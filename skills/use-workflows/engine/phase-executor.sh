#!/usr/bin/env bash

# Phase executor with mode resolution

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/workflow-loader.sh"
source "${SCRIPT_DIR}/context-manager.sh"
source "${SCRIPT_DIR}/script-interpreter.sh"
source "${SCRIPT_DIR}/subagent-pool.sh"

# ============================================================================
# Main Phase Executor
# ============================================================================

execute_phase() {
  local workflow_json=$1
  local phase=$2
  local context_json=$3

  local phase_id=$(get_phase_id "$phase")
  local phase_name=$(get_phase_name "$phase")

  log_info "Executing phase: $phase_name ($phase_id)"

  # Resolve effective execution mode (phase override || workflow default)
  local effective_mode=$(get_phase_mode "$workflow_json" "$phase")
  log_info "Phase mode: $effective_mode"

  # Dispatch to mode-specific executor
  case "$effective_mode" in
    strict)
      execute_phase_strict "$phase" "$context_json"
      ;;
    loose)
      execute_phase_loose "$phase" "$context_json"
      ;;
    adaptive)
      execute_phase_adaptive "$phase" "$context_json"
      ;;
    *)
      handle_error "Unknown execution mode: $effective_mode"
      ;;
  esac
}

# ============================================================================
# Strict Mode Executor
# ============================================================================

execute_phase_strict() {
  local phase=$1
  local context_json=$2

  local phase_id=$(echo "$phase" | jq -r '.id')
  local behavior=$(echo "$phase" | jq -r '.behavior')

  log_debug "Strict mode: behavior=$behavior"

  case "$behavior" in
    main-only)
      execute_main_agent_only "$phase" "$context_json"
      ;;
    parallel|sequential)
      local subagents=$(echo "$phase" | jq -c '.subagents')
      local phase_json=$(echo "$phase" | jq -c '.')
      run_subagent_batch "$subagents" "$behavior" "$context_json" "$phase_json"

      # Execute main agent if defined
      if echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
        execute_main_agent_script "$phase" "$context_json"
      fi
      ;;
    *)
      handle_error "Unknown behavior: $behavior"
      ;;
  esac
}

# ============================================================================
# Loose Mode Executor
# ============================================================================

execute_phase_loose() {
  local phase=$1
  local context_json=$2

  local phase_id=$(echo "$phase" | jq -r '.id')

  log_debug "Loose mode: main agent has full control"

  # Log suggested subagents (informational only)
  if echo "$phase" | jq -e '.suggested_subagents' > /dev/null 2>&1; then
    local suggested=$(echo "$phase" | jq -c '.suggested_subagents[] | .type' | tr '\n' ' ')
    log_info "Suggested subagents (informational): $suggested"
  fi

  # Execute main agent script
  if ! echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
    handle_error "Loose mode requires main_agent.script"
  fi

  execute_main_agent_script "$phase" "$context_json"
}

# ============================================================================
# Adaptive Mode Executor
# ============================================================================

execute_phase_adaptive() {
  local phase=$1
  local context_json=$2

  local phase_id=$(echo "$phase" | jq -r '.id')
  local behavior=$(echo "$phase" | jq -r '.behavior')

  log_debug "Adaptive mode: behavior=$behavior"

  # Step 1: Spawn always subagents
  if echo "$phase" | jq -e '.subagents.always' > /dev/null 2>&1; then
    local always=$(echo "$phase" | jq -c '.subagents.always')
    local phase_json=$(echo "$phase" | jq -c '.')
    log_info "Spawning always subagents"
    run_subagent_batch "$always" "$behavior" "$context_json" "$phase_json"
  fi

  # Step 2: Execute adaptive script and get additional subagents
  if echo "$phase" | jq -e '.subagents.adaptive.script' > /dev/null 2>&1; then
    local adaptive_script=$(echo "$phase" | jq -r '.subagents.adaptive.script')
    local phase_json=$(echo "$phase" | jq -c '.')
    log_info "Executing adaptive script"

    local additional=$(execute_script "$adaptive_script" "$context_json" 30000 "$phase_json")

    # Parse and spawn additional subagents
    if [ -n "$additional" ] && [ "$additional" != "null" ]; then
      local agent_count=$(echo "$additional" | jq 'length')
      if [ "$agent_count" -gt 0 ]; then
        log_info "Spawning $agent_count additional subagents"
        run_subagent_batch "$additional" "$behavior" "$context_json" "$phase_json"
      fi
    fi
  fi

  # Step 3: Execute main agent if defined
  if echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
    execute_main_agent_script "$phase" "$context_json"
  fi
}

# ============================================================================
# Helper Functions
# ============================================================================

execute_main_agent_only() {
  local phase=$1
  local context_json=$2

  if ! echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
    handle_error "main-only behavior requires main_agent.script"
  fi

  execute_main_agent_script "$phase" "$context_json"
}

execute_main_agent_script() {
  local phase=$1
  local context_json=$2

  local phase_id=$(echo "$phase" | jq -r '.id')
  local script=$(echo "$phase" | jq -r '.main_agent.script')
  local phase_json=$(echo "$phase" | jq -c '.')

  log_info "Executing main agent script"
  log_debug "Script: ${script:0:50}..."

  local result=$(execute_script "$script" "$context_json" 30000 "$phase_json")

  if [ $? -ne 0 ]; then
    log_error "Main agent script failed"
    return 1
  fi

  log_debug "Main agent result: ${result:0:100}..."
}

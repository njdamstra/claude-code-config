#!/usr/bin/env bash

# Skills invoker for phase-level skill integration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/context-manager.sh"
source "${SCRIPT_DIR}/script-interpreter.sh"

# ============================================================================
# Main Entry Point
# ============================================================================

invoke_phase_skills() {
  local phase=$1
  local context_json=$2

  # Check if skills defined
  if ! echo "$phase" | jq -e '.skills' > /dev/null 2>&1; then
    log_debug "No skills defined for phase"
    return 0
  fi

  local skills=$(echo "$phase" | jq -c '.skills')
  local skill_count=$(echo "$skills" | jq 'length')

  if [ "$skill_count" -eq 0 ]; then
    log_debug "Empty skills array"
    return 0
  fi

  log_info "Invoking $skill_count skill(s) for phase"

  local index=0
  while [ $index -lt $skill_count ]; do
    local skill=$(echo "$skills" | jq ".[$index]")
    invoke_skill "$skill" "$context_json"
    index=$((index + 1))
  done

  log_info "All skills invoked"
}

# ============================================================================
# Single Skill Invocation
# ============================================================================

invoke_skill() {
  local skill_config=$1
  local context_json=$2

  local skill_name=$(echo "$skill_config" | jq -r '.name')

  # Evaluate condition if defined
  if echo "$skill_config" | jq -e '.condition' > /dev/null 2>&1; then
    local condition=$(echo "$skill_config" | jq -r '.condition')
    log_debug "Evaluating skill condition: $condition"

    local should_invoke=$(evaluate_skill_condition "$condition" "$context_json")
    if [ "$should_invoke" != "true" ]; then
      log_info "Skill condition false, skipping: $skill_name"
      return 0
    fi
  fi

  # Build args array
  local args=()
  if echo "$skill_config" | jq -e '.args' > /dev/null 2>&1; then
    local args_json=$(echo "$skill_config" | jq -c '.args')
    local args_count=$(echo "$args_json" | jq 'length')
    local arg_index=0

    while [ $arg_index -lt $args_count ]; do
      local arg=$(echo "$args_json" | jq -r ".[$arg_index]")
      # Substitute template variables
      arg=$(substitute_template_vars "$arg" "$context_json")
      args+=("$arg")
      arg_index=$((arg_index + 1))
    done
  fi

  # Log invocation
  log_info "Invoking skill: $skill_name"
  if [ ${#args[@]} -gt 0 ]; then
    log_debug "Args: ${args[*]}"
  fi

  # MVP: Just log (Real: Skill tool invocation)
  log_info "[MVP] Skill invocation logged (production would call Skill tool)"
  log_debug "Would execute: Skill tool with command='$skill_name' args='${args[*]}'"

  # Track in context metadata (future enhancement)
  # For now, just log
}

# ============================================================================
# Condition Evaluation
# ============================================================================

evaluate_skill_condition() {
  local condition=$1
  local context_json=$2

  log_debug "Evaluating: $condition"

  # Wrap condition in script
  local script="return ($condition);"

  local result=$(execute_script "$script" "$context_json" 5000)

  if [ $? -ne 0 ]; then
    log_error "Skill condition evaluation failed"
    echo "false"
    return 0
  fi

  # Parse boolean result
  if echo "$result" | jq -e '. == true' > /dev/null 2>&1; then
    echo "true"
  else
    echo "false"
  fi
}

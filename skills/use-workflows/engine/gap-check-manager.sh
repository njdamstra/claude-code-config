#!/usr/bin/env bash

# Gap check manager for quality validation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/context-manager.sh"
source "${SCRIPT_DIR}/script-interpreter.sh"
source "${SCRIPT_DIR}/subagent-pool.sh"

# ============================================================================
# Main Gap Check Handler
# ============================================================================

execute_gap_check() {
  local phase=$1
  local context_json=$2

  # Check if gap check exists and is enabled
  if ! echo "$phase" | jq -e '.gap_check.enabled == true' > /dev/null 2>&1; then
    log_debug "Gap check disabled or not defined"
    echo "CONTINUE"
    return 0
  fi

  local gap_check=$(echo "$phase" | jq -c '.gap_check')
  local phase_id=$(echo "$phase" | jq -r '.id')
  local phase_json=$(echo "$phase" | jq -c '.')

  # Check iteration limit
  local max_iterations=$(echo "$gap_check" | jq -r '.max_iterations // 3')
  local current_iteration=$(phase_get_iteration_count "$phase_id")

  if [ "$current_iteration" -ge "$max_iterations" ]; then
    log_warning "Phase $phase_id reached max iterations ($max_iterations)"
    escalate_gap_check "Max iterations reached" "$context_json"
    return $?
  fi

  # Script-based gap check
  if echo "$gap_check" | jq -e '.script' > /dev/null 2>&1; then
    execute_gap_check_script "$gap_check" "$phase_id" "$context_json" "$phase_json"
    return $?
  fi

  # Criteria-based gap check
  if echo "$gap_check" | jq -e '.criteria' > /dev/null 2>&1; then
    execute_gap_check_criteria "$gap_check" "$phase_id" "$context_json" "$phase_json"
    return $?
  fi

  log_warning "Gap check enabled but no script or criteria defined"
  echo "CONTINUE"
  return 0
}

# ============================================================================
# Script-Based Gap Check
# ============================================================================

execute_gap_check_script() {
  local gap_check=$1
  local phase_id=$2
  local context_json=$3
  local phase_json=${4:-"null"}

  local script=$(echo "$gap_check" | jq -r '.script')

  log_info "Executing gap check script for phase: $phase_id"

  local result=$(execute_script "$script" "$context_json" 30000 "$phase_json")

  if [ $? -ne 0 ]; then
    log_error "Gap check script execution failed"
    echo "CONTINUE"
    return 0
  fi

  # Parse result
  local status=$(echo "$result" | jq -r '.status')

  if [ "$status" = "complete" ]; then
    log_info "Gap check passed: no gaps found"
    record_gap_check "$phase_id" "complete" "[]" "" "[]"
    echo "CONTINUE"
    return 0
  fi

  # Incomplete - handle failure
  log_warning "Gap check found issues"
  handle_gap_check_failure "$result" "$gap_check" "$phase_id" "$context_json"
}

# ============================================================================
# Criteria-Based Gap Check
# ============================================================================

execute_gap_check_criteria() {
  local gap_check=$1
  local phase_id=$2
  local context_json=$3
  local phase_json=${4:-"null"}

  local criteria=$(echo "$gap_check" | jq -c '.criteria')
  local criteria_count=$(echo "$criteria" | jq 'length')

  log_info "Evaluating $criteria_count gap check criteria for phase: $phase_id"

  local failures=()
  local index=0

  while [ $index -lt $criteria_count ]; do
    local criterion=$(echo "$criteria" | jq ".[$index]")
    local name=$(echo "$criterion" | jq -r '.name')
    local check=$(echo "$criterion" | jq -r '.check')

    log_debug "Evaluating criterion: $name"

    # Evaluate check expression
    local script="return ($check);"
    local pass=$(execute_script "$script" "$context_json" 5000 "$phase_json")

    if [ $? -ne 0 ]; then
      log_warning "Criterion evaluation failed: $name"
      failures+=("$name (evaluation error)")
    elif echo "$pass" | jq -e '. == true' > /dev/null 2>&1; then
      log_debug "Criterion passed: $name"
    else
      log_warning "Criterion failed: $name"
      failures+=("$name")
    fi

    index=$((index + 1))
  done

  # Check results
  if [ ${#failures[@]} -eq 0 ]; then
    log_info "All $criteria_count criteria passed"
    record_gap_check "$phase_id" "complete" "[]" "" "[]"
    echo "CONTINUE"
    return 0
  fi

  # Build failures JSON
  local failures_json=$(printf '%s\n' "${failures[@]}" | jq -R . | jq -s .)

  log_warning "${#failures[@]} criteria failed"

  # Build result object
  local result=$(jq -n \
    --argjson gaps "$failures_json" \
    '{
      status: "incomplete",
      gaps: $gaps,
      action: "retry",
      message: "Quality criteria not met"
    }')

  # Handle on_failure action if defined
  if echo "$gap_check" | jq -e '.on_failure.action' > /dev/null 2>&1; then
    local action=$(echo "$gap_check" | jq -r '.on_failure.action')
    result=$(echo "$result" | jq --arg action "$action" '.action = $action')
  fi

  handle_gap_check_failure "$result" "$gap_check" "$phase_id" "$context_json"
}

# ============================================================================
# Failure Handling
# ============================================================================

handle_gap_check_failure() {
  local result=$1
  local gap_check=$2
  local phase_id=$3
  local context_json=$4

  local gaps=$(echo "$result" | jq -c '.gaps')
  local action=$(echo "$result" | jq -r '.action')
  local message=$(echo "$result" | jq -r '.message // "Gaps detected"')

  log_warning "Gap check failure: $message"
  echo "$gaps" | jq -r '.[]' | while read -r gap; do
    log_info "  - $gap"
  done

  case "$action" in
    retry)
      local current_iteration=$(phase_get_iteration_count "$phase_id")
      local max_iterations=$(echo "$gap_check" | jq -r '.max_iterations // 3')

      if [ "$current_iteration" -ge "$max_iterations" ]; then
        log_warning "Max iterations reached, escalating"
        escalate_gap_check "$message" "$context_json"
        return $?
      fi

      phase_increment_iteration "$phase_id"
      record_gap_check "$phase_id" "incomplete" "$gaps" "retry" "[]"

      log_info "Retrying phase: $phase_id (iteration $((current_iteration + 1)))"
      echo "RETRY_PHASE"
      ;;

    spawn_additional)
      local additional_agents=$(echo "$result" | jq -c '.additionalAgents // []')
      local agent_count=$(echo "$additional_agents" | jq 'length')

      if [ "$agent_count" -gt 0 ]; then
        log_info "Spawning $agent_count additional agents to address gaps"

        # Extract agent types for logging
        local agent_types=$(echo "$additional_agents" | jq -r '.[].type' | jq -R . | jq -s .)

        # Need phase_json for subagent spawning - reconstruct or pass through
        run_subagent_batch "$additional_agents" "parallel" "$context_json" "null"

        record_gap_check "$phase_id" "incomplete" "$gaps" "spawn_additional" "$agent_types"
      else
        record_gap_check "$phase_id" "incomplete" "$gaps" "spawn_additional" "[]"
      fi

      echo "CONTINUE"
      ;;

    escalate)
      escalate_gap_check "$message" "$context_json"
      ;;

    abort)
      log_error "Gap check abort: $message"
      record_gap_check "$phase_id" "incomplete" "$gaps" "abort" "[]"
      exit 1
      ;;

    *)
      log_error "Unknown gap check action: $action"
      echo "CONTINUE"
      ;;
  esac
}

# ============================================================================
# Escalation
# ============================================================================

escalate_gap_check() {
  local message=$1
  local context_json=$2

  log_warning "═══════════════════════════════════════"
  log_warning "GAP CHECK ESCALATION"
  log_warning "Issue: $message"
  log_warning "═══════════════════════════════════════"

  # MVP: Auto-continue
  log_info "[MVP] Auto-continuing (user decision required in production)"
  log_info "Options would be:"
  log_info "  1. Continue anyway"
  log_info "  2. Retry phase"
  log_info "  3. Abort workflow"

  echo "CONTINUE"
  return 0
}

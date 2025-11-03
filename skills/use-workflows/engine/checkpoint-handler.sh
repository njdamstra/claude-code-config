#!/usr/bin/env bash

# Checkpoint handler for human-in-loop decision points

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/context-manager.sh"
source "${SCRIPT_DIR}/script-interpreter.sh"

# ============================================================================
# Main Checkpoint Handler
# ============================================================================

handle_checkpoint() {
  local phase=$1
  local context_json=$2

  # Check if checkpoint exists
  if ! echo "$phase" | jq -e '.checkpoint' > /dev/null 2>&1; then
    log_debug "No checkpoint defined for phase"
    echo "CONTINUE"
    return 0
  fi

  local checkpoint=$(echo "$phase" | jq -c '.checkpoint')
  local phase_id=$(echo "$phase" | jq -r '.id')

  # Simple approval checkpoint
  if echo "$checkpoint" | jq -e '.approval_required == true' > /dev/null 2>&1; then
    if ! echo "$checkpoint" | jq -e '.prompt' > /dev/null 2>&1; then
      handle_simple_approval "$phase_id"
      return $?
    fi
  fi

  # Custom checkpoint
  handle_custom_checkpoint "$checkpoint" "$phase_id" "$context_json"
}

# ============================================================================
# Simple Approval
# ============================================================================

handle_simple_approval() {
  local phase_id=$1

  log_info "═══════════════════════════════════════"
  log_info "CHECKPOINT: Continue with workflow?"
  log_info "Phase: $phase_id"
  log_info "═══════════════════════════════════════"

  # MVP: Auto-continue
  log_info "[MVP] Auto-continuing (user approval required in production)"
  record_checkpoint "$phase_id" "continue" "" "[]"

  echo "CONTINUE"
  return 0
}

# ============================================================================
# Custom Checkpoint
# ============================================================================

handle_custom_checkpoint() {
  local checkpoint=$1
  local phase_id=$2
  local context_json=$3

  # Evaluate condition if defined
  if echo "$checkpoint" | jq -e '.condition' > /dev/null 2>&1; then
    local condition=$(echo "$checkpoint" | jq -r '.condition')
    log_debug "Evaluating checkpoint condition: $condition"

    local should_show=$(evaluate_checkpoint_condition "$condition" "$context_json")
    if [ "$should_show" != "true" ]; then
      log_debug "Checkpoint condition false, skipping"
      echo "CONTINUE"
      return 0
    fi
  fi

  # Display checkpoint prompt
  local prompt=$(echo "$checkpoint" | jq -r '.prompt')
  log_info "═══════════════════════════════════════"
  log_info "CHECKPOINT: $prompt"
  log_info "Phase: $phase_id"
  log_info "═══════════════════════════════════════"

  # Show files if specified
  if echo "$checkpoint" | jq -e '.show_files' > /dev/null 2>&1; then
    log_info ""
    log_info "Review files:"
    echo "$checkpoint" | jq -r '.show_files[]' | while read -r file_pattern; do
      local resolved=$(substitute_template_vars "$file_pattern" "$context_json")
      log_info "  - $resolved"
    done
  fi

  # Present options
  log_info ""
  log_info "Options:"
  local options=$(echo "$checkpoint" | jq -c '.options')
  local option_count=$(echo "$options" | jq 'length')
  local option_index=0

  while [ $option_index -lt $option_count ]; do
    local option=$(echo "$options" | jq ".[$option_index]")
    local label=$(echo "$option" | jq -r '.label')
    log_info "  $((option_index + 1)). $label"
    option_index=$((option_index + 1))
  done

  # MVP: Auto-select first option (Continue)
  log_info ""
  log_info "[MVP] Auto-selecting option 1 (user choice required in production)"
  local selected_option=$(echo "$options" | jq '.[0]')
  local selected_label=$(echo "$selected_option" | jq -r '.label')
  log_info "Selected: $selected_label"

  # Collect feedback if required
  local feedback=""
  if echo "$selected_option" | jq -e '.with_feedback == true' > /dev/null 2>&1; then
    feedback="[MVP] Mock user feedback"
    log_debug "Feedback: $feedback"
  fi

  # Execute action
  local on_select=$(echo "$selected_option" | jq -c '.on_select')
  execute_checkpoint_action "$on_select" "$phase_id" "$feedback" "$context_json"
}

# ============================================================================
# Action Execution
# ============================================================================

execute_checkpoint_action() {
  local on_select=$1
  local phase_id=$2
  local feedback=$3
  local context_json=$4

  local action=$(echo "$on_select" | jq -r '.action')

  case "$action" in
    continue)
      record_checkpoint "$phase_id" "continue" "$feedback" "[]"
      echo "CONTINUE"
      ;;

    repeat_phase)
      local target=$(echo "$on_select" | jq -r '.target // "current"')
      if [ "$target" = "current" ]; then
        target="$phase_id"
      fi

      phase_increment_iteration "$target"
      record_checkpoint "$phase_id" "repeat_phase" "$feedback" "[]"

      log_info "Repeating phase: $target"
      echo "REPEAT_PHASE:$target"
      ;;

    skip_phases)
      local phases_json=$(echo "$on_select" | jq -c '.phases')
      add_skip_phases "$phases_json"

      local phases_array=$(echo "$phases_json" | jq -r '.[]' | tr '\n' ' ')
      log_info "Skipping phases: $phases_array"

      record_checkpoint "$phase_id" "skip_phases" "$feedback" "$phases_json"
      echo "CONTINUE"
      ;;

    abort)
      log_warning "Workflow aborted by user at checkpoint"
      record_checkpoint "$phase_id" "abort" "$feedback" "[]"
      echo "ABORT"
      ;;

    *)
      log_error "Unknown checkpoint action: $action"
      echo "ABORT"
      ;;
  esac
}

# ============================================================================
# Condition Evaluation
# ============================================================================

evaluate_checkpoint_condition() {
  local condition=$1
  local context_json=$2

  log_debug "Evaluating: $condition"

  # Wrap condition in script
  local script="return ($condition);"

  local result=$(execute_script "$script" "$context_json" 5000)

  if [ $? -ne 0 ]; then
    log_error "Checkpoint condition evaluation failed"
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

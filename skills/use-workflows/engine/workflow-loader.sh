#!/usr/bin/env bash

# Workflow YAML loader and validator

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# ============================================================================
# Main Functions
# ============================================================================

load_workflow() {
  local path=$1

  if [ ! -f "$path" ]; then
    log_error "Workflow file not found: $path"
    return 1
  fi

  log_info "Loading workflow: $path"

  local workflow_json=$(yaml_parse "$path")

  if ! validate_workflow "$workflow_json"; then
    log_error "Workflow validation failed"
    return 1
  fi

  echo "$workflow_json"
}

validate_workflow() {
  local json=$1

  # Check required fields
  local required=("name" "description" "execution_mode" "phases" "finalization")
  for field in "${required[@]}"; do
    if ! echo "$json" | jq -e ".$field" > /dev/null 2>&1; then
      log_error "Missing required field: $field"
      return 1
    fi
  done

  # Validate execution_mode
  local mode=$(echo "$json" | jq -r '.execution_mode')
  if [[ ! "$mode" =~ ^(strict|loose|adaptive)$ ]]; then
    log_error "Invalid execution_mode: $mode"
    return 1
  fi

  # Validate phases array
  local phase_count=$(get_phase_count "$json")
  if [ "$phase_count" -eq 0 ]; then
    log_error "No phases defined"
    return 1
  fi

  # Validate each phase
  local phase_index=0
  while [ $phase_index -lt $phase_count ]; do
    local phase=$(get_phase_by_index "$json" "$phase_index")
    if ! validate_phase "$phase" "$mode"; then
      return 1
    fi
    phase_index=$((phase_index + 1))
  done

  # Validate finalization
  if ! echo "$json" | jq -e '.finalization.template' > /dev/null 2>&1; then
    log_error "Missing finalization.template"
    return 1
  fi

  if ! echo "$json" | jq -e '.finalization.output' > /dev/null 2>&1; then
    log_error "Missing finalization.output"
    return 1
  fi

  log_debug "Workflow validation passed"
  return 0
}

validate_phase() {
  local phase=$1
  local workflow_mode=$2

  # Required fields
  local required=("id" "name" "description" "behavior")
  for field in "${required[@]}"; do
    if ! echo "$phase" | jq -e ".$field" > /dev/null 2>&1; then
      local phase_id=$(echo "$phase" | jq -r '.id // "unknown"')
      log_error "Phase $phase_id missing field: $field"
      return 1
    fi
  done

  local phase_id=$(echo "$phase" | jq -r '.id')
  local behavior=$(echo "$phase" | jq -r '.behavior')

  # Validate behavior
  if [[ ! "$behavior" =~ ^(parallel|sequential|main-only)$ ]]; then
    log_error "Phase $phase_id has invalid behavior: $behavior"
    return 1
  fi

  # Resolve effective mode
  local phase_mode=$(echo "$phase" | jq -r '.execution_mode // "null"')
  local effective_mode="$workflow_mode"

  if [ "$phase_mode" != "null" ]; then
    if [[ ! "$phase_mode" =~ ^(strict|loose|adaptive)$ ]]; then
      log_error "Phase $phase_id has invalid execution_mode: $phase_mode"
      return 1
    fi
    effective_mode="$phase_mode"
    log_debug "Phase $phase_id mode: $effective_mode (override)"
  else
    log_debug "Phase $phase_id mode: $effective_mode (workflow default)"
  fi

  # Mode-specific validation
  case "$effective_mode" in
    strict)
      if [ "$behavior" = "main-only" ]; then
        if ! echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
          log_error "Phase $phase_id (strict main-only) requires main_agent.script"
          return 1
        fi
      else
        if ! echo "$phase" | jq -e '.subagents' > /dev/null 2>&1; then
          log_error "Phase $phase_id (strict $behavior) requires subagents"
          return 1
        fi
      fi
      ;;

    loose)
      if [ "$behavior" != "main-only" ]; then
        log_error "Phase $phase_id (loose) requires behavior: main-only"
        return 1
      fi
      if ! echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
        log_error "Phase $phase_id (loose) requires main_agent.script"
        return 1
      fi
      ;;

    adaptive)
      if [ "$behavior" = "main-only" ]; then
        log_error "Phase $phase_id (adaptive) cannot use behavior: main-only"
        return 1
      fi
      # Adaptive can have always, adaptive.script, or both
      ;;
  esac

  return 0
}

# ============================================================================
# Query Functions
# ============================================================================

get_phase_count() {
  local json=$1
  echo "$json" | jq '.phases | length'
}

get_phase_by_index() {
  local json=$1
  local index=$2
  echo "$json" | jq ".phases[$index]"
}

get_phase() {
  local json=$1
  local phase_id=$2
  echo "$json" | jq ".phases[] | select(.id == \"$phase_id\")"
}

get_workflow_name() {
  local json=$1
  echo "$json" | jq -r '.name'
}

get_workflow_mode() {
  local json=$1
  echo "$json" | jq -r '.execution_mode'
}

get_workflow_description() {
  local json=$1
  echo "$json" | jq -r '.description'
}

get_phase_mode() {
  local workflow_json=$1
  local phase=$2

  local workflow_mode=$(get_workflow_mode "$workflow_json")
  local phase_mode=$(echo "$phase" | jq -r '.execution_mode // "null"')

  if [ "$phase_mode" != "null" ]; then
    echo "$phase_mode"
  else
    echo "$workflow_mode"
  fi
}

get_phase_id() {
  local phase=$1
  echo "$phase" | jq -r '.id'
}

get_phase_name() {
  local phase=$1
  echo "$phase" | jq -r '.name'
}

get_phase_behavior() {
  local phase=$1
  echo "$phase" | jq -r '.behavior'
}

get_finalization_template() {
  local json=$1
  echo "$json" | jq -r '.finalization.template'
}

get_finalization_output() {
  local json=$1
  echo "$json" | jq -r '.finalization.output'
}

#!/usr/bin/env bash
# Subagent Matcher Library
# Functions to build subagent lists based on scope

set -euo pipefail

# Source constants
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${LIB_DIR}/constants.sh"

# Get all subagents for a specific phase and scope
# Args: workflow_json, phase, scope
# Output: Subagent types, one per line (stdout)
get_phase_subagents() {
  local workflow_json=$1
  local phase=$2
  local scope=$3
  local conditions_json=${4:-'[]'}

  # Get always subagents (use bracket notation for keys with hyphens)
  local always=$(echo "$workflow_json" | \
    jq -r ".subagent_matrix[\"${phase}\"].always[]?" 2>/dev/null || echo "")

  # Get conditional subagents based on scope
  local conditional=""
  if [[ "$scope" != "default" ]]; then
    conditional=$(echo "$workflow_json" | \
      jq -r ".subagent_matrix[\"${phase}\"].conditional[\"${scope}\"][]?" 2>/dev/null || echo "")
  fi

  # Combine base conditional lists
  local combined="$always"$'\n'"$conditional"

  # Add condition-based subagents
  if [[ "$conditions_json" != "[]" && "$conditions_json" != "null" ]]; then
    local condition_count
    condition_count=$(echo "$conditions_json" | jq 'length')
    for ((i=0; i<condition_count; i++)); do
      local key
      key=$(echo "$conditions_json" | jq -r ".[$i].key")
      local value
      value=$(echo "$conditions_json" | jq -r ".[$i].value")
      local condition_key="${key}=${value}"

      local matched
      matched=$(echo "$workflow_json" | jq -r ".subagent_matrix[\"${phase}\"].conditional[\"${condition_key}\"][]?" 2>/dev/null || echo "")

      if [[ -n "$matched" ]]; then
        combined+=$'\n'"$matched"
      fi
    done
  fi

  echo "$combined" | tr ' ' '\n' | grep -v "^$" | sort -u
}

# Build data object for a single subagent
# Args: subagent_type, workflow, feature_name, scope, index, registry_path
# Output: JSON object with subagent data (stdout)
build_subagent_data() {
  local subagent_type=$1
  local workflow=$2
  local feature_name=$3
  local scope=$4
  local index=$5
  local registry_path=$6

  # Load subagent registry
  if [[ ! -f "$registry_path" ]]; then
    echo "Error: Registry not found: $registry_path" >&2
    return 1
  fi

  local registry_json=$(yq eval -o=json "$registry_path" 2>/dev/null)

  local task_agent_type=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".task_agent_type // \"${DEFAULT_TASK_AGENT_TYPE}\"")
  local thoroughness=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".thoroughness // \"${DEFAULT_THOROUGHNESS}\"")
  local description=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".description // \"${DEFAULT_DESCRIPTION}\"")
  local deliverable=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".deliverable // \"${DEFAULT_DELIVERABLE}\"")

  # Extract filename from path
  local deliverable_filename=$(basename "$deliverable")

  # Build JSON object
  local template_path=$(printf "$SUBAGENT_TEMPLATE_PATTERN" "$subagent_type" "$workflow")

  jq -n \
    --arg index "$index" \
    --arg name "$subagent_type" \
    --arg type "$subagent_type" \
    --arg task_agent_type "$task_agent_type" \
    --arg thoroughness "$thoroughness" \
    --arg task_description "$description" \
    --arg deliverable_filename "$deliverable_filename" \
    --arg deliverable_path "$deliverable" \
    --arg template_path "$template_path" \
    '{
      index: ($index | tonumber),
      name: $name,
      type: $type,
      task_agent_type: $task_agent_type,
      thoroughness: $thoroughness,
      task_description: $task_description,
      description: $task_description,
      template_path: $template_path,
      deliverable_filename: $deliverable_filename,
      deliverable_path: $deliverable_path
    }'
}

# Build array of subagent data objects
# Args: subagent_types (space-separated string), workflow, feature_name, scope, registry_path
# Output: JSON array of subagent data objects
build_all_subagents_data() {
  local subagent_types_str=$1
  local workflow=$2
  local feature_name=$3
  local scope=$4
  local registry_path=$5

  # Convert space-separated string to array
  read -ra subagent_types <<< "$subagent_types_str"

  local index=1
  local subagents_json="["

  for subagent_type in "${subagent_types[@]}"; do
    if [[ $index -gt 1 ]]; then
      subagents_json+=","
    fi

    local subagent_data=$(build_subagent_data \
      "$subagent_type" "$workflow" "$feature_name" "$scope" "$index" "$registry_path")

    subagents_json+="$subagent_data"
    ((index++))
  done

  subagents_json+="]"

  echo "$subagents_json"
}

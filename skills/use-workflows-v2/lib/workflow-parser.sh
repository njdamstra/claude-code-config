#!/usr/bin/env bash
# Workflow Parser Library
# Functions to load and parse workflow YAML files

set -euo pipefail

# Load workflow YAML and convert to JSON
# Args: workflow_path
# Output: JSON representation (stdout)
# Returns: 0 on success, 1 on failure
load_workflow() {
  local workflow_path=$1

  # Validate file exists
  if [[ ! -f "$workflow_path" ]]; then
    echo "Error: Workflow file not found: $workflow_path" >&2
    return 1
  fi

  # Parse YAML to JSON using yq
  local workflow_json=$(yq eval -o=json "$workflow_path" 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    echo "Error: Invalid YAML in $workflow_path" >&2
    return 1
  fi

  echo "$workflow_json"
}

# Extract specific field from workflow JSON
# Args: workflow_json, field
# Output: Field value (stdout)
get_workflow_field() {
  local workflow_json=$1
  local field=$2

  echo "$workflow_json" | jq -r ".${field}"
}

# Extract phases array
# Args: workflow_json
# Output: Phase IDs, one per line (stdout)
get_phases() {
  local workflow_json=$1

  echo "$workflow_json" | jq -r '.phases[]'
}

# Extract complete subagent matrix as JSON
# Args: workflow_json
# Output: Subagent matrix JSON (stdout)
get_subagent_matrix() {
  local workflow_json=$1

  echo "$workflow_json" | jq '.subagent_matrix'
}

# Extract gap checks configuration
# Args: workflow_json
# Output: Gap checks JSON (stdout)
get_gap_checks() {
  local workflow_json=$1

  echo "$workflow_json" | jq '.gap_checks'
}

# Extract checkpoints array
# Args: workflow_json
# Output: Checkpoints JSON (stdout)
get_checkpoints() {
  local workflow_json=$1

  echo "$workflow_json" | jq '.checkpoints'
}

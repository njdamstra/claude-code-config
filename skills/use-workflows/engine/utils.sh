#!/usr/bin/env bash

# Core utilities for workflow engine

set -euo pipefail

# ============================================================================
# Logging
# ============================================================================

log_info() {
  echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] INFO: $*" >&2
}

log_error() {
  echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] ERROR: $*" >&2
}

log_debug() {
  if [ "${DEBUG:-0}" = "1" ]; then
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] DEBUG: $*" >&2
  fi
}

log_warning() {
  echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] WARNING: $*" >&2
}

# ============================================================================
# File Operations
# ============================================================================

ensure_dir() {
  local dir=$1
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    log_debug "Created directory: $dir"
  fi
}

read_file() {
  local file=$1
  if [ ! -f "$file" ]; then
    log_error "File not found: $file"
    return 1
  fi
  cat "$file"
}

write_file() {
  local file=$1
  local content=$2
  local dir=$(dirname "$file")

  ensure_dir "$dir"
  echo "$content" > "$file"
  log_debug "Wrote file: $file"
}

# ============================================================================
# JSON/YAML Helpers
# ============================================================================

json_get() {
  local json=$1
  local path=$2
  echo "$json" | jq -r "$path"
}

json_set() {
  local json=$1
  local path=$2
  local value=$3
  echo "$json" | jq "$path = $value"
}

yaml_parse() {
  local file=$1
  if [ ! -f "$file" ]; then
    log_error "YAML file not found: $file"
    return 1
  fi
  yq eval -o=json "$file"
}

yaml_get() {
  local file=$1
  local path=$2
  yq eval "$path" "$file"
}

# ============================================================================
# Template Variable Substitution
# ============================================================================

substitute_template_vars() {
  local template=$1
  local context_json=$2

  # Extract common variables from context
  local feature_name=$(echo "$context_json" | jq -r '.feature.name')
  local workflow_name=$(echo "$context_json" | jq -r '.workflow.name')
  local output_dir=".temp/${feature_name}"

  # Substitute variables
  local result="$template"
  result="${result//\{\{output_dir\}\}/$output_dir}"
  result="${result//\{\{feature_name\}\}/$feature_name}"
  result="${result//\{\{workflow_name\}\}/$workflow_name}"

  echo "$result"
}

# ============================================================================
# Context Helpers
# ============================================================================

# Initialize and export CONTEXT_FILE only if not already set (prevents overwriting when sourced multiple times)
if [ -z "${CONTEXT_FILE+x}" ]; then
  export CONTEXT_FILE=""
fi

context_init() {
  local feature_name=$1
  local workflow_name=$2
  local execution_mode=$3
  shift 3
  local flags=("$@")

  local temp_dir=".temp/${feature_name}"
  ensure_dir "$temp_dir"

  export CONTEXT_FILE="${temp_dir}/context.json"

  # Handle empty flags array
  local flags_json
  if [ ${#flags[@]} -eq 0 ]; then
    flags_json="[]"
  else
    flags_json=$(printf '%s\n' "${flags[@]}" | jq -R . | jq -s .)
  fi

  local context=$(jq -n \
    --arg feature "$feature_name" \
    --arg workflow "$workflow_name" \
    --arg mode "$execution_mode" \
    --arg started "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    --argjson flags "$flags_json" \
    '{
      workflow: {
        name: $workflow,
        started_at: $started,
        execution_mode: $mode
      },
      feature: {
        name: $feature,
        flags: $flags
      },
      phases: {
        current: null,
        completed: [],
        iteration_counts: {}
      },
      subagents_spawned: 0,
      deliverables: [],
      checkpoints: [],
      skip_phases: [],
      gap_checks: []
    }')

  echo "$context" > "$CONTEXT_FILE"
  log_info "Initialized context: $CONTEXT_FILE"
  echo "$temp_dir"
}

context_update() {
  local path=$1
  local value=$2

  if [ -z "$CONTEXT_FILE" ] || [ ! -f "$CONTEXT_FILE" ]; then
    log_warning "Context not initialized, skipping update"
    return 0  # Return success to avoid breaking set -e
  fi

  local context=$(cat "$CONTEXT_FILE")
  context=$(echo "$context" | jq "$path = $value")
  echo "$context" > "$CONTEXT_FILE"
  log_debug "Updated context: $path"
}

context_read() {
  local path=$1

  if [ -z "$CONTEXT_FILE" ] || [ ! -f "$CONTEXT_FILE" ]; then
    log_warning "Context not initialized, returning null"
    echo "null"
    return 0  # Return success to avoid breaking set -e
  fi

  cat "$CONTEXT_FILE" | jq -r "$path"
}

context_get() {
  if [ -z "$CONTEXT_FILE" ] || [ ! -f "$CONTEXT_FILE" ]; then
    log_warning "Context not initialized, returning empty object"
    echo "{}"
    return 0  # Return success to avoid breaking set -e
  fi
  cat "$CONTEXT_FILE"
}

context_set() {
  local context=$1
  if [ -z "$CONTEXT_FILE" ]; then
    log_warning "Context not initialized, skipping set"
    return 0  # Return success to avoid breaking set -e
  fi
  echo "$context" > "$CONTEXT_FILE"
}

# ============================================================================
# Error Handling
# ============================================================================

handle_error() {
  local message=$1
  local exit_code=${2:-1}
  log_error "$message"
  exit "$exit_code"
}

# ============================================================================
# Template Substitution
# ============================================================================

substitute_vars() {
  local template=$1
  local context_json=$2

  local result="$template"

  # Extract all keys from context JSON
  local keys=$(echo "$context_json" | jq -r 'paths(scalars) as $p | $p | join(".")')

  while IFS= read -r key; do
    local value=$(echo "$context_json" | jq -r ".${key}")
    # Replace {{key}} with value
    result="${result//\{\{${key}\}\}/$value}"
  done <<< "$keys"

  echo "$result"
}

# ============================================================================
# Utility Functions
# ============================================================================

timestamp_iso8601() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

file_exists() {
  [ -f "$1" ]
}

dir_exists() {
  [ -d "$1" ]
}

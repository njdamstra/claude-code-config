#!/usr/bin/env bash
# Scope Detector Library
# Functions to parse command-line flags and determine scope

set -euo pipefail

# Source constants
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${LIB_DIR}/constants.sh"

# Determine scope from flags array
# Args: flags...
# Output: Scope string: "frontend" | "backend" | "both" | "default"
detect_scope() {
  if [[ $# -eq 0 ]]; then
    echo "$SCOPE_DEFAULT"
    return 0
  fi

  # Check for scope flags
  for flag in "$@"; do
    case "$flag" in
      --both)
        echo "$SCOPE_BOTH"
        return 0
        ;;
      --frontend)
        echo "$SCOPE_FRONTEND"
        return 0
        ;;
      --backend)
        echo "$SCOPE_BACKEND"
        return 0
        ;;
    esac
  done

  # Default scope
  echo "$SCOPE_DEFAULT"
}

# Check if specific flag is present
# Args: flag_name, flags...
# Returns: 0 if found, 1 if not found
has_flag() {
  local flag_name=$1
  shift
  for flag in "$@"; do
    if [[ "$flag" == "$flag_name" ]]; then
      return 0  # Found
    fi
  done

  return 1  # Not found
}

# Extract custom condition flags (--key=value) excluding scope flags
# Args: flags...
# Output: JSON array of {key,value}
extract_conditions() {
  local conditions="[]"

  for flag in "$@"; do
    if [[ "$flag" =~ ^--([a-zA-Z0-9._-]+)=(.+)$ ]]; then
      local key="${BASH_REMATCH[1]}"
      local value="${BASH_REMATCH[2]}"

      case "$key" in
        frontend|backend|both|summary|full|base-dir)
          continue
          ;;
      esac

      conditions=$(echo "$conditions" | jq \
        --arg key "$key" \
        --arg value "$value" \
        '. + [{key: $key, value: $value}]')
    fi
  done

  echo "$conditions"
}

export -f extract_conditions

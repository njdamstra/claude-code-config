#!/usr/bin/env bash
# List all available workflows from all plugin locations
# Shows workflows from: project, user, and built-in directories

set -uo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "${SCRIPT_DIR}/lib/constants.sh"
source "${SCRIPT_DIR}/lib/workflow-helpers.sh"

# ============================================================================
# Main Function
# ============================================================================

usage() {
  cat <<USAGE
Usage: bash list-workflows.sh [options]

Options:
  --help, -h     Show this help message
  --verbose, -v  Show workflow file paths

Description:
  Lists all available workflows from:
    - Project-level: ./.claude/workflows/
    - User-level: ~/.claude/workflows/
    - Built-in: ~/.claude/skills/use-workflows-v2/workflows/

Examples:
  bash list-workflows.sh
  bash list-workflows.sh --verbose
USAGE
}

main() {
  local verbose=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|-h)
        usage
        exit 0
        ;;
      --verbose|-v)
        verbose=true
        shift
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage
        exit 1
        ;;
    esac
  done

  echo "Available workflows:"
  echo ""

  # Use the list_available_workflows function from workflow-helpers.sh
  local workflows=$(list_available_workflows "$SCRIPT_DIR")

  if [[ -z "$workflows" ]]; then
    echo "  No workflows found"
    exit 0
  fi

  # Display workflows
  if [[ "$verbose" == "true" ]]; then
    # Show with full paths
    local project_dir="./.claude/workflows"
    local user_dir="$HOME/.claude/workflows"
    local builtin_dir="${SCRIPT_DIR}/workflows"

    echo "$workflows" | while IFS= read -r line; do
      local name="${line%% *}"
      local source="${line#*[}"
      source="${source%]}"

      case "$source" in
        project)
          echo "  $name [$source] - ${project_dir}/${name}.yaml"
          ;;
        user)
          echo "  $name [$source] - ${user_dir}/${name}.yaml"
          ;;
        built-in)
          echo "  $name [$source] - ${builtin_dir}/${name}.yaml"
          ;;
      esac
    done
  else
    # Simple list
    echo "$workflows" | sed 's/^/  /'
  fi

  echo ""
  echo "Usage: bash generate-workflow-instructions.sh <workflow-name> <feature-name> [options]"
}

main "$@"

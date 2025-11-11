#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Phase Details Fetcher - Progressive Disclosure Implementation
# ============================================================================
# Purpose: Fetch detailed instructions for a specific workflow phase on-demand
# Usage: bash fetch-phase-details.sh <workflow> <phase> <feature-name> [flags...]
#
# This implements progressive disclosure by allowing the main agent to:
# 1. Get workflow summary first (lightweight)
# 2. Fetch phase details only when needed (focused)
# 3. Reduce initial token load by 80%
# ============================================================================

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "${SCRIPT_DIR}/lib/workflow-parser.sh"
source "${SCRIPT_DIR}/lib/scope-detector.sh"
source "${SCRIPT_DIR}/lib/subagent-matcher.sh"
source "${SCRIPT_DIR}/lib/template-renderer.sh"
source "${SCRIPT_DIR}/lib/workflow-helpers.sh"

# ============================================================================
# Helper Functions
# ============================================================================

usage() {
  cat <<USAGE
Usage: bash fetch-phase-details.sh <workflow> <phase-name-or-number> <feature-name> [flags...]

Arguments:
  workflow      Workflow type (investigation-workflow, new-feature-plan, etc.)
  phase         Phase name OR number (1-6, or problem-understanding, codebase-investigation, etc.)
  feature-name  Name of feature/task being planned

Flags:
  --frontend    Include frontend-specific subagents
  --backend     Include backend-specific subagents
  --both        Include both frontend and backend subagents
  --base-dir    Override base directory for outputs (default: ${DEFAULT_BASE_DIR})
  --<key>=<value>  Custom condition flags to trigger conditional subagents (e.g., --complexity=high)

Examples:
  # Using phase name
  bash fetch-phase-details.sh investigation-workflow codebase-investigation user-auth --frontend

  # Using phase number (1-based)
  bash fetch-phase-details.sh investigation-workflow 2 user-auth --frontend

  bash fetch-phase-details.sh new-feature-plan discovery payment-flow --both
  bash fetch-phase-details.sh improving-plan 3 onboarding --base-dir ~/.claude/plans

Output:
  Complete phase instructions for the specified phase written to stdout
USAGE
}

# ============================================================================
# Main Function
# ============================================================================

main() {
  # Parse arguments
  if [[ $# -lt 3 ]]; then
    usage
    exit 1
  fi

  local workflow=$1
  local phase_input=$2
  local feature_name=$3
  shift 3

  # Initialize workflow context (handles parsing, loading, etc.)
  local context_json
  if ! context_json=$(initialize_workflow_context "$workflow" "$SCRIPT_DIR" "$@"); then
    exit 1
  fi

  # Extract context values
  local base_dir=$(echo "$context_json" | jq -r '.base_dir')
  local scope=$(echo "$context_json" | jq -r '.scope')
  local workflow_json=$(echo "$context_json" | jq -c '.workflow_json')
  local conditions_json=$(echo "$context_json" | jq -c '.conditions_json')
  local phases_array=$(echo "$context_json" | jq -r '.phases_array[]')

  # Extract and set workflow directory info for custom template resolution
  export WORKFLOW_DIR=$(echo "$context_json" | jq -r '.workflow_dir')
  export WORKFLOW_SOURCE_TYPE=$(echo "$context_json" | jq -r '.workflow_source_type')
  export WORKFLOW_FILE_PATH=$(echo "$context_json" | jq -r '.workflow_file_path')
  
  # Convert phases array to bash array
  local phases=()
  while IFS= read -r phase; do
    [[ -n "$phase" ]] && phases+=("$phase")
  done <<< "$phases_array"
  
  local phase_count=${#phases[@]}
  local phases_json=$(echo "$context_json" | jq -c '.phases_json')
  
  # Extract flags for phase-specific logic
  local flags_string=$(echo "$context_json" | jq -r '.flags_string')
  local flags=()
  if [[ "$flags_string" != "none" ]]; then
    read -ra flags <<< "$flags_string"
  fi

  # Detect if phase_input is numeric and convert to phase name
  local phase=""
  local phase_number=0
  if [[ "$phase_input" =~ ^[0-9]+$ ]]; then
    # Numeric input - convert to phase name (1-based)
    local phase_num=$phase_input

    # Validate range (1-based)
    if [[ $phase_num -lt 1 || $phase_num -gt $phase_count ]]; then
      echo "Error: Phase number $phase_num is out of range (1-$phase_count)" >&2
      echo "" >&2
      echo "Available phases:" >&2
      for ((i=0; i<phase_count; i++)); do
        echo "  $((i+1)). ${phases[i]}" >&2
      done
      exit 1
    fi

    # Convert to phase name (1-based to 0-based index)
    phase="${phases[$((phase_num-1))]}"
    echo "→ Resolved phase $phase_num to: $phase" >&2
    phase_number=$phase_num
  else
    # String input - use as-is
    phase="$phase_input"
  fi

  # Validate phase exists in workflow
  local phase_found=false
  for ((i=0; i<phase_count; i++)); do
    if [[ "${phases[$i]}" == "$phase" ]]; then
      phase_found=true
      if [[ $phase_number -eq 0 ]]; then
        phase_number=$((i + 1))
      fi
      break
    fi
  done

  if [[ "$phase_found" == "false" ]]; then
    echo "Error: Phase '$phase' not found in workflow '$workflow'" >&2
    echo "" >&2
    echo "Available phases:" >&2
    for ((i=0; i<phase_count; i++)); do
      echo "  $((i+1)). ${phases[i]}" >&2
    done
    exit 1
  fi

  # Scope and conditions already extracted by initialize_workflow_context

  # Build phase data
  local phase_data=$(build_phase_data \
    "$phase" \
    "$phase_number" \
    "$feature_name" \
    "$workflow" \
    "$scope" \
    "$workflow_json" \
    "$phases_json" \
    "$base_dir" \
    "$conditions_json")

  # Resolve phase template (supports workflow-specific overrides)
  local phase_template
  if ! phase_template=$(check_template_override "$workflow" "$phase" "$SCRIPT_DIR"); then
    exit 1
  fi

  # Output rendered phase
  local phase_cap=$(capitalize "$phase")
  local workspace=$(echo "$phase_data" | jq -r '.workspace')
  local output_dir=$(echo "$phase_data" | jq -r '.output_dir')
  echo "# Phase Details: $phase_cap"
  echo ""
  echo "**Workflow:** $workflow"
  echo "**Feature:** $feature_name"
  echo "**Scope:** $scope"
  echo "**Workspace:** ${workspace}/"
  echo "**Phase Directory:** ${workspace}/${output_dir}/"
  echo ""
  echo "---"
  echo ""

  render_template "$phase_template" "$phase_data"
}

# ============================================================================
# Entry Point
# ============================================================================

# Handle --help flag
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

main "$@"

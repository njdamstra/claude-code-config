#!/usr/bin/env bash
# Prompt Generator (v5)
# Generates subagent Task prompts from phase YAML configurations

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==============================================================================
# USAGE
# ==============================================================================

usage() {
  cat <<USAGE
Usage: $0 <phase_yaml> <subagent_name> <feature_name> <scope> <workflow_name> <base_dir> <phase_number> <phase_name> <workflow_yaml>

Arguments:
  phase_yaml     - Path to phase YAML file
  subagent_name  - Name of subagent to generate prompt for
  feature_name   - Feature being worked on
  scope          - Scope (frontend|backend|both)
  workflow_name  - Name of workflow
  base_dir       - Base output directory (.temp, .claude/plans, etc.)
  phase_number   - Phase number (1, 2, 3...)
  phase_name     - Phase name (for directory naming)
  workflow_yaml  - Path to workflow YAML file (for context files)

Example:
  $0 phases/codebase-investigation.yaml code-researcher user-auth frontend investigation-workflow .temp 2 codebase-investigation workflows/investigation-workflow.yaml

USAGE
}

# ==============================================================================
# MAIN FUNCTION
# ==============================================================================

main() {
  local phase_yaml="${1:-}"
  local subagent_name="${2:-}"
  local feature_name="${3:-}"
  local scope="${4:-}"
  local workflow_name="${5:-}"
  local base_dir="${6:-}"
  local phase_number="${7:-}"
  local phase_name="${8:-}"
  local workflow_yaml="${9:-}"

  # Validate arguments
  if [[ -z "$phase_yaml" || -z "$subagent_name" || -z "$feature_name" || -z "$scope" ]]; then
    usage
    exit 1
  fi

  # Check phase YAML exists
  if [[ ! -f "$phase_yaml" ]]; then
    echo "Error: Phase YAML not found: $phase_yaml" >&2
    exit 1
  fi

  # Check workflow YAML exists (optional but recommended)
  if [[ -n "$workflow_yaml" && ! -f "$workflow_yaml" ]]; then
    echo "Warning: Workflow YAML not found: $workflow_yaml" >&2
  fi

  # Build output directory
  local output_dir="$base_dir/$feature_name/phase-$phase_number-$phase_name"

  # Extract subagent configuration
  local config_path=".subagent_configs.\"$subagent_name\""

  local task_agent_type=$(yq eval "$config_path.task_agent_type" "$phase_yaml")
  local responsibility=$(yq eval "$config_path.responsibility" "$phase_yaml")
  local instructions=$(yq eval "$config_path.instructions" "$phase_yaml")
  local scope_guidance=$(yq eval "$config_path.scope_specific.\"$scope\" // \"\"" "$phase_yaml")
  local output_file=$(yq eval "$config_path.outputs[0].file" "$phase_yaml")
  local output_desc=$(yq eval "$config_path.outputs[0].description" "$phase_yaml")

  # Check if config exists
  if [[ "$task_agent_type" == "null" ]]; then
    echo "Error: No configuration found for subagent: $subagent_name" >&2
    exit 1
  fi

  # Generate prompt
  cat <<PROMPT
# Task: $workflow_name - Phase $phase_number: $phase_name

## Your Role: $subagent_name

**Agent Type:** $task_agent_type

## Responsibility

$responsibility

## Scope

**Current Scope:** $scope

PROMPT

  # Add scope-specific guidance if available
  if [[ -n "$scope_guidance" && "$scope_guidance" != "null" ]]; then
    cat <<SCOPE

## Scope-Specific Guidance

$scope_guidance

SCOPE
  fi

  # Add instructions
  cat <<INSTRUCTIONS

## Instructions

$instructions

## Output Requirements

**Output File:** \`$output_dir/$output_file\`
**Description:** $output_desc

INSTRUCTIONS

  # Add context about inputs if available
  local inputs_check=$(yq eval "$config_path.inputs_to_read" "$phase_yaml" 2>/dev/null || echo "null")

  if [[ "$inputs_check" != "null" ]]; then
    echo ""
    echo "## Available Context"
    echo ""

    # Get inputs from workflow if workflow YAML is provided
    local from_workflow=$(yq eval "$config_path.inputs_to_read[0].from_workflow" "$phase_yaml")
    if [[ "$from_workflow" == "true" && -f "$workflow_yaml" ]]; then
      # Read workflow to find inputs for current phase
      local phase_inputs=$(yq eval ".phases[] | select(.name == \"$phase_name\") | .inputs" "$workflow_yaml" 2>/dev/null || echo "[]")

      if [[ "$phase_inputs" != "[]" && "$phase_inputs" != "null" ]]; then
        echo "Read the following files before starting your work:"
        echo ""

        # Get all phases from workflow to map phase names to numbers
        local workflow_json=$(yq eval '.' "$workflow_yaml" -o json)
        local phase_count=$(echo "$workflow_json" | jq '.phases | length')

        # Parse each input
        local input_count=$(echo "$phase_inputs" | yq eval 'length' -)
        for ((j=0; j<input_count; j++)); do
          local from_phase=$(echo "$phase_inputs" | yq eval ".[$j].from" -)
          local files=$(echo "$phase_inputs" | yq eval ".[$j].files[]" -)
          local context_desc=$(echo "$phase_inputs" | yq eval ".[$j].context_description // \"\"" -)

          # Find phase number for from_phase
          local from_phase_number=0
          for ((k=0; k<phase_count; k++)); do
            local name=$(echo "$workflow_json" | jq -r ".phases[$k].name")
            if [[ "$name" == "$from_phase" ]]; then
              from_phase_number=$((k + 1))
              break
            fi
          done

          echo "**From Phase $from_phase_number ($from_phase):**"
          while IFS= read -r file; do
            echo "- \`$base_dir/$feature_name/phase-$from_phase_number-$from_phase/$file\`"
          done <<< "$files"

          if [[ -n "$context_desc" && "$context_desc" != "null" ]]; then
            echo ""
            echo "*Purpose: $context_desc*"
          fi
          echo ""
        done
      else
        echo "**No context files available from previous phases.**"
        echo ""
      fi
    else
      # Fallback if workflow YAML not provided
      echo "Read the following files before starting your work:"
      echo ""
      echo "**Previous phase outputs are available in the workflow configuration.**"
      echo ""
      echo "Context files should be read from:"
      echo "- \`$output_dir/../*/\` (previous phase directories)"
      echo ""
    fi
  fi

  # Add execution notes
  cat <<FOOTER

---

## Important Notes

1. **Read context files first** to understand the problem and constraints
2. **Follow scope-specific guidance** for this $scope context
3. **Output must be valid** according to the schema specified
4. **Provide file:line citations** for all code references
5. **Save output to the exact path specified** above

---

Begin your work now. Report findings in the specified output file.

FOOTER
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

#!/usr/bin/env bash
# Phase Details Fetcher (v5)
# Fetches detailed instructions for a specific phase using progressive disclosure

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/lib/scope-detector.sh"

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Configuration
WORKFLOWS_DIR="$SCRIPT_DIR/workflows"
PHASES_DIR="$SCRIPT_DIR/phases"

# ==============================================================================
# PHASE RENDERING
# ==============================================================================

render_phase_instructions() {
  local workflow_name="$1"
  local phase_identifier="$2"  # Can be number or name
  local feature_name="$3"
  local user_scope="$4"

  # Load workflow
  local workflow_file="$WORKFLOWS_DIR/$workflow_name.yaml"
  if [[ ! -f "$workflow_file" ]]; then
    echo "Error: Workflow not found: $workflow_file" >&2
    exit 1
  fi

  local workflow_json=$(yq eval -o=json '.' "$workflow_file")
  local base_dir=$(echo "$workflow_json" | jq -r '.base_dir')
  local default_scope=$(echo "$workflow_json" | jq -r '.default_scope')

  # Resolve default scope
  if [[ "$default_scope" == "{{user_provided_scope}}" ]]; then
    default_scope="$user_scope"
  fi

  # Find phase by number or name
  local phase_count=$(echo "$workflow_json" | jq '.phases | length')
  local phase_index=-1
  local phase_name=""

  # Check if identifier is a number
  if [[ "$phase_identifier" =~ ^[0-9]+$ ]]; then
    phase_index=$((phase_identifier - 1))
    if [[ $phase_index -ge 0 && $phase_index -lt $phase_count ]]; then
      phase_name=$(echo "$workflow_json" | jq -r ".phases[$phase_index].name")
    fi
  else
    # Search by name
    for ((i=0; i<phase_count; i++)); do
      local name=$(echo "$workflow_json" | jq -r ".phases[$i].name")
      if [[ "$name" == "$phase_identifier" ]]; then
        phase_index=$i
        phase_name="$name"
        break
      fi
    done
  fi

  if [[ $phase_index -eq -1 || -z "$phase_name" ]]; then
    echo "Error: Phase not found: $phase_identifier" >&2
    echo "" >&2
    echo "Available phases:" >&2
    for ((i=0; i<phase_count; i++)); do
      local name=$(echo "$workflow_json" | jq -r ".phases[$i].name")
      echo "  $((i+1)). $name" >&2
    done
    exit 1
  fi

  local phase_number=$((phase_index + 1))
  local phase_scope=$(echo "$workflow_json" | jq -r ".phases[$phase_index].scope")

  # Resolve scope for this phase
  local resolved_scope="$default_scope"
  case "$phase_scope" in
    "default")
      resolved_scope="$default_scope"
      ;;
    "{{workflow_scope}}")
      resolved_scope="$user_scope"
      ;;
    *)
      resolved_scope="$phase_scope"
      ;;
  esac

  # Load phase YAML
  local phase_file="$PHASES_DIR/$phase_name.yaml"
  if [[ ! -f "$phase_file" ]]; then
    echo "Error: Phase file not found: $phase_file" >&2
    exit 1
  fi

  local phase_json=$(yq eval -o=json '.' "$phase_file")
  local phase_purpose=$(echo "$phase_json" | jq -r '.purpose')

  # Build output directory
  local output_dir="$base_dir/$feature_name/phase-$phase_number-$phase_name"

  # Get subagents for this phase
  local always_agents=$(echo "$phase_json" | jq -r '.subagents.always[]? // empty')
  local conditional_agents=$(echo "$phase_json" | jq -r ".subagents.conditional.\"$resolved_scope\"[]? // empty")
  local all_agents=$(echo -e "$always_agents\n$conditional_agents" | grep -v '^$' | sort -u)

  # Get input files for this phase
  local phase_inputs=$(echo "$workflow_json" | jq -r ".phases[$phase_index].inputs")

  # Render phase instructions
  cat <<EOF
# Phase $phase_number: $phase_name

## Purpose

$phase_purpose

**Scope:** $resolved_scope
**Output Directory:** \`$output_dir/\`

---

## Available Context

EOF

  # Render input files
  if [[ "$phase_inputs" != "null" && "$phase_inputs" != "[]" ]]; then
    echo "The following context files are available from previous phases:"
    echo ""

    local input_count=$(echo "$phase_inputs" | jq 'length')
    for ((j=0; j<input_count; j++)); do
      local from_phase=$(echo "$phase_inputs" | jq -r ".[$j].from")
      local files=$(echo "$phase_inputs" | jq -r ".[$j].files[]")
      local context_desc=$(echo "$phase_inputs" | jq -r ".[$j].context_description // \"\"")

      echo "### From Phase: $from_phase"
      echo ""

      # Find the phase number for from_phase
      local from_phase_number=0
      for ((k=0; k<phase_count; k++)); do
        local name=$(echo "$workflow_json" | jq -r ".phases[$k].name")
        if [[ "$name" == "$from_phase" ]]; then
          from_phase_number=$((k + 1))
          break
        fi
      done

      while IFS= read -r file; do
        echo "- \`$base_dir/$feature_name/phase-$from_phase_number-$from_phase/$file\`"
      done <<< "$files"
      echo ""

      if [[ -n "$context_desc" && "$context_desc" != "null" ]]; then
        echo "**Purpose:** $context_desc"
        echo ""
      fi
    done

    echo "**Read these files** to understand the context before spawning subagents."
    echo ""
  else
    echo "**No input files from previous phases.**"
    echo ""
    echo "This is the first phase or requires no context from previous work."
    echo ""
  fi

  echo "---"
  echo ""
  echo "## Execution Instructions"
  echo ""

  # Check for execution notes
  local execution_notes=$(echo "$phase_json" | jq -r '.execution_notes // empty')
  if [[ -n "$execution_notes" ]]; then
    echo "### Main Agent Responsibilities"
    echo ""
    echo "$execution_notes"
    echo ""
  fi

  # Render subagents
  if [[ -n "$all_agents" ]]; then
    echo "### Subagents to Spawn"
    echo ""
    echo "Use the **Task** tool to spawn these agents:"
    echo ""

    local agent_index=1
    while IFS= read -r agent_name; do
      if [[ -n "$agent_name" ]]; then
        echo "#### $agent_index. $agent_name"
        echo ""

        # Get subagent config
        local task_agent_type=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".task_agent_type")
        local model=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".model // \"sonnet\"")
        local thoroughness=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".thoroughness // \"medium\"")
        local responsibility=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".responsibility")
        local instructions=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".instructions")
        local scope_guidance=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".scope_specific.\"$resolved_scope\" // \"\"")
        local output_file=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".outputs[0].file")
        local output_desc=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".outputs[0].description")
        local output_schema=$(echo "$phase_json" | jq -r ".subagent_configs.\"$agent_name\".outputs[0].schema // \"\"")

        echo "**Configuration:**"
        echo "- **Agent Type:** \`$task_agent_type\`"
        echo "- **Model:** $model"
        echo "- **Thoroughness:** $thoroughness"
        echo ""

        echo "**Task:**"
        echo ""
        echo "$responsibility"
        echo ""

        if [[ -n "$scope_guidance" ]]; then
          echo "**Scope-Specific Focus:**"
          echo ""
          echo "$scope_guidance"
          echo ""
        fi

        echo "**Instructions:**"
        echo ""
        echo "$instructions"
        echo ""

        echo "**Expected Output:**"
        echo "- **File:** \`$output_dir/$output_file\`"
        echo "- **Description:** $output_desc"

        # Display template if available
        if [[ -n "$output_schema" && "$output_schema" != "null" ]]; then
          echo "- **Schema:** \`$output_schema\`"
          echo ""

          # Resolve template path
          local template_path="$SCRIPT_DIR/$output_schema"
          if [[ ! "$output_schema" == *.tmpl ]]; then
            template_path="${template_path}.tmpl"
          fi

          if [[ -f "$template_path" ]]; then
            echo "**Expected Output Structure:**"
            echo ""

            # Detect file type for syntax highlighting
            local file_ext="${output_file##*.}"
            echo "\`\`\`$file_ext"
            cat "$template_path"
            echo "\`\`\`"
          else
            echo "*(Template file not found: $template_path)*"
          fi
        fi

        echo ""

        # Generate and display prompt inline
        echo "**Task Tool Invocation:**"
        echo ""
        echo "Use the Task tool with the following prompt:"
        echo ""
        echo "\`\`\`"

        # Call prompt generator and display output
        bash "$SCRIPT_DIR/lib/prompt-generator.sh" \
          "$phase_file" \
          "$agent_name" \
          "$feature_name" \
          "$resolved_scope" \
          "$workflow_name" \
          "$base_dir" \
          "$phase_number" \
          "$phase_name" \
          "$workflow_file"

        echo "\`\`\`"
        echo ""
        echo "**Agent Type:** \`$task_agent_type\`"
        echo ""
        echo "---"
        echo ""

        ((agent_index++))
      fi
    done <<< "$all_agents"

    echo "**Total Subagents:** $((agent_index - 1))"
    echo ""
  else
    echo "### No Subagents"
    echo ""
    echo "**This phase has no subagents configured.** The main agent handles all work."
    echo ""
  fi

  echo "---"
  echo ""
  echo "## Gap Check"
  echo ""

  # Render gap checks
  local gap_criteria=$(echo "$phase_json" | jq -r '.gap_checks.criteria[]? // empty')
  if [[ -n "$gap_criteria" ]]; then
    echo "Verify the following criteria have been met:"
    echo ""

    while IFS= read -r criterion; do
      echo "- [ ] $criterion"
    done <<< "$gap_criteria"
    echo ""

    echo "### If Any Criteria Fail"
    echo ""
    echo "Present to user:"
    echo ""
    echo "\`\`\`"
    echo "$phase_name phase completed with gaps:"
    echo ""
    echo "[List specific unmet criteria]"
    echo ""
    echo "What would you like to do?"

    local option_index=1
    local gap_options=$(echo "$phase_json" | jq -r '.gap_checks.on_failure[]? // empty')
    while IFS= read -r option; do
      echo "$option_index. $option"
      ((option_index++))
    done <<< "$gap_options"
    echo "\`\`\`"
    echo ""

    echo "**Wait for user selection** before proceeding."
    echo ""
  else
    echo "**No gap checks defined for this phase.**"
    echo ""
  fi

  echo "---"
  echo ""

  # Check for checkpoint
  local checkpoint_count=$(echo "$workflow_json" | jq '.checkpoints | length')
  local has_checkpoint=false

  for ((i=0; i<checkpoint_count; i++)); do
    local after=$(echo "$workflow_json" | jq -r ".checkpoints[$i].after")
    if [[ "$after" == "$phase_name" ]]; then
      has_checkpoint=true
      local checkpoint_prompt=$(echo "$workflow_json" | jq -r ".checkpoints[$i].prompt")
      local checkpoint_files=$(echo "$workflow_json" | jq -r ".checkpoints[$i].show_files[]? // empty")
      local checkpoint_options=$(echo "$workflow_json" | jq -r ".checkpoints[$i].options[]? // empty")

      echo "## Checkpoint Review"
      echo ""
      echo "**User Approval Required**"
      echo ""
      echo "$checkpoint_prompt"
      echo ""

      if [[ -n "$checkpoint_files" ]]; then
        echo "**Files for Review:**"
        while IFS= read -r file; do
          echo "- \`$output_dir/$file\`"
        done <<< "$checkpoint_files"
        echo ""
        echo "**Please review the files above** before making a selection."
        echo ""
      fi

      echo "**Options:**"
      local opt_index=1
      while IFS= read -r option; do
        echo "$opt_index. $option"
        ((opt_index++))
      done <<< "$checkpoint_options"
      echo ""

      echo "**Wait for user selection.**"
      echo ""
      break
    fi
  done

  if [[ "$has_checkpoint" == "false" ]]; then
    echo "## Proceed to Next Phase"
    echo ""
    echo "**No checkpoint defined for this phase.**"
    echo ""
    echo "Continue to next phase."
    echo ""
  fi

  echo "---"
  echo ""
  echo "## Phase Complete"
  echo ""

  # Render provides
  local provides=$(echo "$phase_json" | jq -r '.provides[]? // empty')
  if [[ -n "$provides" ]]; then
    echo "**Provides for Next Phases:**"
    while IFS= read -r data_item; do
      echo "- $data_item"
    done <<< "$provides"
    echo ""
    echo "These data items are now available for subsequent phases to consume."
    echo ""
  fi

  # Show next phase
  local next_phase_index=$((phase_index + 1))
  if [[ $next_phase_index -lt $phase_count ]]; then
    local next_phase_name=$(echo "$workflow_json" | jq -r ".phases[$next_phase_index].name")
    echo "**Next:** Phase $((next_phase_index + 1)): $next_phase_name"
    echo ""
    echo "Fetch instructions:"
    echo "\`\`\`bash"
    echo "bash fetch-phase.sh $workflow_name $((next_phase_index + 1)) $feature_name $user_scope"
    echo "\`\`\`"
  else
    echo "**This is the final phase. Workflow complete.**"
  fi
}

# ==============================================================================
# MAIN FUNCTION
# ==============================================================================

main() {
  local workflow_name="${1:-}"
  local phase_identifier="${2:-}"
  local feature_name="${3:-}"
  local scope_flag="${4:-}"

  if [[ -z "$workflow_name" || -z "$phase_identifier" || -z "$feature_name" ]]; then
    cat <<USAGE
Usage: $0 <workflow-name> <phase-number-or-name> <feature-name> [--frontend|--backend|--both]

Arguments:
  workflow-name       - Name of workflow (e.g., investigation-workflow)
  phase-number-or-name - Phase number (1, 2, 3...) or name (e.g., codebase-investigation)
  feature-name        - Name of feature being worked on (e.g., user-auth)
  scope-flag          - Optional scope (--frontend, --backend, --both)
                        Default: --frontend

Examples:
  $0 investigation-workflow 1 user-auth --frontend
  $0 investigation-workflow codebase-investigation user-auth --frontend
  $0 new-feature-plan 2 payment-integration --both

USAGE
    exit 1
  fi

  # Detect scope
  local user_scope=$(detect_scope "$@")

  # Render phase
  render_phase_instructions "$workflow_name" "$phase_identifier" "$feature_name" "$user_scope"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

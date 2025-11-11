#!/usr/bin/env bash
# Workflow Instructions Generator (v5)
# Generates workflow execution instructions from v5 YAML configurations

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
OUTPUT_TEMPLATES_DIR="$SCRIPT_DIR/output_templates"

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================

load_workflow() {
  local workflow_file="$1"

  if [[ ! -f "$workflow_file" ]]; then
    echo "Error: Workflow file not found: $workflow_file" >&2
    return 1
  fi

  # Return workflow as JSON for easier processing (remove comments)
  yq eval -o=json '.' "$workflow_file" | jq -c '.'
}

load_phase() {
  local phase_file="$1"

  if [[ ! -f "$phase_file" ]]; then
    echo "Error: Phase file not found: $phase_file" >&2
    return 1
  fi

  yq eval -o=json '.' "$phase_file" | jq -c '.'
}

resolve_scope() {
  local phase_scope="$1"
  local workflow_scope="$2"
  local user_scope="$3"

  case "$phase_scope" in
    "default")
      echo "$workflow_scope"
      ;;
    "{{workflow_scope}}")
      echo "$user_scope"
      ;;
    *)
      echo "$phase_scope"
      ;;
  esac
}

get_subagents_for_phase() {
  local phase_json="$1"
  local scope="$2"

  # Always agents
  local always_agents=$(echo "$phase_json" | jq -r '.subagents.always[]? // empty' | tr '\n' ' ')

  # Conditional agents for scope
  local conditional_agents=$(echo "$phase_json" | jq -r ".subagents.conditional.\"$scope\"[]? // empty" | tr '\n' ' ')

  # Combine and return unique agents
  echo -e "$always_agents\n$conditional_agents" | tr ' ' '\n' | grep -v '^$' | sort -u | tr '\n' ' '
}

# ==============================================================================
# PHASE SUMMARY GENERATION
# ==============================================================================

generate_phase_summary() {
  local workflow_json="$1"
  local feature_name="$2"
  local user_scope="$3"

  local workflow_name=$(echo "$workflow_json" | jq -r '.name')
  local base_dir=$(echo "$workflow_json" | jq -r '.base_dir')
  local description=$(echo "$workflow_json" | jq -r '.description')
  local estimated_time=$(echo "$workflow_json" | jq -r '.estimated_time')
  local estimated_tokens=$(echo "$workflow_json" | jq -r '.estimated_tokens')
  local default_scope=$(echo "$workflow_json" | jq -r '.default_scope')

  # Resolve default scope
  if [[ "$default_scope" == "{{user_provided_scope}}" ]]; then
    default_scope="$user_scope"
  fi

  cat <<EOF
# Workflow: $workflow_name

**Feature:** $feature_name
**Scope:** $user_scope
**Description:** $description
**Estimated Time:** $estimated_time
**Estimated Tokens:** $estimated_tokens
**Output Location:** \`$base_dir/$feature_name/\`

---

## Workflow Overview

This workflow consists of the following phases:

EOF

  # List phases
  local phase_count=$(echo "$workflow_json" | jq '.phases | length')

  for ((i=0; i<phase_count; i++)); do
    local phase_name=$(echo "$workflow_json" | jq -r ".phases[$i].name")
    local phase_scope=$(echo "$workflow_json" | jq -r ".phases[$i].scope")
    local phase_file="$PHASES_DIR/$phase_name.yaml"

    # Resolve scope for this phase
    local resolved_scope=$(resolve_scope "$phase_scope" "$default_scope" "$user_scope")

    if [[ -f "$phase_file" ]]; then
      local phase_json=$(load_phase "$phase_file")
      local phase_purpose=$(echo "$phase_json" | jq -r '.purpose')
      local phase_number=$((i+1))

      echo "### Phase $phase_number: $phase_name"
      echo ""
      echo "**Purpose:** $phase_purpose"
      echo ""
      echo "**Scope:** $resolved_scope"
      echo ""

      # List subagents
      local subagents=$(get_subagents_for_phase "$phase_json" "$resolved_scope")
      if [[ -n "$subagents" ]]; then
        echo "**Subagents:** $subagents"
      else
        echo "**Subagents:** None (main agent only)"
      fi
      echo ""
    else
      echo "### Phase $((i+1)): $phase_name"
      echo ""
      echo "⚠️  Phase file not found: $phase_file"
      echo ""
    fi
  done

  # List checkpoints
  local checkpoint_count=$(echo "$workflow_json" | jq '.checkpoints | length')

  if [[ $checkpoint_count -gt 0 ]]; then
    echo "---"
    echo ""
    echo "## User Checkpoints"
    echo ""

    for ((i=0; i<checkpoint_count; i++)); do
      local after=$(echo "$workflow_json" | jq -r ".checkpoints[$i].after")
      local prompt=$(echo "$workflow_json" | jq -r ".checkpoints[$i].prompt")

      echo "- **After $after:** $prompt"
    done
    echo ""
  fi

  cat <<EOF
---

## Progressive Disclosure

To fetch detailed instructions for a specific phase, use:

\`\`\`bash
bash fetch-phase.sh $workflow_name <phase-number-or-name> $feature_name $user_scope
\`\`\`

**Example:**
\`\`\`bash
bash fetch-phase.sh $workflow_name 1 $feature_name $user_scope
bash fetch-phase.sh $workflow_name codebase-investigation $feature_name $user_scope
\`\`\`

---

## Ready to Begin

Execute phases sequentially, fetching detailed instructions for each phase as needed.

Start with Phase 1: **$(echo "$workflow_json" | jq -r '.phases[0].name')**

EOF
}

# ==============================================================================
# MAIN FUNCTION
# ==============================================================================

main() {
  local workflow_name="${1:-}"
  local feature_name="${2:-}"
  local scope_flag="${3:-}"

  # Validate arguments
  if [[ -z "$workflow_name" || -z "$feature_name" ]]; then
    cat <<USAGE
Usage: $0 <workflow-name> <feature-name> [--frontend|--backend|--both]

Arguments:
  workflow-name  - Name of workflow (e.g., investigation-workflow)
  feature-name   - Name of feature being worked on (e.g., user-auth)
  scope-flag     - Optional scope (--frontend, --backend, --both)
                   Default: --frontend

Examples:
  $0 investigation-workflow user-auth --frontend
  $0 new-feature-plan payment-integration --both
  $0 debugging-plan auth-bug --backend

Available workflows:
$(ls -1 "$WORKFLOWS_DIR"/*.yaml 2>/dev/null | xargs -n1 basename | sed 's/.yaml$//' | sed 's/^/  - /')

Output:
  Workflow summary with phase overview and progressive disclosure instructions

USAGE
    exit 1
  fi

  # Detect scope
  local user_scope=$(detect_scope "$@")

  # Load workflow
  local workflow_file="$WORKFLOWS_DIR/$workflow_name.yaml"

  if [[ ! -f "$workflow_file" ]]; then
    echo "Error: Workflow not found: $workflow_file" >&2
    echo "" >&2
    echo "Available workflows:" >&2
    ls -1 "$WORKFLOWS_DIR"/*.yaml 2>/dev/null | xargs -n1 basename | sed 's/.yaml$//' | sed 's/^/  - /' >&2
    exit 1
  fi

  local workflow_json=$(load_workflow "$workflow_file")

  # Generate summary
  generate_phase_summary "$workflow_json" "$feature_name" "$user_scope"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

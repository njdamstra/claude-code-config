#!/usr/bin/env bash
set -euo pipefail

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
Usage: bash generate-workflow-instructions.sh <workflow> <feature-name> [flags...]

Arguments:
  workflow      Workflow type (new-feature-plan, refactoring-plan, debugging-plan, improving-plan, quick-plan)
  feature-name  Name of feature/task being planned

Flags:
  --frontend    Include frontend-specific subagents
  --backend     Include backend-specific subagents
  --both        Include both frontend and backend subagents
  --summary     Output summary only (progressive disclosure - default)
  --full        Output full instructions (legacy behavior)
  --base-dir    Override base directory for outputs (default: ${DEFAULT_BASE_DIR})
  --<key>=<value>  Custom condition flags to trigger conditional subagents (e.g., --complexity=high)

Examples:
  bash generate-workflow-instructions.sh new-feature-plan user-dashboard --frontend
  bash generate-workflow-instructions.sh refactoring-plan auth-flow --backend --summary
  bash generate-workflow-instructions.sh debugging-plan hydration-issue --both --full
  bash generate-workflow-instructions.sh improving-plan onboarding --frontend --base-dir ~/.claude/plans

Output:
  Workflow instructions written to stdout (summary or full based on flags)
USAGE
}


# ============================================================================
# Main Function
# ============================================================================

main() {
  # Parse arguments
  if [[ $# -lt 2 ]]; then
    usage
    exit 1
  fi

  local workflow=$1
  local feature_name=$2

  # Validate feature name
  if ! [[ "$feature_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Error: Feature name must contain only alphanumeric characters, hyphens, and underscores" >&2
    echo "  Invalid name: '$feature_name'" >&2
    exit 1
  fi

  shift 2

  # Initialize workflow context (handles parsing, loading, etc.)
  local context_json
  if ! context_json=$(initialize_workflow_context "$workflow" "$SCRIPT_DIR" "$@"); then
    exit 1
  fi

  # Extract context values
  local workflow_desc=$(echo "$context_json" | jq -r '.workflow_desc')
  local estimated_time=$(echo "$context_json" | jq -r '.estimated_time')
  local estimated_tokens=$(echo "$context_json" | jq -r '.estimated_tokens')
  local base_dir=$(echo "$context_json" | jq -r '.base_dir')
  local scope=$(echo "$context_json" | jq -r '.scope')
  local flags_string=$(echo "$context_json" | jq -r '.flags_string')
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

  # Check for output mode (default: summary)
  local output_mode="summary"
  local flags=()
  if [[ "$flags_string" != "none" ]]; then
    read -ra flags <<< "$flags_string"
    for flag in "${flags[@]}"; do
      if [[ "$flag" == "--full" ]]; then
        output_mode="full"
        break
      fi
    done
  fi

  # Route to appropriate output function
  if [[ "$output_mode" == "summary" ]]; then
    output_summary "$workflow" "$workflow_desc" "$feature_name" "$scope" "$flags_string" "$estimated_time" "$estimated_tokens" "$base_dir" "${phases[@]}"
  else
    output_full "$workflow" "$workflow_desc" "$feature_name" "$scope" "$flags_string" "$estimated_time" "$estimated_tokens" "$base_dir" "$workflow_json" "$conditions_json" "${phases[@]}"
  fi
}

# ============================================================================
# Summary Output (Progressive Disclosure)
# ============================================================================

output_summary() {
  local workflow=$1
  local workflow_desc=$2
  local feature_name=$3
  local scope=$4
  local flags=$5
  local estimated_time=$6
  local estimated_tokens=$7
  local base_dir=$8
  shift 8
  local phases=("$@")
  local workflow_cap=$(capitalize "$workflow")

  cat <<SUMMARY
# Workflow Summary: $workflow_cap - $feature_name

**Workflow:** $workflow
**Description:** $workflow_desc
**Scope:** $scope
**Flags:** ${flags:-none}
**Estimated Time:** $estimated_time
**Estimated Tokens:** $estimated_tokens
**Base Directory:** ${base_dir}/${feature_name}/

---

## Progressive Disclosure Instructions

This workflow uses **progressive disclosure** to minimize token usage and maintain focus.

### How to Execute This Workflow

**Step 1: Review Phase Overview**

The workflow consists of ${#phases[@]} phases:

SUMMARY

  local phase_num=1
  for phase in "${phases[@]}"; do
    local phase_cap=$(capitalize "$phase")
    echo "${phase_num}. **${phase_cap}** - $(get_phase_description "$phase")"
    ((phase_num++))
  done

  cat <<SUMMARY2

---

**Step 2: Fetch Phase Details On-Demand**

When you're ready to execute a phase, run:

\`\`\`bash
bash ~/.claude/skills/use-workflows-v2/fetch-phase-details.sh \
  $workflow \
  <phase-name-or-number> \
  $feature_name \
  $flags
\`\`\`

**Examples:**

Using phase number (1-based):
\`\`\`bash
bash ~/.claude/skills/use-workflows-v2/fetch-phase-details.sh \
  $workflow \
  1 \
  $feature_name \
  $flags
\`\`\`

Using phase name:
\`\`\`bash
bash ~/.claude/skills/use-workflows-v2/fetch-phase-details.sh \
  $workflow \
  ${phases[0]} \
  $feature_name \
  $flags
\`\`\`

This will output the complete step-by-step instructions for that phase including:
- Subagent configurations
- Task tool invocations
- Gap checks
- Checkpoints
- Deliverables

**Step 3: Execute Phase Instructions**

Follow the rendered instructions for the current phase.

**Step 4: Repeat for Each Phase**

Fetch and execute each phase sequentially.

---

## Benefits of Progressive Disclosure

- **80% token reduction** on initial load (2-5K vs 20-100K)
- **Focused execution** - Only see current phase details
- **Reduced context pollution** - Main agent stays focused
- **Same functionality** - Just progressive instead of all-at-once

---

## Phase Execution Order

SUMMARY2

  phase_num=1
  for phase in "${phases[@]}"; do
    local phase_cap=$(capitalize "$phase")
    echo "${phase_num}. ${phase_cap}"
    ((phase_num++))
  done

  cat <<SUMMARY3

---

## Output Structure

All phase deliverables will be written to the configured workspace:

\`\`\`
${base_dir}/${feature_name}/
├── PLAN.md
├── metadata.json
SUMMARY3

  for ((i=0; i<${#phases[@]}; i++)); do
    local phase="${phases[$i]}"
    local phase_cap=$(capitalize "$phase")
    local dir_name
    dir_name=$(calculate_output_dir "$((i + 1))" "$phase")
    echo "├── ${dir_name}/        # $phase_cap phase outputs"
  done

  cat <<SUMMARY4
└── archives/                # Version history
\`\`\`

---

## Success Criteria

- ✓ All ${#phases[@]} phases completed successfully
- ✓ All deliverables exist and validated
- ✓ All gap checks passed (or user approved gaps)
- ✓ All checkpoints approved by user

---

**Ready to begin. Fetch phase details for the first phase to start.**
SUMMARY4
}

# Helper: Get phase description (basic descriptions)
get_phase_description() {
  local phase=$1
  case "$phase" in
    problem-understanding) echo "Define and confirm problem statement" ;;
    codebase-investigation) echo "Research codebase for patterns and dependencies" ;;
    external-research) echo "Research best practices and framework patterns" ;;
    solution-synthesis) echo "Synthesize findings into 2-3 solution approaches" ;;
    introspection) echo "Validate assumptions with targeted questions" ;;
    approach-refinement) echo "Refine chosen approach with technical details" ;;
    discovery) echo "Scan codebase for patterns and dependencies" ;;
    requirements) echo "Document user stories and technical requirements" ;;
    design) echo "Create technical design and architecture" ;;
    synthesis) echo "Synthesize all findings into complete plan" ;;
    validation) echo "Validate plan completeness and feasibility" ;;
    analysis) echo "Analyze code smells and complexity" ;;
    planning) echo "Create refactoring plan with incremental steps" ;;
    investigation) echo "Reproduce bug and analyze environment" ;;
    solution) echo "Design fix with root cause analysis" ;;
    assessment) echo "Baseline performance and identify bottlenecks" ;;
    plan-init) echo "Initialize planning structure" ;;
    plan-generation) echo "Generate implementation plan" ;;
    plan-review) echo "Review and refine plan" ;;
    quick-research) echo "Quick research with minimal overhead" ;;
    decision-finalization) echo "Finalize decision with user approval" ;;
    implementation) echo "Break down implementation into tasks" ;;
    testing) echo "Plan testing strategy" ;;
    quality-review) echo "Comprehensive quality review" ;;
    finalization) echo "Finalize and package deliverables" ;;
    *) echo "Phase execution" ;;
  esac
}

# ============================================================================
# Full Output (Legacy Behavior)
# ============================================================================

output_full() {
  local workflow=$1
  local workflow_desc=$2
  local feature_name=$3
  local scope=$4
  local flags=$5
  local estimated_time=$6
  local estimated_tokens=$7
  local base_dir=$8
  local workflow_json=$9
  local conditions_json=${10:-'[]'}
  shift 10
  local phases=("$@")

  # =========================================================================
  # Output Header
  # =========================================================================

  local workflow_cap=$(capitalize "$workflow")

  cat <<HEADER
# Workflow Instructions: $workflow_cap - $feature_name

**Workflow:** $workflow
**Description:** $workflow_desc
**Scope:** $scope
**Flags:** ${flags:-none}
**Estimated Time:** $estimated_time
**Estimated Tokens:** $estimated_tokens
**Base Directory:** ${base_dir}/${feature_name}/

---

HEADER

  # =========================================================================
  # Render Each Phase
  # =========================================================================

  local phase_number=1
  for phase in "${phases[@]}"; do
    echo "## Rendering Phase: ${phase_number} - $phase" >&2  # Debug to stderr

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
      local phase_cap
      phase_cap=$(capitalize "$phase")
      echo "Warning: Phase template not found for workflow '$workflow', phase '$phase'" >&2
      echo ""
      echo "## Phase: $phase_cap"
      echo ""
      echo "*Phase template not yet created. This will be implemented in Phase 3.*"
      echo ""
      echo "**Subagents for this phase:**"
      echo "$phase_data" | jq -r ".subagents[] | \"- \(.name) (\(.task_agent_type))\""
      echo ""
      echo "---"
      echo ""
      continue
    fi

    local rendered=$(render_template "$phase_template" "$phase_data")

    echo "$rendered"
    echo ""
    echo "---"
    echo ""
    ((phase_number++))
  done

  # =========================================================================
  # Finalization Section
  # =========================================================================

  cat <<FOOTER

## Finalization

All phases complete. Next steps:

1. **Review all deliverables** in \`${base_dir}/${feature_name}/\`
2. **Run validation checks** as specified in the validation phase
3. **Generate final plan** (\`PLAN.md\`) using template: $(get_workflow_field "$workflow_json" "template")
4. **Update metadata.json** with workflow execution summary

---

## Output Structure

\`\`\`
${base_dir}/${feature_name}/
├── PLAN.md                  # Final implementation plan
├── metadata.json            # Execution metadata
FOOTER

  # Add phase directories
  for ((i=0; i<${#phases[@]}; i++)); do
    local phase="${phases[$i]}"
    local phase_cap=$(capitalize "$phase")
    local dir_name
    dir_name=$(calculate_output_dir "$((i + 1))" "$phase")
    echo "├── ${dir_name}/        # $phase_cap phase outputs"
  done

  cat <<FOOTER2
└── archives/                # Version history
\`\`\`

## Success Criteria

- ✓ All phases completed successfully
- ✓ All deliverables exist and validated
- ✓ All gap checks passed (or user approved gaps)
- ✓ All checkpoints approved by user
- ✓ Final plan generated and comprehensive

---

**Workflow complete. Ready for implementation.**
FOOTER2
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

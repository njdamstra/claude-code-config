#!/usr/bin/env bash

# Main workflow orchestrator - TEST INFRASTRUCTURE ONLY
#
# ⚠️  WARNING: This bash engine is for TESTING only, not production use!
# ⚠️  Production execution: Claude reads YAML and spawns Task agents directly
# ⚠️  See SKILL.md "Quick Start Execution" for proper usage
#
# This bash engine has MVP stubs that auto-execute checkpoints, gap checks,
# and subagents. These are for testing the workflow structure only.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/workflow-loader.sh"
source "${SCRIPT_DIR}/context-manager.sh"
source "${SCRIPT_DIR}/phase-executor.sh"
source "${SCRIPT_DIR}/checkpoint-handler.sh"
source "${SCRIPT_DIR}/gap-check-manager.sh"
source "${SCRIPT_DIR}/skills-invoker.sh"
source "${SCRIPT_DIR}/template-renderer.sh"

# ============================================================================
# Main Entry Point
# ============================================================================

run_workflow() {
  local workflow_path=$1
  local feature_name=$2
  shift 2
  local flags=("$@")

  log_info "=========================================="
  log_info "Workflow Engine v2 - Starting"
  log_info "=========================================="
  log_info "Workflow: $workflow_path"
  log_info "Feature: $feature_name"
  if [ ${#flags[@]} -gt 0 ]; then
    log_info "Flags: ${flags[*]}"
  fi
  log_info ""

  # Step 1: Load workflow
  log_info "Loading workflow..."
  local workflow_json=$(load_workflow "$workflow_path")
  if [ $? -ne 0 ]; then
    handle_error "Failed to load workflow" 1
  fi

  local workflow_name=$(get_workflow_name "$workflow_json")
  local workflow_mode=$(get_workflow_mode "$workflow_json")
  log_info "Loaded: $workflow_name (mode: $workflow_mode)"
  log_info ""

  # Step 2: Initialize context
  log_info "Initializing context..."
  if [ ${#flags[@]} -gt 0 ]; then
    local temp_dir=$(context_init "$feature_name" "$workflow_name" "$workflow_mode" "${flags[@]}")
  else
    local temp_dir=$(context_init "$feature_name" "$workflow_name" "$workflow_mode")
  fi
  log_info "Context initialized: $temp_dir"
  log_info ""

  # Step 3: Announce workflow plan
  announce_workflow_plan "$workflow_json"

  # Step 4: Execute phases
  local phase_count=$(get_phase_count "$workflow_json")
  log_info ""
  log_info "=========================================="
  log_info "Executing $phase_count phase(s)"
  log_info "=========================================="
  log_info ""

  local phase_index=0
  local abort_requested=false

  while [ $phase_index -lt $phase_count ]; do
    local phase=$(get_phase_by_index "$workflow_json" "$phase_index")
    local phase_id=$(get_phase_id "$phase")
    local phase_name=$(get_phase_name "$phase")

    # Check if phase should be skipped
    if should_skip_phase "$phase_id"; then
      log_info "⏭  Skipping phase: $phase_name ($phase_id)"
      phase_index=$((phase_index + 1))
      continue
    fi

    log_info "=========================================="
    log_info "Phase $((phase_index + 1))/$phase_count: $phase_name"
    log_info "=========================================="

    # Mark phase as started
    phase_start "$phase_id"

    # Execute phase (with retry loop for gap checks)
    local retry_phase=true
    while [ "$retry_phase" = "true" ]; do
      retry_phase=false

      # Execute phase
      local context_json=$(context_get)
      execute_phase "$workflow_json" "$phase" "$context_json"

      if [ $? -ne 0 ]; then
        log_error "Phase execution failed: $phase_id"
        handle_error "Phase $phase_id failed" 1
      fi

      # Reload context after phase execution
      context_json=$(context_get)

      # Execute gap check
      local gap_check_result=$(execute_gap_check "$phase" "$context_json")

      case "$gap_check_result" in
        RETRY_PHASE)
          log_info "Gap check requested phase retry"
          retry_phase=true
          continue
          ;;
        CONTINUE)
          log_debug "Gap check passed"
          ;;
        *)
          log_warning "Unknown gap check result: $gap_check_result"
          ;;
      esac
    done

    # Invoke phase skills (after gap check passes)
    local context_json=$(context_get)
    invoke_phase_skills "$phase" "$context_json"

    # Reload context after skills
    context_json=$(context_get)

    # Handle checkpoint
    local checkpoint_result=$(handle_checkpoint "$phase" "$context_json")

    case "$checkpoint_result" in
      CONTINUE)
        log_debug "Checkpoint: continue"
        phase_complete "$phase_id"
        phase_index=$((phase_index + 1))
        ;;

      REPEAT_PHASE:*)
        local target_phase_id=$(echo "$checkpoint_result" | cut -d: -f2)
        log_info "Checkpoint: repeating phase $target_phase_id"

        # Find target phase index
        local target_index=0
        local found=false
        while [ $target_index -lt $phase_count ]; do
          local target_phase=$(get_phase_by_index "$workflow_json" "$target_index")
          local target_id=$(get_phase_id "$target_phase")
          if [ "$target_id" = "$target_phase_id" ]; then
            phase_index=$target_index
            found=true
            break
          fi
          target_index=$((target_index + 1))
        done

        if [ "$found" = "false" ]; then
          log_error "Target phase not found: $target_phase_id"
          handle_error "Invalid repeat_phase target" 1
        fi
        ;;

      ABORT)
        log_warning "Workflow aborted by user at checkpoint"
        abort_requested=true
        break
        ;;

      *)
        log_warning "Unknown checkpoint result: $checkpoint_result"
        phase_complete "$phase_id"
        phase_index=$((phase_index + 1))
        ;;
    esac

    log_info ""
  done

  # Check if aborted
  if [ "$abort_requested" = "true" ]; then
    log_warning "Workflow aborted by user"
    return 2
  fi

  # Step 5: Finalize workflow
  log_info "=========================================="
  log_info "Finalizing workflow"
  log_info "=========================================="
  finalize_workflow "$workflow_json" "$temp_dir" "$workflow_path"

  # Step 6: Create metadata
  create_metadata "$temp_dir"

  log_info ""
  log_info "=========================================="
  log_info "Workflow completed successfully"
  log_info "=========================================="
  log_info "Output: $temp_dir"
  log_info ""

  return 0
}

# ============================================================================
# Workflow Announcement
# ============================================================================

announce_workflow_plan() {
  local workflow_json=$1

  local name=$(get_workflow_name "$workflow_json")
  local description=$(get_workflow_description "$workflow_json")
  local mode=$(get_workflow_mode "$workflow_json")
  local phase_count=$(get_phase_count "$workflow_json")

  log_info "=========================================="
  log_info "Workflow Plan: $name"
  log_info "=========================================="
  log_info ""
  log_info "$description"
  log_info ""
  log_info "Execution mode: $mode"
  log_info "Total phases: $phase_count"
  log_info ""
  log_info "Phases:"

  local index=0
  while [ $index -lt $phase_count ]; do
    local phase=$(get_phase_by_index "$workflow_json" "$index")
    local phase_id=$(get_phase_id "$phase")
    local phase_name=$(get_phase_name "$phase")
    local phase_desc=$(echo "$phase" | jq -r '.description')
    local phase_mode=$(get_phase_mode "$workflow_json" "$phase")

    log_info "  $((index + 1)). $phase_name ($phase_id)"
    log_info "     $phase_desc"
    if [ "$phase_mode" != "$mode" ]; then
      log_info "     [Mode override: $phase_mode]"
    fi
    log_info ""

    index=$((index + 1))
  done
}

# ============================================================================
# Finalization
# ============================================================================

finalize_workflow() {
  local workflow_json=$1
  local output_dir=$2
  local workflow_path=$3

  log_info "Rendering final plan..."

  local template_path=$(get_finalization_template "$workflow_json")
  local output_path=$(get_finalization_output "$workflow_json")

  # Resolve template path relative to workflow file or absolute
  if [ ! -f "$template_path" ]; then
    local workflow_dir=$(dirname "$workflow_path")
    template_path="${workflow_dir}/${template_path}"
  fi

  if [ ! -f "$template_path" ]; then
    log_warning "Finalization template not found: $template_path"
    log_info "Skipping final plan rendering"
    return 0
  fi

  # Resolve output path
  if [[ "$output_path" == ./* ]] || [[ "$output_path" != /* ]]; then
    output_path="${output_dir}/${output_path}"
  fi

  # Get context for rendering
  local context_json=$(context_get)

  # Render template
  render_template "$template_path" "$context_json" "$output_path"

  log_info "Final plan: $output_path"
}

# ============================================================================
# Metadata Generation
# ============================================================================

create_metadata() {
  local output_dir=$1

  log_info "Generating metadata..."

  local context_json=$(context_get)
  local metadata_file="${output_dir}/metadata.json"

  # Extract key metrics
  local workflow_name=$(echo "$context_json" | jq -r '.workflow.name')
  local started_at=$(echo "$context_json" | jq -r '.workflow.started_at')
  local completed_at=$(timestamp_iso8601)
  local feature_name=$(echo "$context_json" | jq -r '.feature.name')
  local execution_mode=$(echo "$context_json" | jq -r '.workflow.execution_mode')
  local phases_completed=$(echo "$context_json" | jq '.phases.completed | length')
  local subagents_spawned=$(echo "$context_json" | jq '.subagents_spawned')
  local deliverables=$(echo "$context_json" | jq -c '.deliverables')
  local deliverable_count=$(echo "$deliverables" | jq 'length')
  local checkpoints=$(echo "$context_json" | jq -c '.checkpoints')
  local gap_checks=$(echo "$context_json" | jq -c '.gap_checks')

  # Calculate duration (cross-platform)
  local start_seconds end_seconds
  if date --version >/dev/null 2>&1; then
    # GNU date (Linux)
    start_seconds=$(date -d "$started_at" +%s 2>/dev/null || echo "0")
    end_seconds=$(date -d "$completed_at" +%s 2>/dev/null || echo "0")
  else
    # BSD date (macOS)
    start_seconds=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$started_at" +%s 2>/dev/null || echo "0")
    end_seconds=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$completed_at" +%s 2>/dev/null || echo "0")
  fi
  local duration_seconds=$((end_seconds - start_seconds))

  # Build metadata
  local metadata=$(jq -n \
    --arg workflow "$workflow_name" \
    --arg feature "$feature_name" \
    --arg mode "$execution_mode" \
    --arg started "$started_at" \
    --arg completed "$completed_at" \
    --argjson duration "$duration_seconds" \
    --argjson phases "$phases_completed" \
    --argjson subagents "$subagents_spawned" \
    --argjson deliverable_count "$deliverable_count" \
    --argjson deliverables "$deliverables" \
    --argjson checkpoints "$checkpoints" \
    --argjson gap_checks "$gap_checks" \
    '{
      workflow: $workflow,
      feature: $feature,
      execution_mode: $mode,
      started_at: $started,
      completed_at: $completed,
      duration_seconds: $duration,
      metrics: {
        phases_completed: $phases,
        subagents_spawned: $subagents,
        deliverables_created: $deliverable_count
      },
      deliverables: $deliverables,
      checkpoints: $checkpoints,
      gap_checks: $gap_checks
    }')

  echo "$metadata" > "$metadata_file"

  log_info "Metadata: $metadata_file"
  log_info ""
  log_info "Summary:"
  log_info "  - Phases completed: $phases_completed"
  log_info "  - Subagents spawned: $subagents_spawned"
  log_info "  - Deliverables created: $deliverable_count"
  log_info "  - Duration: ${duration_seconds}s"
}

# ============================================================================
# CLI Entry Point
# ============================================================================

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  # Script is being executed directly
  if [ $# -lt 2 ]; then
    echo "Usage: $0 <workflow.yaml> <feature-name> [flags...]" >&2
    echo "" >&2
    echo "Example:" >&2
    echo "  $0 workflows/new-feature.workflow.yaml user-authentication --frontend" >&2
    exit 1
  fi

  workflow_path=$1
  feature_name=$2
  shift 2

  if [ $# -gt 0 ]; then
    run_workflow "$workflow_path" "$feature_name" "$@"
  else
    run_workflow "$workflow_path" "$feature_name"
  fi
  exit $?
fi

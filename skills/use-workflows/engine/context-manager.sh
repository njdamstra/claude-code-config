#!/usr/bin/env bash

# Context state manager

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# ============================================================================
# Phase Tracking
# ============================================================================

phase_start() {
  local phase_id=$1
  context_update '.phases.current' "\"$phase_id\""
  log_info "Started phase: $phase_id"
}

phase_complete() {
  local phase_id=$1
  local context=$(context_get)

  # Add to completed
  context=$(echo "$context" | jq ".phases.completed += [\"$phase_id\"]")

  # Clear current
  context=$(echo "$context" | jq '.phases.current = null')

  context_set "$context"
  log_info "Completed phase: $phase_id"
}

phase_increment_iteration() {
  local phase_id=$1
  local context=$(context_get)

  # Initialize if not exists
  local current=$(echo "$context" | jq -r ".phases.iteration_counts.\"$phase_id\" // 0")
  local new_count=$((current + 1))

  context=$(echo "$context" | jq ".phases.iteration_counts.\"$phase_id\" = $new_count")
  context_set "$context"

  log_debug "Phase $phase_id iteration count: $new_count"
  echo "$new_count"
}

phase_get_iteration_count() {
  local phase_id=$1
  context_read ".phases.iteration_counts.\"$phase_id\" // 0"
}

# ============================================================================
# Subagent Tracking
# ============================================================================

subagent_spawned() {
  local context=$(context_get)
  local current=$(echo "$context" | jq '.subagents_spawned // 0')
  local new_count=$((current + 1))

  context=$(echo "$context" | jq ".subagents_spawned = $new_count")
  context_set "$context"

  log_debug "Subagents spawned: $new_count"
}

# ============================================================================
# Deliverable Tracking
# ============================================================================

add_deliverable() {
  local phase_id=$1
  local file_path=$2
  local subagent_type=${3:-""}

  if [ ! -f "$file_path" ]; then
    log_warning "Deliverable file not found: $file_path"
  fi

  local size_bytes=0
  if [ -f "$file_path" ]; then
    size_bytes=$(wc -c < "$file_path" | tr -d ' ')
  fi

  local timestamp=$(timestamp_iso8601)
  local context=$(context_get)

  local deliverable=$(jq -n \
    --arg phase "$phase_id" \
    --arg path "$file_path" \
    --arg subagent "$subagent_type" \
    --arg ts "$timestamp" \
    --arg size "$size_bytes" \
    '{
      phase: $phase,
      path: $path,
      subagent: $subagent,
      size_bytes: ($size | tonumber),
      timestamp: $ts
    }')

  context=$(echo "$context" | jq ".deliverables += [$deliverable]")
  context_set "$context"

  log_debug "Added deliverable: $file_path"
}

# ============================================================================
# Checkpoint Tracking
# ============================================================================

record_checkpoint() {
  local phase_id=$1
  local decision=$2
  local feedback=${3:-""}
  local skipped_phases_json=${4:-"[]"}

  local timestamp=$(timestamp_iso8601)
  local context=$(context_get)

  local checkpoint=$(jq -n \
    --arg phase "$phase_id" \
    --arg decision "$decision" \
    --arg feedback "$feedback" \
    --arg ts "$timestamp" \
    --argjson skipped "$skipped_phases_json" \
    '{
      phase: $phase,
      decision: $decision,
      feedback: $feedback,
      skipped: $skipped,
      timestamp: $ts
    }')

  context=$(echo "$context" | jq ".checkpoints += [$checkpoint]")
  context_set "$context"

  log_info "Recorded checkpoint: $phase_id -> $decision"
}

# ============================================================================
# Gap Check Tracking
# ============================================================================

record_gap_check() {
  local phase_id=$1
  local status=$2
  local gaps_json=$3
  local action=${4:-""}
  local agents_json=${5:-"[]"}

  local iteration=$(phase_get_iteration_count "$phase_id")
  local timestamp=$(timestamp_iso8601)
  local context=$(context_get)

  local gap_check=$(jq -n \
    --arg phase "$phase_id" \
    --arg status "$status" \
    --arg action "$action" \
    --arg ts "$timestamp" \
    --argjson iteration "$iteration" \
    --argjson gaps "$gaps_json" \
    --argjson agents "$agents_json" \
    '{
      phase: $phase,
      iteration: $iteration,
      status: $status,
      gaps: $gaps,
      action_taken: $action,
      agents_spawned: $agents,
      timestamp: $ts
    }')

  context=$(echo "$context" | jq ".gap_checks += [$gap_check]")
  context_set "$context"

  log_debug "Recorded gap check: $phase_id -> $status"
}

# ============================================================================
# Skip Phase Management
# ============================================================================

add_skip_phases() {
  local phases_json=$1
  local context=$(context_get)

  context=$(echo "$context" | jq ".skip_phases += $phases_json | .skip_phases | unique")
  context_set "$context"

  local count=$(echo "$phases_json" | jq 'length')
  log_info "Added $count phases to skip list"
}

should_skip_phase() {
  local phase_id=$1

  # Return false (don't skip) if context not initialized yet
  if [ -z "$CONTEXT_FILE" ] || [ ! -f "$CONTEXT_FILE" ]; then
    return 1
  fi

  local skip_list=$(context_read '.skip_phases')
  echo "$skip_list" | jq -e ". | index(\"$phase_id\")" > /dev/null
}

# ============================================================================
# Snapshot & Backup
# ============================================================================

save_snapshot() {
  local label=${1:-"snapshot"}
  if [ -z "$CONTEXT_FILE" ] || [ ! -f "$CONTEXT_FILE" ]; then
    log_error "Context not initialized"
    return 1
  fi

  local backup_file="${CONTEXT_FILE}.${label}.$(date +%s)"
  cp "$CONTEXT_FILE" "$backup_file"
  log_info "Saved context snapshot: $backup_file"
  echo "$backup_file"
}

restore_snapshot() {
  local backup_file=$1
  if [ ! -f "$backup_file" ]; then
    log_error "Backup file not found: $backup_file"
    return 1
  fi

  cp "$backup_file" "$CONTEXT_FILE"
  log_info "Restored context from: $backup_file"
}

# ============================================================================
# Query Functions
# ============================================================================

get_current_phase() {
  context_read '.phases.current'
}

get_completed_phases() {
  context_read '.phases.completed'
}

get_subagents_spawned_count() {
  context_read '.subagents_spawned'
}

get_deliverables() {
  context_read '.deliverables'
}

get_deliverables_for_phase() {
  local phase_id=$1
  context_read ".deliverables[] | select(.phase == \"$phase_id\")"
}

context_get_feature_name() {
  context_read '.feature.name'
}

context_get_feature_flags() {
  context_read '.feature.flags'
}

context_get_workflow_name() {
  context_read '.workflow.name'
}

context_get_output_dir() {
  local feature=$(context_get_feature_name)
  echo ".temp/${feature}"
}

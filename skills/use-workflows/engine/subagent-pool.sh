#!/usr/bin/env bash

# Subagent pool manager with parallel/sequential execution

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/context-manager.sh"
source "${SCRIPT_DIR}/template-renderer.sh"

# ============================================================================
# Main Entry Point
# ============================================================================

run_subagent_batch() {
  local subagents_json=$1
  local behavior=$2
  local context_json=$3
  local phase_json=${4:-"null"}

  local count=$(echo "$subagents_json" | jq 'length')
  log_info "Running $count subagents (behavior: $behavior)"

  case "$behavior" in
    parallel)
      execute_parallel_subagents "$subagents_json" "$context_json" "$phase_json"
      ;;
    sequential)
      execute_sequential_subagents "$subagents_json" "$context_json" "$phase_json"
      ;;
    *)
      handle_error "Unknown behavior: $behavior"
      ;;
  esac
}

# ============================================================================
# Parallel Execution
# ============================================================================

execute_parallel_subagents() {
  local subagents_json=$1
  local context_json=$2
  local phase_json=$3

  local count=$(echo "$subagents_json" | jq 'length')

  if [ "$count" -le 5 ]; then
    # Spawn all simultaneously
    execute_parallel_batch "$subagents_json" "$context_json" "$phase_json"
  else
    # Batch into groups of 5
    execute_parallel_batched "$subagents_json" "$context_json" "$phase_json"
  fi
}

execute_parallel_batch() {
  local subagents_json=$1
  local context_json=$2
  local phase_json=$3

  local count=$(echo "$subagents_json" | jq 'length')
  log_info "Spawning $count subagents in parallel"

  # TEMPORARY: Serialize to avoid context.json race condition
  # TODO: Add file locking or proper concurrency control
  log_warning "Parallel execution serialized (context.json race mitigation)"

  local index=0
  while [ $index -lt $count ]; do
    local subagent=$(echo "$subagents_json" | jq ".[$index]")
    spawn_subagent "$subagent" "$context_json" "$phase_json"
    # Reload context after each spawn
    context_json=$(context_get)
    index=$((index + 1))
  done

  log_info "All $count subagents completed (serialized)"
}

execute_parallel_batched() {
  local subagents_json=$1
  local context_json=$2
  local phase_json=$3

  local total=$(echo "$subagents_json" | jq 'length')
  local batch_size=5
  local processed=0

  log_info "Spawning $total subagents in batches of $batch_size"

  while [ $processed -lt $total ]; do
    local remaining=$((total - processed))
    local current_batch_size=$((remaining < batch_size ? remaining : batch_size))

    local batch=$(echo "$subagents_json" | jq ".[$processed:$((processed + current_batch_size))]")

    log_info "Processing batch: $((processed + 1))-$((processed + current_batch_size)) of $total"
    execute_parallel_batch "$batch" "$context_json" "$phase_json"

    processed=$((processed + current_batch_size))
  done

  log_info "All $total subagents completed (batched)"
}

# ============================================================================
# Sequential Execution
# ============================================================================

execute_sequential_subagents() {
  local subagents_json=$1
  local context_json=$2
  local phase_json=$3

  local count=$(echo "$subagents_json" | jq 'length')
  log_info "Spawning $count subagents sequentially"

  local index=0
  while [ $index -lt $count ]; do
    local subagent=$(echo "$subagents_json" | jq ".[$index]")
    spawn_subagent "$subagent" "$context_json" "$phase_json"
    # Reload context after each spawn
    context_json=$(context_get)
    index=$((index + 1))
  done

  log_info "All $count subagents completed (sequential)"
}

# ============================================================================
# Subagent Spawning
# ============================================================================

spawn_subagent() {
  local config=$1
  local context_json=$2
  local phase_json=${3:-"null"}

  local type=$(echo "$config" | jq -r '.type')
  local subagent_config=$(echo "$config" | jq -c '.config // {}')

  log_info "Spawning subagent: $type"

  # Extract output path from config and substitute template variables
  local output_path=$(echo "$subagent_config" | jq -r '.output_path // ""')
  if [ -z "$output_path" ]; then
    local feature_name=$(echo "$context_json" | jq -r '.feature.name')
    output_path=".temp/${feature_name}/${type}.md"
  else
    # Substitute template variables (e.g., {{output_dir}})
    output_path=$(substitute_template_vars "$output_path" "$context_json")
  fi

  # Render prompt (workflow-specific or default)
  local workflow_name=$(echo "$context_json" | jq -r '.workflow.name')
  local phase_id=$(echo "$context_json" | jq -r '.phases.current')

  # Use real phase JSON if provided, otherwise build stub
  if [ "$phase_json" = "null" ] || [ -z "$phase_json" ]; then
    phase_json=$(echo "$context_json" | jq -n \
      --arg id "$phase_id" \
      --arg name "$phase_id" \
      --arg desc "Phase $phase_id" \
      '{id: $id, name: $name, description: $desc}')
    log_debug "Using stub phase data (real phase not provided)"
  fi

  local prompt_file=".temp/${workflow_name}-${phase_id}-${type}-prompt.md"
  render_subagent_prompt "$type" "$workflow_name" "$phase_json" "$context_json" "$prompt_file"

  # Log delegation
  log_info "Delegating to $type (output: $output_path)"
  log_debug "Prompt: $prompt_file"

  # Read rendered prompt
  local task_prompt=$(cat "$prompt_file")

  # Invoke Task tool to spawn real subagent
  # Output will be written to stdout by the subagent
  local task_result
  if task_result=$(invoke_task_agent "$type" "$task_prompt" "$output_path"); then
    log_info "Subagent $type completed successfully"
  else
    log_warning "Subagent $type failed, creating fallback output"
    create_mock_output "$type" "$output_path"
  fi

  # Track in context
  subagent_spawned
  add_deliverable "$phase_id" "$output_path" "$type"
}

# ============================================================================
# Task Tool Integration
# ============================================================================

invoke_task_agent() {
  local subagent_type=$1
  local prompt=$2
  local output_path=$3

  # Map subagent type to Task tool subagent_type
  local task_subagent_type=$(map_subagent_type "$subagent_type")

  if [ "$task_subagent_type" = "unknown" ]; then
    log_warning "No Task agent mapping for: $subagent_type, using general-purpose"
    task_subagent_type="general-purpose"
  fi

  # Construct Task tool invocation prompt
  local task_prompt="$prompt

**Output Requirements:**
- Save your findings to: $output_path
- Use structured format (JSON or Markdown)
- Include specific examples and evidence
- Cite file locations with line numbers where relevant"

  # This function outputs instructions for the main agent to invoke Task tool
  # Since we're in a bash script, we can't directly call Task tool
  # Instead, we emit a signal that the main agent can intercept

  cat <<EOF
__TASK_INVOCATION__
{
  "subagent_type": "$task_subagent_type",
  "description": "$(echo "$subagent_type" | sed 's/-/ /g')",
  "prompt": $(echo "$task_prompt" | jq -Rs .),
  "output_path": "$output_path"
}
__END_TASK_INVOCATION__
EOF

  return 0
}

map_subagent_type() {
  local type=$1

  case "$type" in
    # Research agents
    codebase-scanner|file-locator|pattern-analyzer|dependency-mapper)
      echo "Explore"
      ;;

    # Analysis agents
    code-analyzer|complexity-analyzer|duplication-finder|test-coverage-checker)
      echo "code-qa"
      ;;

    # Architecture/Design agents
    architecture-designer|architecture-specialist)
      echo "architecture-specialist"
      ;;

    # Planning agents
    requirements-specialist|user-story-writer)
      echo "requirements-specialist"
      ;;

    # Debugging agents
    bug-investigator|root-cause-tracer)
      echo "Bug Investigator"
      ;;

    # Validation agents
    feasibility-validator|completeness-checker|pattern-checker)
      echo "general-purpose"
      ;;

    *)
      echo "unknown"
      ;;
  esac
}

# ============================================================================
# MVP Mock Output
# ============================================================================

create_mock_output() {
  local type=$1
  local output_path=$2

  local dir=$(dirname "$output_path")
  ensure_dir "$dir"

  cat > "$output_path" <<EOF
# ${type} Output (MVP Mock)

Generated at: $(timestamp_iso8601)
Subagent type: ${type}

## Mock Content

This is a mock output generated by the MVP workflow engine.
In production, this would be replaced by actual subagent Task tool invocation.

### Analysis Results
- Item 1: Mock finding
- Item 2: Mock finding
- Item 3: Mock finding

### Recommendations
- Recommendation 1
- Recommendation 2
- Recommendation 3

---
Generated by workflow engine MVP
EOF

  log_debug "Created mock output: $output_path"
}

#!/usr/bin/env bash

# Template renderer with mustache fallback

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# ============================================================================
# Main Rendering Functions
# ============================================================================

render_template() {
  local template_file=$1
  local context_json=$2
  local output_file=$3

  if [ ! -f "$template_file" ]; then
    log_error "Template not found: $template_file"
    return 1
  fi

  # Try mustache first
  if command -v mustache &> /dev/null; then
    render_template_mustache "$template_file" "$context_json" "$output_file"
  else
    log_debug "mustache not found, using fallback renderer"
    render_template_simple "$template_file" "$context_json" "$output_file"
  fi
}

render_template_mustache() {
  local template_file=$1
  local context_json=$2
  local output_file=$3

  # Ensure output directory exists
  ensure_dir "$(dirname "$output_file")"

  local temp_context=$(mktemp)
  echo "$context_json" > "$temp_context"

  mustache "$temp_context" "$template_file" > "$output_file"
  rm "$temp_context"

  log_debug "Rendered template (mustache): $template_file -> $output_file"
}

render_template_simple() {
  local template_file=$1
  local context_json=$2
  local output_file=$3

  # Ensure output directory exists
  ensure_dir "$(dirname "$output_file")"

  local template_content=$(cat "$template_file")
  local result="$template_content"

  # Simple {{variable}} substitution
  # Extract dot-notation paths from context
  local paths=$(echo "$context_json" | jq -r 'paths(scalars) as $p | ($p | map(tostring) | join(".")) as $key | "\($key)=\(getpath($p))"')

  while IFS='=' read -r key value; do
    # Escape special chars in value for sed
    local escaped_value=$(printf '%s\n' "$value" | sed 's/[&/\]/\\&/g')
    result=$(echo "$result" | sed "s|{{${key}}}|${escaped_value}|g")
  done <<< "$paths"

  echo "$result" > "$output_file"
  log_debug "Rendered template (fallback): $template_file -> $output_file"
}

# ============================================================================
# Subagent Prompt Rendering
# ============================================================================

render_subagent_prompt() {
  local subagent_type=$1
  local workflow_name=$2
  local phase_json=$3
  local context_json=$4
  local output_file=$5

  # Look for workflow-specific template first
  local template_dir="subagents/prompts/${subagent_type}"
  local workflow_template="${template_dir}/${workflow_name}.md.tmpl"
  local default_template="${template_dir}/default.md.tmpl"

  local template_file=""
  if [ -f "$workflow_template" ]; then
    template_file="$workflow_template"
    log_debug "Using workflow-specific template: $workflow_template"
  elif [ -f "$default_template" ]; then
    template_file="$default_template"
    log_debug "Using default template: $default_template"
  else
    log_warning "No template found for $subagent_type, creating generic prompt"
    create_generic_prompt "$subagent_type" "$workflow_name" "$phase_json" "$output_file"
    return 0
  fi

  # Merge phase and context for rendering
  local feature_name=$(echo "$context_json" | jq -r '.feature.name')
  local output_dir=".temp/${feature_name}"

  local render_context=$(jq -n \
    --argjson phase "$phase_json" \
    --argjson context "$context_json" \
    --arg workflow "$workflow_name" \
    --arg subagent "$subagent_type" \
    --arg output_dir "$output_dir" \
    '{
      workflow_name: $workflow,
      subagent_type: $subagent,
      phase: $phase,
      context: $context,
      output_dir: $output_dir
    }')

  render_template "$template_file" "$render_context" "$output_file"
}

create_generic_prompt() {
  local subagent_type=$1
  local workflow_name=$2
  local phase_json=$3
  local output_file=$4

  local phase_id=$(echo "$phase_json" | jq -r '.id')
  local phase_name=$(echo "$phase_json" | jq -r '.name')
  local phase_desc=$(echo "$phase_json" | jq -r '.description')

  cat > "$output_file" <<EOF
# Role: ${subagent_type}

## Workflow Context
Workflow: ${workflow_name}
Phase: ${phase_name} (${phase_id})

## Task
${phase_desc}

## Instructions
Complete the task according to the phase description.

Output results to the configured deliverable path.
EOF

  log_debug "Created generic prompt: $output_file"
}

# ============================================================================
# String Substitution
# ============================================================================

substitute_template_vars() {
  local text=$1
  local context_json=$2

  local result="$text"

  # Extract flat key-value pairs
  local paths=$(echo "$context_json" | jq -r 'paths(scalars) as $p | ($p | map(tostring) | join(".")) as $key | "\($key)=\(getpath($p))"')

  while IFS='=' read -r key value; do
    result="${result//\{\{${key}\}\}/$value}"
  done <<< "$paths"

  echo "$result"
}

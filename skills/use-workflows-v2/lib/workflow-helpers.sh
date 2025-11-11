#!/usr/bin/env bash

# ============================================================================
# Shared Workflow Helper Functions
# ============================================================================
# Purpose: Centralized library for common functions used across workflow scripts
# ============================================================================

# Source constants
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${LIB_DIR}/constants.sh"

# SCRIPT_DIR should be set by the calling script (skill root)
# If not set, calculate it from lib directory
if [[ -z "${SCRIPT_DIR:-}" ]]; then
  SCRIPT_DIR="$(cd "${LIB_DIR}/.." && pwd)"
fi

# Capitalize first letter
capitalize() {
  local word="$1"
  local first=$(echo "$word" | cut -c1 | tr '[:lower:]' '[:upper:]')
  local rest=$(echo "$word" | cut -c2-)
  echo "${first}${rest}"
}

# Normalize a base directory path
normalize_base_dir() {
  local raw_base_dir="${1:-$DEFAULT_BASE_DIR}"

  if [[ -z "$raw_base_dir" ]]; then
    raw_base_dir="$DEFAULT_BASE_DIR"
  fi

  # Expand leading tilde
  raw_base_dir="${raw_base_dir/#\~/$HOME}"

  # Trim trailing slashes (but leave root / alone)
  if [[ "$raw_base_dir" != "/" ]]; then
    raw_base_dir="${raw_base_dir%/}"
  fi

  if [[ -z "$raw_base_dir" ]]; then
    raw_base_dir="$DEFAULT_BASE_DIR"
  fi

  if [[ ! "$raw_base_dir" =~ $BASE_DIR_PATTERN ]]; then
    echo "Error: Invalid base directory path '$raw_base_dir'. Allowed characters: A-Za-z0-9._~/-" >&2
    return 1
  fi

  echo "$raw_base_dir"
}

# Calculate the output directory name for a phase
calculate_output_dir() {
  local phase_number=$1
  local phase_name=$2
  printf "$PHASE_DIR_FORMAT" "$phase_number" "$phase_name"
}

# Build a JSON object of phase directories
build_phase_dirs() {
  local phases_json=$1
  local current_index=$2

  if [[ -z "$phases_json" || "$phases_json" == "null" ]]; then
    echo "{}"
    return 0
  fi

  local phase_dirs="{}"
  local total_phases=$(echo "$phases_json" | jq 'length')

  if [[ "$current_index" -lt 0 ]]; then
    current_index=0
  fi

  for ((i=0; i<=current_index && i<total_phases; i++)); do
    local phase_name
    phase_name=$(echo "$phases_json" | jq -r ".[${i}]")
    [[ -z "$phase_name" || "$phase_name" == "null" ]] && continue
    local dir
    dir=$(calculate_output_dir "$((i + 1))" "$phase_name")
    phase_dirs=$(echo "$phase_dirs" | jq --arg key "$phase_name" --arg val "$dir" '. + {($key): $val}')
  done

  echo "$phase_dirs"
}

# Build the complete data package for a single phase
build_phase_data() {
  local phase=$1
  local phase_number=$2
  local feature_name=$3
  local workflow=$4
  local scope=$5
  local workflow_json=$6
  local phases_json=$7
  local base_dir=$8
  local conditions_json=${9:-'[]'}

  local output_dir
  output_dir=$(calculate_output_dir "$phase_number" "$phase")

  local workspace="${base_dir}/${feature_name}"

  local phase_dirs
  phase_dirs=$(build_phase_dirs "$phases_json" "$((phase_number - 1))")

  local phase_paths="{}"
  if [[ $(echo "$phase_dirs" | jq 'length') -gt 0 ]]; then
    while IFS= read -r phase_key; do
      [[ -z "$phase_key" ]] && continue
      local dir_path
      dir_path=$(echo "$phase_dirs" | jq -r --arg key "$phase_key" '.[$key]')
      [[ -z "$dir_path" || "$dir_path" == "null" ]] && continue
      phase_paths=$(echo "$phase_paths" | jq --arg key "$phase_key" --arg value "${workspace}/${dir_path}" '. + {($key): $value}')
    done < <(echo "$phase_dirs" | jq -r 'keys[]?')
  fi

  # Get subagents for this phase
  local subagent_types
  subagent_types=$(get_phase_subagents "$workflow_json" "$phase" "$scope" "$conditions_json" | tr '\n' ' ')
  local registry_path="${SCRIPT_DIR}/${REGISTRY_FILE_PATTERN}"

  local subagents_json="[]"
  if [[ -n "$subagent_types" ]]; then
    subagents_json=$(build_all_subagents_data "$subagent_types" "$workflow" "$feature_name" "$scope" "$registry_path")
  fi

  local subagent_count=$(echo "$subagents_json" | jq 'length')

  # Get gap checks for this phase
  local gap_criteria=$(echo "$workflow_json" | jq ".gap_checks[\"${phase}\"].criteria // []")
  local gap_options=$(echo "$workflow_json" | jq ".gap_checks[\"${phase}\"].on_failure // [] | to_entries | map({index: (.key + 1), value: .value})")

  # Get checkpoint for this phase (if exists)
  local checkpoint=$(echo "$workflow_json" | jq "[.checkpoints[]? | select(.after == \"${phase}\")] | if length > 0 then .[0] else null end")

  if [[ "$checkpoint" != "null" ]]; then
    checkpoint=$(echo "$checkpoint" | jq 'if .options then .options |= (to_entries | map({index: (.key + 1), value: .value})) else . end')
  fi

  local output_templates_config
  output_templates_config=$(echo "$workflow_json" | jq ".subagent_outputs[\"${phase}\"] // {}")

  local deliverables="[]"
  if [[ "$subagent_count" -gt 0 ]]; then
    for ((i=0; i<subagent_count; i++)); do
      local subagent_json
      subagent_json=$(echo "$subagents_json" | jq ".[$i]")
      local subagent_type
      subagent_type=$(echo "$subagent_json" | jq -r '.type')
      local default_filename
      default_filename=$(echo "$subagent_json" | jq -r '.deliverable_filename')
      local default_description
      default_description=$(echo "$subagent_json" | jq -r '.task_description')

      local template_entries_raw
      template_entries_raw=$(echo "$output_templates_config" | jq ".\"${subagent_type}\" // empty")
      local template_entries="[]"
      local template_count=0
      if [[ -n "$template_entries_raw" && "$template_entries_raw" != "null" ]]; then
        local value_type
        value_type=$(echo "$template_entries_raw" | jq -r 'type')
        case "$value_type" in
          string)
            template_entries=$(echo "$template_entries_raw" | jq -c '[{filename: ., template: .}]')
            ;;
          array)
            template_entries=$(echo "$template_entries_raw" | jq -c '[ .[] | if type == "string" then {filename: ., template: .} elif type == "object" then . else empty end ]')
            ;;
          object)
            template_entries=$(echo "$template_entries_raw" | jq -c '[.]')
            ;;
        esac
        template_count=$(echo "$template_entries" | jq 'length')
      fi

      if [[ "$template_count" -gt 0 ]]; then
        for ((j=0; j<template_count; j++)); do
          local template_entry
          template_entry=$(echo "$template_entries" | jq ".[$j]")

          local configured_filename
          configured_filename=$(echo "$template_entry" | jq -r '.filename // empty')
          local filename="$configured_filename"
          [[ -z "$filename" || "$filename" == "null" ]] && filename="$default_filename"

          local configured_description
          configured_description=$(echo "$template_entry" | jq -r '.description // empty')
          local description="$configured_description"
          [[ -z "$description" || "$description" == "null" ]] && description="$default_description"

          local template_name
          template_name=$(echo "$template_entry" | jq -r '.template // empty')
          if [[ -z "$template_name" || "$template_name" == "null" ]]; then
            template_name="$filename"
          fi

          local extension=""
          if [[ "$filename" == *.* ]]; then
            extension="${filename##*.}"
          fi

          local resolved_template_path=""
          if [[ -n "$template_name" && "$template_name" != "null" ]]; then
            if [[ "$template_name" == *"$TEMPLATE_EXTENSION" ]]; then
              resolved_template_path="${SCRIPT_DIR}/${OUTPUT_TEMPLATES_DIR}/${template_name}"
            else
              resolved_template_path="${SCRIPT_DIR}/${OUTPUT_TEMPLATES_DIR}/${template_name}${TEMPLATE_EXTENSION}"
            fi
          fi

          local template_json="null"
          local has_template="false"
          local template_extension="$extension"
          if [[ -n "$resolved_template_path" ]]; then
            if [[ -f "$resolved_template_path" ]]; then
              template_json=$(jq -Rs '.' < "$resolved_template_path")
              has_template="true"
              local template_file_ext="${resolved_template_path##*.}"
              if [[ "$template_file_ext" != "${TEMPLATE_EXTENSION#.}" && -n "$template_file_ext" ]]; then
                template_extension="$template_file_ext"
              fi
            else
              echo "Warning: Output template not found: $resolved_template_path" >&2
            fi
          fi

          deliverables=$(echo "$deliverables" | jq \
            --arg filename "$filename" \
            --arg description "$description" \
            --arg output_dir "$output_dir" \
            --arg workspace "$workspace" \
            --arg extension "$extension" \
            --arg template_extension "$template_extension" \
            --arg subagent "$subagent_type" \
            --arg template_name "$template_name" \
            --arg has_template "$has_template" \
            --argjson template_content "$template_json" \
            '. + [{
              filename: $filename,
              description: $description,
              output_dir: $output_dir,
              workspace: $workspace,
              full_path: ($workspace + "/" + $output_dir + "/" + $filename),
              subagent: $subagent,
              extension: $extension,
              template_name: $template_name,
              template_extension: (if ($template_extension | length) > 0 then $template_extension else $extension end),
              template_content: (if $has_template == "true" then $template_content else null end),
              has_template: ($has_template == "true"),
              validation_checks: [
                "File exists",
                "File is valid format",
                "File contains expected data"
              ]
            }]')
        done
      else
        local filename="$default_filename"
        local extension=""
        if [[ "$filename" == *.* ]]; then
          extension="${filename##*.}"
        fi

        deliverables=$(echo "$deliverables" | jq \
          --arg filename "$filename" \
          --arg description "$default_description" \
          --arg output_dir "$output_dir" \
          --arg workspace "$workspace" \
          --arg extension "$extension" \
          --arg template_extension "$extension" \
          --arg subagent "$subagent_type" \
          '. + [{
            filename: $filename,
            description: $description,
            output_dir: $output_dir,
            workspace: $workspace,
            full_path: ($workspace + "/" + $output_dir + "/" + $filename),
            subagent: $subagent,
            extension: $extension,
            template_name: "",
            template_extension: $template_extension,
            template_content: null,
            has_template: false,
            validation_checks: [
              "File exists",
              "File is valid format",
              "File contains expected data"
            ]
          }]')
      fi
    done
  fi

  # Enrich subagents with their configured deliverable filenames
  # Match deliverables to subagents by subagent type
  if [[ "$subagent_count" -gt 0 && $(echo "$deliverables" | jq 'length') -gt 0 ]]; then
    local enriched_subagents="[]"
    for ((i=0; i<subagent_count; i++)); do
      local subagent=$(echo "$subagents_json" | jq ".[$i]")
      local subagent_type=$(echo "$subagent" | jq -r '.type')

      # Find matching deliverable for this subagent
      local matching_deliverable=$(echo "$deliverables" | jq "[.[] | select(.subagent == \"$subagent_type\")] | .[0] // null")

      if [[ "$matching_deliverable" != "null" ]]; then
        # Add configured filename to subagent
        local configured_filename=$(echo "$matching_deliverable" | jq -r '.filename')
        subagent=$(echo "$subagent" | jq --arg filename "$configured_filename" '. + {configured_filename: $filename}')
      fi

      enriched_subagents=$(echo "$enriched_subagents" | jq --argjson subagent "$subagent" '. + [$subagent]')
    done
    subagents_json="$enriched_subagents"
  fi

  local checkpoint_prompt=""
  local checkpoint_show_files="[]"
  local checkpoint_options="[]"
  if [[ "$checkpoint" != "null" ]]; then
    checkpoint_prompt=$(echo "$checkpoint" | jq -r '.prompt // ""')
    checkpoint_show_files=$(echo "$checkpoint" | jq '.show_files // []')
    checkpoint_options=$(echo "$checkpoint" | jq '.options // []')
  fi

  # Extract individual phase paths for easier template access
  # Convert hyphenated phase names to underscored variables
  local problem_understanding_path=$(echo "$phase_paths" | jq -r '."problem-understanding" // ""')
  local codebase_investigation_path=$(echo "$phase_paths" | jq -r '."codebase-investigation" // ""')
  local external_research_path=$(echo "$phase_paths" | jq -r '."external-research" // ""')
  local solution_synthesis_path=$(echo "$phase_paths" | jq -r '."solution-synthesis" // ""')
  local introspection_path=$(echo "$phase_paths" | jq -r '."introspection" // ""')
  local approach_refinement_path=$(echo "$phase_paths" | jq -r '."approach-refinement" // ""')

  jq -n \
    --arg phase "$phase" \
    --argjson phase_number "$phase_number" \
    --arg feature_name "$feature_name" \
    --arg workflow "$workflow" \
    --arg scope "$scope" \
    --arg base_dir "$base_dir" \
    --arg workspace "$workspace" \
    --arg output_dir "$output_dir" \
    --argjson phase_dirs "$phase_dirs" \
    --argjson phase_paths "$phase_paths" \
    --arg problem_understanding_path "$problem_understanding_path" \
    --arg codebase_investigation_path "$codebase_investigation_path" \
    --arg external_research_path "$external_research_path" \
    --arg solution_synthesis_path "$solution_synthesis_path" \
    --arg introspection_path "$introspection_path" \
    --arg approach_refinement_path "$approach_refinement_path" \
    --argjson subagents "$subagents_json" \
    --argjson subagent_count "$subagent_count" \
    --argjson gap_criteria "$gap_criteria" \
    --argjson gap_options "$gap_options" \
    --argjson checkpoint "$checkpoint" \
    --argjson deliverables "$deliverables" \
    --arg checkpoint_prompt "$checkpoint_prompt" \
    --argjson checkpoint_show_files "$checkpoint_show_files" \
    --argjson checkpoint_options "$checkpoint_options" \
    '{
      phase_name: $phase,
      phase_number: $phase_number,
      feature_name: $feature_name,
      workflow: $workflow,
      scope: $scope,
      base_dir: $base_dir,
      workspace: $workspace,
      output_dir: $output_dir,
      phase_dirs: $phase_dirs,
      phase_paths: $phase_paths,
      problem_understanding_path: $problem_understanding_path,
      codebase_investigation_path: $codebase_investigation_path,
      external_research_path: $external_research_path,
      solution_synthesis_path: $solution_synthesis_path,
      introspection_path: $introspection_path,
      approach_refinement_path: $approach_refinement_path,
      subagents: $subagents,
      subagent_count: $subagent_count,
      gap_criteria: $gap_criteria,
      gap_options: $gap_options,
      checkpoint: $checkpoint,
      deliverables: $deliverables,
      checkpoint_prompt: $checkpoint_prompt,
      checkpoint_show_files: $checkpoint_show_files,
      checkpoint_options: $checkpoint_options
    }'
}

# Find workflow file in plugin directories (XDG convention)
# Priority: project → user → built-in
# Returns: workflow_file_path|source_type (e.g., "/path/to/file.yaml|project")
find_workflow_file() {
    local workflow_name=$1
    local script_dir=$2

    # Define search paths in priority order
    local project_workflows="./.claude/workflows"
    local user_workflows="$HOME/.claude/workflows"
    local builtin_workflows="${script_dir}/${WORKFLOWS_DIR}"

    # 1. Project-level (highest priority)
    if [[ -f "${project_workflows}/${workflow_name}${YAML_EXTENSION}" ]]; then
        echo "${project_workflows}/${workflow_name}${YAML_EXTENSION}|project"
        return 0
    fi

    # 2. User-level
    if [[ -f "${user_workflows}/${workflow_name}${YAML_EXTENSION}" ]]; then
        echo "${user_workflows}/${workflow_name}${YAML_EXTENSION}|user"
        return 0
    fi

    # 3. Built-in (lowest priority)
    if [[ -f "${builtin_workflows}/${workflow_name}${YAML_EXTENSION}" ]]; then
        echo "${builtin_workflows}/${workflow_name}${YAML_EXTENSION}|builtin"
        return 0
    fi

    return 1
}

# List all available workflows from all locations
list_available_workflows() {
    local script_dir=$1
    local workflows=()

    # Built-in workflows
    if [[ -d "${script_dir}/${WORKFLOWS_DIR}" ]]; then
        while IFS= read -r file; do
            [[ -f "$file" ]] && workflows+=("$(basename "$file" ${YAML_EXTENSION}) [built-in]")
        done < <(find "${script_dir}/${WORKFLOWS_DIR}" -maxdepth 1 -name "*${YAML_EXTENSION}" 2>/dev/null)
    fi

    # User-level workflows
    if [[ -d "$HOME/.claude/workflows" ]]; then
        while IFS= read -r file; do
            [[ -f "$file" ]] && workflows+=("$(basename "$file" ${YAML_EXTENSION}) [user]")
        done < <(find "$HOME/.claude/workflows" -maxdepth 1 -name "*${YAML_EXTENSION}" 2>/dev/null)
    fi

    # Project-level workflows
    if [[ -d "./.claude/workflows" ]]; then
        while IFS= read -r file; do
            [[ -f "$file" ]] && workflows+=("$(basename "$file" ${YAML_EXTENSION}) [project]")
        done < <(find "./.claude/workflows" -maxdepth 1 -name "*${YAML_EXTENSION}" 2>/dev/null)
    fi

    printf '%s\n' "${workflows[@]}" | sort
}

# Validate and load a workflow file (with plugin support)
# Returns JSON with workflow content and metadata
load_and_validate_workflow() {
    local workflow_name=$1
    local script_dir=$2

    # Try to find workflow in plugin directories
    local result
    if ! result=$(find_workflow_file "$workflow_name" "$script_dir"); then
        echo "Error: Workflow '$workflow_name' not found" >&2
        echo "  Searched in:" >&2
        echo "    - ./.claude/workflows/ (project-level)" >&2
        echo "    - ~/.claude/workflows/ (user-level)" >&2
        echo "    - ${script_dir}/${WORKFLOWS_DIR}/ (built-in)" >&2
        echo "" >&2
        echo "  Available workflows:" >&2
        list_available_workflows "$script_dir" | sed 's/^/    - /' >&2
        return 1
    fi

    # Extract workflow file path and source type
    local workflow_file="${result%|*}"
    local source_type="${result#*|}"
    local workflow_dir="$(dirname "$workflow_file")"

    # Load the workflow JSON
    local workflow_json
    if ! workflow_json=$(load_workflow "$workflow_file"); then
        return 1
    fi

    # Return JSON object with workflow content and metadata
    jq -n \
        --arg workflow_dir "$workflow_dir" \
        --arg source_type "$source_type" \
        --arg file_path "$workflow_file" \
        --argjson workflow_json "$workflow_json" \
        '{
            workflow_json: $workflow_json,
            workflow_dir: $workflow_dir,
            workflow_source_type: $source_type,
            workflow_file_path: $file_path
        }'
}

# Parse common arguments
parse_common_args() {
  # This function is designed to be called with all script arguments.
  # It will parse common flags and echo back the remaining arguments.
  # It sets global variables for the parsed values.

  # Global variables that will be set
  BASE_DIR_VALUE=""
  REMAINING_ARGS=()

  local args_to_parse=($@)
  local i=0
  while [[ $i -lt ${#args_to_parse[@]} ]]; do
    local arg="${args_to_parse[$i]}"
    case "$arg" in
      --base-dir)
        if [[ $i+1 -ge ${#args_to_parse[@]} ]]; then
          echo "Error: --base-dir flag requires a path argument" >&2
          exit 1
        fi
        BASE_DIR_VALUE="${args_to_parse[$i+1]}"
        ((i+=2))
        ;; 
      --base-dir=*)
        BASE_DIR_VALUE="${arg#--base-dir=}"
        ((i+=1))
        ;; 
      *)
        REMAINING_ARGS+=("$arg")
        ((i+=1))
        ;; 
    esac
  done
}

# Initialize workflow context - common setup for workflow scripts
# Args: workflow_name, script_dir, remaining_args...
# Output: JSON object with all initialized context data
# Returns: 0 on success, 1 on failure
initialize_workflow_context() {
  local workflow_name=$1
  local script_dir=$2
  shift 2
  local remaining_args=("$@")

  # Parse common args from remaining arguments
  parse_common_args "${remaining_args[@]}"
  
  # Extract flags from REMAINING_ARGS
  local flags=()
  if [[ ${#REMAINING_ARGS[@]} -gt 0 ]]; then
    flags=("${REMAINING_ARGS[@]}")
  fi

  # Normalize base directory
  local base_dir
  if ! base_dir=$(normalize_base_dir "${BASE_DIR_VALUE:-$DEFAULT_BASE_DIR}"); then
    return 1
  fi

  # Load and validate workflow (returns JSON with workflow + metadata)
  local workflow_data
  if ! workflow_data=$(load_and_validate_workflow "$workflow_name" "$script_dir"); then
    return 1
  fi

  # Extract workflow JSON and metadata
  local workflow_json=$(echo "$workflow_data" | jq -c '.workflow_json')
  local workflow_dir=$(echo "$workflow_data" | jq -r '.workflow_dir')
  local workflow_source_type=$(echo "$workflow_data" | jq -r '.workflow_source_type')
  local workflow_file_path=$(echo "$workflow_data" | jq -r '.workflow_file_path')

  # Extract workflow metadata
  local workflow_desc=$(get_workflow_field "$workflow_json" "description")
  local estimated_time=$(get_workflow_field "$workflow_json" "estimated_time")
  local estimated_tokens=$(get_workflow_field "$workflow_json" "estimated_tokens")

  # Get phases
  local phases=($(get_phases "$workflow_json"))
  local phases_json="[]"
  if [[ ${#phases[@]} -gt 0 ]]; then
    phases_json=$(printf '%s\n' "${phases[@]}" | jq -R . | jq -s .)
  fi

  # Extract conditions
  local conditions_json
  conditions_json=$(extract_conditions "${flags[@]}")

  # Detect scope (filter out --summary/--full flags for scope detection)
  local scope_flags=()
  for flag in "${flags[@]}"; do
    if [[ "$flag" != "--summary" && "$flag" != "--full" ]]; then
      scope_flags+=("$flag")
    fi
  done
  local scope
  if [[ ${#scope_flags[@]} -gt 0 ]]; then
    scope=$(detect_scope "${scope_flags[@]}")
  else
    scope=$(detect_scope)
  fi

  # Build flags string for output
  local flags_string="${flags[*]:-none}"

  # Return as JSON object (workflow_json is already JSON, so embed it directly)
  # Include workflow directory info for custom template resolution
  jq -n \
    --arg workflow "$workflow_name" \
    --arg workflow_desc "$workflow_desc" \
    --arg estimated_time "$estimated_time" \
    --arg estimated_tokens "$estimated_tokens" \
    --arg base_dir "$base_dir" \
    --arg scope "$scope" \
    --arg flags_string "$flags_string" \
    --arg workflow_dir "$workflow_dir" \
    --arg workflow_source_type "$workflow_source_type" \
    --arg workflow_file_path "$workflow_file_path" \
    --argjson workflow_json "$workflow_json" \
    --argjson phases_json "$phases_json" \
    --argjson conditions_json "$conditions_json" \
    --argjson phases_array "$(printf '%s\n' "${phases[@]}" | jq -R . | jq -s .)" \
    '{
      workflow: $workflow,
      workflow_desc: $workflow_desc,
      estimated_time: $estimated_time,
      estimated_tokens: $estimated_tokens,
      base_dir: $base_dir,
      scope: $scope,
      flags_string: $flags_string,
      workflow_dir: $workflow_dir,
      workflow_source_type: $workflow_source_type,
      workflow_file_path: $workflow_file_path,
      workflow_json: $workflow_json,
      phases_json: $phases_json,
      conditions_json: $conditions_json,
      phases_array: $phases_array
    }'
}

# Resolve template path with optional workflow-specific override and custom phase support
check_template_override() {
  local workflow=$1
  local phase=$2
  local script_dir=$3

  # Basic traversal safeguards
  if [[ "$workflow" == *".."* || "$phase" == *".."* || "$workflow" == *"/"* || "$phase" == *"/"* ]]; then
    echo "Error: Invalid workflow or phase name" >&2
    return 1
  fi

  # Validate against patterns
  if ! [[ "$workflow" =~ $WORKFLOW_NAME_PATTERN ]] || ! [[ "$phase" =~ $PHASE_NAME_PATTERN ]]; then
    echo "Error: Workflow and phase names must match required patterns" >&2
    return 1
  fi

  # 1. Check for custom phase templates (if workflow is from custom location)
  if [[ -n "${WORKFLOW_DIR:-}" && "${WORKFLOW_SOURCE_TYPE:-}" != "builtin" ]]; then
    local custom_phase_path="${WORKFLOW_DIR}/phases/${phase}.md"
    if [[ -f "$custom_phase_path" ]]; then
      echo "$custom_phase_path"
      return 0
    fi
  fi

  # 2. Check for workflow-specific override (built-in)
  local override_path="${script_dir}/$(printf "$PHASE_OVERRIDE_PATTERN" "$workflow" "$phase")"
  if [[ -f "$override_path" ]]; then
    echo "$override_path"
    return 0
  fi

  # 3. Check for default phase template (built-in)
  local default_path="${script_dir}/$(printf "$PHASE_DEFAULT_PATTERN" "$phase")"
  if [[ -f "$default_path" ]]; then
    echo "$default_path"
    return 0
  fi

  echo "Error: Template not found for phase '$phase' (workflow: '$workflow')" >&2
  return 1
}

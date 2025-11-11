# Generator Script Architecture

## Overview

The workflow instruction generator is a bash script that:
1. Loads workflow YAML definitions
2. Detects scope from flags (--frontend, --backend, --both)
3. Builds subagent matrix with conditional logic
4. Renders phase modules with variable substitution
5. Outputs complete workflow instructions to stdout

**Entry point:** `generate-workflow-instructions.sh`

**Dependencies:** yq (YAML parser), jq (JSON processor), bash 4+

---

## High-Level Flow

```
┌─────────────────────────────────────────────┐
│  generate-workflow-instructions.sh          │
│  <workflow> <feature-name> [--flags]        │
└──────────────┬──────────────────────────────┘
               │
       ┌───────▼────────┐
       │  Parse Args    │
       │  workflow=$1   │
       │  feature=$2    │
       │  flags=${@:3}  │
       └───────┬────────┘
               │
       ┌───────▼──────────┐
       │  Load Workflow   │
       │  (workflow-parser)│
       └───────┬──────────┘
               │
       ┌───────▼──────────┐
       │  Detect Scope    │
       │  (scope-detector)│
       └───────┬──────────┘
               │
       ┌───────▼──────────────┐
       │  Build Subagent      │
       │  Matrix              │
       │  (subagent-matcher)  │
       └───────┬──────────────┘
               │
       ┌───────▼──────────────┐
       │  For Each Phase:     │
       │  - Load phase module │
       │  - Build phase data  │
       │  - Render template   │
       │  (template-renderer) │
       └───────┬──────────────┘
               │
       ┌───────▼──────────────┐
       │  Output Instructions │
       │  to stdout           │
       └──────────────────────┘
```

---

## Module Architecture

### Core Modules

```
use-workflows-v2/
├── generate-workflow-instructions.sh   # Main entry point
├── fetch-phase-details.sh              # Single phase details script
└── lib/
    ├── workflow-helpers.sh             # Shared helper functions (NEW)
    ├── workflow-parser.sh              # YAML loading and parsing
    ├── scope-detector.sh               # Flag parsing and scope detection
    ├── subagent-matcher.sh             # Conditional subagent selection
    └── template-renderer.sh            # Variable substitution
```

---

## Module 0: workflow-helpers.sh (NEW)

### Purpose
Centralized library providing shared helper functions used across all workflow scripts. Handles base directory normalization, phase path calculations, deliverable assembly, and template override resolution.

### Key Responsibilities
1. **Base Directory Management** - Normalizes and validates base directories
2. **Phase Directory Helpers** - Generates zero-padded phase directory names
3. **Condition Parsing** - Extracts custom --key=value flags from arguments
4. **Deliverable Assembly** - Builds rich metadata for template rendering
5. **Template Override Resolution** - Checks for workflow-specific template overrides

### Functions

#### `normalize_base_dir(raw_path)`
Normalizes a base directory path with validation.

```bash
normalize_base_dir() {
  local raw_base_dir="${1:-$DEFAULT_BASE_DIR}"

  # Expand leading tilde
  raw_base_dir="${raw_base_dir/#\~/$HOME}"

  # Trim trailing slashes
  raw_base_dir="${raw_base_dir%/}"

  # Validate characters
  if [[ ! "$raw_base_dir" =~ ^[A-Za-z0-9._~/-]+$ ]]; then
    echo "Error: Invalid base directory path" >&2
    return 1
  fi

  echo "$raw_base_dir"
}
```

**Input:** Raw base directory path (default: `.temp`)
**Output:** Normalized path with tilde expansion and trimmed slashes
**Default:** `.temp` if not specified

---

#### `calculate_output_dir(phase_number, phase_name)`
Generates zero-padded phase directory names.

```bash
calculate_output_dir() {
  local phase_number=$1
  local phase_name=$2
  printf "phase-%02d-%s" "$phase_number" "$phase_name"
}
```

**Input:** Phase number (1-based), phase name
**Output:** Formatted directory name (e.g., `phase-01-discovery`, `phase-03-design`)

**Example:**
```bash
dir=$(calculate_output_dir 1 "discovery")
# Output: "phase-01-discovery"
```

---

#### `build_phase_dirs(phases_json, current_index)`
Builds JSON object mapping phase names to their directory paths.

```bash
build_phase_dirs() {
  local phases_json=$1
  local current_index=$2

  local phase_dirs="{}"

  for ((i=0; i<=current_index && i<total_phases; i++)); do
    local phase_name=$(echo "$phases_json" | jq -r ".[${i}]")
    local dir=$(calculate_output_dir "$((i + 1))" "$phase_name")
    phase_dirs=$(echo "$phase_dirs" | jq \
      --arg key "$phase_name" \
      --arg val "$dir" \
      '. + {($key): $val}')
  done

  echo "$phase_dirs"
}
```

**Input:** Phases JSON array, current phase index
**Output:** JSON object: `{"discovery": "phase-01-discovery", "requirements": "phase-02-requirements", ...}`

**Used For:** Cross-phase path references (`{{phase_paths.discovery}}/file.json`)

---

#### `build_phase_data(phase, phase_number, feature_name, workflow, scope, workflow_json, phases_json, base_dir, conditions_json)`
Builds complete data package for template rendering, including enriched deliverable metadata.

**Key Features:**
- Assembles subagent information with template paths
- Builds deliverable metadata with template content embedding
- Generates phase path references
- Includes condition flags for conditional rendering

**Deliverable Metadata Structure:**
```json
{
  "filename": "codebase-analysis.json",
  "description": "Codebase patterns and components",
  "full_path": "{{workspace}}/phase-01-discovery/codebase-analysis.json",
  "template_name": "codebase-analysis",
  "template_extension": "json",
  "has_template": true,
  "template_content": "{\n  \"patterns\": [],\n  ...\n}",
  "validation_checks": [...]
}
```

**Output Templates Directory:** `output_templates/`
- Templates loaded from `output_templates/<name>.<ext>.tmpl`
- Content embedded into deliverable metadata
- Used for showing agents expected output structure

---

#### `parse_common_args(args_array)`
Parses command-line arguments and extracts base directory and remaining flags.

```bash
parse_common_args() {
  local args=("$@")
  local base_dir=""
  local remaining_args=()

  for arg in "${args[@]}"; do
    case "$arg" in
      --base-dir=*)
        base_dir="${arg#*=}"
        ;;
      *)
        remaining_args+=("$arg")
        ;;
    esac
  done

  # Normalize base directory
  base_dir=$(normalize_base_dir "${base_dir:-$DEFAULT_BASE_DIR}")

  # Return both as JSON
  jq -n \
    --arg base_dir "$base_dir" \
    --argjson remaining "$(printf '%s\n' "${remaining_args[@]}" | jq -R . | jq -s .)" \
    '{base_dir: $base_dir, remaining_args: $remaining}'
}
```

**Input:** All command-line arguments
**Output:** JSON with `base_dir` and `remaining_args` array
**Returns:** Base directory extracted, all other flags preserved

**Example:**
```bash
# Input: new-feature-plan example --base-dir=~/projects --frontend --complexity=high
# Output: {
#   "base_dir": "/Users/user/projects",
#   "remaining_args": ["new-feature-plan", "example", "--frontend", "--complexity=high"]
# }
```

---

#### `check_template_override(workflow, phase, default_template_path)`
Checks for workflow-specific template overrides, falls back to default.

```bash
check_template_override() {
  local workflow=$1
  local phase=$2
  local default_template_path=$3

  # Check for override: phases/<workflow>/<phase>.md
  local override_path="phases/${workflow}/${phase}.md"

  if [[ -f "$override_path" ]]; then
    echo "$override_path"
  else
    echo "$default_template_path"
  fi
}
```

**Input:** Workflow name, phase name, default template path
**Output:** Override path if exists, otherwise default path

**Example:**
```bash
template=$(check_template_override "new-feature-plan" "discovery" "phases/discovery.md")
# Checks: phases/new-feature-plan/discovery.md
# Falls back to: phases/discovery.md if not found
```

---

## Module 1: workflow-parser.sh

### Purpose
Load and parse workflow YAML files, extract configuration.

### Functions

#### `load_workflow(workflow_path)`
Load workflow YAML and convert to JSON.

```bash
load_workflow() {
  local workflow_path=$1

  # Validate file exists
  if [[ ! -f "$workflow_path" ]]; then
    echo "Error: Workflow file not found: $workflow_path" >&2
    return 1
  fi

  # Parse YAML to JSON using yq
  local workflow_json=$(yq eval -o=json "$workflow_path" 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    echo "Error: Invalid YAML in $workflow_path" >&2
    return 1
  fi

  echo "$workflow_json"
}
```

**Input:** Path to workflow YAML file
**Output:** JSON representation of workflow (stdout)
**Returns:** 0 on success, 1 on failure

---

#### `get_workflow_field(workflow_json, field)`
Extract specific field from workflow JSON.

```bash
get_workflow_field() {
  local workflow_json=$1
  local field=$2

  echo "$workflow_json" | jq -r ".${field}"
}
```

**Input:** Workflow JSON, field name
**Output:** Field value (stdout)
**Example:**
```bash
name=$(get_workflow_field "$workflow_json" "name")
description=$(get_workflow_field "$workflow_json" "description")
```

---

#### `get_phases(workflow_json)`
Extract phases array.

```bash
get_phases() {
  local workflow_json=$1

  echo "$workflow_json" | jq -r '.phases[]'
}
```

**Input:** Workflow JSON
**Output:** Phase IDs, one per line (stdout)
**Example output:**
```
discovery
requirements
design
synthesis
validation
```

---

#### `get_subagent_matrix(workflow_json)`
Extract complete subagent matrix as JSON.

```bash
get_subagent_matrix() {
  local workflow_json=$1

  echo "$workflow_json" | jq '.subagent_matrix'
}
```

**Input:** Workflow JSON
**Output:** Subagent matrix JSON (stdout)

---

#### `get_gap_checks(workflow_json)`
Extract gap checks configuration.

```bash
get_gap_checks() {
  local workflow_json=$1

  echo "$workflow_json" | jq '.gap_checks'
}
```

---

#### `get_checkpoints(workflow_json)`
Extract checkpoints array.

```bash
get_checkpoints() {
  local workflow_json=$1

  echo "$workflow_json" | jq '.checkpoints'
}
```

---

### Usage Example

```bash
source lib/workflow-parser.sh

workflow_json=$(load_workflow "workflows/new-feature.yaml")
phases=($(get_phases "$workflow_json"))

for phase in "${phases[@]}"; do
  echo "Phase: $phase"
done
```

---

## Module 2: scope-detector.sh

### Purpose
Parse command-line flags and determine scope.

### Functions

#### `detect_scope(flags...)`
Determine scope from flags array.

```bash
detect_scope() {
  local flags=("$@")

  # Check for scope flags
  for flag in "${flags[@]}"; do
    case "$flag" in
      --both)
        echo "both"
        return 0
        ;;
      --frontend)
        echo "frontend"
        return 0
        ;;
      --backend)
        echo "backend"
        return 0
        ;;
    esac
  done

  # Default scope
  echo "default"
}
```

**Input:** Array of flags (--frontend, --backend, --both, etc.)
**Output:** Scope string: "frontend" | "backend" | "both" | "default"
**Example:**
```bash
scope=$(detect_scope "${flags[@]}")  # "frontend"
```

---

#### `has_flag(flag_name, flags...)`
Check if specific flag is present.

```bash
has_flag() {
  local flag_name=$1
  shift
  local flags=("$@")

  for flag in "${flags[@]}"; do
    if [[ "$flag" == "$flag_name" ]]; then
      return 0  # Found
    fi
  done

  return 1  # Not found
}
```

**Input:** Flag name to search for, flags array
**Output:** None
**Returns:** 0 if found, 1 if not found
**Example:**
```bash
if has_flag "--verbose" "${flags[@]}"; then
  echo "Verbose mode enabled"
fi
```

---

### Usage Example

```bash
source lib/scope-detector.sh

flags=("--frontend" "--verbose")
scope=$(detect_scope "${flags[@]}")

echo "Scope: $scope"  # "frontend"
```

---

## Module 3: subagent-matcher.sh

### Purpose
Build filtered subagent list per phase based on scope.

### Functions

#### `get_phase_subagents(workflow_json, phase, scope)`
Get all subagents for a specific phase and scope.

```bash
get_phase_subagents() {
  local workflow_json=$1
  local phase=$2
  local scope=$3

  # Get always subagents
  local always=$(echo "$workflow_json" | \
    jq -r ".subagent_matrix.${phase}.always[]?" 2>/dev/null || echo "")

  # Get conditional subagents based on scope
  local conditional=""
  if [[ "$scope" != "default" ]]; then
    conditional=$(echo "$workflow_json" | \
      jq -r ".subagent_matrix.${phase}.conditional.${scope}[]?" 2>/dev/null || echo "")
  fi

  # Combine and output
  {
    echo "$always"
    echo "$conditional"
  } | grep -v "^$"  # Filter empty lines
}
```

**Input:** Workflow JSON, phase name, scope
**Output:** Subagent types, one per line (stdout)
**Example:**
```bash
subagents=($(get_phase_subagents "$workflow_json" "discovery" "frontend"))
# Output: codebase-scanner pattern-analyzer dependency-mapper frontend-scanner
```

---

#### `build_subagent_data(subagent_type, workflow, feature_name, scope, index)`
Build data object for a single subagent.

```bash
build_subagent_data() {
  local subagent_type=$1
  local workflow=$2
  local feature_name=$3
  local scope=$4
  local index=$5

  # Load subagent registry for Task agent type mapping
  local registry_json=$(cat subagents/registry.yaml | yq eval -o=json)

  local task_agent_type=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".task_agent_type")
  local thoroughness=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".thoroughness // \"medium\"")
  local description=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".description")
  local deliverable=$(echo "$registry_json" | \
    jq -r ".\"${subagent_type}\".deliverable")

  # Extract filename from path
  local deliverable_filename=$(basename "$deliverable")

  # Build JSON object
  jq -n \
    --arg index "$index" \
    --arg name "$subagent_type" \
    --arg type "$subagent_type" \
    --arg task_agent_type "$task_agent_type" \
    --arg thoroughness "$thoroughness" \
    --arg task_description "$description" \
    --arg deliverable_filename "$deliverable_filename" \
    --arg deliverable_path "$deliverable" \
    '{
      index: ($index | tonumber),
      name: $name,
      type: $type,
      task_agent_type: $task_agent_type,
      thoroughness: $thoroughness,
      task_description: $task_description,
      deliverable_filename: $deliverable_filename,
      deliverable_path: $deliverable_path
    }'
}
```

**Input:** Subagent type, workflow, feature name, scope, index
**Output:** JSON object with subagent data (stdout)

---

#### `build_all_subagents_data(subagent_types, workflow, feature_name, scope)`
Build array of subagent data objects.

```bash
build_all_subagents_data() {
  local -n subagent_types_ref=$1  # Array reference
  local workflow=$2
  local feature_name=$3
  local scope=$4

  local index=1
  local subagents_json="["

  for subagent_type in "${subagent_types_ref[@]}"; do
    if [[ $index -gt 1 ]]; then
      subagents_json+=","
    fi

    local subagent_data=$(build_subagent_data \
      "$subagent_type" "$workflow" "$feature_name" "$scope" "$index")

    subagents_json+="$subagent_data"
    ((index++))
  done

  subagents_json+="]"

  echo "$subagents_json"
}
```

**Input:** Subagent types array (by reference), workflow, feature, scope
**Output:** JSON array of subagent data objects

---

### Usage Example

```bash
source lib/subagent-matcher.sh

workflow_json=$(load_workflow "workflows/new-feature.yaml")
scope="frontend"
phase="discovery"

subagent_types=($(get_phase_subagents "$workflow_json" "$phase" "$scope"))
subagents_json=$(build_all_subagents_data subagent_types "new-feature" "user-dashboard" "$scope")

echo "$subagents_json" | jq
```

---

## Module 4: template-renderer.sh

### Purpose
Variable substitution in phase modules and subagent templates.

### Variable Substitution Approach

**Strategy:** Manual substitution using sed (no external dependencies like mustache CLI)

**Supported patterns:**
1. Simple variables: `{{variable}}`
2. Conditionals: `{{#var}}...{{/var}}` and `{{^var}}...{{/var}}`
3. Arrays: `{{#array}}{{item}}{{/array}}`

### Functions

#### `substitute_simple_vars(content, data_json)`
Replace `{{variable}}` with values from JSON.

```bash
substitute_simple_vars() {
  local content=$1
  local data_json=$2

  # Extract all variable names from content
  local vars=$(echo "$content" | grep -oP '\{\{\K[^#^/{}]+(?=\}\})' | sort -u)

  local result="$content"

  # Substitute each variable
  while IFS= read -r var; do
    [[ -z "$var" ]] && continue

    local value=$(echo "$data_json" | jq -r ".${var} // empty")

    if [[ -n "$value" ]]; then
      # Escape special characters in value for sed
      value=$(echo "$value" | sed 's/[&/\]/\\&/g')
      result=$(echo "$result" | sed "s/{{${var}}}/${value}/g")
    fi
  done <<< "$vars"

  echo "$result"
}
```

**Input:** Template content, JSON data
**Output:** Content with simple variables substituted

---

#### `substitute_conditionals(content, data_json)`
Process `{{#var}}...{{/var}}` blocks.

```bash
substitute_conditionals() {
  local content=$1
  local data_json=$2

  # Process {{#var}}...{{/var}} blocks
  while [[ "$content" =~ \{\{#([^}]+)\}\}(.*)\{\{/\1\}\} ]]; do
    local var="${BASH_REMATCH[1]}"
    local block="${BASH_REMATCH[2]}"

    # Check if variable is truthy
    local value=$(echo "$data_json" | jq -r ".${var} // empty")

    if [[ -n "$value" && "$value" != "null" && "$value" != "false" ]]; then
      # Keep block content
      content="${content//\{\{#${var}\}\}${block}\{\{\/${var}\}\}/${block}}"
    else
      # Remove block
      content="${content//\{\{#${var}\}\}${block}\{\{\/${var}\}\}/}"
    fi
  done

  # Process {{^var}}...{{/var}} blocks (inverted conditionals)
  while [[ "$content" =~ \{\{\^([^}]+)\}\}(.*)\{\{/\1\}\} ]]; do
    local var="${BASH_REMATCH[1]}"
    local block="${BASH_REMATCH[2]}"

    local value=$(echo "$data_json" | jq -r ".${var} // empty")

    if [[ -z "$value" || "$value" == "null" || "$value" == "false" ]]; then
      # Keep block content (condition is false, so inverted is true)
      content="${content//\{\{\^${var}\}\}${block}\{\{\/${var}\}\}/${block}}"
    else
      # Remove block
      content="${content//\{\{\^${var}\}\}${block}\{\{\/${var}\}\}/}"
    fi
  done

  echo "$content"
}
```

**Input:** Template content with conditionals, JSON data
**Output:** Content with conditional blocks processed

---

#### `substitute_arrays(content, data_json)`
Process `{{#array}}...{{/array}}` with iteration.

```bash
substitute_arrays() {
  local content=$1
  local data_json=$2

  # Find array blocks
  while [[ "$content" =~ \{\{#([^}]+)\}\}(.*)\{\{/\1\}\} ]]; do
    local array_name="${BASH_REMATCH[1]}"
    local block="${BASH_REMATCH[2]}"

    # Check if it's an array
    local is_array=$(echo "$data_json" | jq -r "(.${array_name} | type) == \"array\"")

    if [[ "$is_array" == "true" ]]; then
      local array_json=$(echo "$data_json" | jq ".${array_name}")
      local length=$(echo "$array_json" | jq 'length')

      local expanded=""

      # Iterate array
      for ((i=0; i<length; i++)); do
        local item_json=$(echo "$array_json" | jq ".[$i]")
        local item_block="$block"

        # Substitute item properties
        local props=$(echo "$item_json" | jq -r 'keys[]')

        while IFS= read -r prop; do
          [[ -z "$prop" ]] && continue

          local prop_value=$(echo "$item_json" | jq -r ".${prop}")
          prop_value=$(echo "$prop_value" | sed 's/[&/\]/\\&/g')

          item_block=$(echo "$item_block" | sed "s/{{${prop}}}/${prop_value}/g")
        done <<< "$props"

        expanded+="$item_block"
      done

      # Replace block with expanded content
      content="${content//\{\{#${array_name}\}\}${block}\{\{\/${array_name}\}\}/${expanded}}"
    else
      # Not an array, treat as conditional
      content=$(substitute_conditionals "$content" "$data_json")
      break
    fi
  done

  echo "$content"
}
```

**Input:** Template content with array blocks, JSON data
**Output:** Content with arrays expanded

---

#### `render_template(template_path, data_json)`
Main rendering function combining all substitutions.

```bash
render_template() {
  local template_path=$1
  local data_json=$2

  # Read template
  local content=$(cat "$template_path")

  # Apply substitutions in order
  content=$(substitute_arrays "$content" "$data_json")
  content=$(substitute_conditionals "$content" "$data_json")
  content=$(substitute_simple_vars "$content" "$data_json")

  echo "$content"
}
```

**Input:** Template file path, JSON data
**Output:** Rendered content
**Example:**
```bash
phase_data=$(build_phase_data "discovery" "user-dashboard" "new-feature" "frontend")
rendered=$(render_template "phases/discovery.md" "$phase_data")
echo "$rendered"
```

---

### Usage Example

```bash
source lib/template-renderer.sh

data_json='{
  "feature_name": "user-dashboard",
  "scope": "frontend",
  "subagents": [
    {"index": 1, "name": "codebase-scanner"},
    {"index": 2, "name": "pattern-analyzer"}
  ],
  "checkpoint": {"prompt": "Review findings"}
}'

rendered=$(render_template "phases/discovery.md" "$data_json")
echo "$rendered"
```

---

## Main Script: generate-workflow-instructions.sh

### Complete Implementation

```bash
#!/usr/bin/env bash
set -euo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "${SCRIPT_DIR}/lib/workflow-parser.sh"
source "${SCRIPT_DIR}/lib/scope-detector.sh"
source "${SCRIPT_DIR}/lib/subagent-matcher.sh"
source "${SCRIPT_DIR}/lib/template-renderer.sh"

# ============================================================================
# Helper Functions
# ============================================================================

usage() {
  cat <<EOF
Usage: bash generate-workflow-instructions.sh <workflow> <feature-name> [flags...]

Arguments:
  workflow      Workflow type (new-feature, refactoring, debugging, improving, quick)
  feature-name  Name of feature/task being planned

Flags:
  --frontend    Include frontend-specific subagents
  --backend     Include backend-specific subagents
  --both        Include both frontend and backend subagents

Examples:
  bash generate-workflow-instructions.sh new-feature user-dashboard --frontend
  bash generate-workflow-instructions.sh refactoring auth-flow --backend
  bash generate-workflow-instructions.sh debugging hydration-issue --both

Output:
  Complete workflow instructions written to stdout
EOF
}

build_phase_data() {
  local phase=$1
  local feature_name=$2
  local workflow=$3
  local scope=$4
  local workflow_json=$5

  # Get subagents for this phase
  local subagent_types=($(get_phase_subagents "$workflow_json" "$phase" "$scope"))
  local subagents_json=$(build_all_subagents_data subagent_types "$workflow" "$feature_name" "$scope")

  # Get gap checks for this phase
  local gap_criteria=$(echo "$workflow_json" | jq ".gap_checks.${phase}.criteria // []")
  local gap_options=$(echo "$workflow_json" | jq ".gap_checks.${phase}.on_failure // []")

  # Get checkpoint for this phase (if exists)
  local checkpoint=$(echo "$workflow_json" | jq ".checkpoints[] | select(.after == \"${phase}\") // null")

  # Build deliverables array
  local deliverables="[]"
  if [[ ${#subagent_types[@]} -gt 0 ]]; then
    deliverables=$(echo "$subagents_json" | jq '[.[] | {
      filename: .deliverable_filename,
      description: .task_description,
      validation_checks: [
        "File exists",
        "File is valid format",
        "File contains expected data"
      ]
    }]')
  fi

  # Build complete phase data JSON
  jq -n \
    --arg phase "$phase" \
    --arg feature_name "$feature_name" \
    --arg workflow "$workflow" \
    --arg scope "$scope" \
    --arg output_dir "phase-01-${phase}" \
    --argjson subagents "$subagents_json" \
    --argjson subagent_count "${#subagent_types[@]}" \
    --argjson gap_criteria "$gap_criteria" \
    --argjson gap_options "$gap_options" \
    --argjson checkpoint "$checkpoint" \
    --argjson deliverables "$deliverables" \
    '{
      phase_name: $phase,
      feature_name: $feature_name,
      workflow: $workflow,
      scope: $scope,
      output_dir: $output_dir,
      subagents: $subagents,
      subagent_count: $subagent_count,
      gap_criteria: $gap_criteria,
      gap_options: $gap_options,
      checkpoint: $checkpoint,
      deliverables: $deliverables
    }'
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
  shift 2
  local flags=("$@")

  # Validate workflow exists
  local workflow_file="${SCRIPT_DIR}/workflows/${workflow}.yaml"
  if [[ ! -f "$workflow_file" ]]; then
    echo "Error: Workflow '$workflow' not found" >&2
    echo "Available workflows:" >&2
    ls -1 "${SCRIPT_DIR}/workflows/"*.yaml | xargs -n1 basename | sed 's/.yaml$//' >&2
    exit 1
  fi

  # Load workflow
  local workflow_json=$(load_workflow "$workflow_file")
  if [[ $? -ne 0 ]]; then
    exit 1
  fi

  # Extract workflow metadata
  local workflow_desc=$(get_workflow_field "$workflow_json" "description")
  local estimated_time=$(get_workflow_field "$workflow_json" "estimated_time")
  local estimated_tokens=$(get_workflow_field "$workflow_json" "estimated_tokens")

  # Detect scope
  local scope=$(detect_scope "${flags[@]}")

  # Get phases
  local phases=($(get_phases "$workflow_json"))

  # =========================================================================
  # Output Header
  # =========================================================================

  cat <<EOF
# Workflow Instructions: ${workflow^} - $feature_name

**Workflow:** $workflow
**Description:** $workflow_desc
**Scope:** $scope
**Flags:** ${flags[*]:-none}
**Estimated Time:** $estimated_time
**Estimated Tokens:** $estimated_tokens

---

EOF

  # =========================================================================
  # Render Each Phase
  # =========================================================================

  for phase in "${phases[@]}"; do
    echo "## Rendering Phase: $phase" >&2  # Debug to stderr

    # Build phase data
    local phase_data=$(build_phase_data \
      "$phase" \
      "$feature_name" \
      "$workflow" \
      "$scope" \
      "$workflow_json")

    # Render phase module
    local phase_template="${SCRIPT_DIR}/phases/${phase}.md"

    if [[ ! -f "$phase_template" ]]; then
      echo "Warning: Phase template not found: $phase_template" >&2
      continue
    fi

    local rendered=$(render_template "$phase_template" "$phase_data")

    echo "$rendered"
    echo ""
    echo "---"
    echo ""
  done

  # =========================================================================
  # Finalization Section
  # =========================================================================

  cat <<EOF
## Finalization

All phases complete. Next steps:

1. **Review all deliverables** in `{{workspace}}/`
2. **Run validation checks** as specified in validation phase
3. **Generate final plan** using template: $(get_workflow_field "$workflow_json" "template")
4. **Create metadata.json** with workflow execution summary

---

## Output Structure

```
{{workspace}}/
├── plan.md                  # Final implementation plan
├── metadata.json            # Execution metadata
EOF

  # Add phase directories
  for phase in "${phases[@]}"; do
    echo "├── phase-01-${phase}/        # ${phase^} phase outputs"
  done

  cat <<EOF
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
EOF
}

# ============================================================================
# Entry Point
# ============================================================================

main "$@"
```

---

## Data Flow Example

### Input
```bash
bash generate-workflow-instructions.sh new-feature user-dashboard --frontend
```

### Processing

**Step 1: Parse args**
```
workflow = "new-feature"
feature_name = "user-dashboard"
flags = ["--frontend"]
```

**Step 2: Load workflow**
```json
{
  "name": "new-feature",
  "phases": ["discovery", "requirements", "design", "synthesis", "validation"],
  "subagent_matrix": {...},
  "gap_checks": {...}
}
```

**Step 3: Detect scope**
```
scope = "frontend"
```

**Step 4: For discovery phase, build data**
```json
{
  "phase_name": "discovery",
  "feature_name": "user-dashboard",
  "scope": "frontend",
  "subagents": [
    {
      "index": 1,
      "name": "codebase-scanner",
      "task_agent_type": "Explore",
      "thoroughness": "medium"
    },
    {
      "index": 2,
      "name": "pattern-analyzer",
      "task_agent_type": "Explore"
    },
    {
      "index": 3,
      "name": "dependency-mapper",
      "task_agent_type": "Explore"
    },
    {
      "index": 4,
      "name": "frontend-scanner",
      "task_agent_type": "Explore"
    }
  ],
  "gap_criteria": [...],
  "checkpoint": {...}
}
```

**Step 5: Render template**
```markdown
# Phase 1: Discovery

## Step 1: Spawn Parallel Subagents

### 1. codebase-scanner

**Agent Configuration:**
- `subagent_type`: "Explore"
- `thoroughness`: "medium"

[... rendered content ...]
```

**Step 6: Output to stdout**

Complete workflow instructions ready for Claude to follow.

---

## Error Handling

### Workflow Not Found
```bash
Error: Workflow 'invalid' not found
Available workflows:
new-feature
refactoring
debugging
improving
quick
```

### Invalid YAML
```bash
Error: Invalid YAML in workflows/new-feature.yaml
```

### Missing Phase Template
```bash
Warning: Phase template not found: phases/custom-phase.md
```

### Missing Subagent Registry Entry
```bash
Warning: Subagent 'unknown-agent' not found in registry
```

---

## Testing Strategy

### Unit Tests

```bash
# Test workflow loading
test_load_workflow() {
  local result=$(load_workflow "workflows/new-feature.yaml")
  assert_not_empty "$result"
  assert_json_valid "$result"
}

# Test scope detection
test_scope_detection() {
  local scope=$(detect_scope "--frontend")
  assert_equals "frontend" "$scope"

  scope=$(detect_scope "--both")
  assert_equals "both" "$scope"

  scope=$(detect_scope)
  assert_equals "default" "$scope"
}

# Test subagent matching
test_subagent_matching() {
  local workflow_json=$(load_workflow "workflows/new-feature.yaml")
  local subagents=($(get_phase_subagents "$workflow_json" "discovery" "frontend"))

  assert_array_contains "codebase-scanner" "${subagents[@]}"
  assert_array_contains "frontend-scanner" "${subagents[@]}"
  assert_array_not_contains "backend-scanner" "${subagents[@]}"
}

# Test variable substitution
test_simple_substitution() {
  local content="Hello {{name}}"
  local data='{"name": "World"}'
  local result=$(substitute_simple_vars "$content" "$data")

  assert_equals "Hello World" "$result"
}
```

### Integration Tests

```bash
# Test complete workflow generation
test_new_feature_workflow() {
  local output=$(bash generate-workflow-instructions.sh new-feature test-feature --frontend)

  assert_contains "# Workflow Instructions" "$output"
  assert_contains "Phase 1: Discovery" "$output"
  assert_contains "codebase-scanner" "$output"
  assert_contains "frontend-scanner" "$output"
  assert_not_contains "backend-scanner" "$output"
}
```

---

## Performance Considerations

### Optimization Strategies

1. **Cache workflow parsing** - Load workflow JSON once
2. **Minimize template reads** - Read phase templates once
3. **Efficient substitution** - Use sed for simple vars, minimize regex
4. **Parallel processing** - Not needed (sequential is fast enough)

### Expected Performance

- **Load workflow:** ~10ms
- **Build subagent matrix:** ~50ms
- **Render 5 phases:** ~200ms
- **Total:** ~300ms per workflow

---

## Dependencies

### Required Tools

```bash
# Check dependencies
check_dependencies() {
  local missing=()

  if ! command -v yq &> /dev/null; then
    missing+=("yq - YAML parser (brew install yq)")
  fi

  if ! command -v jq &> /dev/null; then
    missing+=("jq - JSON processor (brew install jq)")
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Missing dependencies:" >&2
    printf '%s\n' "${missing[@]}" >&2
    exit 1
  fi
}
```

### Installation

```bash
# macOS
brew install yq jq

# Linux (Ubuntu/Debian)
sudo apt-get install jq
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq
```

---

## Next Steps

1. **Implement libraries:**
   - `lib/workflow-parser.sh`
   - `lib/scope-detector.sh`
   - `lib/subagent-matcher.sh`
   - `lib/template-renderer.sh`

2. **Implement main script:**
   - `generate-workflow-instructions.sh`

3. **Create subagent registry:**
   - `subagents/registry.yaml`

4. **Test with sample workflows:**
   - Generate instructions for new-feature
   - Verify output format
   - Check variable substitution

5. **Iterate and refine:**
   - Fix bugs
   - Optimize performance
   - Improve error messages

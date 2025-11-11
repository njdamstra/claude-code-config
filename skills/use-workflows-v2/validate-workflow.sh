#!/usr/bin/env bash
# Workflow YAML Validator (v5)
# Validates workflow YAML files against the v5 schema requirements

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ==============================================================================
# VALIDATION FUNCTIONS
# ==============================================================================

validate_workflow_yaml() {
  local workflow_file="$1"
  local phases_dir="${2:-phases-v5}"
  local errors=0
  local warnings=0

  echo "Validating: $workflow_file"
  echo ""

  # Check file exists
  if [[ ! -f "$workflow_file" ]]; then
    echo -e "${RED}✗ File does not exist${NC}"
    return 1
  fi

  # Check valid YAML
  if ! yq eval '.' "$workflow_file" > /dev/null 2>&1; then
    echo -e "${RED}✗ Invalid YAML syntax${NC}"
    return 1
  fi

  # Required fields
  echo "Checking required fields..."

  local required_fields=(
    "name"
    "description"
    "estimated_time"
    "estimated_tokens"
    "base_dir"
    "phases"
    "checkpoints"
    "default_scope"
  )

  for field in "${required_fields[@]}"; do
    if ! yq eval ".$field" "$workflow_file" | grep -q .; then
      echo -e "${RED}✗ Missing required field: $field${NC}"
      ((errors++))
    else
      echo -e "${GREEN}✓${NC} $field"
    fi
  done

  # Validate phases array
  echo ""
  echo "Checking phases structure..."

  if ! yq eval '.phases' "$workflow_file" | grep -q '\-'; then
    echo -e "${RED}✗ phases must be an array${NC}"
    ((errors++))
  else
    echo -e "${GREEN}✓${NC} phases is array"

    # Validate each phase
    local phase_count=$(yq eval '.phases | length' "$workflow_file")
    echo "  Found $phase_count phase(s)"

    for ((i=0; i<phase_count; i++)); do
      local phase_name=$(yq eval ".phases[$i].name" "$workflow_file")
      local phase_scope=$(yq eval ".phases[$i].scope" "$workflow_file")
      local phase_inputs=$(yq eval ".phases[$i].inputs" "$workflow_file")

      if [[ "$phase_name" == "null" ]]; then
        echo -e "${RED}  ✗ Phase $((i+1)): missing 'name'${NC}"
        ((errors++))
      else
        echo -e "${GREEN}  ✓${NC} Phase $((i+1)): $phase_name"

        # Check if phase YAML exists
        local phase_yaml="$phases_dir/$phase_name.yaml"
        if [[ ! -f "$phase_yaml" ]]; then
          echo -e "${YELLOW}    ⚠ Phase file not found: $phase_yaml${NC}"
          ((warnings++))
        fi

        # Validate scope
        if [[ "$phase_scope" == "null" ]]; then
          echo -e "${RED}    ✗ Missing 'scope'${NC}"
          ((errors++))
        fi

        # Validate inputs structure
        if [[ "$phase_inputs" != "null" && "$phase_inputs" != "[]" ]]; then
          local input_count=$(yq eval ".phases[$i].inputs | length" "$workflow_file")
          echo "    Found $input_count input(s)"

          for ((j=0; j<input_count; j++)); do
            local from=$(yq eval ".phases[$i].inputs[$j].from" "$workflow_file")
            local files=$(yq eval ".phases[$i].inputs[$j].files" "$workflow_file")

            if [[ "$from" == "null" ]]; then
              echo -e "${RED}      ✗ Input $((j+1)): missing 'from'${NC}"
              ((errors++))
            fi

            if [[ "$files" == "null" || "$files" == "[]" ]]; then
              echo -e "${RED}      ✗ Input $((j+1)): missing or empty 'files'${NC}"
              ((errors++))
            fi
          done
        fi
      fi
    done
  fi

  # Validate checkpoints array
  echo ""
  echo "Checking checkpoints structure..."

  if ! yq eval '.checkpoints' "$workflow_file" | grep -q '\-\|null\|\[\]'; then
    echo -e "${RED}✗ checkpoints must be an array (can be empty)${NC}"
    ((errors++))
  else
    local checkpoint_count=$(yq eval '.checkpoints | length' "$workflow_file" 2>/dev/null || echo "0")

    if [[ "$checkpoint_count" -eq 0 ]]; then
      echo -e "${YELLOW}⚠${NC} No checkpoints configured"
      ((warnings++))
    else
      echo -e "${GREEN}✓${NC} checkpoints is array"
      echo "  Found $checkpoint_count checkpoint(s)"

      for ((i=0; i<checkpoint_count; i++)); do
        local after=$(yq eval ".checkpoints[$i].after" "$workflow_file")
        local prompt=$(yq eval ".checkpoints[$i].prompt" "$workflow_file")
        local options=$(yq eval ".checkpoints[$i].options" "$workflow_file")

        if [[ "$after" == "null" ]]; then
          echo -e "${RED}  ✗ Checkpoint $((i+1)): missing 'after'${NC}"
          ((errors++))
        else
          echo -e "${GREEN}  ✓${NC} Checkpoint $((i+1)): after $after"
        fi

        if [[ "$prompt" == "null" ]]; then
          echo -e "${RED}    ✗ Missing 'prompt'${NC}"
          ((errors++))
        fi

        if [[ "$options" == "null" || "$options" == "[]" ]]; then
          echo -e "${RED}    ✗ Missing or empty 'options'${NC}"
          ((errors++))
        fi
      done
    fi
  fi

  # Check for v4 fields (should not exist in v5)
  echo ""
  echo "Checking for legacy v4 fields..."

  local legacy_fields=(
    "subagent_matrix"
    "subagent_outputs"
    "gap_checks"
    "template"
  )

  for field in "${legacy_fields[@]}"; do
    local field_value=$(yq eval ".$field" "$workflow_file")
    if [[ "$field_value" != "null" ]]; then
      echo -e "${RED}✗ Legacy v4 field found: $field (should be removed)${NC}"
      ((errors++))
    else
      echo -e "${GREEN}✓${NC} No legacy $field field"
    fi
  done

  # Validate base_dir
  echo ""
  echo "Checking base_dir..."

  local base_dir=$(yq eval '.base_dir' "$workflow_file")
  if [[ "$base_dir" == "null" ]]; then
    echo -e "${RED}✗ base_dir is required${NC}"
    ((errors++))
  else
    echo -e "${GREEN}✓${NC} base_dir: $base_dir"
  fi

  # Summary
  echo ""
  echo "================================"
  if [[ $errors -eq 0 ]]; then
    echo -e "${GREEN}✓ Validation PASSED${NC}"
    if [[ $warnings -gt 0 ]]; then
      echo -e "${YELLOW}⚠ $warnings warning(s)${NC}"
    fi
    return 0
  else
    echo -e "${RED}✗ Validation FAILED${NC}"
    echo -e "${RED}  $errors error(s)${NC}"
    if [[ $warnings -gt 0 ]]; then
      echo -e "${YELLOW}  $warnings warning(s)${NC}"
    fi
    return 1
  fi
}

# ==============================================================================
# BATCH VALIDATION
# ==============================================================================

validate_all_workflows() {
  local workflows_dir="${1:-workflows}"
  local phases_dir="${2:-phases-v5}"
  local total=0
  local passed=0
  local failed=0

  echo "Validating all workflows in $workflows_dir/"
  echo ""

  if [[ ! -d "$workflows_dir" ]]; then
    echo -e "${RED}✗ Directory not found: $workflows_dir${NC}"
    return 1
  fi

  for workflow_file in "$workflows_dir"/*.yaml; do
    if [[ -f "$workflow_file" ]]; then
      ((total++))
      if validate_workflow_yaml "$workflow_file" "$phases_dir"; then
        ((passed++))
      else
        ((failed++))
      fi
      echo ""
    fi
  done

  echo "========================================"
  echo "Summary:"
  echo "  Total: $total"
  echo -e "  ${GREEN}Passed: $passed${NC}"
  if [[ $failed -gt 0 ]]; then
    echo -e "  ${RED}Failed: $failed${NC}"
  else
    echo "  Failed: $failed"
  fi

  return $(( failed > 0 ? 1 : 0 ))
}

# ==============================================================================
# CLI INTERFACE
# ==============================================================================

main() {
  if [[ $# -eq 0 ]]; then
    cat <<USAGE
Usage: $0 [OPTIONS] <workflow_file.yaml> [phases_dir]

Validate a workflow YAML file against the v5 schema.

Options:
  --all [workflows_dir] [phases_dir]
                  Validate all workflow YAMLs in directory
                  (default: workflows/ phases-v5/)
  --help          Show this help message

Examples:
  $0 workflows/investigation-workflow.yaml
  $0 workflows/investigation-workflow.yaml phases-v5
  $0 --all workflows phases-v5
  $0 --all
USAGE
    exit 0
  fi

  case "$1" in
    --all)
      shift
      validate_all_workflows "$@"
      ;;
    --help)
      main
      ;;
    *)
      validate_workflow_yaml "$@"
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

#!/usr/bin/env bash
# Phase YAML Validator (v5)
# Validates phase YAML files against the v5 schema requirements

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

validate_phase_yaml() {
  local phase_file="$1"
  local errors=0
  local warnings=0

  echo "Validating: $phase_file"
  echo ""

  # Check file exists
  if [[ ! -f "$phase_file" ]]; then
    echo -e "${RED}✗ File does not exist${NC}"
    return 1
  fi

  # Check valid YAML
  if ! yq eval '.' "$phase_file" > /dev/null 2>&1; then
    echo -e "${RED}✗ Invalid YAML syntax${NC}"
    return 1
  fi

  # Required fields
  echo "Checking required fields..."

  local required_fields=(
    "name"
    "purpose"
    "subagents"
    "subagent_configs"
    "gap_checks"
    "provides"
  )

  for field in "${required_fields[@]}"; do
    if ! yq eval ".$field" "$phase_file" | grep -q .; then
      echo -e "${RED}✗ Missing required field: $field${NC}"
      ((errors++))
    else
      echo -e "${GREEN}✓${NC} $field"
    fi
  done

  # Validate subagents structure
  echo ""
  echo "Checking subagents structure..."

  local always_check=$(yq eval '.subagents.always' "$phase_file")
  if [[ "$always_check" == "null" ]]; then
    echo -e "${RED}✗ subagents.always must be an array (can be empty)${NC}"
    ((errors++))
  elif echo "$always_check" | grep -q '^\[\]'; then
    echo -e "${GREEN}✓${NC} subagents.always is array (empty)"
  elif echo "$always_check" | grep -q '\-'; then
    echo -e "${GREEN}✓${NC} subagents.always is array"
  else
    echo -e "${RED}✗ subagents.always must be an array${NC}"
    ((errors++))
  fi

  if ! yq eval '.subagents.conditional' "$phase_file" | grep -q '.\|{}'; then
    echo -e "${RED}✗ subagents.conditional must be an object${NC}"
    ((errors++))
  else
    echo -e "${GREEN}✓${NC} subagents.conditional is object"
  fi

  # Validate subagent configs
  echo ""
  echo "Checking subagent configs..."

  local always_agents=$(yq eval '.subagents.always[]' "$phase_file" 2>/dev/null || echo "")
  local conditional_scopes=$(yq eval '.subagents.conditional | keys | .[]' "$phase_file" 2>/dev/null || echo "")

  # Collect all conditional agents
  local conditional_agents=""
  if [[ -n "$conditional_scopes" ]]; then
    while IFS= read -r scope; do
      local agents=$(yq eval ".subagents.conditional.$scope[]" "$phase_file" 2>/dev/null || echo "")
      conditional_agents="$conditional_agents"$'\n'"$agents"
    done <<< "$conditional_scopes"
  fi

  # All agents that should have configs
  local all_agents=$(echo -e "$always_agents\n$conditional_agents" | grep -v '^$' | sort -u)

  if [[ -z "$all_agents" ]]; then
    echo -e "${YELLOW}⚠${NC} No subagents configured (conversational phase)"
    ((warnings++))
  else
    while IFS= read -r agent; do
      if [[ -n "$agent" ]]; then
        if ! yq eval ".subagent_configs.\"$agent\"" "$phase_file" | grep -q .; then
          echo -e "${RED}✗ Missing config for subagent: $agent${NC}"
          ((errors++))
        else
          # Check required config fields
          local config_errors=0

          if ! yq eval ".subagent_configs.\"$agent\".task_agent_type" "$phase_file" | grep -q .; then
            echo -e "${RED}  ✗ $agent: missing task_agent_type${NC}"
            ((config_errors++))
          fi

          if ! yq eval ".subagent_configs.\"$agent\".responsibility" "$phase_file" | grep -q .; then
            echo -e "${RED}  ✗ $agent: missing responsibility${NC}"
            ((config_errors++))
          fi

          if ! yq eval ".subagent_configs.\"$agent\".outputs" "$phase_file" | grep -q .; then
            echo -e "${RED}  ✗ $agent: missing outputs${NC}"
            ((config_errors++))
          fi

          if [[ $config_errors -eq 0 ]]; then
            echo -e "${GREEN}✓${NC} $agent configuration complete"
          else
            ((errors+=$config_errors))
          fi
        fi
      fi
    done <<< "$all_agents"
  fi

  # Validate gap_checks structure
  echo ""
  echo "Checking gap_checks structure..."

  if ! yq eval '.gap_checks.criteria' "$phase_file" | grep -q '\-'; then
    echo -e "${RED}✗ gap_checks.criteria must be an array${NC}"
    ((errors++))
  else
    echo -e "${GREEN}✓${NC} gap_checks.criteria is array"
  fi

  if ! yq eval '.gap_checks.on_failure' "$phase_file" | grep -q '\-'; then
    echo -e "${RED}✗ gap_checks.on_failure must be an array${NC}"
    ((errors++))
  else
    echo -e "${GREEN}✓${NC} gap_checks.on_failure is array"
  fi

  # Validate provides is array
  echo ""
  echo "Checking provides structure..."

  if ! yq eval '.provides' "$phase_file" | grep -q '\-'; then
    echo -e "${YELLOW}⚠${NC} provides should be an array (empty array if no outputs)"
    ((warnings++))
  else
    echo -e "${GREEN}✓${NC} provides is array"
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

validate_all_phases() {
  local phases_dir="${1:-phases}"
  local total=0
  local passed=0
  local failed=0

  echo "Validating all phases in $phases_dir/"
  echo ""

  if [[ ! -d "$phases_dir" ]]; then
    echo -e "${RED}✗ Directory not found: $phases_dir${NC}"
    return 1
  fi

  for phase_file in "$phases_dir"/*.yaml; do
    if [[ -f "$phase_file" ]]; then
      ((total++))
      if validate_phase_yaml "$phase_file"; then
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
Usage: $0 [OPTIONS] <phase_file.yaml>

Validate a phase YAML file against the v5 schema.

Options:
  --all [dir]     Validate all phase YAMLs in directory (default: phases/)
  --help          Show this help message

Examples:
  $0 phases/codebase-investigation.yaml
  $0 --all phases
  $0 --all
USAGE
    exit 0
  fi

  case "$1" in
    --all)
      shift
      validate_all_phases "$@"
      ;;
    --help)
      main
      ;;
    *)
      validate_phase_yaml "$1"
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

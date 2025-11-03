#!/usr/bin/env bash

set -euo pipefail

# Workflow YAML validator
# Usage: ./tools/validator.sh <workflow.yaml>

if [ $# -lt 1 ]; then
  echo "Usage: $0 <workflow.yaml>"
  exit 1
fi

WORKFLOW_FILE=$1
SCHEMA_FILE="schemas/workflow.schema.json"

if [ ! -f "$WORKFLOW_FILE" ]; then
  echo "Error: File not found: $WORKFLOW_FILE"
  exit 1
fi

if [ ! -f "$SCHEMA_FILE" ]; then
  echo "Error: Schema not found: $SCHEMA_FILE"
  exit 1
fi

echo "Validating $WORKFLOW_FILE..."

# Check dependencies
if ! command -v yq &> /dev/null; then
  echo "Error: yq not found. Install: brew install yq"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "Error: jq not found. Install: brew install jq"
  exit 1
fi

# Parse YAML to JSON
echo "  Parsing YAML..."
if ! workflow_json=$(yq eval -o=json "$WORKFLOW_FILE" 2>&1); then
  echo "✗ YAML parsing failed:"
  echo "$workflow_json"
  exit 1
fi

# Validate required fields
echo "  Checking required fields..."

required_fields=("name" "description" "execution_mode" "phases" "finalization")
for field in "${required_fields[@]}"; do
  if ! echo "$workflow_json" | jq -e ".$field" > /dev/null 2>&1; then
    echo "✗ Missing required field: $field"
    exit 1
  fi
done

# Validate workflow-level execution_mode
workflow_mode=$(echo "$workflow_json" | jq -r '.execution_mode')
if [[ ! "$workflow_mode" =~ ^(strict|loose|adaptive)$ ]]; then
  echo "✗ Invalid workflow execution_mode: $workflow_mode (must be strict, loose, or adaptive)"
  exit 1
fi

echo "  Workflow default mode: $workflow_mode"

# Validate phases
echo "  Checking phases..."
phase_count=$(echo "$workflow_json" | jq '.phases | length')

if [ "$phase_count" -eq 0 ]; then
  echo "✗ No phases defined"
  exit 1
fi

echo "  Found $phase_count phases"

# Validate each phase
phase_index=0
echo "$workflow_json" | jq -c '.phases[]' | while read -r phase; do
  phase_index=$((phase_index + 1))
  phase_id=$(echo "$phase" | jq -r '.id')

  echo "    Phase $phase_index: $phase_id"

  # Check required phase fields
  for field in id name description behavior; do
    if ! echo "$phase" | jq -e ".$field" > /dev/null 2>&1; then
      echo "    ✗ Phase $phase_id missing field: $field"
      exit 1
    fi
  done

  # Resolve execution mode (phase override or workflow default)
  phase_mode=$(echo "$phase" | jq -r '.execution_mode // "null"')
  if [ "$phase_mode" = "null" ]; then
    effective_mode="$workflow_mode"
    echo "      Mode: $effective_mode (workflow default)"
  else
    # Validate phase-level override
    if [[ ! "$phase_mode" =~ ^(strict|loose|adaptive)$ ]]; then
      echo "    ✗ Phase $phase_id has invalid execution_mode: $phase_mode"
      exit 1
    fi
    effective_mode="$phase_mode"
    echo "      Mode: $effective_mode (override)"
  fi

  # Validate behavior
  behavior=$(echo "$phase" | jq -r '.behavior')
  if [[ ! "$behavior" =~ ^(parallel|sequential|main-only)$ ]]; then
    echo "    ✗ Phase $phase_id has invalid behavior: $behavior"
    exit 1
  fi

  # Validate mode-specific requirements
  case "$effective_mode" in
    strict)
      if [ "$behavior" = "main-only" ]; then
        if ! echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
          echo "    ✗ Phase $phase_id (main-only) missing main_agent.script"
          exit 1
        fi
      else
        if ! echo "$phase" | jq -e '.subagents' > /dev/null 2>&1; then
          echo "    ✗ Phase $phase_id ($behavior) missing subagents"
          exit 1
        fi
      fi
      ;;

    loose)
      if [ "$behavior" != "main-only" ]; then
        echo "    ✗ Loose mode requires behavior: main-only (got $behavior)"
        exit 1
      fi
      if ! echo "$phase" | jq -e '.main_agent.script' > /dev/null 2>&1; then
        echo "    ✗ Loose mode requires main_agent.script"
        exit 1
      fi
      ;;

    adaptive)
      if [ "$behavior" = "main-only" ]; then
        echo "    ✗ Adaptive mode cannot use main-only behavior"
        exit 1
      fi
      if ! echo "$phase" | jq -e '.subagents.always' > /dev/null 2>&1; then
        echo "    ⚠ Phase $phase_id missing subagents.always (optional)"
      fi
      if ! echo "$phase" | jq -e '.subagents.adaptive.script' > /dev/null 2>&1; then
        echo "    ⚠ Phase $phase_id missing subagents.adaptive.script (optional)"
      fi
      ;;
  esac
done

# Validate finalization
echo "  Checking finalization..."
if ! echo "$workflow_json" | jq -e '.finalization.template' > /dev/null 2>&1; then
  echo "✗ Missing finalization.template"
  exit 1
fi

if ! echo "$workflow_json" | jq -e '.finalization.output' > /dev/null 2>&1; then
  echo "✗ Missing finalization.output"
  exit 1
fi

# Optional: Validate against JSON schema (if ajv-cli installed)
if command -v ajv &> /dev/null; then
  echo "  Validating against JSON schema..."
  temp_json=$(mktemp)
  echo "$workflow_json" > "$temp_json"

  if ajv validate -s "$SCHEMA_FILE" -d "$temp_json" 2>&1; then
    echo "  ✓ Schema validation passed"
  else
    echo "  ✗ Schema validation failed"
    rm "$temp_json"
    exit 1
  fi

  rm "$temp_json"
fi

echo ""
echo "✓ Validation passed: $WORKFLOW_FILE"
echo ""
echo "Summary:"
echo "  Name: $(echo "$workflow_json" | jq -r '.name')"
echo "  Mode: $execution_mode"
echo "  Phases: $phase_count"

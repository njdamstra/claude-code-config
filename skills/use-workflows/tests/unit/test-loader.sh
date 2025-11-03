#!/usr/bin/env bash
# Unit tests for workflow-loader.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/../test-framework.sh"
source "$WORKFLOW_DIR/engine/workflow-loader.sh"

# Setup
setup_test_env "$SCRIPT_DIR/../.tmp/test-loader"

echo "Testing workflow-loader.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Load valid YAML
test_start "Load valid workflow YAML"
workflow_json=$(load_workflow "$WORKFLOW_DIR/tests/fixtures/simple.workflow.yaml")
if assert_contains "$workflow_json" "Simple Test Workflow"; then
    test_pass
fi

# Test 2: Validate parsed JSON structure
test_start "Validate parsed JSON has required fields"
if echo "$workflow_json" | jq -e '.name' >/dev/null && \
   echo "$workflow_json" | jq -e '.description' >/dev/null && \
   echo "$workflow_json" | jq -e '.execution_mode' >/dev/null && \
   echo "$workflow_json" | jq -e '.phases' >/dev/null; then
    test_pass
else
    test_fail "Missing required fields in parsed JSON"
fi

# Test 3: Load invalid YAML (missing name)
test_start "Reject workflow missing required field (name)"
set +e
load_workflow "$WORKFLOW_DIR/tests/fixtures/invalid-missing-name.workflow.yaml" >/dev/null 2>&1
exit_code=$?
set -e
if [ $exit_code -ne 0 ]; then
    test_pass
else
    test_fail "Should have rejected workflow missing name field"
fi

# Test 4: Load invalid YAML (bad execution mode)
test_start "Reject workflow with invalid execution_mode"
set +e
load_workflow "$WORKFLOW_DIR/tests/fixtures/invalid-bad-mode.workflow.yaml" >/dev/null 2>&1
exit_code=$?
set -e
if [ $exit_code -ne 0 ]; then
    test_pass
else
    test_fail "Should have rejected invalid execution_mode"
fi

# Test 5: Load non-existent file
test_start "Handle non-existent file gracefully"
set +e
load_workflow "$WORKFLOW_DIR/tests/fixtures/does-not-exist.yaml" >/dev/null 2>&1
exit_code=$?
set -e
if [ $exit_code -ne 0 ]; then
    test_pass
else
    test_fail "Should have failed on non-existent file"
fi

# Test 6: Get correct phase count
test_start "Get correct phase count"
workflow_json=$(load_workflow "$WORKFLOW_DIR/tests/fixtures/simple.workflow.yaml")
phase_count=$(get_phase_count "$workflow_json")
if assert_equals "1" "$phase_count" "Phase count should be 1"; then
    test_pass
fi

# Test 7: Get phase by index
test_start "Get phase by index"
phase=$(get_phase_by_index "$workflow_json" 0)
if echo "$phase" | jq -e '.id' >/dev/null && \
   echo "$phase" | jq -r '.id' | grep -q "phase1"; then
    test_pass
else
    test_fail "Failed to get phase by index"
fi

# Test 8: Get phase by ID
test_start "Get phase by ID"
phase=$(get_phase "$workflow_json" "phase1")
if echo "$phase" | jq -e '.name' >/dev/null && \
   echo "$phase" | jq -r '.name' | grep -q "Phase 1"; then
    test_pass
else
    test_fail "Failed to get phase by ID"
fi

# Test 9: Validate execution mode values
test_start "Accept valid execution modes (strict/loose/adaptive)"
all_passed=true
for mode in strict loose adaptive; do
    # Create temp workflow with mode
    temp_workflow="$TEST_DIR/temp-$mode.workflow.yaml"

    # loose requires main-only, adaptive cannot use main-only, strict allows all
    if [ "$mode" = "adaptive" ]; then
        cat > "$temp_workflow" <<EOF
name: "Test $mode"
description: "Test"
version: "1.0.0"
execution_mode: $mode
phases:
  - id: phase1
    name: "Phase 1"
    description: "Test"
    behavior: parallel
    subagents:
      - type: test-agent
        prompt: "Test"
finalization:
  template: "Test"
  output: "test.md"
EOF
    else
        cat > "$temp_workflow" <<EOF
name: "Test $mode"
description: "Test"
version: "1.0.0"
execution_mode: $mode
phases:
  - id: phase1
    name: "Phase 1"
    description: "Test"
    behavior: main-only
    main_agent:
      script: "return {status: 'complete'};"
finalization:
  template: "Test"
  output: "test.md"
EOF
    fi

    if ! load_workflow "$temp_workflow" >/dev/null 2>&1; then
        all_passed=false
        break
    fi
done
if [ "$all_passed" = "true" ]; then
    test_pass
else
    test_fail "Should accept all execution modes"
fi

# Test 10: Validate phase behaviors
test_start "Accept valid phase behaviors (parallel/sequential/main-only)"
all_passed=true
for behavior in parallel sequential main-only; do
    temp_workflow="$TEST_DIR/temp-behavior-$behavior.workflow.yaml"

    # parallel/sequential need subagents for strict mode
    if [ "$behavior" = "main-only" ]; then
        cat > "$temp_workflow" <<EOF
name: "Test $behavior"
description: "Test"
version: "1.0.0"
execution_mode: strict
phases:
  - id: phase1
    name: "Phase 1"
    description: "Test"
    behavior: $behavior
    main_agent:
      script: "return {status: 'complete'};"
finalization:
  template: "Test"
  output: "test.md"
EOF
    else
        cat > "$temp_workflow" <<EOF
name: "Test $behavior"
description: "Test"
version: "1.0.0"
execution_mode: strict
phases:
  - id: phase1
    name: "Phase 1"
    description: "Test"
    behavior: $behavior
    subagents:
      - type: test-agent
        prompt: "Test"
finalization:
  template: "Test"
  output: "test.md"
EOF
    fi

    if ! load_workflow "$temp_workflow" >/dev/null 2>&1; then
        all_passed=false
        break
    fi
done
if [ "$all_passed" = "true" ]; then
    test_pass
else
    test_fail "Should accept all behaviors"
fi

# Cleanup
cleanup_test_env

# Summary
test_summary

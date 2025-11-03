#!/usr/bin/env bash
# Unit tests for context-manager.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/../test-framework.sh"
source "$WORKFLOW_DIR/engine/context-manager.sh"

# Setup
setup_test_env "$SCRIPT_DIR/../.tmp/test-context"

echo "Testing context-manager.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Initialize context
test_start "Initialize context creates context.json"
CONTEXT_DIR=$(cd "$TEST_DIR" && context_init "test-feature" "test-workflow" "strict")
CONTEXT_FILE="$TEST_DIR/$CONTEXT_DIR/context.json"
if assert_file_exists "$CONTEXT_FILE"; then
    test_pass
fi

# Test 2: Context has required fields
test_start "Initialized context has required fields"
context=$(cat "$CONTEXT_FILE")
if echo "$context" | jq -e '.feature.name' >/dev/null && \
   echo "$context" | jq -e '.workflow.name' >/dev/null && \
   echo "$context" | jq -e '.feature.flags' >/dev/null && \
   echo "$context" | jq -e '.phases | has("current")' >/dev/null && \
   echo "$context" | jq -e '.phases.completed' >/dev/null; then
    test_pass
else
    test_fail "Missing required fields in context"
fi

# Test 3: Context update
test_start "Update context value"
context_update ".custom_field" "\"custom_value\""
context=$(cat "$CONTEXT_FILE")
actual=$(echo "$context" | jq -r '.custom_field')
if assert_equals "custom_value" "$actual"; then
    test_pass
fi

# Test 4: Context read
test_start "Read context value"
value=$(context_read ".feature.name")
if assert_equals "test-feature" "$value"; then
    test_pass
fi

# Test 5: Phase start
test_start "Mark phase as started"
phase_start "phase1"
context=$(cat "$CONTEXT_FILE")
current=$(echo "$context" | jq -r '.phases.current')
if assert_equals "phase1" "$current"; then
    test_pass
fi

# Test 6: Phase complete
test_start "Mark phase as completed"
phase_complete "phase1"
context=$(cat "$CONTEXT_FILE")
completed=$(echo "$context" | jq -r '.phases.completed | index("phase1")')
if [ "$completed" != "null" ]; then
    test_pass
else
    test_fail "Phase not added to completed_phases array"
fi

# Test 7: Subagent counter
test_start "Increment subagent counter"
initial_count=$(context_read ".subagents_spawned")
subagent_spawned
new_count=$(context_read ".subagents_spawned")
expected=$((initial_count + 1))
if assert_equals "$expected" "$new_count"; then
    test_pass
fi

# Test 8: Add deliverable
test_start "Track deliverable path"
# Create dummy file for deliverable tracking
touch "$TEST_DIR/output.md"
add_deliverable "phase1" "$TEST_DIR/output.md"
context=$(cat "$CONTEXT_FILE")
# Check if deliverable was added (it's an object with path field)
deliverables=$(echo "$context" | jq -r '.deliverables[] | select(.path == "'"$TEST_DIR/output.md"'") | .path')
if [ -n "$deliverables" ] && [ "$deliverables" = "$TEST_DIR/output.md" ]; then
    test_pass
else
    test_fail "Deliverable not added to array"
fi

# Test 9: Record checkpoint
test_start "Record checkpoint decision"
record_checkpoint "checkpoint1" "continue"
context=$(cat "$CONTEXT_FILE")
checkpoints=$(echo "$context" | jq -r '.checkpoints | length')
if [ "$checkpoints" -gt 0 ]; then
    test_pass
else
    test_fail "Checkpoint not recorded"
fi

# Test 10: Save snapshot
test_start "Save context snapshot"
backup_file=$(save_snapshot)
if [ -n "$backup_file" ] && [ -f "$backup_file" ]; then
    test_pass
else
    test_fail "Snapshot file not created"
fi

# Test 11: Multiple phase completions
test_start "Track multiple completed phases"
CONTEXT_DIR2=$(cd "$TEST_DIR" && context_init "multi-phase-test" "test" "strict")
CONTEXT_FILE2="$TEST_DIR/$CONTEXT_DIR2/context.json"
export CONTEXT_FILE="$CONTEXT_FILE2"
phase_start "phase1"
phase_complete "phase1"
phase_start "phase2"
phase_complete "phase2"
phase_start "phase3"
phase_complete "phase3"
context=$(cat "$CONTEXT_FILE2")
count=$(echo "$context" | jq -r '.phases.completed | length')
if assert_equals "3" "$count"; then
    test_pass
fi

# Test 12: Persist across operations
test_start "Context persists across multiple operations"
CONTEXT_DIR3=$(cd "$TEST_DIR" && context_init "persist-test" "test" "strict")
CONTEXT_FILE3="$TEST_DIR/$CONTEXT_DIR3/context.json"
export CONTEXT_FILE="$CONTEXT_FILE3"
# Create dummy files for deliverables
touch "$TEST_DIR/file1.md"
touch "$TEST_DIR/file2.md"
context_update ".key1" "\"value1\""
context_update ".key2" "\"value2\""
add_deliverable "phase1" "$TEST_DIR/file1.md"
add_deliverable "phase1" "$TEST_DIR/file2.md"
subagent_spawned
subagent_spawned

context=$(cat "$CONTEXT_FILE3")
key1=$(echo "$context" | jq -r '.key1')
key2=$(echo "$context" | jq -r '.key2')
deliverable_count=$(echo "$context" | jq -r '.deliverables | length')
subagent_count=$(echo "$context" | jq -r '.subagents_spawned')

if [ "$key1" = "value1" ] && [ "$key2" = "value2" ] && \
   [ "$deliverable_count" -eq 2 ] && [ "$subagent_count" -eq 2 ]; then
    test_pass
else
    test_fail "Context not persisting correctly across operations"
fi

# Cleanup
cleanup_test_env

# Summary
test_summary

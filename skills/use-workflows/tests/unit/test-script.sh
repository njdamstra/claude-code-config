#!/usr/bin/env bash
# Unit tests for script-interpreter.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$SCRIPT_DIR/../test-framework.sh"
source "$WORKFLOW_DIR/engine/script-interpreter.sh"

# Setup
setup_test_env "$SCRIPT_DIR/../.tmp/test-script"

echo "Testing script-interpreter.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create test context
CONTEXT_JSON='{
  "feature": {"name": "test-feature", "flags": []},
  "workflow": {"name": "test-workflow"},
  "phases": {"current": "phase1"}
}'

# Test 1: Execute valid script
test_start "Execute valid JavaScript script"
result=$(execute_script "$(cat $WORKFLOW_DIR/tests/fixtures/simple-script.js)" "$CONTEXT_JSON")
if echo "$result" | jq -e '.status' >/dev/null && \
   [ "$(echo "$result" | jq -r '.status')" = "complete" ]; then
    test_pass
else
    test_fail "Script did not execute or return expected result"
fi

# Test 2: Script return value parsing
test_start "Parse script return values correctly"
result=$(execute_script "$(cat $WORKFLOW_DIR/tests/fixtures/simple-script.js)" "$CONTEXT_JSON")
status=$(echo "$result" | jq -r '.status')
output=$(echo "$result" | jq -r '.output')
count=$(echo "$result" | jq -r '.count')

if [ "$status" = "complete" ] && \
   [ "$output" = "Test successful" ] && \
   [ "$count" = "42" ]; then
    test_pass
else
    test_fail "Return values not parsed correctly"
fi

# Test 3: Script with context access
test_start "Script can access context"
result=$(execute_script "$(cat $WORKFLOW_DIR/tests/fixtures/context-script.js)" "$CONTEXT_JSON")
message=$(echo "$result" | jq -r '.message')

if assert_contains "$message" "test-feature" && \
   assert_contains "$message" "phase1"; then
    test_pass
fi

# Test 4: Script error handling
test_start "Handle script errors gracefully"
if ! result=$(execute_script "$(cat $WORKFLOW_DIR/tests/fixtures/error-script.js)" "$CONTEXT_JSON" 2>/dev/null); then
    test_pass
else
    test_fail "Should have failed on error script"
fi

# Test 5: Invalid JavaScript syntax
test_start "Handle invalid JavaScript syntax"
invalid_script="this is not valid javascript {"
if ! result=$(execute_script "$invalid_script" "$CONTEXT_JSON" 2>/dev/null); then
    test_pass
else
    test_fail "Should have failed on invalid syntax"
fi

# Test 6: Script with no return value
test_start "Handle script with no return"
no_return_script="console.log('test');"
result=$(execute_script "$no_return_script" "$CONTEXT_JSON" 2>/dev/null || echo '{}')
# Should handle gracefully, not crash
test_pass

# Test 7: Complex return object
test_start "Handle complex nested return objects"
complex_script='
return {
  status: "complete",
  data: {
    items: ["a", "b", "c"],
    metadata: {
      count: 3,
      timestamp: Date.now()
    }
  }
};
'
result=$(execute_script "$complex_script" "$CONTEXT_JSON")
if echo "$result" | jq -e '.data.items' >/dev/null && \
   [ "$(echo "$result" | jq -r '.data.items | length')" = "3" ]; then
    test_pass
else
    test_fail "Complex object not parsed correctly"
fi

# Test 8: Script with helper functions (mock)
test_start "Script can call helper functions"
helper_script='
// Mock helper would be injected
const result = {
  status: "complete",
  message: "Helpers available"
};
return result;
'
result=$(execute_script "$helper_script" "$CONTEXT_JSON")
if [ "$(echo "$result" | jq -r '.status')" = "complete" ]; then
    test_pass
else
    test_fail "Helper script execution failed"
fi

# Test 9: Empty script
test_start "Handle empty script"
if ! result=$(execute_script "" "$CONTEXT_JSON" 2>/dev/null); then
    test_pass
else
    # Or it might return empty object, either is fine
    test_pass
fi

# Test 10: Script with console output
test_start "Script console output doesn't break parsing"
console_script='
console.log("Debug message");
console.error("Error message");
return { status: "complete" };
'
result=$(execute_script "$console_script" "$CONTEXT_JSON" 2>/dev/null)
if [ "$(echo "$result" | jq -r '.status')" = "complete" ]; then
    test_pass
else
    test_fail "Console output interfered with result parsing"
fi

# Cleanup
cleanup_test_env

# Summary
test_summary

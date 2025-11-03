#!/bin/bash
# Test Framework for Workflow Engine
# Provides assertion helpers and test reporting

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
CURRENT_TEST=""

# Start a test
test_start() {
    CURRENT_TEST="$1"
    TESTS_RUN=$((TESTS_RUN + 1))
}

# Pass a test
test_pass() {
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "${GREEN}✓${NC} $CURRENT_TEST"
}

# Fail a test
test_fail() {
    local message="$1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo -e "${RED}✗${NC} $CURRENT_TEST"
    echo -e "  ${RED}Error:${NC} $message"
}

# Assert equals
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Values do not match}"

    if [ "$expected" = "$actual" ]; then
        return 0
    else
        test_fail "$message\n  Expected: '$expected'\n  Actual: '$actual'"
        return 1
    fi
}

# Assert contains
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-String does not contain expected value}"

    if echo "$haystack" | grep -q "$needle"; then
        return 0
    else
        test_fail "$message\n  Expected to find: '$needle'\n  In: '$haystack'"
        return 1
    fi
}

# Assert file exists
assert_file_exists() {
    local filepath="$1"
    local message="${2:-File does not exist: $filepath}"

    if [ -f "$filepath" ]; then
        return 0
    else
        test_fail "$message"
        return 1
    fi
}

# Assert file not exists
assert_file_not_exists() {
    local filepath="$1"
    local message="${2:-File should not exist: $filepath}"

    if [ ! -f "$filepath" ]; then
        return 0
    else
        test_fail "$message"
        return 1
    fi
}

# Assert command succeeds
assert_success() {
    local command="$1"
    local message="${2:-Command failed: $command}"

    if eval "$command" &>/dev/null; then
        return 0
    else
        test_fail "$message"
        return 1
    fi
}

# Assert command fails
assert_fails() {
    local command="$1"
    local message="${2:-Command should have failed: $command}"

    if ! eval "$command" &>/dev/null; then
        return 0
    else
        test_fail "$message"
        return 1
    fi
}

# Assert JSON value equals
assert_json_equals() {
    local json="$1"
    local jq_query="$2"
    local expected="$3"
    local message="${4:-JSON value does not match}"

    local actual=$(echo "$json" | jq -r "$jq_query")
    assert_equals "$expected" "$actual" "$message"
}

# Print test summary
test_summary() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Test Results:"
    echo "  Total: $TESTS_RUN"
    echo -e "  ${GREEN}Passed: $TESTS_PASSED${NC}"
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "  ${RED}Failed: $TESTS_FAILED${NC}"
    else
        echo "  Failed: 0"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ $TESTS_FAILED -gt 0 ]; then
        return 1
    else
        return 0
    fi
}

# Setup test environment
setup_test_env() {
    local test_dir="$1"
    mkdir -p "$test_dir"
    export TEST_DIR="$test_dir"
    export TEST_WORKFLOW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
}

# Cleanup test environment
cleanup_test_env() {
    if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
}

# Create a test fixture file
create_fixture() {
    local name="$1"
    local content="$2"
    local fixture_path="$TEST_DIR/fixtures/$name"
    mkdir -p "$(dirname "$fixture_path")"
    echo "$content" > "$fixture_path"
    echo "$fixture_path"
}

# Load a fixture file
load_fixture() {
    local name="$1"
    local fixtures_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/fixtures"
    cat "$fixtures_dir/$name"
}

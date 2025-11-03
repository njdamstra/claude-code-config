#!/usr/bin/env bash
# Test runner for workflow engine
# Runs all unit and integration tests

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Counters
TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FAILED=0
SUITES_FAILED=0

# Parse arguments
RUN_UNIT=true
RUN_INTEGRATION=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --unit)
            RUN_INTEGRATION=false
            shift
            ;;
        --integration)
            RUN_UNIT=false
            shift
            ;;
        --help)
            echo "Usage: $0 [--unit] [--integration]"
            echo "  --unit         Run only unit tests"
            echo "  --integration  Run only integration tests"
            echo "  (no flags)     Run all tests"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Workflow Engine Test Suite"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

run_test_suite() {
    local test_file=$1
    local test_name=$(basename "$test_file" .sh)

    echo -e "${BLUE}Running: ${test_name}${NC}"

    if "$test_file"; then
        echo -e "${GREEN}✓ ${test_name} passed${NC}"
        echo ""
    else
        echo -e "${RED}✗ ${test_name} FAILED${NC}"
        SUITES_FAILED=$((SUITES_FAILED + 1))
        echo ""
    fi
}

# Run unit tests
if [ "$RUN_UNIT" = true ]; then
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}UNIT TESTS${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo ""

    for test_file in "$SCRIPT_DIR"/unit/test-*.sh; do
        if [ -f "$test_file" ]; then
            run_test_suite "$test_file"
        fi
    done
fi

# Run integration tests
if [ "$RUN_INTEGRATION" = true ]; then
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}INTEGRATION TESTS${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo ""

    if [ -d "$SCRIPT_DIR/integration" ]; then
        for test_file in "$SCRIPT_DIR"/integration/test-*.sh; do
            if [ -f "$test_file" ]; then
                run_test_suite "$test_file"
            fi
        done
    else
        echo -e "${YELLOW}No integration tests found${NC}"
        echo ""
    fi
fi

# Final summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FINAL RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $SUITES_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All test suites passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ $SUITES_FAILED test suite(s) failed${NC}"
    exit 1
fi

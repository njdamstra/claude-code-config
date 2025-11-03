# Testing Strategy

## Unit Tests

### workflow-loader.sh
**File:** `tests/unit/test-loader.sh`

| Test | Input | Expected |
|------|-------|----------|
| Load valid YAML | `workflows/new-feature.workflow.yaml` | Parsed JSON with all fields |
| Load invalid YAML | Malformed YAML | Error with line number |
| Missing required field | YAML without `phases` | Validation error |
| Invalid execution_mode | `execution_mode: "invalid"` | Validation error |
| Invalid behavior | `behavior: "invalid"` | Validation error |
| Empty phases array | `phases: []` | Validation error |
| Get phase by ID | `get_phase("discovery")` | Correct phase object |
| Get phase count | Valid workflow | Correct count |

---

### phase-executor.sh
**File:** `tests/unit/test-executor.sh`

| Test | Mode | Behavior | Expected |
|------|------|----------|----------|
| Strict parallel (≤5 agents) | strict | parallel | All spawned simultaneously |
| Strict parallel (>5 agents) | strict | parallel | Batched (5 at a time) |
| Strict sequential | strict | sequential | One-by-one spawning |
| Strict main-only | strict | main-only | Only main script executed |
| Loose mode | loose | main-only | Main script + suggested logged |
| Adaptive always | adaptive | parallel | Always subagents spawned |
| Adaptive conditional | adaptive | parallel | Additional spawned based on script |
| Adaptive sequential | adaptive | sequential | Always then additional (sequential) |

---

### context-manager.sh
**File:** `tests/unit/test-context.sh`

| Test | Operation | Expected |
|------|-----------|----------|
| Initialize context | `init_context("feature", "workflow", flags)` | context.json created |
| Update value | `context_update("key", "value")` | JSON updated correctly |
| Read value | `context_read("key")` | Correct value returned |
| Phase start | `phase_start("discovery")` | current_phase set |
| Phase complete | `phase_complete("discovery")` | Added to completed_phases |
| Subagent spawned | `subagent_spawned()` | Counter incremented |
| Add deliverable | `add_deliverable(path)` | Path added to array |
| Record checkpoint | `record_checkpoint(id, decision)` | Checkpoint recorded |
| Save snapshot | `save_snapshot()` | Backup created |

---

### checkpoint-handler.sh
**File:** `tests/unit/test-checkpoint.sh`

| Test | Checkpoint Type | Action | Expected |
|------|----------------|--------|----------|
| Simple approval (continue) | Simple | Continue | Return CONTINUE |
| Simple approval (abort) | Simple | Abort | Return ABORT |
| Custom checkpoint (continue) | Custom | Continue | Return CONTINUE |
| Custom checkpoint (repeat) | Custom | repeat_phase | Phase index updated, return REPEAT_PHASE |
| Custom checkpoint (skip) | Custom | skip_phases | Phases added to skip list |
| Custom checkpoint (abort) | Custom | Abort | Return ABORT |
| Conditional checkpoint (false) | Custom + condition | - | Checkpoint skipped |
| Conditional checkpoint (true) | Custom + condition | - | Checkpoint shown |
| Feedback collection | Custom + with_feedback | - | Feedback recorded |

---

### gap-check-manager.sh
**File:** `tests/unit/test-gap-check.sh`

| Test | Type | Status | Action | Expected |
|------|------|--------|--------|----------|
| Gap check disabled | - | - | - | Skipped |
| Script-based pass | Script | complete | - | Return CONTINUE |
| Script-based fail (retry) | Script | incomplete | retry | Return RETRY_PHASE |
| Script-based fail (spawn) | Script | incomplete | spawn_additional | Agents spawned, return CONTINUE |
| Script-based fail (escalate) | Script | incomplete | escalate | User prompted |
| Script-based fail (abort) | Script | incomplete | abort | Exit 1 |
| Max iterations | Script | incomplete | retry | Escalation triggered |
| Criteria-based pass | Criteria | - | - | Return CONTINUE |
| Criteria-based fail | Criteria | - | retry | Action executed |

---

### script-interpreter.sh
**File:** `tests/unit/test-script.sh`

| Test | Script | Expected |
|------|--------|----------|
| Execute valid script | `return {status: 'complete'}` | Correct return value |
| Script with context | Access `context.feature.name` | Context accessible |
| Script error | Syntax error | Error logged, handled gracefully |
| Script timeout | Infinite loop | Timeout after 30s |
| Invalid return value | Non-JSON return | Warning logged |

---

### template-renderer.sh
**File:** `tests/unit/test-template.sh`

| Test | Renderer | Expected |
|------|----------|----------|
| Render with mustache | Template + context | Correct output |
| Render with fallback | Template + context | Correct output (simple substitution) |
| Variable substitution | `{{name}}` | Replaced with value |
| Missing variable | `{{missing}}` | Empty string |
| Subagent prompt | Workflow-specific template | Correct template used |

---

## Integration Tests

### new-feature Workflow
**File:** `tests/integration/test-new-feature.sh`

**Setup:**
```yaml
workflow: new-feature
execution_mode: adaptive
phases: 5
```

**Test:**
1. Execute complete workflow
2. Verify all 5 phases executed
3. Verify deliverables created (≥8 files)
4. Verify metadata.json exists and valid
5. Verify final plan rendered

---

### debugging Workflow
**File:** `tests/integration/test-debugging.sh`

**Setup:**
```yaml
workflow: debugging
execution_mode: strict
phases: 4
```

**Test:**
1. Execute complete workflow
2. Verify all 4 phases executed
3. Verify bug report created
4. Verify fix plan created
5. Verify metadata.json valid

---

### refactoring Workflow
**File:** `tests/integration/test-refactoring.sh`

**Setup:**
```yaml
workflow: refactoring
execution_mode: strict
phases: 4
```

**Test:**
1. Execute complete workflow
2. Verify dependency mapping done
3. Verify refactor plan created
4. Verify metadata.json valid

---

### improving Workflow
**File:** `tests/integration/test-improving.sh`

**Setup:**
```yaml
workflow: improving
execution_mode: adaptive
phases: 4
```

**Test:**
1. Execute complete workflow
2. Verify opportunity scanning
3. Verify improvement plan
4. Verify metadata.json valid

---

### quick Workflow
**File:** `tests/integration/test-quick.sh`

**Setup:**
```yaml
workflow: quick
execution_mode: loose
phases: 2
```

**Test:**
1. Execute complete workflow
2. Verify fast execution (no unnecessary subagents)
3. Verify implementation done
4. Verify metadata.json valid

---

### Custom Workflows
**File:** `tests/integration/test-custom-workflows.sh`

**Test:**
1. Execute `examples/custom-research.workflow.yaml`
2. Execute `examples/code-review.workflow.yaml`
3. Execute `examples/performance-optimization.workflow.yaml`
4. Verify all complete successfully
5. Verify metadata for each

---

## Execution Mode Tests

### Strict Mode Scenarios
**File:** `tests/modes/test-strict-mode.sh`

| Scenario | Behavior | Subagents | Expected |
|----------|----------|-----------|----------|
| Parallel (3 agents) | parallel | 3 | All spawn simultaneously |
| Parallel (10 agents) | parallel | 10 | Batched (5+5) |
| Sequential (3 agents) | sequential | 3 | One-by-one |
| Main-only | main-only | 0 | Only main script |

---

### Loose Mode Scenarios
**File:** `tests/modes/test-loose-mode.sh`

| Scenario | Expected |
|----------|----------|
| Main script executes | Success |
| Suggested subagents logged | Logged only, not spawned |
| Main has full control | No automatic spawning |

---

### Adaptive Mode Scenarios
**File:** `tests/modes/test-adaptive-mode.sh`

| Scenario | Always | Adaptive | Expected |
|----------|--------|----------|----------|
| Always only | 2 | 0 | 2 spawned |
| Always + adaptive | 2 | 3 | 5 total spawned |
| Sequential behavior | 1 | 2 | One-by-one (3 total) |

---

## Performance Benchmarks

### Workflow Execution Time
**File:** `tests/performance/test-execution-time.sh`

| Workflow | Max Duration |
|----------|--------------|
| quick | < 10s |
| new-feature | < 60s |
| debugging | < 45s |
| refactoring | < 45s |
| improving | < 50s |

---

### YAML Parsing
**File:** `tests/performance/test-yaml-parsing.sh`

| Size | Max Duration |
|------|--------------|
| Small (5 phases) | < 100ms |
| Medium (10 phases) | < 200ms |
| Large (20 phases) | < 500ms |

---

### Context Updates
**File:** `tests/performance/test-context-updates.sh`

| Operation | Max Duration |
|-----------|--------------|
| Read context | < 10ms |
| Update field | < 20ms |
| Append array | < 20ms |
| Save context | < 50ms |

---

## Test Runner

### tests/run-all-tests.sh
```bash
#!/usr/bin/env bash

set -euo pipefail

PASS_COUNT=0
FAIL_COUNT=0

run_test_suite() {
  local suite=$1
  echo "Running $suite..."

  if bash "$suite"; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "✓ $suite passed"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "✗ $suite failed"
  fi
}

# Unit tests
run_test_suite "tests/unit/test-loader.sh"
run_test_suite "tests/unit/test-executor.sh"
run_test_suite "tests/unit/test-context.sh"
run_test_suite "tests/unit/test-checkpoint.sh"
run_test_suite "tests/unit/test-gap-check.sh"
run_test_suite "tests/unit/test-script.sh"
run_test_suite "tests/unit/test-template.sh"

# Integration tests
run_test_suite "tests/integration/test-new-feature.sh"
run_test_suite "tests/integration/test-debugging.sh"
run_test_suite "tests/integration/test-refactoring.sh"
run_test_suite "tests/integration/test-improving.sh"
run_test_suite "tests/integration/test-quick.sh"
run_test_suite "tests/integration/test-custom-workflows.sh"

echo ""
echo "======================================"
echo "Test Results: $PASS_COUNT passed, $FAIL_COUNT failed"
echo "======================================"

if [ $FAIL_COUNT -eq 0 ]; then
  echo "All tests passed ✓"
  exit 0
else
  echo "Some tests failed ✗"
  exit 1
fi
```

---

## Test Utilities

### tests/helpers.sh
```bash
#!/usr/bin/env bash

assert_equals() {
  local expected=$1
  local actual=$2
  local message=${3:-"Assertion failed"}

  if [ "$expected" != "$actual" ]; then
    echo "✗ $message"
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
  return 0
}

assert_file_exists() {
  local file=$1
  if [ ! -f "$file" ]; then
    echo "✗ File does not exist: $file"
    return 1
  fi
  return 0
}

assert_json_field() {
  local json=$1
  local field=$2
  local expected=$3

  local actual=$(echo "$json" | jq -r ".$field")
  assert_equals "$expected" "$actual" "JSON field $field"
}
```

---

## Coverage Goals

| Component | Target |
|-----------|--------|
| workflow-loader.sh | 100% |
| phase-executor.sh | 95% |
| context-manager.sh | 100% |
| checkpoint-handler.sh | 90% |
| gap-check-manager.sh | 90% |
| script-interpreter.sh | 85% |
| template-renderer.sh | 90% |
| Overall | 90%+ |

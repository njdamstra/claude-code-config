# Phase 5: Testing Strategy

## Overview

Define comprehensive testing approach including unit, integration, and manual testing.

## Step 1: Review Implementation Plan

**No subagents spawned** - Main agent designs testing.

Read `{{workspace}}/{{output_dir}}/implementation.md` to understand what's being built.

Identify:
- Components that need testing
- Functions that need unit tests
- Integration points that need testing
- User flows that need manual testing

## Step 2: Define Unit Test Requirements

For each testable unit (component, function, composable), specify:

### [Component/Function Name]

**File:** `[path to test file]`

**Test cases:**
1. **[Test case name]**
   - **Given:** [Initial state]
   - **When:** [Action]
   - **Then:** [Expected outcome]

2. **[Test case name]**
   - [Same structure]

**Mocking requirements:**
- Mock: [What needs to be mocked]
- Stub: [What needs to be stubbed]

---

## Step 3: Define Integration Test Scenarios

Identify workflows that span multiple components/systems:

### Scenario 1: [Name]

**Description:** [What this workflow tests]

**Setup:**
- [Required setup steps]
- [Test data needed]

**Steps:**
1. [Action step 1]
2. [Action step 2]
3. [Action step 3]

**Expected outcomes:**
- [ ] [Outcome 1]
- [ ] [Outcome 2]

**Cleanup:**
- [Cleanup steps]

---

## Step 4: Create Manual Testing Checklist

For features that require manual verification:

### Manual Test 1: [Feature Name]

**Objective:** [What to verify]

**Prerequisites:**
- [What needs to be set up]

**Steps:**
1. [Manual step 1]
2. [Manual step 2]
3. [Manual step 3]

**Expected results:**
- [ ] [Result 1]
- [ ] [Result 2]

**Edge cases to test:**
- [ ] [Edge case 1]
- [ ] [Edge case 2]

---

## Step 5: Document Edge Cases

List critical edge cases to test:

1. **[Edge case name]:** [Description]
   - **How to test:** [Steps]
   - **Expected behavior:** [What should happen]

2. **[Edge case name]:** [Description]
   - [Same structure]

## Step 6: Define Test Coverage Targets

Set coverage expectations:
- **Unit tests:** Aim for [X]% coverage of core logic
- **Integration tests:** Cover [Y] critical workflows
- **Manual tests:** Verify [Z] user journeys

## Step 7: Write Testing Document

Write to: `{{workspace}}/{{output_dir}}/testing.md`

Format:
```markdown
# Testing Strategy

## Overview
[Brief summary of testing approach]

## Unit Test Requirements

### [Component/Function 1]
[Test cases, mocking requirements]

### [Component/Function 2]
[Test cases, mocking requirements]

## Integration Test Scenarios

### Scenario 1: [Name]
[Description, setup, steps, expected outcomes]

### Scenario 2: [Name]
[Same structure]

## Manual Testing Checklist

### Test 1: [Feature]
[Objective, prerequisites, steps, expected results]

### Test 2: [Feature]
[Same structure]

## Edge Cases

1. [Edge case with testing approach]
2. [Edge case with testing approach]

## Test Coverage Targets
- Unit: [X]%
- Integration: [Y] workflows
- Manual: [Z] journeys

## Testing Tools
- Framework: [Vitest/Jest/etc.]
- Component testing: [@testing-library/vue]
- E2E: [Playwright/Cypress if needed]
```

## Step 8: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Testing strategy has gaps:

[List specific missing elements]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 9: Checkpoint Review

**Present to user:**

{{checkpoint_prompt}}

**Files for review:**
{{#checkpoint_show_files}}
- `{{.}}`
{{/checkpoint_show_files}}

**Ask user:**

What would you like to do next?
{{#checkpoint_options}}
{{index}}. {{value}}
{{/checkpoint_options}}

**Wait for user selection** before proceeding.
{{/checkpoint}}

{{^checkpoint}}
## Step 9: Proceed to Quality Review

Testing strategy complete. No checkpoint defined.

Continue directly to Phase 6: Quality Review.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/testing.md` - Comprehensive test plan

## Success Criteria

- ✓ Unit test requirements defined
- ✓ Integration scenarios documented
- ✓ Manual testing checklist created
- ✓ Edge cases identified
- ✓ Coverage targets set

---
allowed-tools: Read, Write, Edit, Bash(npm:*), Bash(pnpm:*), Bash(yarn:*), Bash(git:*), Bash(cat:*), Bash(ls:*), TodoWrite, Glob, Grep
argument-hint: [feature-name] [what-to-add?]
description: Validate implementation with automated checks and completion report
---

# Frontend Feature Validation

**Feature:** `$1`

## Phase 0: Initialize and Load Context

### Load Feature Description

If `$2` is provided, use it. Otherwise, read from stored FEATURE_CONTEXT.md:

```bash
# Find the most recent workspace for this feature (any type)
WORKSPACE=$(ls -td .temp/{analyze,initiate,quick-task}-$1-* 2>/dev/null | head -1)

if [ -z "$2" ] && [ -d "$WORKSPACE" ] && [ -f "$WORKSPACE/FEATURE_CONTEXT.md" ]; then
  # Read description from stored context
  DESCRIPTION=$(grep "^**Description:**" "$WORKSPACE/FEATURE_CONTEXT.md" | sed 's/^**Description:** //')
  echo "📖 Loaded feature description from $WORKSPACE/FEATURE_CONTEXT.md"
  echo "Feature: $1"
  echo "Description: $DESCRIPTION"
else
  DESCRIPTION="$2"
fi

# If still no description, error
if [ -z "$DESCRIPTION" ]; then
  echo "❌ Error: No description provided and no FEATURE_CONTEXT.md found."
  echo "Either:"
  echo "  1. Run /frontend-analyze \"$1\" \"description\" first, OR"
  echo "  2. Run /frontend-initiate \"$1\" \"description\" first, OR"
  echo "  3. Run /frontend-quick-task \"$1\" \"description\" first, OR"
  echo "  4. Provide description: /frontend-validate \"$1\" \"description\""
  exit 1
fi
```

**Addition:** `$DESCRIPTION` (from $2 or stored context)

## Prerequisites

You must have completed:
1. `/frontend-analyze "$1" "$DESCRIPTION"` → PRE_ANALYSIS.md
2. `/frontend-plan "$1"` → MASTER_PLAN.md
3. `/frontend-implement "$1"` → Implementation complete

Or completed `/frontend-initiate "$1" "$DESCRIPTION"` + `/frontend-implement "$1"`

Or completed `/frontend-quick-task "$1" "$DESCRIPTION"`

## Phase 0: Initialize Validation

### Create Todo List

```json
{
  "todos": [
    {
      "content": "Run automated validation checks",
      "status": "in_progress",
      "activeForm": "Running automated checks"
    },
    {
      "content": "Verify backward compatibility",
      "status": "pending",
      "activeForm": "Verifying backward compatibility"
    },
    {
      "content": "Run regression tests",
      "status": "pending",
      "activeForm": "Running regression tests"
    },
    {
      "content": "Create COMPLETION_REPORT.md",
      "status": "pending",
      "activeForm": "Creating completion report"
    },
    {
      "content": "Present results to user",
      "status": "pending",
      "activeForm": "Presenting results"
    }
  ]
}
```

## Phase 1: Automated Validation

Run these validation commands and capture results:

### 1. Type Checking

Detect and run appropriate type check command:

```bash
# Try these in order, use first that exists:
npm run typecheck || npm run type-check || pnpm typecheck || yarn typecheck || npx tsc --noEmit
```

**Capture:**
- Exit code (0 = pass, non-zero = fail)
- Error count
- Error details if any

### 2. Linting

Detect and run linting:

```bash
# Try these in order:
npm run lint || pnpm lint || yarn lint || npx eslint .
```

**Capture:**
- Exit code
- Warning count
- Error count
- Critical issues if any

### 3. Testing

Run test suite:

```bash
# Try these in order:
npm test || npm run test || pnpm test || yarn test
```

**Capture:**
- Exit code
- Tests passed/failed counts
- Coverage metrics if available
- Test failures if any

### 4. Build Validation

Run production build:

```bash
# Try these in order:
npm run build || pnpm build || yarn build
```

**Capture:**
- Exit code
- Build time
- Bundle size changes if available
- Build errors if any

## Phase 2: Backward Compatibility Verification

Check backward compatibility:

### 1. Existing Tests Status

Verify all pre-existing tests still pass:
- Compare test results to baseline
- Identify any newly failing tests
- Determine if failures are regressions

### 2. Component API Compatibility

Review modified components:
- All new props are optional or have defaults
- No removed or renamed props
- No changed prop types (breaking)
- Existing slots/events preserved

### 3. Store/State Compatibility

Review store changes:
- New actions added, none removed
- State structure extended, not changed
- Getters are additive
- No breaking changes to state shape

## Phase 3: Regression Testing

Manual regression checklist:

### Feature-Specific Regression

- [ ] Original "$1" feature still works as expected
- [ ] All existing use cases of "$1" function correctly
- [ ] No visual regressions in "$1" UI
- [ ] No console errors when using "$1"
- [ ] Performance not degraded

### New Functionality Verification

- [ ] New "$DESCRIPTION" functionality works as specified
- [ ] Edge cases handled correctly
- [ ] Error states work properly
- [ ] Loading states work properly
- [ ] Success states work properly

## Phase 4: Create Completion Report

Generate comprehensive `COMPLETION_REPORT.md`:

```markdown
# Completion Report: Adding "$DESCRIPTION" to $1

**Feature:** $1
**Addition:** $DESCRIPTION
**Date:** [Current date]
**Status:** [✅ READY FOR PRODUCTION | ⚠️ ISSUES FOUND | ❌ BLOCKED]

---

## Executive Summary

**What Was Added:**
[Brief 2-3 sentence description of functionality added]

**Approach:**
[Extension-first / Minimal changes / Custom implementation]

**Total Impact:**
- Files Modified: [N]
- Files Created: [N]
- Lines Added: [~X]
- Lines Removed: [~X]
- Net Change: [X] lines

**Status:** [Production-ready / Needs fixes / Blocked]

---

## Automated Validation Results

### Type Checking
- **Status:** [✅ PASSED | ❌ FAILED]
- **Command:** [command used]
- **Errors:** [N] errors
- **Details:** [Error summary if failed]

### Linting
- **Status:** [✅ PASSED | ⚠️ WARNINGS | ❌ FAILED]
- **Command:** [command used]
- **Warnings:** [N] warnings
- **Errors:** [N] errors
- **Details:** [Summary if issues]

### Testing
- **Status:** [✅ PASSED | ❌ FAILED]
- **Command:** [command used]
- **Tests Passed:** [N] / [Total]
- **Coverage:** [X%] (if available)
- **Failed Tests:** [List if any]

### Build
- **Status:** [✅ SUCCESS | ❌ FAILED]
- **Command:** [command used]
- **Build Time:** [X seconds]
- **Bundle Size:** [Size / change]
- **Errors:** [Details if failed]

**Overall Automated Validation:** [✅ ALL PASSED | ⚠️ SOME ISSUES | ❌ FAILURES]

---

## Backward Compatibility Assessment

### Component API Compatibility
- [✅/❌] All new props are optional or have defaults
- [✅/❌] No removed or renamed props
- [✅/❌] No breaking type changes
- [✅/❌] Existing slots/events preserved

### Store/State Compatibility
- [✅/❌] New actions added, none removed
- [✅/❌] State structure extended, not changed
- [✅/❌] Getters are additive
- [✅/❌] No breaking state changes

### Test Compatibility
- [✅/❌] All pre-existing tests still pass
- [✅/❌] No new test failures introduced
- [✅/❌] Test coverage maintained or improved

**Backward Compatibility Status:** [✅ FULLY COMPATIBLE | ⚠️ MIGRATION NEEDED | ❌ BREAKING CHANGES]

---

## Regression Testing Results

### Existing Feature ($1)
- [✅/❌] Original functionality works as expected
- [✅/❌] All existing use cases function correctly
- [✅/❌] No visual regressions
- [✅/❌] No console errors
- [✅/❌] Performance maintained

### New Functionality ($DESCRIPTION)
- [✅/❌] New functionality works as specified
- [✅/❌] Edge cases handled
- [✅/❌] Error states work
- [✅/❌] Loading states work
- [✅/❌] Success states work

**Regression Status:** [✅ NO REGRESSIONS | ⚠️ MINOR ISSUES | ❌ REGRESSIONS FOUND]

---

## Changes Summary

### Files Modified
[List each modified file with summary of changes]
- `path/to/file1.ts` - Added [X] actions, extended [Y]
- `path/to/file2.vue` - Added [X] props, enhanced [Y]

### Files Created
[List each new file with purpose]
- `path/to/newfile.ts` - Provides [functionality]

### Key Changes
1. **Store/State:** [Summary of changes]
2. **Composables/Hooks:** [Summary of changes]
3. **Components:** [Summary of changes]
4. **Types:** [Summary of changes]
5. **Tests:** [Summary of changes]

---

## Integration Analysis

**Integration Points:**
1. [Component X] receives new prop [$DESCRIPTION-related]
2. [Store action Y] dispatches to handle [$DESCRIPTION]
3. [Composable Z] provides [$DESCRIPTION] functionality

**Data Flow:**
```
User Input → Component → Store Action → API/Logic → State Update → Component Re-render
```

**New Dependencies Added:**
[List any new npm packages or external dependencies]

---

## Known Issues

### Critical Issues (Blockers)
[List any issues that prevent production deployment]
- None / [Issue description]

### Non-Critical Issues (Can be addressed post-deployment)
[List any minor issues or technical debt]
- None / [Issue description]

### Future Enhancements
[List any identified improvements for future iterations]
- [Enhancement 1]
- [Enhancement 2]

---

## Success Criteria Verification

Based on MASTER_PLAN.md success criteria:

- [✅/❌] Minimal code changes achieved
- [✅/❌] Backward compatibility maintained
- [✅/❌] Architecture patterns preserved
- [✅/❌] All tests passing
- [✅/❌] New "$DESCRIPTION" functionality works
- [✅/❌] Existing "$1" feature still works

**Success Criteria Met:** [X / Y] ([Percentage]%)

---

## Production Readiness Assessment

### Deployment Checklist
- [✅/❌] All automated checks pass
- [✅/❌] No regression issues
- [✅/❌] Backward compatible
- [✅/❌] Tests passing
- [✅/❌] Build successful
- [✅/❌] Code reviewed (if required)
- [✅/❌] Documentation updated (if needed)

**Production Ready:** [✅ YES | ⚠️ WITH CAVEATS | ❌ NO]

### Recommended Next Steps

If Production Ready:
1. Merge to main branch
2. Deploy to staging for final verification
3. Deploy to production
4. Monitor for issues

If Not Ready:
1. [Specific fix needed]
2. [Specific fix needed]
3. Re-run validation after fixes

---

## Artifacts & Documentation

**Analysis:** `.temp/analyze-$1-*/PRE_ANALYSIS.md`
**Plan:** `.temp/analyze-$1-*/MASTER_PLAN.md`
**Completion Report:** This file
**Modified Files:** [See Changes Summary above]

---

## Metrics

**Time Investment:**
- Analysis: [Estimated time]
- Planning: [Estimated time]
- Implementation: [Estimated time]
- Validation: [Actual time]
- **Total:** [Total time]

**Code Impact:**
- Complexity: [Low/Medium/High]
- Risk: [Low/Medium/High]
- Maintenance: [Low/Medium/High]

---

**Report Generated:** [Timestamp]
**Command:** `/frontend-validate "$1"`
```

## Phase 5: Present Results

Present validation summary to user:

```markdown
# Validation Complete for "$1" + "$DESCRIPTION" ✅

## Status: [✅ PRODUCTION READY | ⚠️ ISSUES FOUND | ❌ BLOCKED]

### Automated Checks
- Type Check: [✅ Pass / ❌ Fail] ([N] errors)
- Lint: [✅ Pass / ⚠️ Warn / ❌ Fail] ([N] issues)
- Tests: [✅ Pass / ❌ Fail] ([N passed / N total])
- Build: [✅ Success / ❌ Fail]

### Backward Compatibility
- Component API: [✅ Compatible / ❌ Breaking]
- Store/State: [✅ Compatible / ❌ Breaking]
- Tests: [✅ All pass / ❌ Failures]

### Regression Testing
- Existing Feature: [✅ Works / ❌ Issues]
- New Functionality: [✅ Works / ❌ Issues]

### Overall Assessment
**Production Ready:** [Yes/No]

**Full Report:** `.temp/analyze-$1-*/COMPLETION_REPORT.md`

### Recommended Action
[Specific recommendation: Deploy / Fix issues / Review findings]
```

## Success Criteria

- [x] All automated checks run
- [x] Backward compatibility verified
- [x] Regression testing complete
- [x] COMPLETION_REPORT.md created
- [x] Clear status provided (ready/blocked/issues)
- [x] Actionable recommendations given
- [x] Full documentation of validation process

## Notes

**Validation Philosophy:**
- Automated checks are required, not optional
- Backward compatibility is mandatory
- Regression testing ensures quality
- Clear reporting enables decision-making
- Production readiness must be earned, not assumed

**If Validation Fails:**
- Document specific failures clearly
- Provide steps to resolve issues
- Re-run validation after fixes
- Don't proceed to production until all checks pass

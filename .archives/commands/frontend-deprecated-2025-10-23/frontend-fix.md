---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(echo:*), Bash(cat:*), Bash(grep:*), Bash(npm:*)
argument-hint: [bug-name] [bug-description]
description: Fix frontend bugs with minimal changes and root cause analysis
---

# Fix Frontend Bug

**Bug Name:** `$1`
**Bug Description:** `$2`

---

## Phase 0: Initialization

### Create Todo List

Claude should initialize a TodoWrite list with the following tasks:

```json
{
  "todos": [
    {
      "content": "Run Phase 1: Pre-Analysis (spawn agents)",
      "status": "pending",
      "activeForm": "Running Phase 1 pre-analysis"
    },
    {
      "content": "Categorize bug type from analysis",
      "status": "pending",
      "activeForm": "Categorizing bug type"
    },
    {
      "content": "Run Phase 2: Planning (spawn plan-master)",
      "status": "pending",
      "activeForm": "Running Phase 2 planning"
    },
    {
      "content": "Present plan to user for approval",
      "status": "pending",
      "activeForm": "Presenting plan for approval"
    },
    {
      "content": "Run Phase 3: Implementation (spawn specialist)",
      "status": "pending",
      "activeForm": "Running Phase 3 implementation"
    },
    {
      "content": "Run Phase 4: Completion and validation",
      "status": "pending",
      "activeForm": "Running Phase 4 completion"
    },
    {
      "content": "Present final results to user",
      "status": "pending",
      "activeForm": "Presenting results"
    }
  ]
}
```

### Workspace Setup

Create workspace and gather project context.

Note: Claude will handle workspace creation and context gathering.

---

## Phase 1: Pre-Analysis

**Objective:** Map affected feature and identify root cause

### Step 1: Spawn Analysis Agents in Parallel

**Spawn @code-scout with mission:**
```
Task: Map feature affected by bug "$1" (described as: "$2") and trace root cause

Focus Areas:
1. Project Context:
   - Analyze package.json
   - Map directory structure
   - Identify tech stack

2. Feature Mapping:
   - Find ALL files related to the bug:
     * Components involved
     * Stores managing state
     * Composables providing logic
     * API routes handling data
     * Types definitions
     * Tests (check if any are failing)

3. Trace Data Flow:
   - Where does data originate?
   - How does it flow through components/stores/composables?
   - What triggers the bug?
   - Where does the bug manifest?

4. Find Similar Working Code:
   - Find similar features that work correctly
   - Compare implementations
   - Identify differences

5. Root Cause Clues:
   - Based on bug description "$2", identify likely problem areas
   - Map code paths related to symptoms
   - Document suspicious patterns

Note: Focus on DISCOVERY and MAPPING. Don't try to identify the exact bug - that's for plan-master and specialists.

Output: Create PRE_ANALYSIS.md in .temp/fix-$1/
```

**Spawn @documentation-researcher with mission:**
```
Task: Research potential solutions for "$2" bug symptoms

Focus:
1. If symptoms suggest framework bug, search for known issues
2. Find VueUse composables that might solve underlying problem
3. Document patterns for similar bug fixes

Output: Add findings to PRE_ANALYSIS.md
```

### Step 2: Main Agent Consolidates

Review PRE_ANALYSIS.md and categorize bug type based on symptoms from "$2":
- Hydration/SSR issues
- Type errors
- State management issues
- API/Appwrite errors
- Styling issues
- Component logic bugs
- Test failures

---

## Phase 2: Planning

**Objective:** Create root-cause fix plan with minimal changes

### Step 1: Spawn Planning Agent

**Spawn @plan-master with mission:**
```
Task: Create bug fix plan for "$1" (bug: "$2")

Context:
- Bug Name: $1
- Bug Description: $2
- Command Type: fix (bug fix with minimal changes)

Input: Read .temp/fix-$1/PRE_ANALYSIS.md

Planning Focus:
1. **Root Cause Identification:**
   - What is the underlying cause (not just symptoms)?
   - Where in the code is the problem?
   - Why does it happen?

2. **Minimal Change Fix:**
   - Change minimum code necessary
   - Fix root cause, not symptoms
   - Don't refactor unrelated code
   - Preserve existing functionality

3. **Regression Prevention:**
   - Write test that reproduces bug (fails before fix)
   - Test passes after fix
   - Verify no new bugs introduced

4. **Bug Category → Agent Assignment:**
   Hydration/SSR → @ssr-debugger
   Type errors → @typescript-validator
   State not updating → @nanostore-state-architect
   API/Auth → @appwrite-integration-specialist
   Styling → @tailwind-styling-expert
   Component logic → @vue-architect
   Test failures → @vue-testing-specialist
   Unknown → Assign appropriate specialist based on analysis

5. **Plan phases:**
   - Phase 1: Diagnosis (identify exact root cause)
   - Phase 2: Fix (implement minimal fix)
   - Phase 3: Test (add regression test)
   - Phase 4: Validation (ensure no side effects)

Output: Create MASTER_PLAN.md in .temp/fix-$1/
```

### Step 2: Main Agent Reviews

Read MASTER_PLAN.md and update TODO list

### Step 3: ⚠️ PAUSE FOR USER APPROVAL ⚠️

**Present:**
```
I've analyzed bug "$1" and identified the root cause. Here's what I found:

**Feature Map:**
[Summarize affected files and data flow]

**Root Cause:**
[Explain what's causing "$2"]

**Fix Strategy:**
[Minimal change approach from MASTER_PLAN.md]

**Full Plans:**
- Analysis: .temp/fix-$1/PRE_ANALYSIS.md
- Plan: .temp/fix-$1/MASTER_PLAN.md

Proceed with this fix?
```

**Do NOT proceed without approval. Accept feedback and revise if needed.**

---

## Phase 3: Implementation

**Objective:** Fix root cause with minimal changes

### Agent Reporting Requirements

**File:** `.temp/fix-$1/reports/[agent-name]-report.md` (<300 lines)

```markdown
# [Agent] Implementation Report

## Root Cause Identified
**Problem:** [What was broken]
**Cause:** [Why it was broken]
**Location:** [File and line numbers]

## Fix Implemented
**Approach:** [How it was fixed]
**Changes:**
- `path/file.ts:123` - [What changed]

**Lines Changed:** [number] (minimal change achieved: Yes/No)

## Regression Test Added
**Test File:** `path/test.test.ts`
**Test:** [Description of test that reproduces bug]
- Fails before fix: ✓
- Passes after fix: ✓

## Validation Performed
- [x] Bug is fixed
- [x] Existing functionality works (no regressions)
- [x] Related features tested
- [x] Type check passes
- [x] All tests pass

## Side Effects Checked
- [x] No new bugs introduced
- [x] No breaking changes
- [x] Performance not degraded
- [x] SSR still works (if applicable)

## Files Modified
- `path/file` - [1 line changed: exact fix]

## Files Created
- `path/test.test.ts` - [Regression test]

## Success Criteria Met
- [x] Bug "$2" fixed
- [x] Root cause addressed (not just symptoms)
- [x] Minimal code changes
- [x] Regression test added
```

### Execution

Follow MASTER_PLAN.md with emphasis on:
- Minimal changes (surgical fix)
- Root cause fix (not workaround)
- Regression test (prevent recurrence)
- No side effects

---

## Phase 4: Completion

### Validation

Suggest running these commands to validate the fix:
- `pnpm run typecheck`
- `pnpm run lint`
- `pnpm run build`

Test the specific bug scenario manually if possible.

### Completion Report

**File:** `.temp/fix-$1/COMPLETION_REPORT.md`

```markdown
# Bug Fix Report: $1

**Bug:** $2
**Status:** [Fixed/Partial/Blocked]

## Summary

**Root Cause:**
[What was broken and why]

**Fix:**
[How it was fixed]

**Impact:**
- Files changed: [number]
- Lines changed: [number]
- Regression test added: [Yes/No]

## Bug Details

**Symptoms:**
[How bug manifested]

**Affected Feature:**
[What feature was broken]

**User Impact:**
[How users were affected]

## Root Cause Analysis

**Problem Location:**
`path/file.ts:line`

**Why It Happened:**
[Technical explanation]

**How It Was Missed:**
[Why tests didn't catch it, if applicable]

## Fix Implementation

**Approach:**
[Minimal change strategy used]

**Changes Made:**
- `path/file.ts:123` - Changed [X] to [Y] because [reason]

**Alternative Approaches Considered:**
- [Approach A]: [Why not chosen]
- [Approach B]: [Why not chosen]

## Regression Prevention

**Test Added:**
`path/test.test.ts` - [Description]

**Test Coverage:**
- Reproduces original bug: ✓
- Passes after fix: ✓
- Covers edge cases: ✓

## Validation Results
- [ ] Type check: [Pass/Fail]
- [ ] Lint: [Pass/Fail]
- [ ] Tests: [Pass/Fail]
- [ ] Bug fixed: [Pass/Fail]
- [ ] No regressions: [Pass/Fail]

## Related Issues

**Similar Bugs:**
[Any similar bugs found and fixed]

**Potential Future Issues:**
[Areas that might have similar problems]

## Success Criteria
- [ ] Bug "$2" is fixed
- [ ] Root cause addressed
- [ ] Minimal changes made
- [ ] Regression test added
- [ ] No side effects

**Overall:** [Success/Partial with explanation]
```

### Present Results

```
Bug "$1" is fixed!

**Root Cause:** [Brief explanation]
**Fix:** [What was changed]
**Impact:** [Minimal/Medium/Large]

**Validation:**
- Bug fixed: ✓
- Tests pass: ✓
- No regressions: ✓

Full Report: .temp/fix-$1/COMPLETION_REPORT.md
```

---

## Execution Instructions

### Phase 0: Initialize workspace and locate bug

### Phase 1: Pre-Analysis
- Spawn @code-scout (map feature and trace root cause) + @documentation-researcher in parallel
- Review PRE_ANALYSIS.md
- Categorize bug type

### Phase 2: Planning
- Spawn @plan-master for root-cause fix plan
- Update TODO
- **⚠️ STOP FOR USER APPROVAL ⚠️**

### Phase 3: Implementation
- Spawn bug-specific specialist agent
- Implement minimal fix
- Add regression test
- Collect report

### Phase 4: Completion
- Run validation
- Verify bug fixed and no regressions
- Create COMPLETION_REPORT.md
- Present results

**Bug Decision Tree:**
```
Hydration/SSR symptoms? → @ssr-debugger
Type errors? → @typescript-validator
State not updating? → @nanostore-state-architect
API/Auth errors? → @appwrite-integration-specialist
Styling broken? → @tailwind-styling-expert
Component logic? → @vue-architect
Test failing? → @vue-testing-specialist
Unknown? → @code-scout analysis → [Appropriate specialist]
```

**Remember:**
- Minimal changes - fix ONLY the bug
- Root cause - not symptoms
- Regression test - prevent recurrence
- No side effects - verify related features work
- Document thoroughly - help prevent similar bugs

**Start Phase 0.**

---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(echo:*), Bash(cat:*), Bash(npm:*)
argument-hint: [target] [improvement-goals]
description: Improve code quality, types, cleanup, and logic reuse in frontend code
---

# Improve Frontend Code Quality

**Target:** `$1`
**Improvement Goals:** `$2`

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
      "content": "Consolidate quality analysis findings",
      "status": "pending",
      "activeForm": "Consolidating quality analysis"
    },
    {
      "content": "Run Phase 2: Planning (spawn plan-master)",
      "status": "pending",
      "activeForm": "Running Phase 2 planning"
    },
    {
      "content": "Present improvement plan to user for approval",
      "status": "pending",
      "activeForm": "Presenting plan for approval"
    },
    {
      "content": "Run Phase 3: Implementation (apply improvements)",
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

**Objective:** Identify quality issues and improvement opportunities

### Step 1: Spawn Analysis Agents in Parallel

**Spawn @code-scout with mission:**
```
Task: Analyze "$1" for quality improvement opportunities related to "$2"

Focus Areas:
1. Project Context:
   - Analyze package.json for available tools and scripts
   - Map directory structure
   - Identify tech stack and conventions

2. Code Quality Analysis:
   - Find duplicated code blocks (across files, within files)
   - Identify custom code that reimplements VueUse
   - Locate repeated logic that could be extracted to composables
   - Find prop drilling that could use stores
   - Identify components that could be abstracted

3. Pattern Analysis:
   - Document existing patterns for composables, stores, components
   - Identify inconsistencies with established patterns
   - Find areas not following project conventions

4. Improvement Opportunities Based on "$2":
   Types/TypeScript:
   - Find 'any' types
   - Locate weak typing
   - Identify missing Zod validation

   Reuse/DRY:
   - Duplicated logic
   - Copy-pasted code
   - Reimplemented VueUse functionality

   Cleanup/Refactor:
   - Dead code (unused imports, variables, functions)
   - Complex functions that could be simplified
   - Inconsistent naming

   State Management:
   - Prop drilling chains
   - Local state that should be global
   - Store opportunities

Output: Create PRE_ANALYSIS.md in .temp/improve-$1/
```

**Spawn @documentation-researcher with mission:**
```
Task: Research VueUse alternatives for code in "$1"

Focus:
1. Find VueUse composables that replace custom implementations
2. Document usage patterns for relevant composables
3. Identify modernization opportunities

Output: Add VueUse findings to PRE_ANALYSIS.md
```

### Step 2: Main Agent Consolidates

After both complete, consolidate findings and categorize improvements needed.

---

## Phase 2: Planning

**Objective:** Create surgical improvement plan

### Step 1: Spawn Planning Agent

**Spawn @plan-master with mission:**
```
Task: Create improvement plan for "$1" focusing on "$2"

Context:
- Target: $1
- Improvement Goals: $2
- Command Type: improve (code quality focus)

Input: Read .temp/improve-$1/PRE_ANALYSIS.md

Planning Focus:
1. **Surgical changes only:**
   - Fix only what's in scope of "$2"
   - Don't refactor unrelated code
   - Preserve existing functionality

2. **Test-driven approach:**
   - Write tests before refactoring (if missing)
   - Ensure no regressions

3. **Improvement categories:**
   Types: Eliminate 'any', add Zod, strengthen types
   Reuse: Extract to composables, replace with VueUse, centralize in stores
   Cleanup: Remove dead code, simplify logic, consistent naming
   State: Fix prop drilling, create stores where needed
   SSR: Add useMounted guards, fix hydration issues
   Styling: Responsive, dark mode, design system alignment
   Tests: Add missing tests, improve coverage

4. **Plan phases:**
   - Phase 1: Foundation (types, extractions)
   - Phase 2: Refactoring (apply improvements)
   - Phase 3: Testing (add/update tests)
   - Phase 4: Validation (ensure no regressions)

5. **Assign minimal-change-focused agents**

Output: Create MASTER_PLAN.md in .temp/improve-$1/
```

### Step 2: Main Agent Reviews

Read MASTER_PLAN.md and update TODO list

### Step 3: ⚠️ PAUSE FOR USER APPROVAL ⚠️

**Present:**
```
I've analyzed "$1" for improvements related to "$2". Here's what I found:

**Quality Issues Found:**
[Summarize from PRE_ANALYSIS.md]

**Improvement Strategy:**
[Summarize from MASTER_PLAN.md]

**Full Plans:**
- Analysis: .temp/improve-$1/PRE_ANALYSIS.md
- Plan: .temp/improve-$1/MASTER_PLAN.md

Proceed with this plan?
```

**Do NOT proceed without approval. Accept feedback and revise if needed.**

---

## Phase 3: Implementation

**Objective:** Execute improvements with minimal changes

### Agent Reporting Requirements

**File:** `.temp/improve-$1/reports/[agent-name]-report.md` (<300 lines)

```markdown
# [Agent] Implementation Report

## Improvements Completed
- [x] Eliminated [number] 'any' types
- [x] Extracted [logic] to composable
- [x] Replaced custom code with VueUse

## Files Modified
- `path/file.ts` - [What improved and why]

## Code Metrics
Before:
- 'any' types: [count]
- Duplicated blocks: [count]
- Complex functions (cyclomatic): [count]

After:
- 'any' types: [count]
- Duplicated blocks: [count]
- Complex functions: [count]

## Reusability Achieved
- Extracted [composable] - now reusable
- Replaced with [VueUse composable]
- Centralized in [store]

## Validation
- [x] All tests pass
- [x] Type check passes
- [x] No regressions
- [x] Functionality preserved

## Success Criteria Met
- [x] [Improvement goal from plan]
```

### Execution

Follow MASTER_PLAN.md phases with emphasis on:
- Minimal changes
- Test before refactor
- No regressions
- Preserve functionality

---

## Phase 4: Completion

### Validation

Suggest running these commands to validate:
- `pnpm run typecheck`
- `pnpm run lint`
- `pnpm run build`

### Completion Report

**File:** `.temp/improve-$1/COMPLETION_REPORT.md`

```markdown
# Completion Report: Improving $1

**Target:** $1
**Goals:** $2
**Status:** [Success/Partial/Blocked]

## Summary

**Improvements Made:**
[Brief description]

**Metrics:**
Before → After:
- Type safety: [metric]
- Code duplication: [metric]
- Complexity: [metric]
- Test coverage: [%] → [%]

## Changes

### Files Modified
- `path` - [Improvements]

### Extractions Created
- `src/composables/useX.ts` - Extracted logic
- `src/stores/xStore.ts` - Centralized state

### VueUse Integration
- Replaced [custom] with `useX()`

## Validation Results
- [ ] Type check: [Pass/Fail]
- [ ] Lint: [Pass/Fail]
- [ ] Tests: [Pass/Fail]
- [ ] No regressions: [Pass/Fail]

## Quality Improvement
[Quantifiable improvement metrics]

## Success Criteria
- [ ] [Goal 1 achieved]
- [ ] [Goal 2 achieved]

**Overall:** [Assessment]
```

### Present Results

```
Improvements to "$1" complete!

**Summary:** [What was improved]
**Metrics:** [Before/after comparison]
**Status:** [Success/Partial]

Full Report: .temp/improve-$1/COMPLETION_REPORT.md
```

---

## Execution Instructions

### Phase 0: Initialize workspace and gather context

### Phase 1: Pre-Analysis
- Spawn @code-scout (quality analysis) + @documentation-researcher (VueUse) in parallel
- Review PRE_ANALYSIS.md
- Categorize improvements

### Phase 2: Planning
- Spawn @plan-master for surgical improvement plan
- Update TODO
- **⚠️ STOP FOR USER APPROVAL ⚠️**

### Phase 3: Implementation
- Execute with minimal-change focus
- Test-driven refactoring
- Collect reports

### Phase 4: Completion
- Run validation
- Create COMPLETION_REPORT.md with metrics
- Present results

**Remember:**
- Surgical changes only
- Test before refactoring
- No regressions
- Preserve functionality
- Quantify improvements

**Start Phase 0.**

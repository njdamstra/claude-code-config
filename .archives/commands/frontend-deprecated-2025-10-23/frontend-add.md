---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(echo:*), Bash(cat:*), Bash(grep:*)
argument-hint: [feature-name] [what-to-add]
description: Add functionality to existing frontend feature with code reuse focus
---

# Add to Existing Frontend Feature

**Feature Name:** `$1`
**What to Add:** `$2`

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
      "content": "Consolidate pre-analysis findings",
      "status": "pending",
      "activeForm": "Consolidating pre-analysis findings"
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
      "content": "Run Phase 3: Implementation (spawn specialist agents)",
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

Create the workspace and gather quick project context.

Note: Claude will handle workspace creation and context gathering.

## Phase 1: Pre-Analysis

**Objective:** Map existing feature and identify extension opportunities

### Step 1: Spawn Analysis Agents in Parallel

**Spawn @code-scout with mission:**
```
Task: Analyze existing feature "$1" and find code for adding "$2"

DUAL MISSION:

Mission 1 - Map Existing Feature:
1. Find ALL files related to feature "$1":
   - Components that implement it
   - Stores that manage its state
   - Composables that provide its logic
   - API routes that support it
   - Types that define it
   - Tests that cover it

2. Trace data flow:
   - How data flows through the feature
   - Which stores are involved
   - Which composables are used
   - Which components consume the data

3. Document patterns:
   - How this feature is architected
   - Naming conventions used
   - File organization
   - Integration points

Mission 2 - Find Reusable Code for Addition:
1. Find existing code that provides "$2" functionality:
   - Exact matches (already does exactly this)
   - Near matches (does 70-90% of this)
   - Base components to extend
   - Similar implementations to learn from

2. Identify extension points:
   - Where in existing feature to add "$2"
   - Components that need new props/slots
   - Stores that need new actions
   - Composables that need extension

3. Check for VueUse alternatives:
   - Custom code that VueUse provides
   - Patterns VueUse simplifies

Output: Create PRE_ANALYSIS.md in .temp/add-$1/ with:
- Section 1: Existing Feature Map
- Section 2: Reusability Analysis for Addition
- Section 3: Extension Strategy Recommendations
```

**Spawn @documentation-researcher with mission:**
```
Task: Research VueUse solutions for adding "$2"

Focus Areas:
1. Search VueUse for composables that provide "$2" functionality
2. Find examples of similar additions in documentation
3. Identify patterns that simplify implementation
4. Document usage examples

Output: Add VueUse findings to PRE_ANALYSIS.md
```

### Step 2: Main Agent Consolidates Findings

After both agents complete:
1. Read PRE_ANALYSIS.md
2. Understand existing feature structure
3. Identify best extension approach
4. Note integration points

## Phase 2: Planning

**Objective:** Create minimal-change plan for adding functionality

### Step 1: Spawn Planning Agent

**Spawn @plan-master with mission:**
```
Task: Create plan for adding "$2" to existing feature "$1"

Context:
- Feature Name: $1
- What to Add: $2
- Command Type: add (extending existing feature)

Input Files:
- Read .temp/add-$1/PRE_ANALYSIS.md for feature map and extension opportunities

Planning Focus:
1. **Extension-first approach:**
   - Prefer modifying existing files over creating new ones
   - Extend existing components with props/slots
   - Add actions to existing stores
   - Enhance existing composables

2. **Minimal changes:**
   - Change least amount of code necessary
   - Preserve backward compatibility
   - Don't refactor unrelated code

3. **Integration strategy:**
   - How to wire new functionality into existing feature
   - Which files to modify
   - What new files are absolutely necessary

4. **Follow architecture hierarchy:**
   - Check VueUse first (from pre-analysis)
   - Extend existing composables or create new
   - Extend existing stores or create new
   - Extend existing components or create new

5. **Plan phases:**
   - Phase 1: Foundation (extend/create stores and composables)
   - Phase 2: Implementation (extend/create components)
   - Phase 3: Integration (wire into existing feature)
   - Phase 4: Quality (tests, validation, regression checks)

6. **Assign agents:**
   - Determine which specialists are needed
   - Define what they should extend/modify
   - Specify deliverables

Output: Create MASTER_PLAN.md in .temp/add-$1/
```

### Step 2: Main Agent Reviews Plan

After @plan-master completes:
1. Read MASTER_PLAN.md
2. Update TODO list with all tasks
3. Verify plan minimizes changes

### Step 3: ⚠️ PAUSE FOR USER APPROVAL ⚠️

**Claude, you MUST stop here and present the plan to the user:**

```
I've analyzed existing feature "$1" and created a plan for adding "$2". Here's what I found:

**Existing Feature Analysis:**
[Summarize the feature map - components, stores, composables, structure]

**Addition Strategy:**
[Summarize the approach - what to extend vs create new, integration points]

**Key Decisions:**
- [Extension decision 1]
- [Extension decision 2]

**Full Plans Available:**
- Analysis: .temp/add-$1/PRE_ANALYSIS.md
- Plan: .temp/add-$1/MASTER_PLAN.md

Would you like me to proceed with this plan, or would you like to make any adjustments?
```

**Do NOT proceed to Phase 3 without user approval.**

If user requests changes:
- Update MASTER_PLAN.md based on feedback
- Update TODO list accordingly
- Present revised plan
- Repeat until approval

## Phase 3: Implementation

**Objective:** Execute plan with minimal changes to existing code

### Execution Strategy

Follow MASTER_PLAN.md with emphasis on:
1. **Extend before create** - Modify existing files when possible
2. **Backward compatibility** - Don't break existing functionality
3. **Pattern matching** - Follow existing conventions
4. **Integration focus** - Ensure new code works with existing

### Agent Reporting Requirements

**Each specialist agent MUST create an implementation report (<300 lines):**

**File:** `.temp/add-$1/reports/[agent-name]-report.md`

**Structure:**
```markdown
# [Agent Name] Implementation Report

## Tasks Completed
- [x] Extended existing [file] with [functionality]
- [x] Created new [file] (only if absolutely necessary)

## Files Created
- `path/to/new-file.ts` - [Why new file was necessary]

## Files Modified
- `path/to/existing-file.vue` - [What was added/changed]
  - Added props: [list]
  - Added slots: [list]
  - Added methods: [list]
- `path/to/existing-store.ts` - [What was extended]
  - Added actions: [list]
  - Added getters: [list]

## Extension Strategy Used
- **Approach:** [Extend existing vs create new]
- **Rationale:** [Why this approach]
- **Integration Points:** [Where new code connects to existing]

## Backward Compatibility
- [x] Existing functionality preserved
- [x] No breaking changes to component API
- [x] Existing tests still pass
- [x] Default behavior unchanged

## Decisions Made
- **Decision 1:** [What and why]
- **Decision 2:** [What and why]

## Reusability Leveraged
- Used [existing code] from [file]
- Extended [pattern] from [file]
- Followed [convention] established in [file]

## Validation Performed
- [x] New functionality works
- [x] Existing functionality works (regression test)
- [x] Type check passed
- [x] SSR compatibility verified

## Notes for Other Agents
- Extended interface `InterfaceName` with new properties
- New store action `actionName()` available
- Integration requires [specific step]

## Success Criteria Met
- [x] "$2" functionality added
- [x] Minimal code changes
- [x] Backward compatible
```

### Main Agent Responsibilities

After each agent completes:
1. Read implementation report
2. Verify minimal changes approach
3. Check backward compatibility
4. Update TODO list
5. Proceed to next task

### Phase Execution

Execute phases as defined in MASTER_PLAN.md:

**Phase 1: Foundation**
- Extend existing stores/composables
- Create new only if VueUse doesn't provide and existing can't be extended
- Collect reports

**Phase 2: Implementation**
- Extend existing components
- Create new only if can't compose from existing
- Collect reports

**Phase 3: Integration**
- Wire new functionality into existing feature
- Update types and validation
- Ensure SSR compatibility
- Collect reports

**Phase 4: Quality Assurance**
- Add tests for new functionality
- Run regression tests for existing functionality
- Validate backward compatibility
- Run automated validation

## Phase 4: Completion

**Objective:** Validate addition and ensure no regressions

### Step 1: Automated Validation

Suggest running these commands to validate:
- `pnpm run typecheck`
- `pnpm run lint`
- `pnpm run build`

### Step 2: Create Completion Report

**Main Agent creates:** `.temp/add-$1/COMPLETION_REPORT.md`

**Structure:**
```markdown
# Completion Report: Adding to $1

**Feature:** $1
**Addition:** $2
**Date:** [Current date]
**Status:** [Success/Partial/Blocked]

## Summary

**What Was Added:**
[Brief description of functionality added]

**Approach:**
[Extension vs creation strategy used]

**Key Decisions:**
- [Major decision 1]
- [Major decision 2]


## Changes Overview

### Files Modified (Extensions)
- `path/to/file` - [What was extended]
  - Added: [specifics]
  - Changed: [specifics]
  - Reason: [why this approach]

### Files Created (New)
- `path/to/file` - [Why new file was necessary]
  - Purpose: [what it does]
  - Integration: [how it connects]

### Lines of Code Changed
- Modified: [number] lines across [number] files
- Created: [number] lines across [number] new files
- **Total Impact:** [Small/Medium/Large]


## Extension Strategy

**Extension Opportunities Used:**
- Extended [existing component] with [new props/slots]
- Added [actions] to [existing store]
- Enhanced [composable] with [new functionality]

**New Code Created:**
- [What new code was necessary and why]

**VueUse Composables Used:**
- `useComposable()` - [How it was used]


## Backward Compatibility

**Existing Functionality:**
- ✅ All existing features still work
- ✅ No breaking changes to component APIs
- ✅ Default behavior preserved
- ✅ Existing tests pass

**Migration Required:**
- [ ] None (backward compatible)
- [ ] Optional (enhancement available, not required)
- [ ] Required (breaking changes made)

**If Migration Required:**
- [Steps needed]
- [Impact on existing code]


## Integration Points

**How Addition Integrates:**
1. [Integration point 1]
2. [Integration point 2]

**Data Flow:**
```
[Existing Flow] → [New Addition] → [Existing Flow Continues]
```

**User Experience:**
- [How users interact with new functionality]
- [How it enhances existing feature]

## Validation Results

### Automated Checks
- [ ] `npm run typecheck` - [Pass/Fail/Not Available]
- [ ] `npm run lint` - [Pass/Fail/Not Available]
- [ ] `npm run test` - [Pass/Fail/Not Available]
- [ ] `npm run build` - [Pass/Fail/Not Available]

### Regression Testing
- [ ] Existing feature workflows tested
- [ ] No console errors introduced
- [ ] No visual regressions
- [ ] Performance not degraded

### New Functionality Testing
- [ ] New functionality works as described
- [ ] Edge cases handled
- [ ] Error states tested
- [ ] SSR compatibility verified

## Success Criteria

**From Master Plan:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]

**Additional:**
- [ ] Minimal code changes achieved
- [ ] Backward compatibility maintained
- [ ] Pattern consistency preserved

**Overall Assessment:** [Pass/Partial/Fail with explanation]


## Known Issues

**Issues Found:**
- [Issue 1 and status]

**Technical Debt:**
- [Any shortcuts taken]

**Follow-Up Needed:**
- [Any tasks for later]


## Documentation

**Usage of New Functionality:**
```typescript
// Example code showing how to use the addition
```

**API Changes:**
- [New props/methods/events added]
- [Their purpose and usage]

**Tests:**
- New tests: [location]
- Regression tests: [status]


## Metrics

**Code Impact:**
- Files modified: [number]
- Files created: [number]
- Lines added: [number]
- Lines removed: [number]
- Net change: [number]

**Complexity:**
- Estimated effort: [Low/Medium/High]
- Actual effort: [agent count, time]


## Lessons Learned

**What Worked Well:**
- [Success with extension approach]
- [Success with minimal changes]

**What Could Be Improved:**
- [Improvement opportunity]


## Next Steps

**Immediate:**
- [ ] [Any immediate next steps]

**Future Enhancements:**
- [ ] [Related features that could be added]

## Appendices

**Full Reports:**
- Pre-Analysis: `.temp/add-$1/PRE_ANALYSIS.md`
- Master Plan: `.temp/add-$1/MASTER_PLAN.md`
- Agent Reports: `.temp/add-$1/reports/`

**Command Used:**
\`\`\`bash
/frontend-add $1 "$2"
\`\`\`
```

### Step 3: Present Results

**Main Agent presents to user:**
```
Addition of "$2" to feature "$1" is complete!

**Summary:**
[Brief summary of what was added]

**Approach:**
[Extension vs creation summary]

**Impact:**
- Modified: [number] files
- Created: [number] files
- Backward compatible: [Yes/No]

**Status:**
[Success/Partial with details]

**Full Report:**
.temp/add-$1/COMPLETION_REPORT.md

Would you like me to make any adjustments?
```


## Execution Instructions

**Claude, please execute this command following these phases:**

### Phase 0: Initialization
1. Create workspace directory
2. Find existing feature files
3. Initialize TODO list

### Phase 1: Pre-Analysis
1. Spawn @code-scout (dual mission: map feature + find reusable code)
2. Spawn @documentation-researcher (VueUse for addition)
3. Both run in parallel
4. Review PRE_ANALYSIS.md
5. Summarize existing feature and extension opportunities

### Phase 2: Planning
1. Spawn @plan-master
2. Wait for MASTER_PLAN.md
3. Update TODO list from plan
4. **⚠️ STOP AND PRESENT PLAN TO USER ⚠️**
5. **WAIT FOR USER APPROVAL BEFORE PROCEEDING**
6. If changes requested, update plan and repeat

### Phase 3: Implementation
1. Execute MASTER_PLAN.md with extension-first approach
2. Spawn specialist agents as assigned
3. Collect implementation reports (<300 lines each)
4. Verify minimal changes and backward compatibility
5. Update TODO list as tasks complete

### Phase 4: Completion
1. Run automated validation
2. Run regression tests
3. Create COMPLETION_REPORT.md
4. Present results to user

**Remember:**
- **Extension-first:** Modify existing before creating new
- **Minimal changes:** Change only what's necessary
- **Backward compatible:** Don't break existing functionality
- **Pattern matching:** Follow existing conventions
- **Integration focus:** Wire new code into existing smoothly

**Start with Phase 0: Initialize workspace and find existing feature.**

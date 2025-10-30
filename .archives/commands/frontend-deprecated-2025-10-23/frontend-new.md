---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(echo:*), Bash(cat:*)
argument-hint: [feature-name] [description]
description: Create new frontend feature with intelligent agent orchestration
---

# Create New Frontend Feature

**Feature Name:** `$1`
**Feature Description:** `$2`

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
      "content": "Consolidate analysis and identify reusability",
      "status": "pending",
      "activeForm": "Consolidating analysis findings"
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
      "content": "Run Phase 3: Implementation (spawn specialists)",
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

Create the feature workspace and gather quick project context.

Note: Claude will handle workspace creation and context gathering.

---

## Phase 1: Pre-Analysis

**Objective:** Gather comprehensive project context and identify reusability opportunities

### Step 1: Spawn Analysis Agents in Parallel

**Spawn @code-scout with mission:**
```
Task: Analyze codebase for creating new feature "$2"

Focus Areas:
1. Project Context:
   - Analyze package.json for tech stack, scripts, dependencies
   - Map directory structure (src/components, src/stores, src/composables, etc.)
   - Identify framework versions and build tools

2. Find Similar Features:
   - Search for features similar to "$2"
   - Identify how they were implemented
   - Document patterns and conventions used

3. Identify Reusable Code:
   - Find base components that can be composed
   - Locate composables that provide related functionality
   - Identify stores that manage similar state
   - Find utilities that could be leveraged

4. Detect Duplications:
   - Look for any existing implementations of "$2" functionality
   - Identify if any parts are already implemented elsewhere

5. Map Patterns:
   - Document component architecture patterns
   - Document state management patterns
   - Document naming conventions
   - Document file organization

Output: Create PRE_ANALYSIS.md in .temp/$1/ with all findings
```

**Spawn @documentation-researcher with mission:**
```
Task: Research VueUse solutions for new feature "$2"

Focus Areas:
1. Search VueUse documentation for composables that provide functionality needed for "$2"
2. Identify VueUse patterns that simplify implementation
3. Document usage examples for relevant composables
4. Note any VueUse alternatives to custom implementations

Output: Document findings in VueUse section of PRE_ANALYSIS.md
```

### Step 2: Main Agent Consolidates Findings

After both agents complete:
1. Read PRE_ANALYSIS.md
2. Consolidate findings from both agents
3. Identify key reusability opportunities
4. Note any gaps that need custom implementation

---

## Phase 2: Planning

**Objective:** Create comprehensive implementation plan with agent orchestration

### Step 1: Spawn Planning Agent

**Spawn @plan-master with mission:**
```
Task: Create implementation plan for new feature "$2"

Context:
- Feature Name: $1
- Feature Description: $2
- Command Type: new (creating from scratch)

Input Files:
- Read .temp/$1/PRE_ANALYSIS.md for all findings

Planning Focus:
1. Follow architecture hierarchy:
   - Level 1: VueUse composables (use from pre-analysis findings)
   - Level 2: Custom composables (if VueUse doesn't provide)
   - Level 3: Nanostores (for cross-component state)
   - Level 4: Vue components (UI with slots for flexibility)

2. Leverage reusability:
   - Use base components found in pre-analysis
   - Extend existing composables
   - Follow established patterns

3. Plan phases:
   - Phase 1: Foundation (stores, composables)
   - Phase 2: Implementation (components, pages, API routes)
   - Phase 3: Enhancement (styling, types, SSR checks)
   - Phase 4: Quality (testing, validation)

4. Assign agents:
   - Determine which specialist agents are needed
   - Identify execution order and parallel opportunities
   - Define deliverables for each agent

Output: Create MASTER_PLAN.md in .temp/$1/
```

### Step 2: Main Agent Reviews Plan

After @plan-master completes:
1. Read MASTER_PLAN.md
2. Update TODO list with all tasks from the plan
3. Verify plan makes sense given pre-analysis findings

### Step 3: ⚠️ PAUSE FOR USER APPROVAL ⚠️

**Claude, you MUST stop here and present the plan to the user:**

```
I've completed the analysis and planning phases for creating "$2". Here's what I found:

**Pre-Analysis Summary:**
[Summarize key findings from PRE_ANALYSIS.md - reusable code, patterns, VueUse opportunities]

**Master Plan Summary:**
[Summarize the approach from MASTER_PLAN.md - phases, agents, strategy]

**Full Plans Available:**
- Analysis: .temp/$1/PRE_ANALYSIS.md
- Plan: .temp/$1/MASTER_PLAN.md

Would you like me to proceed with this plan, or would you like to make any adjustments?
```

**Do NOT proceed to Phase 3 without user approval.**

If user requests changes:
- Update MASTER_PLAN.md based on feedback
- Update TODO list accordingly
- Present revised plan
- Repeat until approval

---

## Phase 3: Implementation

**Objective:** Execute the master plan with specialist agents

### Execution Strategy

Follow the MASTER_PLAN.md exactly:
1. Execute phases in order as defined
2. Spawn specialist agents as assigned
3. Run parallel tasks where plan identifies opportunities
4. Collect implementation reports from each agent

### Agent Reporting Requirements

**Each specialist agent MUST create an implementation report (<300 lines):**

**File:** `.temp/$1/reports/[agent-name]-report.md`

**Structure:**
```markdown
# [Agent Name] Implementation Report

## Tasks Completed
- [x] Task 1 from master plan
- [x] Task 2 from master plan

## Files Created/Modified
- `path/to/file.ts` - [Brief description of changes]
- `path/to/file.vue` - [Brief description of changes]

## Decisions Made
- **Decision 1:** [What was decided and why]
- **Decision 2:** [What was decided and why]

## Reusability Leveraged
- Used [existing component/composable] as recommended
- Extended [existing pattern] from [file]

## Validation Performed
- [x] Type check passed
- [x] Manual testing performed
- [x] SSR compatibility verified

## Notes for Other Agents
- Created new type `TypeName` in `src/types/` - available for use
- Added new store action `actionName` - see documentation
- Identified issue that may need attention: [description]

## Success Criteria Met
- [x] Criterion 1 from master plan
- [x] Criterion 2 from master plan
```

### Main Agent Responsibilities

After each agent completes:
1. Read their implementation report
2. Verify success criteria met
3. Note any issues or dependencies for next agents
4. Update TODO list
5. Proceed to next task in plan

### Phase Execution

Execute phases as defined in MASTER_PLAN.md:

**Phase 1: Foundation**
- Spawn assigned agents
- Collect reports
- Validate phase completion criteria

**Phase 2: Implementation**
- Spawn assigned agents (may depend on Phase 1)
- Collect reports
- Validate phase completion criteria

**Phase 3: Enhancement**
- Spawn assigned agents (styling, types, SSR)
- Collect reports
- Validate phase completion criteria

**Phase 4: Quality Assurance**
- Spawn @vue-testing-specialist for tests
- Spawn @typescript-validator if needed
- Run automated validation
- Perform manual verification

---

## Phase 4: Completion

**Objective:** Validate implementation and create comprehensive completion report

### Step 1: Automated Validation

Suggest running these commands to validate:
- `pnpm run typecheck`
- `pnpm run lint`
- `pnpm run build`

### Step 2: Create Completion Report

**Main Agent creates:** `.temp/$1/COMPLETION_REPORT.md`

**Structure:**
```markdown
# Completion Report: $1

**Feature:** $2
**Date:** [Current date]
**Status:** [Success/Partial/Blocked]

---

## Summary

**What Was Built:**
[Brief description of what was implemented]

**Approach:**
[Summary of approach taken based on master plan]

**Key Decisions:**
- [Major decision 1]
- [Major decision 2]

---

## Implementation Overview

### Files Created
- `path/to/file` - [Purpose]
- `path/to/file` - [Purpose]

### Files Modified
- `path/to/file` - [What changed]
- `path/to/file` - [What changed]

### Agents Utilized
| Agent | Tasks | Report |
|-------|-------|--------|
| @agent-name | [Summary] | `.temp/$1/reports/[agent]-report.md` |

---

## Reusability Achieved

**Leveraged Existing Code:**
- [What existing code was reused]
- [What existing code was extended]

**VueUse Composables Used:**
- `useComposable()` - [How it was used]

**Patterns Followed:**
- [Pattern 1 followed from codebase]
- [Pattern 2 followed from codebase]

---

## Architecture Compliance

**Hierarchy Followed:**
- ✅ VueUse composables checked first
- ✅ Custom composables created in src/composables/
- ✅ Stores created in src/stores/
- ✅ Components built with slots for flexibility

**TypeScript:**
- ✅ Strong typing throughout
- ✅ No `any` types
- ✅ Zod validation at API boundaries

**SSR:**
- ✅ SSR-safe patterns (useMounted for client-only)
- ✅ Hydration tested

---

## Validation Results

### Automated Checks
- [ ] `npm run typecheck` - [Pass/Fail/Not Available]
- [ ] `npm run lint` - [Pass/Fail/Not Available]
- [ ] `npm run test` - [Pass/Fail/Not Available]
- [ ] `npm run build` - [Pass/Fail/Not Available]

### Manual Verification
- [ ] Feature works as described
- [ ] Responsive design verified
- [ ] Dark mode verified (if applicable)
- [ ] Accessibility checked
- [ ] SSR hydration successful

### Test Coverage
- Unit tests: [Coverage %]
- Component tests: [Coverage %]
- Integration tests: [Coverage %]

---

## Success Criteria

**From Master Plan:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**Overall Assessment:** [Pass/Partial/Fail with explanation]

---

## Known Issues

**Issues Found:**
- [Issue 1 and status]
- [Issue 2 and status]

**Technical Debt:**
- [Any shortcuts taken that should be addressed]

**Follow-Up Needed:**
- [Any tasks that need follow-up]

---

## Documentation

**Code Documentation:**
- [Where to find implementation details]
- [Any special usage notes]

**Tests:**
- [Where tests are located]
- [How to run tests]

**Usage Examples:**
- [How to use the new feature]
- [Code examples if applicable]

---

## Lessons Learned

**What Worked Well:**
- [Success 1]
- [Success 2]

**What Could Be Improved:**
- [Improvement opportunity 1]
- [Improvement opportunity 2]

**Reusability Opportunities Created:**
- [New reusable code that was created for future use]

---

## Next Steps

**Immediate:**
- [ ] [Any immediate next steps]

**Future Enhancements:**
- [ ] [Potential future improvements]

---

## Appendices

**Full Reports:**
- Pre-Analysis: `.temp/$1/PRE_ANALYSIS.md`
- Master Plan: `.temp/$1/MASTER_PLAN.md`
- Agent Reports: `.temp/$1/reports/`

**Command Used:**
\`\`\`bash
/frontend-new $1 "$2"
\`\`\`
```

### Step 3: Present Results

**Main Agent presents to user:**
```
Feature "$2" implementation is complete!

**Summary:**
[Brief summary of what was built]

**Status:**
[Success/Partial with details]

**Validation:**
[Summary of validation results]

**Full Report:**
.temp/$1/COMPLETION_REPORT.md

Would you like me to make any adjustments or address any issues?
```

---

## Execution Instructions

**Claude, please execute this command following these phases:**

### Phase 0: Initialization
1. Create workspace directory
2. Gather quick project context
3. Initialize TODO list

### Phase 1: Pre-Analysis
1. Spawn @code-scout and @documentation-researcher in parallel
2. Wait for both to complete
3. Review PRE_ANALYSIS.md
4. Summarize findings

### Phase 2: Planning
1. Spawn @plan-master
2. Wait for MASTER_PLAN.md
3. Update TODO list from plan
4. **⚠️ STOP AND PRESENT PLAN TO USER ⚠️**
5. **WAIT FOR USER APPROVAL BEFORE PROCEEDING**
6. If changes requested, update plan and repeat

### Phase 3: Implementation
1. Execute MASTER_PLAN.md phases in order
2. Spawn specialist agents as assigned
3. Collect implementation reports (<300 lines each)
4. Validate each phase completion
5. Update TODO list as tasks complete

### Phase 4: Completion
1. Run automated validation (typecheck, lint, test, build)
2. Create COMPLETION_REPORT.md
3. Present results to user

**Remember:**
- Follow the architecture hierarchy: VueUse → Composables → Stores → Components
- Leverage reusability findings from pre-analysis
- Get user approval before implementation (Phase 2)
- Collect reports from all specialist agents
- Validate thoroughly before completion

**Start with Phase 0: Initialize the workspace and begin analysis.**

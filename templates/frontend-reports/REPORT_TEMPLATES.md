# Frontend Command Report Templates

This document defines the standardized report formats used by frontend commands and agents.

---

## PRE_ANALYSIS.md Template

Used by: `@code-scout` and `@documentation-researcher`
Location: `.temp/[task-name]/PRE_ANALYSIS.md`

```markdown
# Pre-Analysis Report

**Date:** [Current date]
**Task:** [Task description]
**Workspace:** [Workspace path]
**Command:** [frontend-new/add/improve/fix]

---

## 1. Project Context

### Tech Stack
- Framework: [Astro version]
- UI Library: [Vue version]
- Language: [TypeScript version]
- Styling: [Tailwind CSS version]
- Backend: [Appwrite version]
- Build Tool: [Vite/other]
- Package Manager: [npm/pnpm/yarn]

### Available Scripts
\`\`\`json
{
  "dev": "...",
  "build": "...",
  "test": "...",
  "typecheck": "...",
  "lint": "..."
}
\`\`\`

### Directory Structure
\`\`\`
src/
├── components/
│   └── vue/
├── pages/
├── stores/
├── composables/
└── utils/
\`\`\`

---

## 2. Relevant Files

### Primary Files
- \`path/to/file.vue\` - [Relevance description]

### Related Files
- \`path/to/file.ts\` - [How it's related]

### Pattern Files
- \`path/to/similar.vue\` - [Why it's similar]

---

## 3. Reusable Code Analysis

### Exact Matches
- **[Component/Function]** (\`path/to/file\`)
  - What: [Description]
  - Usage: [How to use]
  - Match: [Why it matches]

### Near Matches (70-90% match)
- **[Component/Function]** (\`path/to/file\`)
  - What: [Description]
  - Gap: [What's missing]
  - Extension: [How to extend]

### Base Components
- **[Base Component]** (\`path/to/file\`)
  - Abstraction: [What it provides]
  - Composition: [How to use]
  - Interface: [Props/slots]

### VueUse Opportunities
- **Custom:** [What was built]
- **VueUse:** \`useComposable()\`
- **Recommendation:** [Replace or keep]

---

## 4. Duplication Analysis

### Code Blocks
- **Pattern:** [Description]
- **Locations:** [Files and lines]
- **Target:** [Where to extract]

### Logic Patterns
- **Logic:** [What's repeated]
- **Implementations:** [Different approaches]
- **Opportunity:** [How to unify]

---

## 5. Pattern Documentation

### Architectural Patterns
- **Components:** [Pattern]
- **State:** [Pattern]
- **Data Fetching:** [Pattern]
- **Types:** [Pattern]

### Naming Conventions
- **Components:** [Pattern]
- **Composables:** [Pattern]
- **Stores:** [Pattern]
- **Types:** [Pattern]

### Code Organization
- **Structure:** [How organized]
- **Imports:** [Patterns]
- **Exports:** [Patterns]

---

## 6. Feature Mapping (for add/fix/improve)

### Component Hierarchy
\`\`\`
FeatureRoot
├── ComponentA
│   ├── Sub B
│   └── Sub C
└── ComponentD
\`\`\`

### Data Flow
\`\`\`
API (/api/endpoint)
  ↓
Store (featureStore)
  ↓
Composable (useFeature)
  ↓
Component (Feature.vue)
\`\`\`

### Dependencies
- **Stores:** [Which stores]
- **Composables:** [Which composables]
- **APIs:** [Which routes]
- **External:** [Third-party libs]

---

## 7. Recommendations

### Reuse Opportunities
1. [Specific recommendation]

### Extension Points
1. [Where to extend]

### Pattern Alignment
1. [How to align]

### VueUse Integration
1. [Where to use VueUse]

---

## 8. Context for Agents

### For @vue-architect
- Base components: [List]
- Patterns: [Patterns]
- Conventions: [Conventions]

### For @nanostore-state-architect
- Stores to extend: [List]
- Patterns: [Patterns]
- Conventions: [Conventions]

### For @typescript-validator
- Type organization: [Pattern]
- Validation: [Patterns]
- Shared types: [Location]

---

## Summary

**Key Findings:**
- [Finding 1]
- [Finding 2]

**Primary Recommendation:**
[One sentence recommendation]
```

---

## MASTER_PLAN.md Template

Used by: `@plan-master`
Location: `.temp/[task-name]/MASTER_PLAN.md`

```markdown
# Master Plan

**Task:** [Task description]
**Type:** [new/add/improve/fix]
**Date:** [Current date]
**Workspace:** [Workspace path]

---

## Executive Summary

**Goal:** [One sentence goal]

**Strategy:** [One paragraph strategy based on pre-analysis]

**Key Decisions:**
- [Decision 1 with rationale]
- [Decision 2 with rationale]

**Estimated Complexity:** [Low/Medium/High]

---

## Pre-Analysis Insights

**Reusable Code:**
- [Finding 1]
- [Finding 2]

**Patterns to Follow:**
- [Pattern 1]
- [Pattern 2]

**VueUse Opportunities:**
- [VueUse composable to use]

**Architecture Alignment:**
- [How task aligns with hierarchy]

---

## Phase Breakdown

### Phase 1: [Phase Name]
**Goal:** [What this phase establishes]

**Tasks:**
1. **[Task Name]**
   - **Assigned to:** @[agent-name]
   - **Objective:** [What to accomplish]
   - **Context:** [Relevant pre-analysis findings]
   - **Deliverable:** [What to produce]
   - **Success Criteria:** [How to validate]
   - **Constraints:** [Limitations]
   - **Dependencies:** [What this depends on]

2. **[Task Name]**
   - [Same structure]

**Execution:** [Sequential/Parallel with rationale]

**Validation:** [How to verify phase complete]

---

### Phase 2: [Phase Name]
[Same structure as Phase 1]

---

### Phase 3: [Phase Name]
[Same structure as Phase 1]

---

### Phase 4: Quality Assurance
**Goal:** Validate and ensure production readiness

**Tasks:**
1. **Testing**
   - **Assigned to:** @vue-testing-specialist
   - **Objective:** [Testing objectives]
   - **Deliverable:** Test suite
   - **Success:** All tests pass

2. **Type Validation**
   - **Assigned to:** @typescript-validator
   - **Objective:** Ensure type safety
   - **Deliverable:** Type check results
   - **Success:** No type errors

**Execution:** Parallel where possible

**Validation:** All quality gates pass

---

## Agent Orchestration

### Execution Order

**Sequential Phases:**
1. Phase 1 → Must complete before Phase 2
2. Phase 2 → Must complete before Phase 3
3. Phase 3 → Must complete before Phase 4

**Parallel Opportunities:**

**Within Phase 1:**
- Task 1.1 and 1.2 can run in parallel

**Within Phase 2:**
- [Parallel tasks and rationale]

### Agent Assignments Summary

| Agent | Tasks | Deliverables |
|-------|-------|--------------|
| @agent-1 | [Numbers] | [What they produce] |
| @agent-2 | [Numbers] | [What they produce] |

---

## Context for Specialists

### For @[agent-name]
**Reusability Guidance:**
- Use [specific file] as foundation
- Extend [specific code]
- Follow [pattern] from [file]

**Constraints:**
- [Constraint 1]
- [Constraint 2]

**Reference Files:**
- \`path/to/reference.vue\` - Pattern to follow

---

## Success Criteria

**Overall Success:**
- [ ] All tasks completed
- [ ] Matches description
- [ ] Follows patterns
- [ ] Leverages reusability
- [ ] No regressions

**Phase-Specific:**

**Phase 1 Complete When:**
- [ ] [Criterion]

**Phase 2 Complete When:**
- [ ] [Criterion]

**Phase 3 Complete When:**
- [ ] [Criterion]

**Phase 4 Complete When:**
- [ ] All tests pass
- [ ] Type check passes
- [ ] Lint passes
- [ ] Manual validation successful

---

## Risk Assessment

**Potential Blockers:**
1. **[Risk]**
   - Impact: [High/Medium/Low]
   - Mitigation: [How to address]

**Assumptions:**
- [Assumption that could affect plan]

**Contingencies:**
- If [scenario], then [alternative]

---

## Communication Plan

**Agent Handoffs:**
- Phase 1 → 2: [What info to communicate]
- Phase 2 → 3: [What info to communicate]

**Reporting Requirements:**
Each agent creates report (<300 lines) with:
- Tasks completed
- Files changed
- Decisions made
- Validation performed
- Notes for other agents

---

## Validation Plan

**Automated:**
- [ ] `npm run typecheck`
- [ ] `npm run lint`
- [ ] `npm run test`
- [ ] `npm run build`

**Manual:**
- [ ] Feature works
- [ ] SSR hydration (if applicable)
- [ ] Responsive design
- [ ] Dark mode
- [ ] Accessibility

**Regression:**
- [ ] Existing features functional
- [ ] No new type errors
- [ ] No console warnings
- [ ] Performance maintained

---

## Summary

**What:** [One sentence]

**How:** [One sentence]

**Why:** [One sentence based on pre-analysis]

**Effort:** [Estimate]

**Success Factors:**
1. [Critical factor]
2. [Critical factor]
```

---

## IMPLEMENTATION_REPORT.md Template

Used by: All specialist agents
Location: `.temp/[task-name]/reports/[agent-name]-report.md`
**Max Length:** 300 lines

```markdown
# [Agent Name] Implementation Report

## Tasks Completed
- [x] Task 1 from master plan
- [x] Task 2 from master plan

## Files Created
- \`path/to/file.ts\` - [Why created]

## Files Modified
- \`path/to/file.vue\` - [What changed and why]
  - Added props: [list]
  - Added slots: [list]
  - Added methods: [list]

## Decisions Made
- **Decision 1:** [What and why]
- **Decision 2:** [What and why]

## Reusability Leveraged
- Used [existing code] from [file]
- Extended [pattern] from [file]
- Followed [convention] from [file]

## VueUse Integration
- Used \`useComposable()\` for [purpose]

## Validation Performed
- [x] Type check passed
- [x] Manual testing performed
- [x] SSR compatibility verified
- [x] Tests pass

## Notes for Other Agents
- Created type \`TypeName\` in \`src/types/\` - available for use
- Added store action \`actionName()\` - see docs
- Issue that needs attention: [description]

## Success Criteria Met
- [x] Criterion 1 from master plan
- [x] Criterion 2 from master plan

## Code Metrics (for improve command)
Before:
- Metric 1: [value]

After:
- Metric 1: [value]

## Root Cause Analysis (for fix command)
**Problem:** [What was broken]
**Cause:** [Why broken]
**Location:** \`file.ts:line\`

**Fix:** [How it was fixed]
**Lines Changed:** [number]

## Regression Test (for fix command)
**Test:** \`path/test.test.ts\`
- Fails before fix: ✓
- Passes after fix: ✓
```

---

## COMPLETION_REPORT.md Template

Used by: Main agent
Location: `.temp/[task-name]/COMPLETION_REPORT.md`

```markdown
# Completion Report: [Task Name]

**Task:** [Description]
**Type:** [new/add/improve/fix]
**Date:** [Current date]
**Status:** [Success/Partial/Blocked]

---

## Summary

**What Was Done:**
[Brief description]

**Approach:**
[Summary of approach]

**Key Decisions:**
- [Decision 1]
- [Decision 2]

---

## Implementation Overview

### Files Created
- \`path\` - [Purpose]

### Files Modified
- \`path\` - [Changes]

### Agents Utilized
| Agent | Tasks | Report |
|-------|-------|--------|
| @agent | [Summary] | \`.temp/[task]/reports/[agent]-report.md\` |

---

## Reusability Achieved

**Leveraged Existing:**
- [What was reused]

**VueUse Used:**
- \`useX()\` - [How used]

**Patterns Followed:**
- [Pattern 1]

---

## Architecture Compliance

**Hierarchy:**
- ✅ VueUse checked
- ✅ Composables in src/composables/
- ✅ Stores in src/stores/
- ✅ Components with slots

**TypeScript:**
- ✅ Strong typing
- ✅ No 'any'
- ✅ Zod validation

**SSR:**
- ✅ SSR-safe patterns
- ✅ Hydration tested

---

## Validation Results

**Automated:**
- [ ] typecheck: [Pass/Fail/N/A]
- [ ] lint: [Pass/Fail/N/A]
- [ ] test: [Pass/Fail/N/A]
- [ ] build: [Pass/Fail/N/A]

**Manual:**
- [ ] Feature works
- [ ] Responsive
- [ ] Dark mode
- [ ] Accessible
- [ ] SSR hydration

**Test Coverage:**
- Unit: [%]
- Component: [%]
- Integration: [%]

---

## Success Criteria

**From Plan:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]

**Overall:** [Pass/Partial/Fail]

---

## Known Issues

**Issues:**
- [Issue and status]

**Technical Debt:**
- [Shortcuts taken]

**Follow-Up:**
- [Tasks for later]

---

## Documentation

**Usage:**
\`\`\`typescript
// Example
\`\`\`

**API Changes:**
- [New props/methods/events]

**Tests:**
- Location: [path]
- How to run: [command]

---

## Metrics (for improve/fix)

**Code Impact:**
- Files modified: [number]
- Files created: [number]
- Lines changed: [number]

**Quality (improve):**
Before → After:
- 'any' types: [num] → [num]
- Duplications: [num] → [num]
- Coverage: [%] → [%]

**Bug Fix (fix):**
- Root cause: [description]
- Fix location: \`file:line\`
- Regression test: [added/not needed]

---

## Lessons Learned

**Worked Well:**
- [Success 1]

**Could Improve:**
- [Improvement 1]

**Reusability Created:**
- [New reusable code]

---

## Next Steps

**Immediate:**
- [ ] [Next step]

**Future:**
- [ ] [Enhancement]

---

## Appendices

**Reports:**
- Pre-Analysis: \`.temp/[task]/PRE_ANALYSIS.md\`
- Master Plan: \`.temp/[task]/MASTER_PLAN.md\`
- Agent Reports: \`.temp/[task]/reports/\`

**Command:**
\`\`\`bash
/frontend-[new/add/improve/fix] [args]
\`\`\`
```

---

## Template Usage Guidelines

### For Agents

1. **Read the template** for your report type before creating
2. **Fill all sections** - use "N/A" if section doesn't apply
3. **Stay under 300 lines** for implementation reports
4. **Be specific** - include file paths, line numbers, exact decisions
5. **Quantify** - use metrics where possible
6. **Be helpful** - provide context for other agents

### For Main Agent

1. **PRE_ANALYSIS.md** - Consolidate findings from code-scout and documentation-researcher
2. **MASTER_PLAN.md** - Created by plan-master, review and ensure completeness
3. **IMPLEMENTATION_REPORTS** - Collect from each specialist, review for completeness
4. **COMPLETION_REPORT.md** - Synthesize all reports into final summary

### Quality Checks

**Pre-Analysis Must Have:**
- Project context (tech stack, scripts, structure)
- Reusable code identified
- Patterns documented
- Recommendations for planning

**Master Plan Must Have:**
- Clear phases with tasks
- Agent assignments
- Success criteria
- Execution order (sequential vs parallel)

**Implementation Report Must Have:**
- Tasks completed
- Files changed (with descriptions)
- Validation performed
- Notes for other agents

**Completion Report Must Have:**
- Summary of what was done
- Validation results
- Success criteria assessment
- Next steps

---

## Report Storage Convention

```
.temp/
└── [task-name]/
    ├── PRE_ANALYSIS.md
    ├── MASTER_PLAN.md
    ├── COMPLETION_REPORT.md
    └── reports/
        ├── vue-architect-report.md
        ├── typescript-validator-report.md
        └── [agent-name]-report.md
```

---

## Version

**Template Version:** 1.0
**Last Updated:** 2025-10-16
**Maintained By:** Frontend Development System

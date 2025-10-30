---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(git:*), Read, Write, Edit, TodoWrite, Task, WebSearch, WebFetch, Glob, Grep
argument-hint: [feature-name] [what-to-add]
description: Analyze feature and create implementation plan (combines analyze + plan phases)
---

# Frontend Feature Initiation (Analysis + Planning)

**Feature:** `$1`
**Addition:** `$2`

This command combines the analysis and planning phases into a single workflow:
- **Phase 0-1:** Analyze existing feature architecture and research solutions
- **Phase 2:** Create comprehensive implementation plan based on analysis

## Phase 0: Initialization

### Create Todo List

Initialize a TodoWrite list with the following tasks:

```json
{
  "todos": [
    {
      "content": "Initialize workspace",
      "status": "in_progress",
      "activeForm": "Initializing workspace"
    },
    {
      "content": "Spawn code-scout for feature analysis",
      "status": "pending",
      "activeForm": "Analyzing feature architecture"
    },
    {
      "content": "Spawn documentation-researcher for solution research",
      "status": "pending",
      "activeForm": "Researching solutions"
    },
    {
      "content": "Consolidate analysis findings",
      "status": "pending",
      "activeForm": "Consolidating analysis"
    },
    {
      "content": "Spawn plan-master for plan creation",
      "status": "pending",
      "activeForm": "Creating implementation plan"
    },
    {
      "content": "Present plan to user for approval",
      "status": "pending",
      "activeForm": "Presenting plan"
    }
  ]
}
```

### Workspace Setup

Create the workspace:
```bash
mkdir -p .temp/initiate-$1-$(date +%Y%m%d-%H%M%S)
```

Store the feature context for use by subsequent commands:
```bash
echo "# Feature Context

**Feature Name:** $1
**Description:** $2
**Created:** $(date)
**Command:** frontend-initiate

---

This file stores the feature name and description for use by subsequent commands.
If you run /frontend-implement or /frontend-validate with only the feature name,
they will automatically read the description from this file.
" > .temp/initiate-$1-*/FEATURE_CONTEXT.md
```

Store workspace path for later use.

## Phase 1: Parallel Analysis

Spawn TWO agents in parallel using the Task tool:

### Agent 1: Code Scout (Feature Architecture Mapping)

**Spawn @code-scout agent with mission:**

Use the Task tool to spawn the `code-scout` agent:

```
Task(
  subagent_type: "code-scout",
  description: "Map feature architecture for $1",
  prompt: """
You are analyzing feature "$1" to prepare for adding "$2".

Your PRIMARY MISSION is to discover and map ALL code related to feature "$1":

## Discovery Tasks

1. **Find ALL files related to feature "$1":**
   - Vue/React components that implement it (src/components/)
   - Stores/state management (Pinia/Redux/Zustand/nanostores in src/stores/)
   - Composables/hooks that provide logic (src/composables/ or src/hooks/)
   - API routes that support it (src/api/ or src/pages/api/)
   - TypeScript types that define it (src/types/)
   - Tests that cover it (tests/ or __tests__/)

2. **Trace the complete data flow:**
   - How data enters this feature
   - Which stores manage its state
   - Which composables/hooks provide its logic
   - Which components consume the data
   - How it connects to backend APIs

3. **Document architectural patterns:**
   - Component naming conventions
   - Store organization patterns
   - Composable/hook composition patterns
   - Type definitions and type safety patterns
   - API endpoint patterns

4. **Identify reusability opportunities:**
   - Existing code that could be extended for "$2"
   - Base components that could be composed
   - Utility functions that could be reused
   - Similar patterns used elsewhere in codebase

## Output Requirements

Create your standard PRE_ANALYSIS.md file in the workspace directory with:
- Complete file map of feature "$1"
- Data flow diagram (as markdown)
- Architectural patterns observed
- Extension points for adding "$2"
- Reusability opportunities identified

CRITICAL: Be thorough. This analysis guides the entire implementation.
"""
)
```

### Agent 2: Documentation Researcher (Solution Research)

**Spawn @documentation-researcher agent with mission:**

Use the Task tool to spawn the `documentation-researcher` agent:

```
Task(
  subagent_type: "documentation-researcher",
  description: "Research solutions for $2",
  prompt: """
You are researching existing solutions for implementing "$2" functionality.

Your research question: "What are the best existing solutions, libraries, and patterns for implementing '$2' in the current tech stack?"

## Research Tasks

1. **Search local documentation:**
   - Check /Users/natedamstra/.claude/documentation/ for relevant patterns
   - Look for VueUse composables that provide "$2" or similar
   - Search for React hooks or utilities
   - Find framework-specific patterns for "$2"

2. **Web research verification:**
   - Use gemini-cli to search for current best practices (2025)
   - Find npm packages that solve this problem
   - Locate official documentation examples
   - Identify common implementation patterns

3. **Solution comparison:**
   - Document each solution found (name, source, match %)
   - Explain what each does and how well it matches "$2"
   - Show usage examples if available
   - Note dependencies and compatibility

4. **Best recommendation:**
   - Which solution best matches "$2"?
   - Custom code vs. npm package vs. VueUse/React ecosystem?
   - What are the tradeoffs?

## Output Requirements

Create a markdown report with:
- **Solutions Found:** Table with name, source, match %, rationale
- **Best Recommendation:** Which approach to use and why
- **Implementation Examples:** Code snippets showing usage
- **Dependencies:** What's needed to implement each solution
- **Verification:** Note both local docs and web sources used

Add findings to appropriate MEMORIES.md file for future reference.

CRITICAL: Prioritize VueUse/React ecosystem solutions - prefer battle-tested libraries over custom implementations.
"""
)
```

**Both agents run in parallel.** Wait for both to complete before proceeding.

## Phase 1.5: Consolidate Analysis

After both agents complete:

1. **Read both outputs** from the agents
2. **Create `PRE_ANALYSIS.md`** in the workspace directory consolidating:
   - Existing Feature Architecture
   - Reusable Code & Solutions Found
   - Recommended Extension Strategy
   - Integration Points Identified

3. **Update todo list** - mark analysis tasks as completed

## Phase 2: Create Implementation Plan

### Spawn Planning Agent

**Spawn @plan-master agent with mission:**

Use the Task tool to spawn the `plan-master` agent:

```
Task(
  subagent_type: "plan-master",
  description: "Create implementation plan for adding $2 to $1",
  prompt: """
You are creating an implementation plan for adding "$2" to existing feature "$1".

## Your Task

Read the PRE_ANALYSIS.md file from the analysis phase (just completed) and create a comprehensive MASTER_PLAN.md that orchestrates specialist agents to implement "$2" functionality.

## Input Context

**Task Type:** add (extending existing feature)
**Feature:** $1
**Addition:** $2
**Pre-Analysis Location:** .temp/initiate-$1-*/PRE_ANALYSIS.md

## Planning Requirements

### 1. Extension-First Approach
Focus on extending existing code rather than creating new:
- Extend existing components with new props/slots
- Add actions/getters to existing stores
- Enhance existing composables with new functionality
- Only create new files when absolutely necessary

### 2. Minimal Changes Philosophy
- Change the least amount of code necessary
- Preserve backward compatibility (no breaking changes)
- Don't refactor unrelated code
- Make all new features additive (optional props, default values)

### 3. Leverage Pre-Analysis Findings
Use the reusability opportunities identified by code-scout:
- Exact match components/functions to reuse as-is
- Near match code to extend (70-90% there)
- Base components to compose
- VueUse alternatives to prefer over custom code
- Similar patterns to follow

### 4. Architecture Hierarchy Alignment
Follow the established hierarchy:
- VueUse/ecosystem composables (check first)
- Custom composables/hooks
- Stores/state management
- Components (extend existing or create new)

### 5. Phase Structure
Organize into logical phases:
- **Phase 1: Foundation** - Extend/create stores and composables
- **Phase 2: Implementation** - Extend/create components
- **Phase 3: Integration** - Wire new functionality into existing feature
- **Phase 4: Quality Assurance** - Testing, validation, regression checks

### 6. Agent Assignments
Select appropriate specialist agents for each task:
- Identify which specialists are needed
- Assign clear objectives to each agent
- Define deliverables and success criteria
- Specify execution order (sequential vs parallel)

## Output Requirements

Create MASTER_PLAN.md following your standard template structure:

# Master Plan: Adding "$2" to $1

**Date:** [today]
**Based on:** PRE_ANALYSIS.md

## Summary

**What's Being Added:** [Brief description]
**Approach:** [Extension vs. creation]
**Impact:** [Small/Medium/Large change]
**Backward Compatible:** [Yes/No/Optional]

## Phase 1: Foundation (Stores & Composables)

### Task 1.1: [Store/State Management]
**File:** [path]
**Changes:** [specific changes]
**Rationale:** [why this approach]

### Task 1.2: [Composable/Hook]
**File:** [path]
**Approach:** [Extend existing or create new]
**Responsibilities:** [what it does]
**Dependencies:** [VueUse/npm packages needed]

## Phase 2: Implementation (Components)

### Task 2.1: [Component Modifications]
**File:** [path]
**New Props/Hooks:** [list]
**New Slots/Children:** [list]
**Changes:** [describe additions]
**Rationale:** [why this component]

## Phase 3: Integration

### Task 3.1: Wire into Existing Feature
**Steps:** [numbered list]
**Integration Points:** [where code connects]

### Task 3.2: Backward Compatibility
- All new props optional or have defaults
- Existing functionality unchanged
- Existing tests still pass
- No breaking changes to component API

## Phase 4: Quality Assurance

### Task 4.1: Testing
- Tests for new functionality
- Regression tests for existing features
- Type checking
- Build validation

### Task 4.2: Validation
- Manual testing
- Code review for patterns
- Performance assessment

## Success Criteria

- [ ] Minimal code changes achieved
- [ ] Backward compatibility maintained
- [ ] Architecture patterns preserved
- [ ] All tests passing
- [ ] New "$2" functionality works
- [ ] Existing $1 feature still works

## Implementation Effort Estimate

- Foundation: [N] files, ~[X] LOC
- Implementation: [N] files, ~[X] LOC
- Integration: ~[X] LOC
- Testing: ~[X] LOC

**Total Estimated Effort:** [Low/Medium/High]

## Critical Success Factors

Your plan must:
- ✅ Focus on WHAT needs to be done, not HOW to implement it
- ✅ Leave technical implementation details to specialist agents
- ✅ Leverage all reusability opportunities from PRE_ANALYSIS.md
- ✅ Assign appropriate specialist agents to tasks
- ✅ Define clear success criteria for each phase
- ✅ Enable parallel execution where tasks are independent
- ✅ Minimize changes while achieving the goal
- ✅ Ensure backward compatibility throughout

Remember: You are the orchestrator. Create a clear roadmap that empowers specialist agents to excel at their tasks while ensuring everything works together.
"""
)
```

## Phase 3: Present Results for Approval

After the planning agent completes, review both PRE_ANALYSIS.md and MASTER_PLAN.md and present:

```markdown
# Initiation Complete ✅

## Analysis Results

**Feature Analyzed:** $1
**Addition Requested:** $2

### Key Findings
- Feature architecture: [pattern description]
- Files involved: [N files]
- Recommended solution: [approach]
- Integration points: [where to add code]

**Analysis Document:** `.temp/initiate-$1-*/PRE_ANALYSIS.md`

---

## Implementation Plan Created

### Key Decisions

1. **Extension Strategy**: [Extend existing vs create new]
2. **Minimal Changes**: [Estimated X lines across Y files]
3. **Backward Compatible**: [Yes/No with explanation]
4. **Integration Points**: [How new connects to existing]

### The Plan Phases

**Phase 1 - Foundation (15-30 min)**
- [Store/state changes]
- [Composable/hook changes]

**Phase 2 - Implementation (30-45 min)**
- [Component modifications]
- [New functionality]

**Phase 3 - Integration (15-20 min)**
- [Wiring strategy]
- [Type updates]

**Phase 4 - Quality (20-30 min)**
- [Testing approach]
- [Validation steps]

### Estimated Total Impact

- Files Modified: [N]
- Files Created: [N]
- Lines Added: ~[X]
- Net Change: [Small/Medium/Large]

**Plan Document:** `.temp/initiate-$1-*/MASTER_PLAN.md`

---

## Next Steps

**Please review both documents:**
1. PRE_ANALYSIS.md - Architecture and solution findings
2. MASTER_PLAN.md - Complete implementation strategy

**Once approved, proceed with:**
```bash
/frontend-implement "$1" "$2"
```

⚠️ **IMPORTANT:** Review and approve this plan before implementation!
```

## Success Criteria

- [x] Workspace initialized
- [x] code-scout agent completed feature analysis
- [x] documentation-researcher agent completed solution research
- [x] PRE_ANALYSIS.md created and comprehensive
- [x] plan-master agent completed planning
- [x] MASTER_PLAN.md created with full structure
- [x] Extension-first approach applied
- [x] Minimal changes identified
- [x] Clear phase breakdown
- [x] Backward compatibility ensured
- [x] Both analysis and plan presented for user approval
- [x] Clear handoff to implementation phase

## Execution Notes

**Remember:**
- This command combines analysis + planning into a single workflow
- Three agents spawn sequentially:
  1. `code-scout` + `documentation-researcher` (parallel analysis)
  2. Consolidate findings into PRE_ANALYSIS.md
  3. `plan-master` (reads PRE_ANALYSIS.md, creates MASTER_PLAN.md)
- All work happens in single workspace: `.temp/initiate-$1-*/`
- User gets natural approval gate after both phases complete
- Ready to proceed to `/frontend-implement` after approval

**Agent Files:**
- code-scout: /Users/natedamstra/.claude/agents/code-scout.md
- documentation-researcher: /Users/natedamstra/.claude/agents/documentation-researcher.md
- plan-master: /Users/natedamstra/.claude/agents/plan-master.md

**Workflow:**
```
Phase 0-1: Analysis
  ├─ code-scout (parallel) → Feature architecture
  └─ documentation-researcher (parallel) → Solution research
  ↓
  Consolidate → PRE_ANALYSIS.md
  ↓
Phase 2: Planning
  └─ plan-master (reads PRE_ANALYSIS.md) → MASTER_PLAN.md
  ↓
Phase 3: Approval Gate
  → User reviews both documents
  → User runs /frontend-implement when ready
```

---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(git:*), Bash(npm:*), Bash(pnpm:*), Read, Write, Edit, MultiEdit, TodoWrite, Task, WebSearch, WebFetch, Glob, Grep
argument-hint: [feature-name] [what-to-add]
description: Complete feature addition workflow (analyze + plan + implement) - no approval gate
---

# Frontend Quick Task (Full Auto-Implementation)

**Feature:** `$1`
**Addition:** `$2`

⚠️ **WARNING:** This command runs the complete workflow WITHOUT user approval gates:
- Phase 0-1: Analysis (architecture mapping + solution research)
- Phase 2: Planning (creates implementation plan)
- Phase 3: Implementation (executes the plan with specialist agents)

**Use this when:** You trust the automation and want fast iteration
**Don't use when:** You want to review the plan before implementation

## Phase 0: Initialization

### Create Todo List

```json
{
  "todos": [
    {
      "content": "Initialize workspace",
      "status": "in_progress",
      "activeForm": "Initializing workspace"
    },
    {
      "content": "Phase 1: Analyze feature architecture",
      "status": "pending",
      "activeForm": "Analyzing architecture"
    },
    {
      "content": "Phase 1: Research solutions",
      "status": "pending",
      "activeForm": "Researching solutions"
    },
    {
      "content": "Phase 1: Consolidate analysis",
      "status": "pending",
      "activeForm": "Consolidating analysis"
    },
    {
      "content": "Phase 2: Create implementation plan",
      "status": "pending",
      "activeForm": "Creating plan"
    },
    {
      "content": "Phase 3: Execute foundation (stores/composables)",
      "status": "pending",
      "activeForm": "Implementing foundation"
    },
    {
      "content": "Phase 3: Execute components",
      "status": "pending",
      "activeForm": "Implementing components"
    },
    {
      "content": "Phase 3: Execute integration",
      "status": "pending",
      "activeForm": "Integrating features"
    },
    {
      "content": "Phase 3: Execute testing",
      "status": "pending",
      "activeForm": "Testing implementation"
    },
    {
      "content": "Commit changes and complete",
      "status": "pending",
      "activeForm": "Committing changes"
    }
  ]
}
```

### Workspace Setup

Create the workspace:
```bash
mkdir -p .temp/quick-task-$1-$(date +%Y%m%d-%H%M%S)
```

Store the feature context for use by subsequent commands:
```bash
echo "# Feature Context

**Feature Name:** $1
**Description:** $2
**Created:** $(date)
**Command:** frontend-quick-task

---

This file stores the feature name and description for use by subsequent commands.
If you run /frontend-validate with only the feature name,
it will automatically read the description from this file.
" > .temp/quick-task-$1-*/FEATURE_CONTEXT.md
```

Store workspace path for use throughout all phases.

---

## PHASE 1: ANALYSIS (Parallel Agents)

Spawn TWO agents in parallel using the Task tool:

### Agent 1: Code Scout (Feature Architecture Mapping)

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

**Wait for both agents to complete before proceeding.**

### Consolidate Analysis

After both agents complete:

1. **Read both outputs** from the agents
2. **Create `PRE_ANALYSIS.md`** in the workspace directory consolidating:
   - Existing Feature Architecture
   - Reusable Code & Solutions Found
   - Recommended Extension Strategy
   - Integration Points Identified

3. **Update todo** - Mark analysis tasks as completed

---

## PHASE 2: PLANNING (Strategic Plan)

### Spawn Planning Agent

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
**Pre-Analysis Location:** .temp/quick-task-$1-*/PRE_ANALYSIS.md

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

Create MASTER_PLAN.md following your standard template structure with:
- Summary (what's being added, approach, impact, backward compatibility)
- Phase 1: Foundation (stores, composables, dependencies)
- Phase 2: Implementation (components, modifications, rationale)
- Phase 3: Integration (wiring strategy, integration points, backward compatibility)
- Phase 4: Quality Assurance (testing, validation, performance)
- Success Criteria (checklist of completion requirements)
- Implementation Effort Estimate (files, LOC, total effort)

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

⚠️ IMPORTANT: This plan will be executed IMMEDIATELY without user approval. Make it production-ready.
"""
)
```

**Wait for plan-master to complete.**

### Read and Analyze Plan

After plan-master completes:

1. **Read MASTER_PLAN.md** from workspace
2. **Analyze requirements** to determine which specialist agents are needed
3. **Update todo** - Mark planning task as completed

---

## PHASE 3: IMPLEMENTATION (Multi-Agent Execution)

### Intelligent Agent Selection

Based on MASTER_PLAN.md, determine which specialist agents to spawn:

**Available Specialist Agents:**
- `code-reuser-scout` - Find existing patterns (ALWAYS RUN FIRST)
- `nanostore-state-architect` - State management with nanostores
- `vue-architect` - Vue 3 components, Composition API, SSR patterns
- `astro-architect` - Astro pages, layouts, API routes
- `tailwind-styling-expert` - Responsive design, dark mode, accessibility
- `typescript-validator` - Type safety, Zod schemas, error resolution
- `appwrite-integration-specialist` - Appwrite auth, database, storage
- `ssr-debugger` - SSR issues, hydration mismatches
- `python-architect` - Python backend (if needed)
- `general-purpose` - Standard implementations

### Pre-Implementation: Reusability Check

**ALWAYS spawn code-reuser-scout FIRST:**

```
Task(
  subagent_type: "code-reuser-scout",
  description: "Find existing patterns for $2",
  prompt: """
Search Task: Find existing code patterns for "$2" before implementation

Read: .temp/quick-task-$1-*/MASTER_PLAN.md

Search For:
1. Existing components similar to [components we plan to create]
2. Existing composables that solve [functionality needed]
3. Existing stores that manage [similar state]
4. Existing utilities that provide [helper functions]
5. Similar implementations elsewhere in codebase

Report:
- EXACT MATCHES: Code that already does this
- NEAR MATCHES: Code that does 70-90% of this
- BASE COMPONENTS: Code we can extend/compose
- PATTERNS TO FOLLOW: Conventions observed in codebase

Recommendation:
Should we reuse existing code, extend it, refactor it, or create new?

Output: Detailed reusability report with file paths and line numbers.
"""
)
```

**Wait for code-reuser-scout to complete before spawning implementation agents.**

### Foundation Phase (Parallel Agents)

Based on MASTER_PLAN.md Phase 1, spawn appropriate foundation agents:

**If state management needed:**
```
Task(
  subagent_type: "nanostore-state-architect",
  description: "Implement nanostores for $2 state",
  prompt: """
Read: .temp/quick-task-$1-*/MASTER_PLAN.md (Phase 1: Foundation section)

Task: Implement state management for "$2" using nanostores

[Use full prompt from frontend-implement.md lines 177-203]
"""
)
```

**If TypeScript types needed:**
```
Task(
  subagent_type: "typescript-validator",
  description: "Create type definitions for $2",
  prompt: """
Read: .temp/quick-task-$1-*/MASTER_PLAN.md (Phase 1: Foundation section)

Task: Create comprehensive type definitions for "$2"

[Use full prompt from frontend-implement.md lines 330-358]
"""
)
```

**Wait for foundation agents to complete.**

### Implementation Phase (Parallel Agents)

Based on MASTER_PLAN.md Phase 2, spawn appropriate implementation agents:

**If Vue components needed:**
```
Task(
  subagent_type: "vue-architect",
  description: "Implement Vue components for $2",
  prompt: """
Read: .temp/quick-task-$1-*/MASTER_PLAN.md (Phase 2: Implementation section)

Task: Implement Vue 3 components for "$2" with Composition API

[Use full prompt from frontend-implement.md lines 248-279]
"""
)
```

**If styling needed:**
```
Task(
  subagent_type: "tailwind-styling-expert",
  description: "Style components for $2",
  prompt: """
Read: .temp/quick-task-$1-*/MASTER_PLAN.md (Phase 2: Implementation section)

Task: Style components for "$2" with Tailwind CSS

[Use full prompt from frontend-implement.md lines 288-318]
"""
)
```

**Wait for implementation agents to complete.**

### Integration Phase (Sequential Agents)

Based on MASTER_PLAN.md Phase 3, spawn appropriate integration agents:

**If Appwrite backend needed:**
```
Task(
  subagent_type: "appwrite-integration-specialist",
  description: "Integrate Appwrite backend for $2",
  prompt: """
Read: .temp/quick-task-$1-*/MASTER_PLAN.md (Phase 3: Integration section)

Task: Integrate Appwrite backend services for "$2"

[Use full prompt from frontend-implement.md lines 372-401]
"""
)
```

**If Astro pages/routes needed:**
```
Task(
  subagent_type: "astro-architect",
  description: "Create Astro pages/routes for $2",
  prompt: """
Read: .temp/quick-task-$1-*/MASTER_PLAN.md (Phase 3: Integration section)

Task: Implement Astro pages and API routes for "$2"

[Use full prompt from frontend-implement.md lines 410-442]
"""
)
```

**Wait for integration agents to complete.**

### Quality Assurance Phase

**If SSR issues detected, spawn debugger:**
```
Task(
  subagent_type: "ssr-debugger",
  description: "Debug SSR issues in $2",
  prompt: """
Debug Task: Identify and fix SSR-specific issues in "$2" implementation

[Use full prompt from frontend-implement.md lines 455-482]
"""
)
```

---

## PHASE 4: CONSOLIDATION & COMPLETION

### Consolidate Implementation Reports

After all implementation agents complete:

1. **Collect all agent outputs** and consolidate findings
2. **Create implementation summary** markdown document
3. **Verify all phases completed**

### Run Automated Validation

```bash
# Type checking
pnpm run typecheck

# Linting
pnpm run lint

# Build verification
pnpm run build

# Test suite
pnpm run test
```

### Commit Changes

If all validation passes:

```bash
git add -A
git commit -m "feat: add $2 to $1 feature

Automated implementation via /frontend-quick-task:
- Phase 1: Analysis (code-scout + documentation-researcher)
- Phase 2: Planning (plan-master)
- Phase 3: Implementation (specialist agents)

Changes:
- Extended store with new actions/getters
- Enhanced composable with new logic
- Modified components to support new functionality
- Added comprehensive tests
- Maintained backward compatibility

Agents used: [list all agents that ran]
Validation: All tests passing, type check passed, build successful"
```

### Present Results

```markdown
# Quick Task Complete ✅

## Feature: $1
## Addition: $2

### Workflow Summary

**Phase 1: Analysis (15-30 min)**
- ✅ Feature architecture mapped by code-scout
- ✅ Solutions researched by documentation-researcher
- ✅ PRE_ANALYSIS.md created

**Phase 2: Planning (10-20 min)**
- ✅ Implementation plan created by plan-master
- ✅ MASTER_PLAN.md created
- ✅ Agent assignments determined

**Phase 3: Implementation (45-90 min)**
- ✅ Reusability check by code-reuser-scout
- ✅ Foundation implemented (stores, types)
- ✅ Components implemented
- ✅ Integration completed
- ✅ Tests added

**Phase 4: Validation**
- ✅ Type check: PASSED
- ✅ Lint: PASSED
- ✅ Build: SUCCESSFUL
- ✅ Tests: ALL PASSING

### Total Time: [actual time]

### Files Changed
- Modified: [N] files
- Created: [N] files
- Lines added: ~[X]
- Lines removed: ~[Y]
- Net change: [Small/Medium/Large]

### Agents Used
[List all agents that participated]

### Artifacts Created
- `.temp/quick-task-$1-*/PRE_ANALYSIS.md`
- `.temp/quick-task-$1-*/MASTER_PLAN.md`
- Implementation reports from specialist agents
- Modified source files
- New test files

### Next Step (Optional)

Run final validation if desired:
```bash
/frontend-validate "$1" "$2"
```

Or proceed directly to PR/deployment - implementation is production-ready.
```

---

## Success Criteria

- [x] Workspace initialized
- [x] Phase 1: code-scout completed analysis
- [x] Phase 1: documentation-researcher completed research
- [x] Phase 1: PRE_ANALYSIS.md created
- [x] Phase 2: plan-master created MASTER_PLAN.md
- [x] Phase 3: code-reuser-scout checked for existing patterns
- [x] Phase 3: Foundation agents completed (stores, types)
- [x] Phase 3: Implementation agents completed (components, styling)
- [x] Phase 3: Integration agents completed (pages, backend)
- [x] Phase 3: Quality agents completed (SSR debugging if needed)
- [x] Phase 4: All automated checks passed
- [x] Phase 4: Changes committed with clear message
- [x] Backward compatibility maintained throughout
- [x] Production-ready implementation

---

## Execution Notes

**Command Flow:**
```
/frontend-quick-task "feature" "addition"
  ↓
Phase 1: Analysis (parallel)
  ├─ code-scout → Feature architecture
  └─ documentation-researcher → Solution research
  ↓
  Consolidate → PRE_ANALYSIS.md
  ↓
Phase 2: Planning
  └─ plan-master → MASTER_PLAN.md
  ↓
Phase 3: Implementation (multi-phase)
  ├─ Pre-implementation: code-reuser-scout
  ├─ Foundation: nanostore-state-architect + typescript-validator (parallel)
  ├─ Implementation: vue-architect + tailwind-styling-expert (parallel)
  ├─ Integration: astro-architect + appwrite-integration-specialist (as needed)
  └─ Quality: ssr-debugger (if issues found)
  ↓
Phase 4: Validation & Commit
  ├─ Type check, lint, build, test
  └─ Git commit with detailed message
  ↓
Done! Production-ready implementation ✅
```

**Agent Coordination:**
- All agents spawned from main agent (flat hierarchy)
- File-based state persistence (PRE_ANALYSIS.md, MASTER_PLAN.md)
- No user approval gates (fully automated)
- Intelligent agent selection based on plan requirements
- Parallel execution where tasks are independent
- Sequential execution where dependencies exist

**Key Differences from /frontend-initiate:**
- No approval gate after planning - proceeds directly to implementation
- Single command for entire workflow
- Faster iteration for trusted automation
- Same quality guarantees as phased approach

**When to Use:**
- ✅ Small-medium feature additions
- ✅ Well-understood requirements
- ✅ Trust in automated planning and implementation
- ✅ Fast iteration needed
- ✅ Low-risk changes

**When NOT to Use:**
- ❌ Large, complex feature additions
- ❌ Unclear requirements
- ❌ High-risk changes requiring review
- ❌ Want to modify plan before implementation
- ❌ Learning/experimental work

**Agent Files:**
All specialist agents defined in `/Users/natedamstra/.claude/agents/`:
- code-scout.md, documentation-researcher.md, plan-master.md (phases 1-2)
- code-reuser-scout.md, nanostore-state-architect.md, vue-architect.md (phase 3)
- astro-architect.md, tailwind-styling-expert.md, typescript-validator.md (phase 3)
- appwrite-integration-specialist.md, ssr-debugger.md, python-architect.md (phase 3)

---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(git:*), Read, Write, Edit, TodoWrite, Task, WebSearch, WebFetch, Glob, Grep
argument-hint: [feature-name] [what-to-add]
description: Analyze existing frontend feature and identify extension opportunities
---

# Frontend Feature Analysis

**Feature to Analyze:** `$1`
**What to Add:** `$2`

## Phase 0: Initialization

### Create Todo List

Initialize a TodoWrite list with the following tasks:

```json
{
  "todos": [
    {
      "content": "Initialize analysis workspace",
      "status": "in_progress",
      "activeForm": "Initializing analysis workspace"
    },
    {
      "content": "Run feature architecture mapping (spawn Explore agent)",
      "status": "pending",
      "activeForm": "Mapping feature architecture"
    },
    {
      "content": "Run solution research (spawn web-researcher agent)",
      "status": "pending",
      "activeForm": "Researching solutions"
    },
    {
      "content": "Consolidate findings into PRE_ANALYSIS.md",
      "status": "pending",
      "activeForm": "Consolidating findings"
    },
    {
      "content": "Present analysis results to user",
      "status": "pending",
      "activeForm": "Presenting results"
    }
  ]
}
```

### Workspace Setup

Create the workspace:
```bash
mkdir -p .temp/analyze-$1-$(date +%Y%m%d-%H%M%S)
```

Store the feature context for use by subsequent commands:
```bash
echo "# Feature Context

**Feature Name:** $1
**Description:** $2
**Created:** $(date)
**Command:** frontend-analyze

---

This file stores the feature name and description for use by subsequent commands.
If you run /frontend-plan, /frontend-implement, or /frontend-validate with only the feature name,
they will automatically read the description from this file.
" > .temp/analyze-$1-*/FEATURE_CONTEXT.md
```

## Phase 1: Parallel Pre-Analysis

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

**Both agents run in parallel.** Wait for both to complete before proceeding to consolidation.

## Phase 2: Consolidation

After both agents complete:

1. **Read both outputs** from the agents
2. **Create `PRE_ANALYSIS.md`** in the workspace directory consolidating:
   - Existing Feature Architecture
   - Reusable Code & Solutions Found
   - Recommended Extension Strategy
   - Integration Points Identified

3. **Present results** to user:

```markdown
## Analysis Complete ✅

**Feature Analyzed:** $1
**Addition Requested:** $2

**Key Findings:**
- Feature uses [architecture pattern]
- Found [N] existing files/patterns
- Recommended solution: [approach]
- Integration point: [where to add code]

**Deliverable:** `.temp/analyze-$1-*/PRE_ANALYSIS.md`

**Next Step:**
Review the analysis, then run:
```bash
/frontend-plan "$1" "$2"
```

## Success Criteria

- [x] All files related to "$1" identified
- [x] Data flow through feature understood
- [x] Architectural patterns documented
- [x] Reusable code/solutions found
- [x] PRE_ANALYSIS.md created and comprehensive
- [x] Clear handoff to planning phase

## Execution Notes

**Remember:**
- Use `code-scout` agent (subagent_type: "code-scout") for codebase analysis
- Use `documentation-researcher` agent (subagent_type: "documentation-researcher") for solution research
- Both agents run in parallel (spawn with separate Task tool calls in one message)
- code-scout creates PRE_ANALYSIS.md with architecture findings
- documentation-researcher creates research report with solution recommendations
- Consolidate both findings into comprehensive analysis
- Present clear summary to user before next phase

**Agent Files:**
- code-scout: /Users/natedamstra/.claude/agents/code-scout.md
- documentation-researcher: /Users/natedamstra/.claude/agents/documentation-researcher.md

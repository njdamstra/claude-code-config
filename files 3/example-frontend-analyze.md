# Refactored Frontend Add Workflow: Practical Implementation

This document shows how to refactor your `frontend-add.md` into 4 focused, production-ready slash commands.

---

## Architecture Overview

```
Instead of:
/frontend-add [feature] [what-to-add]  ❌ (tries to do everything, fails at agent spawning)

Use:
/frontend-analyze [feature] [what-to-add]    → Phase 0-1
/frontend-plan [feature] [what-to-add]       → Phase 2
/frontend-implement [feature] [what-to-add]  → Phase 3
/frontend-validate [feature] [what-to-add]   → Phase 4
```

Each command is **focused, testable, and respects Claude Code's actual capabilities**.

---

## Command 1: `/frontend-analyze.md` (Phase 0-1)

Save this as `.claude/commands/frontend-analyze.md`

```yaml
---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(echo:*), Bash(cat:*), Bash(grep:*), Bash(git:*), Read, Write, Edit, TodoWrite, TodoRead, Task, WebSearch, WebFetch
argument-hint: [feature-name] [what-to-add]
description: Analyze existing frontend feature and identify extension opportunities
model: claude-sonnet-4-5-20250929
---

# Frontend Feature Analysis

**Feature to Analyze:** `$1`
**What to Add:** `$2`

## Phase 0: Initialization

Create analysis workspace:
- Directory: `.temp/analyze-$1-$(date +%s)`
- Clear README documenting analysis goal
- Initialize task tracking

## Phase 1: Parallel Pre-Analysis

You have access to the Task tool. Spawn TWO independent agents in parallel:

### Task 1: Code Scout - Feature Architecture Mapping

```
Task(
  description: "Map feature architecture for $1",
  prompt: """
Task: Analyze existing feature "$1" and map its architecture

MISSION - Map Existing Feature:
1. Find ALL files related to feature "$1":
   - Vue components that implement it (src/components/)
   - Stores/state management (src/stores/)
   - Composables that provide logic (src/composables/)
   - API routes that support it (src/api/)
   - TypeScript types that define it (src/types/)
   - Tests that cover it (tests/)
   
2. Trace the data flow:
   - How data enters the feature
   - Which stores manage state
   - Which composables are composed together
   - Which components consume the data
   - How it connects to the API

3. Document patterns used:
   - Component naming conventions
   - Store organization patterns
   - Composable composition patterns
   - Type definitions used
   - API endpoint patterns

Output Format: Create a structured markdown file with sections for:
- Feature File Map (list all files with descriptions)
- Data Flow Diagram (as markdown list showing connections)
- Architectural Patterns (conventions and patterns observed)
- Extension Points (where new code should connect)

CRITICAL: Be thorough. Explore the entire codebase for files related to "$1".
List every component, store, composable, and API endpoint.
Show how they interconnect.
"""
)
```

### Task 2: Documentation Researcher - VueUse & Existing Solutions

```
Task(
  description: "Research solutions for adding $2",
  prompt: """
Task: Research existing solutions for "$2" functionality

MISSION - Find Reusable Solutions:

1. Search for existing implementations:
   - VueUse composables that provide "$2" or similar
   - npm packages that solve this problem
   - Similar features already in the codebase
   - Common patterns for "$2"

2. For each solution found:
   - Document the solution name and source
   - Explain what it does (70-90% match to "$2"?)
   - Show usage example if available
   - Note any dependencies or compatibility issues

3. Compare approaches:
   - Which solution best matches "$2"?
   - Custom code vs. npm package vs. VueUse?
   - What are the tradeoffs?

Output Format: Create a markdown file with:
- Solutions Found (table: name, source, match %, why/why not)
- Best Recommendation (which approach to use)
- Implementation Examples (code snippets showing usage)
- Dependencies & Compatibility (what's needed)

CRITICAL: Focus on VueUse first - Anthropic recommends checking VueUse 
for composable patterns before building custom solutions.
"""
)
```

Both agents run in parallel. Results are saved to the workspace.

## Phase 1 Consolidation

After both tasks complete:

1. Read both outputs
2. Create `PRE_ANALYSIS.md` consolidating findings:
   - Existing Feature Architecture
   - Reusable Code & Solutions Found
   - Recommended Extension Strategy
   - Integration Points Identified

3. Document current state:
   ```
   ## Analysis Complete ✓
   
   **Feature Analyzed:** $1
   **Addition Requested:** $2
   
   **Key Findings:**
   - Feature uses [architecture pattern]
   - Found [N] existing files/patterns
   - Recommended solution: [approach]
   - Integration point: [where to add code]
   
   **Deliverable:** PRE_ANALYSIS.md
   
   Ready for: /frontend-plan $1 "$2"
   ```

## Success Criteria

- [x] All files related to "$1" identified
- [x] Data flow through feature understood
- [x] Architectural patterns documented
- [x] Reusable code/solutions found
- [x] PRE_ANALYSIS.md created and comprehensive
- [x] Clear handoff to planning phase

## Next Step

After reviewing the analysis, run:
```bash
/frontend-plan "$1" "$2"
```

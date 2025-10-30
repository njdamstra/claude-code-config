---
allowed-tools: Read, Write, Edit, TodoWrite, Task, Glob, Grep, Bash(cat:*), Bash(ls:*)
argument-hint: [feature-name] [what-to-add?]
description: Create minimal-change implementation plan based on pre-analysis
---

# Frontend Feature Implementation Planning

**Feature:** `$1`

## Phase 0: Initialize and Load Context

### Load Feature Description

If `$2` is provided, use it. Otherwise, read from stored FEATURE_CONTEXT.md:

```bash
# Find the most recent analyze workspace for this feature
WORKSPACE=$(ls -td .temp/analyze-$1-* 2>/dev/null | head -1)

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
  echo "  2. Provide description: /frontend-plan \"$1\" \"description\""
  exit 1
fi
```

**Addition:** `$DESCRIPTION` (from $2 or stored context)

## Prerequisites

You must have completed `/frontend-analyze "$1" "$DESCRIPTION"` first (or `/frontend-initiate`).
This command reads the PRE_ANALYSIS.md file created by analysis phase.

## Phase 0: Initialize Planning

### Create Todo List

```json
{
  "todos": [
    {
      "content": "Read PRE_ANALYSIS.md from analyze phase",
      "status": "in_progress",
      "activeForm": "Reading pre-analysis"
    },
    {
      "content": "Spawn problem-decomposer-orchestrator for plan creation",
      "status": "pending",
      "activeForm": "Creating implementation plan"
    },
    {
      "content": "Review and format MASTER_PLAN.md",
      "status": "pending",
      "activeForm": "Reviewing plan"
    },
    {
      "content": "Present plan to user for approval",
      "status": "pending",
      "activeForm": "Presenting plan"
    }
  ]
}
```

## Phase 1: Read Analysis Results

Find and read: `.temp/analyze-$1-*/PRE_ANALYSIS.md` (or most recent workspace)

Understand:
- Existing feature architecture
- Where new code should connect
- Reusable code available
- Recommended extension approach

## Phase 2: Spawn Planning Agent

**Spawn @plan-master agent with mission:**

Use the Task tool to spawn the `plan-master` agent:

```
Task(
  subagent_type: "plan-master",
  description: "Create implementation plan for adding $DESCRIPTION to $1",
  prompt: """
You are creating an implementation plan for adding "$DESCRIPTION" to existing feature "$1".

## Your Task

Read the PRE_ANALYSIS.md file from the analyze phase and create a comprehensive MASTER_PLAN.md that orchestrates specialist agents to implement "$DESCRIPTION" functionality.

## Input Context

**Task Type:** add (extending existing feature)
**Feature:** $1
**Addition:** $DESCRIPTION
**Pre-Analysis Location:** .temp/analyze-$1-*/PRE_ANALYSIS.md

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

# Master Plan: Adding "$DESCRIPTION" to $1

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
- [ ] New "$DESCRIPTION" functionality works
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

## Phase 3: Present Plan for Approval

After the planning agent completes, review MASTER_PLAN.md and present:

```markdown
# Plan Ready for Review ✅

## What I've Created

Based on analysis of feature "$1" and addition "$DESCRIPTION", I've created a comprehensive implementation plan.

## Key Decisions

1. **Extension Strategy**: [Extend existing vs create new]
2. **Minimal Changes**: [Estimated X lines across Y files]
3. **Backward Compatible**: [Yes/No with explanation]
4. **Integration Points**: [How new connects to existing]

## The Plan Phases

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

## Estimated Total Impact

- Files Modified: [N]
- Files Created: [N]
- Lines Added: ~[X]
- Net Change: [Small/Medium/Large]

## Next Steps

**Please review the full plan:**
- File: .temp/analyze-$1-*/MASTER_PLAN.md (or in workspace)

**Once approved, proceed with:**
```bash
/frontend-implement "$1"
```

Note: Description is automatically loaded from FEATURE_CONTEXT.md

⚠️ **IMPORTANT:** Review and approve this plan before implementation!
```

## Success Criteria

- [x] PRE_ANALYSIS.md read and understood
- [x] problem-decomposer-orchestrator agent spawned
- [x] MASTER_PLAN.md created with full structure
- [x] Extension-first approach applied
- [x] Minimal changes identified
- [x] Clear phase breakdown
- [x] Backward compatibility ensured
- [x] Plan presented for user approval
- [x] Clear handoff to implementation phase

## Execution Notes

**Remember:**
- Use `plan-master` agent (subagent_type: "plan-master") for strategic planning
- plan-master is a specialist in orchestrating frontend development tasks
- It focuses on WHAT and WHO, leaving HOW to specialist agents
- Reads PRE_ANALYSIS.md to leverage code-scout findings
- Creates comprehensive MASTER_PLAN.md with phase breakdown
- Assigns appropriate specialist agents to each task
- Defines clear execution order (sequential vs parallel)
- Present plan clearly for user approval before implementation

**Agent File:**
- plan-master: /Users/natedamstra/.claude/agents/plan-master.md

**Key Capabilities:**
- Task breakdown into manageable subtasks
- Agent orchestration and assignment
- Deliverable definition with success criteria
- Context provision for specialist agents
- Risk and dependency management

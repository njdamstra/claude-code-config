# Command 2: `/frontend-plan.md` (Phase 2)

Save this as `.claude/commands/frontend-plan.md`

```yaml
---
allowed-tools: Read, Write, Edit, TodoWrite, TodoRead, Task, Glob
argument-hint: [feature-name] [what-to-add]
description: Create minimal-change implementation plan based on pre-analysis
disable-model-invocation: false
---

# Frontend Feature Implementation Planning

**Feature:** `$1`
**Addition:** `$2`

## Prerequisites

You must have completed `/frontend-analyze "$1" "$2"` first.
This command reads the PRE_ANALYSIS.md file created by analysis phase.

## Phase 2: Create Implementation Plan

### Step 1: Read Analysis Results

Find and read: `.temp/analyze-$1-*/PRE_ANALYSIS.md`

Understand:
- Existing feature architecture
- Where new code should connect
- Reusable code available
- Recommended extension approach

### Step 2: Create Minimal-Change Plan

Your goal: **Extend existing code, don't create new**

Analyze:
1. **Extension-First Opportunities:**
   - Which existing components can accept new props/slots?
   - Which existing stores can accept new actions/getters?
   - Which existing composables can be enhanced?
   - Which npm packages/VueUse composables can be used?

2. **Minimal Changes Strategy:**
   - What's the minimum code needed?
   - What can be reused from existing patterns?
   - What absolutely requires new files?
   - Can we avoid refactoring unrelated code?

3. **Integration Plan:**
   - How does new code connect to existing feature?
   - What's the data flow from existing → new → existing?
   - What types need to be updated?
   - What tests need to be added?

### Step 3: Create MASTER_PLAN.md

Generate a structured plan document:

```markdown
# Master Plan: Adding "$2" to $1

**Date:** [today]
**Based on:** PRE_ANALYSIS.md

## Summary

**What's Being Added:** [Brief description]
**Approach:** [Extension vs. creation]
**Impact:** [Small/Medium/Large change]
**Backward Compatible:** [Yes/No/Optional]

## Phase 1: Foundation (Stores & Composables)

### Task 1.1: Extend Existing Store
**File:** [path to store]
**Changes:**
- Add action: [name] - [purpose]
- Add getter: [name] - [purpose]
- New state field: [name] of type [type]
**Rationale:** Extends existing store rather than creating new

### Task 1.2: Create/Extend Composable
**File:** [path to composable]
**Approach:** [Extend existing or create new]
**Responsibilities:**
- Functionality 1
- Functionality 2
**Dependencies:** VueUse: [composable names], Internal: [other composables]

## Phase 2: Implementation (Components)

### Task 2.1: Extend Existing Component
**File:** [path to component]
**New Props:** [list with types]
**New Slots:** [list]
**New Events:** [list]
**Changes:** [describe what gets added]
**Rationale:** Component-level integration point

### Task 2.2: [Additional component modifications as needed]

## Phase 3: Integration

### Task 3.1: Wire into Existing Feature
**Steps:**
1. Update parent component to pass new props
2. Update store calls to use new actions
3. Add type definitions for new interfaces
4. Ensure data flows correctly

### Task 3.2: Backward Compatibility
- All new props are optional or have defaults ✓
- Existing functionality unchanged ✓
- Existing tests still pass ✓
- No breaking changes to component API ✓

## Phase 4: Quality Assurance

### Task 4.1: Testing
- Create tests for new functionality
- Verify existing tests pass (regression)
- Check type checking passes
- Build succeeds

### Task 4.2: Validation
- Manual testing of new feature
- Manual testing of existing feature (regression)
- Code review for pattern consistency
- Performance impact assessment

## Success Criteria

- [ ] Minimal code changes achieved
- [ ] Backward compatibility maintained
- [ ] Architecture patterns preserved
- [ ] All tests passing
- [ ] New "$2" functionality works
- [ ] Existing $1 feature still works

## Implementation Effort Estimate

- Foundation (Stores/Composables): [N] files, ~[X] lines of code
- Implementation (Components): [N] files, ~[X] lines of code
- Integration: ~[X] lines of code changes
- Testing: ~[X] lines of test code

**Total Estimated Effort:** [Low/Medium/High]
```

### Step 4: Present Plan for Approval

Structure your output like this:

```markdown
# Plan Ready for Review ✓

## What I've Created

Based on analysis of feature "$1" and addition "$2", I've created a comprehensive implementation plan.

## Key Decisions

1. **Extension Strategy**: [Extend existing components/stores/composables rather than create new]
2. **Minimal Changes**: [Estimated X lines changed across Y files]
3. **Backward Compatible**: [Yes, all changes are additive]
4. **Integration Points**: [Component receives new props] → [Store dispatches new action] → [API called]

## The Plan Phases

**Phase 1 - Foundation (15-30 min)**
- Extend Store: Add [N] actions/getters
- Enhance/Create Composable: [description]

**Phase 2 - Implementation (30-45 min)**
- Modify [N] components
- Add new props/slots/logic

**Phase 3 - Integration (15-20 min)**
- Wire components to store
- Update types
- Verify data flow

**Phase 4 - Quality (20-30 min)**
- Add tests for new functionality
- Run regression tests
- Validate backward compatibility

## Estimated Total Impact

- Files Modified: [N]
- Files Created: [N]
- Lines Added: ~[X]
- Lines Removed: ~[X]
- Net Change: ~[X] lines

## Next Steps

**Please review the full plan:**
- File: .temp/analyze-$1-*/MASTER_PLAN.md

**Once approved, I'll proceed with implementation.**

Proceed with implementation? (yes/no)
```

### Step 5: Wait for User Approval

The plan is now ready for human review. The user can:

1. Approve the plan as-is → proceed to implementation
2. Request changes → regenerate specific sections
3. Provide guidance → adjust approach and replan

This creates a natural checkpoint for validation.

## CLAUDE.md Integration Hint

Add this to CLAUDE.md so agents know when to use this command:

```markdown
## Frontend Addition Workflow

### Planning Phase
When you have completed the analysis phase and created PRE_ANALYSIS.md:

1. Create a comprehensive implementation plan
2. Focus on EXTENDING existing code, not creating new
3. Minimize changes to the existing feature
4. Present the plan for user approval
5. Wait for feedback before implementing

Use `/frontend-plan [feature] [addition]` to execute this phase.
```

## Success Criteria

- [x] Plan created based on actual analysis (not guessed)
- [x] Extension-first approach applied
- [x] Minimal changes identified
- [x] Clear phase breakdown
- [x] Backward compatibility assured
- [x] Ready for human approval
- [x] MASTER_PLAN.md created
- [x] Clear handoff to implementation phase

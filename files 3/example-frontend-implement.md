# Command 3: `/frontend-implement.md` (Phase 3)

Save this as `.claude/commands/frontend-implement.md`

```yaml
---
allowed-tools: Read, Write, Edit, MultiEdit, Bash(npm:*), Bash(pnpm:*), Bash(git:*), TodoWrite, TodoRead, Task, Glob
argument-hint: [feature-name] [what-to-add]
description: Execute implementation plan with parallel agent coordination
---

# Frontend Feature Implementation

**Feature:** `$1`
**Addition:** `$2`

## Prerequisites

You must have:
1. Completed `/frontend-analyze "$1" "$2"` → creates PRE_ANALYSIS.md
2. Completed `/frontend-plan "$1" "$2"` → creates MASTER_PLAN.md
3. User approved the MASTER_PLAN.md

## Phase 3: Parallel Implementation

### Initialize Tracking

Create a TODO list to track all implementation tasks:

```
Task: Implementing addition to $1
Status: Starting Phase 3 implementation based on MASTER_PLAN.md
```

### Parallel Agent Coordination

Based on MASTER_PLAN.md, spawn 3-5 parallel agents for different concerns.

**Example for typical feature:**

#### Agent 1: Store/State Management Implementation

```
Task(
  description: "Implement store changes for $2",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 1 section)

Implement store changes:
1. File to modify: [from plan]
2. Actions to add: [list from plan]
   - For each action: implement logic
   - Use existing patterns from the store
   - Ensure type safety
3. Getters to add: [list from plan]
4. State fields to add: [list from plan]

Rules:
- Minimal changes - only add what's needed
- Follow existing naming conventions
- Preserve existing functionality
- Add JSDoc comments
- Use existing utility functions

Success: Store implementation is complete and type-safe.
Output: List what was added.
"""
)
```

#### Agent 2: Composable Implementation

```
Task(
  description: "Implement composable for $2",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 1 section)

Implement or enhance composable:
1. File: [from plan]
2. Approach: [Enhance existing or create new]
3. Functions to add/modify: [list from plan]

Rules:
- Use VueUse composables where appropriate
- Follow reactive pattern from existing composables
- Add TypeScript types
- Document with JSDoc
- Create single responsibility functions

Success: Composable is complete, tested, and ready to use.
Output: List functions added/modified.
"""
)
```

#### Agent 3: Component Implementation

```
Task(
  description: "Implement component changes for $2",
  prompt: """
Read: .temp/analyze-$1-*/MASTER_PLAN.md (Phase 2 section)

Implement component modifications:
1. Files to modify: [from plan]
   For each file:
   - Add new props: [list]
   - Add new slots: [list]
   - Add new event handlers: [list]
   - Add new template elements: [description]

2. Follow existing patterns:
   - Prop naming conventions
   - Event naming conventions
   - Component structure
   - Styling approach

Rules:
- Preserve existing functionality - add, don't remove
- Make new props optional (for backward compatibility)
- Add prop validation/types
- Update component tests
- Follow project's component patterns

Success: Components are modified, functional, and backward compatible.
Output: List components modified and changes.
"""
)
```

#### Agent 4: Integration & Wiring

```
Task(
  description: "Integrate new functionality with existing feature",
  prompt: """
Prerequisite: Agents 1-3 have completed their work.

Integration tasks:
1. Update parent components to use new props
2. Wire component events to store actions
3. Update TypeScript type definitions
4. Verify data flow: existing → new → existing

Checklist:
- [ ] All components receive new props correctly
- [ ] All events dispatch store actions
- [ ] TypeScript shows no errors
- [ ] New functionality integrates seamlessly
- [ ] Backward compatibility maintained

Output: Summary of integration points and verification results.
"""
)
```

#### Agent 5: Testing

```
Task(
  description: "Create and run tests for $2",
  prompt: """
Prerequisite: Implementation agents have completed their work.

Testing tasks:
1. Create tests for new functionality:
   - Test new store actions
   - Test new composable functions
   - Test modified components
   - Test integration between layers

2. Run existing tests (regression):
   - Ensure no existing tests broken
   - Verify original feature still works
   - Check for any new console errors

3. Type check:
   - Run typecheck command
   - Resolve any new type errors

Output: Test results, coverage, any failures.
"""
)
```

### Collect Implementation Reports

Each agent creates a report. Consolidate findings:

```markdown
## Implementation Summary

### Store/State (Agent 1)
✓ Added actions: [list]
✓ Added getters: [list]
✓ Added state: [list]

### Composables (Agent 2)
✓ Enhanced: [file path]
✓ Added functions: [list]

### Components (Agent 3)
✓ Modified: [N] files
✓ Changes: [summary]

### Integration (Agent 4)
✓ Wiring complete
✓ Data flow verified
✓ Type safety confirmed

### Testing (Agent 5)
✓ New tests: [N] created
✓ Existing tests: [all passing]
✓ Type check: [passed]
✓ Build: [successful]

## Files Changed
- [list of files with line counts]

## Backward Compatibility
✓ All changes additive
✓ No breaking changes
✓ Existing tests pass
✓ Default behavior unchanged
```

### Verification Checklist

Before considering implementation complete:

- [x] All store changes implemented
- [x] All composable changes implemented
- [x] All component changes implemented
- [x] Integration verified
- [x] New tests passing
- [x] Existing tests passing (regression)
- [x] Type check passing
- [x] Build successful
- [x] No console errors
- [x] Backward compatible

### Commit Changes

If all verification passes:

```bash
git add -A
git commit -m "feat: add $2 to $1 feature

- Extended store with new actions/getters
- Enhanced composable with new logic
- Modified components to support new functionality
- Added comprehensive tests
- Maintained backward compatibility"
```

## CLAUDE.md Integration Hint

```markdown
## Frontend Implementation Execution

When executing the implementation phase:

1. **Spawn agents in parallel** - up to 5 agents for different concerns
2. **Each agent has clear scope** - store, composable, components, integration, testing
3. **Collect implementation reports** - each agent documents what changed
4. **Verify backward compatibility** - existing tests must pass
5. **Commit with clear message** - document what was added

Implementation agents run in parallel when possible for faster execution.
```

## Success Criteria

- [x] PRE_ANALYSIS.md exists and comprehensive
- [x] MASTER_PLAN.md exists and user approved
- [x] Store changes implemented (if needed)
- [x] Composable changes implemented (if needed)
- [x] Component changes implemented (if needed)
- [x] Integration wiring complete
- [x] New tests passing
- [x] Existing tests passing (regression)
- [x] Type check passing
- [x] Build successful
- [x] Backward compatibility maintained
- [x] Changes committed with clear messages

## Next Step

After implementation completes successfully:
```bash
/frontend-validate "$1" "$2"
```

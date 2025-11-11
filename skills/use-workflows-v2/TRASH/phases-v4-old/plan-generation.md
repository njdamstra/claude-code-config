# Phase 2: Plan Generation

## Overview

Main agent writes the complete implementation plan directly (no subagents).

## Step 1: Structure the Plan

**No subagents spawned** - Main agent writes plan.

Create plan structure based on selected approach and detail level.

### Standard Plan Structure:

```markdown
# [Feature Name] - Quick Implementation Plan

## Problem Summary
[Brief recap from investigation]

## Selected Approach
[Chosen approach with rationale]

## Implementation Steps

### Step 1: [Task Name]
**What:** [What needs to be done]
**Why:** [Why this step is necessary]
**Files:** [Specific files to modify/create]
**Details:** [Implementation notes based on detail level]

### Step 2: [Task Name]
[Same structure]

[Continue for all steps...]

## Dependencies
- [Internal dependencies: what must be done first]
- [External dependencies: packages, APIs, etc.]

## Testing Approach
- [How to test this feature]
- [Manual testing steps]
- [Automated tests needed]

## Success Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Risks & Considerations
- [Potential issues to watch for]
- [Edge cases to handle]

## Estimated Effort
[Small/Medium/Large with hours estimate]
```

## Step 2: Write Implementation Steps

Break down the selected approach into **concrete, actionable steps**.

For each step, include:
- **Clear action** - What exactly needs to be done
- **Specific files** - Which files to modify or create (with full paths)
- **Key logic** - Core logic or patterns to use
- **Dependencies** - What must be done before this step

**Detail level adjustments:**
- **Light:** Just action + files
- **Standard:** Action + files + key logic
- **Detailed:** Action + files + key logic + code snippets

## Step 3: Document Dependencies

List all dependencies:

**Internal (codebase):**
- Which existing components/functions will be used?
- Which files depend on the changes?
- What order must steps be done?

**External (packages):**
- Any new npm packages needed?
- Any API endpoints to integrate with?
- Any environment variables required?

## Step 4: Define Testing Approach

Specify how to test:
- **Manual testing:** Step-by-step testing checklist
- **Automated tests:** What unit/integration tests to write
- **Edge cases:** Specific scenarios to verify

## Step 5: Write to File

Write complete plan to: `{{workspace}}/{{output_dir}}/quick-plan.md`

Ensure the plan is:
- Actionable (each step is clear)
- Complete (covers all aspects of implementation)
- Realistic (effort estimate matches complexity)

## Step 6: Gap Check

Verify:
{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Plan generation has gaps:

[List specific missing elements]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 7: Checkpoint Review

**Present to user:**

{{checkpoint_prompt}}

**Files for review:**
{{#checkpoint_show_files}}
- `{{.}}`
{{/checkpoint_show_files}}

**Ask user:**

What would you like to do next?
{{#checkpoint_options}}
{{index}}. {{value}}
{{/checkpoint_options}}

**Wait for user selection** before proceeding.
{{/checkpoint}}

{{^checkpoint}}
## Step 7: Proceed to Plan Review

Plan generation complete. No checkpoint defined.

Continue directly to Phase 3: Plan Review.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/quick-plan.md` - Complete implementation plan

## Success Criteria

- ✓ Plan is actionable
- ✓ Steps are clear
- ✓ Dependencies documented
- ✓ Testing approach defined
- ✓ Files are specified

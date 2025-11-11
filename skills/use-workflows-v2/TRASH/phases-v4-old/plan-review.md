# Phase 3: Plan Review

## Overview

Interactive review of the generated plan with user feedback and refinement.

## Step 1: Present Plan

**No subagents spawned** - Interactive review.

Read the plan aloud to user (or have them read it):
- Read `{{workspace}}/{{output_dir}}/quick-plan.md`
- Highlight key implementation steps
- Call out dependencies and testing approach

## Step 2: Interactive Q&A

Have conversation with user about the plan:

**Questions to ask:**
- "Does this plan make sense to you?"
- "Are the steps clear enough to follow?"
- "Is anything missing?"
- "Are there steps that need more detail?"
- "Do you foresee any issues with this approach?"
- "Is the estimated effort realistic?"

**Be responsive:**
- Answer questions about specific steps
- Clarify technical details if unclear
- Discuss alternative approaches to specific steps
- Add missing details user identifies

## Step 3: Incorporate Feedback

Based on user feedback, make revisions:

**Common revisions:**
- Add more detail to specific steps
- Clarify technical approach
- Adjust order of steps
- Add missing dependencies
- Expand testing approach
- Update effort estimate

Update `{{workspace}}/{{output_dir}}/quick-plan.md` with revisions.

## Step 4: Confirm Readiness

Once revisions complete, ask:
- "Are you ready to start implementing this plan?"
- "Do you need any clarifications before starting?"
- "Should we adjust anything else?"

## Step 5: Gap Check

Verify:
{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Plan review has gaps:

[List specific issues]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 6: Checkpoint Review

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
## Step 6: Plan Finalized

Plan approved and ready for implementation.

User can now begin coding following the plan.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/quick-plan.md` (revised) - Final approved plan

## Success Criteria

- ✓ User has reviewed complete plan
- ✓ Feedback incorporated
- ✓ User approves plan
- ✓ Ready for implementation
- ✓ Effort estimate confirmed

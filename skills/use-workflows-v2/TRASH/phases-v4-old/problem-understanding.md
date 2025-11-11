# Phase 1: Problem Understanding

## Overview

Interactive conversation with user to understand the problem deeply before any research.

## Step 1: Clarify the Problem

**No subagents spawned** - Direct conversation with user.

Ask clarifying questions to understand:
- **Exact issue or goal:** What exactly needs to be solved or built?
- **Context:** Why is this needed? What prompted this?
- **Success criteria:** How will we know this is solved correctly?
- **Constraints:** Any technical limitations, time constraints, or requirements?
- **Initial assumptions:** What does the user already know or assume?

Document the conversation and create a clear problem statement.

## Step 2: Confirm Understanding

Summarize your understanding of:
1. The problem or goal
2. Success criteria
3. Key constraints
4. Scope (frontend, backend, both)

**Ask user:** "Does this accurately capture what we're trying to accomplish?"

## Step 3: Create Problem Document

Write to: `{{workspace}}/{{output_dir}}/problem.md`

Include:
- Problem statement (1-2 paragraphs)
- Success criteria (bullet points)
- Constraints (bullet points)
- Scope (frontend/backend/both)
- Any user-provided context

## Step 4: Gap Check

Verify:
{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Problem understanding phase has gaps:

[List specific issues]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 5: Checkpoint Review

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
## Step 5: Proceed to Research Phase

Problem understanding complete. No checkpoint defined.

Continue directly to Phase 2: Quick Research.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/problem.md` - Documented problem statement

## Success Criteria

- ✓ Problem clearly defined
- ✓ Success criteria established
- ✓ Constraints documented
- ✓ User confirmed understanding

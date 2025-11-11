# Phase 1: Plan Initialization

## Overview

Confirm chosen approach from investigation and determine plan detail level.

## Step 1: Load Investigation Context

**No subagents spawned** - Main agent loads previous work.

Read from investigation workflow:
- `{{phase_paths.investigation}}/problem.md` - Problem statement
- `{{phase_paths.investigation}}/findings.md` - Research findings
- `{{phase_paths.investigation}}/decision.json` - Selected approach

Summarize for user:
- The problem we're solving
- The approach we selected
- Key files that will be modified

## Step 2: Confirm Approach Still Valid

**Ask user:**
- "Does this approach still make sense?"
- "Has anything changed since investigation?"
- "Are there any new constraints or requirements?"

If changes needed, document them.

## Step 3: Determine Plan Detail Level

**Ask user to choose plan detail level:**

1. **Light** - High-level steps, minimal detail (fastest)
2. **Standard** - Clear steps with key implementation notes (recommended)
3. **Detailed** - Comprehensive with code snippets (most thorough)

Document their choice.

## Step 4: Establish File Location

Confirm where plan should be saved:
- Default: `{{workspace}}/{{output_dir}}/quick-plan.md`
- Custom: User can specify different location

## Step 5: Gap Check

Verify:
{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Plan initialization has issues:

[List specific problems]

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
## Step 6: Proceed to Plan Generation

Initialization complete. No checkpoint defined.

Continue directly to Phase 2: Plan Generation.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- In-memory: Confirmed approach and plan detail level

## Success Criteria

- ✓ Investigation context loaded
- ✓ Approach confirmed valid
- ✓ Plan detail level selected
- ✓ File location established

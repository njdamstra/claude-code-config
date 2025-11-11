# Phase 1: Investigation

## Overview

Investigate and reproduce the bug, gathering all necessary context.

## Step 1: Spawn Investigation Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `thoroughness`: "{{thoroughness}}"
- `description`: "{{description}}"

**Prompt Template:** `{{template_path}}`

**Variables to substitute:**
- `feature_name`: {{feature_name}}
- `scope`: {{scope}}
- `workflow_name`: {{workflow}}

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{description}}",
  prompt="[Rendered template content from {{template_path}}]"
)
```

**Expected Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

## Step 2: Wait for Completion

All {{subagent_count}} agents must complete before proceeding.

## Step 3: Read and Review Outputs

Read all deliverables from `{{workspace}}/{{output_dir}}/`:

{{#deliverables}}
### {{filename}}

**Path:** `{{full_path}}`

**Purpose:** {{description}}

**Validation:**
{{#validation_checks}}
- {{.}}
{{/validation_checks}}

{{#has_template}}
**Output Template:**
```{{template_extension}}
{{template_content}}
```
{{/has_template}}

Use Read tool to examine file and verify criteria above.
{{/deliverables}}

## Step 4: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If All Criteria Pass

Proceed to next phase.

### If Any Criteria Fail

Present to user:

```
Investigation phase complete with gaps:

[List specific unmet criteria]

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
## Step 5: Proceed to Next Phase

Gap check passed. No checkpoint defined.

Continue to next workflow phase.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}

## Success Criteria

- ✓ All {{subagent_count}} subagents completed
- ✓ All deliverables exist and validated
- ✓ Gap check passed (or user approved gaps)
{{#checkpoint}}
- ✓ User approved checkpoint
{{/checkpoint}}

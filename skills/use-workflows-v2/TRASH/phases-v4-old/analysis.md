# Phase 2: Analysis

## Overview

Analyze findings from previous phase to identify root causes or issues.

## Step 1: Spawn Analysis Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `thoroughness`: "{{thoroughness}}"
- `description`: "{{description}}"

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

{{/deliverables}}

## Step 4: Gap Check

Verify criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present options to user and wait for selection.

{{#checkpoint}}
## Step 5: Checkpoint Review

{{checkpoint_prompt}}

**Files for review:**
{{#checkpoint_show_files}}
- `{{.}}`
{{/checkpoint_show_files}}

**Options:**
{{#checkpoint_options}}
{{index}}. {{value}}
{{/checkpoint_options}}

**Wait for user selection.**
{{/checkpoint}}

## Deliverables Summary

{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}

## Success Criteria

- ✓ All {{subagent_count}} subagents completed
- ✓ All deliverables validated
- ✓ Gap check passed
{{#checkpoint}}
- ✓ User approved checkpoint
{{/checkpoint}}

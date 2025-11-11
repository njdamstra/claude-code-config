# Phase 1: Discovery

## Overview

Gather codebase context and identify existing patterns.

## Step 1: Spawn Parallel Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `thoroughness`: "{{thoroughness}}"
- `description`: "{{task_description}}"

**Prompt Template:** `subagents/{{type}}/{{workflow}}.md.tmpl`

**Variables to substitute:**
- `feature_name`: {{feature_name}}
- `scope`: {{scope}}
- `workflow_name`: {{workflow}}

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{task_description}}",
  prompt="[Rendered template content from subagents/{{type}}/{{workflow}}.md.tmpl]"
)
```

**Expected Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

## Step 2: Wait for Completion

All {{subagent_count}} agents must complete before proceeding.

Monitor Task tool status. Once all agents finish executing, verify expected output files exist.

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

### If Any Criteria Fail

Present to user:

```
Discovery phase complete with gaps:

[List specific unmet criteria]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

If user selects retry: Return to Step 1 with refined scope.
If user selects continue: Document gaps and proceed.
If user selects abort: Stop workflow.

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

If user selects "Continue": Proceed to next phase.
If user selects "Repeat": Return to Step 1.
If user selects "Abort": Stop workflow.
{{/checkpoint}}

{{^checkpoint}}
## Step 5: Proceed to Requirements Phase

Gap check passed. No checkpoint defined.

Continue directly to Phase 2: Requirements.
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

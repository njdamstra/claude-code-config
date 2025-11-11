# Phase 3: Solution

## Overview

Design solution approaches based on analysis.

## Step 1: Spawn Solution Design Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `description`: "{{description}}"

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{description}}",
  prompt="[Rendered template from {{template_path}}]"
)
```

**Expected Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

## Step 2: Wait for Completion

All {{subagent_count}} agents must complete.

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

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

{{#checkpoint}}
## Step 5: Checkpoint Review

{{checkpoint_prompt}}

**Files:**
{{#checkpoint_show_files}}
- `{{.}}`
{{/checkpoint_show_files}}

**Options:**
{{#checkpoint_options}}
{{index}}. {{value}}
{{/checkpoint_options}}
{{/checkpoint}}

## Success Criteria

- ✓ All subagents completed
- ✓ Deliverables validated
{{#checkpoint}}
- ✓ User approved
{{/checkpoint}}

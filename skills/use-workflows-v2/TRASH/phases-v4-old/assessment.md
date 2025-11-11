# Phase 1: Assessment

## Overview

Assess current state and identify improvement opportunities.

## Step 1: Spawn Assessment Subagents

Use **Task** tool to spawn agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `description`: "{{description}}"

**Task Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{description}}",
  prompt="[Rendered from {{template_path}}]"
)
```

**Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

## Step 2: Wait for Completion

All {{subagent_count}} agents must complete.

## Step 3: Review Outputs

{{#deliverables}}
### {{filename}}

{{description}}

**Validation:**
{{#validation_checks}}
- {{.}}
{{/validation_checks}}

{{/deliverables}}

## Step 4: Gap Check

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

{{#checkpoint}}
## Step 5: Checkpoint

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

# Phase 2: Codebase Investigation

## Overview

Comprehensive codebase research using specialized subagent to identify patterns, dependencies, and integration points.

## Step 1: Spawn Parallel Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `description`: "{{task_description}}"

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="Comprehensive codebase research for {{feature_name}}",
  prompt="Research codebase for patterns, dependencies, and integration points related to {{feature_name}}. Focus on {{scope}} scope. Identify reusable components, similar implementations, and architectural patterns. Output to {{workspace}}/{{output_dir}}/{{deliverable_filename}}"
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

**Expected content:**
- **patterns**: Array of reusable patterns found (minimum 5)
- **dependencies**: Map of internal dependencies
- **integration_points**: Where this connects to other systems
- **similar_implementations**: Examples of similar features
- **reusability_assessment**: For each pattern, can we REUSE, EXTEND, or CREATE?

{{/deliverables}}

## Step 4: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Codebase investigation complete with gaps:

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
{{/checkpoint}}

{{^checkpoint}}
## Step 5: Proceed to External Research Phase

Codebase investigation complete. No checkpoint defined.

Continue directly to Phase 3: External Research.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}

## Success Criteria

- ✓ All {{subagent_count}} subagents completed
- ✓ At least 5 patterns identified
- ✓ Dependencies mapped
- ✓ Integration points documented
- ✓ All deliverables exist and validated

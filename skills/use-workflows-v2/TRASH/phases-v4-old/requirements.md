# Phase 2: Requirements

## Overview

Define user stories, technical requirements, and edge cases based on discovery findings.

## Context from Previous Phase

Discovery phase identified:
- Read `{{phase_paths.discovery}}/codebase-scan.json` - Existing patterns and reusable components
- Read `{{phase_paths.discovery}}/patterns.json` - Architecture patterns and conventions
- Read `{{phase_paths.discovery}}/dependencies.json` - Integration points

Use these findings to inform requirements that align with existing architecture.

## Step 1: Spawn Parallel Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `thoroughness`: "{{thoroughness}}"
- `description`: "{{task_description}}"

**Context to provide:**
- Discovery findings from Phase 1
- Feature scope: {{scope}}

**Prompt Template:** `subagents/{{type}}/{{workflow}}.md.tmpl`

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{task_description}}",
  prompt="[Rendered template with discovery context]"
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
Requirements phase complete with gaps:

[List specific unmet criteria]

What would you like to do?
{{#gap_options}}
{{index}}. {{.}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 5: Checkpoint Review

**Present to user:**

{{prompt}}

**Files for review:**
{{#show_files}}
- `{{.}}`
{{/show_files}}

**Ask user:**

What would you like to do next?
{{#options}}
{{index}}. {{.}}
{{/options}}

**Wait for user selection** before proceeding.
{{/checkpoint}}

{{^checkpoint}}
## Step 5: Proceed to Design Phase

Gap check passed. No checkpoint defined.

Continue directly to Phase 3: Design.
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
- ✓ Requirements align with discovery findings
{{#checkpoint}}
- ✓ User approved checkpoint
{{/checkpoint}}

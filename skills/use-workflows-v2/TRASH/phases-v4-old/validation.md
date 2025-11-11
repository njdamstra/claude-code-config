# Phase 5: Validation

## Overview

Validate the feasibility and completeness of the implementation plan before finalizing.

## Context from Previous Phase

**Synthesis document:**
- Read `{{phase_paths.synthesis}}/synthesis.md` - Comprehensive implementation plan

Validators will check this plan for:
- Technical feasibility
- Completeness (no missing requirements)
- Risk assessment accuracy
- Realistic effort estimates

## Step 1: Spawn Parallel Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `thoroughness`: "{{thoroughness}}"
- `description`: "{{task_description}}"

**Context to provide:**
- Synthesis plan from Phase 4
- All previous phase outputs for cross-reference

**Prompt Template:** `subagents/{{type}}/{{workflow}}.md.tmpl`

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{task_description}}",
  prompt="[Rendered template with synthesis context]"
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
Validation phase complete with concerns:

[List specific issues found by validators]

What would you like to do?
{{#gap_options}}
{{index}}. {{.}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 5: Final Checkpoint

**Present to user:**

{{prompt}}

**Validation Summary:**
- Feasibility: [Pass/Fail with explanation from feasibility-validator]
- Completeness: [Pass/Fail with explanation from completeness-checker]
- Critical Issues: [List any blockers]
- Warnings: [List any concerns]

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

If user selects "Finalize": Plan is approved and ready for implementation.
If user selects "Revise": Return to appropriate phase for revisions.
If user selects "Abort": Stop workflow.
{{/checkpoint}}

{{^checkpoint}}
## Step 5: Plan Finalized

Validation passed. Plan is ready for implementation.

Proceed to finalization.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}

## Success Criteria

- ✓ All {{subagent_count}} validators completed
- ✓ All deliverables exist and validated
- ✓ No critical feasibility issues
- ✓ Plan completeness verified
{{#checkpoint}}
- ✓ User gave final approval
{{/checkpoint}}

## Workflow Complete

If validation passes and user approves, the workflow is complete. The synthesis plan is ready for implementation.

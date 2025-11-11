# Phase: Introspection

## Overview

Validate assumptions made during previous phases by identifying implicit assumptions and using code-qa agent to answer detailed questions about the codebase.

## Step 1: Identify Assumptions

**Main agent task:** Review the approaches generated in the previous phase and explicitly list all assumptions made.

Common assumptions to check:
- "No existing solution for this problem"
- "Feature X doesn't exist in the codebase"
- "We need to build component Y from scratch"
- "Pattern Z isn't being used anywhere"
- "Integration with system A hasn't been done before"

**Output your assumption analysis:**

```markdown
## Assumptions Made

1. **Assumption:** [What you assumed]
   - **Basis:** [Why you made this assumption]
   - **Question to validate:** [Specific question for code-qa]
   - **Impact if wrong:** [How this changes the approach]

2. **Assumption:** [Next assumption]
   ...
```

## Step 2: Spawn code-qa Subagent

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `description`: "{{task_description}}"

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="Answer detailed questions about codebase to validate assumptions for {{feature_name}}",
  prompt="Answer the following questions about the codebase with maximum accuracy and source verification:

[LIST YOUR ASSUMPTION QUESTIONS HERE - from Step 1 analysis]

For each question:
1. Search exhaustively for relevant code
2. Provide file:line citations for all claims
3. Rate confidence (High/Medium/Low)
4. Note if assumption is CONFIRMED or INVALIDATED

Output to {{workspace}}/{{output_dir}}/{{deliverable_filename}}"
)
```

**Expected Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

## Step 3: Wait for Completion

All {{subagent_count}} agents must complete before proceeding.

Monitor Task tool status. Once all agents finish executing, verify expected output files exist.

## Step 4: Read and Review Outputs

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
- **questions**: Array of questions asked
- **answers**: Detailed answers with file:line citations
- **confidence**: Rating for each answer (High/Medium/Low)
- **assumptions_validated**: Which assumptions were CONFIRMED
- **assumptions_invalidated**: Which assumptions were WRONG
- **revised_understanding**: How this changes our approaches

{{/deliverables}}

## Step 5: Revise Approaches Based on Findings

**Main agent task:** Update approaches.json based on introspection findings.

For each invalidated assumption:
1. Read the actual implementation found by code-qa
2. Determine if we can REUSE existing code
3. Update approach to leverage what already exists
4. Recalculate complexity/effort estimates

**Output:** Updated `{{workspace}}/{{output_dir}}/approaches-revised.json`

```json
{
  "original_approaches": [...],
  "introspection_findings": {
    "assumptions_confirmed": [...],
    "assumptions_invalidated": [
      {
        "assumption": "What we assumed",
        "reality": "What actually exists",
        "impact": "How this changes our approach"
      }
    ]
  },
  "revised_approaches": [
    {
      "approach_name": "Updated approach name",
      "changes_from_original": "What changed based on introspection",
      "reusable_code_found": ["path/to/existing.ts"],
      "new_complexity": "High → Medium (reduced)",
      ...
    }
  ],
  "recommendation": "Which revised approach to pursue"
}
```

## Step 6: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Introspection complete with gaps:

[List specific unmet criteria]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

If user selects retry: Return to Step 1 with more thorough analysis.
If user selects continue: Document gaps and proceed.
If user selects abort: Stop workflow.

{{#checkpoint}}
## Step 7: Checkpoint Review

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
## Step 7: Proceed to Next Phase

Introspection complete. No checkpoint defined.

Continue with revised approaches based on validated assumptions.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}
- `{{workspace}}/{{output_dir}}/approaches-revised.json` - Updated approaches based on introspection

## Success Criteria

- ✓ All assumptions explicitly identified
- ✓ code-qa agent answered all questions with citations
- ✓ Confidence ratings provided for all answers
- ✓ Approaches revised based on findings
- ✓ Reusable code leveraged where discovered

# Phase 3: Decision Finalization

## Overview

Interactive discussion with user to select approach and finalize the investigation.

## Step 1: Present Findings

Show user the findings from Phase 2:
- Read `{{workspace}}/{{output_dir}}/findings.md` aloud
- Highlight key differences between approaches
- Share your recommendation (if you have one)

## Step 2: Discuss Approaches

Have interactive conversation with user:

**Questions to ask:**
- Which approach resonates with you?
- Do you have concerns about any approach?
- Is there a combination of approaches that might work?
- Are there factors I haven't considered?
- What's your risk tolerance? (prefer safe vs innovative)
- What's your time constraint? (need fast vs can take time)

**Be responsive:**
- Answer questions about specific approaches
- Clarify technical details
- Discuss tradeoffs
- Consider hybrid approaches if user suggests

## Step 3: Document Decision

Once user selects an approach (or hybrid), create decision document.

Write to: `{{workspace}}/{{output_dir}}/decision.json`

Format:
```json
{
  "selected_approach": "Approach [1/2/3] or Hybrid",
  "approach_name": "[Name from findings]",
  "rationale": "[Why user selected this - their reasoning]",
  "modifications": "[Any tweaks to the approach discussed]",
  "confidence_level": "high|medium|low",
  "next_steps": [
    "Move to quick-plan workflow",
    "[Any other immediate actions]"
  ],
  "concerns": "[Any remaining concerns or risks to track]"
}
```

## Step 4: Summarize Next Steps

Clearly state:
1. Which approach was selected
2. Why it was selected
3. What happens next (move to planning)
4. Any open questions to address in planning

## Step 5: Gap Check

Verify:
{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Decision finalization has gaps:

[List specific issues]

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
## Step 6: Investigation Complete

Decision finalized. Ready to move to planning workflow.

User can now invoke: `quick-plan` workflow
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/decision.json` - Selected approach with rationale

## Success Criteria

- ✓ Approach selected
- ✓ Decision documented
- ✓ User is confident in direction
- ✓ Ready for planning phase

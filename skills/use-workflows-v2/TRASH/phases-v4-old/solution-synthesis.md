# Phase 4: Solution Synthesis

## Overview

Synthesize codebase and external research to generate 2-3 feasible approaches with detailed comparison.

## Step 1: Review All Research

**No subagents spawned** - Main agent synthesizes.

Review findings from previous phases:
- `{{problem_understanding_path}}/problem.md` - Problem statement
- `{{codebase_investigation_path}}/codebase-analysis.json` - Codebase research
- `{{external_research_path}}/research.md` - External research

Identify key insights that inform solution approaches.

## Step 2: Generate Approaches

Create **2-3 distinct, feasible approaches** to solve the problem.

Each approach should be meaningfully different, not just minor variations.

For each approach, document:

### Approach Structure:
```markdown
## Approach [N]: [Descriptive Name]

### Description
[2-3 paragraph explanation of this approach]
[What makes it unique?]
[How does it solve the problem?]

### Technical Details
- **Architecture:** [High-level architecture]
- **Key components:** [What gets built/modified]
- **Data flow:** [How data moves through system]
- **State management:** [How state is handled]

### Pros
- [Advantage 1]: [Why this is good]
- [Advantage 2]: [Why this is good]
- [Advantage 3]: [Why this is good]

### Cons
- [Disadvantage 1]: [Why this is challenging]
- [Disadvantage 2]: [Why this is challenging]
- [Disadvantage 3]: [Why this is challenging]

### Risk Assessment
- **Technical Risk:** [Low/Medium/High] - [Explanation]
- **Complexity Risk:** [Low/Medium/High] - [Explanation]
- **Timeline Risk:** [Low/Medium/High] - [Explanation]
- **Maintenance Risk:** [Low/Medium/High] - [Explanation]

### Complexity Rating
**Overall:** [Simple/Moderate/Complex]
**Reasoning:** [Why this complexity level]

### Estimated Effort
**Timeline:** [Days/Weeks]
**Breakdown:**
- Research/Planning: [hours]
- Implementation: [hours]
- Testing: [hours]
- Documentation: [hours]

### Confidence Level
[High/Medium/Low] - [Why this confidence level]
```

## Step 3: Create Comparison Matrix

Synthesize approaches into comparison matrix.

Write to: `{{workspace}}/{{output_dir}}/approaches.json`

Format:
```json
{
  "approaches": [
    {
      "id": 1,
      "name": "[Approach name]",
      "description": "[Brief description]",
      "pros": ["[pro1]", "[pro2]"],
      "cons": ["[con1]", "[con2]"],
      "technical_risk": "low|medium|high",
      "complexity_risk": "low|medium|high",
      "timeline_risk": "low|medium|high",
      "overall_complexity": "simple|moderate|complex",
      "estimated_days": 3,
      "confidence_level": "high|medium|low",
      "key_files": ["file1.ts", "file2.vue"],
      "recommended": false
    }
  ],
  "recommendation": {
    "approach_id": 2,
    "rationale": "[Why this one is recommended]"
  }
}
```

## Step 4: Present to User

Summarize approaches for user:
- Read through each approach
- Highlight key differences
- Share your recommendation (with reasoning)
- Ask which approach resonates with them

**Interactive discussion:**
- Answer questions about each approach
- Clarify technical details
- Discuss tradeoffs
- Consider hybrid approaches if user suggests

## Step 5: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Solution synthesis has gaps:

[List specific unmet criteria]

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

**Document user's choice:**
- Which approach(es) selected
- Any modifications discussed
- Rationale for selection
{{/checkpoint}}

{{^checkpoint}}
## Step 6: Proceed to Approach Refinement

User has selected approach. No checkpoint defined.

Continue directly to Phase 5: Approach Refinement.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/approaches.json` - Detailed approach comparison

## Success Criteria

- ✓ 2-3 approaches generated
- ✓ Each has pros, cons, risks, complexity
- ✓ User has discussed and selected approach
- ✓ Decision documented

# Phase 2: Quick Research

## Overview

Rapid research using codebase search and optional external research to identify 2-3 feasible approaches.

## Step 1: Codebase Search (Main Agent)

**No subagents spawned** - Main agent uses `code-researcher` skill directly.

Search codebase for:
- **Existing patterns:** Has this been done before? Similar features?
- **Reusable components:** What can be reused vs built new?
- **Integration points:** Where does this connect to existing code?
- **Dependencies:** What does this depend on? What depends on this?

Use Grep, Glob, and Read tools to explore relevant files quickly.

## Step 2: External Research (Optional)

**If needed**, use `external-research` skill to:
- Search for best practices
- Find framework-specific patterns
- Identify common gotchas

Keep research focused - spend max 5 minutes.

## Step 3: Generate Approaches

Based on codebase + optional external research, generate **2-3 feasible approaches**.

For each approach, document:
- **Description:** What is this approach? (2-3 sentences)
- **Pros:** What are the advantages? (2-3 bullet points)
- **Cons:** What are the drawbacks? (2-3 bullet points)
- **Complexity:** Simple | Moderate | Complex
- **Key files to modify:** List 3-5 specific files
- **Estimated effort:** Small (< 2 hrs) | Medium (2-6 hrs) | Large (> 6 hrs)

## Step 4: Write Findings

Write to: `{{workspace}}/{{output_dir}}/findings.md`

Format:
```markdown
# Quick Investigation Findings

## Problem Summary
[Brief recap from Phase 1]

## Codebase Context
- Relevant patterns found: [list]
- Reusable components: [list]
- Integration points: [list]

## Proposed Approaches

### Approach 1: [Name]
**Description:** [2-3 sentences]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

**Complexity:** [Simple/Moderate/Complex]
**Key files:** [list 3-5 files]
**Estimated effort:** [Small/Medium/Large]

### Approach 2: [Name]
[Same structure]

### Approach 3: [Name] (optional)
[Same structure]

## Recommendation
[Your initial recommendation with brief justification]
```

## Step 5: Gap Check

Verify:
{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Quick research phase has gaps:

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
{{/checkpoint}}

{{^checkpoint}}
## Step 6: Proceed to Decision Phase

Research complete. No checkpoint defined.

Continue directly to Phase 3: Decision Finalization.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/findings.md` - 2-3 approaches with analysis

## Success Criteria

- ✓ 2-3 approaches identified
- ✓ Each approach has pros/cons
- ✓ Key files identified
- ✓ Complexity assessed

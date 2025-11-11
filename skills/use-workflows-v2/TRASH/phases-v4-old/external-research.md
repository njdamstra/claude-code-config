# Phase 3: External Research

## Overview

Search external sources for best practices, framework patterns, and community solutions.

## Step 1: Invoke External Research Skill

**No subagents spawned** - Main agent uses `external-research` skill.

Use the skill to research:
1. **Best practices** for this type of feature
2. **Framework-specific patterns** (Vue, Astro, etc.)
3. **Community solutions** from GitHub, Stack Overflow
4. **Known gotchas** and common pitfalls
5. **Official documentation** (if relevant)

**Skill invocation:**
```bash
# Main agent internally calls external-research skill
# Focus: [problem domain from Phase 1]
# Scope: [frontend/backend/both]
```

## Step 2: Compile Research Findings

Organize findings into structured document:

**Categories to include:**
- **Best Practices**: Industry-standard approaches
- **Framework Patterns**: Specific to our tech stack (Vue 3, Astro, Appwrite, etc.)
- **Similar Solutions**: How others solved this
- **Gotchas**: Common mistakes to avoid
- **Official Docs**: Relevant documentation sections

## Step 3: Write Research Report

Write to: `{{workspace}}/{{output_dir}}/research.md`

Format:
```markdown
# External Research Report

## Problem Context
[Brief recap from Phase 1]

## Best Practices

### [Practice 1 Name]
**Source:** [URL or reference]
**Summary:** [Key points]
**Relevance:** [How this applies to our case]

### [Practice 2 Name]
[Same structure]

## Framework Patterns

### [Pattern 1 Name]
**Framework:** [Vue 3 / Astro / etc.]
**Pattern:** [Description]
**Example:** [Code snippet or reference]
**Application:** [How we'd use this]

### [Pattern 2 Name]
[Same structure]

## Community Solutions

### [Solution 1]
**Source:** [GitHub repo / Stack Overflow / etc.]
**Approach:** [Summary]
**Pros:** [What's good]
**Cons:** [What's lacking]

### [Solution 2]
[Same structure]

## Gotchas & Pitfalls
- [Gotcha 1]: [Description and how to avoid]
- [Gotcha 2]: [Description and how to avoid]

## Official Documentation References
- [Doc 1]: [Link and key points]
- [Doc 2]: [Link and key points]

## Research Summary
[1-2 paragraph summary of key takeaways]
```

## Step 4: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
External research has gaps:

[List specific missing elements]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

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
## Step 5: Proceed to Solution Synthesis

External research complete. No checkpoint defined.

Continue directly to Phase 4: Solution Synthesis.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/research.md` - External research findings

## Success Criteria

- ✓ Best practices documented
- ✓ Framework patterns identified
- ✓ Community solutions reviewed
- ✓ Gotchas documented
- ✓ Research report complete

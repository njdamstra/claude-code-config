# Phase 7: Finalization

## Overview

Consolidate all artifacts into final plan document and prepare for implementation.

## Step 1: Load All Artifacts

**No subagents spawned** - Main agent consolidates.

Read all outputs from previous phases:
- `{{phase_paths.investigation}}/problem.md`
- `{{phase_paths.investigation}}/refined-approach.md`
- `{{phase_paths.requirements}}/requirements.json`
- `{{phase_paths.design}}/architecture.json`
- `{{phase_paths.implementation}}/implementation.md`
- `{{phase_paths.testing}}/testing.md`
- `{{phase_paths.quality-review}}/checklist.md`

## Step 2: Generate Final Plan Document

Create comprehensive plan document consolidating all information.

Write to: `{{workspace}}/{{output_dir}}/PLAN.md`

Format:
```markdown
# [Feature Name] - Implementation Plan

**Created:** [Date]
**Workflow:** plan-writing-workflow
**Scope:** [frontend/backend/both]

---

## Executive Summary

### Problem Statement
[From problem.md - 1-2 paragraphs]

### Selected Approach
[From refined-approach.md - brief summary]

### Estimated Effort
**Timeline:** [X days/weeks]
**Complexity:** [Simple/Moderate/Complex]

---

## Requirements

### User Stories
[From requirements.json]

### Technical Requirements
[From requirements.json]

### Dependencies
**Internal:**
- [List internal dependencies]

**External:**
- [List npm packages with versions]

### Schema Changes
[From requirements.json if applicable]

---

## Technical Design

### Architecture Overview
[From architecture.json]

### Component Structure
[From architecture.json]

### Data Flow
[From architecture.json]

### State Management
[From architecture.json]

### API Contracts
[From architecture.json if applicable]

---

## Implementation Plan

### Implementation Order
[From implementation.md]

### Files to Create
[From implementation.md]

### Files to Modify
[From implementation.md]

### Code Snippets
[Key snippets from implementation.md]

---

## Testing Strategy

### Unit Tests
[From testing.md]

### Integration Tests
[From testing.md]

### Manual Testing
[From testing.md]

### Edge Cases
[From testing.md]

---

## Quality Checklist

[Full checklist from checklist.md]

---

## Success Criteria

Implementation is complete when:
- [ ] All files created/modified
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] Manual testing checklist complete
- [ ] Quality checklist complete
- [ ] Code reviewed and approved

---

## References

**Investigation artifacts:**
- Problem: `{{phase_paths.investigation}}/problem.md`
- Research: `{{phase_paths.investigation}}/findings.md`
- Approach: `{{phase_paths.investigation}}/refined-approach.md`

**Planning artifacts:**
- Requirements: `{{phase_paths.requirements}}/requirements.json`
- Architecture: `{{phase_paths.design}}/architecture.json`
- Implementation: `{{phase_paths.implementation}}/implementation.md`
- Testing: `{{phase_paths.testing}}/testing.md`
- Checklist: `{{phase_paths.quality-review}}/checklist.md`

---

**Status:** ✅ Ready for Implementation
```

## Step 3: Create Metadata File

Write to: `{{workspace}}/{{output_dir}}/metadata.json`

Format:
```json
{
  "feature_name": "{{feature_name}}",
  "workflow": "plan-writing-workflow",
  "scope": "{{scope}}",
  "created_date": "{{date}}",
  "estimated_days": 5,
  "complexity": "moderate",
  "status": "ready_for_implementation",
  "artifacts": {
    "problem": "problem.md",
    "requirements": "requirements.json",
    "architecture": "architecture.json",
    "implementation": "implementation.md",
    "testing": "testing.md",
    "checklist": "checklist.md",
    "final_plan": "PLAN.md"
  }
}
```

## Step 4: Summarize Plan

Present concise summary to user:

```
Plan finalized for: [Feature Name]

Key highlights:
- Approach: [Brief description]
- Estimated effort: [X days/weeks]
- Files to create: [N]
- Files to modify: [N]
- Test cases: [N unit + N integration]
- Quality checks: [N items]

All artifacts saved to: {{workspace}}/

Next steps:
1. Review PLAN.md for complete details
2. Begin implementation following plan
3. Check off quality checklist as you go
4. Run tests as you complete each component
```

## Step 5: Archive Artifacts

Optionally copy artifacts to permanent location:
- Copy `{{workspace}}/` to project planning directory
- Add to version control if desired
- Link related documents

## Step 6: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Finalization has gaps:

[List specific issues]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

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
## Step 7: Planning Complete

Plan finalized. Ready to begin implementation.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/PLAN.md` - Complete consolidated plan
- `{{workspace}}/{{output_dir}}/metadata.json` - Plan metadata

## Success Criteria

- ✓ All artifacts consolidated into final plan
- ✓ Plan is comprehensive and actionable
- ✓ Metadata captured
- ✓ User has clear next steps
- ✓ Ready for implementation

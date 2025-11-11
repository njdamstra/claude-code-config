# Phase 6: Quality Review

## Overview

Create comprehensive quality checklist covering TypeScript, duplication, performance, and security.

## Step 1: Review All Artifacts

**No subagents spawned** - Main agent creates checklist.

Review all outputs from previous phases:
- `{{workspace}}/{{output_dir}}/requirements.json`
- `{{workspace}}/{{output_dir}}/architecture.json`
- `{{workspace}}/{{output_dir}}/implementation.md`
- `{{workspace}}/{{output_dir}}/testing.md`

## Step 2: Create Quality Checklist

Generate checklist covering all quality dimensions:

### TypeScript Compliance
- [ ] All types explicitly defined (no implicit any)
- [ ] Strict mode enabled and passing
- [ ] No type assertions (as) unless absolutely necessary
- [ ] Zod schemas match TypeScript types
- [ ] Return types specified for all functions

### Code Duplication
- [ ] Checked for similar patterns in codebase (reuse > recreate)
- [ ] Common logic extracted to utilities/composables
- [ ] No copy-paste code blocks
- [ ] Shared components identified and used

### Performance Considerations
- [ ] No unnecessary re-renders (Vue computed vs methods)
- [ ] Large lists use virtual scrolling if needed
- [ ] Images optimized and lazy-loaded
- [ ] API calls batched/debounced where appropriate
- [ ] Bundle size impact assessed

### Security Review
- [ ] Input validation with Zod schemas
- [ ] XSS prevention (proper escaping)
- [ ] Authentication checks before sensitive operations
- [ ] Authorization/permissions verified
- [ ] No secrets in client-side code
- [ ] API endpoints have rate limiting (if applicable)

### Accessibility (a11y)
- [ ] ARIA labels on interactive elements
- [ ] Keyboard navigation works
- [ ] Focus management proper
- [ ] Color contrast meets WCAG standards
- [ ] Screen reader tested (or planned)

### SSR Safety (Astro/Vue)
- [ ] No browser APIs called during SSR
- [ ] Client directives used correctly (client:load, client:visible)
- [ ] `useMounted` used for client-only code
- [ ] No hydration mismatches

### Code Quality
- [ ] Consistent naming conventions
- [ ] Functions are single-purpose
- [ ] No magic numbers/strings (use constants)
- [ ] Error handling present
- [ ] Logging appropriate (not excessive)

### Documentation
- [ ] Complex logic has comments
- [ ] API contracts documented
- [ ] README updated (if applicable)
- [ ] Component props documented

## Step 3: Add Project-Specific Checks

Based on the feature, add custom quality checks:

### [Feature-Specific Check Category]
- [ ] [Custom check 1]
- [ ] [Custom check 2]

## Step 4: Present Plan to User

Review complete plan with user:
- Summarize requirements
- Explain architecture decisions
- Walk through implementation steps
- Highlight testing approach
- Review quality checklist

**Ask user:**
- "Does this plan cover everything we discussed?"
- "Are there any concerns or gaps?"
- "Is the level of detail appropriate?"
- "Should we add/modify anything?"

## Step 5: Incorporate Feedback

Based on user feedback, update any of the artifacts:
- Revise requirements if needed
- Adjust architecture if concerns raised
- Add detail to implementation if requested
- Expand testing if needed
- Add to quality checklist

## Step 6: Write Quality Checklist Document

Write to: `{{workspace}}/{{output_dir}}/checklist.md`

Format:
```markdown
# Quality Checklist

## TypeScript Compliance
[List of TypeScript checks]

## Code Duplication
[List of duplication checks]

## Performance Considerations
[List of performance checks]

## Security Review
[List of security checks]

## Accessibility (a11y)
[List of accessibility checks]

## SSR Safety
[List of SSR checks]

## Code Quality
[List of code quality checks]

## Documentation
[List of documentation checks]

## Feature-Specific Checks
[Custom checks for this feature]

## Pre-Implementation Review
- [ ] All plan artifacts reviewed
- [ ] User approved plan
- [ ] No blocking concerns
- [ ] Ready to begin implementation
```

## Step 7: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Quality review has gaps:

[List specific issues]

What would you like to do?
{{#gap_options}}
{{index}}. {{value}}
{{/gap_options}}
```

**Wait for user selection** before proceeding.

{{#checkpoint}}
## Step 8: Checkpoint Review

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
## Step 8: Proceed to Finalization

Quality review complete and approved. No checkpoint defined.

Continue directly to Phase 7: Finalization.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/checklist.md` - Comprehensive quality checklist

## Success Criteria

- ✓ All quality dimensions covered
- ✓ Feature-specific checks added
- ✓ User reviewed complete plan
- ✓ Feedback incorporated
- ✓ Ready for finalization

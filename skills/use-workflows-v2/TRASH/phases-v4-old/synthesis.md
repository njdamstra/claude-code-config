# Phase 4: Synthesis

## Overview

Synthesize all findings from discovery, requirements, and design phases into a comprehensive implementation plan.

**Note:** This phase has no subagents. You (the main agent) will perform synthesis directly.

## Step 1: Read All Phase Outputs

Read and review all deliverables from previous phases:

**From Discovery (Phase 1):**
- `{{phase_paths.discovery}}/codebase-scan.json` - Existing patterns and components
- `{{phase_paths.discovery}}/patterns.json` - Architecture patterns
- `{{phase_paths.discovery}}/dependencies.json` - Integration points

**From Requirements (Phase 2):**
- `{{phase_paths.requirements}}/user-stories.md` - User stories
- `{{phase_paths.requirements}}/technical-requirements.json` - Technical requirements
- `{{phase_paths.requirements}}/edge-cases.json` - Edge cases

**From Design (Phase 3):**
- `{{phase_paths.design}}/architecture.md` - System architecture
- `{{phase_paths.design}}/implementation-sequence.md` - Implementation steps
- `{{phase_paths.design}}/test-strategy.md` - Testing approach

## Step 2: Synthesize Findings

Combine all findings into a cohesive narrative. Consider:

1. **Context** - What problem are we solving? (from requirements)
2. **Existing System** - What patterns and components exist? (from discovery)
3. **Solution Design** - How will we implement this? (from design)
4. **Implementation Path** - What's the step-by-step approach? (from design)
5. **Quality Assurance** - How will we test and validate? (from design)
6. **Edge Cases** - What special scenarios must we handle? (from requirements)

## Step 3: Generate Synthesis Document

Create `{{workspace}}/{{output_dir}}/synthesis.md` with the following structure:

```markdown
# {{feature_name}} Implementation Plan

## Executive Summary
[1-2 paragraphs summarizing the feature and approach]

## Context
**Problem Statement:**
[What user need does this address?]

**Success Criteria:**
[How will we know when this is complete?]

## Existing System Analysis
**Reusable Components:**
[List from discovery - what can we reuse?]

**Architecture Patterns:**
[List from discovery - what patterns should we follow?]

**Integration Points:**
[List from discovery - what systems does this touch?]

## Requirements Overview
**User Stories:**
[Summary of key user stories from requirements phase]

**Technical Requirements:**
[Key technical constraints and requirements]

**Edge Cases:**
[Critical edge cases to handle]

## Solution Design
**Architecture:**
[High-level architecture from design phase]

**Component Structure:**
[Key components and their relationships]

**Data Flow:**
[How data flows through the system]

## Implementation Sequence
[Ordered list of implementation steps from design phase]

1. Step 1: [Description]
2. Step 2: [Description]
...

## Testing Strategy
[Summary of testing approach from design phase]

**Unit Tests:**
[What to unit test]

**Integration Tests:**
[What to integration test]

**E2E Tests:**
[What to test end-to-end]

## Risk Assessment
**Known Risks:**
- [Risk 1 and mitigation]
- [Risk 2 and mitigation]

## Estimated Effort
[Time estimate based on complexity and scope]

## Success Metrics
[How will we measure success?]
```

## Step 4: Self-Review

Review your synthesis document for:

- [ ] All phases (discovery, requirements, design) are represented
- [ ] Implementation steps are actionable and sequenced
- [ ] No contradictions between phases
- [ ] Edge cases are addressed
- [ ] Testing strategy is comprehensive
- [ ] Architecture aligns with existing patterns

## Step 5: Proceed to Validation

Once synthesis is complete, proceed to Phase 5: Validation.

## Deliverables Summary

This phase produces:
- `{{workspace}}/{{output_dir}}/synthesis.md` - Comprehensive implementation plan

## Success Criteria

- ✓ Synthesis document created
- ✓ All previous phases integrated
- ✓ Implementation path is clear
- ✓ Self-review passed

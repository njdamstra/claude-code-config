# Multi-Agent Orchestration Patterns for Planning

## Overview

This resource provides detailed patterns for coordinating multiple subagents in parallel and serial workflows for implementation planning, refactoring, debugging, and improvement tasks.

## Core Coordination Patterns

### Pattern 1: Parallel Independent Research

**When to Use:** Multiple subagents can work simultaneously without dependencies

**Structure:**
Lead Agent:
  ├─→ Subagent A (independent task)
  ├─→ Subagent B (independent task)
  ├─→ Subagent C (independent task)
  └─→ Subagent D (independent task)

Lead Agent: Collect & Synthesize

**Example (Phase 1 Discovery - New Feature):**
I'll spawn 4 discovery subagents in parallel:

1. Use the codebase-scanner subagent to scan for existing patterns
   Output: .temp/phase1-discovery/codebase-scan.json

2. Use the dependency-mapper subagent to map integration points
   Output: .temp/phase1-discovery/dependency-map.json

3. Use the pattern-analyzer subagent to identify reusable patterns
   Output: .temp/phase1-discovery/pattern-analysis.json

4. Use the frontend-scanner subagent to analyze Vue components
   Output: .temp/phase1-discovery/frontend-analysis.json

**Benefits:**
- Maximum parallelization
- Reduced total execution time
- Independent context windows
- Clear separation of concerns

### Pattern 2: Sequential Dependent Analysis

**When to Use:** Later subagents need outputs from earlier subagents

**Structure:**
Lead Agent → Subagent A (produces artifact)
Lead Agent reads artifact
Lead Agent → Subagent B (uses artifact from A)
Lead Agent → Subagent C (uses artifacts from A & B)

**Example (Refactoring Workflow):**
Step 1: Use code-smell-detector to identify refactoring opportunities
        Wait for .temp/phase1-analysis/code-smells.json

Step 2: Read code-smells.json, prioritize high-impact smells

Step 3: Use refactoring-sequencer subagent on prioritized smells
        Output: .temp/phase2-planning/refactor-sequence.md

**Benefits:**
- Proper data flow between agents
- Each agent has necessary context
- Reduced redundant work

### Pattern 3: Fork-Join Synthesis

**When to Use:** Multiple parallel analyses need synthesis

**Structure:**
Lead Agent:
  ├─→ Subagent A → artifact-a
  ├─→ Subagent B → artifact-b
  └─→ Subagent C → artifact-c

Lead Agent: Read all artifacts
Lead Agent: Synthesize into unified plan

**Example (Phase 2 Design → Phase 3 Implementation Planning):**
Phase 2 (Parallel):
1. architecture-designer → system architecture
2. integration-planner → integration strategies
3. test-strategy-planner → testing approach

Phase 3 (Lead Agent Synthesis):
1. Read all Phase 2 outputs
2. Combine into comprehensive implementation plan
3. Ensure consistency across design decisions
4. Sequence tasks based on dependencies

**Benefits:**
- Maintains coherent plan narrative
- Lead agent ensures consistency
- Opportunities to resolve conflicts

### Pattern 4: Conditional Branching

**When to Use:** Different subagents needed based on feature flags

**Structure:**
Lead Agent: Analyze flags (--frontend, --backend, --both)

If --frontend:
  ├─→ frontend-scanner
  └─→ ui-designer

If --backend:
  ├─→ backend-scanner
  └─→ api-designer

If --both:
  ├─→ frontend-scanner
  ├─→ backend-scanner
  ├─→ ui-designer
  ├─→ api-designer
  └─→ integration-planner

**Example:**
Feature: "user-dashboard" with --both flag

Discovery Phase:
1. codebase-scanner (always)
2. pattern-analyzer (always)
3. dependency-mapper (always)
4. frontend-scanner (--frontend or --both)
5. backend-scanner (--backend or --both)

Design Phase:
1. architecture-designer (always)
2. ui-designer (--frontend or --both)
3. api-designer (--backend or --both)
4. integration-planner (for --both)

**Benefits:**
- Efficient resource usage
- Targeted research
- Faster completion for focused features

## Delegation Best Practices

### 1. Explicit Task Specification

**Good:**
Use the codebase-scanner subagent to:
1. Find all files related to [feature area]
2. Identify existing patterns and conventions
3. Map reusable components and utilities
4. Output to .temp/phase1-discovery/codebase-scan.json

**Bad:**
Use codebase-scanner to scan the code

### 2. Output Location Specification

Always specify exact output paths:
Output to: .temp/phase1-discovery/codebase-scan.json

This enables:
- Later phases to read findings
- Debugging via .temp/ inspection
- Verification of completion

### 3. Context Passing Between Phases

**Pattern:**
Phase 1: Subagents write to .temp/phase1-discovery/

Lead Agent: Read Phase 1 outputs
Lead Agent: Summarize findings in delegation to Phase 2

Phase 2: Use the architecture-designer subagent to design system
         architecture based on patterns identified in
         .temp/phase1-discovery/pattern-analysis.json

### 4. Batching vs. Splitting

**Batch when:**
- Tasks are independent
- Similar tool usage
- Can run in parallel

**Split when:**
- Sequential dependencies
- Different tool requirements
- Context window concerns

**Example Decision:**

Batch these (Phase 1 Discovery):
- codebase-scanner
- pattern-analyzer
- dependency-mapper

Split these (can't parallel):
- Phase 1 discovery
- Phase 2 design (depends on Phase 1)
- Phase 3 implementation planning (depends on Phase 2)

## Workflow-Specific Patterns

### New Feature Planning Pattern

**Phase Sequence:**
1. **Scope Definition** (Lead Agent) → .temp/scope.md
2. **Discovery** (3-5 parallel subagents) → .temp/phase1-discovery/
3. **Requirements Analysis** (3-4 parallel subagents) → .temp/phase2-requirements/
4. **Design** (3-5 parallel subagents) → .temp/phase3-design/
5. **Synthesis** (Lead Agent) → plan.md
6. **Validation** (2 parallel subagents) → .temp/phase-validation/
7. **Finalize** (Lead Agent) → metadata.json

**Key Pattern:** Each phase builds on artifacts from previous phases

### Refactoring Planning Pattern

**Phase Sequence:**
1. **Analysis** (4 parallel subagents) → .temp/phase1-analysis/
   - code-smell-detector
   - complexity-analyzer
   - duplication-finder
   - test-coverage-checker

2. **Planning** (3 parallel subagents) → .temp/phase2-planning/
   - refactoring-sequencer (reads analysis artifacts)
   - technique-selector
   - test-planner

3. **Synthesis** → plan.md
4. **Validation** (2 subagents) → safety checks
5. **Finalize** → metadata.json

**Key Pattern:** Heavy upfront analysis, incremental planning

### Debugging Planning Pattern

**Phase Sequence:**
1. **Reproduction** (3 parallel subagents) → .temp/phase1-reproduction/
   - bug-reproducer
   - environment-analyzer
   - log-analyzer

2. **Root Cause** (3 parallel subagents) → .temp/phase2-root-cause/
   - hypothesis-generator (reads reproduction artifacts)
   - code-tracer
   - dependency-checker

3. **Solution** (2 parallel subagents) → .temp/phase3-solution/
   - fix-designer
   - regression-checker

4. **Synthesis** → plan.md
5. **Validation** → approach verification
6. **Finalize** → metadata.json

**Key Pattern:** Systematic investigation before solution design

## Verification Integration

### Parallel Validation Pattern

Phase 3: Plan Synthesis Complete
  ↓
Lead Agent: Spawn validation subagents

Parallel:
├─→ feasibility-validator → feasibility-report.json
├─→ completeness-checker → completeness-check.json
└─→ approach-validator → approach-validation.json (conditional)

Lead Agent: Collect validation results
Lead Agent: Address critical issues
Lead Agent: Finalize plan

### Critical Issue Workflow

If critical issues found:
  1. Read validation report
  2. Identify specific problems
  3. Apply fixes directly to plan.md
  4. Document fixes in metadata
  5. Proceed to finalization

If warnings only:
  1. Document in metadata
  2. Proceed to finalization
  3. Note for implementation phase

## Gap Checks Between Phases

### After Discovery Phase

THINK HARD:
1. **Coverage**
   - All relevant code discovered?
   - Patterns identified?
   - Dependencies mapped?

2. **Completeness**
   - Missing any critical areas?
   - Need additional investigation?

Decision: Proceed to Requirements/Design or spawn additional agents?

### After Design Phase

THINK HARD:
1. **Architecture Clarity**
   - Design well-defined?
   - Decisions documented?
   - Integration points clear?

2. **Actionability**
   - Implementation steps clear?
   - Dependencies identified?
   - Risks understood?

Decision: Ready for implementation planning?

### After Validation Phase

THINK HARD:
1. **Feasibility**
   - Plan realistic?
   - Risks acceptable?
   - Effort reasonable?

2. **Completeness**
   - All sections populated?
   - Success criteria defined?
   - Verification strategy included?

Decision: Finalize or revise?

## Token Optimization Strategies

### 1. Progressive Loading

Phase 1: Load only filenames and imports
Phase 2: Load full file contents only for relevant files
Phase 3: Load specific sections for validation

### 2. Subagent Scope Limiting

Each subagent focuses on ONE specific task:
- codebase-scanner: ONLY pattern discovery
- dependency-mapper: ONLY dependency analysis
- architecture-designer: ONLY system design

Prevents context bloat in individual subagents.

### 3. Summary Passing

Instead of passing full artifacts between phases:
# Bad (bloats context)
Lead Agent passes entire codebase-scan.json to design phase

# Good (summarizes)
Lead Agent: "23 reusable components found: [key list]"
Lead Agent: "For detailed analysis, read .temp/phase1-discovery/codebase-scan.json"

## Error Handling

### Subagent Failure Recovery

If subagent produces incomplete output:
  1. Check .temp/ for partial results
  2. Determine what's missing
  3. Re-invoke subagent with clarified instructions

If subagent output format wrong:
  1. Read actual output
  2. Re-invoke with explicit format example

### Missing Context Recovery

If design subagent lacks context:
  1. Read relevant Phase 1 outputs
  2. Summarize for subagent
  3. Re-invoke with context included

## Performance Metrics

### Expected Subagent Counts by Workflow

**New Feature:**
- Simple feature: 8-10 subagents
- Moderate feature: 10-15 subagents
- Complex feature: 15-20 subagents

**Refactoring:**
- Small refactor: 6-8 subagents
- Medium refactor: 8-12 subagents
- Large refactor: 12-15 subagents

**Debugging:**
- Simple bug: 6-8 subagents
- Complex bug: 8-12 subagents

**Improving:**
- Targeted improvement: 6-9 subagents
- Comprehensive improvement: 9-12 subagents

**Quick:**
- Quick task: 2-4 subagents

### Bottleneck Identification

Monitor for:
- Subagents waiting for dependencies
- Redundant file reads
- Repeated pattern analysis
- Excessive validation passes

Optimize by:
- Better parallel batching
- Caching common reads
- Targeted validation

---

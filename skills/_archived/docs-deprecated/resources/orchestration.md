

# Multi-Agent Orchestration Patterns

## Overview

This resource provides detailed patterns for coordinating multiple subagents in parallel and serial workflows for documentation research.

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

**Example (Phase 1 Discovery):**
I'll spawn 4 discovery subagents in parallel:

1. Use the dependency-mapper subagent to build the dependency graph
   Output: .temp/phase1-discovery/dependency-map.json

2. Use the file-scanner subagent to identify all relevant files
   Output: .temp/phase1-discovery/file-scan.json

3. Use the pattern-analyzer subagent to extract patterns
   Output: .temp/phase1-discovery/pattern-analysis.json

4. Use the component-analyzer subagent to analyze Vue components
   Output: .temp/phase1-discovery/component-analysis.json

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

**Example:**
Step 1: Use file-scanner to identify files
        Wait for .temp/phase1-discovery/file-scan.json

Step 2: Read file-scan.json, identify high-confidence files

Step 3: Use code-deepdive subagent on files from Step 2
        Output: .temp/phase2-analysis/code-deepdive.md

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
Lead Agent: Synthesize into unified output

**Example (Phase 2 → Phase 3):**
Phase 2 (Parallel):
1. code-deepdive → implementation details
2. architecture-synthesizer → system architecture
3. usage-pattern-extractor → usage examples

Phase 3 (Lead Agent Synthesis):
1. Read all Phase 2 outputs
2. Combine into comprehensive documentation
3. Ensure consistency across findings
4. Fill gaps identified during synthesis

**Benefits:**
- Maintains coherent narrative
- Lead agent ensures consistency
- Opportunities to resolve conflicts

### Pattern 4: Conditional Branching

**When to Use:** Different subagents needed based on topic flags

**Structure:**
Lead Agent: Analyze flags (--frontend, --backend, --both)

If --frontend:
  ├─→ component-analyzer
  └─→ frontend-specific patterns

If --backend:
  ├─→ backend-analyzer
  └─→ serverless-function patterns

If --both:
  ├─→ component-analyzer
  ├─→ backend-analyzer
  └─→ integration-point analysis

**Example:**
Topic: "api-integration" with --both flag

Discovery Phase:
1. dependency-mapper (always)
2. file-scanner (always)
3. pattern-analyzer (always)
4. component-analyzer (--frontend or --both)
5. backend-analyzer (--backend or --both)

Analysis Phase:
1. code-deepdive on frontend components
2. code-deepdive on serverless functions
3. architecture-synthesizer for full integration flow

**Benefits:**
- Efficient resource usage
- Targeted research
- Faster completion for focused topics

## Delegation Best Practices

### 1. Explicit Task Specification

**Good:**
Use the dependency-mapper subagent to:
1. Find all files related to [topic]
2. Scan imports/exports in each file
3. Build complete dependency graph
4. Output to .temp/phase1-discovery/dependency-map.json

**Bad:**
Use dependency-mapper to check dependencies

### 2. Output Location Specification

Always specify exact output paths:
Output to: .temp/phase1-discovery/dependency-map.json

This enables:
- Later phases to read findings
- Debugging via .temp/ inspection
- Verification of completion

### 3. Context Passing Between Phases

**Pattern:**
Phase 1: Subagents write to .temp/phase1-discovery/

Lead Agent: Read Phase 1 outputs
Lead Agent: Summarize findings in delegation to Phase 2

Phase 2: Use the code-deepdive subagent to analyze files
         identified in .temp/phase1-discovery/file-scan.json
         with confidence > 0.8

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

Batch these (Phase 1):
- dependency-mapper
- file-scanner  
- pattern-analyzer

Split these (can't parallel):
- Phase 1 discovery
- Phase 2 analysis (depends on Phase 1)
- Phase 3 synthesis (depends on Phase 2)

## Verification Integration

### Parallel Verification Pattern

Phase 3: Documentation Complete
  ↓
Lead Agent: Spawn verification subagents

Parallel:
├─→ accuracy-verifier → accuracy-report.json
├─→ completeness-checker → completeness-check.json
└─→ example-validator → example-validation.json

Lead Agent: Collect verification results
Lead Agent: Apply critical fixes
Lead Agent: Finalize documentation

### Critical Fix Workflow

If critical issues found:
  1. Read verification report
  2. Identify specific errors
  3. Apply fixes directly to main.md
  4. Document fixes in metadata
  5. Proceed to finalization

If warnings only:
  1. Document in metadata
  2. Proceed to finalization
  3. Note for future updates

## Token Optimization Strategies

### 1. Progressive Loading

Phase 1: Load only filenames and imports
Phase 2: Load full file contents only for high-confidence files
Phase 3: Load specific sections for verification

### 2. Subagent Scope Limiting

Each subagent focuses on ONE specific task:
- dependency-mapper: ONLY dependencies
- file-scanner: ONLY file identification
- pattern-analyzer: ONLY pattern extraction

Prevents context bloat in individual subagents.

### 3. Summary Passing

Instead of passing full artifacts between phases:
# Bad (bloats context)
Lead Agent passes entire file-scan.json to analysis phase

# Good (summarizes)
Lead Agent: "12 high-confidence files found: [list]"
Lead Agent: "For detailed list, read .temp/phase1-discovery/file-scan.json"

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

If analysis subagent lacks context:
  1. Read relevant Phase 1 outputs
  2. Summarize for subagent
  3. Re-invoke with context included

## Workflow Checkpoints

### After Each Phase

THINK HARD:
1. Did all subagents complete?
2. Are outputs in expected locations?
3. Is output quality sufficient?
4. Any missing information?
5. Ready for next phase?

Decision: Continue or adjust

### Before Finalization

VERIFY:
1. All phases complete
2. All verification passed
3. Critical issues resolved
4. Documentation comprehensive
5. Metadata accurate

Decision: Finalize or iterate

## Advanced Patterns

### Conditional Verification

If documentation contains code examples:
  └─→ example-validator
Else:
  Skip example validation

### Iterative Refinement

Phase 4: Verification finds gaps
Lead Agent: Identify specific gap
Lead Agent: Spawn targeted analysis subagent
Lead Agent: Update documentation
Lead Agent: Re-verify specific section

### Cross-Topic Linking

If related topics exist:
  1. Read related topic metadata
  2. Identify shared components
  3. Add cross-references
  4. Update both metadata.json files

## Performance Metrics

### Expected Subagent Counts

- **Simple topic**: 8-12 subagents
  - 3-4 discovery
  - 3-4 analysis  
  - 2-3 verification

- **Moderate topic**: 12-16 subagents
  - 4-5 discovery
  - 4-5 analysis
  - 3-4 verification

- **Complex topic**: 16-20 subagents
  - 5-7 discovery
  - 5-7 analysis
  - 3-5 verification

### Bottleneck Identification

Monitor for:
- Subagents waiting for dependencies
- Redundant file reads
- Repeated pattern analysis
- Excessive verification passes

Optimize by:
- Better parallel batching
- Caching common reads
- Targeted verification

---


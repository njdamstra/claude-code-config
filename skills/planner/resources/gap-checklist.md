# Phase Completion Verification Checklist for Planning

Use these checklists after each phase to ensure quality and actionability of implementation plans.

## Phase 0: Strategic Planning

### Planning Completeness
- [ ] Feature/task scope clearly defined (in-scope, out-scope, boundaries)
- [ ] Complexity assessed (Simple/Moderate/Complex)
- [ ] Workflow type selected (new-feature, refactoring, debugging, improving, quick)
- [ ] Subagent strategy defined for each phase
- [ ] Success criteria listed with measurable outcomes
- [ ] Resource estimation documented
- [ ] Plan written to `.temp/plan.md` or `.temp/scope.md`

### Quality Indicators
✓ Scope boundaries are specific, not vague
✓ Subagent count matches complexity and workflow type
✓ Success criteria are measurable and testable
✓ Conditional subagents identified based on flags (--frontend, --backend, --both)

### Red Flags
⚠ Scope too broad (will exceed planning capacity)
⚠ Too few subagents for complex feature
⚠ Success criteria are subjective or untestable
⚠ No clear stopping point or done criteria defined

---

## Phase 1: Discovery/Analysis/Reproduction

**Varies by workflow:**
- **New Feature:** Discovery phase (codebase scanning)
- **Refactoring:** Analysis phase (code quality assessment)
- **Debugging:** Reproduction phase (bug documentation)
- **Improving:** Assessment phase (baseline profiling)
- **Quick:** Discovery phase (file location)

### Discovery Completeness (New Feature, Quick)
- [ ] Codebase scan completed with existing patterns
- [ ] Pattern analysis extracted reusable components
- [ ] Dependency map created with integration points
- [ ] Frontend analysis done (if --frontend or --both)
- [ ] Backend analysis done (if --backend or --both)
- [ ] All outputs in `.temp/phase1-discovery/`

### Analysis Completeness (Refactoring)
- [ ] Code smells identified and categorized
- [ ] Complexity metrics captured
- [ ] Duplication analysis completed
- [ ] Test coverage assessed
- [ ] All outputs in `.temp/phase1-analysis/`

### Reproduction Completeness (Debugging)
- [ ] Bug reproduction steps documented
- [ ] Environment context captured
- [ ] Log analysis completed
- [ ] State inspection done (if stateful bug)
- [ ] All outputs in `.temp/phase1-reproduction/`

### Assessment Completeness (Improving)
- [ ] Baseline measurements captured
- [ ] Bottlenecks identified
- [ ] Optimization opportunities scanned
- [ ] UX issues analyzed (if applicable)
- [ ] All outputs in `.temp/phase1-assessment/`

### Pattern Coverage Check
- [ ] Existing components/patterns identified
- [ ] Naming conventions documented
- [ ] Architecture patterns recognized
- [ ] Reusable code opportunities noted

### Quality Indicators
✓ Existing patterns well-documented
✓ Integration points clearly identified
✓ No large gaps in codebase understanding
✓ Conditional subagents executed when needed

### Red Flags
⚠ Missing key existing components (scope may be wrong)
⚠ No clear patterns identified (planning may be premature)
⚠ Integration points unclear (missing context)
⚠ Skipped conditional analysis when needed

### Gap Resolution
If gaps found:
1. Identify what's missing (patterns, context, integration points)
2. Determine cause (wrong search terms, boundary issues, missing files)
3. Spawn targeted subagent to fill gap OR adjust scope
4. Re-verify coverage before proceeding

---

## Phase 2: Requirements/Design/Dependencies/Root-Cause/Findings

**Varies by workflow:**
- **New Feature:** Requirements analysis
- **Refactoring:** Planning phase (refactor strategy)
- **Debugging:** Root-cause analysis
- **Improving:** Planning phase (optimization strategy)
- **Quick:** (Skipped)

### Requirements Completeness (New Feature)
- [ ] User stories written with INVEST criteria
- [ ] Technical requirements documented
- [ ] Edge cases identified
- [ ] Integration planning done (if multi-component)
- [ ] All outputs in `.temp/phase2-requirements/`

### Refactoring Planning Completeness
- [ ] Refactoring sequence defined
- [ ] Refactoring techniques selected
- [ ] Test plan created
- [ ] Risk mapping done (if high-risk)
- [ ] All outputs in `.temp/phase2-planning/`

### Root-Cause Completeness (Debugging)
- [ ] Hypotheses generated and prioritized
- [ ] Code tracing completed
- [ ] Dependencies verified
- [ ] Data flow analyzed (if data bug)
- [ ] Timing analyzed (if timing bug)
- [ ] All outputs in `.temp/phase2-root-cause/`

### Improvement Planning Completeness
- [ ] Optimization design created
- [ ] Impact estimated
- [ ] Verification approach planned
- [ ] Rollout strategy defined (if user-facing)
- [ ] All outputs in `.temp/phase2-planning/`

### Quality Indicators
✓ User stories are complete and testable (new feature)
✓ Refactor steps are incremental and safe (refactoring)
✓ Root cause clearly identified with evidence (debugging)
✓ Optimization approach is measurable (improving)

### Red Flags
⚠ User stories missing acceptance criteria (new feature)
⚠ Refactor steps too large or risky (refactoring)
⚠ Root cause still unclear or multiple hypotheses (debugging)
⚠ Optimization lacks baseline/target metrics (improving)

### Gap Resolution
If gaps found:
1. Compare Phase 2 outputs to Phase 1 discoveries
2. Identify missing requirements, designs, or analysis
3. Spawn targeted subagent for gaps
4. Update outputs and re-verify

---

## Phase 3: Design/Implementation-Planning/Solution

**Varies by workflow:**
- **New Feature:** Design phase (architecture, implementation sequence)
- **Refactoring:** (Combined with Phase 2)
- **Debugging:** Solution phase (fix design)
- **Improving:** (Combined with Phase 2)
- **Quick:** (Skipped)

### Design Completeness (New Feature)
- [ ] Architecture designed with component structure
- [ ] Implementation sequence defined with dependencies
- [ ] Test strategy planned
- [ ] UI design created (if --frontend or --both)
- [ ] API design created (if --backend or --both)
- [ ] All outputs in `.temp/phase3-design/`

### Solution Completeness (Debugging)
- [ ] Fix approach designed
- [ ] Regression checks planned
- [ ] Alternative approaches evaluated (if applicable)
- [ ] All outputs in `.temp/phase3-solution/`

### Architecture Check
- [ ] Component relationships clear
- [ ] Data flow documented
- [ ] Integration points defined
- [ ] State management strategy defined

### Implementation Sequence Check
- [ ] Tasks ordered by dependencies
- [ ] Each task is actionable
- [ ] Effort estimates reasonable
- [ ] Testing integrated into sequence

### Quality Indicators
✓ Architecture is clear and viable
✓ Implementation steps are concrete and actionable
✓ Dependencies correctly sequenced
✓ Test strategy comprehensive

### Red Flags
⚠ Architecture is vague or incomplete
⚠ Implementation steps too large (not incremental)
⚠ Circular dependencies in task sequence
⚠ Testing strategy missing or inadequate

### Gap Resolution
If gaps found:
1. Re-read Phase 1-2 outputs for context
2. Identify architectural uncertainties
3. Spawn architecture-designer or integration-planner
4. Update design and re-verify

---

## Phase 4: Synthesis

**All workflows:** Synthesis phase (generate plan.md)

### Plan Completeness
- [ ] Overview/Summary section written
- [ ] Background/Context documented (requirements, current state)
- [ ] Architecture/Design section complete
- [ ] Implementation steps documented
- [ ] Task breakdown with estimates
- [ ] Risk analysis included
- [ ] Verification/Testing strategy defined
- [ ] Success criteria listed
- [ ] Dependencies documented (internal and external)
- [ ] Related plans linked (if applicable)

### Structure Check
- [ ] Follows workflow-specific template structure
- [ ] All required sections present
- [ ] Sections in logical order
- [ ] No orphaned subsections

### Content Quality Check
- [ ] All claims supported by Phase 1-3 research
- [ ] Task descriptions are actionable
- [ ] File paths are correct
- [ ] No placeholder text (like "TODO", "TBD")
- [ ] Estimates are realistic

### Actionability Check
- [ ] Tasks have clear done criteria
- [ ] Dependencies explicitly stated
- [ ] Risks have mitigation strategies
- [ ] Verification steps are specific

### Quality Indicators
✓ Plan flows logically from context to implementation
✓ Technical depth matches feature complexity
✓ All Phase 1-3 findings incorporated
✓ No contradictions between sections

### Red Flags
⚠ Tasks are vague or non-actionable
⚠ Missing integration between components
⚠ Estimates feel arbitrary (not research-based)
⚠ Key Phase 2-3 findings not mentioned

### Gap Resolution
If gaps found:
1. Re-read Phase 1-3 outputs
2. Identify what research exists but wasn't incorporated
3. Update plan to include missing information
4. Ensure consistency across all sections

---

## Phase 5: Validation

**Workflows:** new-feature (required), refactoring (required), debugging (required), improving (required), quick (skipped)

### Validation Completeness
- [ ] Feasibility validation completed
- [ ] Completeness check completed
- [ ] Approach validation done (debugging/improving)
- [ ] Estimate review done (if --estimate flag)
- [ ] All outputs in `.temp/phase-validation/`

### Feasibility Check
- [ ] Critical feasibility issues: _____
- [ ] Warnings: _____
- [ ] Architecture viable
- [ ] Implementation steps realistic
- [ ] Effort estimates reasonable
- [ ] Risks acceptable

### Completeness Check
- [ ] All sections populated
- [ ] Task breakdown complete
- [ ] Success criteria defined
- [ ] Verification strategy included
- [ ] Dependencies documented

### Approach Validation Check
- [ ] Solution addresses root cause (debugging)
- [ ] Refactor steps safe and incremental (refactoring)
- [ ] Optimization measurable (improving)
- [ ] Risks identified and mitigated

### Quality Indicators
✓ Zero critical issues
✓ Fewer than 3 warnings
✓ Plan is complete and actionable
✓ Feasibility confirmed

### Red Flags
⚠ Any critical issues (MUST fix before finalization)
⚠ 3+ warnings (significant concerns)
⚠ Major sections incomplete
⚠ Feasibility questionable

### Gap Resolution
If critical issues found:
1. Apply fixes immediately to plan.md
2. Re-run validation
3. Ensure no new issues introduced

If warnings found:
1. Assess severity (can proceed vs. must fix)
2. Fix high-priority warnings
3. Document remaining warnings in metadata

---

## Phase 6: Finalization

### Finalization Completeness
- [ ] All critical issues resolved
- [ ] Major warnings resolved
- [ ] Remaining warnings documented in metadata
- [ ] metadata.json created with accurate stats
- [ ] archives/ directory created
- [ ] `.temp/` directory preserved
- [ ] User report generated

### Metadata Accuracy Check
- [ ] Feature name correct
- [ ] Workflow type accurate
- [ ] Date accurate
- [ ] Estimated effort matches plan
- [ ] Complexity assessment matches plan
- [ ] Subagent count accurate
- [ ] Stack array includes all technologies

### Output Structure Check
[project]/.claude/plans/[feature]/
├── plan.md              ✓ Present and complete
├── metadata.json        ✓ Present and accurate
├── .temp/              ✓ Present with all phase outputs
│   ├── scope.md or plan.md  ✓
│   ├── phase1-*/            ✓
│   ├── phase2-*/            ✓ (if applicable)
│   ├── phase3-*/            ✓ (if applicable)
│   └── phase-validation/    ✓ (if applicable)
└── archives/           ✓ Directory created

### Quality Indicators
✓ All validation issues addressed
✓ Metadata accurately reflects work done
✓ Directory structure complete
✓ User report is informative and accurate

### Red Flags
⚠ Critical issues still present (validation failed)
⚠ Metadata contradicts actual content
⚠ Missing .temp/ outputs (research not preserved)
⚠ Inaccurate user report (misleading)

---

## Universal Quality Checks

These apply to all phases:

### Output File Existence
- [ ] Expected output files exist at specified paths
- [ ] Files are not empty
- [ ] Files contain properly formatted content (JSON is valid, Markdown is well-formed)

### Format Consistency
- [ ] JSON outputs use consistent structure
- [ ] Markdown outputs use consistent heading levels
- [ ] File paths use consistent format (absolute vs. relative)

### Content Accuracy
- [ ] No hallucinated files or functions
- [ ] All references are verifiable in codebase
- [ ] No contradictions within output
- [ ] No outdated information

### Actionability
- [ ] Tasks are concrete and specific
- [ ] Dependencies are explicit
- [ ] Verification criteria clear
- [ ] Risks have mitigation strategies

---

## Decision Framework

After each phase, use this decision tree:

Phase Complete?
├─ YES
│  ├─ Quality checks passed?
│  │  ├─ YES → Proceed to next phase
│  │  └─ NO → Identify and fix gaps
│  └─ Quality checks available?
│     ├─ YES → Run quality checks
│     └─ NO → Define quality criteria first
└─ NO
   ├─ Subagents still running? → Wait for completion
   ├─ Subagents failed? → Analyze and retry
   └─ Missing outputs? → Identify and generate

### Gap Severity Levels

**Critical (MUST fix before proceeding):**
- Missing required outputs
- Contradictory information
- Hallucinated files/functions
- Invalid JSON/data structures
- Infeasible architecture or approach

**High (SHOULD fix before proceeding):**
- Major planning gaps (missing requirements, incomplete design)
- Multiple warnings (3+)
- Missing integration strategies
- Incomplete task breakdown
- Unrealistic estimates

**Medium (CAN proceed, address if time permits):**
- Minor planning gaps
- 1-2 warnings
- Missing edge case planning
- Incomplete risk mitigation

**Low (Document and defer):**
- Stylistic inconsistencies
- Minor redundancies
- Future enhancement opportunities
- Related plan links incomplete

---

## Workflow-Specific Checkpoints

### New Feature Workflow
Key gates:
1. After Discovery: Existing patterns identified?
2. After Requirements: User stories complete?
3. After Design: Architecture viable?
4. After Validation: Plan actionable?

### Refactoring Workflow
Key gates:
1. After Analysis: Code smells clear? Tests adequate?
2. After Planning: Steps incremental? Safety validated?
3. After Validation: Scope reasonable? Risks acceptable?

### Debugging Workflow
Key gates:
1. After Reproduction: Bug reproducible consistently?
2. After Root-Cause: Root cause identified with evidence?
3. After Solution: Fix addresses root cause? Regressions checked?
4. After Validation: Approach sound? Risks acceptable?

### Improving Workflow
Key gates:
1. After Assessment: Baseline captured? Bottlenecks identified?
2. After Planning: Optimization measurable? Impact estimated?
3. After Validation: ROI positive? Risks acceptable?

### Quick Workflow
Key gates:
1. After Discovery: Relevant files located? Dependencies clear?
2. After Synthesis: Plan actionable and concise?

---



# Phase Completion Verification Checklist

Use these checklists after each phase to ensure quality and completeness.

## Phase 0: Strategic Planning

### Planning Completeness
- [ ] Topic scope clearly defined (in-scope, out-scope, boundaries)
- [ ] Complexity assessed (Simple/Moderate/Complex)
- [ ] Subagent strategy defined for each phase
- [ ] Success criteria listed with checkboxes
- [ ] Resource estimation documented
- [ ] Plan written to `.temp/plan.md`

### Quality Indicators
✓ Scope boundaries are specific, not vague
✓ Subagent count matches complexity (8-12 for simple, 12-16 for moderate, 16-20 for complex)
✓ Success criteria are measurable
✓ Conditional subagents identified based on flags

### Red Flags
⚠ Scope too broad (will exceed token limits)
⚠ Too few subagents for complex topic
⚠ Success criteria are subjective
⚠ No clear stopping point defined

---

## Phase 1: Discovery

### Discovery Completeness
- [ ] Dependency map created with all files
- [ ] File scan completed with confidence scores
- [ ] Pattern analysis extracted naming/composition patterns
- [ ] Component analysis done (if --frontend)
- [ ] Backend analysis done (if --backend)
- [ ] All outputs in `.temp/phase1-discovery/`

### File Coverage Check
- [ ] High-confidence files (>0.8) count: _____
- [ ] Medium-confidence files (0.6-0.8) count: _____
- [ ] All expected file types found (`.vue`, `.ts`, `.js`)
- [ ] Boundary files included (types, utils, configs)

### Dependency Coverage Check
- [ ] Direct dependencies mapped
- [ ] First-level indirect dependencies mapped
- [ ] External package dependencies listed
- [ ] Circular dependencies identified (if any)

### Pattern Coverage Check
- [ ] Naming conventions documented
- [ ] File organization patterns identified
- [ ] Composition patterns extracted
- [ ] Unusual patterns flagged for explanation

### Quality Indicators
✓ File confidence scores are well-distributed (not all high or all low)
✓ Dependency graph is connected, not fragmented
✓ Patterns are consistent across similar files
✓ No large gaps in file coverage

### Red Flags
⚠ Many high-confidence files but few medium (scope may be wrong)
⚠ Disconnected dependency islands (topic boundaries unclear)
⚠ No clear patterns (codebase may be inconsistent)
⚠ Key expected files missing from scan

### Gap Resolution
If gaps found:
1. Identify what's missing (files, deps, patterns)
2. Determine cause (wrong search terms, boundary issues, genuinely not there)
3. Spawn targeted subagent to fill gap OR adjust scope
4. Re-verify coverage before proceeding

---

## Phase 2: Analysis

### Analysis Completeness
- [ ] Code deep-dive completed on high-confidence files
- [ ] Architecture synthesized with data flows
- [ ] Usage patterns extracted with examples
- [ ] All outputs in `.temp/phase2-analysis/`

### Code Deep-Dive Check
- [ ] Implementation details documented for key functions/composables
- [ ] Complex logic explained
- [ ] Parameters and return types documented
- [ ] Edge cases identified

### Architecture Check
- [ ] Component relationships mapped
- [ ] Data flow documented (input → processing → output)
- [ ] Integration points identified
- [ ] State management patterns documented

### Usage Pattern Check
- [ ] Real-world usage examples extracted
- [ ] Multiple use cases covered
- [ ] Common scenarios documented
- [ ] Edge case handling shown

### Quality Indicators
✓ Deep-dive covers all high-confidence files from Phase 1
✓ Architecture diagram/description is clear and complete
✓ Usage examples are from actual codebase, not invented
✓ Integration points match dependency map from Phase 1

### Red Flags
⚠ Deep-dive skipped key files
⚠ Architecture description is vague or incomplete
⚠ Usage examples are trivial or generic
⚠ Integration points don't align with dependencies

### Gap Resolution
If gaps found:
1. Compare Phase 2 outputs to Phase 1 discoveries
2. Identify uncovered files, patterns, or integrations
3. Spawn targeted analysis subagent for gaps
4. Update outputs and re-verify

---

## Phase 3: Synthesis

### Documentation Completeness
- [ ] Overview section written
- [ ] Architecture section complete with diagrams
- [ ] All components documented
- [ ] Composables and utilities documented
- [ ] Patterns and conventions documented
- [ ] Usage examples included
- [ ] Dependencies listed (internal and external)
- [ ] State management documented (if applicable)
- [ ] API integration documented (if applicable)
- [ ] Edge cases documented
- [ ] Related topics linked

### Structure Check
- [ ] Follows doc-template.md structure
- [ ] All required sections present
- [ ] Sections in logical order
- [ ] No orphaned subsections

### Content Quality Check
- [ ] All claims supported by Phase 1-2 research
- [ ] Code examples are syntactically valid
- [ ] File paths are correct
- [ ] Type definitions are accurate
- [ ] No placeholder text (like "TODO", "TBD")

### Cross-Reference Check
- [ ] Component mentions link to component sections
- [ ] Dependencies reference actual files
- [ ] Usage examples import correct paths
- [ ] Related topics are accurate

### Quality Indicators
✓ Documentation flows logically from overview to details
✓ Technical depth matches topic complexity
✓ All Phase 1-2 findings incorporated
✓ No contradictions between sections

### Red Flags
⚠ Sections feel "copy-pasted" rather than synthesized
⚠ Missing integration between components
⚠ Examples don't align with described architecture
⚠ Key Phase 2 findings not mentioned

### Gap Resolution
If gaps found:
1. Re-read Phase 1-2 outputs
2. Identify what research exists but wasn't incorporated
3. Update documentation to include missing information
4. Ensure consistency across all sections

---

## Phase 4: Verification

### Verification Completeness
- [ ] Accuracy verification completed
- [ ] Completeness verification completed
- [ ] Example validation completed (if examples present)
- [ ] All outputs in `.temp/phase4-verification/`

### Accuracy Check
- [ ] Critical issues count: _____
- [ ] Warning issues count: _____
- [ ] All file paths verified
- [ ] All function signatures verified
- [ ] All code examples validated
- [ ] All dependency claims verified

### Completeness Check
- [ ] File coverage: _____%  (target: >80%)
- [ ] Pattern coverage: _____%  (target: >90%)
- [ ] Missing high-confidence files: _____
- [ ] Missing patterns: _____
- [ ] Missing integration points: _____

### Example Validation Check
- [ ] Example count: _____
- [ ] Valid examples: _____
- [ ] Invalid examples: _____
- [ ] Syntax errors: _____
- [ ] Import errors: _____

### Quality Indicators
✓ Zero critical issues
✓ Fewer than 5 warnings
✓ File coverage >80%
✓ Pattern coverage >90%
✓ All examples syntactically valid

### Red Flags
⚠ Any critical issues (MUST fix before finalization)
⚠ 5+ warnings (significant quality concerns)
⚠ File coverage <70% (major gaps)
⚠ Pattern coverage <80% (incomplete patterns)
⚠ Multiple invalid examples (quality issue)

### Gap Resolution
If critical issues found:
1. Apply fixes immediately
2. Re-run accuracy verification
3. Ensure no new issues introduced

If warnings found:
1. Assess severity (can proceed vs. must fix)
2. Fix high-priority warnings
3. Document remaining warnings in metadata

If coverage gaps found:
1. Identify missing items
2. Determine if in-scope or out-of-scope
3. Add missing items if in-scope
4. Update scope definition if out-of-scope

---

## Phase 5: Finalization

### Finalization Completeness
- [ ] All critical issues resolved
- [ ] Major warnings resolved
- [ ] Remaining warnings documented in metadata
- [ ] metadata.json created with accurate stats
- [ ] archives/ directory created
- [ ] `.temp/` directory preserved
- [ ] User report generated

### Metadata Accuracy Check
- [ ] Topic name correct
- [ ] Date accurate
- [ ] File count matches analysis
- [ ] Complexity assessment matches plan
- [ ] Subagent count accurate
- [ ] Verification status reflects actual results
- [ ] Stack array includes all technologies used

### Output Structure Check
[project]/.claude/brains/[topic]/
├── main.md              ✓ Present and complete
├── metadata.json        ✓ Present and accurate
├── .temp/              ✓ Present with all phase outputs
│   ├── plan.md         ✓
│   ├── phase1-discovery/  ✓
│   ├── phase2-analysis/   ✓
│   └── phase4-verification/ ✓
└── archives/           ✓ Directory created

### Quality Indicators
✓ All verification issues addressed
✓ Metadata accurately reflects work done
✓ Directory structure complete
✓ User report is informative and accurate

### Red Flags
⚠ Critical issues still present (verification failed)
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

### Token Efficiency
- [ ] Outputs are concise, not verbose
- [ ] Redundant information minimized
- [ ] Structured data used where appropriate (JSON vs. prose)

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

**High (SHOULD fix before proceeding):**
- Coverage below targets (<80% files, <90% patterns)
- Multiple warnings (5+)
- Missing key integration points
- Incomplete architecture description

**Medium (CAN proceed, address if time permits):**
- Minor coverage gaps
- 1-4 warnings
- Missing edge case documentation
- Incomplete usage examples

**Low (Document and defer):**
- Stylistic inconsistencies
- Minor redundancies
- Future enhancement opportunities
- Related topic links incomplete

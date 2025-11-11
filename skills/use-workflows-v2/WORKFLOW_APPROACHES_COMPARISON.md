# Workflow Approaches Comparison
## Investigation + Plan Writing Workflows

This document presents 3 distinct approaches for creating two new workflows:
1. **Investigation/Research/Advice Workflow** - For brainstorming, research, and decision-making
2. **Plan Writing Workflow** - For detailed implementation planning

---

## Philosophy Summary

### Approach 1: Minimal (The "Sprinter")
**Philosophy:** Speed and efficiency. Assumes user expertise and clear problem space. Minimal subagents and checkpoints for rapid results.

**Best for:**
- Small, well-defined tasks
- When user has strong intuition about solution
- Fast iterations and quick decisions
- Experienced developers who need light guidance

**Tradeoffs:**
- ✅ Fast (15-30 min total)
- ✅ Low token usage (10-40K)
- ✅ Direct, no analysis paralysis
- ❌ May miss edge cases
- ❌ Less comprehensive research
- ❌ Fewer safety checks

---

### Approach 2: Balanced (The "Strategist")
**Philosophy:** Pragmatic blend of speed and rigor. Documentation-first, structured planning, critical user approval points. Aligns with modern SDLC practices.

**Best for:**
- Majority of development tasks
- New features of moderate complexity
- When clear documentation is needed
- Teams requiring alignment before implementation

**Tradeoffs:**
- ✅ Good balance of speed/depth
- ✅ Structured checkpoints prevent wasted work
- ✅ External research integrated
- ✅ Clear deliverables
- ⚖️ Moderate time (30-60 min total)
- ⚖️ Moderate tokens (30-80K)
- ❌ More overhead than minimal

---

### Approach 3: Comprehensive (The "Architect")
**Philosophy:** Maximum rigor and safety. No stone unturned. Specialized subagents for deep analysis. Extensive documentation and context preservation.

**Best for:**
- Large-scale features
- Complex refactoring
- High-stakes projects
- When team alignment is critical
- Reducing risk on unfamiliar territory

**Tradeoffs:**
- ✅ Thorough research (web + docs + codebase)
- ✅ Multiple validation layers
- ✅ Extensive documentation
- ✅ Risk mitigation built-in
- ❌ Time-intensive (60-120 min total)
- ❌ High token usage (80-200K)
- ❌ Can feel like overkill for simple tasks

---

## Approach 1: MINIMAL (The "Sprinter")

### Investigation Workflow

**Name:** `quick-investigation`
**Estimated Time:** 10-15 minutes
**Estimated Tokens:** 5-20K

#### Phase Structure (2 phases)

1. **Problem Understanding**
   - Main agent asks clarifying questions directly
   - User describes problem, success criteria, constraints
   - No subagent - direct conversation

2. **Quick Research**
   - Main agent uses code-researcher skill directly (no subagent spawning)
   - Searches codebase for patterns
   - Presents 2-3 approaches immediately

#### Subagent Strategy
- **Phase 1:** None (direct user interaction)
- **Phase 2:** None (main agent uses skills directly: code-researcher, external-research if needed)

#### Checkpoint Placement
- **After Phase 2:** Present findings, ask user to pick approach

#### Gap Checks
- Phase 2: "At least 2 approaches identified", "Approaches are feasible"

#### Deliverables
- `.temp/quick-investigation/findings.md` - Brief findings with 2-3 approaches
- `.temp/quick-investigation/decision.json` - User's chosen approach

#### YAML Configuration
```yaml
name: quick-investigation
description: Fast investigation with minimal overhead for clear problems
estimated_time: 10-15 minutes
estimated_tokens: 5K-20K
complexity: simple

phases:
  - problem-understanding
  - quick-research

subagent_matrix:
  problem-understanding:
    always: []  # Main agent interaction only
  quick-research:
    always: []  # Main agent uses skills directly

gap_checks:
  quick-research:
    criteria:
      - "At least 2 approaches identified"
      - "Each approach has pros/cons"
      - "Approaches are technically feasible"

checkpoints:
  - after: quick-research
    prompt: "Review findings and select approach"
    show_files:
      - "{{output_dir}}/findings.md"
    options:
      - "Continue to planning with selected approach"
      - "Need more research"
      - "Abort"
```

---

### Plan Writing Workflow

**Name:** `quick-plan`
**Estimated Time:** 5-15 minutes
**Estimated Tokens:** 5-20K

#### Phase Structure (2 phases)

1. **Plan Initialization**
   - Confirm chosen approach from investigation
   - Main agent asks about plan detail level

2. **Plan Generation**
   - Main agent writes plan directly
   - Uses implementation-sequencer subagent for task breakdown
   - Single deliverable: `quick-plan.md`

#### Subagent Strategy
- **Phase 1:** None (direct conversation)
- **Phase 2:** 1 subagent - implementation-sequencer

#### Checkpoint Placement
- **After Phase 2:** Review quick plan before implementation

#### Gap Checks
- Phase 2: "Implementation steps are clear", "Dependencies identified"

#### Deliverables
- `.temp/quick-plan/quick-plan.md` - Concise plan with steps

#### YAML Configuration
```yaml
name: quick-plan
description: Fast-track planning for simple tasks with minimal overhead
estimated_time: 5-15 minutes
estimated_tokens: 5K-20K
complexity: simple

phases:
  - plan-init
  - plan-generation

subagent_matrix:
  plan-init:
    always: []
  plan-generation:
    always:
      - implementation-sequencer

gap_checks:
  plan-generation:
    criteria:
      - "Implementation steps are clear"
      - "Dependencies identified"
      - "Testing approach defined"

checkpoints:
  - after: plan-generation
    prompt: "Review quick plan before implementation"
    show_files:
      - "{{output_dir}}/quick-plan.md"
    options:
      - "Finalize plan"
      - "Revise steps"
      - "Abort"
```

---

## Approach 2: BALANCED (The "Strategist")

### Investigation Workflow

**Name:** `investigation-workflow`
**Estimated Time:** 20-40 minutes
**Estimated Tokens:** 20-60K

#### Phase Structure (5 phases)

1. **Problem Understanding (STOP & ASK)**
   - Main agent conversation
   - Clarify issue/goal, gather context, define success criteria
   - User approval checkpoint

2. **Codebase Investigation**
   - Spawn code-researcher subagent
   - File discovery, pattern analysis, dependency mapping
   - Review similar implementations

3. **External Research**
   - Main agent invokes external-research skill
   - Search web for best practices, framework updates
   - Present findings alongside codebase research

4. **Solution Synthesis (STOP & ASK)**
   - Main agent synthesizes findings
   - Present 2-3 feasible approaches with pros/cons
   - Risk assessment and complexity rating
   - User selects preferred approach

5. **Approach Refinement**
   - Deep dive into chosen approach
   - Spawn architecture-specialist subagent (conditional)
   - Identify specific files/modules to change
   - List technical challenges and validation strategy

#### Subagent Strategy
- **Phase 1:** None (user conversation)
- **Phase 2:** code-researcher (always)
- **Phase 3:** None (main agent uses external-research skill)
- **Phase 4:** None (main agent synthesis)
- **Phase 5:** architecture-specialist (conditional on complexity)

#### Checkpoint Placement
- **After Phase 1:** Confirm understanding before research
- **After Phase 4:** Discuss options, get user preference
- **After Phase 5:** Final approval before moving to planning

#### Gap Checks
- Phase 2: "At least 5 patterns identified", "Dependencies mapped", "Integration points documented"
- Phase 4: "2-3 approaches presented", "Each has pros/cons and risk rating"
- Phase 5: "Specific files identified", "Technical challenges listed"

#### Deliverables
- `.temp/investigation/problem.md` - Problem statement and success criteria
- `.temp/investigation/codebase.json` - Codebase research findings
- `.temp/investigation/research.md` - External research findings
- `.temp/investigation/approaches.json` - 2-3 approaches with analysis
- `.temp/investigation/refined-approach.md` - Deep dive on chosen approach

#### YAML Configuration
```yaml
name: investigation-workflow
description: Balanced investigation with codebase + external research and user checkpoints
estimated_time: 20-40 minutes
estimated_tokens: 20K-60K
complexity: moderate

phases:
  - problem-understanding
  - codebase-investigation
  - external-research
  - solution-synthesis
  - approach-refinement

subagent_matrix:
  problem-understanding:
    always: []
  codebase-investigation:
    always:
      - code-researcher
  external-research:
    always: []  # Main agent uses skill
  solution-synthesis:
    always: []
  approach-refinement:
    always: []
    conditional:
      complex:
        - architecture-specialist

gap_checks:
  codebase-investigation:
    criteria:
      - "At least 5 patterns identified"
      - "Dependencies mapped"
      - "Integration points documented"
      - "All file paths are real"
  solution-synthesis:
    criteria:
      - "2-3 approaches presented"
      - "Each has pros/cons"
      - "Risk assessment included"
      - "Complexity rating provided"
  approach-refinement:
    criteria:
      - "Specific files identified"
      - "Technical challenges listed"
      - "Validation strategy defined"

checkpoints:
  - after: problem-understanding
    prompt: "Confirm problem understanding before starting research"
    show_files: []
    options:
      - "Proceed to research"
      - "Refine problem statement"
      - "Abort"

  - after: solution-synthesis
    prompt: "Review approaches and select preferred solution direction"
    show_files:
      - "{{output_dir}}/codebase.json"
      - "{{output_dir}}/research.md"
      - "{{output_dir}}/approaches.json"
    options:
      - "Continue with selected approach"
      - "Need more research"
      - "Combine approaches"
      - "Abort"

  - after: approach-refinement
    prompt: "Review refined approach before moving to detailed planning"
    show_files:
      - "{{output_dir}}/refined-approach.md"
    options:
      - "Continue to planning workflow"
      - "Refine further"
      - "Abort"
```

---

### Plan Writing Workflow

**Name:** `plan-writing-workflow`
**Estimated Time:** 30-60 minutes
**Estimated Tokens:** 30-80K

#### Phase Structure (7 phases)

1. **Plan Initialization (STOP & ASK)**
   - Confirm approach from investigation phase
   - Determine plan scope and detail level
   - Establish file naming/location

2. **Requirements Documentation**
   - Spawn requirements-specialist subagent
   - Functional requirements, technical constraints
   - Dependencies, schema changes

3. **Technical Design**
   - Spawn architecture-specialist subagent
   - Component architecture, data flow, API contracts
   - State management, file organization

4. **Implementation Breakdown**
   - Main agent synthesizes requirements + design
   - File-by-file change list
   - Specific function/component changes
   - Code snippets for complex logic

5. **Testing Strategy**
   - Main agent designs testing approach
   - Unit test requirements
   - Integration test scenarios
   - Manual testing checklist, edge cases

6. **Quality Checklist (STOP & ASK)**
   - Main agent creates checklist
   - TypeScript compliance, duplication, performance, security
   - User reviews complete plan

7. **Plan Finalization**
   - Main agent saves plan to directory
   - Version control, links to related plans
   - Mark as ready for implementation

#### Subagent Strategy
- **Phase 1:** None (user conversation)
- **Phase 2:** requirements-specialist (always)
- **Phase 3:** architecture-specialist (always)
- **Phase 4-7:** None (main agent synthesis)

#### Checkpoint Placement
- **After Phase 1:** Agree on plan structure
- **After Phase 6:** Review complete plan, iterate if needed
- **After Phase 7:** Final approval

#### Gap Checks
- Phase 2: "User stories follow INVEST", "Technical requirements specific", "Dependencies listed"
- Phase 3: "Architecture well-defined", "Data flow documented", "API contracts specified"
- Phase 4: "File-by-file changes listed", "Import updates documented"
- Phase 5: "Testing strategy comprehensive", "Edge cases covered"

#### Deliverables
- `.temp/plan/requirements.json` - Functional and technical requirements
- `.temp/plan/architecture.json` - Technical design and data models
- `.temp/plan/implementation.md` - File-by-file breakdown
- `.temp/plan/testing.md` - Testing strategy
- `.temp/plan/checklist.md` - Quality checklist
- `.temp/plan/PLAN.md` - Final consolidated plan

#### YAML Configuration
```yaml
name: plan-writing-workflow
description: Structured plan writing with requirements, design, and quality checks
estimated_time: 30-60 minutes
estimated_tokens: 30K-80K
complexity: moderate

phases:
  - plan-init
  - requirements
  - design
  - implementation
  - testing
  - quality-review
  - finalization

subagent_matrix:
  plan-init:
    always: []
  requirements:
    always:
      - requirements-specialist
  design:
    always:
      - architecture-specialist
  implementation:
    always: []
  testing:
    always: []
  quality-review:
    always: []
  finalization:
    always: []

gap_checks:
  requirements:
    criteria:
      - "User stories follow INVEST criteria"
      - "Technical requirements are specific"
      - "Dependencies listed with versions"
      - "Schema changes documented"
  design:
    criteria:
      - "Architecture is well-defined"
      - "Data flow documented"
      - "API contracts specified"
      - "State management approach clear"
  implementation:
    criteria:
      - "File-by-file changes listed"
      - "Function/component changes specific"
      - "Import updates documented"
  testing:
    criteria:
      - "Unit test requirements defined"
      - "Integration scenarios documented"
      - "Edge cases covered"

checkpoints:
  - after: plan-init
    prompt: "Confirm plan structure and scope"
    show_files: []
    options:
      - "Continue to requirements"
      - "Adjust scope"
      - "Abort"

  - after: quality-review
    prompt: "Review complete plan before finalizing"
    show_files:
      - "{{output_dir}}/requirements.json"
      - "{{output_dir}}/architecture.json"
      - "{{output_dir}}/implementation.md"
      - "{{output_dir}}/testing.md"
      - "{{output_dir}}/checklist.md"
    options:
      - "Finalize plan"
      - "Revise requirements"
      - "Revise design"
      - "Abort"

  - after: finalization
    prompt: "Plan saved and ready for implementation"
    show_files:
      - "{{output_dir}}/PLAN.md"
    options:
      - "Begin implementation"
      - "Archive for later"
```

---

## Approach 3: COMPREHENSIVE (The "Architect")

### Investigation Workflow

**Name:** `comprehensive-investigation`
**Estimated Time:** 40-80 minutes
**Estimated Tokens:** 60-150K

#### Phase Structure (7 phases)

1. **Problem Understanding (STOP & ASK)**
   - Detailed problem exploration with clarifying questions
   - Spawn requirements-specialist to document problem formally
   - Success criteria, constraints, assumptions

2. **Codebase Investigation**
   - Spawn multiple specialized subagents in parallel:
     - code-researcher (comprehensive scan)
     - pattern-analyzer (deep pattern matching)
     - dependency-mapper (full dependency graph)
   - Frontend/backend specialists based on scope

3. **External Research (Multi-Source)**
   - Spawn web-researcher subagent for comprehensive research
   - Search official docs (Context7 MCP)
   - Search best practices (Tavily)
   - Compile research report with citations

4. **Comparative Analysis**
   - Spawn feasibility-validator to assess each approach
   - Risk assessment for each option
   - Performance implications
   - Security considerations

5. **Solution Synthesis (STOP & ASK)**
   - Main agent synthesizes all research
   - Present 3-5 approaches with detailed comparison matrix
   - Include: pros, cons, risks, complexity, timeline, resource needs
   - User discusses and ranks preferences

6. **Approach Deep Dive**
   - Spawn architecture-specialist for chosen approach
   - Spawn technique-selector for implementation patterns
   - Create detailed implementation strategy
   - Identify potential blockers and mitigation

7. **Validation & Refinement (STOP & ASK)**
   - Spawn completeness-checker to verify coverage
   - Spawn risk-assessor for final risk analysis
   - User final approval with confidence rating

#### Subagent Strategy
- **Phase 1:** requirements-specialist
- **Phase 2:** code-researcher, pattern-analyzer, dependency-mapper, + conditional (frontend-scanner, backend-scanner)
- **Phase 3:** web-researcher
- **Phase 4:** feasibility-validator
- **Phase 5:** None (main agent synthesis)
- **Phase 6:** architecture-specialist, technique-selector
- **Phase 7:** completeness-checker, risk-assessor

#### Checkpoint Placement
- **After Phase 1:** Confirm problem understanding (90%+ confidence)
- **After Phase 5:** Select approach from comparison matrix
- **After Phase 7:** Final approval with documented risks

#### Gap Checks
- Phase 2: "10+ patterns identified", "Complete dependency graph", "All integration points documented"
- Phase 3: "Multiple sources researched", "Official docs consulted", "Best practices documented"
- Phase 4: "All approaches have feasibility rating", "Risks documented", "Performance implications assessed"
- Phase 6: "Implementation strategy complete", "Blockers identified", "Mitigation plans documented"
- Phase 7: "90%+ coverage confidence", "All risks documented with mitigation"

#### Deliverables
- `.temp/investigation/problem-spec.md` - Formal problem specification
- `.temp/investigation/codebase-report.json` - Comprehensive codebase analysis
- `.temp/investigation/patterns.json` - Pattern analysis results
- `.temp/investigation/dependencies.json` - Full dependency graph
- `.temp/investigation/research-report.md` - Multi-source research compilation
- `.temp/investigation/feasibility.json` - Feasibility assessment
- `.temp/investigation/comparison-matrix.md` - Detailed approach comparison
- `.temp/investigation/implementation-strategy.md` - Deep dive on chosen approach
- `.temp/investigation/validation.json` - Completeness and risk validation
- `.temp/investigation/INVESTIGATION-SUMMARY.md` - Executive summary

#### YAML Configuration
```yaml
name: comprehensive-investigation
description: Exhaustive investigation with multi-source research and deep validation
estimated_time: 40-80 minutes
estimated_tokens: 60K-150K
complexity: complex

phases:
  - problem-understanding
  - codebase-investigation
  - external-research
  - comparative-analysis
  - solution-synthesis
  - approach-deep-dive
  - validation-refinement

subagent_matrix:
  problem-understanding:
    always:
      - requirements-specialist
  codebase-investigation:
    always:
      - code-researcher
      - pattern-analyzer
      - dependency-mapper
    conditional:
      frontend:
        - frontend-scanner
      backend:
        - backend-scanner
      both:
        - frontend-scanner
        - backend-scanner
  external-research:
    always:
      - web-researcher
  comparative-analysis:
    always:
      - feasibility-validator
  solution-synthesis:
    always: []
  approach-deep-dive:
    always:
      - architecture-specialist
      - technique-selector
  validation-refinement:
    always:
      - completeness-checker
      - risk-assessor

gap_checks:
  codebase-investigation:
    criteria:
      - "At least 10 patterns identified"
      - "Complete dependency graph created"
      - "All integration points documented"
      - "Similar implementations analyzed"
  external-research:
    criteria:
      - "Multiple sources researched"
      - "Official docs consulted"
      - "Best practices documented with citations"
  comparative-analysis:
    criteria:
      - "All approaches have feasibility rating"
      - "Risks documented for each"
      - "Performance implications assessed"
  approach-deep-dive:
    criteria:
      - "Implementation strategy complete"
      - "Blockers identified with mitigation"
      - "File changes specified"
  validation-refinement:
    criteria:
      - "Coverage confidence 90%+"
      - "All risks documented"
      - "Completeness verified"

checkpoints:
  - after: problem-understanding
    prompt: "Confirm detailed problem specification before extensive research"
    show_files:
      - "{{output_dir}}/problem-spec.md"
    options:
      - "Proceed to investigation"
      - "Refine specification"
      - "Abort"

  - after: solution-synthesis
    prompt: "Review comprehensive analysis and select approach"
    show_files:
      - "{{output_dir}}/codebase-report.json"
      - "{{output_dir}}/research-report.md"
      - "{{output_dir}}/feasibility.json"
      - "{{output_dir}}/comparison-matrix.md"
    options:
      - "Continue with selected approach"
      - "Need deeper analysis on specific approach"
      - "Request additional research"
      - "Abort"

  - after: validation-refinement
    prompt: "Final approval before moving to comprehensive planning"
    show_files:
      - "{{output_dir}}/implementation-strategy.md"
      - "{{output_dir}}/validation.json"
      - "{{output_dir}}/INVESTIGATION-SUMMARY.md"
    options:
      - "Continue to planning workflow"
      - "Refine strategy"
      - "Re-assess risks"
      - "Abort"
```

---

### Plan Writing Workflow

**Name:** `comprehensive-plan`
**Estimated Time:** 60-120 minutes
**Estimated Tokens:** 80-200K

#### Phase Structure (9 phases)

1. **Plan Initialization (STOP & ASK)**
   - Load investigation summary
   - Determine comprehensive vs focused plan
   - Establish documentation standards

2. **Requirements Documentation**
   - Spawn requirements-specialist
   - Spawn edge-case-identifier
   - Functional requirements, technical constraints
   - Comprehensive edge case analysis

3. **Technical Design**
   - Spawn architecture-specialist
   - Spawn ui-designer (conditional frontend)
   - Spawn api-designer (conditional backend)
   - Detailed component architecture, data models, API contracts
   - State management, file organization

4. **Implementation Breakdown**
   - Spawn implementation-sequencer
   - File-by-file detailed changes
   - Function signatures, logic pseudo-code
   - Import/dependency updates

5. **Testing Strategy**
   - Spawn test-planner
   - Unit, integration, e2e test requirements
   - Test data setup, mocking strategies
   - Coverage targets

6. **Security Review**
   - Spawn security-reviewer
   - Input validation, auth/authorization
   - Data exposure risks, API security

7. **Performance Planning**
   - Spawn performance-assessor (conditional)
   - Performance implications
   - Optimization opportunities
   - Monitoring strategy

8. **Quality Checklist (STOP & ASK)**
   - Spawn completeness-checker
   - Spawn feasibility-validator
   - Comprehensive quality review
   - User reviews all artifacts

9. **Plan Finalization**
   - Generate comprehensive PRD
   - Create implementation roadmap
   - Establish success metrics
   - Archive all artifacts

#### Subagent Strategy
- **Phase 1:** None
- **Phase 2:** requirements-specialist, edge-case-identifier
- **Phase 3:** architecture-specialist, + conditional (ui-designer, api-designer)
- **Phase 4:** implementation-sequencer
- **Phase 5:** test-planner
- **Phase 6:** security-reviewer
- **Phase 7:** performance-assessor (conditional)
- **Phase 8:** completeness-checker, feasibility-validator
- **Phase 9:** None (main agent synthesis)

#### Checkpoint Placement
- **After Phase 1:** Confirm plan scope
- **After Phase 3:** Review technical design before detailed breakdown
- **After Phase 8:** Review complete plan with all validation
- **After Phase 9:** Final approval with executive summary

#### Gap Checks
- Phase 2: "INVEST criteria met", "Edge cases comprehensive", "Schema fully documented"
- Phase 3: "Architecture detailed", "All components specified", "Data flow complete"
- Phase 4: "All files identified", "Function signatures specified", "Logic pseudo-code provided"
- Phase 5: "Test coverage targets set", "Test data strategy defined", "Mocking approach clear"
- Phase 6: "Security risks identified", "Mitigation plans documented", "Auth/authz verified"
- Phase 8: "Completeness 95%+", "Feasibility confirmed", "All risks documented"

#### Deliverables
- `.temp/plan/requirements.json` - Comprehensive requirements
- `.temp/plan/edge-cases.json` - Edge case analysis
- `.temp/plan/architecture.json` - Detailed technical design
- `.temp/plan/ui-design.json` - UI component specifications (conditional)
- `.temp/plan/api-design.json` - API contract specifications (conditional)
- `.temp/plan/implementation-sequence.md` - File-by-file breakdown
- `.temp/plan/testing-strategy.md` - Comprehensive test plan
- `.temp/plan/security-review.md` - Security analysis
- `.temp/plan/performance-plan.md` - Performance considerations (conditional)
- `.temp/plan/validation.json` - Completeness validation
- `.temp/plan/PRD.md` - Product Requirements Document
- `.temp/plan/ROADMAP.md` - Implementation roadmap
- `.temp/plan/SUCCESS-METRICS.md` - Success criteria and metrics

#### YAML Configuration
```yaml
name: comprehensive-plan
description: Exhaustive planning with security, performance, and comprehensive validation
estimated_time: 60-120 minutes
estimated_tokens: 80K-200K
complexity: complex

phases:
  - plan-init
  - requirements
  - design
  - implementation
  - testing
  - security
  - performance
  - quality-review
  - finalization

subagent_matrix:
  plan-init:
    always: []
  requirements:
    always:
      - requirements-specialist
      - edge-case-identifier
  design:
    always:
      - architecture-specialist
    conditional:
      frontend:
        - ui-designer
      backend:
        - api-designer
      both:
        - ui-designer
        - api-designer
  implementation:
    always:
      - implementation-sequencer
  testing:
    always:
      - test-planner
  security:
    always:
      - security-reviewer
  performance:
    always: []
    conditional:
      high_load:
        - performance-assessor
  quality-review:
    always:
      - completeness-checker
      - feasibility-validator
  finalization:
    always: []

gap_checks:
  requirements:
    criteria:
      - "User stories follow INVEST criteria"
      - "Edge cases are comprehensive"
      - "Schema fully documented with types"
      - "All dependencies listed with versions"
  design:
    criteria:
      - "Architecture is detailed and viable"
      - "All components specified"
      - "Data flow complete"
      - "API contracts defined"
  implementation:
    criteria:
      - "All files identified with paths"
      - "Function signatures specified"
      - "Logic pseudo-code provided"
      - "Import updates documented"
  testing:
    criteria:
      - "Test coverage targets set"
      - "Test data strategy defined"
      - "Mocking approach clear"
      - "E2E scenarios documented"
  security:
    criteria:
      - "Security risks identified"
      - "Mitigation plans documented"
      - "Auth/authz patterns verified"
      - "Input validation specified"
  quality-review:
    criteria:
      - "Completeness confidence 95%+"
      - "Feasibility confirmed"
      - "All risks documented"
      - "Success metrics defined"

checkpoints:
  - after: plan-init
    prompt: "Confirm plan scope and documentation level"
    show_files: []
    options:
      - "Continue with comprehensive planning"
      - "Reduce scope to balanced"
      - "Abort"

  - after: design
    prompt: "Review technical design before detailed implementation breakdown"
    show_files:
      - "{{output_dir}}/requirements.json"
      - "{{output_dir}}/architecture.json"
      - "{{output_dir}}/ui-design.json"
      - "{{output_dir}}/api-design.json"
    options:
      - "Continue to implementation breakdown"
      - "Revise requirements"
      - "Revise architecture"
      - "Abort"

  - after: quality-review
    prompt: "Review complete comprehensive plan with all validation"
    show_files:
      - "{{output_dir}}/requirements.json"
      - "{{output_dir}}/architecture.json"
      - "{{output_dir}}/implementation-sequence.md"
      - "{{output_dir}}/testing-strategy.md"
      - "{{output_dir}}/security-review.md"
      - "{{output_dir}}/validation.json"
    options:
      - "Finalize plan"
      - "Revise specific section"
      - "Add more detail"
      - "Abort"

  - after: finalization
    prompt: "Comprehensive plan complete - ready for implementation"
    show_files:
      - "{{output_dir}}/PRD.md"
      - "{{output_dir}}/ROADMAP.md"
      - "{{output_dir}}/SUCCESS-METRICS.md"
    options:
      - "Begin implementation"
      - "Archive for team review"
      - "Export to external tool"
```

---

## Integration Between Workflows

### Approach 1: Minimal
```
Investigation (10-15 min) → [User picks approach] → Planning (5-15 min) = 15-30 min total
```
**Handoff:** Findings.md from investigation passed to planning phase

---

### Approach 2: Balanced
```
Investigation (20-40 min) → [90% confidence] → Planning (30-60 min) = 50-100 min total
```
**Handoff:** Refined approach from investigation loaded as input for planning

---

### Approach 3: Comprehensive
```
Investigation (40-80 min) → [Validated approach] → Planning (60-120 min) = 100-200 min total
```
**Handoff:** Investigation summary + all artifacts available to planning workflow

---

## Subagent Orchestration Summary

| Approach | Investigation Subagents | Planning Subagents | Total Subagents |
|----------|------------------------|-------------------|-----------------|
| **Minimal** | 0 (uses skills directly) | 1 (implementation-sequencer) | 1 |
| **Balanced** | 1-2 (code-researcher + optional architect) | 2 (requirements-specialist, architecture-specialist) | 3-4 |
| **Comprehensive** | 6-8 (multiple specialized agents) | 7-9 (comprehensive coverage) | 13-17 |

---

## Recommendation Decision Matrix

### Choose MINIMAL if:
- [ ] Task is well-defined
- [ ] User has strong intuition about solution
- [ ] Time is critical (tight deadline)
- [ ] Problem space is familiar
- [ ] Risk tolerance is high
- [ ] Team is experienced

### Choose BALANCED if:
- [ ] Task has moderate complexity
- [ ] Clear documentation is needed
- [ ] Team alignment required
- [ ] Reasonable time available
- [ ] Balance of speed and rigor desired
- [ ] Follows established SDLC practices

### Choose COMPREHENSIVE if:
- [ ] Task is large-scale or complex
- [ ] Risk must be minimized
- [ ] Stakeholder buy-in critical
- [ ] Unfamiliar problem space
- [ ] Extensive documentation needed
- [ ] Multiple validation layers required

---

## Next Steps

1. **Select your preferred approach** (or hybrid)
2. **Review specific YAML configurations** for chosen approach
3. **Create workflow files** in `use-workflows-v2/workflows/`
4. **Create subagent templates** in `use-workflows-v2/subagents/`
5. **Test workflow generation** with sample feature

---

**Created:** 2025-11-04
**Author:** Claude Code workflow research
**Status:** Ready for user decision

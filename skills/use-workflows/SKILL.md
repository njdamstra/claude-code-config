---
name: planner
description: Create implementation plans using workflow-specific multi-agent orchestration. Supports new features, refactors, debugging, architecture design, and code review planning. Use when user requests "plan [feature]", "create plan for [task]", "/plans", or specifies workflow type. Optimized for Vue3, Astro, TypeScript, nanostore, Appwrite, Tailwind CSS v4 projects.
tools: [Bash, Grep, Glob, Read, Write]
model: sonnet
---

# Planner Skill

## Overview

Systematically plans implementation tasks through coordinated multi-agent research. Creates comprehensive plans capturing requirements, design decisions, task breakdowns, and risk assessments with verification checkpoints at each phase.

**Stack Support:** Vue3, Astro, TypeScript, nanostore, Appwrite (databases, serverless functions), Cloudflare, Zod, headless-ui/vue, floating-ui/vue, shadcn-ui/vue, Tailwind CSS v4

**Output Location:** `.temp/[feature-name]/`

## When to Use This Skill

Invoke this skill when you need to:
- Plan implementation of new features or systems
- Design refactoring approaches for existing code
- Create systematic debugging strategies
- Architect complex integrations or systems
- Plan comprehensive code reviews

## Quick Start Execution

**IMPORTANT:** This skill is **Claude-executed**, not bash-executed. Do NOT run `bash engine/workflow-runner.sh` - that's test infrastructure only.

When invoked, follow these steps:

### Step 1: Select Workflow
Ask user or detect from request:
- `new-feature` → Comprehensive feature planning (7 phases, ~15 subagents)
- `quick` → Rapid planning (4 phases, ~2 subagents)
- `refactoring` → Refactor planning (6 phases, ~12 subagents)
- `debugging` → Bug investigation (7 phases, ~12 subagents)
- `improving` → Optimization planning (6 phases, ~11 subagents)

### Step 2: Load Workflow YAML
```bash
yq eval workflows/[workflow-name].workflow.yaml -o=json
```

### Step 3: Execute Each Phase
For each phase in workflow:

**If `behavior: main-only`:**
- Execute the inline script logic yourself (Claude)
- Use writeFile/readFile helpers as described
- Continue to next phase

**If `behavior: parallel` or `sequential`:**
- **YOU (Claude) spawn Task agents** - don't try to run bash scripts
- For each subagent in list:
  1. Map subagent type to Task agent (see mapping below)
  2. Create task prompt describing what agent should find
  3. **Use Task tool directly** with mapped agent type
  4. Wait for agent completion
  5. Agent writes output to specified path

**If checkpoint defined:**
- **Present options to user** (don't auto-select)
- Ask user which option to take
- Record decision, proceed accordingly

**If gap_check defined:**
- **Check deliverables quality yourself** (Claude)
- If gaps found, **ask user** how to proceed
- Options: retry, spawn additional agents, continue anyway

### Step 4: Synthesize & Finalize
- Read all deliverables from `.temp/[feature]/`
- Synthesize findings yourself (Claude)
- Create final plan document
- Output plan location to user

## Execution Principles

**✅ DO:**
- Load YAML and execute phases yourself (Claude)
- Spawn Task agents directly when workflow specifies subagents
- Present checkpoints to user for approval
- Check gap criteria and ask user about gaps

**❌ DON'T:**
- Run `bash engine/workflow-runner.sh` (that's test infrastructure)
- Auto-continue checkpoints (always ask user)
- Auto-select checkpoint options (always present choices)
- Auto-spawn subagents from bash (Claude spawns them)

## Subagent to Task Agent Mapping

| Workflow Subagent | Task Agent Type | Thoroughness |
|------------------|----------------|--------------|
| `file-locator` | `Explore` | quick |
| `codebase-scanner` | `Explore` | quick |
| `pattern-checker` | `Explore` | quick |
| `dependency-mapper` | `Explore` | medium |
| `pattern-analyzer` | `Explore` | medium |
| `architecture-designer` | `architecture-specialist` | - |
| `requirements-specialist` | `requirements-specialist` | - |
| `user-story-writer` | `requirements-specialist` | - |
| `bug-investigator` | `Bug Investigator` | - |
| `[any-other]` | `general-purpose` | - |

## Usage Examples

### Via Slash Command:
```bash
/plans new user-dashboard
Description: Build user dashboard with profile, settings, activity feed
Workflow: new-feature
Flags: --frontend
```

### Natural Language:
- "Plan implementation of user dashboard"
- "Create refactor plan for form components"
- "Plan debugging approach for hydration issue"

---

## Workflow Engine v2

The skill is powered by a new YAML-based workflow orchestrator that provides advanced execution control and human-in-loop capabilities.

### Direct Engine Usage

You can run workflows directly using the engine:

```bash
bash engine/workflow-runner.sh <workflow.yaml> <feature-name> [flags...]
```

**Example:**
```bash
bash engine/workflow-runner.sh workflows/new-feature.workflow.yaml user-auth --frontend
```

### Engine Features

**Execution Modes:**
- **Strict mode:** Execute exactly as defined (deterministic subagent spawning)
- **Loose mode:** Main agent has full control (subagents are suggestions)
- **Adaptive mode:** Core agents + conditional spawning based on findings

**Human-in-Loop:**
- **Checkpoints:** Review points where user can continue, repeat phases, skip phases, or abort
- **Gap checks:** Quality validation with automatic retry, additional agent spawning, or escalation

**Skills Integration:**
- Phases can invoke Claude Code skills conditionally
- Skills are invoked after phase completion

**Context Management:**
- Persistent state across phases in `context.json`
- Tracks subagents spawned, deliverables created, checkpoints, and gap checks
- Final metadata generation with workflow metrics

**Template Rendering:**
- Mustache templates for final plan generation
- Variable substitution from workflow context

**Backward Compatibility:**
- Existing JSON-based workflows still supported (legacy mode)
- YAML workflows are the new recommended format

### Workflow Structure

YAML workflows define:
- **name, description:** Workflow metadata
- **execution_mode:** Default mode for all phases (can be overridden per-phase)
- **phases[]:** Array of phase definitions
- **finalization:** Template path and output location

Each **phase** defines:
- **id, name, description:** Phase identification
- **execution_mode:** Optional override (strict/loose/adaptive)
- **behavior:** parallel | sequential | main-only
- **subagents:** Agent configurations
- **checkpoint:** Optional review point
- **gap_check:** Optional quality validation
- **skills:** Optional skill invocations

See `test-minimal.workflow.yaml` for a working example.

---

## Quality Commitment

**Prioritizes thoroughness and actionability over speed.** Token usage and time vary by workflow type (see workflow configurations below).

---

## Workflow Types

This skill supports 5 planning workflows optimized for different use cases:

### 1. **New Feature** (default)
Comprehensive feature planning with PRD generation (40/60 planning-to-coding ratio).
- **Phases:** plan → discovery → requirements → design → synthesis → validation → finalize
- **Subagents:** 10-15 across all phases
- **Token usage:** 30K-100K
- **Time:** 30-90 minutes

### 2. **Refactoring**
Controlled code improvement planning (small-step, behavior-preserving).
- **Phases:** plan → analysis → planning → synthesis → validation → finalize
- **Subagents:** 8-12 focused on analysis
- **Token usage:** 15-60K
- **Time:** 15-45 minutes

### 3. **Debugging**
Systematic bug investigation and resolution planning.
- **Phases:** plan → reproduction → root-cause → solution → synthesis → validation → finalize
- **Subagents:** 8-12 focused on investigation
- **Token usage:** 20-80K
- **Time:** 20-60 minutes

### 4. **Improving**
Targeted code/UX optimization planning (quality-driven enhancements).
- **Phases:** plan → assessment → planning → synthesis → validation → finalize
- **Subagents:** 8-11 focused on optimization
- **Token usage:** 15-60K
- **Time:** 15-45 minutes

### 5. **Quick**
Rapid sprint-style planning for quick tasks (15-minute planning).
- **Phases:** plan → discovery → synthesis → finalize
- **Subagents:** 2-4 focused execution
- **Token usage:** 5-20K
- **Time:** 5-15 minutes

---

## Workflow Detection & Initialization

### Step 1: Detect Workflow Type

Parse user input for workflow indicators:

**Command-based detection:**
- `/plans new <feature>` → new-feature (default)
- `/plans new <feature> --workflow refactoring` → refactoring
- `/plans new <feature> --workflow debugging` → debugging
- `/plans new <feature> --workflow improving` → improving
- `/plans new <feature> --workflow quick` → quick

**Natural language detection:**
- "plan refactoring" → refactoring
- "plan debugging approach" → debugging
- "plan improvement for" → improving
- "quick plan for" → quick
- "plan implementation" → new-feature

**If unclear:** Default to **new-feature**

---

### Step 2: Load Workflow Configuration

```bash
# Read workflow registry
view ~/.claude/skills/planner/workflows/registry.json

# Extract workflow definition
workflow_config = registry.workflows[detected_workflow]

# Note the following from config:
# - phases: List of phases to execute
# - subagents: Which agents to spawn per phase
# - template: Which template file to use
# - quality_target: Success criteria
# - estimated_tokens: Budget guidance
```

---

### Step 3: Load Phase Configuration

```bash
# Read phase registry
view ~/.claude/skills/planner/phases/phase-registry.json

# For each phase in workflow_config.phases:
#   - Check if required/optional/skipped
#   - Note subagent count
#   - Note gap check requirements
#   - Note outputs location
```

---

### Step 4: Load Subagent Selection Matrix

```bash
# Read selection matrix
view ~/.claude/skills/planner/subagents/selection-matrix.json

# Extract subagent selection for this workflow
# Note:
# - "always" subagents (spawn unconditionally)
# - "conditional" subagents (spawn based on flags like --frontend/--backend)
```

---

### Step 5: Announce Workflow Plan

After loading all configurations, announce to user:

```markdown
## Implementation Plan: [feature-name]

**Workflow:** [workflow-name]
**Scope:** [--frontend/--backend/--both or default]
**Estimated time:** [X-Y minutes]
**Estimated tokens:** [N-M]K

**Phases to execute:**
1. [Phase 1 name] - [brief description]
2. [Phase 2 name] - [brief description]
...

**Subagents:** [X] total across all phases

Proceeding with [workflow-name] planning workflow...
```

---

## Multi-Agent Orchestration Architecture

### Core Principles

1. **Lead Agent** (main conversation) coordinates all activities
2. **Extended Thinking** ("think hard") for strategic planning
3. **Parallel Subagents** (2-5 simultaneous) for independent research
4. **Interleaved Thinking** by subagents after each tool result
5. **No subagent-spawned subagents** - flat hierarchy only
6. **Persistent Research Storage** - all findings saved to `.temp/` folder

### Available Subagents

This skill coordinates with 50+ specialized subagents located in `~/.claude/agents/plans/`:

**Research Phase:**
- `codebase-scanner` - Scan codebase for patterns and existing code
- `pattern-finder` - Find reusable patterns and best practices
- `dependency-analyzer` - Analyze dependencies and integration points
- `component-analyzer` - Analyze Vue components (conditional: --frontend)
- `backend-analyzer` - Analyze serverless functions (conditional: --backend)

**Analysis Phase:**
- `code-analyzer` - Analyze code quality and structure
- `duplication-detector` - Detect code duplication
- `dependency-mapper` - Map all dependencies
- `impact-analyzer` - Assess refactor impact
- `code-tracer` - Trace code execution paths
- `log-analyzer` - Analyze logs and error patterns

**Design Phase:**
- `architecture-designer` - Design system architecture
- `decision-analyzer` - Analyze architectural decisions
- `integration-planner` - Plan integration strategies
- `refactor-designer` - Design refactor approaches
- `migration-planner` - Plan migration strategies
- `data-flow-designer` - Design data flows
- `solution-designer` - Design bug solutions

**Planning Phase:**
- `task-breakdown-specialist` - Break down tasks
- `risk-analyzer` - Analyze risks
- `verification-planner` - Plan verification strategies
- `scalability-analyzer` - Analyze scalability concerns
- `hypothesis-generator` - Generate debugging hypotheses
- `evidence-analyzer` - Analyze debugging evidence

**Audit Phase:**
- `code-quality-auditor` - Audit code quality
- `security-auditor` - Audit security
- `performance-auditor` - Audit performance
- `accessibility-auditor` - Audit accessibility (conditional: --frontend)
- `issue-categorizer` - Categorize issues
- `priority-ranker` - Rank issue priorities
- `remediation-planner` - Plan remediation steps

### Research Storage Pattern

All subagent research stored in `.claude/plans/[feature-name]/.temp/`:

```
.claude/plans/[feature-name]/
├── plan.md                   # Final implementation plan
├── metadata.json            # Plan metadata
├── .temp/                   # Research scratchpad
│   ├── scope.md            # Phase 0 scope definition
│   ├── phase1-discovery/
│   │   ├── codebase-scan.json
│   │   ├── patterns.json
│   │   └── dependencies.json
│   ├── phase2-requirements/  # or analysis/root-cause/assessment
│   │   ├── user-stories.md
│   │   ├── requirements.json
│   │   └── edge-cases.md
│   ├── phase3-design/       # or planning/solution
│   │   ├── architecture.md
│   │   ├── implementation-sequence.md
│   │   └── test-strategy.md
│   └── phase-validation/
│       ├── feasibility.json
│       └── completeness.json
└── archives/                # Previous versions
```

**Storage Rules:**
- Each subagent writes findings to `.temp/phase{N}-{category}/{subagent-name}.{ext}`
- Use JSON for structured data, Markdown for analysis
- Later phase subagents read from earlier phase files for context
- `.temp/` folder preserved for debugging and reference

---

## Phase Execution

**IMPORTANT:** Only execute phases listed in the loaded workflow configuration. Check `workflow_config.phases` from registry.json.

---

## Phase 0: Scope Definition (Lead Agent)

**Runs for workflows:** new-feature
**Skips for:** refactoring, debugging, improving, quick

### Trigger Extended Thinking

Use **"think hard"** to activate deep planning mode before any actions.

### Planning Tasks (Workflow-Aware)

```
THINK HARD about:
1. Feature Scope
   - What's included in this feature?
   - What's explicitly out of scope?
   - Where are boundaries unclear?

2. Requirements
   - Functional requirements
   - Non-functional requirements (performance, security, etc.)
   - User experience requirements

3. Success Criteria
   - How do we know when it's done?
   - What metrics define success?
   - What are the acceptance criteria?

4. Constraints
   - Technical constraints
   - Timeline constraints
   - Resource constraints
```

### Scope Output

```bash
mkdir -p .claude/plans/[feature-name]/.temp
cat > .claude/plans/[feature-name]/.temp/scope.md << 'EOF'
# Scope: [feature-name]

## In Scope
- [Item 1]
- [Item 2]

## Out of Scope
- [Item 1]
- [Item 2]

## Requirements
### Functional
- [Requirement 1]

### Non-Functional
- [Requirement 1]

## Success Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Constraints
- [Constraint 1]
- [Constraint 2]
EOF
```

---

## Phase 1: Parallel Research/Analysis/Investigation

**Varies by workflow:**
- **new-feature/quick:** discovery phase (codebase scanning, patterns)
- **refactoring:** analysis phase (code analysis, duplication detection)
- **debugging:** reproduction phase (issue reproduction, environment analysis)
- **improving:** assessment phase (baseline profiling, bottleneck identification)

### Orchestration Strategy

Spawn subagents **simultaneously** based on workflow configuration. Each subagent writes findings to `.temp/phase1-{category}/`.

### Subagent Invocation Pattern (Workflow-Aware)

**For new-feature workflow:**
```
I'll now spawn 3-5 discovery subagents in parallel:

1. Use codebase-scanner to scan for existing patterns
2. Use pattern-analyzer to identify reusable code
3. Use dependency-mapper to map integration points
[4. Use frontend-scanner for Vue components] (if --frontend or --both)
[5. Use backend-scanner for Appwrite functions] (if --backend or --both)
```

**For refactoring workflow:**
```
I'll now spawn 4 analysis subagents in parallel:

1. Use code-smell-detector to identify refactoring opportunities
2. Use complexity-analyzer to measure code complexity
3. Use duplication-finder to find duplicate code
4. Use test-coverage-checker to assess test coverage
```

**For debugging workflow:**
```
I'll spawn 3 reproduction subagents in parallel:

1. Use bug-reproducer to document reproduction steps
2. Use environment-analyzer to capture environment context
3. Use log-analyzer to analyze error patterns
[4. Use state-inspector for reactive state bugs] (if stateful_bug)
```

**For improving workflow:**
```
I'll spawn 3 assessment subagents in parallel:

1. Use baseline-profiler to measure current performance
2. Use bottleneck-identifier to identify optimization opportunities
3. Use opportunity-scanner to scan for improvements
[4. Use ux-analyzer for UX improvements] (if ux_improvement)
```

**For quick workflow:**
```
I'll spawn 2 discovery subagents in parallel:

1. Use file-locator to find relevant files
2. Use pattern-checker to verify patterns
[3. Use dependency-mapper if integration needed]
```

### Gap Check After Phase 1

```
THINK - Phase 1 Quality Check:

1. Coverage
   - All relevant code discovered?
   - Patterns identified?
   - Dependencies mapped?

2. Completeness
   - Missing any critical areas?
   - Need additional investigation?

Decision: Proceed to Phase 2 or spawn additional agents?
```

---

## Phase 2: Requirements/Planning/Root-Cause

**Varies by workflow:**
- **new-feature:** requirements phase (user stories, technical requirements)
- **refactoring:** planning phase (refactor sequencing, technique selection)
- **debugging:** root-cause phase (hypothesis generation, code tracing)
- **improving:** planning phase (optimization design, impact estimation)

### Orchestration Strategy

Spawn subagents **simultaneously** based on workflow. Each reads from Phase 1 and writes to `.temp/phase2-{category}/`.

### Subagent Invocation Pattern (Workflow-Aware)

**For new-feature workflow:**
```
Based on Phase 1 discovery, I'll spawn 3-4 requirements subagents:

1. Use user-story-writer to write user stories (INVEST criteria)
2. Use technical-requirements-analyzer to document technical requirements
3. Use edge-case-identifier to identify edge cases
[4. Use integration-planner for multi-component features]
```

**For refactoring workflow:**
```
I'll spawn 3 planning subagents:

1. Use refactoring-sequencer to sequence refactor steps
2. Use technique-selector to select refactoring techniques
3. Use test-planner to plan testing strategy
[4. Use risk-mapper for high-risk refactorings]
```

**For debugging workflow:**
```
I'll spawn 3 root-cause analysis subagents:

1. Use hypothesis-generator to generate and prioritize hypotheses
2. Use code-tracer to trace execution paths
3. Use dependency-checker to verify dependency versions
[4. Use data-flow-analyzer for data bugs]
[5. Use timing-analyzer for timing/async bugs]
```

**For improving workflow:**
```
I'll spawn 3 planning subagents:

1. Use optimization-designer to design optimization approach
2. Use impact-estimator to estimate improvement impact
3. Use verification-planner to plan verification strategy
[4. Use rollout-planner for user-facing changes]
```

### Gap Check After Phase 2

```
THINK - Phase 2 Quality Check:

1. Design Clarity
   - Architecture well-defined?
   - Decisions documented?
   - Integration points clear?

2. Completeness
   - All dependencies mapped?
   - Impact understood?
   - Risks identified?

Decision: Ready for implementation planning?
```

---

## Phase 3: Design/Solution

**Varies by workflow:**
- **new-feature:** design phase (architecture design, implementation sequencing)
- **refactoring:** (combined with Phase 2)
- **debugging:** solution phase (fix design, regression checking)
- **improving:** (combined with Phase 2)

### Orchestration Strategy

Spawn planning subagents **simultaneously**. Each reads from Phases 1-2 and writes to `.temp/phase3-{category}/`.

### Subagent Invocation Pattern (Workflow-Aware)

**For new-feature workflow:**
```
I'll spawn 3-5 design subagents:

1. Use architecture-designer to design system architecture
2. Use implementation-sequencer to define implementation sequence
3. Use test-strategy-planner to plan testing approach
[4. Use ui-designer for UI design] (if --frontend or --both)
[5. Use api-designer for API design] (if --backend or --both)
```

**For debugging workflow:**
```
I'll spawn 2 solution subagents:

1. Use fix-designer to design fix implementation
2. Use regression-checker to plan regression testing
[3. Use alternative-evaluator for multiple fix options]
```

### Gap Check After Phase 3

```
THINK - Phase 3 Quality Check:

1. Actionability
   - Tasks clearly defined?
   - Dependencies ordered?
   - Estimates reasonable?

2. Completeness
   - All risks identified?
   - Verification steps included?
   - Success criteria clear?

Decision: Ready for finalization?
```

---

## Phase 4: Synthesis (Lead Agent)

**Runs for workflows:** ALL (required)
**Template:** Varies by workflow

### Synthesis Process (Workflow-Aware)

1. **Read All Research Findings**
   ```bash
   # Load all phase outputs
   view .claude/plans/[feature]/.temp/scope.md
   view .claude/plans/[feature]/.temp/phase1-*/
   view .claude/plans/[feature]/.temp/phase2-*/
   view .claude/plans/[feature]/.temp/phase3-*/
   ```

2. **Load Workflow-Specific Template**

   ```bash
   # Get template from workflow config
   template_name = workflow_config.template

   # Load template
   view ~/.claude/skills/planner/templates/${template_name}
   ```

   **Templates by workflow:**
   - **new-feature:** `templates/new-feature.md` (implementation plan)
   - **refactoring:** `templates/refactoring.md` (refactor strategy)
   - **debugging:** `templates/debugging.md` (debugging plan)
   - **improving:** `templates/improving.md` (optimization plan)
   - **quick:** `templates/quick.md` (rapid plan)

3. **Synthesize Plan**

   Create `.claude/plans/[feature]/plan.md` following the loaded template structure.

---

## Phase 5: Validation

**Runs for workflows:** new-feature, refactoring, debugging, improving (required)
**Skips for:** quick

### Validation Process

Spawn validation subagents based on workflow:

**For new-feature workflow:**
```
1. Use feasibility-validator to check plan viability
2. Use completeness-checker to verify all sections populated
[3. Use estimate-reviewer if --estimate flag]
```

**For refactoring/debugging/improving workflows:**
```
1. Use approach-validator to validate approach soundness
2. Use risk-assessor to assess risks
```

---

## Phase 6: Finalization

**Runs for workflows:** ALL (required)

### Finalization Actions

1. **Apply Critical Fixes** (if any from validation)

2. **Create Metadata**
   ```bash
   cat > .claude/plans/[feature]/metadata.json << 'EOF'
   {
     "feature": "[feature-name]",
     "workflow": "[workflow-type]",
     "created": "2025-10-29",
     "estimated_effort": "[effort estimate]",
     "complexity": "[simple/moderate/complex]",
     "subagents_used": X,
     "phases_completed": [list],
     "related_plans": [],
     "stack": ["Vue3", "TypeScript", "nanostore", "Tailwind CSS v4"]
   }
   EOF
   ```

3. **Create Archives Directory**
   ```bash
   mkdir -p .claude/plans/[feature]/archives
   ```

4. **Report to User**

   ```markdown
   ## Implementation Plan Complete: [feature-name]

   **Workflow:** [workflow-name]
   **Summary:**
   - X subagents across Y phases
   - Complexity: [Simple/Moderate/Complex]
   - Estimated effort: [effort]

   **Plan saved to:**
   - Main plan: [.claude/plans/[feature]/plan.md]
   - Metadata: [.claude/plans/[feature]/metadata.json]
   - Research: [.claude/plans/[feature]/.temp/] (preserved)

   [View Plan]
   ```

---

## Token Usage Expectations

- **Simple Feature** (~5 files): 40-80K tokens, 8-10 subagents
- **Moderate Feature** (~20 files): 80-150K tokens, 10-15 subagents
- **Complex Feature** (~50+ files): 150-250K tokens, 15-20 subagents

**Note:** Thoroughness and actionability prioritized over speed/efficiency.

---

## Best Practices Summary

### For Lead Agent
1. Always use **"think hard"** before strategic phases
2. Explicitly check gaps after each phase
3. Spawn 2-5 subagents in parallel per phase
4. Read all `.temp/` research before synthesis
5. Use workflow-specific templates

### For Subagent Delegation
1. Be explicit: "Use the [subagent-name] subagent to [specific task]"
2. Specify output location in delegation
3. Batch parallel invocations when independent
4. Reference previous phase outputs when needed
5. Use conditional subagents based on flags (--frontend, --backend)

### Tool Usage
- **Prefer:** `Grep` for text search (ripgrep)
- **Batch:** Multiple `Read` calls together when independent
- **Parallel:** Delegate to multiple subagents simultaneously
- **Context:** Use absolute paths, avoid directory changes

---

## Skill Directory Structure

```
~/.claude/skills/planner/
├── SKILL.md                    # This file
├── workflows/
│   └── registry.json           # Workflow definitions
├── phases/
│   └── phase-registry.json     # Phase definitions
├── subagents/
│   └── selection-matrix.json   # Subagent selection rules
├── templates/
│   ├── new-feature.md          # New feature template
│   ├── refactor.md             # Refactor template
│   ├── debug.md                # Debug template
│   ├── architecture.md         # Architecture template
│   └── review.md               # Review template
└── resources/
    └── orchestration.md        # Multi-agent patterns
```

All supporting files available via progressive disclosure.

---
description: Create implementation plans using workflow-specific multi-agent orchestration. Supports new features, debugging, refactoring, improvements, and quick planning.
argument-hint: new <feature-name> [Description: ...] [Workflow: ...] [Flags: --frontend|--backend|--both]
---

# Planning Command

Generate implementation plans for codebase tasks using workflow-specific multi-agent orchestration.

## Usage

```bash
/plans new <feature-name>
Description: <detailed explanation>
Workflow: <new-feature|debugging|refactoring|improving|quick>
Flags: --frontend | --backend | --both
```

**Defaults:**
- If no workflow specified: `new-feature`
- If no flag specified: `--frontend`

---

## Workflow Types

### 1. New Feature (default)
Comprehensive feature planning with PRD generation (40/60 planning-to-coding ratio).

**Best for:** Building new features or major functionality from scratch
**Time:** 30-90 minutes
**Tokens:** 30-100K
**Quality Gates:** 3

**Example:**
```bash
/plans new user-profile-dashboard
Description: Plan implementation of user profile dashboard with avatar upload, bio editing, and activity timeline
Flags: --both
```

**Phases:** plan → discovery → requirements → design → synthesis → validation → finalize

---

### 2. Debugging
Systematic bug investigation and resolution planning.

**Best for:** Investigating bugs or unexpected behavior systematically
**Time:** 20-60 minutes
**Tokens:** 20-80K
**Quality Gates:** 2

**Example:**
```bash
/plans new hydration-mismatch-fix
Description: Plan approach to debug SSR hydration mismatches in profile component
Workflow: debugging
Flags: --frontend
```

**Phases:** plan → reproduction → root-cause → solution → synthesis → validation → finalize

---

### 3. Refactoring
Controlled code improvement planning with small-step, behavior-preserving transformations.

**Best for:** Improving existing code structure before adding features
**Time:** 15-45 minutes
**Tokens:** 15-60K
**Quality Gates:** 2

**Example:**
```bash
/plans new form-components-refactor
Description: Plan consolidation of duplicate form input components into reusable pattern
Workflow: refactoring
Flags: --frontend
```

**Phases:** plan → analysis → planning → synthesis → validation → finalize

---

### 4. Improving
Targeted code/UX optimization planning with quality-driven enhancements.

**Best for:** Optimizing performance, quality, or UX of existing code
**Time:** 15-45 minutes
**Tokens:** 15-60K
**Quality Gates:** 2

**Example:**
```bash
/plans new search-performance-optimization
Description: Plan improvements to search response time and bundle size reduction
Workflow: improving
Flags: --frontend
```

**Phases:** plan → assessment → planning → synthesis → validation → finalize

---

### 5. Quick
Rapid sprint-style planning for quick tasks (15-minute planning).

**Best for:** Small features, bug fixes, or well-understood tasks
**Time:** 5-15 minutes
**Tokens:** 5-20K
**Quality Gates:** 0

**Example:**
```bash
/plans new add-tooltip-button
Description: Add tooltip to submit button explaining validation requirements
Workflow: quick
```

**Phases:** plan → discovery → synthesis → finalize

---

## What This Command Does

This command invokes the **planner** skill, which:

1. **Detects workflow type** from user input or defaults to `new-feature`
2. **Loads workflow configuration** from `~/.claude/skills/planner/workflows/registry.json`
3. **Executes workflow-specific phases** with appropriate subagents
4. **Spawns 2-15 specialized subagents** depending on workflow and complexity
5. **Uses workflow-specific template** for final plan formatting

### Subagent Categories (53 total)
- **Discovery** (7): Find existing code, patterns, dependencies
- **Analysis** (8): Requirements, user stories, edge cases, code quality
- **Design** (5): Architecture, sequencing, testing strategy
- **Debugging** (10): Reproduction, investigation, hypothesis generation
- **Refactoring** (3): Sequencing, technique selection, test planning
- **Improving** (7): Profiling, bottlenecks, optimization design
- **Validation** (10): Feasibility, completeness, safety, ROI
- **Shared** (3): Verification planning, rollout, risk mapping

---

## Output Location

Plans are created at:
```
[project]/.claude/plans/<feature-name>/
├── main.md                # Final implementation plan
├── metadata.json          # Plan metadata (workflow, effort, complexity)
├── .temp/                 # Research artifacts (preserved for reference)
│   ├── plan.md
│   ├── phase1-*/
│   ├── phase2-*/
│   └── phase3-*/
└── archives/              # Previous versions
```

---

## Examples

### Example 1: New Feature Planning
```bash
/plans new social-sharing
Description: Plan implementation of social sharing feature with Twitter, Facebook, LinkedIn integration and OG image generation
Flags: --both
```

**Result:** Comprehensive PRD with user stories, architecture, implementation roadmap, testing strategy

**Subagents used:** codebase-scanner, pattern-analyzer, user-story-writer, architecture-designer, ui-designer, api-designer, feasibility-validator

---

### Example 2: Debugging
```bash
/plans new performance-degradation
Description: Plan investigation of dashboard performance degradation under heavy data loads
Workflow: debugging
Flags: --both
```

**Result:** Systematic debugging plan with reproduction steps, hypothesis testing, fix options with tradeoffs

**Subagents used:** bug-reproducer, log-analyzer, hypothesis-generator, code-tracer, fix-designer, regression-checker

---

### Example 3: Refactoring
```bash
/plans new store-consolidation
Description: Plan consolidation of user-related stores into unified UserStore pattern
Workflow: refactoring
Flags: --frontend
```

**Result:** Refactor strategy with code smell analysis, incremental steps, safety validation

**Subagents used:** code-smell-detector, complexity-analyzer, duplication-finder, refactoring-sequencer, test-planner, safety-validator

---

### Example 4: Improving
```bash
/plans new bundle-size-reduction
Description: Plan optimization to reduce bundle size by 40% through code splitting and lazy loading
Workflow: improving
Flags: --frontend
```

**Result:** Improvement plan with baseline metrics, optimization strategy, ROI calculation

**Subagents used:** baseline-profiler, bottleneck-identifier, optimization-designer, impact-estimator, roi-validator

---

### Example 5: Quick
```bash
/plans new add-loading-state
Description: Add loading spinner to form submission button
Workflow: quick
```

**Result:** Lightweight task list with files to modify, implementation steps, testing notes

**Subagents used:** file-locator, pattern-checker

---

## Workflow Selection Guide

| Workflow | Use When | Token Range | Time | Subagents |
|----------|----------|-------------|------|-----------|
| **new-feature** | Building new features from scratch | 30-100K | 30-90 min | 8-12 |
| **debugging** | Investigating complex bugs systematically | 20-80K | 20-60 min | 6-10 |
| **refactoring** | Improving code structure safely | 15-60K | 15-45 min | 5-8 |
| **improving** | Optimizing performance/quality/UX | 15-60K | 15-45 min | 5-8 |
| **quick** | Small tasks, quick fixes | 5-20K | 5-15 min | 2-4 |

**Choose based on:**
- **Complexity:** How many files/components affected?
- **Research needed:** How much discovery required?
- **Risk level:** How critical is thoroughness vs speed?
- **Time available:** How much planning time can you invest?

---

## Processing Arguments

Parse the input to extract:

1. **Action**: Must be "new" (for creating new plans)
2. **Feature Name**: The feature/task to plan (required)
3. **Description**: Detailed explanation (required after "Description:")
4. **Workflow**: Optional workflow type (after "Workflow:")
5. **Flags**: Optional --frontend, --backend, or --both

### Parsing Logic

Input: $ARGUMENTS

Parse as:
  - First word: action ("new")
  - Second word: feature name
  - After "Description:": detailed description
  - After "Workflow:": workflow type (new-feature|debugging|refactoring|improving|quick)
  - After "Flags:": flag values

---

## Invoking the Skill

When this command is invoked, parse the arguments and then **explicitly invoke** the planner skill using the Skill tool.

**Implementation:**

```
After parsing arguments:
1. Extract feature name, description, workflow, and flags
2. Announce the plan to user
3. Invoke Skill tool with command: "planner"
```

**Response format before invoking skill:**

"I'll create [workflow-name] implementation plan for [feature-name].

**Feature:** [feature-name]
**Workflow:** [workflow-type]
**Scope:** [based on flags: frontend/backend/both]
**Description:** [user's description]

This will involve:
- [X] subagent invocations across [Y] phases
- [Workflow-specific approach description]
- Expected token usage: [N-M]K tokens
- Estimated time: [X-Y] minutes

Invoking planner skill..."

Then immediately use: `Skill tool with command: "planner"`

---

## Error Handling

### Invalid Workflow Type
If workflow type doesn't match options:
```
Error: Invalid workflow type "[type]"

Valid workflows: new-feature, debugging, refactoring, improving, quick

Example: /plans new user-dashboard
         Description: Plan user dashboard implementation
         Workflow: new-feature
```

### Missing Description
If description not provided:
```
Please provide a description of what to plan.

Example format:
/plans new authentication
Description: Plan implementation of OAuth authentication with Google and GitHub providers
Workflow: new-feature
```

### Plan Already Exists
If `.claude/plans/<feature-name>` already exists:
```
Plan for "[feature-name]" already exists.

Options:
1. Archive existing and regenerate: I can archive the current version and create fresh plan
2. View existing: [link to existing main.md]
3. Choose different feature name

What would you like to do?
```

---

## Integration with Skill System

This command works by describing the planning task in natural language that matches the **planner** skill's description triggers. The workflow is:

1. **Command receives:** User input via `/plans new <feature> Description: ... Workflow: ... Flags: ...`
2. **Command parses:** Extracts feature name, description, workflow, and flags
3. **Command outputs:** Natural language description of the planning task
4. **Claude recognizes:** The description matches the **planner** skill
5. **Skill activates:** Claude automatically invokes the skill using the Skill tool
6. **Skill orchestrates:** Workflow-specific multi-agent planning process begins

The skill is located at `~/.claude/skills/planner/SKILL.md` and automatically activates when Claude recognizes the planning task matches its description.

---

## Viewing Plans

After completion, users can:

```bash
# View in editor
open [project]/.claude/plans/<feature-name>/main.md

# Or if using Claude Code
view .claude/plans/<feature-name>/main.md
```

---

## Regenerating Plans

To update existing plans:
```bash
/plans new <same-feature-name>
Description: <updated description if needed>
Workflow: <same or different workflow>
```

The existing version will be archived to:
`.claude/plans/<feature-name>/archives/<timestamp>-main.md`

---

## Research Foundation

All workflows based on industry-standard methodologies:

- **new-feature:** 40/60 planning ratio, INVEST principles (dev.to, Microsoft Learn)
- **debugging:** Systematic debugging (ntietz.com, GeeksforGeeks)
- **refactoring:** Martin Fowler's workflows, Red-Green-Refactor TDD (martinfowler.com)
- **improving:** Workflow optimization, continuous improvement (Kissflow, Perforce)
- **quick:** Sprint planning timeboxing (Atlassian, Scrum.org)

---

## Troubleshooting

### Command Not Found
- Verify file exists at `~/.claude/commands/plans.md`
- Restart Claude Code session
- Check with `/help` to see if command listed

### Skill Not Loading
- Verify `~/.claude/skills/planner/SKILL.md` exists
- Check skill has proper YAML frontmatter with `name: planner`
- Verify workflow configs exist in `workflows/`, `phases/`, `subagents/`

### Wrong Workflow Executed
- Verify workflow name spelling (new-feature, debugging, refactoring, improving, quick)
- Check natural language doesn't conflict with workflow detection
- Explicitly specify with `Workflow:` parameter

---

*This command uses the planner skill with 5 research-backed workflows and 53 specialized subagents.*

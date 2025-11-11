# Workflow Creation and Modification Guide (v5)

**Purpose:** Meta-instructions for creating and modifying workflows in use-workflows-v2 system.

**Audience:** Future Claude Code sessions tasked with adding/modifying workflows.

**Version:** 5.0 (Phase-Centric Architecture)

---

## System Architecture Overview (v5)

### Core Principle

**Phases are self-contained, reusable modules.** Workflows coordinate phases without knowing their internals.

### Components

```
use-workflows-v2/
├── workflows/              # Workflow coordination (phase sequence + inputs + checkpoints)
├── phases/                 # Self-contained phase YAMLs (subagents + validation + behavior)
├── schemas/                # YAML schemas for validation
│   ├── phase-v5.yaml       # Phase structure definition
│   └── workflow-v5.yaml    # Workflow structure definition
├── lib/
│   └── prompt-generator.sh # Runtime prompt generation from YAML
├── generate-workflow.sh    # Main workflow generator
├── fetch-phase.sh          # Progressive disclosure (fetch phase details)
├── validate-phase.sh       # Phase YAML validator
└── validate-workflow.sh    # Workflow YAML validator
```

### Key Changes from v4

❌ **Removed:**
- Subagent template files (replaced by runtime generation)
- subagent_matrix in workflow YAMLs (moved to phase YAMLs)
- gap_checks in workflow YAMLs (moved to phase YAMLs)
- subagent_outputs in workflow YAMLs (moved to phase YAMLs)
- Phase template files (replaced by phase YAMLs)

✅ **Added:**
- Phase YAMLs with embedded subagent configs
- Runtime prompt generation
- base_dir in workflow YAMLs
- Input wiring between phases
- Validation scripts

### Execution Flow

```
Workflow YAML → generate-workflow.sh → Summary
                     ↓
              fetch-phase.sh → Phase Details
                     ↓
         lib/prompt-generator.sh → Subagent Prompts
```

1. User invokes: `bash generate-workflow.sh investigation-workflow user-auth --frontend`
2. Script loads `workflows/investigation-workflow.yaml`
3. Shows high-level summary with all phases
4. User fetches phase details: `bash fetch-phase.sh investigation-workflow 1 user-auth --frontend`
5. Phase details show subagent configs and execution instructions
6. Prompts generated dynamically from phase YAML + workflow context

---

## Creating a New Workflow

### Quick Checklist

- [ ] Create workflow YAML: `workflows/{name}.yaml`
- [ ] Define phase sequence with input wiring
- [ ] Define checkpoints (user approval points)
- [ ] Set base_dir for outputs
- [ ] Test validation: `bash validate-workflow.sh workflows/{name}.yaml`
- [ ] Test rendering: `bash generate-workflow.sh {name} test-feature --frontend`
- [ ] Verify phase details: `bash fetch-phase.sh {name} 1 test-feature --frontend`

**Note:** No need to create phase templates or subagent templates - those are now phase YAMLs with embedded configs!

---

## Workflow YAML Structure (v5)

### Minimal Example

```yaml
name: simple-workflow
description: "Brief description of what this workflow does"
estimated_time: "10-20 minutes"
estimated_tokens: "10K-30K"
complexity: simple

base_dir: ".temp"  # Output location (.temp, .claude/plans, etc.)

phases:
  - name: problem-understanding
    scope: default
    inputs: []  # First phase has no inputs

  - name: codebase-investigation
    scope: "{{workflow_scope}}"  # Inherits from user flag
    inputs:
      - from: problem-understanding
        files: [problem.md, constraints.json]
        context_description: "Problem definition to focus research"

checkpoints:
  - after: problem-understanding
    prompt: "Confirm understanding before research"
    show_files: []
    options:
      - "Proceed"
      - "Refine"
      - "Abort"

default_scope: "{{user_provided_scope}}"  # --frontend, --backend, --both
```

### Required Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `name` | string | Workflow identifier | `investigation-workflow` |
| `description` | string | What workflow does | `"Research and planning workflow"` |
| `estimated_time` | string | Time range | `"20-40 minutes"` |
| `estimated_tokens` | string | Token range | `"20K-60K"` |
| `base_dir` | string | Output directory | `".temp"` or `".claude/plans"` |
| `phases` | array | Phase sequence | See below |
| `checkpoints` | array | User approval points | See below |
| `default_scope` | string | Default scope value | `"{{user_provided_scope}}"` |

### Phases Array

Each phase object:

```yaml
- name: phase-name          # Must match phase YAML filename
  scope: default            # default, frontend, backend, both, {{workflow_scope}}
  inputs:                   # Files from previous phases
    - from: previous-phase  # Which phase to get files from
      files:                # List of files
        - output.json
        - analysis.md
      context_description: "What these files provide"
```

**Scope options:**
- `default` - No special scope handling
- `frontend` - Force frontend scope
- `backend` - Force backend scope
- `both` - Force fullstack scope
- `{{workflow_scope}}` - Inherit from user's --flag

### Input Wiring

Connect phases by declaring which files flow between them:

```yaml
phases:
  - name: discovery
    scope: default
    inputs: []

  - name: synthesis
    scope: default
    inputs:
      - from: discovery                    # Previous phase
        files: [patterns.json, files.json] # Specific files
        context_description: "Codebase patterns for solution generation"
```

**Best practices:**
- Only wire essential files (don't pass everything)
- Provide clear context_description for each input
- Files are relative to phase output directory

### Checkpoints

```yaml
checkpoints:
  - after: phase-name
    prompt: "Brief instruction to user"
    show_files:
      - "file.json"  # Relative to phase output dir
    options:
      - "Continue"
      - "Refine"
      - "Abort"
```

**When to add checkpoints:**
- After major decision points
- Before expensive operations
- When user input could change direction

**When NOT to add:**
- Quick workflows
- Between tightly coupled phases

---

## Phase YAMLs (v5)

### Phase Structure

Phases are now self-contained YAML files in `phases/`:

```yaml
# Phase: {Title} (v5)
# {Brief description}

name: phase-name
purpose: "Single sentence describing what this phase does"

# Which subagents to spawn
subagents:
  always: []              # Always spawn (any scope)
  conditional:            # Conditional on scope
    frontend: []          # Only with --frontend
    backend: []           # Only with --backend
    both: []              # Only with --both

# Subagent configurations (replaces templates)
subagent_configs:
  subagent-name:
    task_agent_type: "code-researcher"
    model: "sonnet"       # haiku, sonnet, opus
    thoroughness: "medium" # quick, medium, very thorough

    responsibility: |
      Core task description (1-2 sentences)

    instructions: |
      Step-by-step guidance:
      1. Do this
      2. Then this
      3. Output that

    scope_specific:
      frontend: |
        Frontend-specific guidance
      backend: |
        Backend-specific guidance
      both: |
        Fullstack guidance

    outputs:
      - file: output.json
        schema: output_templates/output.json.tmpl
        required: true
        description: "What this file contains"

# Validation criteria
gap_checks:
  criteria:
    - "Specific criterion 1"
    - "Specific criterion 2"
  on_failure:
    - "Retry with refinement"
    - "Continue with gaps"
    - "Abort workflow"

# What this phase produces for other phases
provides:
  - data_item_1
  - data_item_2

# Main agent responsibilities (if no subagents)
execution_notes: |
  Main agent tasks:
  1. Task description
  2. Output requirements

# Metadata
metadata:
  estimated_time: "10-15 minutes"
  complexity: "moderate"
  requires_user_input: false
```

### Reusing Existing Phases

Available phases in `phases/`:

**Investigation & Research:**
- `problem-understanding` - User conversation, requirements gathering
- `codebase-investigation` - Pattern discovery, code research
- `external-research` - Best practices, framework patterns
- `solution-synthesis` - Generate implementation approaches
- `introspection` - Validate assumptions with code-qa
- `approach-refinement` - Detailed planning for chosen approach

**Feature Development:**
- `discovery` - File location, pattern identification
- `requirements` - User stories, technical requirements
- `design` - Architecture planning
- `validation` - Feasibility and completeness checks

**Debugging:**
- `investigation` - Bug reproduction, environment analysis
- `analysis` - Root cause identification
- `solution` - Fix design and implementation

**Optimization:**
- `assessment` - Baseline metrics, bottleneck identification
- `planning` - Optimization sequencing and verification

---

## Creating a New Phase YAML

### Template

```yaml
# Phase: {Title} (v5)
# {Description}

name: new-phase-name
purpose: "{What this phase accomplishes}"

subagents:
  always:
    - primary-agent
  conditional:
    frontend:
      - ui-specific-agent

subagent_configs:
  primary-agent:
    task_agent_type: "code-researcher"
    model: "sonnet"
    thoroughness: "medium"

    responsibility: |
      What this agent does

    instructions: |
      1. Step-by-step instructions
      2. Clear, actionable guidance
      3. Expected output format

    scope_specific:
      frontend: "Frontend focus areas"
      backend: "Backend focus areas"

    outputs:
      - file: output.json
        required: true
        description: "Output description"

gap_checks:
  criteria:
    - "Measurable criterion"
    - "Verifiable check"
  on_failure:
    - "Retry option"
    - "Continue option"
    - "Abort"

provides:
  - output_data
  - analysis_results

metadata:
  estimated_time: "10-20 minutes"
  complexity: "moderate"
  requires_user_input: false
```

### Validation

```bash
bash validate-phase.sh phases/new-phase-name.yaml
```

Must pass validation before use.

---

## Modification Scenarios

### Adding a Phase to Workflow

**Steps:**
1. Add phase to `phases:` array in workflow YAML
2. Define input wiring (which files it needs from previous phases)
3. Validate: `bash validate-workflow.sh workflows/{name}.yaml`
4. Test: `bash generate-workflow.sh {name} test --frontend`

**Example:**

```yaml
# Before
phases:
  - name: discovery
    scope: default
    inputs: []

  - name: planning
    scope: default
    inputs:
      - from: discovery
        files: [patterns.json]

# After - added synthesis phase
phases:
  - name: discovery
    scope: default
    inputs: []

  - name: synthesis  # New phase
    scope: default
    inputs:
      - from: discovery
        files: [patterns.json, files.json]
        context_description: "Patterns to synthesize into approaches"

  - name: planning
    scope: default
    inputs:
      - from: synthesis  # Now reads from synthesis instead
        files: [approaches.json]
```

### Modifying Phase Behavior

**To modify a phase used by multiple workflows:**
Edit the phase YAML in `phases/`. Changes apply to ALL workflows using that phase.

**Example:** Add security scanning to codebase-investigation

```yaml
# In phases/codebase-investigation.yaml

subagents:
  always:
    - code-researcher
    - security-scanner  # Added

subagent_configs:
  security-scanner:  # Add new config
    task_agent_type: "security-scanner"
    responsibility: "Scan for security vulnerabilities"
    # ... rest of config
```

### Adding a Checkpoint

```yaml
checkpoints:
  - after: synthesis
    prompt: "Review proposed approaches before detailed planning"
    show_files:
      - "approaches.json"
    options:
      - "Continue to planning"
      - "Refine approaches"
      - "Abort"
```

### Changing Output Location

```yaml
# Default: .temp/
base_dir: ".temp"

# For long-term plans:
base_dir: ".claude/plans"

# For documentation:
base_dir: "docs/planning"
```

---

## Subagent Configuration

### In Phase YAML

```yaml
subagent_configs:
  agent-name:
    task_agent_type: "code-researcher"  # Task tool agent type
    model: "sonnet"                      # Optional: haiku, sonnet, opus
    thoroughness: "medium"                # Optional: quick, medium, very thorough

    responsibility: |
      Core task (1-2 sentences)

    instructions: |
      1. Detailed steps
      2. Clear guidance
      3. Expected format

    scope_specific:
      frontend: "Frontend focus"
      backend: "Backend focus"
      both: "Fullstack focus"

    outputs:
      - file: output.json
        schema: output_templates/schema.json.tmpl  # Optional
        required: true
        description: "What this outputs"
```

### Runtime Prompt Generation

Prompts are generated dynamically from YAML using `lib/prompt-generator.sh`:

```bash
bash lib/prompt-generator.sh \
  phases/codebase-investigation.yaml \
  code-researcher \
  my-feature \
  frontend \
  investigation-workflow \
  .temp \
  2 \
  codebase-investigation
```

**Generates:**
- Task header with context
- Responsibility statement
- Scope-specific guidance
- Step-by-step instructions
- Output requirements
- Complete Task tool prompt

---

## Testing and Validation

### Validate Workflow YAML

```bash
bash validate-workflow.sh workflows/my-workflow.yaml
```

**Checks:**
- Required fields present
- Phases array structure
- Input wiring syntax
- Checkpoints format
- No legacy v4 fields

### Validate Phase YAML

```bash
bash validate-phase.sh phases/my-phase.yaml
```

**Checks:**
- Required fields present
- Subagents structure
- Subagent configs complete
- Gap checks format
- Provides array

### Test Workflow Rendering

```bash
# Generate workflow summary
bash generate-workflow.sh my-workflow test-feature --frontend

# Fetch phase 1 details
bash fetch-phase.sh my-workflow 1 test-feature --frontend

# Fetch phase by name
bash fetch-phase.sh my-workflow codebase-investigation test-feature --frontend
```

### Batch Validation

```bash
# Validate all phases
bash validate-phase.sh --all phases

# Validate all workflows
for wf in workflows/*.yaml; do
  bash validate-workflow.sh "$wf"
done
```

---

## Variable Reference

### Available in Prompts

| Variable | Description | Example |
|----------|-------------|---------|
| `{{feature_name}}` | Feature being worked on | `user-auth` |
| `{{scope}}` | Current scope | `frontend` |
| `{{workflow_name}}` | Workflow type | `investigation-workflow` |
| `{{base_dir}}` | Output base directory | `.temp` |
| `{{phase_number}}` | Phase sequence number | `2` |
| `{{phase_name}}` | Phase identifier | `codebase-investigation` |
| `{{output_dir}}` | Full output path | `.temp/user-auth/phase-2-codebase-investigation` |

### Scope Values

| User Flag | Scope Value | Subagents Spawned |
|-----------|-------------|-------------------|
| (none) | `default` | `always` only |
| `--frontend` | `frontend` | `always` + `conditional.frontend` |
| `--backend` | `backend` | `always` + `conditional.backend` |
| `--both` | `both` | `always` + `conditional.both` |

---

## Best Practices

### DO ✅

- Reuse existing phases when possible
- Keep gap checks specific and measurable
- Wire only essential files between phases
- Provide clear context descriptions
- Use meaningful phase names
- Test validation before committing
- Document workflow purpose clearly
- Use runtime prompt generation (no templates!)

### DON'T ❌

- Create custom phase templates (use YAMLs)
- Hardcode file paths (use variables)
- Include subagent_matrix in workflow (moved to phases)
- Include gap_checks in workflow (moved to phases)
- Skip validation steps
- Create workflows without testing
- Use vague gap check criteria

---

## Migration from v4

If you have old v4 workflow:

### Remove These Fields

```yaml
# Remove from workflow YAML:
subagent_matrix: {...}      # Moved to phase YAMLs
subagent_outputs: {...}     # Moved to phase YAMLs
gap_checks: {...}           # Moved to phase YAMLs
template: templates/...     # No longer used
```

### Add These Fields

```yaml
# Add to workflow YAML:
base_dir: ".temp"

phases:
  - name: phase-name
    scope: default
    inputs:  # New: wire files between phases
      - from: previous-phase
        files: [output.json]
        context_description: "Description"
```

### Convert Phase Templates to YAMLs

Use existing phase YAMLs as reference. Extract:
1. Subagent configs from registry → `subagent_configs` section
2. Gap checks from workflow → `gap_checks` section
3. Execution notes from template → `execution_notes` section

---

## Example: Complete Workflow

```yaml
name: investigation-workflow
description: "Balanced investigation with codebase + external research"
estimated_time: "20-40 minutes"
estimated_tokens: "20K-60K"
complexity: moderate

base_dir: ".temp"

phases:
  - name: problem-understanding
    scope: default
    inputs: []

  - name: codebase-investigation
    scope: "{{workflow_scope}}"
    inputs:
      - from: problem-understanding
        files: [problem.md, constraints.json]
        context_description: "Problem definition to focus research"

  - name: external-research
    scope: default
    inputs:
      - from: problem-understanding
        files: [problem.md]
      - from: codebase-investigation
        files: [codebase-analysis.json]

  - name: solution-synthesis
    scope: default
    inputs:
      - from: codebase-investigation
        files: [codebase-analysis.json]
      - from: external-research
        files: [best-practices.md]

  - name: introspection
    scope: default
    inputs:
      - from: solution-synthesis
        files: [approaches.json]

  - name: approach-refinement
    scope: default
    inputs:
      - from: introspection
        files: [assumptions-validated.json, approaches-revised.json]

checkpoints:
  - after: problem-understanding
    prompt: "Confirm problem understanding before research"
    show_files: []
    options:
      - "Proceed to research"
      - "Refine problem statement"
      - "Abort"

  - after: introspection
    prompt: "Review assumption validation and revised approaches"
    show_files:
      - "approaches.json"
      - "assumptions-validated.json"
      - "approaches-revised.json"
    options:
      - "Continue with revised approach"
      - "Need more introspection"
      - "Revert to original approaches"
      - "Abort"

  - after: approach-refinement
    prompt: "Review refined approach before detailed planning"
    show_files:
      - "refined-approach.md"
    options:
      - "Continue to plan-writing-workflow"
      - "Refine further"
      - "Abort"

default_scope: "{{user_provided_scope}}"
```

---

## Troubleshooting

### "Workflow not found"
- Check filename matches workflow name
- Ensure file is in `workflows/` directory

### "Phase not found"
- Check phase name in workflow matches phase YAML filename
- Verify phase YAML exists in `phases/` directory

### Validation fails
- Read error message carefully
- Check against schema: `schemas/workflow-v5.yaml` or `schemas/phase-v5.yaml`
- Look at working examples in existing files

### Subagent not spawning
- Check `subagents` section in phase YAML
- Verify scope matches (always vs conditional)
- Ensure subagent_configs entry exists

---

## Quick Reference

### Workflow Lifecycle

```bash
# 1. Create workflow YAML
vim workflows/my-workflow.yaml

# 2. Validate
bash validate-workflow.sh workflows/my-workflow.yaml

# 3. Test summary
bash generate-workflow.sh my-workflow test --frontend

# 4. Test phase fetch
bash fetch-phase.sh my-workflow 1 test --frontend

# 5. Validate all phases used
bash validate-phase.sh --all phases
```

### File Locations

```
Workflow YAML:  workflows/{name}.yaml
Phase YAML:     phases/{phase-name}.yaml
Schemas:        schemas/phase-v5.yaml, schemas/workflow-v5.yaml
Validators:     validate-workflow.sh, validate-phase.sh
Generators:     generate-workflow.sh, fetch-phase.sh
Prompt Gen:     lib/prompt-generator.sh
```

---

**End of Guide**

For detailed architecture information, see `ARCHITECTURE_v5.md`.

For quick start guide, see `QUICKSTART_v5.md`.

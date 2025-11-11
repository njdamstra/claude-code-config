# Workflow YAML Schema Design

## Design Philosophy

### Core Principles
1. **Declarative, not imperative** - Define WHAT, not HOW
2. **Human-readable** - No JavaScript, no inline scripts
3. **Instruction-focused** - Generate instructions for Claude to follow
4. **Modular** - Reusable phases, subagents, templates
5. **Conditional** - Support scope flags (--frontend, --backend, --both)

### What We Eliminated
- ❌ Inline JavaScript scripts
- ❌ `main_agent.script` blocks
- ❌ Executable gap check scripts
- ❌ Complex state management (context.json)
- ❌ Auto-execution logic

### What We Added
- ✅ Simple phase arrays
- ✅ Subagent matrices with conditional logic
- ✅ Human-readable gap check criteria
- ✅ Copy-paste checkpoint prompts
- ✅ Metadata for planning (time, tokens, complexity)

---

## Schema Structure

### Top-Level Fields

```yaml
name: string                    # Workflow identifier (new-feature, refactoring, etc.)
description: string             # Human-readable description
estimated_time: string          # e.g., "30-90 minutes"
estimated_tokens: string        # e.g., "30K-100K"
complexity: string              # simple | moderate | complex

phases: array[string]           # List of phase IDs to execute

subagent_matrix:                # Subagents per phase, per scope
  {phase_id}:
    always: array[string]       # Always spawn these
    conditional:                # Conditional spawning
      frontend: array[string]
      backend: array[string]
      both: array[string]

gap_checks:                     # Quality checks per phase
  {phase_id}:
    criteria: array[string]     # Human-readable criteria
    on_failure: array[string]   # Options to present to user

checkpoints:                    # User approval points
  - after: string               # Phase ID
    prompt: string              # What to tell user
    show_files: array[string]   # Files to review (optional)
    options: array[string]      # Choices for user

template: string                # Final plan template path
```

---

## Field Specifications

### `name` (required)
- **Type:** string
- **Format:** lowercase-with-dashes
- **Examples:** `new-feature`, `refactoring`, `debugging`, `improving`, `quick`
- **Purpose:** Workflow identifier used in CLI and file paths

### `description` (required)
- **Type:** string
- **Format:** Plain text, sentence case
- **Purpose:** Human-readable explanation shown to user
- **Example:** "Comprehensive feature planning with PRD generation"

### `estimated_time` (required)
- **Type:** string
- **Format:** "{min}-{max} minutes" or "{min}-{max} hours"
- **Purpose:** Set user expectations
- **Examples:** "30-90 minutes", "15-45 minutes", "5-15 minutes"

### `estimated_tokens` (required)
- **Type:** string
- **Format:** "{min}K-{max}K" or "{min}M-{max}M"
- **Purpose:** Help user understand token budget
- **Examples:** "30K-100K", "15-60K", "5-20K"

### `complexity` (optional)
- **Type:** string
- **Enum:** simple | moderate | complex
- **Purpose:** Categorize workflow scope
- **Default:** moderate

### `phases` (required)
- **Type:** array of strings
- **Format:** Array of phase IDs (match files in phases/ directory)
- **Purpose:** Define execution sequence
- **Example:**
  ```yaml
  phases:
    - discovery
    - requirements
    - design
    - synthesis
    - validation
  ```
- **Valid phase IDs:** discovery, requirements, design, synthesis, validation, analysis, planning, reproduction, root-cause, solution, assessment

---

## Subagent Matrix Structure

### Purpose
Defines which subagents to spawn for each phase, with conditional logic based on scope flags.

### Schema
```yaml
subagent_matrix:
  {phase_id}:               # e.g., "discovery", "requirements"
    always:                 # Always spawn (all scopes)
      - subagent-type-1
      - subagent-type-2
    conditional:            # Conditional spawning
      frontend:             # Only if --frontend flag
        - frontend-subagent
      backend:              # Only if --backend flag
        - backend-subagent
      both:                 # Only if --both flag
        - integration-planner
```

### Example: New Feature Discovery
```yaml
subagent_matrix:
  discovery:
    always:
      - codebase-scanner
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
```

### Conditional Logic Rules
1. **No flag (default):** Only `always` subagents spawn
2. **--frontend:** `always` + `conditional.frontend` spawn
3. **--backend:** `always` + `conditional.backend` spawn
4. **--both:** `always` + `conditional.both` spawn (includes both frontend and backend)

### Subagent Type Naming
- Use lowercase-with-dashes
- Match template files: `subagents/{type}/{workflow}.md.tmpl`
- Match subagent registry: `subagents/registry.yaml`

---

## Gap Checks Structure

### Purpose
Define quality criteria to verify after each phase, with user-facing failure options.

### Schema
```yaml
gap_checks:
  {phase_id}:
    criteria: array[string]      # Human-readable checks
    on_failure: array[string]    # Options to present to user
```

### Example: Discovery Gap Check
```yaml
gap_checks:
  discovery:
    criteria:
      - "{{phase_dirs.discovery}}/codebase-scan.json"
      - "Each output file contains > 100 characters"
      - "codebase-scan.json has 'patterns' array with 5+ items"
      - "dependencies.json has 'integration_points' array"
      - "No hallucinated file paths (all paths are real)"
    on_failure:
      - "Retry discovery phase with refined scope"
      - "Spawn additional targeted agents for missing areas"
      - "Continue with gaps noted in metadata"
      - "Abort workflow"
```

### Criteria Guidelines
- Be specific and measurable
- Reference exact file paths
- Check both existence and content quality
- Include common failure modes (hallucination, empty files)
- Keep criteria count reasonable (3-6 per phase)

### On Failure Options
- Present as numbered list to user
- Include retry option
- Include continue-anyway option
- Include abort option
- Optionally include targeted fixes ("Spawn X agent for Y")

---

## Checkpoints Structure

### Purpose
Define user approval points where Claude presents findings and waits for direction.

### Schema
```yaml
checkpoints:
  - after: string                # Phase ID (when to trigger)
    prompt: string               # What to tell user
    show_files: array[string]    # Files to review (optional)
    options: array[string]       # Choices for user
```

### Example: Discovery Checkpoint
```yaml
checkpoints:
  - after: discovery
    prompt: "Discovery phase complete. Review findings before proceeding to requirements."
    show_files:
      - "{{phase_dirs.discovery}}/codebase-scan.json"
      - "{{phase_dirs.discovery}}/patterns.json"
      - "{{phase_dirs.discovery}}/dependencies.json"
    options:
      - "Continue to requirements phase"
      - "Repeat discovery with refined scope"
      - "Skip to design phase (fast-track)"
      - "Abort workflow"
```

### Checkpoint Guidelines
- Trigger after major phases (discovery, design, validation)
- Keep prompt concise (1-2 sentences)
- Show 2-4 key files for review
- Provide 3-5 clear options
- Include "Continue", "Repeat", and "Abort" options
- Option order: Continue, Repeat/Modify, Skip, Abort

### Variable Substitution in show_files
- `{{output_dir}}` - Replaced with `.temp/{feature-name}`
- `{{feature_name}}` - Replaced with actual feature name
- Use relative paths from output_dir

---

## Template Field

### Purpose
Specify which template to use for final plan generation.

### Schema
```yaml
template: string    # Path to template file
```

### Example
```yaml
template: templates/new-feature-plan.md.tmpl
```

### Template Guidelines
- Store templates in `templates/` directory
- Use `.md.tmpl` extension
- Support Mustache-style variables: `{{variable}}`
- Templates define final plan.md structure
- One template per workflow type

---

## Complete Schema Example

### New Feature Workflow
```yaml
name: new-feature
description: Comprehensive feature planning with PRD generation (40/60 planning-to-coding ratio)
estimated_time: 30-90 minutes
estimated_tokens: 30K-100K
complexity: moderate

phases:
  - discovery
  - requirements
  - design
  - synthesis
  - validation

subagent_matrix:
  discovery:
    always:
      - codebase-scanner
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

  requirements:
    always:
      - user-story-writer
      - technical-requirements-analyzer
      - edge-case-identifier
    conditional:
      both:
        - integration-planner

  design:
    always:
      - architecture-designer
      - implementation-sequencer
      - test-strategy-planner
    conditional:
      frontend:
        - ui-designer
      backend:
        - api-designer
      both:
        - ui-designer
        - api-designer

  validation:
    always:
      - feasibility-validator
      - completeness-checker

gap_checks:
  discovery:
    criteria:
      - "All subagent output files exist"
      - "Each file > 100 characters"
      - "At least 5 patterns identified"
      - "Integration points documented"
    on_failure:
      - "Retry discovery with refined scope"
      - "Spawn additional targeted agents"
      - "Continue with gaps noted"
      - "Abort workflow"

  requirements:
    criteria:
      - "User stories follow INVEST criteria"
      - "Technical requirements are specific"
      - "Edge cases documented with examples"
      - "All requirements map to discovery findings"
    on_failure:
      - "Retry requirements phase"
      - "Continue with warnings"
      - "Abort workflow"

  design:
    criteria:
      - "Architecture is well-defined and viable"
      - "Implementation steps are actionable"
      - "Dependencies are mapped and sequenced"
      - "Test strategy is comprehensive"
    on_failure:
      - "Retry design phase"
      - "Continue with warnings"
      - "Abort workflow"

checkpoints:
  - after: discovery
    prompt: "Review discovery findings before proceeding to requirements"
    show_files:
      - "{{phase_dirs.discovery}}/codebase-scan.json"
      - "{{phase_dirs.discovery}}/patterns.json"
      - "{{phase_dirs.discovery}}/dependencies.json"
    options:
      - "Continue to requirements"
      - "Repeat discovery"
      - "Skip to design"
      - "Abort"

  - after: validation
    prompt: "Review validation results before finalizing plan"
    show_files:
      - "{{output_dir}}/phase-validation/feasibility.json"
      - "{{output_dir}}/phase-validation/completeness.json"
      - "{{output_dir}}/synthesis.md"
    options:
      - "Finalize plan"
      - "Repeat design phase"
      - "Abort"

template: templates/new-feature-plan.md.tmpl
```

---

## Validation Rules

### Required Fields
- `name`
- `description`
- `estimated_time`
- `estimated_tokens`
- `phases` (must have at least 1)
- `subagent_matrix` (must cover all phases)
- `template`

### Optional Fields
- `complexity`
- `gap_checks`
- `checkpoints`

### Validation Checks
1. All phases have subagent_matrix entries
2. All checkpoint `after` values reference valid phases
3. All template paths exist
4. Subagent types exist in subagents/registry.yaml
5. No duplicate checkpoint triggers
6. Options arrays have 2-5 items

---

## Usage in Generator Script

### Parsing
```bash
# Load YAML
workflow_json=$(yq eval -o=json workflows/new-feature.yaml)

# Extract fields
name=$(echo "$workflow_json" | jq -r '.name')
phases=($(echo "$workflow_json" | jq -r '.phases[]'))
```

### Subagent Selection
```bash
# Get subagents for phase + scope
get_phase_subagents() {
  local phase=$1
  local scope=$2  # frontend | backend | both | default

  # Get always subagents
  local always=$(echo "$workflow_json" | jq -r ".subagent_matrix.${phase}.always[]")

  # Get conditional based on scope
  if [[ "$scope" != "default" ]]; then
    local conditional=$(echo "$workflow_json" | jq -r ".subagent_matrix.${phase}.conditional.${scope}[]")
    echo "$always $conditional"
  else
    echo "$always"
  fi
}
```

### Gap Check Rendering
```bash
# Render gap check criteria as markdown checklist
render_gap_check() {
  local phase=$1
  local criteria=$(echo "$workflow_json" | jq -r ".gap_checks.${phase}.criteria[]")

  echo "## Gap Check"
  echo ""
  echo "Verify:"
  while IFS= read -r criterion; do
    echo "- [ ] $criterion"
  done <<< "$criteria"
}
```

---

## Migration from Old Schema

### Old Schema (Bash Engine)
```yaml
phases:
  - id: discovery
    behavior: parallel
    subagents:
      - type: codebase-scanner
        config:
          output_path: "phase-01-discovery/codebase-scan.json"
    gap_check:
      enabled: true
      script: |
        const files = context.deliverables.filter(...);
        return { status: 'complete' };
```

### New Schema (Instruction Generator)
```yaml
phases:
  - discovery

subagent_matrix:
  discovery:
    always:
      - codebase-scanner

gap_checks:
  discovery:
    criteria:
      - "All subagent output files exist"
```

### Key Differences
1. **Phases:** Array of strings instead of complex objects
2. **Subagents:** Matrix structure with conditional logic
3. **Gap checks:** Human-readable criteria instead of scripts
4. **No config objects:** Configuration moves to subagent registry
5. **No inline scripts:** All logic becomes instructions

---

## Design Rationale

### Why Simple Phase Arrays?
- Phase definitions are templates (phases/discovery.md)
- Workflow YAML just lists which phases to use
- Reduces duplication (phase logic defined once)

### Why Subagent Matrix?
- Clear separation: always vs conditional
- Easy to understand scope logic
- Supports complex conditional patterns (both = frontend + backend)

### Why Human-Readable Gap Checks?
- Claude verifies criteria manually
- User-friendly failure messages
- No complex script debugging
- Easier to maintain and extend

### Why Separate Checkpoints?
- Explicit control over approval points
- Clear user experience definition
- Easy to see workflow decision points
- Decoupled from phase execution

---

## Next Steps

1. Create 5 workflow YAML files using this schema:
   - workflows/new-feature.yaml
   - workflows/refactoring.yaml
   - workflows/debugging.yaml
   - workflows/improving.yaml
   - workflows/quick.yaml

2. Document schema in README

3. Create validation script to check YAML correctness


## Conditional Subagent Syntax

Workflows support conditional subagent inclusion based on custom flags passed via CLI.

### Conditional Matrix Structure

```yaml
subagent_matrix:
  design:
    always:
      - architecture-specialist
    conditional:
      complexity=high:
        - detailed-architecture-specialist
      ui=true:
        - ui-designer
      api=true:
        - api-designer
```

### How Conditionals Work

1. User passes flag: `--complexity=high`
2. Script extracts condition: `{"key": "complexity", "value": "high"}`
3. Matcher checks `conditional.complexity=high` in YAML
4. Adds `detailed-architecture-specialist` to phase subagents

### Example CLI Usage

```bash
# Activates complexity=high conditional
bash generate-workflow-instructions.sh new-feature-plan example --complexity=high

# Multiple conditions
bash generate-workflow-instructions.sh new-feature-plan example --complexity=high --ui=true
```

### Condition Extraction Rules

- Format: `--key=value`
- Ignored flags: `--frontend`, `--backend`, `--both`, `--base-dir`, `--summary`
- Multiple conditions combined with AND logic
- Values are string-matched exactly


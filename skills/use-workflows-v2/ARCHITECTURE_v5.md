# Workflow System v5 - Architecture Documentation

**Date:** 2025-01-06
**Version:** 5.0
**Status:** Implementation in progress

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [Architecture Overview](#architecture-overview)
3. [Component Responsibilities](#component-responsibilities)
4. [Phase YAML Structure](#phase-yaml-structure)
5. [Workflow YAML Structure](#workflow-yaml-structure)
6. [Execution Flow](#execution-flow)
7. [Prompt Generation](#prompt-generation)
8. [Benefits Over v4](#benefits-over-v4)
9. [Migration Guide](#migration-guide)
10. [Examples](#examples)

---

## Core Principles

### 1. Phases are Self-Contained Modules

**In v5, a phase is a black box with a clear interface:**

- **Inputs:** Files from previous phases (via workflow wiring)
- **Processing:** Subagents + main agent work (owned by phase)
- **Outputs:** Deliverable files in output directory
- **Contract:** `provides[]` declares what data is available for next phases
- **Validation:** Gap checks verify phase success

### 2. Workflows are Pure Coordination

**Workflows don't know HOW phases work, only:**

- **What:** Which phases to run
- **When:** Sequence and dependencies
- **Where:** Output base directory
- **Wiring:** Which files to pass between phases
- **Gates:** User approval checkpoints

### 3. Configuration Over Templates

**v4:** 26 phase templates + 51+ subagent templates = 77+ files
**v5:** 26 phase YAMLs + 1 generic executor = 27 files

Data-driven generation eliminates template duplication.

### 4. Explicit Interfaces

**Phase interface:**
```yaml
provides: [data_item1, data_item2]
```

**Workflow wiring:**
```yaml
inputs:
  - from: previous-phase
    files: [file1.json, file2.md]
```

Type-safe, discoverable, validatable.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Workflow YAML (v5)                      │
│  - Phase sequence                                           │
│  - Input wiring (phase → phase)                            │
│  - Checkpoints                                              │
│  - Base directory                                           │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ References
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                      Phase YAML (v5)                        │
│  - Subagent matrix (always/conditional)                    │
│  - Subagent configs (responsibility, instructions, scope)  │
│  - Gap checks (criteria, on_failure)                       │
│  - Provides (interface contract)                           │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Consumed by
                       ▼
┌─────────────────────────────────────────────────────────────┐
│               Prompt Generator (Runtime)                    │
│  - Reads phase YAML + subagent config                      │
│  - Combines responsibility + instructions + scope_specific │
│  - Embeds output schema                                    │
│  - Formats input files                                     │
│  → Generates complete subagent prompt                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Feeds into
                       ▼
┌─────────────────────────────────────────────────────────────┐
│           Generic Phase Executor Template                  │
│  - Reads phase YAML dynamically                            │
│  - Displays context files                                  │
│  - Renders subagent configurations                         │
│  - Includes generated prompts                              │
│  - Handles gap checks + checkpoints                        │
│  → Works for ANY phase                                     │
└─────────────────────────────────────────────────────────────┘
```

---

## Component Responsibilities

### Phase YAML (`phases-v5/{name}.yaml`)

**Owns:**
- Subagent selection (always + conditional based on scope)
- Subagent configuration (responsibility, instructions, scope_specific)
- Output specifications (file, schema, description)
- Gap check criteria and options
- Interface contract (`provides[]`)

**Does NOT know:**
- Which workflow is using it
- Where outputs will be stored (workflow controls `base_dir`)
- What specific inputs it will receive (workflow wires inputs)

### Workflow YAML (`workflows-v5/{name}.yaml`)

**Owns:**
- Phase sequence (order of execution)
- Input wiring (which files flow between phases)
- Output location (`base_dir`)
- User checkpoints (approval gates)
- Scope defaults

**Does NOT know:**
- Which subagents run in phases
- How phases validate success
- What phases output (uses `provides[]` for discovery)

### Prompt Generator (`lib/prompt-generator-v5.sh`)

**Responsibilities:**
- Read phase YAML + subagent config
- Extract: responsibility, instructions, scope_specific guidance
- Format: input files list, output schema
- Generate: complete, cohesive subagent prompt
- Replace: 51+ subagent template files

### Phase Executor (`lib/phase-executor.md.tmpl`)

**Responsibilities:**
- Generic template that works for ANY phase
- Reads phase YAML dynamically at runtime
- Displays available context files
- Renders subagent configurations
- Includes generated prompts
- Handles gap checks and checkpoints
- Replace: 26 phase-specific templates

---

## Phase YAML Structure

See `schemas/phase-v5.yaml` for the complete schema.

### Minimal Example

```yaml
name: codebase-investigation
purpose: "Scan codebase for patterns and dependencies"

subagents:
  always:
    - code-researcher
  conditional: {}

subagent_configs:
  code-researcher:
    task_agent_type: "code-researcher"
    responsibility: "Research codebase for patterns"

    instructions: |
      1. Read problem.md
      2. Search for patterns
      3. Output findings

    scope_specific:
      frontend: "Focus on Vue components"
      backend: "Focus on API routes"

    inputs_to_read:
      - from_workflow: true
        description: "Problem definition"

    outputs:
      - file: codebase-analysis.json
        schema: output_templates/codebase-analysis.json.tmpl
        required: true

gap_checks:
  criteria:
    - "At least 5 patterns identified"
  on_failure:
    - "Retry with broader scope"
    - "Continue anyway"

provides:
  - codebase_patterns
  - dependency_map
```

### Key Sections

#### 1. Subagent Matrix

```yaml
subagents:
  always: [agents that ALWAYS run]
  conditional:
    frontend: [run with --frontend]
    backend: [run with --backend]
    both: [run with --both]
    complex: [run for complex features]
```

#### 2. Subagent Configuration

```yaml
subagent_configs:
  agent-name:
    task_agent_type: "code-researcher"  # Task tool agent type
    model: "sonnet"                     # Optional
    thoroughness: "medium"              # Optional

    responsibility: |                   # Core task description
      Multi-line description of what this subagent does

    instructions: |                     # Step-by-step guidance
      1. Step one
      2. Step two

    scope_specific:                     # Replaces workflow-specific templates
      frontend: "Frontend-specific guidance"
      backend: "Backend-specific guidance"
      both: "Full-stack guidance"

    inputs_to_read:                     # Context files
      - from_workflow: true
        expected_files: [problem.md]
        description: "What these files contain"

    outputs:                            # What this subagent produces
      - file: output.json
        schema: output_templates/output.json.tmpl
        required: true
        description: "What this file contains"
```

#### 3. Gap Checks

```yaml
gap_checks:
  criteria:                             # Success criteria
    - "Criterion 1"
    - "Criterion 2"

  on_failure:                           # Options if criteria not met
    - "Retry with refinement"
    - "Continue anyway"
    - "Abort workflow"
```

#### 4. Provides Contract

```yaml
provides:                               # Data available for next phases
  - data_item_1
  - data_item_2
```

---

## Workflow YAML Structure

See `schemas/workflow-v5.yaml` for the complete schema.

### Minimal Example

```yaml
name: investigation-workflow
description: "Balanced investigation with research"
estimated_time: 20-40 minutes
estimated_tokens: 20K-60K

base_dir: ".temp"

phases:
  - name: problem-understanding
    scope: default
    inputs: []

  - name: codebase-investigation
    scope: "{{workflow_scope}}"
    inputs:
      - from: problem-understanding
        files: [problem.md]
        context_description: "Problem to focus research"

checkpoints:
  - after: problem-understanding
    prompt: "Confirm problem understanding"
    show_files: []
    options:
      - "Proceed"
      - "Refine"

default_scope: "{{user_provided_scope}}"
```

### Key Sections

#### 1. Base Directory

```yaml
base_dir: ".temp"
```

Final path: `{base_dir}/{feature-name}/phase-{N}-{phase-name}/`

Examples:
- `.temp` → `.temp/user-auth/phase-1-discovery/`
- `.claude/plans` → `.claude/plans/new-feature/phase-1-requirements/`

#### 2. Phase Execution Config

```yaml
phases:
  - name: phase-id              # References phases-v5/{name}.yaml
    scope: "{{workflow_scope}}" # Use user --frontend/--backend flag
    inputs:                     # Files from previous phases
      - from: previous-phase
        files: [file1.md, file2.json]
        context_description: "What these contain"
```

#### 3. Checkpoints

```yaml
checkpoints:
  - after: phase-id
    prompt: "User prompt message"
    show_files: [file1.json, file2.md]  # Filenames only
    options:
      - "Option 1"
      - "Option 2"
```

---

## Execution Flow

### 1. User Invocation

```bash
bash generate-workflow-v5.sh investigation-workflow user-auth --frontend
```

### 2. Workflow Loading

1. Load `workflows-v5/investigation-workflow.yaml`
2. Extract: phases, base_dir, checkpoints, default_scope
3. Resolve scope: `--frontend` flag

### 3. For Each Phase

#### A. Load Phase YAML

1. Load `phases-v5/{phase-name}.yaml`
2. Extract: subagents, subagent_configs, gap_checks, provides

#### B. Resolve Subagents

```bash
# Always agents
always_agents = phase.subagents.always

# Conditional agents (based on scope)
conditional_agents = phase.subagents.conditional[scope]

# Combined
all_agents = always_agents + conditional_agents
```

#### C. Generate Prompts

For each subagent:

```bash
bash lib/prompt-generator-v5.sh \
  phases-v5/codebase-investigation.yaml \
  code-researcher \
  user-auth \
  frontend \
  investigation-workflow \
  .temp \
  2 \
  codebase-investigation \
  '[{"from":"problem-understanding","file":"problem.md","phase_dir":"phase-1-problem-understanding"}]'
```

#### D. Render Phase Instructions

```bash
# Build Mustache data JSON
phase_data=$(build_phase_data_json \
  phase_yaml \
  workflow_yaml \
  phase_number \
  scope \
  input_files)

# Render generic executor
render_template \
  lib/phase-executor.md.tmpl \
  "$phase_data"
```

#### E. Execute Phase

1. Claude reads phase instructions
2. Spawns subagents with generated prompts
3. Waits for completion
4. Validates outputs
5. Runs gap checks
6. Presents checkpoint (if configured)

### 4. Phase Transition

1. Phase completes, outputs written to `base_dir/feature-name/phase-N-name/`
2. Next phase receives files via workflow inputs wiring
3. Process repeats

### 5. Workflow Completion

All phases complete → Final deliverables in `base_dir/feature-name/`

---

## Prompt Generation

### Input (Phase YAML)

```yaml
subagent_configs:
  code-researcher:
    task_agent_type: "code-researcher"
    responsibility: |
      Research codebase for patterns and dependencies

    instructions: |
      1. Read problem.md
      2. Search for patterns
      3. Output findings

    scope_specific:
      frontend: "Focus on src/components/, src/stores/"
      backend: "Focus on functions/, src/pages/api/"

    outputs:
      - file: codebase-analysis.json
        schema: output_templates/codebase-analysis.json.tmpl
```

### Output (Generated Prompt)

```markdown
# Task Context for code-researcher

You are supporting the **investigation-workflow** for feature: **user-auth**.

**Phase:** codebase-investigation (Phase 2)
**Scope:** frontend

---

## Your Task

Research codebase for patterns and dependencies

---

## Input Context

Read the following context files:
- `.temp/user-auth/phase-1-problem-understanding/problem.md`

---

## Instructions

1. Read problem.md
2. Search for patterns
3. Output findings

---

## Scope-Specific Focus

Focus on src/components/, src/stores/

---

## Output Deliverable

Write findings to: `.temp/user-auth/phase-2-codebase-investigation/codebase-analysis.json`

### Expected Format

```json
{...schema from template...}
```

Output Location: `.temp/user-auth/phase-2-codebase-investigation/codebase-analysis.json`
```

---

## Benefits Over v4

| Aspect | v4 | v5 | Improvement |
|--------|----|----|-------------|
| **Configuration** | Scattered across workflow YAML, phase templates, subagent templates | Centralized in phase YAML | Single source of truth |
| **Reusability** | Phase behavior tied to workflow | Phase is black box, works in any workflow | True modularity |
| **File Count** | 26 phase templates + 51+ subagent templates = 77+ files | 26 phase YAMLs + 1 executor = 27 files | 65% reduction |
| **Maintainability** | Edit 4+ files to change subagent behavior | Edit 1 phase YAML | Localized changes |
| **Workflow Clarity** | 150 lines of config + coordination | 50 lines of pure coordination | 66% simpler |
| **Prompt Generation** | Template files with Mustache | Runtime generation from YAML | No template duplication |
| **Interface** | Implicit (inspect code) | Explicit `provides[]` | Type-safe wiring |
| **Base Directory** | Hardcoded in templates | Workflow-controlled `base_dir` | Flexible output locations |

---

## Migration Guide

### From v4 to v5

#### 1. Phase Migration

**v4:** `phases/discovery.md` (template)
**v5:** `phases-v5/discovery.yaml` (config)

**Extract:**
1. Subagent matrix from workflow YAML → `subagents:` section
2. Subagent templates → `subagent_configs:` section
3. Gap checks from workflow YAML → `gap_checks:` section
4. Define `provides:` based on phase outputs

#### 2. Workflow Migration

**v4:** `workflows/investigation-workflow.yaml`
**v5:** `workflows-v5/investigation-workflow.yaml`

**Changes:**
1. Add `base_dir:` (e.g., ".temp")
2. Add `inputs:` wiring for each phase
3. Remove `subagent_matrix:`
4. Remove `subagent_outputs:`
5. Remove `gap_checks:`
6. Remove `template:`

#### 3. Validation

```bash
bash validate-phase-v5.sh phases-v5/discovery.yaml
bash validate-workflow-v5.sh workflows-v5/investigation-workflow.yaml
```

---

## Examples

### Complete Phase Example

See: `phases-v5/codebase-investigation.yaml` (created in Phase 2)

### Complete Workflow Example

See: `workflows-v5/investigation-workflow.yaml` (created in Phase 2)

### Generating a Prompt

```bash
bash lib/prompt-generator-v5.sh \
  phases-v5/codebase-investigation.yaml \
  code-researcher \
  user-auth \
  frontend \
  investigation-workflow \
  .temp \
  2 \
  codebase-investigation
```

---

## Directory Structure (v5)

```
use-workflows-v2/
├── schemas/
│   ├── phase-v5.yaml              # Phase YAML schema
│   └── workflow-v5.yaml           # Workflow YAML schema
├── phases-v5/
│   ├── problem-understanding.yaml
│   ├── codebase-investigation.yaml
│   ├── requirements.yaml
│   └── ... (26 total)
├── workflows-v5/
│   ├── investigation-workflow.yaml
│   ├── new-feature-plan.yaml
│   └── ... (10 total)
├── output_templates/              # Unchanged from v4
│   ├── codebase-analysis.json.tmpl
│   └── ...
├── lib/
│   ├── prompt-generator-v5.sh     # NEW: Generates prompts
│   ├── phase-executor.md.tmpl     # NEW: Generic executor
│   ├── workflow-parser.sh         # Updated for v5
│   ├── scope-detector.sh          # Unchanged
│   └── template-renderer.sh       # Updated for v5
├── generate-workflow-v5.sh        # NEW: v5 entry point
├── fetch-phase-v5.sh              # NEW: v5 progressive disclosure
├── validate-phase-v5.sh           # NEW: Phase validator
├── validate-workflow-v5.sh        # NEW: Workflow validator
└── ARCHITECTURE_v5.md             # This document
```

---

## Next Steps

1. **Phase 2:** Create proof-of-concept (codebase-investigation phase + investigation workflow)
2. **Phase 3:** Analyze and extract all 26 subagent configs
3. **Phase 4-5:** Migrate all phases to v5 YAMLs
4. **Phase 6:** Migrate all workflows to v5 YAMLs
5. **Phase 7:** Build v5 scripts (generate, fetch)
6. **Phase 8:** Test and validate
7. **Phase 9:** Documentation
8. **Phase 10:** Cutover and cleanup

---

## Conclusion

v5 architecture delivers:
- **Modularity:** Phases are reusable black boxes
- **Clarity:** Workflows are pure coordination
- **Efficiency:** 65% fewer files, no duplication
- **Maintainability:** Single source of truth per phase
- **Flexibility:** Workflow-controlled output locations
- **Type Safety:** Explicit `provides[]` interfaces

This foundation enables rapid workflow creation through phase composition.

---

**Status:** Foundation complete (Phase 1). Proceeding to proof-of-concept (Phase 2).

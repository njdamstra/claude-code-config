# Workflow Engine v2 - Implementation Plan (Enhanced)

## Executive Summary

This plan details the complete implementation of the Hybrid Workflow Engine v2 for Claude Code skills environment. The engine enables declarative YAML workflow definitions with inline scripting, supporting strict/loose/adaptive execution modes, human-in-the-loop checkpoints, dynamic subagent orchestration, and skills integration.

**Estimated Effort:** 14-16 days (increased for proper documentation)
**Complexity:** High
**Risk Level:** Medium (backward compatibility required)

**Key Enhancements:**
- MVP execution path documented first
- Comprehensive data models defined
- Execution mode logic clearly specified
- Checkpoint and gap-check flows detailed
- Inline scripting API documented
- Testing matrix established
- Workflow authoring support planned

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Phase 0: Foundation & Design](#phase-0-foundation--design-days-1-2)
3. [Phase 1: MVP Implementation](#phase-1-mvp-implementation-days-3-5)
4. [Phase 2: Advanced Features](#phase-2-advanced-features-days-6-8)
5. [Phase 3: Workflows & Templates](#phase-3-workflows--templates-days-9-11)
6. [Phase 4: Testing & Documentation](#phase-4-testing--documentation-days-12-14)
7. [Phase 5: Launch & Migration](#phase-5-launch--migration-days-15-16)

---

## Architecture Overview

### System Components

```
Workflow Engine v2 Architecture

┌─────────────────────────────────────────────────────────────┐
│                    Main Agent (Coordinator)                  │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                  Workflow Engine Core                        │
│  • YAML Loader                                              │
│  • Phase Executor (Strict/Loose/Adaptive)                   │
│  • Behavior Coordinator (Parallel/Sequential/Main-Only)      │
│  • Checkpoint Handler (Human-in-Loop)                       │
│  • Gap Check Manager                                        │
│  • Context Manager                                          │
│  • Script Interpreter                                       │
└───────────────┬─────────────────────────────────────────────┘
                │
    ┌───────────┼───────────┬──────────────┐
    │           │           │              │
    ▼           ▼           ▼              ▼
┌────────┐  ┌────────┐  ┌─────────┐  ┌──────────┐
│Subagent│  │Subagent│  │ Skills  │  │Templates │
│ Pool   │  │Prompts │  │Invoker  │  │ Renderer │
└────────┘  └────────┘  └─────────┘  └──────────┘
```

### MVP Execution Path (Core Loop)

```
1. Load YAML Workflow
   ├─ Parse YAML → JSON
   ├─ Validate schema
   └─ Extract phases, metadata

2. Initialize Context
   ├─ Create .temp/ directory
   ├─ Initialize context.json
   └─ Set workflow variables

3. Iterate Phases
   │
   ├─ For each phase:
   │  │
   │  ├─ Check skip conditions
   │  │
   │  ├─ Execute Phase (based on execution_mode)
   │  │  ├─ strict: Follow definition exactly
   │  │  ├─ loose: Main agent has freedom
   │  │  └─ adaptive: Main agent decides subagents
   │  │
   │  ├─ Execute phase behavior:
   │  │  ├─ parallel: Spawn subagents simultaneously
   │  │  ├─ sequential: Spawn subagents one-by-one
   │  │  └─ main-only: No subagents, main agent script
   │  │
   │  ├─ Gap Check (if enabled)
   │  │  ├─ Evaluate criteria
   │  │  ├─ On failure: retry/spawn/escalate/abort
   │  │  └─ Record results
   │  │
   │  ├─ Checkpoint (if required)
   │  │  ├─ Show deliverables
   │  │  ├─ Prompt user for decision
   │  │  ├─ On retry: repeat phase
   │  │  └─ On skip: mark phases to skip
   │  │
   │  └─ Update context
   │     ├─ Mark phase complete
   │     ├─ Add deliverables
   │     └─ Increment counters

4. Finalization
   ├─ Render final plan from template
   ├─ Generate metadata.json
   ├─ Create archives/ directory
   └─ Report completion

5. Emit Metadata
   ├─ Phases executed
   ├─ Subagents spawned
   ├─ Checkpoints passed
   ├─ Deliverables created
   └─ Execution time
```

### File Structure

```
~/.claude/skills/use-workflows/
├── SKILL.md                          # Skill entry point (updated)
├── REQUIREMENTS.md                   # Requirements document
├── IMPLEMENTATION_PLAN_V2.md         # This document
├── README.md                         # User-facing documentation
├── ARCHITECTURE.md                   # NEW: Architecture deep-dive
├── DATA_MODELS.md                    # NEW: Schema definitions
├── EXECUTION_MODES.md                # NEW: Execution mode logic
├── CHECKPOINT_FLOW.md                # NEW: Checkpoint documentation
├── GAP_CHECK_FLOW.md                 # NEW: Gap check documentation
├── SCRIPTING_API.md                  # NEW: Inline scripting reference
│
├── engine/                           # Core engine (NEW)
│   ├── workflow-loader.sh           # YAML loading & parsing
│   ├── phase-executor.sh            # Phase execution logic
│   ├── subagent-pool.sh             # Parallel orchestration
│   ├── checkpoint-handler.sh        # Human-in-loop logic
│   ├── gap-check-manager.sh         # Gap check execution
│   ├── context-manager.sh           # Context persistence
│   ├── script-interpreter.sh        # Inline script execution
│   ├── template-renderer.sh         # Mustache rendering
│   └── utils.sh                     # Shared utilities
│
├── schemas/                          # NEW: JSON schemas
│   ├── workflow.schema.json         # Workflow definition schema
│   ├── phase.schema.json            # Phase definition schema
│   ├── context.schema.json          # Context structure schema
│   └── metadata.schema.json         # Metadata output schema
│
├── workflows/                        # Workflow definitions
│   ├── registry.yaml                # Workflow catalog (YAML)
│   ├── new-feature.workflow.yaml    # Converted from JSON
│   ├── debugging.workflow.yaml
│   ├── refactoring.workflow.yaml
│   ├── improving.workflow.yaml
│   ├── quick.workflow.yaml
│   └── legacy/                      # OLD: Keep for reference
│
├── subagents/                        # Subagent configuration
│   ├── selection-matrix.yaml        # Selection rules (YAML)
│   └── prompts/                     # Workflow-specific prompts
│       ├── codebase-scanner/
│       ├── web-researcher/
│       └── ...
│
├── templates/                        # Final output templates
│   ├── new-feature.md.tmpl
│   ├── debugging.md.tmpl
│   └── ...
│
├── tools/                            # Utilities & tooling
│   ├── converter.sh                 # JSON → YAML converter
│   ├── validator.sh                 # Schema validator
│   ├── test-workflow.sh             # Testing utility
│   ├── new-workflow.sh              # NEW: Workflow scaffolding
│   └── check-deps.sh                # NEW: Dependency checker
│
├── tests/                            # NEW: Test suite
│   ├── unit/                        # Unit tests
│   │   ├── test-loader.sh
│   │   ├── test-executor.sh
│   │   ├── test-context.sh
│   │   └── ...
│   ├── integration/                 # Integration tests
│   │   ├── test-new-feature.sh
│   │   ├── test-debugging.sh
│   │   └── ...
│   └── fixtures/                    # Test data
│       ├── sample-workflow.yaml
│       └── ...
│
├── examples/                         # Example workflows
│   ├── custom-research.workflow.yaml
│   ├── code-review.workflow.yaml
│   └── ...
│
└── resources/                        # Documentation
    ├── orchestration.md             # Existing
    ├── yaml-syntax.md               # YAML syntax guide
    ├── template-syntax.md           # Template guide
    └── migration-guide.md           # JSON → YAML migration
```

---

## Phase 0: Foundation & Design (Days 1-2)

**Goal:** Establish architectural foundation and data models before implementation

### Task 0.1: Document MVP Execution Path
**File:** `ARCHITECTURE.md`
**Estimated:** 2 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Architecture

## MVP Execution Path

### Overview
The engine's core execution loop: Load → Iterate → Finalize → Emit

### Detailed Flow

#### 1. Load YAML Workflow
**Input:** `workflow.yaml` path
**Output:** Validated workflow JSON

```bash
workflow_json=$(load_workflow "$workflow_path")
```

**Steps:**
1. Read YAML file
2. Parse to JSON (via yq)
3. Validate against schema
4. Extract phases array
5. Load workflow metadata

**Error handling:**
- File not found → abort
- Parse error → show line number, abort
- Schema validation failure → show violations, abort

#### 2. Initialize Context
**Input:** Feature name, workflow name, flags
**Output:** `context.json` file

```bash
init_context "$feature_name" "$workflow_name" "$flags"
```

**Steps:**
1. Create `.claude/plans/$feature_name/.temp/` directory
2. Initialize `context.json` with:
   - feature_name
   - workflow_name
   - flags (array)
   - start_time (ISO-8601)
   - current_phase (null)
   - completed_phases (empty array)
   - subagents_spawned (0)
   - iterations (object)
   - checkpoints (object)
   - deliverables (array)
   - status ("running")

#### 3. Iterate Phases
**Input:** Workflow JSON, context
**Output:** Updated context per phase

```bash
for phase in phases:
  execute_phase(phase, context)
```

**Per-Phase Steps:**

```
3.1. Check Skip Conditions
     ├─ User requested skip? (from checkpoint)
     ├─ Conditional skip? (skip_if evaluates to true)
     └─ If skip: log and continue to next phase

3.2. Phase Start
     ├─ Update context.current_phase
     ├─ Log phase start
     └─ Create phase output directory (.temp/phase{N}/)

3.3. Execute Phase (based on execution_mode)
     ├─ strict: execute_phase_strict()
     ├─ loose: execute_phase_loose()
     └─ adaptive: execute_phase_adaptive()

3.4. Execute Phase Behavior
     ├─ parallel: spawn_subagents_parallel()
     ├─ sequential: spawn_subagents_sequential()
     └─ main-only: execute_main_script()

3.5. Gap Check (if gap_check.enabled)
     ├─ evaluate_gap_check()
     ├─ On pass: continue
     ├─ On fail: retry/spawn/escalate/abort
     └─ Record gap check result

3.6. Checkpoint (if approval_required || checkpoint defined)
     ├─ Show deliverables to user
     ├─ Prompt for decision
     ├─ On continue: proceed
     ├─ On retry: decrement phase index, continue loop
     ├─ On skip: mark phases to skip
     └─ On abort: exit workflow

3.7. Phase Complete
     ├─ Add phase to completed_phases
     ├─ Update deliverables list
     └─ Save context snapshot
```

#### 4. Finalization
**Input:** Workflow JSON, context
**Output:** Final plan document, metadata

```bash
finalize_workflow(workflow_json, context)
```

**Steps:**
1. Load finalization config from workflow
2. Render final plan template with context
3. Generate metadata.json:
   - Workflow metadata
   - Execution statistics
   - Phases executed
   - Subagents spawned
   - Deliverables created
4. Create archives/ directory
5. Log completion

#### 5. Emit Metadata
**Output:** `metadata.json`

```json
{
  "feature": "feature-name",
  "workflow": "workflow-name",
  "created": "2025-10-31T10:00:00Z",
  "completed": "2025-10-31T10:45:00Z",
  "duration_seconds": 2700,
  "phases_executed": ["discovery", "requirements", "design"],
  "phases_skipped": [],
  "subagents_spawned": 12,
  "checkpoints": {
    "synthesis": "continue"
  },
  "iterations": {
    "discovery": 1,
    "requirements": 2
  },
  "deliverables": [
    ".temp/phase1-discovery/codebase-scan.json",
    ".temp/phase2-requirements/user-stories.md"
  ],
  "status": "completed"
}
```

### Error Handling Strategy

**Recoverable Errors:**
- Gap check failure → retry phase
- Checkpoint rejection → repeat phase
- Script execution error → log and continue (if non-critical)

**Non-Recoverable Errors:**
- Workflow file not found → abort immediately
- Schema validation failure → abort immediately
- Critical subagent failure → abort workflow
- User abort at checkpoint → graceful exit

### Performance Characteristics

- **Workflow loading:** <1 second
- **Phase iteration overhead:** <100ms per phase
- **Context persistence:** <50ms per update
- **Template rendering:** <500ms
```

**Validation:**
- Clear execution path documented
- Error handling specified
- Performance targets defined

---

### Task 0.2: Define Engine Data Models
**File:** `DATA_MODELS.md`
**Estimated:** 3 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Data Models

## 1. Workflow Schema

### YAML Structure
```yaml
name: string                    # REQUIRED
description: string             # REQUIRED
variables: object               # Optional workflow-level variables

phases: array<Phase>            # REQUIRED, min 1 phase

finalization:                   # REQUIRED
  template: string              # Template filename
  inputs: array<string>         # Input paths
  output: string                # Output path (supports ${vars})

metadata:                       # Optional
  typical_duration_minutes: string
  token_estimate: string
  complexity: enum[simple, moderate, complex]
  tags: array<string>
```

### JSON Schema
**File:** `schemas/workflow.schema.json`

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["name", "description", "phases", "finalization"],
  "properties": {
    "name": {
      "type": "string",
      "minLength": 1
    },
    "description": {
      "type": "string"
    },
    "variables": {
      "type": "object"
    },
    "phases": {
      "type": "array",
      "minItems": 1,
      "items": { "$ref": "#/definitions/phase" }
    },
    "finalization": {
      "type": "object",
      "required": ["template", "output"],
      "properties": {
        "template": { "type": "string" },
        "inputs": {
          "type": "array",
          "items": { "type": "string" }
        },
        "output": { "type": "string" }
      }
    },
    "metadata": {
      "type": "object",
      "properties": {
        "typical_duration_minutes": { "type": "string" },
        "token_estimate": { "type": "string" },
        "complexity": {
          "enum": ["simple", "moderate", "complex"]
        },
        "tags": {
          "type": "array",
          "items": { "type": "string" }
        }
      }
    }
  }
}
```

---

## 2. Phase Schema

### YAML Structure
```yaml
id: string                      # REQUIRED, unique within workflow
name: string                    # REQUIRED, display name
execution_mode: enum            # strict | loose | adaptive (default: strict)
behavior: enum                  # parallel | sequential | main-only (default: parallel)
skip_if: string                 # Optional JS expression
approval_required: boolean      # Simple approval (default: false)

subagents:                      # Configuration varies by execution_mode
  always: array<SubagentConfig> # Always spawned (strict/adaptive)
  suggested: array<SubagentConfig> # Suggestions (loose)
  adaptive:                     # Adaptive decision logic
    script: string              # JS script returning subagent array

main_agent:                     # For loose/main-only modes
  script: string                # JS script for main agent

skills: array<SkillConfig>      # Skills to invoke

gap_check:                      # Optional gap checking
  enabled: boolean
  script: string                # JS script returning {status, gaps, action}
  criteria: array<string>       # Or criteria-based

checkpoint:                     # Optional human-in-loop
  condition: string             # JS expression (default: "true")
  prompt: string
  show_files: array<string>
  options: array<CheckpointOption>

deliverables:                   # Expected outputs
  required: array<string>
  optional: array<string>

depends_on: array<string>       # Phase dependencies (for parallel groups)
parallel_group: string          # Parallel execution group
max_iterations: number          # Iteration limit (default: 1)
```

### SubagentConfig
```yaml
type: string                    # Subagent type (e.g., "codebase-scanner")
prompt: string                  # Inline prompt OR @template:name
prompt_vars: object             # Variables for template
output: string                  # Output file path
```

### SkillConfig
```yaml
name: string                    # Skill name
condition: string               # JS expression (default: "true")
args: object                    # Skill arguments
```

### CheckpointOption
```yaml
label: string                   # Display label
value: string                   # Option value
on_select:                      # Action when selected
  action: enum                  # continue | repeat_phase | skip_phases | abort
  target: string                # For repeat_phase
  targets: array<string>        # For skip_phases
  with_feedback: boolean        # Collect user feedback?
  feedback_prompt: string       # Feedback question
```

---

## 3. Context Structure

### context.json Schema

```json
{
  "feature_name": "user-dashboard",
  "workflow_name": "New Feature Planning",
  "flags": ["--frontend"],
  "start_time": "2025-10-31T10:00:00Z",
  "current_phase": "requirements",
  "completed_phases": ["discovery"],
  "skip_phases": [],
  "subagents_spawned": 5,
  "iterations": {
    "discovery": 1,
    "requirements": 2
  },
  "checkpoints": {
    "synthesis-review": "continue"
  },
  "deliverables": [
    ".temp/phase1-discovery/codebase-scan.json",
    ".temp/phase1-discovery/patterns.json"
  ],
  "gap_checks": {
    "discovery": {
      "status": "complete",
      "gaps": [],
      "timestamp": "2025-10-31T10:15:00Z"
    }
  },
  "status": "running",
  "error": null
}
```

### Schema File
**File:** `schemas/context.schema.json`

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": [
    "feature_name",
    "workflow_name",
    "start_time",
    "completed_phases",
    "subagents_spawned",
    "deliverables",
    "status"
  ],
  "properties": {
    "feature_name": { "type": "string" },
    "workflow_name": { "type": "string" },
    "flags": {
      "type": "array",
      "items": { "type": "string" }
    },
    "start_time": { "type": "string", "format": "date-time" },
    "current_phase": { "type": ["string", "null"] },
    "completed_phases": {
      "type": "array",
      "items": { "type": "string" }
    },
    "skip_phases": {
      "type": "array",
      "items": { "type": "string" }
    },
    "subagents_spawned": { "type": "integer", "minimum": 0 },
    "iterations": {
      "type": "object",
      "patternProperties": {
        ".*": { "type": "integer", "minimum": 1 }
      }
    },
    "checkpoints": {
      "type": "object",
      "patternProperties": {
        ".*": { "type": "string" }
      }
    },
    "deliverables": {
      "type": "array",
      "items": { "type": "string" }
    },
    "gap_checks": {
      "type": "object",
      "patternProperties": {
        ".*": { "$ref": "#/definitions/gapCheckRecord" }
      }
    },
    "status": {
      "enum": ["running", "completed", "failed", "aborted"]
    },
    "error": { "type": ["string", "null"] }
  },
  "definitions": {
    "gapCheckRecord": {
      "type": "object",
      "properties": {
        "status": { "enum": ["complete", "incomplete"] },
        "gaps": {
          "type": "array",
          "items": { "type": "string" }
        },
        "timestamp": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```

---

## 4. Deliverable Record

### Structure
```json
{
  "path": ".temp/phase1-discovery/codebase-scan.json",
  "phase_id": "discovery",
  "subagent": "codebase-scanner",
  "created": "2025-10-31T10:15:00Z",
  "size_bytes": 15420,
  "required": true
}
```

---

## 5. Checkpoint Record

### Structure
```json
{
  "checkpoint_id": "synthesis-review",
  "phase_id": "synthesis",
  "timestamp": "2025-10-31T10:30:00Z",
  "prompt": "Review synthesis before deep-dive?",
  "files_shown": [
    ".temp/synthesis.md"
  ],
  "options_presented": [
    "Proceed to deep-dive",
    "Refine research",
    "Skip deep-dive"
  ],
  "user_selection": "Proceed to deep-dive",
  "user_selection_value": "continue",
  "user_feedback": null,
  "action_taken": "continue"
}
```

---

## 6. Metadata Output Schema

### metadata.json Structure

```json
{
  "feature": "user-dashboard",
  "workflow": "New Feature Planning",
  "created": "2025-10-31T10:00:00Z",
  "completed": "2025-10-31T10:45:00Z",
  "duration_seconds": 2700,
  "duration_human": "45 minutes",

  "phases": {
    "total": 5,
    "executed": ["discovery", "requirements", "design", "synthesis", "finalize"],
    "skipped": [],
    "iterations": {
      "discovery": 1,
      "requirements": 2
    }
  },

  "subagents": {
    "total_spawned": 12,
    "by_phase": {
      "discovery": 5,
      "requirements": 4,
      "design": 3
    }
  },

  "checkpoints": {
    "total": 1,
    "passed": ["synthesis-review"],
    "decisions": {
      "synthesis-review": "continue"
    }
  },

  "gap_checks": {
    "total": 3,
    "passed": ["discovery", "requirements", "design"],
    "failed": [],
    "retries": {
      "requirements": 1
    }
  },

  "deliverables": {
    "total": 15,
    "by_phase": {
      "discovery": 5,
      "requirements": 4,
      "design": 6
    },
    "paths": [
      ".temp/phase1-discovery/codebase-scan.json"
    ]
  },

  "output": {
    "plan": ".claude/plans/user-dashboard/plan.md",
    "metadata": ".claude/plans/user-dashboard/metadata.json",
    "research": ".claude/plans/user-dashboard/.temp/"
  },

  "status": "completed",
  "error": null
}
```

### Schema File
**File:** `schemas/metadata.schema.json`

(Full JSON schema definition...)
```

**Validation:**
- All data models documented
- JSON schemas created
- Examples provided
- Relationships clear

---

### Task 0.3: Document Execution Mode Logic
**File:** `EXECUTION_MODES.md`
**Estimated:** 3 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Execution Modes

## Overview

Three execution modes control how phases execute: **strict**, **loose**, and **adaptive**.

Each mode changes:
- How subagents are selected
- Main agent's decision-making authority
- Deviation from defined configuration

---

## 1. Strict Mode

### Philosophy
**"Follow the recipe exactly"**

The phase definition is a prescription. No deviations, no runtime decisions.

### Configuration Requirements
```yaml
phases:
  - id: example-phase
    execution_mode: strict
    behavior: parallel         # REQUIRED
    subagents:
      always:                  # REQUIRED
        - type: subagent-a
        - type: subagent-b
```

### Execution Logic

```bash
execute_phase_strict(phase, context):
  behavior = phase.behavior
  subagents = phase.subagents.always

  if behavior == "parallel":
    spawn_all_subagents_parallel(subagents)
  elif behavior == "sequential":
    for subagent in subagents:
      spawn_subagent(subagent)
      wait_for_completion()
  elif behavior == "main-only":
    if phase.main_agent.script exists:
      execute_script(phase.main_agent.script)
    else:
      log("No main agent script, skipping")
```

### Behavior Mapping

| Behavior | Subagent Handling | Main Agent Role |
|----------|-------------------|-----------------|
| **parallel** | Spawn all `always` subagents simultaneously | Coordinator only |
| **sequential** | Spawn `always` subagents one-by-one | Coordinator only |
| **main-only** | No subagents spawned | Executes `main_agent.script` |

### Use Cases
- Well-defined phases with known subagents
- Repeatable, deterministic workflows
- Compliance-sensitive processes
- Batch processing

### Example
```yaml
phases:
  - id: discovery
    execution_mode: strict
    behavior: parallel
    subagents:
      always:
        - type: codebase-scanner
          output: .temp/phase1/codebase.json
        - type: pattern-analyzer
          output: .temp/phase1/patterns.json
        - type: dependency-mapper
          output: .temp/phase1/dependencies.json
```

**Execution:**
1. Spawn all 3 subagents in parallel
2. Wait for all to complete
3. Proceed to next phase

---

## 2. Loose Mode

### Philosophy
**"Use your best judgment"**

Main agent has freedom to decide approach. Subagents are suggestions, not requirements.

### Configuration Requirements
```yaml
phases:
  - id: example-phase
    execution_mode: loose
    behavior: parallel         # Optional (ignored)
    main_agent:               # REQUIRED
      script: |
        // Main agent logic here
    subagents:
      suggested:              # Optional (informational)
        - type: subagent-a
        - type: subagent-b
```

### Execution Logic

```bash
execute_phase_loose(phase, context):
  if phase.main_agent.script not exists:
    error("Loose mode requires main_agent.script")

  # Show suggested subagents (informational)
  if phase.subagents.suggested exists:
    log_info("Suggested subagents: " + phase.subagents.suggested)

  # Main agent decides everything
  execute_script(phase.main_agent.script, context)
```

### Main Agent Capabilities in Script
```javascript
// Main agent can:
await thinkHard("Should I spawn code-scout?");
await spawnSubagent({ type: "code-scout", output: "..." });
await invokeSkill("codebase-researcher", { topic: "..." });
await readFiles([...]);
await writeFile("...", "...");
// Full freedom to choose approach
```

### Behavior Mapping

| Behavior | Subagent Handling | Main Agent Role |
|----------|-------------------|-----------------|
| **N/A** | Main agent decides | Full control |

### Use Cases
- Exploratory research
- Context-dependent analysis
- Creative problem-solving
- Unknown problem space

### Example
```yaml
phases:
  - id: deep-dive
    execution_mode: loose
    main_agent:
      script: |
        // Main agent evaluates context
        const synthesis = await readFile('.temp/synthesis.md');

        // Decides approach dynamically
        if (synthesis.includes('performance')) {
          await spawnSubagent({
            type: 'bottleneck-identifier',
            output: '.temp/deep-dive/performance.json'
          });
        }

        if (synthesis.includes('architecture')) {
          await invokeSkill('codebase-researcher', {
            topic: 'architecture patterns'
          });
        }

        // Perform own analysis
        await writeFile('.temp/deep-dive/analysis.md', myAnalysis);
    subagents:
      suggested:
        - type: bottleneck-identifier
          note: "Use for performance issues"
        - type: architecture-synthesizer
          note: "Use for design questions"
```

**Execution:**
1. Main agent reads synthesis
2. Conditionally spawns bottleneck-identifier
3. Conditionally invokes skill
4. Writes own analysis
5. Proceeds to next phase

---

## 3. Adaptive Mode

### Philosophy
**"Start with essentials, adapt as needed"**

Always spawn core subagents, then main agent decides if additional subagents needed.

### Configuration Requirements
```yaml
phases:
  - id: example-phase
    execution_mode: adaptive
    behavior: parallel         # REQUIRED
    subagents:
      always:                  # REQUIRED (core subagents)
        - type: subagent-a
      adaptive:                # REQUIRED (decision logic)
        script: |
          // Decision script here
          return [/* additional subagents */];
```

### Execution Logic

```bash
execute_phase_adaptive(phase, context):
  behavior = phase.behavior
  always = phase.subagents.always
  adaptive = phase.subagents.adaptive

  # Step 1: Spawn always subagents
  if behavior == "parallel":
    spawn_all_subagents_parallel(always)
  elif behavior == "sequential":
    for subagent in always:
      spawn_subagent(subagent)
      wait_for_completion()

  wait_for_all()

  # Step 2: Main agent evaluates and decides
  if adaptive.script exists:
    additional = execute_script(adaptive.script, context)

    # Step 3: Spawn additional subagents
    if additional is array and length > 0:
      if behavior == "parallel":
        spawn_all_subagents_parallel(additional)
      elif behavior == "sequential":
        for subagent in additional:
          spawn_subagent(subagent)
          wait_for_completion()
```

### Adaptive Script API
```javascript
// Available in adaptive.script:
const findings = await readFiles([
  '.temp/phase1/web-research.md',
  '.temp/phase1/docs.md'
]);

const decision = await thinkHard(`
  Review findings. Do we need codebase analysis?
  Consider: completeness, code references, implementation details
`);

if (decision.needsCodeAnalysis) {
  return [
    { type: 'code-scout', output: '.temp/phase1/code.json' },
    { type: 'pattern-analyzer', output: '.temp/phase1/patterns.json' }
  ];
}

return [];  // No additional subagents
```

### Behavior Mapping

| Behavior | Subagent Handling | Main Agent Role |
|----------|-------------------|-----------------|
| **parallel** | Spawn `always` parallel → decide → spawn `additional` parallel | Decision maker |
| **sequential** | Spawn `always` sequential → decide → spawn `additional` sequential | Decision maker |
| **main-only** | Not applicable | N/A |

### Use Cases
- Discovery phases (core scan + targeted deep-dives)
- Risk-based analysis (always check basics, conditionally deep-dive)
- Progressive refinement (start broad, narrow based on findings)
- Cost optimization (only spawn expensive subagents if needed)

### Example
```yaml
phases:
  - id: discovery
    execution_mode: adaptive
    behavior: parallel
    subagents:
      always:
        - type: web-researcher
          prompt: "@template:research-mode"
          output: .temp/phase1/web-research.md
        - type: doc-searcher
          prompt: "@template:research-mode"
          output: .temp/phase1/docs.md

      adaptive:
        script: |
          // Read initial research
          const webFindings = await readFile('.temp/phase1/web-research.md');
          const docFindings = await readFile('.temp/phase1/docs.md');

          // Evaluate completeness
          const needsCode = await thinkHard(`
            Review findings:
            - Web research: ${webFindings.slice(0, 200)}...
            - Documentation: ${docFindings.slice(0, 200)}...

            Do we need codebase analysis? (yes/no)
            Consider:
            1. Are there code references we need to investigate?
            2. Is implementation detail missing?
            3. Do we need pattern examples?
          `);

          if (needsCode === 'yes') {
            return [
              {
                type: 'code-scout',
                output: '.temp/phase1/code-analysis.json'
              },
              {
                type: 'pattern-analyzer',
                output: '.temp/phase1/patterns.json'
              }
            ];
          }

          return [];
```

**Execution:**
1. Spawn web-researcher and doc-searcher in parallel
2. Wait for both to complete
3. Main agent reads outputs
4. Main agent decides: "Yes, need code analysis"
5. Spawn code-scout and pattern-analyzer in parallel
6. Wait for both to complete
7. Proceed to next phase

---

## Comparison Matrix

| Feature | Strict | Loose | Adaptive |
|---------|--------|-------|----------|
| **Subagent selection** | Pre-defined | Main agent decides | Core + conditional |
| **Main agent role** | Coordinator | Full control | Decision maker |
| **Deterministic** | Yes | No | Partially |
| **Runtime decisions** | None | All | Subagent additions only |
| **Complexity** | Low | High | Medium |
| **Token usage** | Predictable | Variable | Moderate |
| **Use case** | Known processes | Exploration | Discovery + depth |

---

## Decision Tree: Choosing Execution Mode

```
Is the phase approach well-defined?
├─ Yes → Is customization needed based on context?
│         ├─ No → STRICT
│         └─ Yes → Are there core subagents that always run?
│                   ├─ Yes → ADAPTIVE
│                   └─ No → LOOSE
└─ No → LOOSE
```

---

## Best Practices

### For Strict Mode
- Clearly define all subagents upfront
- Use for predictable, repeatable phases
- Prefer when compliance/audit needed

### For Loose Mode
- Provide detailed guidance in `main_agent.script` comments
- List suggested subagents for documentation
- Use when problem space is unknown

### For Adaptive Mode
- Define minimal "always" subagents (1-3)
- Make adaptive decision criteria explicit
- Use when you know core steps but depth varies

---

## Implementation Notes

### Execution Mode Validation

```bash
validate_execution_mode(phase):
  mode = phase.execution_mode

  if mode == "strict":
    assert phase.subagents.always exists
    assert phase.behavior in ["parallel", "sequential", "main-only"]

  elif mode == "loose":
    assert phase.main_agent.script exists

  elif mode == "adaptive":
    assert phase.subagents.always exists
    assert phase.subagents.adaptive.script exists
    assert phase.behavior in ["parallel", "sequential"]
```

### Testing Strategy
- Strict: Verify all subagents spawn
- Loose: Verify main agent has control
- Adaptive: Verify conditional spawning logic
```

**Validation:**
- All three modes documented
- Behavior mappings clear
- Examples provided
- Decision tree included

---

### Task 0.4: Document Checkpoint Flow
**File:** `CHECKPOINT_FLOW.md`
**Estimated:** 2 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Checkpoint Flow

## Overview

Checkpoints enable human-in-the-loop decision points during workflow execution.

**Two types:**
1. **Simple approval** - `approval_required: true`
2. **Custom checkpoint** - Full configuration with options

---

## Simple Approval

### Configuration
```yaml
phases:
  - id: synthesis
    approval_required: true
```

### Flow
```
1. Phase completes
2. Display: "Phase 'synthesis' requires approval"
3. Show deliverables (if any in phase.deliverables)
4. Prompt: "Continue to next phase?"
5. Options: [Continue, Abort]
6. On Continue → proceed
7. On Abort → exit workflow
```

### Implementation
```bash
if phase.approval_required:
  log_info("Phase requires approval")

  # In real Claude Code, would use AskUserQuestion tool
  decision = ask_user("Continue to next phase?", ["Continue", "Abort"])

  if decision == "Abort":
    log_info("Workflow aborted by user")
    exit 0
```

---

## Custom Checkpoint

### Configuration
```yaml
phases:
  - id: synthesis
    checkpoint:
      condition: "context.environment === 'production'"  # Optional
      prompt: "Review synthesis before proceeding?"
      show_files:
        - .temp/synthesis.md
        - .temp/phase1-summary.md
      options:
        - label: "Proceed to next phase"
          value: continue

        - label: "Refine synthesis"
          value: refine
          on_select:
            action: repeat_phase
            target: synthesis
            with_feedback: true
            feedback_prompt: "What needs refinement?"

        - label: "Go back to discovery"
          value: redo
          on_select:
            action: repeat_phase
            target: discovery

        - label: "Skip remaining phases"
          value: skip
          on_select:
            action: skip_phases
            targets: ["deep-dive", "validation"]

        - label: "Abort workflow"
          value: abort
          on_select:
            action: abort
```

### Flow

```
1. Phase completes

2. Evaluate condition (if defined)
   ├─ If false → skip checkpoint, continue
   └─ If true → proceed with checkpoint

3. Display Prompt
   "Review synthesis before proceeding?"

4. Show Files to User
   ├─ Read .temp/synthesis.md
   ├─ Read .temp/phase1-summary.md
   └─ Display contents (formatted)

5. Present Options
   Option 1: Proceed to next phase
   Option 2: Refine synthesis
   Option 3: Go back to discovery
   Option 4: Skip remaining phases
   Option 5: Abort workflow

6. Collect User Decision
   User selects: "Refine synthesis" (value: refine)

7. Lookup on_select Action
   action: repeat_phase
   target: synthesis
   with_feedback: true

8. Collect Feedback (if with_feedback: true)
   Prompt: "What needs refinement?"
   User input: "Add more implementation details"

9. Update Context
   context.checkpoints.synthesis = "refine"
   context.feedback.synthesis = "Add more implementation details"

10. Execute Action
    ├─ continue → proceed to next phase
    ├─ repeat_phase → set phase_index to target phase
    ├─ skip_phases → add targets to context.skip_phases
    └─ abort → exit workflow gracefully

11. Record Checkpoint
    Save checkpoint record to context.checkpoints
```

---

## Actions

### 1. continue
**Description:** Proceed to next phase

**Configuration:**
```yaml
on_select:
  action: continue
```

**Effect:**
- No phase index change
- Next phase executes normally

---

### 2. repeat_phase
**Description:** Go back to a specific phase and re-execute

**Configuration:**
```yaml
on_select:
  action: repeat_phase
  target: discovery              # Phase ID to repeat
  with_feedback: boolean         # Collect user feedback?
  feedback_prompt: string        # Prompt for feedback
```

**Effect:**
- Set phase_index to target phase
- Increment context.iterations.{target}
- If with_feedback: store user input in context.feedback.{target}
- Re-execute target phase

**Example:**
User selects "Refine synthesis"
→ Phase index set to "synthesis"
→ Synthesis phase re-executes with feedback

---

### 3. skip_phases
**Description:** Skip one or more upcoming phases

**Configuration:**
```yaml
on_select:
  action: skip_phases
  targets: ["deep-dive", "validation"]  # Phase IDs to skip
```

**Effect:**
- Add targets to context.skip_phases array
- When iterating phases, check if phase_id in skip_phases
- If yes, log skip and continue to next

**Example:**
User selects "Skip deep-dive"
→ context.skip_phases = ["deep-dive"]
→ When deep-dive phase reached, skip and continue

---

### 4. abort
**Description:** Exit workflow immediately

**Configuration:**
```yaml
on_select:
  action: abort
```

**Effect:**
- Set context.status = "aborted"
- Log abortion reason
- Exit workflow gracefully (no error)
- Preserve research artifacts

**Example:**
User selects "Abort workflow"
→ Workflow exits
→ .temp/ folder preserved
→ Partial metadata saved

---

## Conditional Checkpoints

### Configuration
```yaml
checkpoint:
  condition: "context.environment === 'production'"
  prompt: "Approve production deployment?"
  # ...
```

### Evaluation
```javascript
// Evaluate condition (JS expression)
const should_show = eval(checkpoint.condition, context);

if (!should_show) {
  log_info("Checkpoint condition false, skipping");
  return;
}

// Proceed with checkpoint
```

### Use Cases
- Environment-specific approvals (prod only)
- Risk-based approvals (high-risk changes only)
- Conditional branching (if X found, ask Y)

---

## Context Updates

### Checkpoint Record
```json
{
  "checkpoint_id": "synthesis-review",
  "phase_id": "synthesis",
  "timestamp": "2025-10-31T10:30:00Z",
  "condition_evaluated": true,
  "condition_result": true,
  "prompt": "Review synthesis before proceeding?",
  "files_shown": [
    ".temp/synthesis.md",
    ".temp/phase1-summary.md"
  ],
  "options_presented": [
    "Proceed to next phase",
    "Refine synthesis",
    "Go back to discovery",
    "Skip remaining phases",
    "Abort workflow"
  ],
  "user_selection_label": "Refine synthesis",
  "user_selection_value": "refine",
  "user_feedback": "Add more implementation details",
  "action_taken": "repeat_phase",
  "action_target": "synthesis"
}
```

### Context Updates
```json
{
  "checkpoints": {
    "synthesis-review": "refine"
  },
  "feedback": {
    "synthesis": "Add more implementation details"
  },
  "skip_phases": [],
  "iterations": {
    "synthesis": 2
  }
}
```

---

## Implementation

### checkpoint-handler.sh

```bash
handle_checkpoint(phase, context):
  checkpoint = phase.checkpoint
  approval_required = phase.approval_required

  # Check if checkpoint needed
  if checkpoint is null and approval_required is false:
    return CONTINUE

  # Simple approval
  if approval_required and checkpoint is null:
    return handle_simple_approval(phase)

  # Custom checkpoint
  return handle_custom_checkpoint(checkpoint, phase, context)

handle_custom_checkpoint(checkpoint, phase, context):
  # Evaluate condition
  if checkpoint.condition exists:
    should_show = evaluate_condition(checkpoint.condition, context)
    if not should_show:
      log_info("Checkpoint condition false, skipping")
      return CONTINUE

  # Display prompt
  log_info("CHECKPOINT: " + checkpoint.prompt)

  # Show files
  for file in checkpoint.show_files:
    display_file(file)

  # Present options
  options = checkpoint.options
  for i, option in enumerate(options):
    log_info(f"Option {i+1}: {option.label}")

  # Collect user decision (via AskUserQuestion tool in real implementation)
  user_choice = ask_user(checkpoint.prompt, options.map(o => o.label))

  # Find selected option
  selected = options.find(o => o.label == user_choice)

  # Collect feedback if needed
  user_feedback = null
  if selected.on_select.with_feedback:
    user_feedback = ask_user(selected.on_select.feedback_prompt, freeText=true)

  # Record checkpoint
  record_checkpoint(phase.id, selected.value, user_feedback, selected.on_select)

  # Execute action
  return execute_checkpoint_action(selected.on_select, phase.id, user_feedback)

execute_checkpoint_action(on_select, phase_id, feedback):
  action = on_select.action

  if action == "continue":
    return CONTINUE

  elif action == "repeat_phase":
    target = on_select.target || phase_id
    if feedback:
      context_update("feedback." + target, feedback)
    increment_iteration(target)
    return REPEAT_PHASE(target)

  elif action == "skip_phases":
    targets = on_select.targets
    for target in targets:
      add_skip_phase(target)
    return CONTINUE

  elif action == "abort":
    log_info("Workflow aborted by user")
    context_update("status", "aborted")
    return ABORT
```

---

## Error Handling

### Invalid Option Selection
```
User selects invalid option
→ Log error
→ Re-prompt user
→ Max 3 retries
→ If still invalid, abort
```

### Missing Files
```
show_files references non-existent file
→ Log warning: "File not found: {path}"
→ Continue with available files
→ Don't block checkpoint
```

### Script Errors in Condition
```
Condition evaluation throws error
→ Log error with details
→ Default to showing checkpoint (fail-open)
→ Warn user about condition failure
```

---

## Best Practices

### Checkpoint Placement
- After synthesis phases (before proceeding to expensive work)
- Before destructive operations (deployments, migrations)
- After research phases (validate completeness)
- At natural decision points (fork in workflow)

### Option Design
- Max 5 options (avoid overwhelming user)
- Provide clear, actionable labels
- Order by likelihood (most common first)
- Always include "Continue" and "Abort"

### Feedback Collection
- Only collect feedback when actionable
- Provide specific prompts ("What's missing?")
- Store in context for phase to use
- Display feedback in re-executed phase

### Condition Usage
- Keep conditions simple (avoid complex JS)
- Use for environment checks (prod/dev)
- Use for risk gating (high-impact only)
- Test both true and false paths
```

**Validation:**
- Checkpoint flow documented
- All actions explained
- Examples provided
- Error handling specified

---

### Task 0.5: Document Gap Check Flow
**File:** `GAP_CHECK_FLOW.md`
**Estimated:** 2 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Gap Check Flow

## Overview

Gap checks validate phase completeness before proceeding.

**Two types:**
1. **Script-based** - Custom JS logic returning structured result
2. **Criteria-based** - Predefined checklist evaluation

---

## Script-Based Gap Check

### Configuration
```yaml
phases:
  - id: discovery
    gap_check:
      enabled: true
      script: |
        // Analyze phase outputs
        const coverage = await analyzeFiles('.temp/phase1/');
        const gaps = await identifyGaps(coverage);

        if (gaps.length > 0) {
          return {
            status: 'incomplete',
            gaps: gaps,
            action: 'spawn_additional',
            additionalAgents: [
              { type: 'gap-filler', output: '.temp/phase1/gaps.json' }
            ]
          };
        }

        return { status: 'complete' };
```

### Flow

```
1. Phase completes execution

2. Check if gap_check.enabled
   ├─ false → skip gap check, continue
   └─ true → proceed

3. Execute Gap Check Script
   ├─ Inject context
   ├─ Execute JS script
   └─ Capture return value

4. Parse Result
   {
     status: 'complete' | 'incomplete',
     gaps: array<string>,              # List of identified gaps
     action: 'retry' | 'spawn_additional' | 'escalate' | 'abort',
     additionalAgents: array<SubagentConfig>,  # For spawn_additional
     message: string                   # Optional explanation
   }

5. Handle Result Based on Status

   If status == 'complete':
     ├─ Log: "Gap check passed"
     ├─ Record result in context
     └─ Continue to next phase

   If status == 'incomplete':
     ├─ Log gaps found
     ├─ Execute action
     │  ├─ retry → repeat current phase
     │  ├─ spawn_additional → spawn agents, then continue
     │  ├─ escalate → prompt user for decision
     │  └─ abort → exit workflow
     └─ Record result in context

6. Update Context
   context.gap_checks.{phase_id} = {
     status: result.status,
     gaps: result.gaps,
     action: result.action,
     timestamp: now()
   }
```

---

## Criteria-Based Gap Check

### Configuration
```yaml
phases:
  - id: discovery
    gap_check:
      enabled: true
      criteria:
        - "All relevant code discovered?"
        - "Patterns identified?"
        - "Dependencies mapped?"
      on_failure: retry  # retry | escalate | abort
```

### Flow

```
1. Phase completes

2. gap_check.enabled? → Yes

3. Load Criteria
   criteria = gap_check.criteria

4. Evaluate Each Criterion
   For each criterion in criteria:
     ├─ Display criterion to main agent
     ├─ Main agent evaluates (via thinkHard)
     └─ Record result (pass/fail)

5. Aggregate Results
   total = criteria.length
   passed = count(results where status == 'pass')
   failed = count(results where status == 'fail')

6. Determine Overall Status
   if failed == 0:
     status = 'complete'
   else:
     status = 'incomplete'

7. Handle Result
   if status == 'complete':
     continue
   else:
     execute on_failure action:
       ├─ retry → repeat phase
       ├─ escalate → ask user
       └─ abort → exit workflow
```

---

## Actions

### 1. retry
**Description:** Repeat the current phase

**Use Case:** Phase incomplete, needs another iteration

**Effect:**
- Increment context.iterations.{phase_id}
- Check max_iterations limit
- If under limit: repeat phase
- If at limit: escalate to user

**Example:**
```yaml
gap_check:
  enabled: true
  script: |
    if (coverageBelow80Percent) {
      return { status: 'incomplete', action: 'retry' };
    }
```

---

### 2. spawn_additional
**Description:** Spawn additional subagents to fill gaps, then continue

**Use Case:** Specific gaps identified, targeted agents can fix

**Effect:**
- Spawn additionalAgents (parallel or sequential based on phase behavior)
- Wait for completion
- Continue to next phase (don't retry whole phase)

**Example:**
```yaml
gap_check:
  enabled: true
  script: |
    const gaps = identifyMissingPatterns();
    if (gaps.length > 0) {
      return {
        status: 'incomplete',
        action: 'spawn_additional',
        additionalAgents: [
          { type: 'pattern-deep-dive', output: '.temp/phase1/patterns-extra.json' }
        ]
      };
    }
```

---

### 3. escalate
**Description:** Prompt user for decision

**Use Case:** Uncertain if issue is critical, need human judgment

**Effect:**
- Display gaps to user
- Present options: [Continue anyway, Retry phase, Abort]
- Execute user-selected action

**Example:**
```yaml
gap_check:
  enabled: true
  script: |
    if (minorIssuesFound) {
      return {
        status: 'incomplete',
        gaps: ['Missing edge case documentation'],
        action: 'escalate',
        message: 'Non-critical gaps found. Continue anyway?'
      };
    }
```

---

### 4. abort
**Description:** Exit workflow immediately

**Use Case:** Critical gaps that block progress

**Effect:**
- Log critical gap
- Set context.status = 'failed'
- Exit workflow with error
- Preserve artifacts for debugging

**Example:**
```yaml
gap_check:
  enabled: true
  script: |
    if (criticalDataMissing) {
      return {
        status: 'incomplete',
        gaps: ['Required dependency not found in codebase'],
        action: 'abort',
        message: 'Cannot proceed without dependency information'
      };
    }
```

---

## Scripting API

### Available Helpers

```javascript
// File operations
const content = await readFile(path);
const contents = await readFiles([path1, path2]);
await writeFile(path, content);

// Analysis
const coverage = await analyzeFiles(directory);
// Returns: { total_files: N, analyzed: M, coverage: 0.XX }

const gaps = await identifyGaps(coverage);
// Returns: ['Missing X', 'Incomplete Y']

// Main agent thinking
const decision = await thinkHard(prompt);
// Returns: { decision: 'yes'|'no', reasoning: '...' }

// Context access
const context = this.context;
// { feature_name, workflow_name, current_phase, ... }
```

### Return Value Schema

```typescript
interface GapCheckResult {
  status: 'complete' | 'incomplete';
  gaps?: string[];                     // List of identified gaps
  action?: 'retry' | 'spawn_additional' | 'escalate' | 'abort';
  additionalAgents?: SubagentConfig[]; // For spawn_additional
  message?: string;                    // Explanation for user
}
```

---

## Context Updates

### Gap Check Record

```json
{
  "phase_id": "discovery",
  "timestamp": "2025-10-31T10:15:00Z",
  "type": "script",
  "status": "incomplete",
  "gaps": [
    "Missing dependency analysis",
    "Pattern coverage below 80%"
  ],
  "action": "spawn_additional",
  "additional_agents_spawned": [
    "dependency-deep-dive",
    "pattern-exhaustive-search"
  ],
  "message": "Spawning additional agents to fill gaps"
}
```

### Context Updates

```json
{
  "gap_checks": {
    "discovery": {
      "status": "incomplete",
      "gaps": ["Missing dependency analysis"],
      "action": "spawn_additional",
      "timestamp": "2025-10-31T10:15:00Z"
    }
  },
  "iterations": {
    "discovery": 1  // No retry, so remains 1
  }
}
```

---

## Iteration Limits

### Configuration
```yaml
phases:
  - id: discovery
    max_iterations: 3
    gap_check:
      enabled: true
      script: |
        // ... gap check logic
```

### Flow with Limits

```
1. Phase executes (iteration 1)
2. Gap check fails → action: retry
3. Check current iteration: 1 < 3
4. Repeat phase (iteration 2)
5. Gap check fails → action: retry
6. Check current iteration: 2 < 3
7. Repeat phase (iteration 3)
8. Gap check fails → action: retry
9. Check current iteration: 3 == 3 (LIMIT REACHED)
10. Escalate to user:
    "Phase 'discovery' reached max iterations (3). Continue anyway?"
    Options: [Continue, Abort]
```

---

## Error Handling

### Script Execution Error
```
Gap check script throws error
→ Log error with stack trace
→ Treat as gap check failure
→ Action: escalate
→ Prompt user: "Gap check error. Continue anyway?"
```

### Invalid Return Value
```
Script returns invalid structure
→ Log warning
→ Treat as gap check pass (fail-open)
→ Continue to next phase
```

### Missing Helper Function
```
Script calls unavailable helper
→ Log error: "Helper 'xyz' not available"
→ Treat as gap check failure
→ Action: escalate
```

---

## Implementation

### gap-check-manager.sh

```bash
execute_gap_check(phase, context):
  gap_check = phase.gap_check

  if gap_check is null or not gap_check.enabled:
    return CONTINUE

  log_info("Executing gap check for phase: " + phase.id)

  # Script-based
  if gap_check.script exists:
    return execute_gap_check_script(gap_check.script, phase, context)

  # Criteria-based
  if gap_check.criteria exists:
    return execute_gap_check_criteria(gap_check.criteria, phase, context)

  log_warning("Gap check enabled but no script or criteria defined")
  return CONTINUE

execute_gap_check_script(script, phase, context):
  # Execute script
  result = execute_script(script, context)

  # Validate result
  if not is_valid_gap_check_result(result):
    log_warning("Invalid gap check result, treating as pass")
    return CONTINUE

  # Record in context
  record_gap_check(phase.id, result)

  # Handle based on status
  if result.status == 'complete':
    log_info("Gap check passed")
    return CONTINUE

  # Incomplete
  log_info("Gap check identified gaps: " + result.gaps.join(', '))

  return handle_gap_check_action(result, phase, context)

handle_gap_check_action(result, phase, context):
  action = result.action

  if action == 'retry':
    # Check iteration limit
    current = context.iterations[phase.id] || 1
    max = phase.max_iterations || 10

    if current >= max:
      log_warning("Max iterations reached, escalating")
      return escalate_to_user(result, phase)

    log_info("Retrying phase due to gaps")
    increment_iteration(phase.id)
    return RETRY_PHASE

  elif action == 'spawn_additional':
    log_info("Spawning additional agents to fill gaps")
    additional = result.additionalAgents
    spawn_parallel_subagents(additional, context)
    return CONTINUE

  elif action == 'escalate':
    return escalate_to_user(result, phase)

  elif action == 'abort':
    log_error("Gap check failed critically, aborting")
    context_update("status", "failed")
    context_update("error", result.message)
    return ABORT

escalate_to_user(result, phase):
  # Display gaps
  log_info("Gaps found:")
  for gap in result.gaps:
    log_info("  - " + gap)

  # Prompt user
  decision = ask_user(
    result.message || "Gap check found issues. How to proceed?",
    ["Continue anyway", "Retry phase", "Abort workflow"]
  )

  if decision == "Continue anyway":
    return CONTINUE
  elif decision == "Retry phase":
    increment_iteration(phase.id)
    return RETRY_PHASE
  elif decision == "Abort workflow":
    return ABORT
```

---

## Best Practices

### When to Use Gap Checks
- After discovery/research phases (check completeness)
- After analysis phases (check coverage)
- Before expensive operations (validate prerequisites)
- Before synthesis (check all inputs present)

### Script Design
- Keep scripts focused (single responsibility)
- Return clear, actionable gaps
- Choose appropriate action (retry vs. spawn vs. escalate)
- Provide helpful messages for escalation

### Criteria Design
- Max 5 criteria per phase (avoid fatigue)
- Make criteria objective ("X exists?" not "X good?")
- Order by importance (critical first)
- Use clear, specific language

### Action Selection
- **retry**: Whole phase needs rework
- **spawn_additional**: Targeted fix possible
- **escalate**: Uncertain criticality
- **abort**: Blocking issue, cannot proceed
```

**Validation:**
- Gap check flow documented
- All actions explained
- Scripting API defined
- Error handling specified

---

### Task 0.6: Document Inline Scripting API
**File:** `SCRIPTING_API.md`
**Estimated:** 3 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Inline Scripting API

## Overview

Inline scripts enable custom logic in workflow definitions for:
- Adaptive subagent selection
- Gap check evaluation
- Checkpoint conditions
- Custom main agent behavior (loose mode)

**Language:** JavaScript (ES6+)
**Execution:** Node.js via `script-interpreter.sh`

---

## Context Injection

### Available in All Scripts

```javascript
// Workflow context (read-only)
const context = {
  feature_name: "user-dashboard",
  workflow_name: "New Feature Planning",
  flags: ["--frontend"],
  current_phase: "discovery",
  completed_phases: ["plan"],
  subagents_spawned: 3,
  iterations: { discovery: 1 },
  checkpoints: {},
  deliverables: [],
  status: "running"
};
```

---

## Helper Functions

### File Operations

#### readFile(path)
**Description:** Read file contents as string

**Signature:**
```javascript
async readFile(path: string): Promise<string>
```

**Example:**
```javascript
const synthesis = await readFile('.temp/synthesis.md');
if (synthesis.includes('performance')) {
  // ... decision logic
}
```

---

#### readFiles(paths)
**Description:** Read multiple files, return object keyed by path

**Signature:**
```javascript
async readFiles(paths: string[]): Promise<Record<string, string>>
```

**Example:**
```javascript
const findings = await readFiles([
  '.temp/phase1/web-research.md',
  '.temp/phase1/docs.md'
]);

const combined = findings['.temp/phase1/web-research.md'] +
                 findings['.temp/phase1/docs.md'];
```

---

#### writeFile(path, content)
**Description:** Write content to file

**Signature:**
```javascript
async writeFile(path: string, content: string): Promise<void>
```

**Example:**
```javascript
await writeFile('.temp/phase2/summary.md', `
# Summary
...
`);
```

---

### Analysis Functions

#### analyzeFiles(directory)
**Description:** Analyze files in directory, return coverage metrics

**Signature:**
```javascript
async analyzeFiles(directory: string): Promise<FileCoverageResult>

interface FileCoverageResult {
  total_files: number;
  analyzed: number;
  coverage: number;  // 0.0 to 1.0
  file_types: Record<string, number>;
}
```

**Example:**
```javascript
const coverage = await analyzeFiles('.temp/phase1-discovery/');

if (coverage.coverage < 0.8) {
  return {
    status: 'incomplete',
    gaps: [`Coverage only ${coverage.coverage * 100}%`],
    action: 'retry'
  };
}
```

---

#### identifyGaps(coverage)
**Description:** Identify gaps from coverage analysis

**Signature:**
```javascript
async identifyGaps(coverage: FileCoverageResult): Promise<string[]>
```

**Example:**
```javascript
const coverage = await analyzeFiles('.temp/phase1/');
const gaps = await identifyGaps(coverage);
// Returns: ['Missing dependency analysis', 'No pattern documentation']
```

---

### Main Agent Functions

#### thinkHard(prompt)
**Description:** Invoke main agent extended thinking

**Signature:**
```javascript
async thinkHard(prompt: string): Promise<ThinkResult>

interface ThinkResult {
  decision: 'yes' | 'no' | string;
  reasoning: string;
  confidence: number;  // 0.0 to 1.0
}
```

**Example:**
```javascript
const result = await thinkHard(`
  Review findings:
  ${webFindings.slice(0, 200)}...

  Do we need codebase analysis? (yes/no)
  Consider:
  1. Are there code references?
  2. Is implementation detail missing?
`);

if (result.decision === 'yes') {
  return [
    { type: 'code-scout', output: '.temp/code.json' }
  ];
}
```

---

#### spawnSubagent(config)
**Description:** Spawn a subagent (loose mode only)

**Signature:**
```javascript
async spawnSubagent(config: SubagentConfig): Promise<void>

interface SubagentConfig {
  type: string;
  prompt?: string;
  prompt_vars?: Record<string, any>;
  output: string;
}
```

**Example:**
```javascript
await spawnSubagent({
  type: 'code-scout',
  prompt_vars: { focus: 'authentication patterns' },
  output: '.temp/deep-dive/auth-patterns.json'
});
```

---

#### invokeSkill(name, args)
**Description:** Invoke Claude Code skill (loose mode only)

**Signature:**
```javascript
async invokeSkill(name: string, args: Record<string, any>): Promise<void>
```

**Example:**
```javascript
await invokeSkill('codebase-researcher', {
  topic: 'authentication patterns',
  output_dir: '.temp/deep-dive/'
});
```

---

## Return Values

### Adaptive Subagent Selection

**Required for:** `phases[].subagents.adaptive.script`

**Return Type:**
```typescript
SubagentConfig[]
```

**Example:**
```javascript
// Must return array of subagent configs
return [
  { type: 'code-scout', output: '.temp/phase1/code.json' },
  { type: 'pattern-analyzer', output: '.temp/phase1/patterns.json' }
];

// Or empty array if no additional subagents needed
return [];
```

---

### Gap Check Scripts

**Required for:** `phases[].gap_check.script`

**Return Type:**
```typescript
interface GapCheckResult {
  status: 'complete' | 'incomplete';
  gaps?: string[];
  action?: 'retry' | 'spawn_additional' | 'escalate' | 'abort';
  additionalAgents?: SubagentConfig[];
  message?: string;
}
```

**Example:**
```javascript
return {
  status: 'incomplete',
  gaps: ['Missing dependency analysis', 'Pattern coverage < 80%'],
  action: 'spawn_additional',
  additionalAgents: [
    { type: 'dependency-deep-dive', output: '.temp/deps.json' }
  ],
  message: 'Filling identified gaps'
};
```

---

### Checkpoint Conditions

**Required for:** `phases[].checkpoint.condition`

**Return Type:**
```typescript
boolean
```

**Example:**
```javascript
// Show checkpoint only in production
return context.environment === 'production';
```

---

### Main Agent Scripts (Loose Mode)

**Required for:** `phases[].main_agent.script` (loose mode)

**Return Type:** None (script performs actions directly)

**Example:**
```javascript
// Read context
const synthesis = await readFile('.temp/synthesis.md');

// Decide actions
if (synthesis.includes('performance')) {
  await spawnSubagent({
    type: 'bottleneck-identifier',
    output: '.temp/deep-dive/perf.json'
  });
}

// Perform own analysis
const myAnalysis = `...`;
await writeFile('.temp/deep-dive/analysis.md', myAnalysis);

// No return value needed
```

---

## Error Handling

### Try-Catch Blocks

```javascript
try {
  const findings = await readFiles([...]);
  // ... logic
} catch (error) {
  // Log error
  console.error('Script error:', error.message);

  // Return safe default
  return [];  // or { status: 'complete' }
}
```

---

### Null/Undefined Checks

```javascript
const synthesis = await readFile('.temp/synthesis.md');

if (!synthesis) {
  // File missing or empty
  return {
    status: 'incomplete',
    gaps: ['Synthesis file missing'],
    action: 'abort'
  };
}
```

---

### Type Validation

```javascript
// Validate return value structure
function validateGapCheckResult(result) {
  if (!result.status) {
    throw new Error('Gap check result missing status');
  }
  if (result.status === 'incomplete' && !result.action) {
    throw new Error('Incomplete status requires action');
  }
  return true;
}
```

---

## Best Practices

### Keep Scripts Short
```javascript
// Good: <20 lines, single purpose
const coverage = await analyzeFiles('.temp/phase1/');
if (coverage.coverage < 0.8) {
  return { status: 'incomplete', action: 'retry' };
}
return { status: 'complete' };

// Bad: >50 lines, complex logic
// ... complex analysis, multiple concerns
```

---

### Use Main Agent Thinking
```javascript
// Good: Delegate decision to main agent
const decision = await thinkHard('Should we spawn code-scout?');
return decision === 'yes' ? [{ type: 'code-scout', ... }] : [];

// Bad: Hard-code complex decision logic in script
if (conditionA && (conditionB || conditionC) && !conditionD) {
  // ...
}
```

---

### Provide Clear Error Messages
```javascript
// Good
return {
  status: 'incomplete',
  gaps: ['Dependency analysis missing for module X'],
  message: 'Cannot proceed without dependency information',
  action: 'abort'
};

// Bad
return {
  status: 'incomplete',
  gaps: ['Missing stuff'],
  action: 'abort'
};
```

---

### Validate Inputs
```javascript
// Good: Check file existence
const exists = await fileExists('.temp/phase1/codebase.json');
if (!exists) {
  return { status: 'incomplete', action: 'retry' };
}

// Bad: Assume file exists
const data = await readFile('.temp/phase1/codebase.json');  // May throw
```

---

## Limitations

### No External Dependencies
- Cannot `require()` npm packages
- Only built-in Node.js modules available
- Must use provided helper functions

### No Async await Outside Helpers
- Top-level await supported
- But helper functions must be awaited
- No custom Promise creation

### No Direct File System Access
- Must use `readFile`, `writeFile` helpers
- Cannot use `fs.readFileSync()`
- Prevents security issues

### Limited Context Mutation
- Context is read-only in scripts
- Cannot modify `context` object directly
- Use return values to signal changes

---

## Testing Scripts

### Unit Testing

```javascript
// test-script.js
const script = `
  const coverage = await analyzeFiles('.temp/phase1/');
  return coverage.coverage > 0.8 ?
    { status: 'complete' } :
    { status: 'incomplete', action: 'retry' };
`;

const context = { /* test context */ };
const result = executeScript(script, context);

assert.equal(result.status, 'complete');
```

---

### Debug Mode

```bash
# Enable debug logging
DEBUG=true bash engine/workflow-runner.sh workflow.yaml feature-name

# Script execution will be logged
[DEBUG] Executing script: const coverage = await...
[DEBUG] Script returned: { status: 'complete' }
```

---

## Examples

### Example 1: Adaptive Discovery
```javascript
// In workflow YAML:
# subagents:
#   adaptive:
#     script: |

const webFindings = await readFile('.temp/phase1/web-research.md');
const docFindings = await readFile('.temp/phase1/docs.md');

const needsCode = await thinkHard(`
  Review findings. Do we need codebase analysis?
  Web: ${webFindings.slice(0, 100)}...
  Docs: ${docFindings.slice(0, 100)}...
`);

if (needsCode.decision === 'yes') {
  return [
    { type: 'code-scout', output: '.temp/phase1/code.json' },
    { type: 'pattern-analyzer', output: '.temp/phase1/patterns.json' }
  ];
}

return [];
```

---

### Example 2: Coverage Gap Check
```javascript
// gap_check:
//   script: |

const coverage = await analyzeFiles('.temp/phase1-discovery/');

if (coverage.coverage < 0.8) {
  const gaps = await identifyGaps(coverage);

  return {
    status: 'incomplete',
    gaps: gaps,
    action: 'spawn_additional',
    additionalAgents: [
      { type: 'coverage-enhancer', output: '.temp/phase1/enhanced.json' }
    ]
  };
}

return { status: 'complete' };
```

---

### Example 3: Conditional Checkpoint
```javascript
// checkpoint:
//   condition: |

// Show checkpoint only for production deployments
return context.flags.includes('--production') ||
       context.feature_name.startsWith('critical-');
```

---

### Example 4: Loose Mode Exploration
```javascript
// main_agent:
//   script: |

const synthesis = await readFile('.temp/synthesis.md');

// Conditionally spawn agents
if (synthesis.includes('performance')) {
  await spawnSubagent({
    type: 'bottleneck-identifier',
    output: '.temp/deep-dive/perf.json'
  });
}

if (synthesis.includes('architecture')) {
  await invokeSkill('codebase-researcher', {
    topic: 'architecture patterns'
  });
}

// Perform own analysis
const analysis = `
# Deep-Dive Analysis
Based on synthesis findings...
`;

await writeFile('.temp/deep-dive/analysis.md', analysis);
```

---

## Troubleshooting

### "Helper function not available"
**Cause:** Calling unsupported function
**Fix:** Use only documented helpers

### "Invalid return value"
**Cause:** Script returned wrong structure
**Fix:** Match required return type exactly

### "Script timeout"
**Cause:** Script took >30 seconds
**Fix:** Simplify logic, reduce file reads

### "Cannot modify context"
**Cause:** Attempted `context.foo = 'bar'`
**Fix:** Use return values to signal changes
```

**Validation:**
- All helpers documented
- Return types specified
- Examples provided
- Best practices included

---

### Task 0.7: Document Required Tooling
**File:** `TOOLING.md`
**Estimated:** 2 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Required Tooling

## Overview

The engine requires external tools for parsing, rendering, and script execution.

**Design principle:** Prefer standard Unix tools, provide fallbacks when possible.

---

## Required Tools

### 1. jq (JSON Processor)
**Version:** 1.6+
**Purpose:** JSON manipulation and querying
**Installation:**
```bash
# macOS
brew install jq

# Ubuntu/Debian
apt-get install jq

# Check version
jq --version
```

**Usage in Engine:**
```bash
# Parse JSON
workflow_name=$(echo "$workflow_json" | jq -r '.name')

# Extract array
phases=$(echo "$workflow_json" | jq -c '.phases')

# Query nested
phase_id=$(echo "$phase" | jq -r '.id')
```

**Fallback:** None (critical dependency)

---

### 2. yq (YAML Processor)
**Version:** 4.x (Go version, not Python yq)
**Purpose:** YAML parsing and YAML ↔ JSON conversion
**Installation:**
```bash
# macOS
brew install yq

# Ubuntu/Debian
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq

# Check version
yq --version
```

**Usage in Engine:**
```bash
# Parse YAML to JSON
workflow_json=$(yq eval -o=json workflow.yaml)

# Query YAML directly
workflow_name=$(yq eval '.name' workflow.yaml)

# Validate YAML
yq eval workflow.yaml > /dev/null
```

**Fallback:** Python with PyYAML
```bash
# Fallback parser
python3 -c '
import yaml, json, sys
with open(sys.argv[1]) as f:
    print(json.dumps(yaml.safe_load(f)))
' workflow.yaml
```

---

### 3. Node.js (JavaScript Runtime)
**Version:** 16+
**Purpose:** Inline script execution
**Installation:**
```bash
# macOS
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Check version
node --version
```

**Usage in Engine:**
```bash
# Execute inline script
node -e "
const context = $context_json;
$inline_script
"

# Execute script file
node /tmp/script.js
```

**Fallback:** None (required for inline scripting)

---

### 4. mustache (Template Rendering)
**Version:** Any (CLI tool)
**Purpose:** Render Mustache templates with JSON context
**Installation:**
```bash
# macOS/Linux via npm
npm install -g mustache

# Ruby version (alternative)
gem install mustache

# Check
mustache --version
```

**Usage in Engine:**
```bash
# Render template
echo "$context_json" | mustache template.md.tmpl > output.md

# With file input
mustache context.json template.md.tmpl > output.md
```

**Fallback:** Custom bash parser (simple {{var}} substitution)
```bash
# Simple variable substitution fallback
render_template_simple() {
  local template="$1"
  local context="$2"
  local output="$3"

  local content=$(cat "$template")
  local vars=$(echo "$content" | grep -oE '\{\{[^}]+\}\}' | sed 's/[{}]//g' | sort -u)

  for var in $vars; do
    local value=$(echo "$context" | jq -r ".$var // \"\"")
    content=$(echo "$content" | sed "s|{{${var}}}|${value}|g")
  done

  echo "$content" > "$output"
}
```

---

### 5. envsubst (Variable Substitution)
**Version:** Standard (part of gettext)
**Purpose:** Substitute ${VAR} in strings
**Installation:**
```bash
# Usually pre-installed
# macOS
brew install gettext
brew link --force gettext

# Ubuntu/Debian
apt-get install gettext

# Check
envsubst --version
```

**Usage in Engine:**
```bash
# Substitute variables
output_path=".claude/plans/${feature_name}/plan.md"
output_path=$(echo "$output_path" | envsubst)
# Result: .claude/plans/user-dashboard/plan.md
```

**Fallback:** Bash parameter expansion
```bash
# Manual substitution
eval "echo $output_path"
```

---

## Dependency Checker Script

**File:** `tools/check-deps.sh`

```bash
#!/bin/bash

check_dependency() {
  local cmd="$1"
  local required="$2"
  local install_msg="$3"

  if command -v "$cmd" &> /dev/null; then
    echo "✓ $cmd found"
    return 0
  else
    if [[ "$required" == "true" ]]; then
      echo "✗ $cmd NOT FOUND (REQUIRED)"
      echo "  Install: $install_msg"
      return 1
    else
      echo "⚠ $cmd not found (optional)"
      echo "  Install: $install_msg"
      return 0
    fi
  fi
}

echo "Checking Workflow Engine v2 dependencies..."
echo ""

failed=0

check_dependency "jq" "true" "brew install jq" || failed=1
check_dependency "yq" "true" "brew install yq" || failed=1
check_dependency "node" "true" "brew install node" || failed=1
check_dependency "mustache" "false" "npm install -g mustache"
check_dependency "envsubst" "false" "brew install gettext"

echo ""
if [[ $failed -eq 1 ]]; then
  echo "❌ Missing required dependencies"
  exit 1
else
  echo "✅ All required dependencies found"
  exit 0
fi
```

---

## Version Compatibility

### jq
- **Minimum:** 1.5
- **Recommended:** 1.6+
- **Breaking changes:** None for our usage

### yq
- **Minimum:** 4.0
- **Recommended:** 4.x latest
- **Note:** Python `yq` is different package, use Go version
- **Breaking changes:** v3 → v4 syntax changes

### Node.js
- **Minimum:** 14.x (for async/await)
- **Recommended:** 16.x LTS or 18.x LTS
- **Breaking changes:** None for our usage

### mustache
- **Minimum:** Any version
- **Recommended:** Latest npm version
- **Alternatives:** Ruby mustache, Python pystache

---

## Invocation Patterns

### Safe Invocation

```bash
# Check before use
if ! command -v jq &> /dev/null; then
  echo "Error: jq not installed"
  exit 1
fi

# Use tool
result=$(echo "$json" | jq -r '.field')
```

---

### Error Handling

```bash
# Capture errors
result=$(yq eval workflow.yaml 2>&1)
exit_code=$?

if [[ $exit_code -ne 0 ]]; then
  echo "YAML parse error: $result"
  exit 1
fi
```

---

### Timeout Protection

```bash
# Prevent hangs
timeout 30s node script.js || {
  echo "Script timeout after 30 seconds"
  exit 1
}
```

---

## Performance Considerations

### yq Optimization
```bash
# Slow: Parse YAML multiple times
name=$(yq eval '.name' workflow.yaml)
desc=$(yq eval '.description' workflow.yaml)

# Fast: Parse once to JSON, then use jq
workflow_json=$(yq eval -o=json workflow.yaml)
name=$(echo "$workflow_json" | jq -r '.name')
desc=$(echo "$workflow_json" | jq -r '.description')
```

---

### jq Optimization
```bash
# Slow: Multiple jq calls
for i in {0..10}; do
  value=$(echo "$json" | jq -r ".array[$i]")
done

# Fast: Single jq call
values=$(echo "$json" | jq -r '.array[]')
for value in $values; do
  # ...
done
```

---

### Node.js Optimization
```bash
# Slow: Spawn node for each script
for script in scripts/*.js; do
  node "$script"
done

# Fast: Single node process
node -e "
  const scripts = ['script1.js', 'script2.js'];
  for (const script of scripts) {
    require(script);
  }
"
```

---

## Testing Tooling

### Unit Tests

```bash
# Test jq availability
test_jq() {
  echo '{"name":"test"}' | jq -r '.name'
  [[ $? -eq 0 ]] && echo "PASS" || echo "FAIL"
}

# Test yq parsing
test_yq() {
  echo "name: test" | yq eval -o=json - | jq -r '.name'
  [[ $? -eq 0 ]] && echo "PASS" || echo "FAIL"
}

# Test node execution
test_node() {
  node -e "console.log('test')" | grep -q "test"
  [[ $? -eq 0 ]] && echo "PASS" || echo "FAIL"
}
```

---

## Troubleshooting

### "jq: command not found"
```bash
# Install jq
brew install jq  # macOS
apt-get install jq  # Ubuntu
```

### "yq: parse error"
```bash
# Check YAML syntax
yq eval workflow.yaml

# Common issues:
# - Tabs instead of spaces
# - Incorrect indentation
# - Missing colons
```

### "node: command not found"
```bash
# Install Node.js
brew install node  # macOS
# or download from nodejs.org
```

### "mustache: command not found"
```bash
# Install via npm
npm install -g mustache

# Or use fallback renderer
# (uses simple {{var}} substitution)
```

---

## Offline Usage

### Pre-install Tools
```bash
# Create portable tooling directory
mkdir -p ~/.claude/skills/use-workflows/bin/

# Download binaries (Linux x64 example)
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O bin/jq
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O bin/yq
chmod +x bin/jq bin/yq

# Add to PATH in engine scripts
export PATH="~/.claude/skills/use-workflows/bin:$PATH"
```

---

## Future Enhancements

### Potential Improvements
1. **Pure bash YAML parser** - Eliminate yq dependency
2. **Compiled binaries** - Ship jq/yq with skill
3. **Docker image** - Self-contained environment
4. **Web Assembly** - Run tools in browser context

### Not Planned
- Remove jq requirement (too useful)
- Remove Node.js requirement (needed for scripting)
- Custom template engine (mustache sufficient)
```

**Validation:**
- All tools documented
- Installation instructions provided
- Usage patterns explained
- Fallbacks specified

---

### Task 0.8: Define Testing Matrix
**File:** `TESTING_STRATEGY.md`
**Estimated:** 2 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Testing Strategy

## Overview

Comprehensive testing across unit, integration, and end-to-end levels.

**Goals:**
- Ensure MVP execution path works
- Validate all execution modes
- Test checkpoint and gap check flows
- Verify backward compatibility
- Catch regressions early

---

## Testing Levels

### 1. Unit Tests
**Scope:** Individual engine components
**Tool:** Bash unit testing framework (shunit2 or custom)
**Location:** `tests/unit/`

---

### 2. Integration Tests
**Scope:** Complete workflow execution
**Tool:** Bash scripts executing workflows
**Location:** `tests/integration/`

---

### 3. End-to-End Tests
**Scope:** Real workflow scenarios
**Tool:** Manual testing + automated scripts
**Location:** `tests/e2e/`

---

## Unit Testing Matrix

### Component: workflow-loader.sh

| Test Case | Input | Expected Output | Status |
|-----------|-------|-----------------|--------|
| Load valid YAML | valid.workflow.yaml | Parsed JSON | ⬜ |
| Load invalid YAML | invalid-syntax.yaml | Error + line number | ⬜ |
| Missing required field | no-name.yaml | Validation error | ⬜ |
| Load JSON (legacy) | legacy.json | Converted to YAML, loaded | ⬜ |
| Invalid execution_mode | bad-mode.yaml | Validation error | ⬜ |

**Test Script:** `tests/unit/test-loader.sh`

```bash
#!/bin/bash
source ../../engine/workflow-loader.sh

test_load_valid_yaml() {
  result=$(load_workflow "fixtures/valid.workflow.yaml")
  name=$(echo "$result" | jq -r '.name')
  assertEquals "Test Workflow" "$name"
}

test_load_invalid_yaml() {
  result=$(load_workflow "fixtures/invalid.yaml" 2>&1)
  assertContains "$result" "parse error"
}

# Run tests
. shunit2
```

---

### Component: phase-executor.sh

| Test Case | Input | Expected Behavior | Status |
|-----------|-------|-------------------|--------|
| Execute strict mode | phase with always subagents | Spawn all subagents | ⬜ |
| Execute loose mode | phase with main_agent script | Execute script only | ⬜ |
| Execute adaptive mode | phase with adaptive script | Spawn always + conditionals | ⬜ |
| Parallel behavior | 3 subagents | Spawn simultaneously | ⬜ |
| Sequential behavior | 3 subagents | Spawn one-by-one | ⬜ |
| Main-only behavior | No subagents | Execute main script | ⬜ |

**Test Script:** `tests/unit/test-executor.sh`

---

### Component: context-manager.sh

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Initialize context | Create context.json | ⬜ |
| Update context value | JSON updated | ⬜ |
| Read context value | Correct value returned | ⬜ |
| Phase start tracking | current_phase updated | ⬜ |
| Phase complete tracking | Added to completed_phases | ⬜ |
| Subagent count increment | Count incremented | ⬜ |

---

### Component: checkpoint-handler.sh

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Simple approval (continue) | Proceed to next phase | ⬜ |
| Simple approval (abort) | Exit workflow | ⬜ |
| Custom checkpoint (continue) | Proceed | ⬜ |
| Custom checkpoint (repeat) | Phase index updated | ⬜ |
| Custom checkpoint (skip) | Phases marked for skip | ⬜ |
| Conditional checkpoint (false) | Skip checkpoint | ⬜ |
| Conditional checkpoint (true) | Show checkpoint | ⬜ |

---

### Component: gap-check-manager.sh

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Gap check disabled | Skip check | ⬜ |
| Gap check pass | Continue | ⬜ |
| Gap check fail (retry) | Repeat phase | ⬜ |
| Gap check fail (spawn) | Spawn additional agents | ⬜ |
| Gap check fail (escalate) | Prompt user | ⬜ |
| Gap check fail (abort) | Exit workflow | ⬜ |
| Max iterations reached | Escalate to user | ⬜ |

---

### Component: script-interpreter.sh

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Execute valid script | Return correct value | ⬜ |
| Script with context | Context accessible | ⬜ |
| Script with helpers | Helpers available | ⬜ |
| Script error | Error logged, handled | ⬜ |
| Script timeout | Timeout after 30s | ⬜ |
| Invalid return value | Warning logged | ⬜ |

---

### Component: template-renderer.sh

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Render simple template | Variables substituted | ⬜ |
| Render with missing var | Empty string inserted | ⬜ |
| Render with conditionals | Sections shown/hidden | ⬜ |
| Render subagent prompt | Workflow-specific template | ⬜ |
| Fallback renderer | Simple substitution works | ⬜ |

---

## Integration Testing Matrix

### Workflow Type: new-feature

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Complete execution | All phases execute | ⬜ |
| Deliverables created | All required files exist | ⬜ |
| Metadata generated | metadata.json correct | ⬜ |
| Gap check passes | No retries needed | ⬜ |
| Checkpoint passes | User continues | ⬜ |
| Final plan rendered | plan.md created | ⬜ |

**Test Script:** `tests/integration/test-new-feature.sh`

```bash
#!/bin/bash

test_new_feature_workflow() {
  # Run workflow
  bash ../../engine/workflow-runner.sh \
    ../../workflows/new-feature.workflow.yaml \
    "test-feature" \
    '["--frontend"]'

  # Verify deliverables
  assertTrue "[ -f .claude/plans/test-feature/plan.md ]"
  assertTrue "[ -f .claude/plans/test-feature/metadata.json ]"
  assertTrue "[ -d .claude/plans/test-feature/.temp ]"

  # Verify metadata
  workflow=$(jq -r '.workflow' .claude/plans/test-feature/metadata.json)
  assertEquals "New Feature Planning" "$workflow"
}

. shunit2
```

---

### Workflow Type: debugging

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Reproduction phase | Bug reproduced | ⬜ |
| Root-cause phase | Hypothesis generated | ⬜ |
| Solution phase | Fix designed | ⬜ |
| All deliverables | Files created | ⬜ |
| Metadata correct | Workflow tracked | ⬜ |

---

### Workflow Type: refactoring

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Analysis phase | Code smells found | ⬜ |
| Planning phase | Sequence defined | ⬜ |
| Safety validation | Tests checked | ⬜ |
| Deliverables created | Files exist | ⬜ |

---

### Workflow Type: improving

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Assessment phase | Baseline measured | ⬜ |
| Planning phase | Optimization designed | ⬜ |
| ROI validation | Impact estimated | ⬜ |

---

### Workflow Type: quick

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Minimal phases | Only 2-3 phases | ⬜ |
| Fast execution | <15 minutes | ⬜ |
| Basic deliverables | Essential files only | ⬜ |

---

### Custom Workflow: research

| Test Case | Expected Behavior | Status |
|-----------|-------------------|--------|
| Adaptive discovery | Conditional subagents | ⬜ |
| Checkpoint approval | User review works | ⬜ |
| Loose deep-dive | Main agent freedom | ⬜ |
| Final synthesis | Documentation created | ⬜ |

---

## Execution Mode Testing

### Strict Mode

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| Parallel subagents | All spawn simultaneously | ⬜ |
| Sequential subagents | Spawn one-by-one | ⬜ |
| Main-only phase | No subagents spawned | ⬜ |
| No deviation | Exactly as defined | ⬜ |

---

### Loose Mode

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| Main agent decides | Full control | ⬜ |
| Spawn subagent | Works from script | ⬜ |
| Invoke skill | Works from script | ⬜ |
| Suggested subagents | Displayed but ignored | ⬜ |

---

### Adaptive Mode

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| Always subagents | Spawn first | ⬜ |
| Adaptive decision | Conditionals spawn | ⬜ |
| No additional agents | Empty array works | ⬜ |
| Parallel + adaptive | Both batches parallel | ⬜ |

---

## Checkpoint Testing

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| Continue action | Next phase executes | ⬜ |
| Repeat action | Phase re-executes | ⬜ |
| Skip action | Phases skipped | ⬜ |
| Abort action | Workflow exits | ⬜ |
| With feedback | Feedback stored | ⬜ |
| Conditional (true) | Checkpoint shown | ⬜ |
| Conditional (false) | Checkpoint skipped | ⬜ |

---

## Gap Check Testing

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| Pass | Continue to next phase | ⬜ |
| Fail (retry) | Phase re-executes | ⬜ |
| Fail (spawn) | Additional agents spawned | ⬜ |
| Fail (escalate) | User prompted | ⬜ |
| Fail (abort) | Workflow exits | ⬜ |
| Max iterations | Escalation triggered | ⬜ |

---

## Backward Compatibility Testing

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| Load legacy JSON | Auto-converted | ⬜ |
| Execute legacy workflow | Identical behavior | ⬜ |
| Legacy subagent matrix | Still works | ⬜ |
| Legacy phase registry | Still works | ⬜ |
| Legacy templates | Still works | ⬜ |

---

## Performance Testing

| Metric | Target | Status |
|--------|--------|--------|
| Workflow loading | <1 second | ⬜ |
| YAML parsing | <500ms | ⬜ |
| Phase execution overhead | <100ms/phase | ⬜ |
| Context persistence | <50ms/update | ⬜ |
| Template rendering | <500ms | ⬜ |

---

## Test Execution

### Run All Unit Tests
```bash
cd tests/unit
./run-all-tests.sh
```

### Run All Integration Tests
```bash
cd tests/integration
./run-all-tests.sh
```

### Run Specific Test
```bash
cd tests/unit
./test-loader.sh
```

### Test Coverage Report
```bash
./coverage-report.sh
```

---

## CI/CD Integration

### GitHub Actions Workflow

```yaml
name: Test Workflow Engine

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y jq yq
          npm install -g mustache

      - name: Run unit tests
        run: |
          cd tests/unit
          ./run-all-tests.sh

      - name: Run integration tests
        run: |
          cd tests/integration
          ./run-all-tests.sh

      - name: Generate coverage report
        run: ./coverage-report.sh

      - name: Upload coverage
        uses: codecov/codecov-action@v2
```

---

## Manual Testing Checklist

### Before Release

- [ ] Run all unit tests
- [ ] Run all integration tests
- [ ] Test each execution mode
- [ ] Test checkpoints with all actions
- [ ] Test gap checks with all actions
- [ ] Test backward compatibility
- [ ] Test error handling
- [ ] Test performance benchmarks
- [ ] Manual smoke test (create real feature)
- [ ] Review test coverage report

---

## Test Fixtures

### Directory Structure
```
tests/
├── fixtures/
│   ├── workflows/
│   │   ├── valid.workflow.yaml
│   │   ├── invalid.yaml
│   │   ├── strict-mode.yaml
│   │   ├── loose-mode.yaml
│   │   └── adaptive-mode.yaml
│   ├── contexts/
│   │   ├── basic-context.json
│   │   └── advanced-context.json
│   └── templates/
│       └── test-template.md.tmpl
```

---

## Coverage Goals

| Component | Target Coverage | Status |
|-----------|----------------|--------|
| workflow-loader | 90% | ⬜ |
| phase-executor | 90% | ⬜ |
| context-manager | 95% | ⬜ |
| checkpoint-handler | 85% | ⬜ |
| gap-check-manager | 85% | ⬜ |
| script-interpreter | 80% | ⬜ |
| template-renderer | 85% | ⬜ |
| **Overall** | **85%** | ⬜ |

---

## Issue Tracking

### Test Failure Process
1. Test fails
2. Create GitHub issue
3. Label: `bug`, `test-failure`
4. Assign to component owner
5. Fix bug
6. Verify test passes
7. Close issue

---

## Regression Prevention

### Test After Every Change
- Add new test for bug fix
- Run full test suite
- Update test documentation
- Review test coverage

---

## Future Enhancements

### Planned Improvements
1. **Visual test reports** - HTML coverage reports
2. **Performance benchmarks** - Track execution time trends
3. **Snapshot testing** - Compare workflow outputs
4. **Property-based testing** - Fuzz test inputs
5. **Mutation testing** - Verify test effectiveness
```

**Validation:**
- Testing matrix complete
- All components covered
- Integration scenarios defined
- Performance targets set

---

### Task 0.9: Plan Workflow Authoring Support
**File:** `AUTHORING_GUIDE.md`
**Estimated:** 2 hours

**Deliverable:**

```markdown
# Workflow Engine v2 - Workflow Authoring Guide

## Overview

Complete guide for creating custom workflows with validation and tooling support.

---

## Quick Start

### 1. Use Scaffolding Tool

```bash
# Create new workflow from template
bash tools/new-workflow.sh custom-research

# Output:
# Created: workflows/custom-research.workflow.yaml
# Created: examples/custom-research-usage.md
```

---

### 2. Edit Workflow Definition

```yaml
name: Custom Research
description: Deep dive research with iterative refinement

phases:
  - id: discovery
    name: Research Discovery
    execution_mode: adaptive
    behavior: parallel
    # ... (see templates)
```

---

### 3. Validate Workflow

```bash
# Validate against schema
bash tools/validator.sh workflows/custom-research.workflow.yaml

# Output:
# ✓ Workflow structure valid
# ✓ All execution_modes valid
# ✓ All phases have required fields
# ✓ Subagent types exist
```

---

### 4. Test Workflow

```bash
# Dry-run (no actual execution)
bash tools/test-workflow.sh workflows/custom-research.workflow.yaml --dry-run

# Full execution
bash engine/workflow-runner.sh \
  workflows/custom-research.workflow.yaml \
  test-feature \
  '["--frontend"]'
```

---

## Scaffolding Tool

**File:** `tools/new-workflow.sh`

```bash
#!/bin/bash

workflow_name="$1"

if [[ -z "$workflow_name" ]]; then
  echo "Usage: $0 <workflow-name>"
  exit 1
fi

workflow_file="workflows/${workflow_name}.workflow.yaml"

if [[ -f "$workflow_file" ]]; then
  echo "Error: Workflow already exists: $workflow_file"
  exit 1
fi

# Create workflow from template
cat > "$workflow_file" <<'EOF'
name: ${WORKFLOW_NAME}
description: TODO: Describe your workflow

variables:
  example_var: "value"

phases:
  # Phase 1: Discovery
  - id: discovery
    name: Discovery Phase
    execution_mode: strict  # strict | loose | adaptive
    behavior: parallel      # parallel | sequential | main-only

    subagents:
      always:
        - type: codebase-scanner
          output: .temp/phase1-discovery/codebase.json
        # Add more subagents...

    gap_check:
      enabled: true
      criteria:
        - "All relevant files discovered?"
        - "Patterns identified?"

    deliverables:
      required:
        - .temp/phase1-discovery/codebase.json

  # Phase 2: Synthesis
  - id: synthesis
    name: Synthesis
    execution_mode: strict
    behavior: main-only
    approval_required: true

    main_agent:
      script: |
        // Main agent synthesizes findings
        const findings = await readFiles(['.temp/phase1-discovery/']);
        await writeFile('.temp/synthesis.md', 'Synthesis content...');

    deliverables:
      required:
        - .temp/synthesis.md

finalization:
  template: custom-template.md.tmpl  # Create this template
  inputs:
    - .temp/phase1-discovery/
    - .temp/synthesis.md
  output: .claude/plans/\${context.feature_name}/plan.md

metadata:
  typical_duration_minutes: "30-60"
  token_estimate: "20-50K"
  complexity: moderate
  tags:
    - research
    - custom
EOF

# Substitute workflow name
sed -i "s/\${WORKFLOW_NAME}/$workflow_name/g" "$workflow_file"

echo "✓ Created: $workflow_file"
echo ""
echo "Next steps:"
echo "1. Edit the workflow definition"
echo "2. Create template: templates/custom-template.md.tmpl"
echo "3. Validate: bash tools/validator.sh $workflow_file"
echo "4. Test: bash tools/test-workflow.sh $workflow_file"
```

---

## Schema Validator

**File:** `tools/validator.sh`

```bash
#!/bin/bash

workflow_file="$1"

if [[ ! -f "$workflow_file" ]]; then
  echo "Error: File not found: $workflow_file"
  exit 1
fi

echo "Validating: $workflow_file"
echo ""

# Parse YAML
workflow_json=$(yq eval -o=json "$workflow_file" 2>&1)

if [[ $? -ne 0 ]]; then
  echo "✗ YAML syntax error:"
  echo "$workflow_json"
  exit 1
fi

echo "✓ YAML syntax valid"

# Validate against schema
if command -v ajv &> /dev/null; then
  ajv validate -s schemas/workflow.schema.json -d "$workflow_file"
else
  # Manual validation
  name=$(echo "$workflow_json" | jq -r '.name')
  phases=$(echo "$workflow_json" | jq -r '.phases')

  if [[ "$name" == "null" ]]; then
    echo "✗ Missing required field: name"
    exit 1
  fi

  if [[ "$phases" == "null" ]]; then
    echo "✗ Missing required field: phases"
    exit 1
  fi

  echo "✓ Required fields present"
fi

# Validate execution modes
invalid_modes=$(echo "$workflow_json" | jq -r '
  .phases[] |
  select(.execution_mode != null) |
  select(.execution_mode != "strict" and .execution_mode != "loose" and .execution_mode != "adaptive") |
  .execution_mode
')

if [[ -n "$invalid_modes" ]]; then
  echo "✗ Invalid execution_mode values:"
  echo "$invalid_modes"
  exit 1
fi

echo "✓ All execution_modes valid"

# Validate behaviors
invalid_behaviors=$(echo "$workflow_json" | jq -r '
  .phases[] |
  select(.behavior != null) |
  select(.behavior != "parallel" and .behavior != "sequential" and .behavior != "main-only") |
  .behavior
')

if [[ -n "$invalid_behaviors" ]]; then
  echo "✗ Invalid behavior values:"
  echo "$invalid_behaviors"
  exit 1
fi

echo "✓ All behaviors valid"

# Validate subagent types exist
subagent_types=$(echo "$workflow_json" | jq -r '
  .phases[].subagents.always[]?.type
' | sort -u)

for type in $subagent_types; do
  if [[ ! -f "~/.claude/agents/plans/${type}.md" ]]; then
    echo "⚠ Subagent type not found: $type"
  fi
done

echo "✓ Subagent type validation complete"

echo ""
echo "✅ Validation passed"
```

---

## Template Library

### Basic Workflow Template
**File:** `templates/workflow-templates/basic.yaml`

```yaml
name: Basic Workflow
description: Simple sequential workflow

phases:
  - id: phase1
    name: Phase 1
    execution_mode: strict
    behavior: parallel
    subagents:
      always:
        - type: example-subagent
          output: .temp/phase1/output.json

finalization:
  template: basic.md.tmpl
  output: .claude/plans/\${context.feature_name}/plan.md
```

---

### Adaptive Workflow Template
**File:** `templates/workflow-templates/adaptive.yaml`

```yaml
name: Adaptive Workflow
description: Workflow with conditional subagents

phases:
  - id: discovery
    execution_mode: adaptive
    behavior: parallel
    subagents:
      always:
        - type: core-scanner
          output: .temp/phase1/core.json
      adaptive:
        script: |
          const core = await readFile('.temp/phase1/core.json');
          const needsDeep = await thinkHard('Need deep analysis?');
          return needsDeep === 'yes' ?
            [{ type: 'deep-analyzer', output: '.temp/phase1/deep.json' }] :
            [];

finalization:
  template: adaptive.md.tmpl
  output: .claude/plans/\${context.feature_name}/plan.md
```

---

### Human-in-Loop Template
**File:** `templates/workflow-templates/checkpoint.yaml`

```yaml
name: Checkpoint Workflow
description: Workflow with human approval

phases:
  - id: research
    execution_mode: strict
    behavior: parallel
    subagents:
      always:
        - type: researcher
          output: .temp/research.md

  - id: review
    execution_mode: strict
    behavior: main-only
    checkpoint:
      prompt: "Review research before proceeding?"
      show_files:
        - .temp/research.md
      options:
        - label: "Proceed"
          value: continue
        - label: "Refine research"
          value: retry
          on_select:
            action: repeat_phase
            target: research

finalization:
  template: checkpoint.md.tmpl
  output: .claude/plans/\${context.feature_name}/plan.md
```

---

## Best Practices

### Naming Conventions
- **Workflow files:** `kebab-case.workflow.yaml`
- **Phase IDs:** `lowercase-hyphenated`
- **Subagent types:** `lowercase-hyphenated`
- **Deliverables:** `.temp/phase{N}-{category}/{file}`

---

### Phase Design
- **Keep phases focused:** Single responsibility
- **3-7 phases:** Optimal range for most workflows
- **Order by dependency:** Prerequisites first
- **Name clearly:** Verb + noun (e.g., "Analyze Dependencies")

---

### Subagent Selection
- **Start minimal:** Only essential subagents in `always`
- **Use adaptive for depth:** Conditional deep-dives
- **Avoid redundancy:** Don't spawn same agent twice
- **Limit parallelism:** Max 5 simultaneous subagents

---

### Checkpoints
- **Place strategically:** Before expensive work
- **Provide context:** Show relevant files
- **Offer options:** Continue, retry, skip, abort
- **Collect feedback:** Use `with_feedback` when actionable

---

### Gap Checks
- **Check completeness:** After research phases
- **Validate quality:** After synthesis phases
- **Use criteria for simple checks:** Checklist-style
- **Use scripts for complex checks:** Custom analysis

---

## Common Patterns

### Pattern 1: Discovery → Requirements → Design → Synthesis

```yaml
phases:
  - id: discovery
    execution_mode: adaptive
    # Discover codebase, conditionally deep-dive

  - id: requirements
    execution_mode: strict
    # Define what needs to be built

  - id: design
    execution_mode: strict
    # Plan implementation approach

  - id: synthesis
    execution_mode: strict
    behavior: main-only
    # Main agent synthesizes all findings
```

---

### Pattern 2: Research Loop with Checkpoint

```yaml
phases:
  - id: research
    execution_mode: adaptive
    max_iterations: 3
    # Research with conditional depth

  - id: review
    approval_required: true
    # User reviews before proceeding

  - id: deep-dive
    execution_mode: loose
    # Main agent has freedom
```

---

### Pattern 3: Parallel Analysis → Convergence

```yaml
phases:
  - id: frontend-analysis
    parallel_group: analysis
    # Analyze frontend

  - id: backend-analysis
    parallel_group: analysis
    # Analyze backend

  - id: integration
    depends_on: [frontend-analysis, backend-analysis]
    # Synthesize both analyses
```

---

## Troubleshooting

### "Validation failed: missing required field"
**Fix:** Add required field (`name`, `phases`, `finalization`)

### "Subagent type not found"
**Fix:** Check subagent exists in `~/.claude/agents/plans/`

### "Execution mode invalid"
**Fix:** Use `strict`, `loose`, or `adaptive` only

### "Circular phase dependency"
**Fix:** Review `depends_on` fields, remove cycles

### "Template not found"
**Fix:** Create template in `templates/` directory

---

## Documentation Standards

### Workflow README
Each workflow should have a README:

```markdown
# Custom Research Workflow

## Purpose
Deep dive research with iterative refinement

## When to Use
- Exploring new problem spaces
- Comprehensive codebase analysis
- Multi-source research

## Phases
1. **Discovery** - Initial research (adaptive)
2. **Synthesis** - Review and decide (checkpoint)
3. **Deep-dive** - Targeted analysis (loose)

## Expected Duration
60-120 minutes

## Token Usage
50-150K tokens

## Example
bash engine/workflow-runner.sh \
  workflows/custom-research.workflow.yaml \
  feature-name \
  '[]'
```

---

## Resources

### Documentation
- [YAML Syntax Guide](resources/yaml-syntax.md)
- [Execution Modes](EXECUTION_MODES.md)
- [Checkpoint Flow](CHECKPOINT_FLOW.md)
- [Gap Check Flow](GAP_CHECK_FLOW.md)
- [Scripting API](SCRIPTING_API.md)

### Examples
- `examples/custom-research.workflow.yaml`
- `examples/code-review.workflow.yaml`
- `examples/performance-optimization.workflow.yaml`

### Tools
- `tools/new-workflow.sh` - Create new workflow
- `tools/validator.sh` - Validate workflow
- `tools/test-workflow.sh` - Test workflow
- `tools/converter.sh` - Convert JSON → YAML
```

**Validation:**
- Authoring guide complete
- Scaffolding tool planned
- Validator designed
- Templates provided
- Best practices documented

---

## Summary of Phase 0

**Days 1-2: Foundation & Design Complete**

✅ **9 comprehensive documents created:**
1. ARCHITECTURE.md - MVP execution path
2. DATA_MODELS.md - All schema definitions
3. EXECUTION_MODES.md - Strict/loose/adaptive logic
4. CHECKPOINT_FLOW.md - Human-in-loop documentation
5. GAP_CHECK_FLOW.md - Gap check flows
6. SCRIPTING_API.md - Inline scripting reference
7. TOOLING.md - Required dependencies
8. TESTING_STRATEGY.md - Complete testing matrix
9. AUTHORING_GUIDE.md - Workflow creation guide

**Total Estimated Time:** 19 hours (across 2 days)

**Next Phase:** Begin MVP implementation with clear architectural foundation

---

*[Implementation continues with Phase 1: MVP Implementation (Days 3-5)...]*

**Note:** The rest of the implementation plan continues from the original IMPLEMENTATION_PLAN.md, but now with proper Phase 0 foundation established first.

---

## Updated Timeline

**Phase 0:** Foundation & Design (Days 1-2) ← NEW
**Phase 1:** MVP Implementation (Days 3-5) ← Renumbered
**Phase 2:** Advanced Features (Days 6-8) ← Renumbered
**Phase 3:** Workflows & Templates (Days 9-11) ← Renumbered
**Phase 4:** Testing & Documentation (Days 12-14) ← Renumbered
**Phase 5:** Launch & Migration (Days 15-16) ← NEW

**Total: 14-16 days** (was 10-12 days, increased for proper documentation)

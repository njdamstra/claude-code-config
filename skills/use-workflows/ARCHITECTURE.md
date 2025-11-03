# Workflow Engine v2 - MVP Execution Path

## Core Flow

```
workflow-runner.sh
  ↓
1. LOAD: Parse YAML → JSON (workflow-loader.sh)
  ↓
2. VALIDATE: Check schema compliance
  ↓
3. INIT: Create context.json (context-manager.sh)
  ↓
4. ANNOUNCE: Display workflow plan to user
  ↓
5. ITERATE PHASES:
   for each phase in phases[]:
     ↓
     a. CHECK SKIP: context.skip_phases contains phase.id? → skip
     ↓
     b. RESOLVE MODE: phase.execution_mode || workflow.execution_mode
     ↓
     c. EXECUTE PHASE (phase-executor.sh):
        - Use resolved mode (strict/loose/adaptive)
        - Spawn subagents per mode logic
        - Execute main_agent script if defined
        - Track deliverables in context
     ↓
     d. GAP CHECK (gap-check-manager.sh):
        - Execute gap_check.script or evaluate criteria
        - On incomplete: retry/spawn_additional/escalate/abort
        - Update context with iteration count
     ↓
     e. CHECKPOINT (checkpoint-handler.sh):
        - Evaluate checkpoint condition
        - Present options to user
        - Handle action: continue/repeat_phase/skip_phases/abort
        - Update context with decision
     ↓
     f. RELOAD: context-manager.sh reloads context.json
  ↓
6. FINALIZE: Render final plan template (template-renderer.sh)
  ↓
7. METADATA: Generate metadata.json
  ↓
8. EXIT: Return 0 (success), 1 (error), 2 (user abort)
```

## Data Flow

```
YAML file
  ↓ yq
JSON (in-memory)
  ↓
context.json (disk)
  ↓ read/write cycles
Updated context.json
  ↓
metadata.json (final output)
```

## Module Dependencies

```
workflow-runner.sh
  ├─ workflow-loader.sh
  │    └─ utils.sh (yaml_parse)
  ├─ context-manager.sh
  │    └─ utils.sh (json_get/set)
  ├─ phase-executor.sh
  │    ├─ subagent-pool.sh
  │    │    └─ template-renderer.sh
  │    └─ script-interpreter.sh
  ├─ gap-check-manager.sh
  │    └─ script-interpreter.sh
  ├─ checkpoint-handler.sh
  │    └─ script-interpreter.sh
  └─ template-renderer.sh
       └─ utils.sh (substitute_vars)
```

## File System Structure

```
~/.claude/skills/use-workflows/
├── engine/
│   ├── workflow-runner.sh      # Entry point
│   ├── workflow-loader.sh      # YAML → JSON
│   ├── context-manager.sh      # State persistence
│   ├── phase-executor.sh       # Mode dispatch
│   ├── subagent-pool.sh        # Parallel/sequential spawning
│   ├── checkpoint-handler.sh   # Human-in-loop
│   ├── gap-check-manager.sh    # Quality gates
│   ├── script-interpreter.sh   # JS execution
│   ├── template-renderer.sh    # Mustache/fallback
│   └── utils.sh                # Shared functions
├── workflows/
│   ├── *.workflow.yaml         # Workflow definitions
│   └── legacy/                 # Archived JSON
├── subagents/
│   └── prompts/
│       └── {type}/
│           └── {workflow}.md.tmpl
├── schemas/
│   ├── workflow.schema.json
│   ├── phase.schema.json
│   └── context.schema.json
├── tools/
│   ├── new-workflow.sh         # Scaffolding
│   ├── validator.sh            # Schema validation
│   └── check-deps.sh           # Dependency verification
└── .temp/
    └── {feature}/
        ├── context.json        # Runtime state
        ├── deliverables/       # Phase outputs
        └── metadata.json       # Final report
```

## State Transitions

### Phase Execution
```
PENDING → IN_PROGRESS → (GAP_CHECK) → (CHECKPOINT) → COMPLETED
                            ↓             ↓
                          RETRY      REPEAT/SKIP/ABORT
```

### Context Lifecycle
```
INIT → PHASE_START → SUBAGENT_SPAWN → PHASE_COMPLETE → CHECKPOINT → NEXT_PHASE
  ↓                      ↓                                ↓
context.json        context.subagents_spawned++     context.decisions[]
```

## Execution Modes Logic

**Note:** Mode resolved per-phase: `phase.execution_mode || workflow.execution_mode`

### Strict Mode
```
if behavior == 'parallel':
  spawn all subagents simultaneously (batched if >5)
else if behavior == 'sequential':
  spawn subagents one-by-one (wait for each)
else if behavior == 'main-only':
  execute main_agent.script only (no subagents)
```

### Loose Mode
```
log suggested subagents (informational only)
execute main_agent.script with full autonomy
```

### Adaptive Mode
```
spawn subagents.always[] (per behavior)
execute subagents.adaptive.script
  → returns [{type, config}] array
spawn returned subagents dynamically
```

### Mixed-Mode Example
```
workflow.execution_mode = adaptive (default)

Phase 1: discovery
  mode = adaptive (uses workflow default)
  → spawn always + conditional subagents

Phase 2: finalization
  mode = loose (override)
  → main agent synthesizes with full control
```

## Critical Paths

**Shortest path (main-only):**
```
Load → Validate → Init → Execute main script → Finalize → Exit
```

**Longest path (adaptive + checkpoints + retries):**
```
Load → Validate → Init → Phase 1 → Gap Check (retry 3x) → Checkpoint (repeat phase) →
Phase 2 → Checkpoint (skip phases) → Phase N → Finalize → Exit
```

## Error Handling

```
Validation error → log + exit 1
Script timeout → log + continue
Gap check abort → exit 1
Checkpoint abort → exit 2
Missing dependency → exit 1
```

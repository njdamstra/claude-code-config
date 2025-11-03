# Data Models

## Workflow Schema (YAML)

```yaml
name: string                    # Workflow identifier
description: string             # Human-readable purpose
execution_mode: enum            # strict | loose | adaptive (workflow-level default)
phases:                         # Array of phase definitions
  - id: string
    name: string
    description: string
    execution_mode: enum        # Optional per-phase override (strict | loose | adaptive)
    behavior: enum              # parallel | sequential | main-only
    main_agent:                 # Optional main script
      script: string            # JS code
    subagents:                  # Mode-dependent structure
      - type: string            # Subagent identifier
        config: object          # Subagent parameters
    checkpoint: object          # Optional checkpoint config
    gap_check: object           # Optional validation config
    skills: array               # Optional skill invocations
finalization:
  template: string              # Path to final plan template
  output: string                # Destination path
```

## Phase Schema

**Note:** Each phase can optionally declare `execution_mode` to override workflow default.

### Strict Mode Phase
```yaml
id: string
name: string
description: string
execution_mode: strict          # Optional override
behavior: parallel | sequential | main-only
subagents:                      # Required for parallel/sequential
  - type: string
    config:
      output_path: string
      max_tokens: number
      model: string
main_agent:                     # Required for main-only
  script: string
```

### Loose Mode Phase
```yaml
id: string
name: string
description: string
execution_mode: loose           # Optional override
behavior: main-only             # Only valid behavior
main_agent:                     # Required
  script: string
suggested_subagents:            # Informational only
  - type: string
```

### Adaptive Mode Phase
```yaml
id: string
name: string
description: string
execution_mode: adaptive        # Optional override
behavior: parallel | sequential
subagents:
  always:                       # Always spawned
    - type: string
      config: object
  adaptive:                     # Conditionally spawned
    script: string              # Returns subagent array
```

### Mixed-Mode Workflow Example
```yaml
name: research-with-finalization
execution_mode: adaptive        # Workflow default
phases:
  - id: discovery
    # Uses workflow default (adaptive)
    behavior: parallel
    subagents:
      always: [...]
      adaptive: {...}

  - id: finalization
    execution_mode: loose       # Override to loose for this phase
    behavior: main-only
    main_agent:
      script: |
        const plan = await thinkHard("Synthesize all findings");
        writeFile('final-plan.md', plan);
```

## Context Schema (Runtime State)

```json
{
  "workflow": {
    "name": "string",
    "started_at": "ISO8601",
    "execution_mode": "strict|loose|adaptive"
  },
  "feature": {
    "name": "string",
    "flags": ["array", "of", "flags"]
  },
  "phases": {
    "current": "phase_id",
    "completed": ["phase_1", "phase_2"],
    "iteration_counts": {
      "phase_1": 1,
      "phase_2": 3
    }
  },
  "subagents_spawned": 12,
  "deliverables": [
    {
      "phase": "phase_1",
      "path": "/path/to/file.md",
      "timestamp": "ISO8601"
    }
  ],
  "checkpoints": [
    {
      "phase": "phase_2",
      "decision": "continue",
      "feedback": "Looks good",
      "timestamp": "ISO8601"
    }
  ],
  "skip_phases": ["phase_4", "phase_5"],
  "gap_checks": [
    {
      "phase": "phase_1",
      "status": "complete",
      "attempts": 2
    }
  ]
}
```

## Checkpoint Schema

### Simple Approval
```yaml
checkpoint:
  approval_required: true
```

### Custom Checkpoint
```yaml
checkpoint:
  condition: "context.subagents_spawned > 0"  # Optional JS expression
  prompt: "Review phase outputs before continuing?"
  show_files:                                  # Optional file list
    - "{{output_dir}}/plan.md"
  options:
    - label: "Continue"
      on_select:
        action: continue
    - label: "Redo Phase"
      on_select:
        action: repeat_phase
        target: "current"
    - label: "Skip Next Phase"
      with_feedback: true
      on_select:
        action: skip_phases
        phases: ["phase_3"]
    - label: "Abort"
      on_select:
        action: abort
```

## Gap Check Schema

### Script-Based
```yaml
gap_check:
  enabled: true
  max_iterations: 3
  script: |
    const gaps = identifyGaps(context.deliverables);
    if (gaps.length === 0) {
      return { status: 'complete' };
    }
    return {
      status: 'incomplete',
      gaps: gaps,
      action: 'spawn_additional',
      additionalAgents: [
        { type: 'code-scout', config: { focus: 'missing-patterns' } }
      ]
    };
```

### Criteria-Based
```yaml
gap_check:
  enabled: true
  criteria:
    - name: "All files created"
      check: "files_exist(['plan.md', 'architecture.md'])"
    - name: "No TODOs left"
      check: "!contains_todos(deliverables)"
  on_failure:
    action: escalate
    message: "Quality criteria not met. Continue anyway?"
```

## Subagent Config Schema

```yaml
type: string                    # Subagent identifier
config:
  output_path: string           # Where to write results
  max_tokens: number            # Optional token limit
  model: string                 # Optional model override (haiku/sonnet/opus)
  context:                      # Optional context injection
    key: value
```

## Skills Schema

```yaml
skills:
  - name: "codebase-researcher"
    condition: "context.feature.flags.includes('backend')"
    args:
      - "--scope=backend"
      - "--output={{output_dir}}/research.md"
```

## Deliverable Record

```json
{
  "phase": "phase_1",
  "subagent": "code-scout",
  "path": "/abs/path/to/output.md",
  "size_bytes": 12345,
  "created_at": "ISO8601"
}
```

## Checkpoint Record

```json
{
  "phase": "phase_2",
  "decision": "skip_phases",
  "skipped": ["phase_3", "phase_4"],
  "feedback": "User comment",
  "timestamp": "ISO8601"
}
```

## Gap Check Record

```json
{
  "phase": "phase_1",
  "iteration": 2,
  "status": "incomplete",
  "gaps": ["Missing test coverage", "No error handling"],
  "action_taken": "spawn_additional",
  "agents_spawned": ["test-planner"],
  "timestamp": "ISO8601"
}
```

## Metadata Output

```json
{
  "workflow": {
    "name": "new-feature",
    "execution_mode": "adaptive",
    "started_at": "ISO8601",
    "completed_at": "ISO8601",
    "duration_seconds": 1234
  },
  "feature": {
    "name": "user-profile",
    "flags": ["frontend", "backend"]
  },
  "phases": [
    {
      "id": "discovery",
      "status": "completed",
      "iterations": 1,
      "subagents_spawned": 3,
      "deliverables": 2
    }
  ],
  "totals": {
    "phases_completed": 5,
    "phases_skipped": 1,
    "subagents_spawned": 12,
    "deliverables_created": 8,
    "checkpoints_hit": 2
  },
  "final_plan": "/path/to/final-plan.md"
}
```

## Script Return Values

### Adaptive Script Return
```javascript
return [
  { type: 'code-scout', config: { output_path: '/tmp/scout.md' } },
  { type: 'pattern-analyzer', config: { depth: 'deep' } }
];
```

### Gap Check Script Return
```javascript
return {
  status: 'complete' | 'incomplete',
  gaps: ['gap1', 'gap2'],
  action: 'retry' | 'spawn_additional' | 'escalate' | 'abort',
  additionalAgents: [{ type: 'string', config: {} }],
  message: 'string'
};
```

### Checkpoint Condition Return
```javascript
return true;  // Show checkpoint
return false; // Skip checkpoint
```

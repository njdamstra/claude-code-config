# Checkpoint Flow

## Purpose
Human-in-loop decision points that pause workflow execution for user input.

---

## Checkpoint Types

### 1. Simple Approval
```yaml
checkpoint:
  approval_required: true
```

**Flow:**
```
Phase completes
  ↓
Display: "Continue with next phase?"
  ↓
Options: [Continue, Abort]
  ↓
User selects
  ↓
CONTINUE → proceed to next phase
ABORT → exit with code 2
```

### 2. Custom Checkpoint
```yaml
checkpoint:
  condition: "context.subagents_spawned > 0"  # Optional
  prompt: "Review outputs before proceeding?"
  show_files:
    - "{{output_dir}}/plan.md"
    - "{{output_dir}}/architecture.md"
  options:
    - label: "Continue"
      on_select:
        action: continue
    - label: "Redo This Phase"
      on_select:
        action: repeat_phase
        target: "current"
    - label: "Skip Next 2 Phases"
      with_feedback: true
      on_select:
        action: skip_phases
        phases: ["phase_3", "phase_4"]
    - label: "Abort Workflow"
      on_select:
        action: abort
```

**Flow:**
```
Phase completes
  ↓
Evaluate condition (if defined)
  ↓ true
Display prompt
  ↓
Log show_files paths
  ↓
Present options
  ↓
User selects
  ↓
Collect feedback (if with_feedback: true)
  ↓
Record in context.checkpoints[]
  ↓
Execute action handler
```

---

## Condition Evaluation

### Syntax
JavaScript expression that returns boolean:
```javascript
"context.subagents_spawned > 5"
"context.phases.iteration_counts[phase.id] > 1"
"context.feature.flags.includes('backend')"
"context.deliverables.length === 0"
```

### Evaluation Logic
```javascript
function should_show_checkpoint(checkpoint, context) {
  if (!checkpoint.condition) {
    return true;  // Always show if no condition
  }

  try {
    const result = eval_with_context(checkpoint.condition, context);
    return Boolean(result);
  } catch (error) {
    log_error(`Checkpoint condition failed: ${error}`);
    return false;  // Skip checkpoint on error
  }
}
```

---

## Action Handlers

### 1. Continue
```yaml
on_select:
  action: continue
```
**Effect:** Proceed to next phase normally.
**Context update:** Record decision only.

### 2. Repeat Phase
```yaml
on_select:
  action: repeat_phase
  target: "current" | "phase_id"
```
**Effect:** Jump back to specified phase, increment iteration count.
**Context update:**
```javascript
context.phases.iteration_counts[phase_id]++;
context.checkpoints.push({
  phase: current_phase,
  decision: 'repeat_phase',
  target: target_phase,
  timestamp: new Date().toISOString()
});
```

### 3. Skip Phases
```yaml
on_select:
  action: skip_phases
  phases: ["phase_3", "phase_4"]
```
**Effect:** Add phases to skip list, continue to next non-skipped phase.
**Context update:**
```javascript
context.skip_phases.push(...phases);
context.checkpoints.push({
  phase: current_phase,
  decision: 'skip_phases',
  skipped: phases,
  timestamp: new Date().toISOString()
});
```

### 4. Abort
```yaml
on_select:
  action: abort
```
**Effect:** Exit workflow with code 2 (user abort).
**Context update:**
```javascript
context.checkpoints.push({
  phase: current_phase,
  decision: 'abort',
  timestamp: new Date().toISOString()
});
// Exit immediately
```

---

## Feedback Collection

### Configuration
```yaml
options:
  - label: "Skip Documentation Phase"
    with_feedback: true
    on_select:
      action: skip_phases
      phases: ["documentation"]
```

### Prompt Logic
```
MVP: Log placeholder for user input
Real: Use AskUserQuestion tool with text field
```

### Context Storage
```javascript
context.checkpoints.push({
  phase: "current_phase",
  decision: "skip_phases",
  skipped: ["documentation"],
  feedback: "User comment here",
  timestamp: "2025-10-31T14:00:00Z"
});
```

---

## Execution Pseudocode

### Main Checkpoint Handler
```javascript
function handle_checkpoint(phase, context) {
  const checkpoint = phase.checkpoint;

  if (!checkpoint) {
    return 'CONTINUE';
  }

  // Simple approval
  if (checkpoint.approval_required === true) {
    return handle_simple_approval(phase);
  }

  // Custom checkpoint
  return handle_custom_checkpoint(checkpoint, phase, context);
}
```

### Simple Approval Handler
```javascript
function handle_simple_approval(phase) {
  log_info(`Checkpoint: Continue with workflow?`);

  // MVP: Always continue
  // Real: Prompt user with Continue/Abort
  const decision = prompt_user(['Continue', 'Abort']);

  if (decision === 'Abort') {
    log_info('User aborted workflow');
    return 'ABORT';
  }

  return 'CONTINUE';
}
```

### Custom Checkpoint Handler
```javascript
function handle_custom_checkpoint(checkpoint, phase, context) {
  // 1. Evaluate condition
  if (checkpoint.condition) {
    const should_show = eval_condition(checkpoint.condition, context);
    if (!should_show) {
      log_debug(`Checkpoint condition false, skipping`);
      return 'CONTINUE';
    }
  }

  // 2. Display prompt
  log_info(`Checkpoint: ${checkpoint.prompt}`);

  // 3. Show files
  if (checkpoint.show_files) {
    checkpoint.show_files.forEach(file => {
      const resolved = substitute_vars(file, context);
      log_info(`Review: ${resolved}`);
    });
  }

  // 4. Present options
  const labels = checkpoint.options.map(opt => opt.label);
  const selected = prompt_user(labels);  // MVP: mock, Real: AskUserQuestion

  // 5. Collect feedback
  let feedback = null;
  const option = checkpoint.options.find(opt => opt.label === selected);
  if (option.with_feedback) {
    feedback = prompt_text('Provide feedback:');  // MVP: mock
  }

  // 6. Record decision
  record_checkpoint(phase.id, option.on_select.action, {
    skipped: option.on_select.phases,
    target: option.on_select.target,
    feedback: feedback
  }, context);

  // 7. Execute action
  return execute_checkpoint_action(option.on_select, phase.id, context);
}
```

### Action Executor
```javascript
function execute_checkpoint_action(on_select, current_phase_id, context) {
  const action = on_select.action;

  switch (action) {
    case 'continue':
      return 'CONTINUE';

    case 'repeat_phase':
      const target = on_select.target === 'current' ? current_phase_id : on_select.target;
      context.phases.iteration_counts[target]++;
      return `REPEAT_PHASE:${target}`;

    case 'skip_phases':
      context.skip_phases.push(...on_select.phases);
      return 'CONTINUE';

    case 'abort':
      return 'ABORT';

    default:
      throw new Error(`Unknown checkpoint action: ${action}`);
  }
}
```

---

## Integration with Main Loop

### Workflow Runner Integration
```javascript
for (const phase of workflow.phases) {
  // Check skip list
  if (context.skip_phases.includes(phase.id)) {
    log_info(`Skipping phase: ${phase.id}`);
    continue;
  }

  // Execute phase
  execute_phase(workflow, phase, context);

  // Gap check
  const gap_result = execute_gap_check(phase, context);
  if (gap_result === 'RETRY_PHASE') {
    // Repeat current phase
    continue;
  }

  // Checkpoint
  const checkpoint_result = handle_checkpoint(phase, context);

  if (checkpoint_result === 'ABORT') {
    log_info('Workflow aborted by user');
    exit(2);
  }

  if (checkpoint_result.startsWith('REPEAT_PHASE:')) {
    const target_phase_id = checkpoint_result.split(':')[1];
    // Jump to target phase (implementation detail: adjust loop index)
    continue;
  }

  // CONTINUE → proceed normally
}
```

---

## Context Schema Updates

### Checkpoint Record Format
```javascript
{
  "phase": "discovery",
  "decision": "skip_phases",
  "skipped": ["documentation", "testing"],
  "feedback": "Not needed for MVP",
  "timestamp": "2025-10-31T14:00:00Z"
}
```

### Skip Phases Tracking
```javascript
context.skip_phases = ["phase_3", "phase_4"];
```

### Iteration Count Tracking
```javascript
context.phases.iteration_counts = {
  "discovery": 1,
  "planning": 3,  // Repeated twice
  "implementation": 1
};
```

---

## Common Patterns

### Pattern: Review Before Major Changes
```yaml
- id: implementation
  checkpoint:
    prompt: "Review plan before implementing?"
    show_files:
      - "{{output_dir}}/plan.md"
    options:
      - label: "Looks good, proceed"
        on_select: { action: continue }
      - label: "Revise plan"
        on_select: { action: repeat_phase, target: "planning" }
```

### Pattern: Conditional Quality Gate
```yaml
- id: testing
  checkpoint:
    condition: "context.feature.flags.includes('production')"
    prompt: "All tests passing?"
    options:
      - label: "Yes, continue"
        on_select: { action: continue }
      - label: "No, fix tests"
        on_select: { action: repeat_phase, target: "current" }
```

### Pattern: Skip Optional Phases
```yaml
- id: optimization
  checkpoint:
    prompt: "Optimize performance now or later?"
    options:
      - label: "Optimize now"
        on_select: { action: continue }
      - label: "Skip for now"
        with_feedback: true
        on_select: { action: skip_phases, phases: ["performance_tuning"] }
```

### Pattern: Early Exit on Issues
```yaml
- id: validation
  checkpoint:
    prompt: "Critical issues found. How to proceed?"
    show_files:
      - "{{output_dir}}/validation-report.md"
    options:
      - label: "Fix and retry"
        on_select: { action: repeat_phase, target: "current" }
      - label: "Abort workflow"
        with_feedback: true
        on_select: { action: abort }
```

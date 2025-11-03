# Gap Check Flow

## Purpose
Automated quality validation that detects incomplete work and triggers corrective actions.

---

## Gap Check Types

### 1. Script-Based
```yaml
gap_check:
  enabled: true
  max_iterations: 3
  script: |
    const deliverables = context.deliverables.filter(d => d.phase === phase.id);
    const gaps = identifyGaps(deliverables);

    if (gaps.length === 0) {
      return { status: 'complete' };
    }

    return {
      status: 'incomplete',
      gaps: gaps,
      action: 'spawn_additional',
      additionalAgents: [
        { type: 'code-scout', config: { focus: 'missing-patterns' } }
      ],
      message: 'Found gaps in pattern coverage'
    };
```

### 2. Criteria-Based
```yaml
gap_check:
  enabled: true
  criteria:
    - name: "All required files exist"
      check: "files_exist(['plan.md', 'architecture.md'])"
    - name: "No TODO markers"
      check: "!contains_todos(context.deliverables)"
    - name: "Minimum 3 deliverables"
      check: "context.deliverables.length >= 3"
  on_failure:
    action: retry
    message: "Quality criteria not met"
```

---

## Execution Flow

### Script-Based Flow
```
Phase completes
  ↓
gap_check.enabled? → No → Continue
  ↓ Yes
Execute gap_check.script with context
  ↓
Parse return value
  ↓
status === 'complete'? → Yes → Continue
  ↓ No (status === 'incomplete')
Check iteration count
  ↓
iterations < max_iterations?
  ↓ Yes
Execute action handler:
  - retry → RETRY_PHASE
  - spawn_additional → spawn agents, CONTINUE
  - escalate → prompt user
  - abort → EXIT 1
  ↓ No (max iterations reached)
Escalate to user
```

### Criteria-Based Flow
```
Phase completes
  ↓
gap_check.enabled? → No → Continue
  ↓ Yes
For each criterion in criteria[]:
  ↓
  Evaluate check expression
  ↓
  Pass? → Next criterion
  ↓ Fail → Record failure
  ↓
All criteria pass? → Yes → Continue
  ↓ No
Execute on_failure.action:
  - retry → RETRY_PHASE
  - escalate → prompt user
  - abort → EXIT 1
```

---

## Action Handlers

### 1. Retry
**Effect:** Repeat current phase, increment iteration count.
**When:** Transient issues, expected to succeed on retry.

```javascript
if (context.phases.iteration_counts[phase.id] >= gap_check.max_iterations) {
  // Max iterations reached, escalate
  return escalate_to_user(gaps, context);
}

context.phases.iteration_counts[phase.id]++;
log_info(`Retrying phase ${phase.id} (attempt ${context.phases.iteration_counts[phase.id]})`);
return 'RETRY_PHASE';
```

### 2. Spawn Additional
**Effect:** Spawn new subagents to fill gaps, continue to next phase.
**When:** Additional work needed but phase shouldn't repeat entirely.

```javascript
const agents = result.additionalAgents;
log_info(`Spawning ${agents.length} additional agents to address gaps`);

run_subagent_batch(agents, 'parallel', context);

record_gap_check(phase.id, 'incomplete', result.gaps, 'spawn_additional', agents, context);
return 'CONTINUE';
```

### 3. Escalate
**Effect:** Prompt user for decision (continue/retry/abort).
**When:** Uncertain how to proceed automatically.

```javascript
log_warning(`Gap check failed: ${result.message}`);
log_info(`Gaps found: ${result.gaps.join(', ')}`);

// MVP: Log and continue
// Real: AskUserQuestion with options
const decision = prompt_user([
  'Retry phase',
  'Continue anyway',
  'Abort workflow'
]);

if (decision === 'Retry phase') {
  context.phases.iteration_counts[phase.id]++;
  return 'RETRY_PHASE';
} else if (decision === 'Continue anyway') {
  return 'CONTINUE';
} else {
  return 'ABORT';
}
```

### 4. Abort
**Effect:** Exit workflow with error code 1.
**When:** Critical gaps that must be fixed before proceeding.

```javascript
log_error(`Gap check failed critically: ${result.message}`);
log_error(`Gaps: ${result.gaps.join(', ')}`);
exit(1);
```

---

## Script Return Schema

### Complete Status
```javascript
return {
  status: 'complete'
};
```

### Incomplete Status
```javascript
return {
  status: 'incomplete',
  gaps: ['Missing test coverage', 'No error handling'],
  action: 'retry' | 'spawn_additional' | 'escalate' | 'abort',
  additionalAgents: [  // Required if action === 'spawn_additional'
    { type: 'test-planner', config: { output_path: 'tests.md' } }
  ],
  message: 'Human-readable explanation'
};
```

---

## Helper Functions (Stubs for MVP)

### identifyGaps(deliverables)
```javascript
function identifyGaps(deliverables) {
  // MVP: Mock implementation
  // Real: Analyze deliverable content for completeness
  const gaps = [];

  deliverables.forEach(d => {
    const content = readFile(d.path);
    if (content.includes('TODO')) {
      gaps.push(`TODO found in ${d.path}`);
    }
    if (content.length < 100) {
      gaps.push(`${d.path} too short`);
    }
  });

  return gaps;
}
```

### files_exist(paths)
```javascript
function files_exist(paths) {
  return paths.every(path => {
    const resolved = substitute_vars(path, context);
    return fs.existsSync(resolved);
  });
}
```

### contains_todos(deliverables)
```javascript
function contains_todos(deliverables) {
  return deliverables.some(d => {
    const content = readFile(d.path);
    return /TODO|FIXME|XXX/.test(content);
  });
}
```

---

## Iteration Limit Logic

### Tracking
```javascript
context.phases.iteration_counts = {
  "discovery": 1,
  "planning": 3,  // Hit limit at 3
  "implementation": 1
};
```

### Enforcement
```javascript
function execute_gap_check(phase, context) {
  const gap_check = phase.gap_check;

  if (!gap_check || !gap_check.enabled) {
    return 'CONTINUE';
  }

  const iterations = context.phases.iteration_counts[phase.id] || 0;

  if (iterations >= gap_check.max_iterations) {
    log_warning(`Phase ${phase.id} reached max iterations (${gap_check.max_iterations})`);
    return escalate_to_user('Max iterations reached', context);
  }

  // Execute gap check logic...
}
```

---

## Context Updates

### Gap Check Record
```javascript
context.gap_checks.push({
  phase: "discovery",
  iteration: 2,
  status: "incomplete",
  gaps: ["Missing coverage", "No tests"],
  action_taken: "spawn_additional",
  agents_spawned: ["test-planner"],
  timestamp: "2025-10-31T14:00:00Z"
});
```

### Iteration Count
```javascript
context.phases.iteration_counts["discovery"]++;
```

---

## Execution Pseudocode

### Main Gap Check Handler
```javascript
function execute_gap_check(phase, context) {
  const gap_check = phase.gap_check;

  if (!gap_check || !gap_check.enabled) {
    return 'CONTINUE';
  }

  // Script-based
  if (gap_check.script) {
    return execute_gap_check_script(gap_check.script, gap_check, phase, context);
  }

  // Criteria-based
  if (gap_check.criteria) {
    return execute_gap_check_criteria(gap_check.criteria, gap_check, phase, context);
  }

  log_warning('Gap check enabled but no script or criteria defined');
  return 'CONTINUE';
}
```

### Script-Based Handler
```javascript
function execute_gap_check_script(script, gap_check, phase, context) {
  const result = execute_script(script, context);

  if (result.status === 'complete') {
    log_info(`Gap check passed for phase ${phase.id}`);
    record_gap_check(phase.id, 'complete', [], null, [], context);
    return 'CONTINUE';
  }

  // Incomplete
  log_warning(`Gap check found issues: ${result.message}`);
  log_info(`Gaps: ${result.gaps.join(', ')}`);

  return handle_gap_check_failure(result, gap_check, phase, context);
}
```

### Criteria-Based Handler
```javascript
function execute_gap_check_criteria(criteria, gap_check, phase, context) {
  const failures = [];

  criteria.forEach(criterion => {
    try {
      const pass = eval_with_context(criterion.check, context);
      if (!pass) {
        failures.push(criterion.name);
      }
    } catch (error) {
      log_error(`Criterion "${criterion.name}" failed to evaluate: ${error}`);
      failures.push(criterion.name);
    }
  });

  if (failures.length === 0) {
    log_info(`All ${criteria.length} criteria passed for phase ${phase.id}`);
    return 'CONTINUE';
  }

  log_warning(`${failures.length} criteria failed: ${failures.join(', ')}`);

  const result = {
    status: 'incomplete',
    gaps: failures,
    action: gap_check.on_failure.action,
    message: gap_check.on_failure.message
  };

  return handle_gap_check_failure(result, gap_check, phase, context);
}
```

### Failure Handler
```javascript
function handle_gap_check_failure(result, gap_check, phase, context) {
  const action = result.action;
  const iterations = context.phases.iteration_counts[phase.id] || 0;

  switch (action) {
    case 'retry':
      if (iterations >= gap_check.max_iterations) {
        return escalate_to_user(result.gaps, context);
      }
      context.phases.iteration_counts[phase.id]++;
      record_gap_check(phase.id, 'incomplete', result.gaps, 'retry', [], context);
      return 'RETRY_PHASE';

    case 'spawn_additional':
      const agents = result.additionalAgents || [];
      run_subagent_batch(agents, 'parallel', context);
      record_gap_check(phase.id, 'incomplete', result.gaps, 'spawn_additional', agents, context);
      return 'CONTINUE';

    case 'escalate':
      return escalate_to_user(result.gaps, context);

    case 'abort':
      log_error(`Gap check abort: ${result.message}`);
      exit(1);

    default:
      throw new Error(`Unknown gap check action: ${action}`);
  }
}
```

---

## Common Patterns

### Pattern: Automatic Retry with Limit
```yaml
gap_check:
  enabled: true
  max_iterations: 3
  script: |
    const coverage = analyzeCoverage(context.deliverables);
    if (coverage < 80) {
      return {
        status: 'incomplete',
        gaps: [`Coverage only ${coverage}%`],
        action: 'retry'
      };
    }
    return { status: 'complete' };
```

### Pattern: Spawn Missing Specialists
```yaml
gap_check:
  enabled: true
  script: |
    const scan = readFile(context.output_dir + '/scan.md');
    const agents = [];

    if (!scan.includes('Vue components')) {
      agents.push({ type: 'component-analyzer', config: {} });
    }
    if (!scan.includes('API endpoints')) {
      agents.push({ type: 'backend-analyzer', config: {} });
    }

    if (agents.length > 0) {
      return {
        status: 'incomplete',
        gaps: ['Missing specialized analysis'],
        action: 'spawn_additional',
        additionalAgents: agents
      };
    }

    return { status: 'complete' };
```

### Pattern: Critical Quality Gate
```yaml
gap_check:
  enabled: true
  criteria:
    - name: "No syntax errors"
      check: "!has_syntax_errors(context.deliverables)"
    - name: "All tests pass"
      check: "all_tests_pass()"
  on_failure:
    action: abort
    message: "Critical quality criteria failed"
```

### Pattern: Escalate on Ambiguity
```yaml
gap_check:
  enabled: true
  script: |
    const ambiguous = findAmbiguousRequirements(context.deliverables);
    if (ambiguous.length > 0) {
      return {
        status: 'incomplete',
        gaps: ambiguous,
        action: 'escalate',
        message: 'User input needed to clarify requirements'
      };
    }
    return { status: 'complete' };
```

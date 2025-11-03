# Execution Modes

## Mode Definitions

### Strict Mode
**Purpose:** Execute workflow exactly as defined. No autonomy.
**Use when:** Repeatable processes, compliance requirements, deterministic outputs.

### Loose Mode
**Purpose:** Main agent has full control, suggested subagents informational only.
**Use when:** Exploratory work, novel problems, maximum flexibility needed.

### Adaptive Mode
**Purpose:** Core subagents always spawn, additional ones determined at runtime.
**Use when:** Context-dependent workflows, conditional delegation, dynamic scoping.

---

## Strict Mode Logic

### Parallel Behavior
```
Pseudocode:
  subagents = phase.subagents
  if len(subagents) <= 5:
    spawn_all_simultaneously(subagents)
  else:
    batch_size = 5
    for batch in chunks(subagents, batch_size):
      spawn_all_simultaneously(batch)
      wait_for_completion()

  collect_deliverables()
```

**Example:**
```yaml
behavior: parallel
subagents:
  - type: code-scout
    config: { output_path: scout.md }
  - type: pattern-analyzer
    config: { output_path: patterns.md }
  - type: dependency-mapper
    config: { output_path: deps.md }
```
→ All 3 spawn simultaneously, execution continues when all complete.

### Sequential Behavior
```
Pseudocode:
  subagents = phase.subagents
  for subagent in subagents:
    spawn_subagent(subagent)
    wait_for_completion()
    collect_deliverable()
```

**Example:**
```yaml
behavior: sequential
subagents:
  - type: codebase-scanner
    config: { output_path: scan.md }
  - type: code-scout
    config: { output_path: scout.md, context: { scan_results: scan.md } }
```
→ codebase-scanner completes first, then code-scout spawns with context.

### Main-Only Behavior
```
Pseudocode:
  main_script = phase.main_agent.script
  execute_script(main_script, context)
  # No subagents spawned
```

**Example:**
```yaml
behavior: main-only
main_agent:
  script: |
    const plan = await thinkHard("Synthesize findings into implementation plan");
    writeFile(context.output_path + '/plan.md', plan);
```
→ Main agent executes script directly, no delegation.

---

## Loose Mode Logic

```
Pseudocode:
  log_info("Suggested subagents: " + phase.suggested_subagents)
  main_script = phase.main_agent.script
  execute_script(main_script, context)
  # Main agent decides whether to spawn subagents
```

**Requirements:**
- `behavior` must be `main-only`
- `main_agent.script` required
- `suggested_subagents` optional (informational)

**Example:**
```yaml
behavior: main-only
main_agent:
  script: |
    // Main agent has full autonomy
    const needsDeepDive = context.complexity === 'high';
    if (needsDeepDive) {
      // Could spawn subagents here via Task tool
      return spawnSubagent('code-deepdive', { focus: 'performance' });
    }
    return { status: 'complete' };
suggested_subagents:
  - type: code-deepdive
  - type: usage-pattern-extractor
```
→ Main agent reads suggestions, makes own decisions.

---

## Adaptive Mode Logic

```
Pseudocode:
  # Step 1: Spawn always subagents
  always_subagents = phase.subagents.always
  if phase.behavior == 'parallel':
    spawn_all_simultaneously(always_subagents)
  else:
    spawn_sequentially(always_subagents)

  # Step 2: Execute adaptive script
  adaptive_script = phase.subagents.adaptive.script
  additional_subagents = execute_script(adaptive_script, context)

  # Step 3: Spawn additional subagents
  if phase.behavior == 'parallel':
    spawn_all_simultaneously(additional_subagents)
  else:
    spawn_sequentially(additional_subagents)

  collect_all_deliverables()
```

**Requirements:**
- `subagents.always[]` - spawned unconditionally
- `subagents.adaptive.script` - returns array of subagent configs
- `behavior` applies to both always and adaptive subagents

**Example:**
```yaml
behavior: parallel
subagents:
  always:
    - type: codebase-scanner
      config: { output_path: scan.md }
  adaptive:
    script: |
      const scan = readFile('scan.md');
      const additional = [];

      if (scan.includes('Vue components')) {
        additional.push({
          type: 'component-analyzer',
          config: { output_path: 'components.md' }
        });
      }

      if (scan.includes('Appwrite')) {
        additional.push({
          type: 'backend-analyzer',
          config: { output_path: 'backend.md' }
        });
      }

      return additional;
```
→ codebase-scanner always runs, then script determines if component-analyzer or backend-analyzer spawn.

---

## Behavior Mappings

| Mode | Behavior | Main Script | Subagents | Logic |
|------|----------|-------------|-----------|-------|
| strict | parallel | optional | required | Spawn all simultaneously (batch if >5) |
| strict | sequential | optional | required | Spawn one-by-one |
| strict | main-only | required | none | Execute main script only |
| loose | main-only | required | suggested | Main agent full control |
| adaptive | parallel | optional | always + adaptive | Always spawned, then conditional |
| adaptive | sequential | optional | always + adaptive | Always spawned, then conditional |

---

## Mode Selection Guidelines

**Choose Strict when:**
- Workflow is well-understood and repeatable
- Deterministic outputs required
- Compliance/audit trail needed
- Team wants consistency

**Choose Loose when:**
- Problem is novel or exploratory
- Main agent needs maximum flexibility
- Context highly variable
- Creative problem-solving needed

**Choose Adaptive when:**
- Core steps known, edge cases vary
- Conditional delegation based on findings
- Optimize token usage (spawn only when needed)
- Hybrid of strict and loose

---

## Execution Pseudocode by Mode

### Strict Mode Executor
```javascript
function execute_phase_strict(phase, context) {
  if (phase.behavior === 'main-only') {
    return execute_main_agent_only(phase, context);
  }

  const subagents = phase.subagents;
  const behavior = phase.behavior;

  run_subagent_batch(subagents, behavior, context);

  if (phase.main_agent && phase.main_agent.script) {
    execute_script(phase.main_agent.script, context);
  }
}
```

### Loose Mode Executor
```javascript
function execute_phase_loose(phase, context) {
  if (!phase.main_agent || !phase.main_agent.script) {
    throw new Error('Loose mode requires main_agent.script');
  }

  if (phase.suggested_subagents) {
    log_info(`Suggested subagents: ${phase.suggested_subagents.map(s => s.type).join(', ')}`);
  }

  return execute_script(phase.main_agent.script, context);
}
```

### Adaptive Mode Executor
```javascript
function execute_phase_adaptive(phase, context) {
  const always = phase.subagents.always || [];
  const behavior = phase.behavior;

  // Spawn always subagents
  if (always.length > 0) {
    run_subagent_batch(always, behavior, context);
  }

  // Execute adaptive script
  if (phase.subagents.adaptive && phase.subagents.adaptive.script) {
    const additional = execute_script(phase.subagents.adaptive.script, context);

    // Spawn additional subagents
    if (additional && additional.length > 0) {
      run_subagent_batch(additional, behavior, context);
    }
  }

  // Execute main agent if defined
  if (phase.main_agent && phase.main_agent.script) {
    execute_script(phase.main_agent.script, context);
  }
}
```

---

## Common Patterns

### Pattern: Conditional Branching (Adaptive)
```yaml
subagents:
  always:
    - type: codebase-scanner
  adaptive:
    script: |
      const flags = context.feature.flags;
      const agents = [];

      if (flags.includes('frontend')) {
        agents.push({ type: 'frontend-scanner', config: {} });
      }
      if (flags.includes('backend')) {
        agents.push({ type: 'backend-scanner', config: {} });
      }

      return agents;
```

### Pattern: Sequential Discovery (Strict Sequential)
```yaml
behavior: sequential
subagents:
  - type: codebase-scanner
    config: { output_path: scan.md }
  - type: code-scout
    config: { output_path: scout.md, context: { previous: scan.md } }
  - type: duplication-finder
    config: { output_path: dups.md, context: { scout: scout.md } }
```

### Pattern: Parallel Research (Strict Parallel)
```yaml
behavior: parallel
subagents:
  - type: web-researcher
    config: { output_path: web.md, query: "Vue 3 patterns" }
  - type: doc-searcher
    config: { output_path: docs.md, topic: "Vue" }
  - type: code-scout
    config: { output_path: code.md, pattern: "*.vue" }
```

### Pattern: Full Autonomy (Loose)
```yaml
behavior: main-only
main_agent:
  script: |
    // Main agent decides everything
    const complexity = analyzeComplexity(context);

    if (complexity > 8) {
      // Could spawn decomposer
      await spawnProblemDecomposer();
    }

    // Implement directly
    return implementFeature(context);
```

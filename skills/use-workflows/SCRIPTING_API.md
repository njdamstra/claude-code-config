# Scripting API

## Overview
JavaScript API available to scripts in `main_agent.script`, `adaptive.script`, `gap_check.script`, and `checkpoint.condition`.

---

## Context Injection

### Automatic Variables
All scripts execute with `context` object in scope:

```javascript
// Available in all scripts
const context = {
  workflow: { name: "new-feature", execution_mode: "adaptive", started_at: "..." },
  feature: { name: "user-profile", flags: ["frontend", "backend"] },
  phases: {
    current: "discovery",
    completed: ["phase_1"],
    iteration_counts: { "discovery": 1 }
  },
  subagents_spawned: 3,
  deliverables: [...],
  checkpoints: [...],
  skip_phases: [],
  gap_checks: [...]
};

// Also available
const phase = { id: "discovery", name: "...", ... };
const output_dir = "/abs/path/to/.temp/feature";
```

---

## Helper Functions

### thinkHard(prompt)
**Purpose:** Delegate reasoning to Claude.
**Signature:**
```typescript
function thinkHard(prompt: string): Promise<string>
```

**MVP Implementation:**
```javascript
function thinkHard(prompt) {
  // Mock: Return placeholder
  console.log(`[MVP] thinkHard called: ${prompt}`);
  return Promise.resolve(`Mock response for: ${prompt}`);
}
```

**Real Implementation:**
```javascript
function thinkHard(prompt) {
  // Invoke Claude with prompt
  // Return response text
}
```

**Usage:**
```javascript
const plan = await thinkHard("Synthesize findings into implementation plan");
writeFile(output_dir + '/plan.md', plan);
```

---

### readFile(path)
**Purpose:** Read file contents.
**Signature:**
```typescript
function readFile(path: string): string
```

**Implementation:**
```javascript
const fs = require('fs');

function readFile(path) {
  const resolved = path.startsWith('/') ? path : `${output_dir}/${path}`;
  return fs.readFileSync(resolved, 'utf-8');
}
```

**Usage:**
```javascript
const scan = readFile('scan.md');
if (scan.includes('Vue')) {
  // ...
}
```

---

### readFiles(paths)
**Purpose:** Read multiple files.
**Signature:**
```typescript
function readFiles(paths: string[]): { [path: string]: string }
```

**Implementation:**
```javascript
function readFiles(paths) {
  const result = {};
  paths.forEach(path => {
    result[path] = readFile(path);
  });
  return result;
}
```

**Usage:**
```javascript
const files = readFiles(['scan.md', 'scout.md']);
const combined = files['scan.md'] + '\n\n' + files['scout.md'];
```

---

### writeFile(path, content)
**Purpose:** Write file contents.
**Signature:**
```typescript
function writeFile(path: string, content: string): void
```

**Implementation:**
```javascript
const fs = require('fs');

function writeFile(path, content) {
  const resolved = path.startsWith('/') ? path : `${output_dir}/${path}`;
  fs.writeFileSync(resolved, content, 'utf-8');

  // Track in context
  context.deliverables.push({
    phase: context.phases.current,
    path: resolved,
    size_bytes: content.length,
    timestamp: new Date().toISOString()
  });
}
```

**Usage:**
```javascript
const plan = await thinkHard("Create implementation plan");
writeFile('plan.md', plan);
```

---

### analyzeFiles(directory)
**Purpose:** Analyze coverage of files in directory.
**Signature:**
```typescript
function analyzeFiles(directory: string): { coverage: number, files: string[] }
```

**MVP Implementation:**
```javascript
function analyzeFiles(directory) {
  // Mock: Return placeholder
  return {
    coverage: 85,
    files: ['file1.md', 'file2.md']
  };
}
```

**Usage:**
```javascript
const analysis = analyzeFiles(output_dir);
if (analysis.coverage < 80) {
  return { status: 'incomplete', gaps: ['Low coverage'] };
}
```

---

### identifyGaps(deliverables)
**Purpose:** Find missing or incomplete deliverables.
**Signature:**
```typescript
function identifyGaps(deliverables: Deliverable[]): string[]
```

**MVP Implementation:**
```javascript
function identifyGaps(deliverables) {
  // Mock: Check for TODOs
  const gaps = [];
  deliverables.forEach(d => {
    const content = readFile(d.path);
    if (content.includes('TODO')) {
      gaps.push(`TODO in ${d.path}`);
    }
  });
  return gaps;
}
```

**Usage:**
```javascript
const gaps = identifyGaps(context.deliverables);
if (gaps.length > 0) {
  return {
    status: 'incomplete',
    gaps: gaps,
    action: 'retry'
  };
}
```

---

### files_exist(paths)
**Purpose:** Check if files exist.
**Signature:**
```typescript
function files_exist(paths: string[]): boolean
```

**Implementation:**
```javascript
const fs = require('fs');

function files_exist(paths) {
  return paths.every(path => {
    const resolved = path.startsWith('/') ? path : `${output_dir}/${path}`;
    return fs.existsSync(resolved);
  });
}
```

**Usage:**
```javascript
if (!files_exist(['plan.md', 'architecture.md'])) {
  return { status: 'incomplete', gaps: ['Missing required files'] };
}
```

---

### contains_todos(deliverables)
**Purpose:** Check if deliverables contain TODO markers.
**Signature:**
```typescript
function contains_todos(deliverables: Deliverable[]): boolean
```

**Implementation:**
```javascript
function contains_todos(deliverables) {
  return deliverables.some(d => {
    const content = readFile(d.path);
    return /TODO|FIXME|XXX/.test(content);
  });
}
```

**Usage:**
```javascript
if (contains_todos(context.deliverables)) {
  return {
    status: 'incomplete',
    gaps: ['Unresolved TODOs'],
    action: 'escalate'
  };
}
```

---

## Script Types & Return Values

### 1. Main Agent Script
**Context:** `main_agent.script` in loose mode or main-only behavior.
**Return:** None (optional).

```javascript
// Example: Synthesize findings
const findings = readFiles(['scan.md', 'scout.md']);
const plan = await thinkHard(`Create plan from: ${findings}`);
writeFile('plan.md', plan);
```

---

### 2. Adaptive Script
**Context:** `subagents.adaptive.script` in adaptive mode.
**Return:** Array of subagent configs.

```javascript
// Example: Conditional spawning
const scan = readFile('scan.md');
const agents = [];

if (scan.includes('Vue')) {
  agents.push({
    type: 'component-analyzer',
    config: { output_path: 'components.md' }
  });
}

if (scan.includes('Appwrite')) {
  agents.push({
    type: 'backend-analyzer',
    config: { output_path: 'backend.md' }
  });
}

return agents;
```

**Return Schema:**
```typescript
type AdaptiveReturn = Array<{
  type: string;
  config: {
    output_path?: string;
    max_tokens?: number;
    model?: 'haiku' | 'sonnet' | 'opus';
    context?: object;
  }
}>;
```

---

### 3. Gap Check Script
**Context:** `gap_check.script` after phase completes.
**Return:** Gap check result object.

```javascript
// Example: Coverage check
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
    { type: 'code-scout', config: { focus: 'missing' } }
  ],
  message: 'Gaps detected'
};
```

**Return Schema:**
```typescript
type GapCheckReturn =
  | { status: 'complete' }
  | {
      status: 'incomplete';
      gaps: string[];
      action: 'retry' | 'spawn_additional' | 'escalate' | 'abort';
      additionalAgents?: Array<{ type: string; config: object }>;
      message?: string;
    };
```

---

### 4. Checkpoint Condition
**Context:** `checkpoint.condition` before showing checkpoint.
**Return:** Boolean (true = show, false = skip).

```javascript
// Example: Show only if many subagents spawned
return context.subagents_spawned > 5;
```

```javascript
// Example: Show only on repeated attempts
return context.phases.iteration_counts[phase.id] > 1;
```

**Return Schema:**
```typescript
type ConditionReturn = boolean;
```

---

## Error Handling

### Script Errors
```javascript
try {
  const result = execute_script(script, context);
  return result;
} catch (error) {
  log_error(`Script execution failed: ${error.message}`);
  log_debug(error.stack);

  // For gap checks: treat as pass (don't block)
  // For adaptive: return empty array
  // For main agent: continue

  return default_value;
}
```

### Timeout
```javascript
// 30 second timeout for all scripts
const result = execute_with_timeout(script, context, 30000);
```

---

## Execution Context

### Node.js Environment
```javascript
// Available modules (require'd automatically)
const fs = require('fs');
const path = require('path');

// Available globals
const context = {...};
const phase = {...};
const output_dir = "/path";

// Helper functions injected
const thinkHard = (prompt) => {...};
const readFile = (path) => {...};
const writeFile = (path, content) => {...};
// etc.
```

### Invocation
```bash
# Bash wrapper
script_result=$(node -e "
  const context = ${context_json};
  const phase = ${phase_json};
  const output_dir = '${output_dir}';

  // Inject helpers
  const thinkHard = ${thinkHard_stub};
  const readFile = ${readFile_impl};
  // etc.

  // Execute user script
  const result = (function() {
    ${user_script}
  })();

  console.log(JSON.stringify(result));
")
```

---

## Common Patterns

### Pattern: Conditional Subagent Spawning
```javascript
const flags = context.feature.flags;
const agents = [];

if (flags.includes('frontend')) {
  agents.push({ type: 'frontend-scanner', config: {} });
}
if (flags.includes('backend')) {
  agents.push({ type: 'backend-analyzer', config: {} });
}

return agents;
```

### Pattern: Multi-File Synthesis
```javascript
const files = readFiles(['scan.md', 'scout.md', 'deps.md']);
const combined = Object.values(files).join('\n\n---\n\n');

const plan = await thinkHard(`Synthesize into plan:\n${combined}`);
writeFile('plan.md', plan);
```

### Pattern: Iterative Refinement
```javascript
const iteration = context.phases.iteration_counts[phase.id] || 0;

if (iteration === 0) {
  // First attempt: broad analysis
  return [
    { type: 'codebase-scanner', config: { depth: 'shallow' } }
  ];
} else {
  // Retry: deep dive
  return [
    { type: 'codebase-scanner', config: { depth: 'deep' } },
    { type: 'code-deepdive', config: { focus: 'gaps' } }
  ];
}
```

### Pattern: Quality Gate
```javascript
const required_files = ['plan.md', 'architecture.md', 'tests.md'];

if (!files_exist(required_files)) {
  return {
    status: 'incomplete',
    gaps: required_files.filter(f => !files_exist([f])),
    action: 'retry'
  };
}

if (contains_todos(context.deliverables)) {
  return {
    status: 'incomplete',
    gaps: ['Unresolved TODOs'],
    action: 'escalate',
    message: 'Manual review needed'
  };
}

return { status: 'complete' };
```

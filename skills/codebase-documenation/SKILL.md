---
name: codebase-documentation
description: Research and document codebase topics using workflow-specific multi-agent orchestration. Supports comprehensive docs, how-to guides, quick references, and architecture docs. Use when user requests "document [topic]", "create docs for [feature]", "/docs-v2", or specifies workflow type. Optimized for Vue3, Astro, TypeScript, nanostore, Appwrite, Tailwind CSS v4 projects.
model: sonnet
---

# Codebase Documentation Skill

## Overview

Systematically documents codebase topics through coordinated multi-agent research. Creates comprehensive documentation capturing architecture, patterns, dependencies, and implementation details with verification checkpoints at each phase.

**Stack Support:** Vue3, Astro, TypeScript, nanostore, Appwrite (databases, serverless functions), Cloudflare, Zod, headless-ui/vue, floating-ui/vue, shadcn-ui/vue, Tailwind CSS v4

**Output Location:** `[project]/.claude/brains/[topic-name]/`

## When to Use This Skill

Invoke this skill when you need to:
- Document a component, feature, or system comprehensively
- Create architecture documentation for a codebase area
- Research implementation patterns across multiple files
- Generate verified, detailed technical documentation
- Map dependencies and data flows

## Usage

This skill is typically invoked via the `/docs` slash command:

```bash
/docs new <topic-name>
Description: <detailed explanation>
Flags: --frontend | --backend | --both (default: --frontend)
```

You can also invoke it naturally:
- "Document the animation system"
- "Create comprehensive docs for the API integration layer"
- "Research and document the onboarding workflow"

## Quality Commitment

**Prioritizes accuracy and thoroughness over speed.** Token usage and time vary by workflow type (see workflow configurations below).

---

## Workflow Types

This skill supports 4 documentation workflows optimized for different use cases:

### 1. **Comprehensive** (default)
Full multi-agent research with verification. Best for complete feature documentation.
- **Phases:** plan → discovery → analysis → synthesis → verification → finalize
- **Subagents:** 15-20 across all phases
- **Token usage:** 50K-350K
- **Time:** 20-60 minutes

### 2. **How-To**
Task-focused tutorials with step-by-step instructions. Best for implementation guides.
- **Phases:** plan → discovery → synthesis → finalize
- **Subagents:** 2-3 focused on usage patterns
- **Token usage:** 15-50K
- **Time:** 5-15 minutes

### 3. **Quickref**
Concise cheat sheets with common patterns. Best for reference docs.
- **Phases:** discovery → synthesis → finalize
- **Subagents:** 2 focused on patterns
- **Token usage:** 10-35K
- **Time:** 5-10 minutes

### 4. **Architecture**
System design and component relationships. Best for architectural docs.
- **Phases:** plan → discovery → analysis → synthesis → finalize
- **Subagents:** 10-15 focused on architecture
- **Token usage:** 30-250K
- **Time:** 15-45 minutes

---

## Workflow Detection & Initialization

### Step 1: Detect Workflow Type

Parse user input for workflow indicators:

**Command-based detection:**
- `/docs new <topic>` → comprehensive (default)
- `/docs new <topic> --workflow how-to` → how-to
- `/docs new <topic> --workflow quickref` → quickref
- `/docs new <topic> --workflow architecture` → architecture

**Natural language detection:**
- "create a how-to guide" → how-to
- "quick reference for" → quickref
- "document the architecture" → architecture
- "comprehensive documentation" → comprehensive

**If unclear:** Default to **comprehensive**

---

### Step 2: Load Workflow Configuration

```bash
# Read workflow registry
view ~/.claude/skills/docs-v2/workflows/registry.json

# Extract workflow definition
workflow_config = registry.workflows[detected_workflow]

# Note the following from config:
# - phases: List of phases to execute
# - subagents: Which agents to spawn per phase
# - template: Which template file to use
# - quality_target: Success criteria
# - estimated_tokens: Budget guidance
```

---

### Step 3: Load Phase Configuration

```bash
# Read phase registry
view ~/.claude/skills/docs-v2/phases/phase-registry.json

# For each phase in workflow_config.phases:
#   - Check if required/optional/skipped
#   - Note subagent count
#   - Note gap check requirements
#   - Note outputs location
```

---

### Step 4: Load Subagent Selection Matrix

```bash
# Read selection matrix
view ~/.claude/skills/docs-v2/subagents/selection-matrix.json

# Extract subagent selection for this workflow
# Note:
# - "always" subagents (spawn unconditionally)
# - "conditional" subagents (spawn based on flags like --frontend/--backend)
```

---

### Step 5: Announce Workflow Plan

After loading all configurations, announce to user:

```markdown
## Documentation Plan: [topic-name]

**Workflow:** [workflow-name]
**Scope:** [--frontend/--backend/--both or default]
**Estimated time:** [X-Y minutes]
**Estimated tokens:** [N-M]K

**Phases to execute:**
1. [Phase 1 name] - [brief description]
2. [Phase 2 name] - [brief description]
...

**Subagents:** [X] total across all phases

Proceeding with [workflow-name] workflow...
```

---

## Multi-Agent Orchestration Architecture

### Core Principles

1. **Lead Agent** (main conversation) coordinates all activities
2. **Extended Thinking** ("think hard") for strategic planning
3. **Parallel Subagents** (3-5 simultaneous) for independent research
4. **Interleaved Thinking** by subagents after each tool result
5. **No subagent-spawned subagents** - flat hierarchy only
6. **Persistent Research Storage** - all findings saved to `.temp/` folder

### Available Subagents

This skill coordinates with 11 specialized subagents located in `~/.claude/agents/docs/`:

**Discovery Phase:**
- `dependency-mapper` - Build dependency graphs
- `file-scanner` - Identify relevant files with confidence scores
- `pattern-analyzer` - Extract naming and composition patterns
- `component-analyzer` - Analyze Vue components (conditional: --frontend)
- `backend-analyzer` - Analyze serverless functions (conditional: --backend)

**Analysis Phase:**
- `code-deepdive` - Deep-dive into implementation details
- `architecture-synthesizer` - Map system architecture
- `usage-pattern-extractor` - Extract real-world usage examples

**Verification Phase:**
- `accuracy-verifier` - Verify all documentation claims
- `completeness-checker` - Check for missing coverage
- `example-validator` - Validate code examples (conditional)

### Research Storage Pattern

All subagent research stored in `[project]/.claude/brains/[topic-name]/.temp/`:

```
.claude/brains/[topic-name]/
├── main.md                    # Final documentation
├── metadata.json             # Topic metadata
├── .temp/                    # Research scratchpad
│   ├── plan.md              # Phase 0 strategic plan
│   ├── phase1-discovery/
│   │   ├── dependency-map.json
│   │   ├── file-scan.json
│   │   └── pattern-analysis.json
│   ├── phase2-analysis/
│   │   ├── code-deepdive.md
│   │   ├── architecture.json
│   │   └── usage-patterns.md
│   └── phase4-verification/
│       ├── accuracy-report.json
│       └── completeness-check.json
└── archives/                 # Previous versions
```

**Storage Rules:**
- Each subagent writes findings to `.temp/phase{N}-{category}/{subagent-name}.{ext}`
- Use JSON for structured data, Markdown for analysis
- Later phase subagents read from earlier phase files for context
- `.temp/` folder preserved for debugging and reference

---

## Phase Execution

**IMPORTANT:** Only execute phases listed in the loaded workflow configuration. Check `workflow_config.phases` from registry.json.

---

## Phase 0: Strategic Planning (Lead Agent)

**Runs for workflows:** comprehensive, architecture
**Skips for:** quickref, how-to (unless simple scope requires it)

### Trigger Extended Thinking

Use **"think hard"** to activate deep planning mode before any actions.

### Planning Tasks (Workflow-Aware)

```
THINK HARD about:
1. Topic Scope Analysis
   - What's explicitly in scope?
   - What's explicitly out of scope?
   - Where are the boundaries fuzzy?

2. Complexity Assessment
   - Simple: Single component/utility (1-5 files)
   - Moderate: Feature with multiple components (6-20 files)
   - Complex: System with cross-cutting concerns (20+ files)

3. Subagent Strategy
   - Which 3-5 discovery subagents needed?
   - Which 3-5 analysis subagents needed?
   - Which 2-3 verification subagents needed?
   - Are conditional subagents needed? (external deps, git history)

4. Success Criteria
   - What does "complete documentation" look like?
   - Which patterns must be documented?
   - What verification checkpoints are critical?

5. Resource Estimation
   - Expected file count: X-Y files
   - Expected token usage: ~{N}K tokens
   - Critical dependencies to document
```

### Planning Output

After thinking, document the plan:

```bash
mkdir -p [project]/.claude/brains/[topic-name]/.temp
cat > [project]/.claude/brains/[topic-name]/.temp/plan.md << 'EOF'
# Documentation Plan: [topic-name]

## Scope
- In scope: ...
- Out of scope: ...
- Boundaries: ...

## Complexity: [Simple/Moderate/Complex]

## Phase 1 Subagents (Discovery)
1. [subagent-name] - [objective]
2. [subagent-name] - [objective]
...

## Phase 2 Subagents (Analysis)
1. [subagent-name] - [objective]
...

## Phase 4 Subagents (Verification)
1. [subagent-name] - [objective]
...

## Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2
...
EOF
```

---

## Phase 1: Parallel Discovery

**Runs for workflows:** ALL (required)
**Subagent count:** Varies by workflow (see selection matrix)

### Orchestration Strategy

Spawn subagents **simultaneously** based on workflow configuration. Each subagent writes findings to `.temp/phase1-discovery/`.

**Check subagent selection matrix:**
- Load `subagents/selection-matrix.json`
- Get workflow-specific subagent list
- Apply "always" subagents
- Apply "conditional" subagents based on flags (--frontend/--backend/--both)

### Subagent Invocation Pattern (Workflow-Aware)

**For comprehensive workflow:**
```
I'll now spawn 3-5 discovery subagents in parallel:

1. Use dependency-mapper to build dependency graph
2. Use file-scanner to identify relevant files with confidence scores
3. Use pattern-analyzer to extract naming and composition patterns
[4. Use component-analyzer for Vue components] (if --frontend or --both)
[5. Use backend-analyzer for Appwrite functions] (if --backend or --both)
```

**For how-to workflow:**
```
I'll now spawn 2 discovery subagents focused on usage patterns:

1. Use file-scanner to identify relevant implementation files
2. Use usage-pattern-extractor to find real-world usage examples
```

**For quickref workflow:**
```
I'll now spawn 2 discovery subagents for pattern extraction:

1. Use file-scanner to identify pattern files
2. Use pattern-analyzer to extract common patterns and syntax
```

**For architecture workflow:**
```
I'll now spawn 3-4 discovery subagents focused on system structure:

1. Use dependency-mapper to build complete dependency graph
2. Use file-scanner to identify all system components
[3. Use component-analyzer for frontend architecture] (if --frontend or --both)
[4. Use backend-analyzer for backend architecture] (if --backend or --both)
```

Each subagent writes findings to `.temp/phase1-discovery/{subagent-name}.{ext}`

### Gap Check After Phase 1

```
THINK - Phase 1 Quality Check:

1. File Coverage
   - How many files discovered?
   - Any high-confidence files (>0.8) that seem missing?
   - Are boundary files (utilities, types) included?

2. Dependency Completeness
   - All direct dependencies mapped?
   - First-level indirect dependencies captured?
   - External packages identified?

3. Pattern Clarity
   - Naming patterns clear and consistent?
   - Composition patterns identified?
   - Any unusual patterns requiring explanation?

Decision: Proceed to Phase 2 or spawn additional discovery agents?
```

---

## Phase 2: Parallel Analysis

**Runs for workflows:** comprehensive, architecture
**Skips for:** quickref, how-to

### Orchestration Strategy

Spawn analysis subagents **simultaneously** based on workflow. Each reads from Phase 1 and writes to `.temp/phase2-analysis/`.

### Subagent Invocation Pattern (Workflow-Aware)

**For comprehensive workflow:**
```
Based on Phase 1 discoveries, I'll spawn 3-5 analysis subagents:

1. Use code-deepdive to analyze implementation details
2. Use architecture-synthesizer to map system architecture
3. Use usage-pattern-extractor to extract real-world examples
```

**For architecture workflow:**
```
Based on Phase 1 discoveries, I'll spawn 2-3 analysis subagents focused on architecture:

1. Use architecture-synthesizer to map system design and component relationships
2. Use code-deepdive to understand key architectural patterns
```

### Gap Check After Phase 2

```
THINK - Phase 2 Quality Check:

1. Architecture Clarity
   - Data flows documented?
   - Integration points identified?
   - Component relationships clear?

2. Implementation Coverage
   - Key functions/composables explained?
   - Complex logic documented?
   - Edge cases identified?

3. Usage Examples
   - Real usage patterns captured?
   - Multiple use cases shown?
   - Examples cover common scenarios?

Decision: Ready for synthesis or need additional analysis?
```

---

## Phase 3: Documentation Synthesis (Lead Agent)

**Runs for workflows:** ALL (required)
**Template:** Varies by workflow

### Synthesis Process (Workflow-Aware)

1. **Read All Research Findings**
   ```bash
   # Load discovery outputs (all workflows)
   view [project]/.claude/brains/[topic]/.temp/phase1-discovery/

   # Load analysis outputs (if phase 2 ran)
   view [project]/.claude/brains/[topic]/.temp/phase2-analysis/
   ```

2. **Load Workflow-Specific Template**

   ```bash
   # Get template from workflow config
   template_name = workflow_config.template

   # Load template
   view ~/.claude/skills/docs-v2/templates/${template_name}
   ```

   **Templates by workflow:**
   - **comprehensive:** `templates/comprehensive.md` (full documentation structure)
   - **how-to:** `templates/how-to.md` (step-by-step tutorial)
   - **quickref:** `templates/quickref.md` (concise cheat sheet)
   - **architecture:** `templates/architecture.md` (system design)

3. **Synthesize Documentation**

   Create `[project]/.claude/brains/[topic]/main.md` following the loaded template structure.

   **Fill template placeholders with research findings:**
   - Replace `{{TOPIC_NAME}}`, `{{DESCRIPTION}}`, etc.
   - Populate code examples from usage patterns
   - Add diagrams for architecture workflow
   - Ensure examples are complete and working

4. **Ensure Completeness**

   Cross-reference with Phase 1 (and Phase 2 if applicable) findings to ensure no gaps.

---

## Phase 4: Parallel Verification

**Runs for workflows:** comprehensive (required), architecture (optional)
**Skips for:** quickref, how-to

### Orchestration Strategy

Spawn verification subagents **simultaneously** based on workflow. Each writes to `.temp/phase4-verification/`.

### Subagent Invocation Pattern (Workflow-Aware)

**For comprehensive workflow:**
```
Documentation complete. Spawning 2-3 verification subagents:

1. Use accuracy-verifier to verify all claims
2. Use completeness-checker to check coverage
[3. Use example-validator to validate code examples] (if examples present)
```

**For architecture workflow (optional):**
```
If user requested verification or critical system:

1. Use accuracy-verifier to verify architectural claims
```

### Gap Check After Phase 4

```
THINK - Phase 4 Quality Assessment:

1. Critical Issues
   - Any "critical" severity issues found?
   ✓ If yes: Fix immediately before finalization

2. Warning Issues
   - How many warnings?
   ✓ If < 5: Document & proceed
   ✓ If >= 5: Review & fix major ones

3. Completeness Score
   - File coverage: X% (target: >80%)
   - Pattern coverage: Y% (target: >90%)
   ✓ If below targets: add missing items

4. Example Quality
   - All examples validated?
   - Any broken examples?
   ✓ Fix any invalid examples

Decision: Finalize or make corrections?
```

---

## Phase 5: Finalization

**Runs for workflows:** ALL (required)

### Actions (Workflow-Aware)

1. **Apply Critical Fixes** (if any from Phase 4 verification)

2. **Create Metadata**
   ```bash
   cat > [project]/.claude/brains/[topic]/metadata.json << 'EOF'
   {
     "topic": "[topic-name]",
     "workflow": "[workflow-type]",
     "created": "2025-10-29",
     "files_analyzed": X,
     "complexity": "[simple/moderate/complex]",
     "last_verified": "[date or 'not-verified']",
     "subagents_used": X,
     "verification_status": "[verified/not-verified/partial]",
     "verification_summary": {
       "accuracy": "[if verified]",
       "completeness": "[if verified]",
       "examples": "[if validated]"
     },
     "related_topics": [],
     "stack": ["Vue3", "TypeScript", "nanostore", "Tailwind CSS v4"]
   }
   EOF
   ```

3. **Create Archives Directory**
   ```bash
   mkdir -p [project]/.claude/brains/[topic]/archives
   ```

4. **Report to User (Workflow-Specific)**

   **For comprehensive workflow:**
   ```markdown
   ## Documentation Complete: [topic-name]

   **Workflow:** Comprehensive
   **Summary:**
   - X files analyzed across Y discovery and Z analysis subagents
   - N verification subagents confirmed accuracy
   - Complexity: [Simple/Moderate/Complex]
   - Verification: ✓ Passed (N minor warnings documented)

   **Documentation saved to:**
   - Main doc: [[project]/.claude/brains/[topic]/main.md]
   - Metadata: [[project]/.claude/brains/[topic]/metadata.json]
   - Research: [[project]/.claude/brains/[topic]/.temp/] (preserved)

   **Coverage:**
   - X components/modules documented
   - Y patterns identified
   - Z code examples validated
   - N external dependencies explained

   [View Documentation]
   ```

---

## Supporting Resources

This skill includes additional resources for detailed guidance:

### `resources/orchestration.md`
Detailed multi-agent coordination patterns, delegation strategies, and workflow optimization techniques.

### `resources/doc-template.md`
Standard documentation structure template ensuring consistent, comprehensive output.

### `resources/gap-checklist.md`
Phase-by-phase verification checklists for ensuring quality at each stage.

**To access these resources:** Explicitly reference them when needed, e.g., "refer to resources/orchestration.md for delegation patterns."

---

## Token Usage Expectations

- **Simple Topic** (~5 files): 50-80K tokens, 8-12 subagents
- **Moderate Topic** (~20 files): 120-200K tokens, 12-16 subagents
- **Complex Topic** (~50+ files): 250-350K tokens, 16-20 subagents

**Note:** Quality and thoroughness prioritized over speed/efficiency.

---

## Best Practices Summary

### For Lead Agent
1. Always use **"think hard"** before each phase
2. Explicitly check gaps after Phases 1, 2, 4
3. Spawn 3-5 subagents in parallel per phase
4. Read all `.temp/` research before synthesis
5. Never skip verification phase

### For Subagent Delegation
1. Be explicit: "Use the [subagent-name] subagent to [specific task]"
2. Specify output location in delegation
3. Batch parallel invocations when independent
4. Reference previous phase outputs when needed
5. Use conditional subagents based on flags (--frontend, --backend)

### Tool Usage
- **Prefer:** `Grep` for text search (ripgrep)
- **Batch:** Multiple `Read` calls together when independent
- **Parallel:** Delegate to multiple subagents simultaneously
- **Context:** Use absolute paths, avoid directory changes

---

## Skill Directory Structure

```
~/.claude/skills/docs/
├── SKILL.md                    # This file
├── resources/
│   ├── orchestration.md        # Multi-agent patterns
│   ├── doc-template.md         # Documentation template
│   └── gap-checklist.md        # Verification checklists
└── templates/
    ├── subagent-template.md    # Subagent format guide
    └── verification-report.md  # Verification output format
```

All supporting files available via progressive disclosure.

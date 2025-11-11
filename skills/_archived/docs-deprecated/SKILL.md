---
name: docs-deprecated
description: Research and document codebase topics comprehensively using multi-agent orchestration. Use when user requests "document [topic]", "create docs for [feature]", "/docs new [topic]", or "research and document [workflow/component/system]". Optimized for Vue3, Astro, TypeScript, nanostore, Appwrite, Tailwind CSS v4 projects.
tools: [Bash, Grep, Glob, Read, Write]
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

**Prioritizes accuracy and thoroughness over speed.** Expect 15-20 subagent invocations and significant token usage (50K-300K+) for complete, verified documentation.

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

## Phase 0: Strategic Planning (Lead Agent)

### Trigger Extended Thinking

Use **"think hard"** to activate deep planning mode before any actions.

### Planning Tasks

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

### Orchestration Strategy

Spawn 3-5 discovery subagents **simultaneously**. Each subagent writes findings to `.temp/phase1-discovery/`.

### Subagent Invocation Pattern

```
I'll now spawn [N] discovery subagents in parallel to gather foundational information:

1. Use the dependency-mapper subagent to build the complete dependency graph for [topic]
2. Use the file-scanner subagent to identify all relevant files with confidence scores
3. Use the pattern-analyzer subagent to extract naming and composition patterns
[4. Use the component-analyzer subagent to analyze Vue components] (if --frontend)
[5. Use the backend-analyzer subagent to analyze Appwrite functions] (if --backend)
```

Each subagent will write findings to its designated output file.

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

### Orchestration Strategy

Spawn 3-5 analysis subagents **simultaneously**. Each subagent reads from Phase 1 outputs and writes to `.temp/phase2-analysis/`.

### Subagent Invocation Pattern

```
Based on Phase 1 discoveries, I'll now spawn [N] analysis subagents to perform deep research:

1. Use the code-deepdive subagent to analyze implementation details across high-confidence files
2. Use the architecture-synthesizer subagent to map the overall system architecture
3. Use the usage-pattern-extractor subagent to extract real-world usage examples
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

### Synthesis Process

1. **Read All Research Findings**
   ```bash
   # Load all discovery outputs
   view [project]/.claude/brains/[topic]/.temp/phase1-discovery/

   # Load all analysis outputs
   view [project]/.claude/brains/[topic]/.temp/phase2-analysis/
   ```

2. **Structure Documentation**

   Use the documentation template from `resources/doc-template.md` as the structure guide.

3. **Write Comprehensive Documentation**

   Create `[project]/.claude/brains/[topic]/main.md` with:
   - Overview and purpose
   - Architecture and components
   - Implementation patterns
   - Usage examples
   - Dependencies and integration
   - Edge cases and considerations

4. **Ensure Completeness**

   Cross-reference with Phase 1-2 findings to ensure no gaps.

---

## Phase 4: Parallel Verification

### Orchestration Strategy

Spawn 2-3 verification subagents **simultaneously**. Each verifies different aspects and writes to `.temp/phase4-verification/`.

### Subagent Invocation Pattern

```
Documentation complete. Now spawning verification subagents to ensure quality:

1. Use the accuracy-verifier subagent to verify all claims in the documentation
2. Use the completeness-checker subagent to check for missing coverage
[3. Use the example-validator subagent to validate all code examples] (if examples present)
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

### Actions

1. **Apply Critical Fixes** (if any from Phase 4)

2. **Create Metadata**
   ```bash
   cat > [project]/.claude/brains/[topic]/metadata.json << 'EOF'
   {
     "topic": "[topic-name]",
     "created": "2025-10-29",
     "files_analyzed": 42,
     "complexity": "moderate",
     "last_verified": "2025-10-29",
     "subagents_used": 14,
     "verification_status": "verified",
     "verification_summary": {
       "accuracy": "45 claims verified, 2 warnings",
       "completeness": "83% file coverage",
       "examples": "5/5 examples valid"
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

4. **Report to User**
   ```markdown
   ## Documentation Complete: [topic-name]

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

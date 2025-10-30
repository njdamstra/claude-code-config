# Codebase Documentation System Architecture

**System Type:** Three-tier workflow orchestration framework with configuration-driven multi-agent coordination
**Last Updated:** 2025-10-29
**Complexity:** Complex

---

## System Overview

The codebase documentation system is a sophisticated multi-agent orchestration framework that generates comprehensive technical documentation through coordinated research phases. The system consists of three core components: a slash command entry point (`/docs`), an orchestration skill that coordinates workflow execution, and 11 specialized subagents that perform discovery, analysis, and verification tasks in parallel.

**Purpose:**
Automate comprehensive codebase documentation generation through systematic multi-phase research, ensuring accuracy, completeness, and proper architectural understanding.

**Key Responsibilities:**
- Parse user documentation requests and select appropriate workflow (comprehensive, how-to, quickref, or architecture)
- Orchestrate multi-phase research using specialized subagents (discovery → analysis → synthesis → verification)
- Generate workflow-specific documentation using templates populated with verified research findings
- Manage research artifacts, quality gates, and verification checkpoints throughout the process

---

## System Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      USER INPUT                                  │
│  /docs new <topic> Description: ... Workflow: ... Flags: ...    │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│               COMMAND LAYER (/commands/docs.md)                  │
│  • Parse arguments (topic, description, workflow, flags)         │
│  • Validate input format                                         │
│  • Trigger skill invocation via natural language pattern         │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│        ORCHESTRATION LAYER (/skills/codebase-documentation/)     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Step 1: Load Configurations                              │  │
│  │  • workflows/registry.json (4 workflows)                  │  │
│  │  • phases/phase-registry.json (6 phases)                  │  │
│  │  • subagents/selection-matrix.json (conditional logic)    │  │
│  │  • templates/*.md (4 output templates)                    │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Step 2: Execute Workflow Phases                          │  │
│  │  Phase 0: Strategic Planning (extended thinking)          │  │
│  │  Phase 1: Discovery (2-5 subagents in parallel)           │  │
│  │  Phase 2: Analysis (2-5 subagents in parallel)            │  │
│  │  Phase 3: Synthesis (template + research → main.md)       │  │
│  │  Phase 4: Verification (1-3 subagents in parallel)        │  │
│  │  Phase 5: Finalization (metadata + archiving)             │  │
│  └───────────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│            WORKER LAYER (/agents/docs/*.md)                      │
│  Discovery Agents (Phase 1):                                     │
│    • dependency-mapper       • component-analyzer (conditional)  │
│    • file-scanner            • backend-analyzer (conditional)    │
│    • pattern-analyzer                                            │
│  Analysis Agents (Phase 2):                                      │
│    • code-deepdive           • usage-pattern-extractor           │
│    • architecture-synthesizer                                    │
│  Verification Agents (Phase 4):                                  │
│    • accuracy-verifier       • example-validator (conditional)   │
│    • completeness-checker                                        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│         STORAGE LAYER (.claude/brains/<topic>/)                  │
│  main.md              ← Final documentation                      │
│  metadata.json        ← Topic metadata                           │
│  .temp/               ← Research artifacts (preserved)           │
│    ├── plan.md        ← Phase 0 strategic plan                   │
│    ├── phase1-discovery/*.json                                   │
│    ├── phase2-analysis/*.{json,md}                               │
│    └── phase4-verification/*.json                                │
│  archives/            ← Previous versions                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Component Architecture

### Component 1: Command Interface

**Purpose:** Parse user input and trigger skill invocation through natural language pattern matching

**Responsibilities:**
- Parse `/docs new <topic>` command arguments
- Extract description, workflow type, and flags (--frontend/--backend/--both)
- Validate input format and provide helpful error messages
- Generate natural language trigger that activates the codebase-documentation skill
- Handle edge cases (topic already exists, invalid workflow, missing description)

**Dependencies:**
- `/skills/codebase-documentation/` (triggers via natural language)
- SlashCommand tool (Claude Code execution)

**Implementation:** `~/.claude/commands/docs.md`

**Diagram:**
```
User Input: /docs new authentication Description: ... Workflow: comprehensive
           ↓
    [Parse Arguments]
           ↓
    topic: "authentication"
    description: "Document auth system..."
    workflow: "comprehensive" (or default)
    flags: "--frontend" (or default)
           ↓
    [Generate Natural Language Trigger]
           ↓
    "I'll create comprehensive documentation for authentication..."
           ↓
    [Skill Auto-Invocation] → codebase-documentation skill activated
```

**Argument Parsing Logic:**
```
Input format: /docs new <topic> Description: <text> Workflow: <type> Flags: <flags>

Extraction rules:
  • First word after "new": topic name
  • After "Description:": detailed description (required)
  • After "Workflow:": comprehensive|how-to|quickref|architecture (optional, default: comprehensive)
  • After "Flags:": --frontend|--backend|--both (optional, default: --frontend)

Error handling:
  • Missing description → prompt user with example
  • Invalid workflow → show valid options
  • Topic exists → offer archive/regenerate options
```

---

### Component 2: Orchestration Skill

**Purpose:** Coordinate multi-phase workflow execution using configuration-driven orchestration

**Responsibilities:**
- Detect workflow type from user input (command flags or natural language)
- Load workflow configuration (phases, subagents, template, quality targets)
- Execute phases sequentially with quality gate checks
- Delegate research tasks to specialized subagents via Task tool
- Manage research artifact storage in `.temp/` directories
- Apply workflow-specific templates during synthesis phase
- Coordinate verification and finalization

**Dependencies:**
- `workflows/registry.json` - Workflow definitions
- `phases/phase-registry.json` - Phase execution rules
- `subagents/selection-matrix.json` - Conditional subagent selection
- `templates/*.md` - Output templates
- 11 specialized subagents (`/agents/docs/`)
- Task tool for subagent delegation

**Implementation:** `~/.claude/skills/codebase-documentation/SKILL.md`

**Diagram:**
```
Skill Invocation
      ↓
[Step 1: Workflow Detection]
  • Parse user input for workflow indicators
  • Default to "comprehensive" if unclear
      ↓
[Step 2: Load Configurations]
  • Read workflows/registry.json
  • Read phases/phase-registry.json
  • Read subagents/selection-matrix.json
      ↓
[Step 3: Execute Phases Sequentially]
  Phase 0: Strategic Planning
    • Extended thinking ("think hard")
    • Create .temp/plan.md
  Phase 1: Discovery
    • Spawn 2-5 subagents in parallel
    • Wait for all to complete
    • Gap check: file coverage, dependencies, patterns
  Phase 2: Analysis
    • Spawn 2-5 subagents in parallel
    • Read Phase 1 artifacts
    • Gap check: architecture clarity, implementation details
  Phase 3: Synthesis
    • Load workflow-specific template
    • Read all .temp/ research artifacts
    • Populate template placeholders
    • Write main.md
  Phase 4: Verification (if required by workflow)
    • Spawn 1-3 verification subagents
    • Gap check: critical issues, coverage targets
  Phase 5: Finalization
    • Apply critical fixes
    • Create metadata.json
    • Create archives/ directory
    • Report completion
```

**Workflow Selection Logic:**
```
Detection priority:
  1. Explicit flag: --workflow comprehensive
  2. Natural language: "create a how-to guide" → how-to
  3. Default: comprehensive

Workflow phase sequences:
  • comprehensive: plan → discovery → analysis → synthesis → verification → finalize
  • how-to:        plan → discovery → synthesis → finalize
  • quickref:             discovery → synthesis → finalize
  • architecture:  plan → discovery → analysis → synthesis → finalize
```

---

### Component 3: Subagent Workers

**Purpose:** Execute specialized research tasks in parallel during discovery, analysis, and verification phases

**Responsibilities:**
- Perform focused research tasks (file scanning, dependency mapping, pattern analysis, code deep-dives)
- Write findings to `.temp/phase{N}-{category}/{subagent-name}.{ext}`
- Operate independently without spawning recursive subagents (flat hierarchy)
- Use Read, Grep, Glob, Bash tools for codebase analysis
- Provide structured output (JSON for data, Markdown for analysis)

**Dependencies:**
- Codebase files (target of research)
- `.temp/` directories (output location)
- Previous phase artifacts (for analysis/verification phases)
- Read, Grep, Glob, Bash tools

**Implementation:** `~/.claude/agents/docs/*.md` (11 subagent files)

**11 Specialized Subagents:**

**Discovery Phase (5 subagents):**
1. **dependency-mapper** - Build dependency graphs between components
2. **file-scanner** - Identify relevant files with confidence scores
3. **pattern-analyzer** - Extract naming conventions and composition patterns
4. **component-analyzer** (conditional: --frontend) - Analyze Vue components
5. **backend-analyzer** (conditional: --backend) - Analyze Appwrite serverless functions

**Analysis Phase (3 subagents):**
6. **code-deepdive** - Deep analysis of implementation details and complex logic
7. **architecture-synthesizer** - Map system architecture, data flows, integration points
8. **usage-pattern-extractor** - Extract real-world usage examples from codebase

**Verification Phase (3 subagents):**
9. **accuracy-verifier** - Verify all documentation claims against actual codebase
10. **completeness-checker** - Check coverage against Phase 1 discoveries
11. **example-validator** (conditional: has_examples) - Validate code examples are syntactically correct

**Subagent Selection Logic (from selection-matrix.json):**
```
For each phase in workflow:
  • "always" subagents: spawn unconditionally
  • "conditional" subagents: spawn based on:
    - Flags: --frontend, --backend, --both
    - Content: has_examples (if documentation contains code examples)
    - User intent: user_requested (if user explicitly requests verification)

Example (comprehensive workflow, --both flag):
  Discovery: dependency-mapper + file-scanner + pattern-analyzer + component-analyzer + backend-analyzer
  Analysis: code-deepdive + architecture-synthesizer + usage-pattern-extractor
  Verification: accuracy-verifier + completeness-checker + example-validator (if examples present)
```

---

## Data Flow

### Flow 1: Documentation Generation (End-to-End)

**Sequence:**
```
User Input
  → Command Parsing
  → Skill Invocation
  → Workflow Detection
  → Configuration Loading
  → Phase 0: Strategic Planning (extended thinking → .temp/plan.md)
  → Phase 1: Discovery (2-5 subagents → .temp/phase1-discovery/*.json)
  → Gap Check 1 (file coverage, dependencies, patterns)
  → Phase 2: Analysis (2-5 subagents → .temp/phase2-analysis/*.{json,md})
  → Gap Check 2 (architecture clarity, implementation coverage)
  → Phase 3: Synthesis (template + research → main.md)
  → Phase 4: Verification (1-3 subagents → .temp/phase4-verification/*.json)
  → Gap Check 3 (critical issues, coverage targets)
  → Phase 5: Finalization (metadata.json, archives/)
  → Final Output
```

**Data transformations:**
1. **Command → Skill:** Raw arguments (topic, description, workflow, flags) → Natural language trigger
2. **Workflow Detection:** Natural language → Workflow config object (phases, subagents, template, quality targets)
3. **Discovery Phase:** Codebase files → Structured research artifacts (dependency-map.json, file-scan.json, pattern-analysis.json)
4. **Analysis Phase:** Phase 1 artifacts + codebase → Architecture synthesis (architecture.json, code-deepdive.md)
5. **Synthesis Phase:** All research artifacts + template → Populated documentation (main.md)
6. **Verification Phase:** main.md + codebase → Verification reports (accuracy-report.json, completeness-check.json)
7. **Finalization:** All artifacts → Metadata (metadata.json) + archived versions

**Diagram:**
```
┌─────────────┐
│ User Input  │ /docs new auth Description: ... Workflow: comprehensive
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Command    │ Parse → {topic, description, workflow, flags}
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Skill     │ Detect workflow, load configs
└──────┬──────┘
       │
       ├─── Phase 0: plan.md
       │
       ├─── Phase 1: 3-5 subagents in parallel
       │         │
       │         ├─── dependency-map.json
       │         ├─── file-scan.json
       │         └─── pattern-analysis.json
       │
       ├─── Phase 2: 2-5 subagents in parallel (read Phase 1)
       │         │
       │         ├─── architecture.json
       │         └─── code-deepdive.md
       │
       ├─── Phase 3: Template + Phase 1+2 artifacts → main.md
       │
       ├─── Phase 4: 1-3 verification subagents (read main.md)
       │         │
       │         ├─── accuracy-report.json
       │         └─── completeness-check.json
       │
       └─── Phase 5: metadata.json, archives/
```

---

### Flow 2: Configuration Loading & Workflow Execution

**Sequence:**
```
Skill Activation
  → Read workflows/registry.json
  → Extract workflow definition
  → Read phases/phase-registry.json
  → Read subagents/selection-matrix.json
  → Build execution plan
  → Execute phases sequentially
  → Return final documentation
```

**Data transformations:**
1. **Registry Loading:** JSON files → In-memory workflow config object
2. **Subagent Selection:** Workflow type + flags → List of subagents to spawn per phase
3. **Template Selection:** Workflow type → Template file path (comprehensive.md, how-to.md, etc.)
4. **Phase Orchestration:** Phase definitions + subagent selection → Execution order with gap checks

**Configuration Flow:**
```
workflows/registry.json
  {
    "comprehensive": {
      "phases": ["plan", "discovery", "analysis", "synthesis", "verification", "finalize"],
      "template": "comprehensive.md",
      ...
    }
  }
          ↓
phases/phase-registry.json
  {
    "discovery": {
      "required_for": ["comprehensive", ...],
      "gap_check": true,
      ...
    }
  }
          ↓
subagents/selection-matrix.json
  {
    "comprehensive": {
      "discovery": {
        "always": ["dependency-mapper", "file-scanner", "pattern-analyzer"],
        "conditional": {
          "--frontend": ["component-analyzer"]
        }
      }
    }
  }
          ↓
Execution Plan:
  • Phase 1: Spawn dependency-mapper, file-scanner, pattern-analyzer
  • Gap check after Phase 1
  • Phase 2: Spawn code-deepdive, architecture-synthesizer
  • ...
```

---

## Integration Points

### Integration 1: Command → Skill Activation

**Systems involved:** Command Interface (`/commands/docs.md`) ↔ Orchestration Skill (`/skills/codebase-documentation/`)

**Communication protocol:** Natural language pattern matching (loose coupling)

**Data exchanged:**
- **Direction:** Command → Skill
- **Format:** Natural language description
- **Data:** Topic name, workflow type, scope (frontend/backend/both), detailed description

**Implementation:**
```markdown
Command output (docs.md):
"I'll create comprehensive documentation for authentication.

**Topic:** authentication
**Workflow:** comprehensive
**Scope:** frontend
**Description:** Document the authentication system including login, registration, and session management

This will involve:
- 15-20 subagent invocations across 6 phases
- Full research with verification
- Expected token usage: 50-350K tokens
- Estimated time: 20-60 minutes

Let me proceed with comprehensive workflow..."
```

Claude recognizes this pattern matches the `codebase-documentation` skill description and automatically invokes the skill using the Skill tool.

**Error handling:**
- Invalid workflow → Command shows valid options before triggering skill
- Missing description → Command prompts user for required info
- Topic exists → Command offers archive/regenerate options

**Benefits of loose coupling:**
- ✅ Command can be modified without changing skill
- ✅ Skill can be invoked manually without command
- ✅ Natural language allows flexibility in user input
- ⚠️ Requires pattern matching to be robust

---

### Integration 2: Skill ↔ Configuration Files

**Systems involved:** Orchestration Skill ↔ JSON Configuration Registries

**Communication protocol:** Explicit file reads (tight coupling)

**Data exchanged:**
- **Direction:** Configs → Skill (read-only)
- **Format:** JSON
- **Data:** Workflow definitions, phase rules, subagent selection logic

**File Dependencies:**
```
Skill reads:
  1. workflows/registry.json       → Workflow definitions
  2. phases/phase-registry.json    → Phase execution rules
  3. subagents/selection-matrix.json → Conditional subagent selection
  4. templates/<workflow>.md       → Output template
```

**Loading sequence:**
```markdown
1. Detect workflow type from user input
2. Read workflows/registry.json
3. Extract workflow definition: workflow_config = registry.workflows[detected_workflow]
4. Read phases/phase-registry.json
5. For each phase in workflow_config.phases:
     - Get phase definition
     - Note if required/optional/skipped
6. Read subagents/selection-matrix.json
7. Build subagent spawn list per phase (always + conditional)
```

**Error handling:**
- Missing config file → Skill fails with error message
- Invalid JSON → Skill reports parsing error
- Missing workflow → Skill defaults to "comprehensive"
- Missing template → Skill reports template not found

**Benefits of tight coupling:**
- ✅ Configuration changes take effect immediately
- ✅ Easy to add new workflows without code changes
- ✅ Clear separation of logic (configs) and orchestration (skill)
- ⚠️ Breaking config format requires skill updates

---

### Integration 3: Skill ↔ Subagents

**Systems involved:** Orchestration Skill ↔ 11 Specialized Subagents

**Communication protocol:** Task tool delegation + file-based artifact passing (medium coupling)

**Data exchanged:**
- **Direction (delegation):** Skill → Subagent (task prompt)
- **Direction (results):** Subagent → Skill (research artifacts in .temp/ files)
- **Format:** Markdown prompts (delegation), JSON/Markdown files (artifacts)
- **Data:** Research objectives, scope, output format, previous phase artifacts

**Delegation Pattern:**
```markdown
Skill spawns subagent via Task tool:

[Task tool invocation]
  subagent_type: "dependency-mapper"
  prompt: "
    **Objective:** Build complete dependency graph
    **Topic:** authentication
    **Scope:** ...
    **Output Location:** .temp/phase1-discovery/dependency-map.json
    **Output Format:** {...}
  "

Subagent executes independently:
  • Reads codebase files
  • Analyzes dependencies
  • Writes .temp/phase1-discovery/dependency-map.json

Skill reads artifact:
  • After all Phase 1 subagents complete
  • Gap check using artifact data
  • Pass to Phase 2 subagents
```

**Artifact Storage:**
```
.temp/
  ├── plan.md
  ├── phase1-discovery/
  │   ├── dependency-map.json       ← dependency-mapper output
  │   ├── file-scan.json             ← file-scanner output
  │   └── pattern-analysis.json      ← pattern-analyzer output
  ├── phase2-analysis/
  │   ├── architecture.json          ← architecture-synthesizer output
  │   └── code-deepdive.md           ← code-deepdive output
  └── phase4-verification/
      ├── accuracy-report.json       ← accuracy-verifier output
      └── completeness-check.json    ← completeness-checker output
```

**Error handling:**
- Subagent failure → Skill retries or reports error
- Missing artifact → Skill detects gap and respawns subagent
- Invalid artifact format → Skill reports parsing error

**Benefits of file-based coordination:**
- ✅ Simple, debuggable (artifacts visible to user)
- ✅ Persistent (artifacts preserved after completion)
- ✅ Parallelizable (subagents don't block each other)
- ⚠️ Requires explicit file I/O management

---

### Integration 4: Phase → Phase Data Flow

**Systems involved:** Sequential phases passing research artifacts

**Communication protocol:** File-based artifact passing via .temp/ directories

**Data exchanged:**
- **Direction:** Phase N → Phase N+1 (read artifacts from previous phases)
- **Format:** JSON (structured data), Markdown (analysis)
- **Data:** Discovery findings, analysis results, verification reports

**Phase Dependencies:**
```
Phase 0 (plan.md) → Phase 1 (read plan for scope)
Phase 1 (discovery/*.json) → Phase 2 (read for deep analysis)
Phase 1 + Phase 2 → Phase 3 (read all for synthesis)
Phase 3 (main.md) → Phase 4 (read main.md to verify)
Phase 4 (verification/*.json) → Phase 5 (apply fixes, create metadata)
```

**Example Artifact Flow:**
```
Phase 1: file-scanner writes file-scan.json
  {
    "files": [
      {"path": "src/auth/login.ts", "confidence": 1.0, "role": "Login handler"},
      ...
    ]
  }
          ↓
Phase 2: code-deepdive reads file-scan.json
  • Knows which files to analyze deeply
  • Prioritizes high-confidence files (>0.8)
  • Writes code-deepdive.md with implementation details
          ↓
Phase 3: Synthesis reads file-scan.json + code-deepdive.md
  • Populates template "Files Analyzed" section
  • Includes implementation details from code-deepdive.md
  • Writes main.md
          ↓
Phase 4: accuracy-verifier reads main.md
  • Verifies claims match actual codebase
  • Writes accuracy-report.json
          ↓
Phase 5: Finalization reads accuracy-report.json
  • Applies critical fixes to main.md
  • Creates metadata.json with verification status
```

---

### Integration 5: Subagent → Codebase

**Systems involved:** Subagents ↔ Project Codebase Files

**Communication protocol:** Read, Grep, Glob, Bash tools

**Data exchanged:**
- **Direction:** Codebase → Subagent (read-only)
- **Format:** Source code, config files, documentation
- **Data:** Implementation details, patterns, dependencies, usage examples

**Tool Usage Patterns:**
```
Glob: Find files by pattern
  • "**/*.vue" → Find all Vue components
  • "src/auth/**/*.ts" → Find all auth TypeScript files

Grep: Search file contents
  • pattern: "export function" → Find exported functions
  • pattern: "import.*from.*nanostore" → Find nanostore usage

Read: Read specific files
  • Read file_path: "src/auth/login.ts"
  • Get full implementation details

Bash: Run commands
  • ls -la src/ → List directory structure
  • git log --oneline --since="1 month ago" → Get recent changes
```

**Error handling:**
- File not found → Subagent reports missing file
- Permission denied → Subagent skips file
- Large file → Subagent reads in chunks

---

### Integration 6: Synthesis → Template System

**Systems involved:** Phase 3 Synthesis ↔ Workflow-Specific Templates

**Communication protocol:** Template loading + placeholder replacement

**Data exchanged:**
- **Direction:** Template → Synthesis (template structure), Research Artifacts → Synthesis (data to fill template)
- **Format:** Markdown with placeholders (`{{PLACEHOLDER}}`)
- **Data:** Documentation structure, sections, formatting

**Template Selection:**
```
Workflow type → Template file
  • comprehensive → templates/comprehensive.md
  • how-to → templates/how-to.md
  • quickref → templates/quickref.md
  • architecture → templates/architecture.md
```

**Placeholder Replacement:**
```markdown
Template (architecture.md):
  # {{SYSTEM_NAME}} Architecture
  **System Type:** {{SYSTEM_TYPE}}
  ...

Research Artifacts:
  • Phase 1: file-scan.json → {"files": [...], "total_files": 23}
  • Phase 2: architecture.json → {"system_overview": "Three-tier..."}

Synthesis:
  1. Load template: templates/architecture.md
  2. Read all .temp/ artifacts
  3. Replace placeholders:
     {{SYSTEM_NAME}} → "Codebase Documentation System"
     {{SYSTEM_TYPE}} → "Three-tier workflow orchestration framework"
  4. Write main.md
```

**Error handling:**
- Template not found → Skill reports error
- Missing placeholder data → Skill fills with "[Data not available]"
- Invalid placeholder syntax → Skill logs warning

---

## State Management

**State storage:** File-based state in `.temp/` directories + final documentation in `main.md` and `metadata.json`

**State transitions:**
```
[Idle] → User invokes /docs command
  ↓
[Parsing] → Command parses arguments
  ↓
[Skill Activation] → Skill invoked via natural language
  ↓
[Config Loading] → Skill loads workflow/phase/subagent configs
  ↓
[Phase 0: Planning] → .temp/plan.md created
  ↓
[Phase 1: Discovery] → Subagents spawn, .temp/phase1-discovery/*.json created
  ↓
[Gap Check 1] → Quality assessment, decision: proceed or retry
  ↓
[Phase 2: Analysis] → Subagents spawn, .temp/phase2-analysis/*.{json,md} created
  ↓
[Gap Check 2] → Quality assessment, decision: proceed or retry
  ↓
[Phase 3: Synthesis] → main.md created from template + artifacts
  ↓
[Phase 4: Verification] (if required) → .temp/phase4-verification/*.json created
  ↓
[Gap Check 3] → Critical issues check, decision: fix or finalize
  ↓
[Phase 5: Finalization] → metadata.json created, archives/ created
  ↓
[Complete] → Final output delivered to user
```

**Key states:**
- **Planning:** Extended thinking, strategic decisions, .temp/plan.md exists
- **Discovery:** Parallel subagent execution, .temp/phase1-discovery/ exists
- **Analysis:** Deep research, .temp/phase2-analysis/ exists
- **Synthesis:** Template population, main.md exists
- **Verification:** Quality checks, .temp/phase4-verification/ exists
- **Finalized:** metadata.json exists, archives/ directory created

**State persistence:**
- **Persistent:** All .temp/ artifacts preserved indefinitely for debugging/reference
- **Versioned:** Previous main.md versions archived to archives/<timestamp>-main.md
- **Metadata:** metadata.json tracks workflow type, verification status, complexity

---

## Design Decisions

### Decision 1: Configuration-Driven vs. Hard-Coded Workflows

**Context:**
The system needed to support multiple documentation workflows (comprehensive, how-to, quickref, architecture) with different phase sequences and subagent combinations. The choice was between hard-coding workflow logic in the skill file vs. externalizing it to JSON configuration files.

**Options considered:**
1. **Hard-coded workflows** - Embed all workflow logic in SKILL.md with if/else conditionals
2. **Configuration-driven** - Externalize workflow definitions to JSON registries
3. **Hybrid approach** - Core logic in skill, minor variations in config

**Decision:** Configuration-driven design using JSON registries (workflows/registry.json, phases/phase-registry.json, subagents/selection-matrix.json)

**Rationale:**
- Workflows can be added/modified without changing skill code
- Clear separation of concerns (orchestration logic vs. workflow definitions)
- Easier to test and debug (config files are data, not code)
- Non-technical users can create new workflows by editing JSON

**Consequences:**
- ✅ Extensibility: New workflows added by editing JSON files
- ✅ Maintainability: Workflow changes don't require skill updates
- ✅ Clarity: Workflow definitions are declarative and easy to understand
- ⚠️ Complexity: Requires multiple file reads at initialization
- ⚠️ Tight coupling: Skill depends on specific config file structure
- ⚠️ Error handling: Config file errors can break entire system

---

### Decision 2: Parallel vs. Sequential Subagent Execution

**Context:**
Each phase spawns multiple subagents (2-5) to perform research tasks. The choice was whether to spawn them sequentially (one at a time) or in parallel (all at once).

**Decision:** Parallel subagent execution using multiple Task tool invocations in a single message

**Rationale:**
- 2-5x faster execution (subagents don't wait for each other)
- Independent research tasks don't have dependencies
- Task tool supports parallel delegation
- Better user experience (faster documentation generation)

**Consequences:**
- ✅ Performance: 2-5x speedup for each phase
- ✅ User experience: Faster time to completion (5-60 minutes vs. 15-180 minutes)
- ⚠️ Token usage: Multiple subagents consume tokens simultaneously
- ⚠️ Complexity: Skill must track completion of all parallel subagents

---

### Decision 3: File-Based vs. Return-Value Artifact Passing

**Context:**
Subagents need to pass research findings to the skill and to subsequent phases. The choice was between returning findings directly (return value) or writing to files (.temp/ directories).

**Decision:** File-based artifact passing using .temp/ directories

**Rationale:**
- Persistent artifacts visible to user (transparency)
- Debugging easier (can inspect intermediate results)
- Subagents can write large outputs without token limits
- Supports parallel execution (no blocking)
- Artifacts preserved after completion (reference for future work)

**Consequences:**
- ✅ Transparency: User can inspect research artifacts
- ✅ Debuggability: Issues can be traced to specific subagent outputs
- ✅ Persistence: Artifacts preserved for future reference
- ⚠️ File I/O overhead: Explicit reads/writes required
- ⚠️ Cleanup: .temp/ directories grow over time (but intentionally preserved)

---

### Decision 4: Flat vs. Hierarchical Subagent Delegation

**Context:**
Subagents could potentially spawn their own subagents (hierarchical delegation) or only the lead agent can spawn subagents (flat delegation).

**Decision:** Flat hierarchy - only lead agent spawns subagents, no recursive spawning allowed

**Rationale:**
- Simpler orchestration (one level of delegation)
- Easier to track progress (known number of subagents)
- Prevents infinite recursion
- Clear separation: lead agent orchestrates, subagents execute

**Consequences:**
- ✅ Simplicity: One coordination level
- ✅ Predictability: Known subagent count per phase
- ✅ Safety: No infinite recursion risk
- ⚠️ Limited flexibility: Subagents can't delegate complex tasks

---

## Scalability Considerations

### Performance Characteristics

**Current capacity:**
- **File count:** Handles 5-50+ files per documentation topic
- **Token usage:** 10K-350K tokens per documentation generation
- **Subagent count:** 2-20 subagents per workflow
- **Time:** 5-60 minutes per documentation topic
- **Parallel execution:** 2-5 simultaneous subagents per phase

**Bottlenecks:**
1. **Sequential phase execution:**
   - **Impact:** Phases run one at a time, limiting parallelism
   - **Mitigation:** Parallel subagent spawning within each phase (implemented)

2. **Token consumption during verification:**
   - **Impact:** Verification phase reads main.md + codebase, high token cost
   - **Mitigation:** Make verification optional for quickref/how-to workflows (implemented)

3. **File I/O for artifact passing:**
   - **Impact:** Multiple .temp/ file reads/writes per phase
   - **Mitigation:** Use JSON for structured data (smaller files), batch reads where possible

**Optimization strategies:**
- **Conditional subagents:** Only spawn when needed (--frontend, --backend, has_examples)
- **Workflow selection:** Use lightweight workflows (quickref, how-to) for simple topics
- **Gap checks:** Prevent wasted work by catching issues early
- **Parallel execution:** 2-5 subagents per phase

---

### Scalability Path

**Horizontal scaling:**
Not applicable (single-user CLI tool, no distributed architecture)

**Vertical scaling:**
- Increase parallelism: Spawn more subagents per phase (currently 2-5, could increase to 10)
- Optimize token usage: Cache repeated reads, use smaller models for simple tasks

**Workflow optimization:**
- Add more lightweight workflows for specific use cases (e.g., "api-reference" workflow)
- Skip phases for simple topics (quickref workflow already does this)
- Conditional phase execution based on topic complexity

---

## Security Considerations

**Authentication:** Not applicable (local CLI tool, no network access)

**Authorization:** File system permissions (user can only access files they own)

**Data protection:**
- **In transit:** Not applicable (no network communication)
- **At rest:** Documentation stored in `.claude/brains/` with user file permissions

**Security boundaries:**
```
┌────────────────────────────────────────┐
│  User's File System (trusted)          │
│  ┌──────────────────────────────────┐  │
│  │  Claude Code CLI                 │  │
│  │  ├── /commands/docs.md           │  │
│  │  ├── /skills/codebase-documentation/ │
│  │  ├── /agents/docs/               │  │
│  │  └── /brains/<topic>/.temp/      │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  Project Codebase (read-only)    │  │
│  │  └── src/, docs/, etc.           │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

**Security concerns:**
- Subagents have read access to entire codebase
- No secret scanning (could accidentally include API keys in documentation)
- No sandboxing (Bash tool can execute arbitrary commands if delegated)

---

## Failure Modes & Recovery

### Failure Mode 1: Configuration File Missing or Invalid

**Trigger:** Skill attempts to read registry.json, phase-registry.json, or selection-matrix.json but file is missing or contains invalid JSON

**Impact:** Skill cannot load workflow configuration, entire documentation generation fails

**Detection:** File read error or JSON parse error during config loading

**Recovery:**
- Skill reports clear error message: "Failed to load workflows/registry.json: File not found"
- User must fix config file or restore from backup
- No automatic recovery (fail fast)

---

### Failure Mode 2: Subagent Failure During Discovery/Analysis

**Trigger:** Subagent encounters error (file not found, permission denied, tool timeout)

**Impact:** Missing research artifact in .temp/ directory, subsequent phases may have incomplete data

**Detection:** Gap check detects missing artifact or incomplete coverage

**Recovery:**
- Skill respawns failed subagent with retry logic
- If retry fails, skill proceeds with warning and incomplete data
- Gap check may fail and require manual intervention

---

### Failure Mode 3: Gap Check Failure

**Trigger:** Gap check criteria not met (e.g., file coverage <80%, critical issues found in verification)

**Impact:** Quality gate failed, documentation may be incomplete or inaccurate

**Detection:** Explicit gap check logic after phases 1, 2, 4

**Recovery:**
- **Critical issues:** Skill halts and reports issues to user, requires manual fix
- **Warnings:** Skill proceeds with warning, documents gaps in metadata.json
- **Coverage gaps:** Skill may respawn subagents to fill gaps

---

### Failure Mode 4: Template Not Found

**Trigger:** Synthesis phase attempts to load template for workflow type but file doesn't exist

**Impact:** Cannot generate final documentation, synthesis phase fails

**Detection:** File read error during template loading

**Recovery:**
- Skill reports error: "Template not found: templates/comprehensive.md"
- User must create template or use different workflow
- No automatic recovery

---

## Monitoring & Observability

**Metrics tracked:**
- **Subagent count:** Number of subagents spawned per phase (2-20)
- **Token usage:** Estimated tokens per workflow (10K-350K)
- **Time:** Estimated time per workflow (5-60 minutes)
- **File coverage:** Percentage of relevant files documented (target: >80%)
- **Pattern coverage:** Percentage of patterns captured (target: >90%)
- **Verification status:** Pass/fail status from verification phase

**Logging:**
- All research artifacts logged to `.temp/` directories (persistent)
- Plan logged to `.temp/plan.md`
- Gap check decisions logged in skill output
- Verification reports logged to `.temp/phase4-verification/`

**Alerting:**
- Gap check failures: Skill explicitly reports and halts
- Critical verification issues: Skill reports before finalization
- Missing artifacts: Skill detects and reports during gap checks

**User visibility:**
```
During execution:
  • Phase announcements ("Phase 1: Parallel Discovery")
  • Subagent spawn messages ("Spawning dependency-mapper...")
  • Gap check results ("✓ File coverage adequate")
  • Verification results ("N minor warnings documented")

After completion:
  • Completion report (files analyzed, coverage, verification status)
  • Links to main.md and metadata.json
  • Preserved .temp/ artifacts for inspection
```

---

## Dependencies

### External Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| Claude Code CLI | Latest | Execution environment, tool access (Task, Read, Grep, Glob, Bash) |
| Task tool | Built-in | Subagent delegation |
| Read/Grep/Glob tools | Built-in | Codebase analysis |
| Bash tool | Built-in | File system operations, directory creation |

### Internal Dependencies

| Component | Depends On | Reason |
|-----------|------------|--------|
| Command (`/docs`) | Skill (`codebase-documentation`) | Triggers skill invocation |
| Skill | Configs (registry.json, phase-registry.json, selection-matrix.json) | Loads workflow definitions |
| Skill | Templates (*.md) | Populates final documentation |
| Skill | Subagents (`/agents/docs/*.md`) | Delegates research tasks |
| Subagents | Project codebase files | Analyzes implementation |
| Phase 2 (Analysis) | Phase 1 (Discovery) artifacts | Reads .temp/phase1-discovery/ |
| Phase 3 (Synthesis) | Phase 1+2 artifacts | Reads all .temp/ research |
| Phase 4 (Verification) | Phase 3 (main.md) | Verifies documentation |
| Phase 5 (Finalization) | Phase 4 (verification reports) | Applies fixes, creates metadata |

---

## Future Considerations

**Planned improvements:**
1. **Interactive workflow selection** - Prompt user with workflow options and descriptions during command execution
2. **Incremental documentation updates** - Re-run specific phases (e.g., only verification) without full regeneration
3. **Custom subagent pools** - Allow users to define project-specific subagents in `.claude/agents/docs-custom/`
4. **Multi-topic documentation** - Generate documentation for multiple topics in parallel
5. **Diff-based verification** - Compare documentation with previous version to highlight changes
6. **Automated archiving** - Schedule periodic documentation regeneration to keep docs up-to-date

**Technical debt:**
- **Hard-coded phase numbers** - Phase names are plan/discovery/analysis/synthesis/verification/finalize, but also referred to as Phase 0-5 (inconsistent)
- **Template placeholder validation** - No validation that all required placeholders are filled (missing data shows as empty)
- **Error handling in subagents** - Subagents may fail silently if tools return errors (need better error propagation)
- **Gap check subjectivity** - Gap checks use qualitative criteria ("adequate coverage?") rather than quantitative thresholds
- **Config file versioning** - No versioning strategy for registry.json changes (breaking changes could affect existing workflows)

---

## Related Documentation

- [Command Interface: `/commands/docs.md`](~/.claude/commands/docs.md)
- [Orchestration Skill: `/skills/codebase-documentation/SKILL.md`](~/.claude/skills/codebase-documentation/SKILL.md)
- [Subagent Directory: `/agents/docs/`](~/.claude/agents/docs/)
- [Workflow Registry: `workflows/registry.json`](~/.claude/skills/codebase-documentation/workflows/registry.json)
- [Phase Registry: `phases/phase-registry.json`](~/.claude/skills/codebase-documentation/phases/phase-registry.json)
- [Selection Matrix: `subagents/selection-matrix.json`](~/.claude/skills/codebase-documentation/subagents/selection-matrix.json)

---

*Generated by codebase-documentation skill using architecture workflow*

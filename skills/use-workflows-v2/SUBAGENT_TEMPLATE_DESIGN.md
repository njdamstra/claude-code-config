# Subagent Prompt Template Design

## Overview

## Path Helpers (Updated 2025-11-05)

**IMPORTANT:** All subagent templates should use these path helper variables:

- `{{workspace}}` - Base workspace directory (e.g., `.temp/feature-name`)
- `{{output_dir}}` - Current phase output directory (e.g., `phase-01-discovery`)
- `{{phase_paths.<name>}}` - Full path to another phase's output (e.g., `{{phase_paths.discovery}}/codebase-scan.json`)
- `{{full_path}}` - Complete path to current deliverable file
- `{{template_path}}` - Path to subagent's prompt template

**Never use hard-coded paths** like `.temp/phase1-discovery/`. Always use the helpers above.

### Zero-Padded Phase Directories

All phase directories use zero-padded format:
- `phase-01-discovery`
- `phase-02-requirements`  
- `phase-03-design`
- etc.


Subagent prompt templates are Markdown files that define the specific task, output format, and success criteria for each specialized subagent type within each workflow. They are rendered with variables substituted and passed to Task agents.

**Location:** `subagents/{subagent-type}/{workflow}.md.tmpl`

**Example:** `subagents/codebase-scanner/new-feature.md.tmpl`

---

## Design Principles

1. **Task-focused** - Clear, specific task description
2. **Output-driven** - Explicit output format with schema
3. **Tool-aware** - Guide subagent on which Claude Code tools to use
4. **Search-strategic** - Provide concrete search patterns and approaches
5. **Quality-oriented** - Define success criteria and validation
6. **Context-aware** - Include relevant context from previous phases

---

## Template Structure

### Standard Sections

Every subagent template should include:

```markdown
# {{subagent_name}} - {{workflow_name}}

[Role description]

## Your Task

[Specific task description]

## Scope
{{scope}}

{{#previous_phase_context}}
## Context from Previous Phases
{{previous_phase_context}}
{{/previous_phase_context}}

## Output Format

Create `.temp/{{output_path}}`:

\```{{output_format}}
{{output_schema}}
\```

## Tools Available

- **Glob**: Find files by pattern
- **Grep**: Search code by regex
- **Read**: Read file contents
- **Bash**: Execute shell commands

## Search Strategy

[Specific search approach]

## Success Criteria

{{#success_criteria}}
- {{.}}
{{/success_criteria}}

{{#common_patterns}}
## Common Patterns to Look For

{{#patterns}}
- **{{name}}**: {{description}}
{{/patterns}}
{{/common_patterns}}

## Important Constraints

- Only analyze actual files (no hallucination)
- Include file paths with line numbers when relevant
- Cite specific code examples
- Note confidence level for findings
```

---

## Section Details

### Header

```markdown
# {{subagent_name}} - {{workflow_name}}

You are a specialized {{subagent_name}} analyzing the project for **{{feature_name}}** {{workflow_purpose}}.
```

**Purpose:** Establish role and context

**Variables:**
- `subagent_name` - Human-readable agent name (e.g., "Codebase Scanner")
- `workflow_name` - Workflow type (e.g., "New Feature")
- `feature_name` - Specific feature being planned (e.g., "user-dashboard")
- `workflow_purpose` - Brief purpose (e.g., "feature planning", "refactoring")

**Example:**
```markdown
# Codebase Scanner - New Feature

You are a specialized codebase scanner analyzing the project for **user-dashboard** feature planning.
```

---

### Your Task Section

```markdown
## Your Task

[1-3 paragraphs describing specific task]

Key objectives:
1. [Objective 1]
2. [Objective 2]
3. [Objective 3]
```

**Purpose:** Define what the subagent should accomplish

**Guidelines:**
- Be specific and actionable
- List 2-4 key objectives
- Reference the feature/workflow context
- Avoid vague instructions

**Example:**
```markdown
## Your Task

Scan the codebase to identify:
1. **Existing Patterns** - Reusable components, utilities, composables that could be leveraged
2. **Naming Conventions** - File, function, variable naming patterns to follow
3. **Architecture Patterns** - State management, routing, API patterns in use

Focus on patterns relevant to building **{{feature_name}}** within the existing architecture.
```

---

### Scope Section

```markdown
## Scope
{{scope}}
```

**Purpose:** Define boundaries and focus area

**Variables:**
- `scope` - User-provided or inferred scope description

**Example (rendered):**
```markdown
## Scope
Frontend dashboard component with user profile and settings sections
```

**Guidelines:**
- Keep concise (1-3 sentences)
- Reference specific areas of codebase if known
- Clarify what's in/out of scope

---

### Context Section (Conditional)

```markdown
{{#previous_phase_context}}
## Context from Previous Phases

{{previous_phase_context}}
{{/previous_phase_context}}
```

**Purpose:** Provide relevant findings from earlier phases

**When to include:**
- Requirements phase (reads discovery)
- Design phase (reads discovery + requirements)
- Solution phase (reads reproduction + root-cause)

**Example:**
```markdown
## Context from Previous Phases

Discovery phase identified:
- 12 Vue components in src/components/ using Composition API
- State management via nanostores with BaseStore pattern
- Tailwind CSS v4 for styling
- Appwrite SDK for backend integration

Build on these patterns for consistency.
```

**Guidelines:**
- Summarize key findings (3-6 bullet points)
- Reference specific technologies/patterns
- Guide towards consistency with existing code

---

### Output Format Section

```markdown
## Output Format

Create `.temp/{{output_path}}`:

\```{{output_format}}
{{output_schema}}
\```
```

**Purpose:** Define exact structure of deliverable

**Variables:**
- `output_path` - Relative path from `{{workspace}}` (e.g., "phase-01-discovery/codebase-scan.json")
- `output_format` - File format (json, markdown, yaml)
- `output_schema` - Example structure

**Example (JSON output):**
```markdown
## Output Format

Create `{{workspace}}/phase-01-discovery/codebase-scan.json`:

\```json
{
  "patterns": [
    {
      "type": "component|composable|store|utility",
      "name": "ComponentName",
      "location": "src/components/ComponentName.vue",
      "reusability": "high|medium|low",
      "reason": "Why this is reusable",
      "usage_examples": ["file1.vue:45", "file2.vue:89"]
    }
  ],
  "naming_conventions": {
    "components": "Description of component naming pattern",
    "composables": "Description of composable naming pattern",
    "stores": "Description of store naming pattern"
  },
  "architecture": {
    "state_management": "Pattern used (e.g., nanostores with BaseStore)",
    "routing": "Pattern used (e.g., Astro file-based)",
    "api_layer": "Pattern used (e.g., Appwrite SDK)"
  }
}
\```
```

**Example (Markdown output):**
```markdown
## Output Format

Create `.temp/phase2-requirements/user-stories.md`:

\```markdown
# User Stories: {{feature_name}}

## Epic
As a [user type], I want [goal] so that [benefit].

## Stories

### Story 1: [Title]
**As a** [user type]
**I want** [functionality]
**So that** [benefit]

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2

**Estimation:** [S/M/L]

---
\```
```

**Guidelines:**
- Provide complete schema/structure
- Include data types and constraints
- Show example values
- Clarify required vs. optional fields

---

### Tools Available Section

```markdown
## Tools Available

- **Glob**: Find files by pattern (e.g., `**/*.vue`, `src/components/**`)
- **Grep**: Search code by regex with file filtering
- **Read**: Read file contents
- **Bash**: Execute shell commands (ls, find, tree)
```

**Purpose:** Remind subagent of available tools

**Guidelines:**
- List all 4 core tools
- Provide usage examples for Glob (most important)
- Keep consistent across all templates

---

### Search Strategy Section

```markdown
## Search Strategy

### 1. {Stage Name}
\```bash
# {Tool usage example}
\```

{What to look for}

### 2. {Stage Name}
\```bash
# {Tool usage example}
\```

{What to do with results}

### 3. {Stage Name}
{Next steps}
```

**Purpose:** Provide concrete search approach

**Example:**
```markdown
## Search Strategy

### 1. Component Discovery
\```bash
# Find Vue components
glob "src/**/*.vue"

# Find composables
glob "src/composables/**/*.ts"

# Find stores
glob "src/stores/**/*.ts"
\```

For each file found, note its purpose and reusability potential.

### 2. Pattern Analysis
For each file:
- Read file contents with Read tool
- Identify naming patterns (PascalCase, camelCase, etc.)
- Extract reusability potential (high/medium/low)
- Note architectural patterns used

### 3. Integration Points
\```bash
# Search for import statements
grep "import.*from" --type ts -n

# Find API calls
grep "fetch\\|axios\\|appwrite" --type ts
\```

Map how components integrate with each other and external services.
```

**Guidelines:**
- Provide 2-4 stages
- Include actual command examples
- Explain what to do with results
- Be specific about search patterns

---

### Success Criteria Section

```markdown
## Success Criteria

{{#success_criteria}}
- {{.}}
{{/success_criteria}}
```

**Purpose:** Define what "done" looks like

**Example:**
```markdown
## Success Criteria

- Identified 10+ reusable patterns
- Documented 5+ naming conventions
- Mapped 3+ architecture patterns
- Found 5+ integration points
- Output is valid JSON
- All file paths are real (no hallucination)
- Includes specific line numbers for code references
```

**Guidelines:**
- Be specific and measurable
- Include quantity targets (10+, 5+, etc.)
- Cover both quantity and quality
- Include anti-hallucination checks
- 5-8 criteria typical

---

### Common Patterns Section (Optional)

```markdown
{{#common_patterns}}
## Common Patterns to Look For

{{#patterns}}
- **{{name}}**: {{description}}
{{/patterns}}
{{/common_patterns}}
```

**Purpose:** Guide subagent towards specific patterns

**Example:**
```markdown
## Common Patterns to Look For

- **Vue Components**: `.vue` files using Composition API with `<script setup>`
- **Composables**: Functions starting with `use` prefix (e.g., `useAuth`, `useFormValidation`)
- **Nanostores**: Stores extending `BaseStore` class for Appwrite integration
- **Tailwind Styling**: No scoped styles, all styling via Tailwind utility classes
- **Appwrite Integration**: Database queries using `Query.` methods
```

**Guidelines:**
- List 4-8 common patterns
- Be specific to the tech stack
- Include actual examples
- Help subagent recognize patterns faster

---

### Important Constraints Section

```markdown
## Important Constraints

- Only analyze actual files (no hallucination)
- Include file paths with line numbers when relevant
- Cite specific code examples
- Note confidence level for findings
{{#workflow_specific_constraints}}
- {{.}}
{{/workflow_specific_constraints}}
```

**Purpose:** Prevent common mistakes

**Guidelines:**
- Always include anti-hallucination constraint
- Require specific citations
- Encourage confidence levels
- Add workflow-specific constraints as needed

---

## Variable Reference

### Standard Variables (All Templates)

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `feature_name` | string | Feature being planned | "user-dashboard" |
| `workflow` | string | Workflow type | "new-feature" |
| `workflow_name` | string | Human-readable workflow | "New Feature" |
| `workflow_purpose` | string | Brief purpose | "feature planning" |
| `scope` | string | Scope description | "Frontend dashboard component" |
| `output_path` | string | Deliverable path | "phase-01-discovery/codebase-scan.json" |
| `output_format` | string | File format | "json" |

### Conditional Variables

| Variable | Type | When Present | Description |
|----------|------|--------------|-------------|
| `previous_phase_context` | string | Phase 2+ | Summary of prior findings |
| `common_patterns` | array | Tech-specific | List of patterns to find |
| `workflow_specific_constraints` | array | Workflow-specific | Additional constraints |
| `success_criteria` | array | Always | List of success criteria |

---

## Workflow-Specific Considerations

### New Feature Templates

**Focus:** Existing patterns, reusability, conventions

**Key sections:**
- Common patterns (Vue, Tailwind, nanostores)
- Integration points
- Reusability assessment

**Output:** JSON with patterns, conventions, architecture

---

### Refactoring Templates

**Focus:** Code quality, complexity, duplication

**Key sections:**
- Code smell detection
- Complexity metrics
- Duplication analysis

**Output:** JSON with smells, metrics, duplications

---

### Debugging Templates

**Focus:** Error reproduction, logs, state

**Key sections:**
- Reproduction steps
- Environment context
- Stack traces

**Output:** Markdown with reproduction guide

---

### Improving Templates

**Focus:** Performance, UX, optimization opportunities

**Key sections:**
- Baseline measurements
- Bottleneck identification
- Optimization opportunities

**Output:** JSON with metrics, bottlenecks, opportunities

---

### Quick Templates

**Focus:** Fast file location, basic patterns

**Key sections:**
- Simplified search strategy
- Minimal pattern checking
- Fast output

**Output:** JSON with file list, basic patterns

---

## Template Naming Convention

**Pattern:** `{subagent-type}/{workflow}.md.tmpl`

**Examples:**
- `codebase-scanner/new-feature.md.tmpl`
- `codebase-scanner/refactoring.md.tmpl`
- `pattern-analyzer/new-feature.md.tmpl`
- `user-story-writer/new-feature.md.tmpl`
- `bug-reproducer/debugging.md.tmpl`

**Guidelines:**
- Use lowercase-with-dashes for subagent types
- Use workflow name exactly as in workflow YAML
- Always use `.md.tmpl` extension

---

## Template Reuse Strategy

### Shared Templates

Some subagents are used across multiple workflows with minimal changes:

**Candidates for reuse:**
- `codebase-scanner` (new-feature, refactoring, quick)
- `pattern-analyzer` (new-feature, refactoring)
- `dependency-mapper` (new-feature, refactoring)

**Approach:** Create base template, extend with workflow-specific sections

---

### Workflow-Specific Templates

Some subagents are unique to one workflow:

**Examples:**
- `user-story-writer` → new-feature only
- `bug-reproducer` → debugging only
- `refactoring-sequencer` → refactoring only
- `optimization-designer` → improving only

**Approach:** Create dedicated template with workflow-specific focus

---

## Complete Example Templates

### 1. codebase-scanner/new-feature.md.tmpl

```markdown
# Codebase Scanner - New Feature

You are a specialized codebase scanner analyzing the project for **{{feature_name}}** feature planning.

## Your Task

Scan the codebase to identify:
1. **Existing Patterns** - Reusable components, utilities, composables
2. **Naming Conventions** - File, function, variable naming patterns
3. **Architecture Patterns** - State management, routing, API patterns

## Scope
{{scope}}

## Output Format

Create `.temp/{{output_path}}`:

\```json
{
  "patterns": [
    {
      "type": "component|composable|store|utility",
      "name": "ComponentName",
      "location": "src/components/ComponentName.vue",
      "reusability": "high|medium|low",
      "reason": "Why this is reusable",
      "usage_examples": ["file1.vue:45", "file2.vue:89"]
    }
  ],
  "naming_conventions": {
    "components": "Description",
    "composables": "Description",
    "stores": "Description"
  },
  "architecture": {
    "state_management": "Pattern used",
    "routing": "Pattern used",
    "api_layer": "Pattern used"
  },
  "integration_points": [
    {
      "type": "API|Database|External Service",
      "location": "file.ts:123",
      "description": "What integrates with what"
    }
  ]
}
\```

## Tools Available

- **Glob**: Find files by pattern (e.g., `**/*.vue`)
- **Grep**: Search code by regex
- **Read**: Read file contents
- **Bash**: Execute shell commands

## Search Strategy

### 1. Component Discovery
\```bash
glob "src/**/*.vue"
glob "src/composables/**/*.ts"
glob "src/stores/**/*.ts"
\```

### 2. Pattern Analysis
For each file:
- Read contents
- Identify reusability (high/medium/low)
- Extract naming patterns
- Note architectural patterns

### 3. Integration Points
\```bash
grep "import.*from" --type ts -n
grep "fetch\\|axios\\|appwrite" --type ts
\```

## Success Criteria

- Identified 10+ reusable patterns
- Documented 5+ naming conventions
- Mapped 3+ architecture patterns
- Found 5+ integration points
- Output is valid JSON
- All file paths are real (no hallucination)

## Common Patterns to Look For

- **Vue Components**: `.vue` files with `<script setup lang="ts">`
- **Composables**: Functions with `use` prefix
- **Nanostores**: Classes extending `BaseStore`
- **Tailwind**: Utility classes, no scoped styles

## Important Constraints

- Only analyze actual files
- Include line numbers
- Cite specific examples
- Note confidence level
```

### 2. pattern-analyzer/new-feature.md.tmpl

```markdown
# Pattern Analyzer - New Feature

You are a specialized pattern analyzer identifying architectural patterns for **{{feature_name}}** feature planning.

## Your Task

Analyze the codebase to extract:
1. **Component composition patterns** - How components are structured and composed
2. **State management patterns** - How state flows through the application
3. **API integration patterns** - How external services are accessed
4. **Styling patterns** - How styling is applied

## Scope
{{scope}}

## Context from Previous Phases

Discovery phase identified these files:
[Read from codebase-scan.json]

## Output Format

Create `.temp/{{output_path}}`:

\```json
{
  "component_patterns": [
    {
      "pattern_name": "Modal with Teleport",
      "description": "Modals use Teleport to #modals div",
      "examples": ["Modal.vue:15", "ConfirmDialog.vue:20"],
      "frequency": "common|occasional|rare"
    }
  ],
  "state_patterns": [
    {
      "pattern_name": "BaseStore CRUD",
      "description": "Stores extend BaseStore for Appwrite",
      "examples": ["UserStore.ts:10"],
      "when_to_use": "For Appwrite collections"
    }
  ],
  "api_patterns": [
    {
      "pattern_name": "Appwrite Query Builder",
      "description": "Use Query.* methods for filtering",
      "examples": ["users.ts:45"],
      "best_practices": ["Always use Query.limit()", "Check permissions"]
    }
  ],
  "styling_patterns": [
    {
      "pattern_name": "Dark mode with dark: prefix",
      "description": "All dark mode via Tailwind dark: utilities",
      "examples": ["Button.vue:30"],
      "conventions": ["No custom dark mode logic", "Always provide dark variant"]
    }
  ]
}
\```

## Search Strategy

### 1. Read Discovery Output
\```bash
cat `{{workspace}}/phase-01-discovery/codebase-scan.json`
\```

Extract file locations for detailed analysis.

### 2. Analyze Component Patterns
Read identified component files and extract:
- Composition patterns (slots, props, emits)
- Common component structures
- Reusable patterns

### 3. Analyze State Patterns
Read store files and extract:
- State management approach
- Data flow patterns
- Best practices

### 4. Analyze API Patterns
\```bash
grep -n "Query\\." --type ts
grep -n "appwrite" --type ts
\```

Extract API integration patterns.

## Success Criteria

- Identified 8+ component patterns
- Identified 4+ state patterns
- Identified 3+ API patterns
- Identified 3+ styling patterns
- All patterns have examples with line numbers
- Patterns are categorized by frequency/use case

## Important Constraints

- Build on discovery findings
- All examples must reference real files
- Include when-to-use guidance
- Note best practices for each pattern
```

### 3. user-story-writer/new-feature.md.tmpl

```markdown
# User Story Writer - New Feature

You are a requirements specialist writing user stories for **{{feature_name}}**.

## Your Task

Based on discovery findings, write user stories following INVEST criteria:
- **I**ndependent
- **N**egotiable
- **V**aluable
- **E**stimable
- **S**mall
- **T**estable

## Scope
{{scope}}

## Context from Previous Phases

Read these files to understand the feature context:
- `{{phase_paths.discovery}}/codebase-scan.json` - Existing patterns
- `{{phase_paths.discovery}}/patterns.json` - Architecture patterns

## Output Format

Create `.temp/{{output_path}}`:

\```markdown
# User Stories: {{feature_name}}

## Epic
As a [user type], I want [goal] so that [benefit].

## Stories

### Story 1: [Title]
**As a** [user type]
**I want** [functionality]
**So that** [benefit]

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Technical Notes:**
- Reuses: [component from discovery]
- Integrates with: [system from discovery]

**Estimation:** [S/M/L based on complexity]

---

### Story 2: [Title]
[...]

## INVEST Check

For each story:
- [ ] Independent from other stories
- [ ] Negotiable scope
- [ ] Provides user value
- [ ] Can be estimated
- [ ] Small enough for one iteration
- [ ] Has testable acceptance criteria
\```

## Search Strategy

### 1. Understand Context
Read discovery phase outputs to understand:
- Existing components to reuse
- Technical constraints
- Integration points

### 2. Identify User Goals
Based on scope, identify:
- Primary user personas
- Core user goals
- Value propositions

### 3. Write Stories
For each user goal:
- Write story in standard format
- Define 3-5 acceptance criteria
- Add technical notes referencing discovery
- Estimate size (S/M/L)

### 4. Verify INVEST
Check each story against INVEST criteria.

## Success Criteria

- 3-8 user stories (right-sized)
- All stories follow INVEST criteria
- Acceptance criteria are specific and testable
- Technical notes reference discovery findings
- Estimation based on codebase complexity
- Stories are independent (can be developed in any order)

## Important Constraints

- Stories must provide user value (not technical tasks)
- Acceptance criteria must be verifiable
- Technical notes must reference actual files from discovery
- Estimation must consider existing patterns and complexity
```

---

## Next Steps

1. Create subagent directory structure:
   ```
   subagents/
   ├── codebase-scanner/
   ├── pattern-analyzer/
   ├── user-story-writer/
   └── [others]/
   ```

2. Create 3 example templates (above)

3. Create subagent registry mapping subagents to Task agent types

4. Document template rendering process in generator script design

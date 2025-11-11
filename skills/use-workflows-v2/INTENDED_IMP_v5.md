# Workflow System v5 - Phase-Centric Architecture

## Nate's follow up:
* shouldn't workflow config determine base directory? ex: base = '.claude/plans/' and then the + [feature-name]/ and then the phase folders in this.

## Core Principle

**Phases are self-contained, reusable modules.** Workflows coordinate phases without knowing their internals.

## Architecture

### Phase YAML Files (e.g., `phases/discovery.yaml`)

Phases own ALL their behavior:

```yaml
name: discovery
purpose: "Scan codebase for patterns, dependencies, and reusable components"

# Subagent matrix - which agents run under what conditions
subagents:
  always:
    - file-locator
    - pattern-checker
  conditional:
    frontend:
      - component-scanner
    backend:
      - api-scanner
    both:
      - integration-mapper

# Subagent configurations (replaces prompt templates)
subagent_configs:
  file-locator:
    task_agent_type: "file-locator"
    responsibility: "Locate all relevant files for the feature scope"
    outputs:
      - file: files.json
        schema: output_templates/files.json.tmpl
        required: true
    scope_specific:
      frontend: "Focus on .vue, .ts composables, stores"
      backend: "Focus on Appwrite functions, API routes"
      both: "Focus on full-stack integration files"

  pattern-checker:
    task_agent_type: "pattern-checker"
    responsibility: "Identify architectural patterns and conventions"
    outputs:
      - file: patterns.json
        schema: output_templates/patterns.json.tmpl
        required: true
    scope_specific:
      frontend: "Vue component patterns, composable patterns, Tailwind patterns"
      backend: "Database schemas, auth patterns, API patterns"

# Gap checks - validation criteria
gap_checks:
  criteria:
    - "At least 5 files identified"
    - "At least 3 patterns documented"
    - "All file paths verified to exist"
  on_failure:
    - "Retry with broader search"
    - "Continue with current findings"
    - "Abort workflow"

# What this phase produces for other phases to consume
provides:
  - files_list
  - patterns_identified
  - conventions_documented
```

### Workflow YAML Files (e.g., `workflows/investigation-workflow.yaml`)

Workflows coordinate phases, supply inputs, define scope and checkpoints:

```yaml
name: investigation-workflow
description: "Balanced investigation with codebase + external research"
estimated_time: 20-40 minutes
estimated_tokens: 20K-60K

# Phase sequence with coordination
phases:
  - name: problem-understanding
    scope: default
    inputs: []  # No inputs, first phase

  - name: discovery
    scope: "{{workflow_scope}}"  # Use workflow-level scope
    inputs:
      - from: problem-understanding
        files:
          - problem.md
          - constraints.json
        context_description: "Problem statement and constraints to focus discovery"

  - name: external-research
    scope: default
    inputs:
      - from: problem-understanding
        files: [problem.md]
      - from: discovery
        files: [patterns.json]
        context_description: "Codebase patterns to compare against best practices"

  - name: synthesis
    scope: default
    inputs:
      - from: discovery
        files: [patterns.json, files.json]
      - from: external-research
        files: [best-practices.md]
        context_description: "All research findings for solution generation"

# Checkpoints - user approval gates
checkpoints:
  - after: problem-understanding
    prompt: "Confirm problem understanding before research"
    show_files: []
    options:
      - "Proceed to research"
      - "Refine problem statement"
      - "Abort"

  - after: synthesis
    prompt: "Review synthesized approaches"
    show_files:
      - "{{workspace}}/synthesis/approaches.json"
    options:
      - "Continue to planning"
      - "Refine approaches"
      - "Abort"

# Workflow-level scope (can be overridden per-phase)
default_scope: "{{user_provided_scope}}"  # --frontend, --backend, --both
```

## Benefits

### Phases Are Reusable Black Boxes
- "discovery" phase works the same in ANY workflow
- Phase owns its subagents, outputs, validation
- Different workflows can use same phases with different inputs

### Workflow YAML Is Clean Coordination
- Lists phase sequence
- Connects phases via inputs
- No knowledge of subagents or deliverables
- Just scope + checkpoints + phase wiring

### No Prompt Templates
- Subagent configs in phase YAML have `responsibility` field
- System generates prompts from:
  - `responsibility` description
  - `scope_specific` guidance for current scope
  - `outputs[].schema` for expected format
  - `inputs[]` context files to read
  - All template variables (feature_name, etc.)

### Phases Define Their Own Validation
- Gap checks live with the phase that produces outputs
- Phase knows what quality criteria matter for ITS outputs
- Workflows don't need to know validation details

### Clear Interfaces
```
Phase Interface:
  Input: scope + context files from previous phases
  Output: deliverable files in output_dir
  Validation: internal gap checks
  Contract: provides[] declares what data is available for next phases
```

## File Structure

```
skills/use-workflows-v2/
├── workflows/
│   ├── investigation-workflow.yaml      # Coordinates phases
│   ├── new-feature-plan.yaml
│   └── debugging-plan.yaml
├── phases/
│   ├── problem-understanding.yaml       # Self-contained phase
│   ├── discovery.yaml
│   ├── requirements.yaml
│   ├── external-research.yaml
│   └── synthesis.yaml
├── output_templates/
│   ├── files.json.tmpl
│   ├── patterns.json.tmpl
│   └── codebase-analysis.json.tmpl
└── lib/
    └── phase-executor.md.tmpl          # ONE generic executor
```

## Execution Flow

1. User runs: `generate-workflow-instructions.sh investigation-workflow user-auth --frontend`
2. System loads `workflows/investigation-workflow.yaml`
3. For each phase in sequence:
   - Load phase YAML (e.g., `phases/discovery.yaml`)
   - Resolve subagents using phase's subagent_matrix + workflow's scope
   - Build prompt from phase's subagent_configs
   - Pass inputs specified in workflow YAML
   - Execute with generic phase-executor template
   - Validate with phase's gap_checks
   - Check for workflow's checkpoint

## Implementation Order

1. **Phase 1:** Create phase YAML structure, move subagent configs from templates to phase YAMLs
2. **Phase 2:** Move subagent_matrix and gap_checks from workflow YAMLs to phase YAMLs
3. **Phase 3:** Simplify workflow YAMLs to just phase sequence + inputs + checkpoints + scope
4. **Phase 4:** Create generic phase executor that reads phase YAML + workflow inputs
5. **Phase 5:** Add workflow composition (import phases, reuse sequences)

## Result

- **Phase YAMLs** = Reusable modules with internal logic, subagents, validation
- **Workflow YAMLs** = Phase coordination, input wiring, checkpoints
- **No prompt templates** = Generated from phase configs
- **One executor** = Generic template reads phase + workflow data
- **Clean separation** = Phases are black boxes, workflows compose them

---

# Before & After Comparison

## CURRENT SYSTEM (v4)

### Current: investigation-workflow.yaml

```yaml
name: investigation-workflow
description: Balanced investigation with codebase + external research and user checkpoints
estimated_time: 20-40 minutes
estimated_tokens: 20K-60K
complexity: moderate

phases:
  - problem-understanding
  - codebase-investigation
  - external-research
  - solution-synthesis
  - introspection
  - approach-refinement

subagent_matrix:
  problem-understanding:
    always: []  # Main agent conversation
    conditional: {}

  codebase-investigation:
    always:
      - code-researcher
    conditional: {}

  external-research:
    always: []  # Main agent uses external-research skill
    conditional: {}

  solution-synthesis:
    always: []  # Main agent synthesizes findings
    conditional: {}

  introspection:
    always:
      - code-qa
    conditional: {}

  approach-refinement:
    always: []
    conditional:
      complex:
        - architecture-specialist

subagent_outputs:
  codebase-investigation:
    code-researcher: codebase-analysis.json
  introspection:
    code-qa: assumptions-validated.json
  approach-refinement:
    architecture-specialist: refined-approach.md

gap_checks:
  problem-understanding:
    criteria:
      - "Problem is clearly defined"
      - "Success criteria are documented"
      - "Constraints are understood"
      - "User has confirmed understanding"
    on_failure:
      - "Refine problem statement"
      - "Continue anyway"
      - "Abort workflow"

  codebase-investigation:
    criteria:
      - "At least 5 patterns identified"
      - "Dependencies mapped"
      - "Integration points documented"
      - "All file paths are real (no hallucination)"
    on_failure:
      - "Retry codebase investigation with refined scope"
      - "Continue with current findings"
      - "Abort workflow"

  external-research:
    criteria:
      - "Best practices documented"
      - "Framework patterns identified"
      - "At least 2 external sources consulted"
      - "Research findings are relevant"
    on_failure:
      - "Do additional research"
      - "Continue with current findings"
      - "Abort workflow"

  solution-synthesis:
    criteria:
      - "2-3 approaches presented"
      - "Each approach has pros and cons"
      - "Risk assessment included"
      - "Complexity rating provided"
    on_failure:
      - "Generate additional approaches"
      - "Continue with current approaches"
      - "Abort workflow"

  introspection:
    criteria:
      - "All assumptions explicitly identified"
      - "code-qa answered all questions with file:line citations"
      - "Confidence ratings provided (High/Medium/Low)"
      - "At least one assumption validated or invalidated"
      - "Reusable code identified where assumptions were wrong"
    on_failure:
      - "Retry introspection with more questions"
      - "Continue with original approaches"
      - "Abort workflow"

  approach-refinement:
    criteria:
      - "Specific files identified for chosen approach"
      - "Technical challenges listed"
      - "Validation strategy defined"
    on_failure:
      - "Add more detail to refinement"
      - "Continue with current level"
      - "Abort workflow"

checkpoints:
  - after: problem-understanding
    prompt: "Confirm problem understanding before starting research"
    show_files: []
    options:
      - "Proceed to research"
      - "Refine problem statement"
      - "Abort"

  - after: introspection
    prompt: "Review assumption validation and revised approaches"
    show_files:
      - "{{output_dir}}/approaches.json"
      - "{{output_dir}}/phase-introspection/assumptions.json"
      - "{{output_dir}}/approaches-revised.json"
    options:
      - "Continue with revised approach"
      - "Need more introspection"
      - "Revert to original approaches"
      - "Abort"

  - after: approach-refinement
    prompt: "Review refined approach before moving to detailed planning"
    show_files:
      - "{{output_dir}}/refined-approach.md"
    options:
      - "Continue to plan-writing-workflow"
      - "Refine further"
      - "Abort"

template: templates/investigation-workflow.md.tmpl
```

### Current: phases/introspection.md (with mustache variables annotated)

```markdown
# Phase: Introspection

## Overview

Validate assumptions made during previous phases by identifying implicit assumptions and using code-qa agent to answer detailed questions about the codebase.

## Step 1: Identify Assumptions

**Main agent task:** Review the approaches generated in the previous phase and explicitly list all assumptions made.

Common assumptions to check:
- "No existing solution for this problem"
- "Feature X doesn't exist in the codebase"
- "We need to build component Y from scratch"
- "Pattern Z isn't being used anywhere"
- "Integration with system A hasn't been done before"

**Output your assumption analysis:**

[... markdown template ...]

## Step 2: Spawn code-qa Subagent

{{#subagents}}:(loops through [code-qa])
### {{index}}:(1). {{name}}:(code-qa)

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}:(code-qa)"
- `description`: "{{task_description}}:(Answer detailed questions about codebase with source verification and confidence ratings)"

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}:(code-qa)",
  description="Answer detailed questions about codebase to validate assumptions for {{feature_name}}:(user-auth)",
  prompt="Answer the following questions about the codebase with maximum accuracy and source verification:

[LIST YOUR ASSUMPTION QUESTIONS HERE - from Step 1 analysis]

For each question:
1. Search exhaustively for relevant code
2. Provide file:line citations for all claims
3. Rate confidence (High/Medium/Low)
4. Note if assumption is CONFIRMED or INVALIDATED

Output to {{workspace}}:(.temp/user-auth-investigation)/{{output_dir}}:(phase-5-introspection)/{{deliverable_filename}}:(assumptions-validated.json)"
)
```

**Expected Output:** `{{workspace}}:(.temp/user-auth-investigation)/{{output_dir}}:(phase-5-introspection)/{{deliverable_filename}}:(assumptions-validated.json)`

---
{{/subagents}}

## Step 3: Wait for Completion

All {{subagent_count}}:(1) agents must complete before proceeding.

Monitor Task tool status. Once all agents finish executing, verify expected output files exist.

## Step 4: Read and Review Outputs

Read all deliverables from `{{workspace}}:(.temp/user-auth-investigation)/{{output_dir}}:(phase-5-introspection)/`:

{{#deliverables}}:(loops through [{filename: "assumptions-validated.json", ...}])
### {{filename}}:(assumptions-validated.json)

**Path:** `{{full_path}}:(.temp/user-auth-investigation/phase-5-introspection/assumptions-validated.json)`

**Purpose:** {{description}}:(Answer detailed questions about codebase with source verification and confidence ratings)

**Validation:**
{{#validation_checks}}:(loops through ["File exists", "File is valid format", ...])
- {{.}}:(File exists)
{{/validation_checks}}

{{#has_template}}:(true)
**Output Template:**
```{{template_extension}}:(json)
{{template_content}}:({
  "questions_answered": [...],
  "assumptions_confirmed": [...],
  "assumptions_invalidated": [...],
  "gaps_in_understanding": [...]
})
```
{{/has_template}}

Use Read tool to examine file and verify criteria above.

**Expected content:**
- **questions**: Array of questions asked
- **answers**: Detailed answers with file:line citations
- **confidence**: Rating for each answer (High/Medium/Low)
- **assumptions_validated**: Which assumptions were CONFIRMED
- **assumptions_invalidated**: Which assumptions were WRONG
- **revised_understanding**: How this changes our approaches

{{/deliverables}}

## Step 5: Revise Approaches Based on Findings

**Main agent task:** Update approaches.json based on introspection findings.

[... rest of template ...]

## Step 6: Gap Check

Verify the following criteria:

{{#gap_criteria}}:(loops through ["All assumptions explicitly identified", ...])
- [ ] {{.}}:(All assumptions explicitly identified)
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

```
Introspection complete with gaps:

[List specific unmet criteria]

What would you like to do?
{{#gap_options}}:(loops through [{index: 1, value: "Retry..."}, ...])
{{index}}:(1). {{value}}:(Retry introspection with more questions)
{{/gap_options}}
```

**Wait for user selection** before proceeding.

[...]

{{#checkpoint}}:(true, checkpoint exists)
## Step 7: Checkpoint Review

**Present to user:**

{{checkpoint_prompt}}:(Review assumption validation and revised approaches)

**Files for review:**
{{#checkpoint_show_files}}:(loops through file paths)
- `{{.}}:(.temp/user-auth-investigation/approaches.json)`
{{/checkpoint_show_files}}

**Ask user:**

What would you like to do next?
{{#checkpoint_options}}:(loops through options)
{{index}}:(1). {{value}}:(Continue with revised approach)
{{/checkpoint_options}}

**Wait for user selection** before proceeding.
{{/checkpoint}}

{{^checkpoint}}:(would render if checkpoint was null/false)
## Step 7: Proceed to Next Phase

Introspection complete. No checkpoint defined.

Continue with revised approaches based on validated assumptions.
{{/^checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}
- `{{workspace}}/{{output_dir}}/approaches-revised.json` - Updated approaches based on introspection

## Success Criteria

- ✓ All assumptions explicitly identified
- ✓ code-qa agent answered all questions with citations
- ✓ Confidence ratings provided for all answers
- ✓ Approaches revised based on findings
- ✓ Reusable code leveraged where discovered
```

### Current: subagents/code-qa/investigation-workflow.md.tmpl

```markdown
# Task Context for code-qa

You are validating assumptions for the **{{feature_name}}** investigation.

**Workflow:** investigation-workflow (introspection phase)
**Scope:** {{scope}}

## Your Task

The main agent has made assumptions during its investigation. Your job is to answer detailed questions about the codebase to validate or invalidate those assumptions.

**Critical Requirements:**
1. Search exhaustively - use multiple search strategies
2. Provide file:line citations for ALL claims
3. Rate confidence for each answer (High/Medium/Low)
4. NEVER guess or hallucinate - if you can't find something, say so explicitly

## Input Context

Read the approaches from the previous phase:
- `.temp/{{feature_name}}-investigation/approaches.json` - Proposed approaches with embedded assumptions

The main agent will provide specific questions to answer in the Task prompt.

## Output Deliverable

Write your findings to: `.temp/{{output_dir}}/assumptions.json`

### Expected Format

```json
{
  "questions_answered": [...],
  "assumptions_confirmed": [...],
  "assumptions_invalidated": [...],
  "gaps_in_understanding": [...]
}
```

[... extensive prompt with search strategies, scope-specific guidance, etc ...]
```

---

## NEW SYSTEM (v5)

### New: workflows/investigation-workflow.yaml

```yaml
name: investigation-workflow
description: "Balanced investigation with codebase + external research"
estimated_time: 20-40 minutes
estimated_tokens: 20K-60K

# Base directory for all workflow outputs
base_dir: ".temp"  # Creates .temp/[feature-name]/

# Phase sequence with input wiring
phases:
  - name: problem-understanding
    scope: default
    inputs: []

  - name: codebase-investigation
    scope: "{{workflow_scope}}"
    inputs:
      - from: problem-understanding
        files: [problem.md, constraints.json]
        context_description: "Problem definition to focus research"

  - name: external-research
    scope: default
    inputs:
      - from: problem-understanding
        files: [problem.md]
      - from: codebase-investigation
        files: [codebase-analysis.json]

  - name: solution-synthesis
    scope: default
    inputs:
      - from: codebase-investigation
        files: [codebase-analysis.json]
      - from: external-research
        files: [best-practices.md]

  - name: introspection
    scope: default
    inputs:
      - from: solution-synthesis
        files: [approaches.json]
        context_description: "Approaches to validate assumptions against"

  - name: approach-refinement
    scope: default
    inputs:
      - from: introspection
        files: [assumptions-validated.json, approaches-revised.json]

# Checkpoints - user approval gates
checkpoints:
  - after: problem-understanding
    prompt: "Confirm problem understanding before starting research"
    show_files: []
    options:
      - "Proceed to research"
      - "Refine problem statement"
      - "Abort"

  - after: introspection
    prompt: "Review assumption validation and revised approaches"
    show_files:
      - "approaches.json"
      - "assumptions-validated.json"
      - "approaches-revised.json"
    options:
      - "Continue with revised approach"
      - "Need more introspection"
      - "Revert to original approaches"
      - "Abort"

  - after: approach-refinement
    prompt: "Review refined approach before moving to detailed planning"
    show_files:
      - "refined-approach.md"
    options:
      - "Continue to plan-writing-workflow"
      - "Refine further"
      - "Abort"
```

**Key Changes:**
- ❌ No `subagent_matrix` (moved to phase YAMLs)
- ❌ No `subagent_outputs` (moved to phase YAMLs)
- ❌ No `gap_checks` (moved to phase YAMLs)
- ✅ Added `base_dir` configuration
- ✅ Clean phase sequence with input wiring
- ✅ Checkpoints reference files by name (not full paths)

### New: phases/introspection.yaml

```yaml
name: introspection
purpose: "Validate assumptions by questioning codebase with code-qa agent"

# Subagent matrix - who runs when
subagents:
  always:
    - code-qa
  conditional: {}

# Subagent configurations (replaces prompt templates)
subagent_configs:
  code-qa:
    task_agent_type: "code-qa"
    responsibility: |
      Answer detailed questions about the codebase to validate assumptions made during investigation.

      CRITICAL: Search exhaustively, provide file:line citations for ALL claims, rate confidence,
      and clearly distinguish between "not found" vs "doesn't exist".

    inputs_to_read:
      - from_workflow: true  # Read files passed by workflow
        description: "approaches.json with embedded assumptions to validate"

    outputs:
      - file: assumptions-validated.json
        schema: output_templates/assumptions-validated.json.tmpl
        required: true
        description: "Detailed answers with evidence and confidence ratings"

    instructions: |
      1. The main agent will list specific assumption questions in the Task prompt
      2. For each question:
         - Search using multiple strategies (keyword, pattern, dependency tracing)
         - Provide file:line citations for all claims
         - Rate confidence (High/Medium/Low)
         - Note if assumption is CONFIRMED or INVALIDATED
      3. For invalidated assumptions, assess reusability of found code
      4. Document search strategies used for transparency

    scope_specific:
      frontend: |
        Search locations: src/components/, src/composables/, src/stores/, src/utils/
        Look for: Vue components, Tailwind patterns, Nanostore usage
      backend: |
        Search locations: functions/, database schemas, API routes
        Look for: Appwrite patterns, auth flows, data transformations
      both: |
        Trace: Frontend-to-backend data flow, API contracts, SSR patterns

# Gap checks - validation criteria
gap_checks:
  criteria:
    - "All assumptions explicitly identified"
    - "code-qa answered all questions with file:line citations"
    - "Confidence ratings provided (High/Medium/Low)"
    - "At least one assumption validated or invalidated"
    - "Reusable code identified where assumptions were wrong"
  on_failure:
    - "Retry introspection with more questions"
    - "Continue with original approaches"
    - "Abort workflow"

# What this phase produces
provides:
  - assumptions_validated
  - assumptions_invalidated
  - reusable_code_found
  - revised_approaches

# Phase-specific execution notes
execution_notes: |
  Main agent responsibilities:
  1. Review approaches.json and identify all implicit assumptions
  2. Formulate specific questions for code-qa
  3. After code-qa completes, revise approaches based on findings
  4. Output updated approaches-revised.json
```

**Key Changes:**
- ❌ No separate prompt template file
- ✅ `responsibility` field describes what subagent does
- ✅ `instructions` provides step-by-step guidance
- ✅ `scope_specific` gives contextual hints
- ✅ `inputs_to_read` references workflow-provided files
- ✅ Phase owns gap checks
- ✅ `execution_notes` guide main agent behavior

### New: lib/phase-executor.md.tmpl (Generic Template)

```markdown
# Phase {{phase_number}}: {{phase_name}}

## Purpose

{{phase.purpose}}

## Context Files Available

{{#phase.inputs}}
From phase "{{from}}":
{{#files}}
- `{{workspace}}/{{from_output_dir}}/{{.}}`
{{/files}}
Context: {{context_description}}
{{/phase.inputs}}

{{^phase.inputs}}
No input files from previous phases.
{{/phase.inputs}}

---

## Execution Instructions

### Main Agent Responsibilities

{{phase.execution_notes}}

### Subagents to Spawn

{{#phase.subagents}}
#### {{index}}. {{name}}

**Task Configuration:**
- Agent Type: `{{task_agent_type}}`
- Responsibility: {{responsibility}}

**Inputs to Read:**
{{#inputs_to_read}}
{{#from_workflow}}
- Files provided by workflow (see Context Files Available above)
{{/from_workflow}}
{{/inputs_to_read}}

**Scope-Specific Guidance:**
{{scope_specific[current_scope]}}

**Instructions:**
{{instructions}}

**Expected Output:**
{{#outputs}}
- File: `{{workspace}}/{{output_dir}}/{{file}}`
- Schema: `{{schema}}`
{{/outputs}}

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{responsibility}}",
  prompt="[AUTO-GENERATED PROMPT]

Context Files:
{{#phase.inputs}}
{{#files}}
- Read: {{workspace}}/{{from_output_dir}}/{{.}}
{{/files}}
{{/phase.inputs}}

Your Task:
{{responsibility}}

{{instructions}}

Scope-Specific Focus:
{{scope_specific[current_scope]}}

Expected Output Format:
[EMBED SCHEMA FROM {{schema}}]

Output Location: {{workspace}}/{{output_dir}}/{{file}}
"
)
```

---
{{/phase.subagents}}

{{^phase.subagents}}
No subagents configured for this phase. Main agent handles all work.
{{/phase.subagents}}

### Wait for Completion

{{#phase.subagents}}
Wait for all {{subagent_count}} subagents to complete.
{{/phase.subagents}}

### Read and Validate Outputs

{{#phase.subagents}}
{{#outputs}}
Read `{{workspace}}/{{output_dir}}/{{file}}` and verify:
- File exists and is valid {{extension}} format
- Matches expected schema
- Contains required data
{{/outputs}}
{{/phase.subagents}}

---

## Gap Check

Verify the following criteria:

{{#phase.gap_checks.criteria}}
- [ ] {{.}}
{{/phase.gap_checks.criteria}}

### If Gaps Found

Present to user:

```
{{phase_name}} phase completed with gaps:

[List unmet criteria]

What would you like to do?
{{#phase.gap_checks.on_failure}}
{{@index}}. {{.}}
{{/phase.gap_checks.on_failure}}
```

Wait for user selection before proceeding.

---

{{#checkpoint}}
## Checkpoint Review

**User Approval Required:**

{{checkpoint.prompt}}

**Files to Review:**
{{#checkpoint.show_files}}
- `{{workspace}}/{{output_dir}}/{{.}}`
{{/checkpoint.show_files}}

**Options:**
{{#checkpoint.options}}
{{@index}}. {{.}}
{{/checkpoint.options}}

Wait for user selection.
{{/checkpoint}}

{{^checkpoint}}
## Proceed to Next Phase

No checkpoint defined. Continue to next phase.
{{/checkpoint}}

---

## Phase Complete

**Deliverables:**
{{#phase.subagents}}
{{#outputs}}
- `{{workspace}}/{{output_dir}}/{{file}}` - {{description}}
{{/outputs}}
{{/phase.subagents}}

**Provides for Next Phases:**
{{#phase.provides}}
- {{.}}
{{/phase.provides}}
```

### Example: Rendered Output for Introspection Phase

When executing: `fetch-phase-details.sh investigation-workflow introspection user-auth --frontend`

**Rendered Output:**

```markdown
# Phase 5: introspection

## Purpose

Validate assumptions by questioning codebase with code-qa agent

## Context Files Available

From phase "solution-synthesis":
- `.temp/user-auth-investigation/phase-4-solution-synthesis/approaches.json`

Context: Approaches to validate assumptions against

---

## Execution Instructions

### Main Agent Responsibilities

Main agent responsibilities:
1. Review approaches.json and identify all implicit assumptions
2. Formulate specific questions for code-qa
3. After code-qa completes, revise approaches based on findings
4. Output updated approaches-revised.json

### Subagents to Spawn

#### 1. code-qa

**Task Configuration:**
- Agent Type: `code-qa`
- Responsibility: Answer detailed questions about the codebase to validate assumptions made during investigation.

CRITICAL: Search exhaustively, provide file:line citations for ALL claims, rate confidence,
and clearly distinguish between "not found" vs "doesn't exist".

**Inputs to Read:**
- Files provided by workflow (see Context Files Available above)

**Scope-Specific Guidance:**
Search locations: src/components/, src/composables/, src/stores/, src/utils/
Look for: Vue components, Tailwind patterns, Nanostore usage

**Instructions:**
1. The main agent will list specific assumption questions in the Task prompt
2. For each question:
   - Search using multiple strategies (keyword, pattern, dependency tracing)
   - Provide file:line citations for all claims
   - Rate confidence (High/Medium/Low)
   - Note if assumption is CONFIRMED or INVALIDATED
3. For invalidated assumptions, assess reusability of found code
4. Document search strategies used for transparency

**Expected Output:**
- File: `.temp/user-auth-investigation/phase-5-introspection/assumptions-validated.json`
- Schema: `output_templates/assumptions-validated.json.tmpl`

**Task Tool Invocation:**
```
Task(
  subagent_type="code-qa",
  description="Answer detailed questions about the codebase to validate assumptions made during investigation...",
  prompt="[AUTO-GENERATED PROMPT]

Context Files:
- Read: .temp/user-auth-investigation/phase-4-solution-synthesis/approaches.json

Your Task:
Answer detailed questions about the codebase to validate assumptions made during investigation.

CRITICAL: Search exhaustively, provide file:line citations for ALL claims, rate confidence,
and clearly distinguish between "not found" vs "doesn't exist".

1. The main agent will list specific assumption questions in the Task prompt
2. For each question:
   - Search using multiple strategies (keyword, pattern, dependency tracing)
   - Provide file:line citations for all claims
   - Rate confidence (High/Medium/Low)
   - Note if assumption is CONFIRMED or INVALIDATED
3. For invalidated assumptions, assess reusability of found code
4. Document search strategies used for transparency

Scope-Specific Focus:
Search locations: src/components/, src/composables/, src/stores/, src/utils/
Look for: Vue components, Tailwind patterns, Nanostore usage

Expected Output Format:
{
  \"questions_answered\": [...],
  \"assumptions_confirmed\": [...],
  \"assumptions_invalidated\": [...],
  \"gaps_in_understanding\": [...]
}

Output Location: .temp/user-auth-investigation/phase-5-introspection/assumptions-validated.json
"
)
```

---

### Wait for Completion

Wait for all 1 subagents to complete.

### Read and Validate Outputs

Read `.temp/user-auth-investigation/phase-5-introspection/assumptions-validated.json` and verify:
- File exists and is valid json format
- Matches expected schema
- Contains required data

---

## Gap Check

Verify the following criteria:

- [ ] All assumptions explicitly identified
- [ ] code-qa answered all questions with file:line citations
- [ ] Confidence ratings provided (High/Medium/Low)
- [ ] At least one assumption validated or invalidated
- [ ] Reusable code identified where assumptions were wrong

### If Gaps Found

Present to user:

```
introspection phase completed with gaps:

[List unmet criteria]

What would you like to do?
1. Retry introspection with more questions
2. Continue with original approaches
3. Abort workflow
```

Wait for user selection before proceeding.

---

## Checkpoint Review

**User Approval Required:**

Review assumption validation and revised approaches

**Files to Review:**
- `.temp/user-auth-investigation/phase-5-introspection/approaches.json`
- `.temp/user-auth-investigation/phase-5-introspection/assumptions-validated.json`
- `.temp/user-auth-investigation/phase-5-introspection/approaches-revised.json`

**Options:**
1. Continue with revised approach
2. Need more introspection
3. Revert to original approaches
4. Abort

Wait for user selection.

---

## Phase Complete

**Deliverables:**
- `.temp/user-auth-investigation/phase-5-introspection/assumptions-validated.json` - Detailed answers with evidence and confidence ratings

**Provides for Next Phases:**
- assumptions_validated
- assumptions_invalidated
- reusable_code_found
- revised_approaches
```

---

## Comparison Summary

### What Moved Where

**FROM workflow YAML → TO phase YAML:**
- ✅ Subagent matrix (always/conditional)
- ✅ Subagent outputs configuration
- ✅ Gap checks (criteria + on_failure options)

**FROM subagent template files → TO phase YAML:**
- ✅ Subagent prompts → `responsibility` + `instructions` + `scope_specific`

**ADDED to workflow YAML:**
- ✅ `base_dir` configuration
- ✅ Input wiring (which files to pass between phases)

**REMOVED entirely:**
- ❌ `subagents/{name}/{workflow}.md.tmpl` files (100+ templates)
- ❌ Per-phase template files (replaced by one generic executor)

### Benefits Achieved

1. **Single Source of Truth**: Phase YAML contains ALL phase behavior
2. **Workflow Simplicity**: Just phase sequence + wiring + checkpoints
3. **No Template Duplication**: One executor handles all phases
4. **Phase Reusability**: Same phase works in any workflow
5. **Clear Interfaces**: Inputs/outputs/provides explicitly declared
6. **Maintainability**: Change phase = edit one YAML file

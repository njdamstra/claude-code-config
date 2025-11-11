# Phase Module Design

## Overview

Phase modules are reusable instruction templates that define how Claude should execute each phase of a workflow. They are Markdown files stored in `phases/` directory, rendered with variables substituted by the generator script.

---

## Design Principles

1. **Instructions for Claude** - Written as clear, actionable steps
2. **Variable-based** - Use Mustache-style `{{variables}}` for customization
3. **Copy-paste ready** - Claude should be able to follow instructions verbatim
4. **Explicit human-in-loop** - Clear "Present to user" and "Wait for" instructions
5. **Tool-aware** - Reference specific Claude Code tools (Task, Read, Write, Grep, Glob)

---

## Phase Module Structure

### Standard Sections

Every phase module should include:

```markdown
# Phase {N}: {Phase Name}

## Overview
[1-2 sentence description of phase purpose]

## Step 1: Spawn Parallel Subagents

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `thoroughness`: "{{thoroughness}}"
- `description`: "{{task_description}}"

**Prompt:**

Render the following template with these variables:
- `feature_name`: {{feature_name}}
- `scope`: {{scope}}
{{#additional_vars}}
- `{{name}}`: {{value}}
{{/additional_vars}}

**Prompt Template:** `{{template_path}}`

**Task Tool Invocation:**
```
Task(
  subagent_type="{{task_agent_type}}",
  description="{{task_description}}",
  prompt="[Rendered template content from {{template_path}}]"
)
```

**Expected Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

## Step 2: Wait for Completion

All {{subagent_count}} agents must complete before proceeding.

Monitor completion status. Once all complete, verify outputs exist.

## Step 3: Read and Review Outputs

Read all deliverables from `{{workspace}}/{{output_dir}}/`:

{{#deliverables}}
### {{filename}}

**Path:** `{{full_path}}`

**Purpose:** {{description}}

**Validation:**
{{#validation_checks}}
- {{.}}
{{/validation_checks}}

{{#has_template}}
**Output Template:**
```{{template_extension}}
{{template_content}}
```
{{/has_template}}

Use Read tool to examine file and verify criteria above.

{{/deliverables}}

- `{{workspace}}/{{output_dir}}/{{.}}`
{{/review_files}}

**Ask user:**

What would you like to do next?
{{#checkpoint_options}}
{{index}}. {{.}}
{{/checkpoint_options}}

**Wait for user selection** before proceeding.
{{/checkpoint}}

{{^checkpoint}}
## Step 5: Proceed to {{next_phase}}

Gap check passed. Continue directly to Phase {{next_phase_number}}: {{next_phase_name}}.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{workspace}}/{{output_dir}}/{{filename}}` - {{description}}
{{/deliverables}}

## Success Criteria

- All {{subagent_count}} subagents completed successfully
- All deliverables created and validated
- Gap check passed (or user approved continuation)
{{#checkpoint}}
- User approved checkpoint
{{/checkpoint}}
```

---

## Variable Substitution Patterns

### Simple Variables

```markdown
{{variable_name}}
```

Replaced with single value:
- `{{feature_name}}` → "user-dashboard"
- `{{workflow}}` → "new-feature"
- `{{scope}}` → "frontend"

### Conditional Blocks

```markdown
{{#condition}}
Content shown only if condition is truthy
{{/condition}}

{{^condition}}
Content shown only if condition is falsy
{{/condition}}
```

Examples:
```markdown
{{#checkpoint}}
## Checkpoint Required
[checkpoint content]
{{/checkpoint}}

{{^checkpoint}}
No checkpoint for this phase. Proceed directly.
{{/checkpoint}}
```

### Array Iteration

```markdown
{{#array_name}}
{{property}}
{{/array_name}}
```

Example:
```markdown
{{#subagents}}
### {{index}}. {{name}}
Type: {{type}}
{{/subagents}}
```

Renders as:
```markdown
### 1. codebase-scanner
Type: Explore

### 2. pattern-analyzer
Type: Explore
```

### Nested Variables

```markdown
{{#subagents}}
  {{#config}}
    Output: {{output_path}}
  {{/config}}
{{/subagents}}
```

### Cross-Phase Path References

Use `{{phase_paths.<phase_name>}}` to reference outputs from previous phases:

```markdown
## Context from Previous Phase

Discovery phase identified:
- Read `{{phase_paths.discovery}}/codebase-scan.json` - Existing patterns
- Read `{{phase_paths.discovery}}/patterns.json` - Architecture patterns
- Read `{{phase_paths.requirements}}/user-stories.md` - User stories

Use these findings to inform this phase.
```

**Important:** Never use hard-coded paths like `.temp/phase1-discovery/`. Always use the helper variables:
- `{{workspace}}` - Base directory for all workflow outputs
- `{{output_dir}}` - Current phase output directory (e.g., `phase-01-discovery`)
- `{{phase_paths.<name>}}` - Full path to another phase's output directory
- `{{full_path}}` - Complete path to a deliverable file

---

## Step-by-Step Format

### Structure

Each step should:
1. **Start with action verb** - "Spawn", "Read", "Verify", "Present"
2. **Be numbered** - Step 1, Step 2, Step 3...
3. **Have clear end state** - "All agents complete", "User selects option"
4. **Reference specific tools** - "Use Task tool", "Read files with Read tool"

### Example Step

```markdown
## Step 1: Spawn Parallel Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

[Agent list]

**Wait** for all agents to complete before proceeding to Step 2.
```

### Step Guidelines

- **Step 1:** Always subagent spawning (or "No subagents")
- **Step 2:** Always "Wait for completion"
- **Step 3:** Always "Read outputs"
- **Step 4:** Always "Gap check"
- **Step 5:** Conditional (Checkpoint or Proceed)

---

## Subagent Section Format

### Structure

```markdown
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
{{#thoroughness}}
- `thoroughness`: "{{thoroughness}}"
{{/thoroughness}}
- `description`: "{{task_description}}"

**Prompt:**

Use Task tool with this prompt:

\```markdown
[Embedded or referenced template content]
\```

**Expected Output:** `.temp/{{output_dir}}/{{deliverable_path}}`

---
```

### Prompt Embedding Options

**Option A: Fully Embedded** (recommended for short prompts)
```markdown
**Prompt:**

\```markdown
# Codebase Scanner - {{workflow}}

Your task: Scan codebase for patterns...

[Full template content here]
\```
```

**Option B: Reference with Key Points** (recommended for long prompts)
```markdown
**Prompt:**

Load and render template: `subagents/codebase-scanner/new-feature.md.tmpl`

Variables:
- `feature_name`: {{feature_name}}
- `scope`: {{scope}}

Key instructions:
- Find existing patterns
- Document naming conventions
- Identify reusable components
```

**Decision:** Use **Option B** for production (avoids massive file bloat)

---

## Deliverables Format

### Structure

```markdown
{{#deliverables}}
### {{filename}}

**Purpose:** {{description}}

**Validation:**
{{#validation_checks}}
- {{.}}
{{/validation_checks}}

Read file and verify criteria.
{{/deliverables}}
```

### Example

```markdown
### codebase-scan.json

**Purpose:** List of existing patterns and reusable components

**Validation:**
- File exists and is valid JSON
- Contains "patterns" array with 5+ items
- Contains "naming_conventions" object
- All file paths referenced actually exist (no hallucination)

Read file and verify criteria.
```

### Validation Check Guidelines

- Be specific and measurable
- Reference exact data structures
- Check for common failures (empty files, hallucination)
- 3-5 checks per deliverable

---

## Gap Check Format

### Structure

```markdown
## Step 4: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Gaps Found

Present to user:

\```
{{phase_name}} phase complete with the following issues:

[List specific gaps found]

What would you like to do?
{{#gap_options}}
{{index}}. {{.}}
{{/gap_options}}
\```

**Wait for user selection** before proceeding.
```

### Example

```markdown
## Step 4: Gap Check

Verify the following criteria:

- [ ] All subagent output files exist in `{{workspace}}/phase-01-discovery/`
- [ ] Each output file contains > 100 characters
- [ ] codebase-scan.json has 'patterns' array with 5+ items
- [ ] dependencies.json has 'integration_points' array
- [ ] No hallucinated file paths (all paths are real)

### If Gaps Found

Present to user:

\```
Discovery phase complete with the following issues:

- Missing patterns in codebase-scan.json (only 2 found, expected 5+)
- dependencies.json is incomplete (no integration_points array)

What would you like to do?
1. Retry discovery phase with refined scope
2. Spawn additional targeted agents for missing areas
3. Continue with gaps noted in metadata
4. Abort workflow
\```

**Wait for user selection** before proceeding.
```

### Gap Check Guidelines

- Present checklist format (clickable checkboxes)
- Be explicit about what constitutes "passing"
- Provide numbered options (1-4 typical)
- Always include retry, continue, and abort options
- **Always** say "Wait for user selection"

---

## Checkpoint Format

### Structure

```markdown
{{#checkpoint}}
## Step 5: Checkpoint Review

**Present to user:**

{{checkpoint_prompt}}

**Summary:**
{{#summary_points}}
- {{.}}
{{/summary_points}}

**Files for review:**
{{#checkpoint_show_files}}
- `{{.}}`
{{/checkpoint_show_files}}

**Ask user:**

What would you like to do next?
{{#checkpoint_options}}
{{index}}. {{.}}
{{/checkpoint_options}}

**Wait for user selection** before proceeding.
{{/checkpoint}}
```

### Example

```markdown
## Step 5: Checkpoint Review

**Present to user:**

Discovery phase complete. Review findings before proceeding to requirements.

**Summary:**
- Found 12 reusable components
- Identified 8 naming conventions
- Mapped 4 architecture patterns
- Discovered 6 integration points

**Files for review:**
- `{{workspace}}/phase-01-discovery/codebase-scan.json`
- `{{workspace}}/phase-01-discovery/patterns.json`
- `{{workspace}}/phase-01-discovery/dependencies.json`

**Ask user:**

What would you like to do next?
1. Continue to requirements phase
2. Repeat discovery with refined scope
3. Skip to design phase (fast-track)
4. Abort workflow

**Wait for user selection** before proceeding.
```

### Checkpoint Guidelines

- Start with "Present to user:"
- Provide bullet-point summary (3-5 points)
- List specific files to review (with full paths)
- Provide 3-5 options
- End with "Wait for user selection"
- Use actual numbers (1, 2, 3) not placeholders

---

## Complete Example: Discovery Phase Module

**File:** `phases/discovery.md`

```markdown
# Phase 1: Discovery

## Overview

Gather codebase context and identify existing patterns.

## Step 1: Spawn Parallel Subagents

Use the **Task** tool to spawn these agents **simultaneously**:

{{#subagents}}
### {{index}}. {{name}}

**Agent Configuration:**
- `subagent_type`: "{{task_agent_type}}"
- `thoroughness`: "{{thoroughness}}"
- `description`: "{{task_description}}"

**Prompt:**

Load and render template: `subagents/{{type}}/{{workflow}}.md.tmpl`

Substitute these variables:
- `feature_name`: {{feature_name}}
- `scope`: {{scope}}
- `workflow_name`: {{workflow}}

**Expected Output:** `{{workspace}}/{{output_dir}}/{{deliverable_filename}}`

---
{{/subagents}}

## Step 2: Wait for Completion

All {{subagent_count}} agents must complete before proceeding.

Monitor Task tool completion. Once all agents finish, verify expected outputs exist.

## Step 3: Read and Review Outputs

Read all deliverables from `{{workspace}}/{{output_dir}}/`:

{{#deliverables}}
### {{filename}}

**Path:** `{{full_path}}`

**Purpose:** {{description}}

**Validation:**
{{#validation_checks}}
- {{.}}
{{/validation_checks}}

{{#has_template}}
**Output Template:**
```{{template_extension}}
{{template_content}}
```
{{/has_template}}

Use Read tool to examine file and verify criteria above.

{{/deliverables}}

## Step 4: Gap Check

Verify the following criteria:

{{#gap_criteria}}
- [ ] {{.}}
{{/gap_criteria}}

### If Any Criteria Fail

Present to user:

\```
Discovery phase complete with gaps:

[List specific unmet criteria]

What would you like to do?
{{#gap_options}}
{{index}}. {{.}}
{{/gap_options}}
\```

**Wait for user selection** before proceeding.

If user selects retry: Return to Step 1 with refined scope.
If user selects continue: Document gaps and proceed.
If user selects abort: Stop workflow.

{{#checkpoint}}
## Step 5: Checkpoint Review

**Present to user:**

{{checkpoint_prompt}}

**Summary:**
{{#summary_points}}
- {{.}}
{{/summary_points}}

**Files for review:**
{{#checkpoint_show_files}}
- `{{.}}`
{{/checkpoint_show_files}}

**Ask user:**

What would you like to do next?
{{#checkpoint_options}}
{{index}}. {{.}}
{{/checkpoint_options}}

**Wait for user selection** before proceeding.

If user selects "Continue": Proceed to Phase 2.
If user selects "Repeat": Return to Step 1.
If user selects "Abort": Stop workflow.
{{/checkpoint}}

{{^checkpoint}}
## Step 5: Proceed to Requirements Phase

Gap check passed. No checkpoint defined.

Continue directly to Phase 2: Requirements.
{{/checkpoint}}

## Deliverables Summary

This phase produces:
{{#deliverables}}
- `{{full_path}}` - {{description}}
{{/deliverables}}

## Success Criteria

- ✓ All {{subagent_count}} subagents completed
- ✓ All deliverables exist and validated
- ✓ Gap check passed (or user approved gaps)
{{#checkpoint}}
- ✓ User approved checkpoint
{{/checkpoint}}
```

---

## Variable Data Structures

### Subagents Array

```json
{
  "subagents": [
    {
      "index": 1,
      "name": "codebase-scanner",
      "type": "codebase-scanner",
      "task_agent_type": "Explore",
      "thoroughness": "medium",
      "task_description": "Scan codebase for patterns",
      "deliverable_filename": "codebase-scan.json",
      "deliverable_path": "phase-01-discovery/codebase-scan.json"
    }
  ]
}
```

### Deliverables Array

```json
{
  "deliverables": [
    {
      "filename": "codebase-scan.json",
      "description": "List of existing patterns and reusable components",
      "full_path": "{{workspace}}/phase-01-discovery/codebase-scan.json",
      "template_name": "codebase-analysis",
      "template_extension": "json",
      "has_template": true,
      "template_content": "{\n  \"patterns\": [],\n  \"components\": [],\n  \"conventions\": {}\n}",
      "validation_checks": [
        "File exists and is valid JSON",
        "Contains 'patterns' array with 5+ items",
        "All file paths are real"
      ]
    }
  ]
}
```

**New Fields Explained:**
- `full_path` - Complete path including workspace and phase directory
- `template_name` - Name of the template file (without extension)
- `template_extension` - File extension for syntax highlighting (json, md, etc.)
- `has_template` - Boolean flag to show/hide template block
- `template_content` - Full content of the output template file

### Checkpoint Object

```json
{
  "checkpoint": {
    "prompt": "Discovery complete. Review findings.",
    "summary_points": [
      "Found 12 reusable components",
      "Identified 8 naming conventions"
    ],
    "review_files": [
      "phase-01-discovery/codebase-scan.json",
      "phase-01-discovery/patterns.json"
    ],
    "options": [
      "Continue to requirements",
      "Repeat discovery",
      "Abort"
    ]
  }
}
```

---

## Phase-Specific Considerations

### Discovery Phase
- Focus on pattern identification
- Many subagents (3-5)
- Gap check on pattern count
- Checkpoint recommended

### Requirements Phase
- Reads discovery outputs as context
- Focus on INVEST criteria
- Gap check on completeness
- Checkpoint optional

### Design Phase
- Reads discovery + requirements
- Conditional subagents (ui-designer, api-designer)
- Gap check on actionability
- Checkpoint recommended

### Synthesis Phase
- No subagents (main agent only)
- Reads all previous phases
- Follows template structure
- No gap check (covered by validation)

### Validation Phase
- Few subagents (2-3)
- Reads synthesized plan
- Gap check on critical issues
- Checkpoint recommended

---

## Generator Script Integration

### How Generator Uses Phase Modules

```bash
render_phase_instructions() {
  local phase=$1
  local feature_name=$2
  local workflow=$3

  # 1. Load phase module template
  local phase_template="phases/${phase}.md"

  # 2. Build variable data (JSON)
  local phase_data=$(build_phase_data "$phase" "$feature_name" "$workflow")

  # 3. Render template with variables
  render_template "$phase_template" "$phase_data"
}
```

### Variable Building

```bash
build_phase_data() {
  local phase=$1
  local feature_name=$2
  local workflow=$3

  # Get subagents for this phase
  local subagents=$(get_phase_subagents "$workflow" "$phase")

  # Get gap criteria
  local gap_criteria=$(get_gap_criteria "$workflow" "$phase")

  # Get checkpoint (if exists)
  local checkpoint=$(get_checkpoint "$workflow" "$phase")

  # Build JSON
  jq -n \
    --arg phase "$phase" \
    --arg feature "$feature_name" \
    --arg workflow "$workflow" \
    --argjson subagents "$subagents" \
    --argjson gaps "$gap_criteria" \
    --argjson checkpoint "$checkpoint" \
    '{
      phase_name: $phase,
      feature_name: $feature,
      workflow: $workflow,
      output_dir: ("phase-01-" + $phase),
      subagents: $subagents,
      gap_criteria: $gaps.criteria,
      gap_options: $gaps.on_failure,
      checkpoint: $checkpoint
    }'
}
```

---

## Design Decisions

### Why Markdown Templates?

- Human-readable
- Easy to edit
- Clear structure
- Works well with variable substitution
- Claude can read and understand naturally

### Why Mustache-style Variables?

- Simple syntax
- Well-understood pattern
- Easy to implement (no external deps)
- Supports conditionals and loops
- Clear what's variable vs. static

### Why Explicit "Wait for User"?

- Makes human-in-loop crystal clear
- Prevents Claude from auto-proceeding
- Forces deliberate approval points
- Matches user expectations

### Why Numbered Steps?

- Clear sequence
- Easy to reference
- Natural progression
- Prevents confusion
- Matches workflow mental model

---

## Next Steps

1. Create example phase modules for all 5 phases:
   - `phases/discovery.md`
   - `phases/requirements.md`
   - `phases/design.md`
   - `phases/synthesis.md`
   - `phases/validation.md`

2. Test template rendering with sample data

3. Validate against actual workflow execution

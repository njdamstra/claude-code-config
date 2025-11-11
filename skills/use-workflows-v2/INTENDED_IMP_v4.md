# Workflow System v4 - Architecture Improvements

## Problem Statement

Current system has scattered configuration across workflow YAMLs, subagent templates, registries, and output templates. Subagent prompt templates duplicate information and create maintenance burden. Phase templates contain execution logic that should be generic.

## Proposed Improvements (Sequential Implementation)

### 1. Consolidate Subagent Configuration in Workflow YAML

**Remove:** All subagent prompt templates (`subagents/{name}/{workflow}.md.tmpl`)

**Add to workflow YAML:**

```yaml
subagents:
  code-researcher:
    task_agent_type: "code-researcher"  # from registry
    responsibility: "Research codebase for existing patterns, dependencies, and integration points relevant to the problem"
    outputs:
      - file: codebase-analysis.json
        schema: output_templates/codebase-analysis.json.tmpl
        required: true
        description: "Complete analysis of existing codebase patterns"
    scope_specific:
      frontend: "Focus on Vue components, composables, Tailwind patterns"
      backend: "Focus on Appwrite functions, database schemas, API patterns"
      both: "Focus on full-stack integration and data flow"

  requirements-specialist:
    task_agent_type: "requirements-specialist"
    responsibility: "Document user stories, technical requirements, and edge cases"
    outputs:
      - file: requirements.json
        schema: output_templates/requirements.json.tmpl
        required: true
```

**Benefits:**
- Workflow YAML is single source of truth
- No duplicate templates to maintain
- Clear what each subagent does in this workflow
- Output schemas directly referenced
- Scope-specific guidance inline

**Execution:** Task tool receives:
- `subagent_type` from task_agent_type
- `description` from responsibility + scope_specific guidance
- Expected output schema embedded in prompt automatically
- All context variables (feature_name, scope, etc.)

---

### 2. Phases Declare Contracts, Not Procedures

**Remove:** Per-phase template files with step-by-step instructions

**Add:** Phase definitions in workflow YAML

```yaml
phases:
  problem-understanding:
    purpose: "Define and validate problem scope with user"
    subagents: []  # main agent conversation
    inputs: []
    outputs:
      - problem.md
      - success-criteria.json
    provides: ["problem_statement", "constraints", "success_criteria"]

  codebase-investigation:
    purpose: "Research existing codebase patterns and dependencies"
    subagents: [code-researcher]
    inputs: []
    outputs:
      - codebase-analysis.json
    provides: ["patterns", "dependencies", "integration_points"]
    requires: []

  external-research:
    purpose: "Research framework best practices and external patterns"
    subagents: []  # main agent uses skills
    inputs:
      - problem.md
    outputs:
      - best-practices.md
    provides: ["best_practices", "framework_patterns"]
    requires: ["problem_statement"]
```

**Create:** ONE generic phase executor template

```markdown
# Phase: {{phase.purpose}}

## Subagents to Spawn
{{#phase.subagents}}
- {{name}}: {{responsibility}}
  - Output: {{outputs[0].file}}
  - Schema: {{outputs[0].schema}}
{{/phase.subagents}}

## Expected Outputs
{{#phase.outputs}}
- {{.}}
{{/phase.outputs}}

## Gap Check
[Generic validation logic using workflow's gap_checks[phase_name]]

## Checkpoint
[Generic checkpoint logic using workflow's checkpoints]
```

**Benefits:**
- Phases are self-documenting
- One template handles all phases
- Clear contracts between phases
- Easy to see workflow flow

---

### 3. Explicit Inter-Phase Dependencies

**Add to phase definitions:**

```yaml
phases:
  solution-synthesis:
    purpose: "Synthesize findings into 2-3 solution approaches"
    subagents: []
    inputs:
      - from: codebase-investigation
        files: [codebase-analysis.json]
        data: [patterns, dependencies]
      - from: external-research
        files: [best-practices.md]
        data: [framework_patterns]
    outputs:
      - approaches.json
    provides: ["solution_approaches"]
    requires: ["patterns", "dependencies", "best_practices"]
```

**System can now:**
- Validate workflow before execution ("Phase X requires data Y that no previous phase provides")
- Show dependency graph
- Auto-populate available context in templates (`{{inputs.codebase-investigation.patterns}}`)
- Skip unnecessary phases if dependencies not used

---

### 4. Workflow Composition

**Enable importing phases from other workflows:**

```yaml
name: my-investigation-plan
description: Custom workflow combining investigation + planning

imports:
  - investigation-workflow
  - plan-writing-workflow

phases:
  - import: investigation-workflow.problem-understanding
  - import: investigation-workflow.codebase-investigation
  - import: investigation-workflow.external-research
  - custom-synthesis:
      purpose: "Custom synthesis with extra validation"
      subagents: [architecture-specialist]
      inputs:
        - from: codebase-investigation
          files: [codebase-analysis.json]
      outputs: [refined-approaches.json]
  - import: plan-writing-workflow.plan-generation
```

**Or import all phases:**

```yaml
phases:
  - use: investigation-workflow.phases[0:3]  # First 3 phases
  - custom-decision
  - use: plan-writing-workflow.phases[-1]    # Last phase
```

**Benefits:**
- Reuse proven phase sequences
- Mix and match phases
- Create workflow variations without duplication
- Build workflow libraries

---

## Implementation Order

1. **Phase 1:** Consolidate subagent configs into workflow YAML, remove subagent templates
2. **Phase 2:** Create generic phase executor template, move phase definitions to workflow YAML
3. **Phase 3:** Add dependency declarations to phase definitions, implement validation
4. **Phase 4:** Add import/composition support to workflow parser

## Result

- Workflow YAML is complete specification (subagents, phases, dependencies, composition)
- Minimal templates (one generic phase executor, output schemas)
- Self-documenting (dependencies declared, purposes clear)
- Composable (mix and match phases)
- Maintainable (change workflow = edit one YAML file)

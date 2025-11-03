# Claude Workflow Executor

## Purpose
Execute YAML workflows by reading the workflow definition and spawning Task agents for each phase.

## How It Works

1. **Load Workflow** - Read and parse YAML workflow file
2. **Initialize Context** - Create context tracking file
3. **Execute Phases** - For each phase:
   - If `main-only`: Execute inline script/instructions
   - If `parallel`/`sequential`: Spawn Task agents based on subagents list
   - Run gap checks if defined
   - Run checkpoints if defined
4. **Finalize** - Render final template and create metadata

## Execution Pattern

```markdown
## Workflow Execution: [feature-name]

### Phase 1: [phase-name]
**Behavior:** [parallel|sequential|main-only]

[If parallel/sequential:]
Spawning [N] subagents:
1. [subagent-type-1] → output: [path]
2. [subagent-type-2] → output: [path]
...

[Then invoke Task tool for each]
```

## Implementation

When this skill is invoked, Claude should:

1. **Read workflow YAML**
   ```bash
   cat workflows/[workflow-name].workflow.yaml | yq eval -o=json
   ```

2. **For each phase with subagents**, invoke Task tool:
   ```
   Task tool:
   - subagent_type: [mapped from workflow]
   - description: [subagent type]
   - prompt: [rendered from template + context]
   ```

3. **Map workflow subagents to Task tool agents:**
   - `codebase-scanner` → `Explore` (quick thoroughness)
   - `dependency-mapper` → `Explore` (medium thoroughness)
   - `pattern-analyzer` → `Explore` (medium thoroughness)
   - `architecture-designer` → `architecture-specialist`
   - `requirements-specialist` → `requirements-specialist`
   - `bug-investigator` → `Bug Investigator`
   - `[unknown]` → `general-purpose`

4. **After all subagents complete**, synthesize findings

5. **Render final template** using findings

## Example Execution Flow

```
User: "Plan dark mode toggle feature"

Claude:
1. Detects "plan" → invokes use-workflows skill
2. Reads workflows/new-feature.workflow.yaml
3. Creates .temp/dark-mode-toggle/context.json
4. Phase 1 (plan): Executes main_agent script (think hard about approach)
5. Phase 2 (discovery):
   - Spawns Task(Explore, "Scan for existing theme/dark mode patterns")
   - Spawns Task(Explore, "Map dependencies for theme switching")
   - Spawns Task(Explore, "Find reusable Vue theme components")
6. Phase 3 (requirements):
   - Spawns Task(requirements-specialist, "Write user stories...")
   - etc.
7. Synthesis: Reads all .temp/ outputs, renders plan.md
8. Returns: "Plan complete: .temp/dark-mode-toggle/plan.md"
```

## Key Insight

**The bash workflow-runner.sh is scaffolding.**
**The real execution happens when Claude reads this guide and manually orchestrates Task agents based on the YAML workflow definition.**

The workflow YAML is a **recipe for Claude to follow**, not a script to execute.

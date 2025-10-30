# Frontend Command Auto-Spawn Hook

## Purpose
This hook triggers when processing `/frontend-*` commands and ensures Claude automatically spawns agents mentioned with `@agent-name` syntax.

## Trigger
File: Frontend command files (frontend-add.md, frontend-fix.md, frontend-new.md, frontend-improve.md)

## Behavior

### Step 1: Parse Command File
When a `/frontend-*` command is processed, Claude should:
1. Extract all lines containing `**Spawn @agent-name with mission:**`
2. Identify all unique agents mentioned
3. Note the mission/context for each agent

### Step 2: Group by Phase
Claude should identify which agents should run in parallel:
- Agents in the same Phase section → spawn together
- "Main Agent Consolidates" sections → agents completed, proceed to consolidation
- Different phases → sequential, not parallel

### Step 3: Auto-Spawn Agents

**For agents in parallel (same phase):**
```
Use Task tool with multiple agent invocations in a single message:
- One Task call per agent
- All in parallel (same message)
```

**For sequential agents (different phases):**
```
Complete parallel batch → wait for results → move to next phase → spawn next batch
```

### Step 4: Process Results

After agents complete:
1. Read their output/reports
2. Consolidate findings (as per command instructions)
3. Proceed to next phase or present to user for approval

## Agent Type Mappings

When you see `@agent-name`, map to actual agent type for Task tool:

| Alias | Agent Type | Purpose |
|-------|-----------|---------|
| @code-scout | Explore | Codebase analysis, file discovery |
| @documentation-researcher | web-researcher | Documentation and web research |
| @plan-master | problem-decomposer-orchestrator | Strategic planning and decomposition |
| @vue-architect | astro-vue-architect | Vue/Astro architecture |
| @ssr-debugger | astro-vue-architect | SSR and hydration issues |
| @typescript-validator | typescript-master | TypeScript type issues |
| @nanostore-state-architect | astro-vue-architect | State management |
| @appwrite-integration-specialist | appwrite-expert | Appwrite backend |
| @tailwind-styling-expert | astro-vue-ux | UI/UX and styling |
| @vue-testing-specialist | astro-vue-architect | Vue component testing |
| @minimal-change-specialist | minimal-change-analyzer | Surgical code changes |

## Example Execution

**Command File Contains:**
```markdown
**Spawn @code-scout with mission:**
[mission description]

**Spawn @documentation-researcher with mission:**
[mission description]

### Step 2: Main Agent Consolidates
[consolidation instructions]
```

**Claude Should Execute:**

1. Parse: Found 2 agents to spawn
2. Group: Both in same phase → run in parallel
3. Spawn:
   ```
   Task 1: Spawn code-scout with Explore agent
   Task 2: Spawn documentation-researcher with web-researcher agent
   (both in single message)
   ```
4. Wait for both to complete
5. Consolidate: Read reports, follow consolidation instructions
6. Continue to next phase

## When This Activates

- User runs `/frontend-add`, `/frontend-fix`, `/frontend-new`, or `/frontend-improve`
- Claude begins processing the command
- Claude should scan for `@agent-name` patterns
- Auto-spawn agents before main agent proceeds

## Success Criteria

✅ Agents are spawned automatically without user intervention
✅ Parallel agents run in single Task tool call
✅ Sequential phases respect ordering
✅ Agent outputs are incorporated before proceeding
✅ User approval gates (Phase 2) are still respected before implementation

## Notes

- This is a **behavioral hook**, not a pre-processor
- Claude reads this during command execution
- The frontend command files don't need modification
- Works with current command file syntax

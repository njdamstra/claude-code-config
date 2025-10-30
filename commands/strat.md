---
argument-hint: <description>
description: Strategic workflow planning using available Claude Code tools
---

# /strat - Strategic Workflow Planning

**Usage:** `/strat <description>`

Analyzes available Claude Code tools (MCPs, agents, skills, commands) and creates a strategic execution plan for the described task without actually executing it.

## Examples

```bash
# Plan authentication feature
/strat "Implement OAuth2 authentication with Appwrite"

# Plan performance optimization
/strat "Optimize Vue component rendering and reduce bundle size"

# Plan data migration
/strat "Migrate user data from legacy system to Appwrite"
```

## What This Command Does

1. **Loads Tool Inventory** - Discovers all available MCPs, agents, skills, slash commands
2. **Analyzes Description** - Understands requirements and constraints
3. **Maps Tools to Tasks** - Identifies which tools are best suited
4. **Creates Strategic Plan** - Outlines exploration, orchestration, and execution steps
5. **Waits for Approval** - Presents plan and awaits user confirmation

## When to Use

- **Complex tasks** - When you need coordinated use of multiple tools
- **Unfamiliar codebase** - Need to explore before implementing
- **High-stakes changes** - Want to review plan before execution
- **Resource optimization** - Want to ensure using best tools for the job
- **Learning workflow** - Understand how to approach similar tasks

## Implementation

When this command is run with a description argument, execute the following:

### Step 1: Load Tool Inventory

```bash
# Run list-tools.sh to get all available tools
TOOL_INVENTORY=$(~/.claude/scripts/list-tools.sh all)

echo "📋 Loading Claude Code tool inventory..."
echo ""
echo "$TOOL_INVENTORY"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
```

### Step 2: Analyze Description

Parse the description argument and identify:
- **Primary Goal** - What needs to be accomplished
- **Domain** - Frontend, backend, infrastructure, etc.
- **Complexity** - Simple, medium, complex
- **Dependencies** - What existing code/systems are involved
- **Constraints** - Time, scope, technical limitations

```typescript
const description = args.join(' ');

console.log(`
🎯 Task Description:
"${description}"

📊 Analyzing requirements...
`);

// Analyze description to determine:
// - Does this need codebase exploration?
// - Are there existing patterns to discover?
// - Which domains are involved? (Vue, Astro, Appwrite, etc.)
// - What's the estimated complexity?
// - Are there security considerations?
```

### Step 3: Strategic Tool Mapping

Based on the tool inventory and description analysis, map tools to task phases:

```typescript
console.log(`
🗺️  Strategic Tool Mapping
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Phase 1: Discovery & Exploration

**Codebase areas to explore:**
- [List specific directories/files that need investigation]
- [Identify patterns to search for]
- [Document existing implementations to understand]

**Recommended approach:**
${shouldUseExploreAgent ? `
✓ Use Explore subagent (subagent_type: "Explore")
  Reason: [Why Explore agent is best for this task]
  Focus: [What to search for and analyze]
` : ''}

${shouldUseCodeScout ? `
✓ Use code-scout agent (or Explore subagent for broad discovery)
  Reason: [Why pattern search is needed]
  Search for: [Existing patterns, components, composables]
` : ''}

${shouldUseWebResearcher ? `
✓ Use web-researcher agent
  Reason: [Why documentation research is needed]
  Topics: [What documentation to search]
` : ''}

## Phase 2: Planning & Design

**What needs to be planned:**
- [Architecture decisions]
- [Component/file structure]
- [Integration points]

**Recommended approach:**
${shouldUsePlanningSkills ? `
✓ Invoke relevant skills:
  ${skillsToInvoke.map(s => `- ${s} skill`).join('\n  ')}
  Reason: [Why these skills provide necessary context]
` : ''}

${shouldUseProblemDecomposer ? `
✓ Use problem-decomposer-orchestrator agent
  Reason: [Why task decomposition is needed]
  Breaks down: [What gets decomposed]
` : ''}

${shouldUseExistingSlashCommand ? `
✓ Use existing slash command:
  ${slashCommandToUse}
  Reason: [Why this command fits the workflow]
` : ''}

## Phase 3: Orchestration Strategy

**Coordination approach:**
${shouldRunInParallel ? `
✓ Parallel Agent Execution
  Agents to run simultaneously:
  ${parallelAgents.map(a => `  - ${a}`).join('\n')}
  Reason: [Why these can run independently]
` : `
✓ Sequential Execution
  Order:
  ${sequentialSteps.map((s, i) => `  ${i + 1}. ${s}`).join('\n')}
  Reason: [Why sequential is necessary]
`}

${shouldUseUltratask ? `
✓ Consider /ultratask for complex orchestration
  Reason: [Why ultratask workflow is appropriate]
` : ''}

## Phase 4: Implementation

**Tools for execution:**
${implementationTools.map(tool => `
- ${tool.name}
  Use for: ${tool.purpose}
  Why: ${tool.reason}
`).join('\n')}

**Validation steps:**
${validationSteps.map((step, i) => `${i + 1}. ${step}`).join('\n')}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`);
```

### Step 4: Present Strategic Plan

```typescript
console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 STRATEGIC EXECUTION PLAN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Summary

**Task:** ${description}
**Estimated Complexity:** ${complexity}
**Estimated Duration:** ${estimatedTime}
**Risk Level:** ${riskLevel}

## Execution Workflow

### 1️⃣ Discovery Phase
${discoverySteps.map((step, i) => `
${i + 1}. ${step.action}
   Tool: ${step.tool}
   Purpose: ${step.purpose}
   Output: ${step.output}
`).join('\n')}

### 2️⃣ Planning Phase
${planningSteps.map((step, i) => `
${i + 1}. ${step.action}
   Tool: ${step.tool}
   Purpose: ${step.purpose}
   Output: ${step.output}
`).join('\n')}

### 3️⃣ Execution Phase
${executionSteps.map((step, i) => `
${i + 1}. ${step.action}
   Tool: ${step.tool}
   Purpose: ${step.purpose}
   Output: ${step.output}
`).join('\n')}

### 4️⃣ Validation Phase
${validationSteps.map((step, i) => `
${i + 1}. ${step.action}
   Tool: ${step.tool}
   Purpose: ${step.purpose}
   Output: ${step.output}
`).join('\n')}

## Tool Usage Summary

**MCP Servers:** ${mcpsUsed.length > 0 ? mcpsUsed.join(', ') : 'None required'}
**Subagents:** ${agentsUsed.length > 0 ? agentsUsed.join(', ') : 'None required'}
**Skills:** ${skillsUsed.length > 0 ? skillsUsed.join(', ') : 'None required'}
**Slash Commands:** ${commandsUsed.length > 0 ? commandsUsed.join(', ') : 'None required'}

## Estimated Resource Usage

**Token Budget:** ~${estimatedTokens.toLocaleString()} tokens
**Agent Calls:** ${estimatedAgentCalls}
**Context Windows:** ${estimatedContextWindows}

## Risk Assessment

${risks.length > 0 ? risks.map(risk => `
⚠️  ${risk.level}: ${risk.description}
   Mitigation: ${risk.mitigation}
`).join('\n') : '✅ No significant risks identified'}

## Dependencies

${dependencies.length > 0 ? dependencies.map(dep => `
- ${dep.name}
  Status: ${dep.status}
  ${dep.status === 'missing' ? `Action: ${dep.action}` : ''}
`).join('\n') : '✅ All dependencies available'}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`);
```

### Step 5: Wait for Approval

```typescript
console.log(`
🤔 Review the strategic plan above.

**Options:**

1. **Proceed with plan** - Execute the workflow as outlined
2. **Modify plan** - Adjust specific phases or tool choices
3. **Cancel** - Don't proceed with execution

**Additional commands you can run:**

- \`/strat "${description}" --explore-only\` - Only run discovery phase
- \`/strat "${description}" --dry-run\` - Show tool commands without executing
- \`/ultratask [name] [description]\` - Break down into parallel execution

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**What would you like to do?**

Type "proceed", "modify", or "cancel":
`);

// IMPORTANT: Stop here and wait for user response
// Do NOT automatically execute the plan
// Do NOT invoke any tools or agents yet
// Do NOT explore the codebase
// Do NOT proceed beyond presenting the plan
```

## Decision Framework

The command uses this logic to determine tool usage:

### When to Use Explore Agent
- Codebase structure is unfamiliar
- Need to understand existing patterns
- Searching for multiple related files/concepts
- Broad discovery vs. specific file search

### When to Use code-scout Agent
- Looking for existing implementations to reuse
- Checking for duplicate code before creating new
- Finding patterns like composables, components, stores
- Match percentage analysis needed

### When to Use Specialized Agents
- **astro-vue-architect**: SSR components, Vue+Astro integration
- **vue-architect**: Vue component architecture
- **appwrite-integration-specialist**: Appwrite integration, auth, database
- **typescript-validator**: TypeScript errors, type safety
- **problem-decomposer-orchestrator**: Complex multi-step tasks

### When to Use Existing Slash Commands
- `/frontend-*`: Frontend feature workflows
- `/ui-*`: UI component workflows
- `/wt` or `/wt-full`: Worktree management
- `/ultratask`: Complex parallel execution

### When to Invoke Skills
- **nanostore-builder**: State management questions
- **vue-component-builder**: Vue SFC creation
- **appwrite-integration**: Appwrite SDK usage
- **typescript-fixer**: Type error resolution
- **cc-mastery**: Claude Code ecosystem questions

## Strategic Principles

This command follows these principles:

1. **Discovery Before Implementation** - Always explore first
2. **Reuse Over Recreation** - Find existing patterns before building new
3. **Parallel When Possible** - Identify independent tasks
4. **Sequential When Necessary** - Respect dependencies
5. **Right Tool for Right Job** - Match tools to task requirements
6. **Resource Awareness** - Estimate token usage and context
7. **Risk Mitigation** - Identify and plan for potential issues
8. **User Approval** - Never auto-execute without confirmation

## Example Output Scenarios

### Scenario 1: Simple Task
```
Task: "Add a loading spinner to the button component"

Plan Summary:
- Complexity: Simple
- Duration: 5-10 minutes
- No exploration needed

Execution:
1. Invoke vue-component-builder skill
2. Edit existing Button.vue component
3. Add loading prop and spinner icon

Tools: vue-component-builder skill only
```

### Scenario 2: Medium Task
```
Task: "Create user profile page with Appwrite integration"

Plan Summary:
- Complexity: Medium
- Duration: 30-45 minutes
- Needs exploration + implementation

Execution:
1. Explore agent: Find existing profile patterns
2. Skills: vue-component-builder, appwrite-integration, nanostore-builder
3. Create: ProfilePage.vue, UserStore, API route

Tools: Explore agent + 3 skills
```

### Scenario 3: Complex Task
```
Task: "Refactor authentication system to use OAuth2"

Plan Summary:
- Complexity: Complex
- Duration: 2-3 hours
- Needs discovery, planning, orchestration

Execution:
1. Explore agent: Map current auth implementation
2. documentation-researcher: OAuth2 best practices
3. problem-decomposer-orchestrator: Break down refactor
4. Parallel agents: appwrite-expert + typescript-master
5. Sequential: Update components → stores → routes

Tools: 2 agents + orchestrator + 2 specialist agents + 4 skills
```

## Error Handling

```typescript
// Missing description
if (!description || description.trim() === '') {
  console.log(`
⚠️  No task description provided

**Usage:** \`/strat <description>\`

**Example:** \`/strat "Implement user authentication with Appwrite"\`
  `);
  return;
}

// Tool inventory load failure
if (!TOOL_INVENTORY) {
  console.log(`
⚠️  Failed to load tool inventory

**Fallback:** Proceeding with known tools only
**Warning:** Plan may be incomplete

**To fix:** Check ~/.claude/scripts/list-tools.sh
  `);
  // Continue with fallback tool list
}

// No suitable tools found
if (recommendedTools.length === 0) {
  console.log(`
⚠️  No specialized tools identified for this task

**Recommendation:** Use main agent with standard tools

**Consider:**
- Breaking task into smaller pieces
- Using /ultratask for complex orchestration
- Asking for clarification on requirements
  `);
}
```

## Integration with Other Commands

This command complements other workflow commands:

- **Before /frontend-new** - Plan the approach first
- **Before /ultratask** - Understand tool landscape before breaking down
- **After /recall** - Load context, then strategize
- **Before /wt** - Plan before creating worktree

## Pro Tips

1. **Use for Unfamiliar Tasks** - Great for learning best approach
2. **Review Plans** - Even if you know what to do, validate tool choices
3. **Iterate Plans** - Run /strat multiple times with refined descriptions
4. **Save Plans** - Copy output to active/plan.md for reference
5. **Compare Approaches** - Try different descriptions to see alternative plans

## Implementation Notes

- Uses `~/.claude/scripts/list-tools.sh` to get tool inventory
- Analyzes description using pattern matching and heuristics
- Creates plan without executing ANY tools or agents
- Strictly waits for user approval before proceeding
- Can be extended with `--explore-only` or `--dry-run` flags

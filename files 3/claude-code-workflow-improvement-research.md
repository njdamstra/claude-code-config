# Claude Code Slash Commands: Improving Todo Lists, Agent Spawning & Multi-Phase Workflows

**Research Date:** October 16, 2025  
**Status:** Comprehensive Analysis Complete  
**Based on:** Official Anthropic documentation + Community implementations

---

## Executive Summary

Your `frontend-add.md` slash command isn't following through on its complex multi-phase workflow because of **fundamental architectural limitations** in how Claude Code handles slash commands. The issues fall into three categories:

1. **Slash Command Execution Model** - Slash commands execute as sub-agents (via Task tool), losing interactive context
2. **Agent Spawning Limitations** - Sub-agents cannot spawn additional sub-agents (nested tasks not supported)
3. **Todo List Scope** - TodoWrite only persists per-conversation session; doesn't carry across Task boundaries
4. **Automatic Plan Generation** - Claude doesn't automatically infer multi-phase execution from command structure

---

## Part 1: The Core Problem - Why Your Command Fails

### Issue 1.1: Slash Commands Execute as Isolated Sub-Tasks

When a slash command is executed, Claude Code runs it by default using the Task tool, creating an isolated execution environment. This means:

- **Loss of Session Context**: The command runs in a new context window with its own TodoWrite state
- **No Interactive Feedback**: Pauses for user approval don't work as expected within task boundaries
- **Isolated Agent State**: Each spawned agent has limited visibility into the parent's progress

**Reference:** The system instructions state "If you are instructed to execute one, use the Task tool with the slash command invocation as the entire prompt"

### Issue 1.2: Sub-Agents Cannot Spawn Sub-Agents (No Nesting)

Currently, sub-agents spawned via the Task tool in Claude Code cannot themselves spawn additional sub-agents. When a sub-agent attempts to use the Task tool, it reports that the tool is not available.

This breaks your Phase 1 strategy where you wanted:
- Main agent spawns @code-scout
- @code-scout spawns parallel analysis tasks
- Results get consolidated

**What Actually Happens:**
- Main agent spawns @code-scout ✓
- @code-scout tries to spawn parallel tasks ✗ (Task tool not available)
- @code-scout must complete everything sequentially

**Community Workaround:** Some users discovered they can call `claude -p` through the Bash tool to spawn non-interactive Claude instances, but this creates resource management chaos, data flow complexity, and inconsistent behavior.

### Issue 1.3: Todo Lists Don't Persist Across Task Boundaries

**Critical Finding:** The TodoWrite and TodoRead tools are session-scoped - they help manage and plan tasks within a conversation, but Claude Code automatically creates and updates todo lists as you work on tasks.

What this means:
- Phase 0 creates todo list with TodoWrite ✓
- Phase 1 runs as separate Task - todo list is **not inherited** ✗
- Each phase starts with fresh todo state
- User doesn't see unified progress across phases

**Best Practice:** Todo lists really help keep the LLM on track and plan before acting, with a nice dedicated UI in the CLI that improves user experience - but only *within a single task execution*.

### Issue 1.4: No Automatic Phase Detection

Claude doesn't automatically execute your carefully-defined phases. Your markdown structure:

```markdown
## Phase 0: Initialization
## Phase 1: Pre-Analysis
## Phase 2: Planning
## Phase 3: Implementation
```

...is just text to Claude. It doesn't parse this and execute phase-by-phase with pauses. You must **explicitly instruct** Claude to:
1. Run Phase 1
2. Wait for user feedback
3. Run Phase 2
4. Etc.

---

## Part 2: How Successful Multi-Phase Workflows Actually Work

### Pattern 1: The CLAUDE.md Orchestration Pattern

The CLAUDE.md file serves as an implementation guide, with explicit instructions for agents to study codebase, understand current state before writing plan, and follow a methodical three-phase approach.

**Key Insight:** Do one task per session (use /clear command or restart Claude Code) to avoid wasting tokens - sending context from previous task to next task.

**Success Pattern:**
```
1. CLAUDE.md defines the overall workflow
2. User runs ONE slash command per session
3. Slash command handles ONE phase
4. User manually triggers next slash command
5. Context passed via persistent docs, not todo state
```

### Pattern 2: The Sub-Agent Delegation System

When using multi-agent systems, Claude won't be actively using these subagents, so add reminders in CLAUDE.md to tell Claude to assign work to specialists. Include "CRITICAL BEHAVIOR: BE PROACTIVE WITH SUB-AGENTS!"

**Real Implementation:**
- Define specialized agents in `.claude/agents/` directory
- Agents must be **explicitly named and targeted**
- In CLAUDE.md, include explicit delegation reminders
- Claude doesn't automatically use agents - you must tell it to

Claude won't be actively using these subagents, so add CLAUDE.md reminders with a SUB-AGENT DELEGATION SYSTEM noting "YOU HAVE 12 SPECIALIZED EMPLOYEES AVAILABLE!" to make it proactive.

### Pattern 3: The 7-Parallel-Task Method

To maximize sub-agent usage, provide Claude with explicit steps including details about which steps will be delegated to sub-agents. This is quite similar to programming to utilize multi-threads.

**Key Requirement:** You must balance token costs with performance gains - grouping related tasks together is often more efficient than creating separate agents for every operation.

**Implementation:**
- Explicitly state "Run these 7 tasks in parallel"
- Each agent gets clear, bounded scope
- Main agent coordinates results
- Maximum practical parallelism is ~10 tasks (not unlimited)

### Pattern 4: Persistent Context Via Files, Not Todo State

Successful multi-phase workflows use:
- `PRE_ANALYSIS.md` - output from phase 1
- `MASTER_PLAN.md` - output from phase 2
- `IMPLEMENTATION_REPORTS/` - outputs from phase 3
- `COMPLETION_REPORT.md` - final summary

Files become the **single source of truth**, not the todo list.

---

## Part 3: Official Documentation Findings

### From Anthropic Documentation

Slash commands are custom prompts stored as Markdown files that you can trigger with `/command-name` syntax, with argument support via $ARGUMENTS placeholder or positional $1, $2, etc.

The SlashCommand tool allows Claude to execute custom slash commands programmatically during a conversation. Slash commands must have the description field in frontmatter for Claude to see them, and disable-model-invocation: true prevents automatic invocation.

### Todo Tool Design

The Claude Code SDK includes built-in todo functionality that helps organize complex workflows and keep users informed about task progression, but todo tracking is **session-scoped**.

Use TodoWrite tool VERY frequently and mark todos as completed immediately after finishing each task - do not batch up multiple tasks before marking them completed.

---

## Part 4: Known Limitations & Workarounds

### Limitation 1: No Nested Sub-Agent Spawning

**Problem:** Sub-agents can't spawn sub-agents
**Workaround Options:**
1. ✅ Flatten the hierarchy - have main agent spawn all tasks directly
2. ⚠️ Use bash `claude -p` calls (lossy, not recommended)
3. ⏳ Wait for nested Task tool support (requested as Issue #4182)

### Limitation 2: Slash Commands Auto-Execute as Tasks

**Problem:** Slash commands by default execute with the Task tool, preventing interactive prompts from working as designed
**Workaround:** 
- Design non-interactive commands that don't need user pauses
- Use CLAUDE.md for interactive workflows instead
- Manually orchestrate phases in separate sessions

### Limitation 3: Sub-Agents Named "code-reviewer" Infer Function

There's a "feature" where Claude Code will infer a sub-agent's function based on its name, silently overriding your custom instructions. The workaround is to use non-descriptive names for your sub-agents.

**Example:** Instead of naming an agent `feature-analyzer`, use `analyzer-alpha` to avoid automatic role inference.

### Limitation 4: Slash Commands Bypass Tool Visibility in Sub-Agents

**Issue:** When a slash command runs via Task tool, the spawned agent inherits all tools EXCEPT the ability to spawn more tasks.

---

## Part 5: Community Best Practices

### Best Practice 1: Single-Purpose Slash Commands

One developer reported 20% reduction in token usage by converting fixed workflows to slash commands, but this works best when each command has **single responsibility**.

**Pattern:**
- `/frontend-analyze` - analyzes existing feature
- `/frontend-plan` - creates implementation plan
- `/frontend-implement` - executes implementation
- `/frontend-validate` - runs validation

Rather than one massive `/frontend-add` command.

### Best Practice 2: Use Plugins for Workspaces

Plugins are now in public beta, allowing you to package slash commands, subagents, MCP servers, and hooks together. Install them with /plugin command and they work across terminal and VS Code.

**Benefit:** Shared workflows across team, version control, reusable patterns.

### Best Practice 3: Explicit Agent Orchestration in CLAUDE.md

Rather than hoping Claude uses agents, explicitly document:

```markdown
## Multi-Agent Coordination

When implementing new features, delegate work as follows:

1. **Architecture Agent**: Review design requirements
   - Command: Use @architect for system design
   - Output: ARCHITECTURE.md
   
2. **Frontend Agent**: Build UI components
   - Command: Use @frontend for implementation
   - Output: Updated components/
   
3. **Testing Agent**: Create comprehensive tests
   - Command: Use @tester for test coverage
   - Output: Updated tests/
```

Add "SMART DELEGATION: YOU HAVE 12 SPECIALIZED EMPLOYEES AVAILABLE!" and "CRITICAL BEHAVIOR: BE PROACTIVE WITH SUB-AGENTS!" to make delegations automatic.

### Best Practice 4: Session-Based Architecture

Do one task per session (use /clear command or restart Claude Code) to avoid wasting tokens.

**Better Workflow:**
```
Session 1: Run `/frontend-add feature-name` → creates plan
Session 2: User reviews plan, says "proceed"
Session 3: Run `/frontend-add feature-name --phase=implement`
Session 4: Validation and results
```

---

## Part 6: Recommended Improvements to Your Workflow

### Recommendation 1: Refactor Into Phase-Specific Commands

Instead of one mega-command, create four slash commands:

**`frontend-analyze.md`**
- Phase 0 + Phase 1 only
- Outputs: `PRE_ANALYSIS.md`
- Provides human checkpoint

**`frontend-plan.md`**
- Phase 2 only
- Input: `PRE_ANALYSIS.md`
- Outputs: `MASTER_PLAN.md`
- Requests user approval

**`frontend-implement.md`**
- Phase 3 only
- Input: `MASTER_PLAN.md`
- Runs implementation
- Creates implementation reports

**`frontend-validate.md`**
- Phase 4 only
- Runs tests and creates completion report

### Recommendation 2: Explicit Agent Instructions in Frontmatter

```yaml
---
allowed-tools: Bash(ls:*), Read, Write, Edit, TodoWrite, TodoRead, Task, WebSearch
argument-hint: [feature-name] [feature-description]
description: Analyze existing feature and map extension points
disable-model-invocation: false
---

# Phase 1: Pre-Analysis for Frontend Feature Addition

**Feature to Analyze:** `$1`
**Extension Request:** `$2`

## Delegate to Specialized Agents

I have access to specialized agents. Spawn them with explicit Task calls:

**Spawn Agent 1: Code Scout Analysis**
```
Task(
  description: "Analyze feature $1 architecture",
  prompt: "Map all files related to feature: $1
  - Find components, stores, composables, API routes
  - Trace data flow through feature
  - Document architectural patterns"
)
```

**Spawn Agent 2: Documentation Research**
```
Task(
  description: "Research VueUse solutions for $2",
  prompt: "Search documentation for existing solutions...
  - Find composables that provide $2
  - Document usage patterns
  - Compare with custom implementations"
)
```

[Continue with explicit instructions...]
```

### Recommendation 3: Use Markdown Files as State Persistence

Instead of relying on TodoWrite for multi-phase state:

```markdown
# `.claude/PHASE_STATE.md`

## Current Phase Tracking

**Active Phase:** Phase 2 (Planning)
**Completed Phases:** [Phase 0, Phase 1]
**Next Phase:** Phase 3 (Implementation)

## Phase 1 Outputs
- [x] Feature architecture mapped
- [x] VueUse alternatives identified
- [x] Extension points documented

**File:** `.temp/add-$1/PRE_ANALYSIS.md` ✓ Created

## Phase 2 Status
- [ ] Plan created
- [ ] User approval obtained
- [ ] Implementation strategy finalized

**File:** `.temp/add-$1/MASTER_PLAN.md` (pending)
```

User can then continue workflow by asking: "Check PHASE_STATE.md and continue from where we left off"

### Recommendation 4: Add Context Priming in CLAUDE.md

```markdown
## Frontend Addition Workflow Rules

- **One Phase Per Command**: Each slash command (/frontend-analyze, 
  /frontend-plan, etc.) handles exactly one phase
- **File-Based Handoff**: Each phase outputs to markdown files that 
  the next phase reads
- **Explicit Approval Gates**: Stop and present findings before 
  proceeding to implementation
- **Agent Usage**: When performing analysis, spawn dedicated agents 
  for different concerns (code analysis, documentation, etc.)
- **Parallel Execution**: For independent analyses, use Task tool 
  with explicit parallelism request
```

---

## Part 7: Production-Ready Implementation Template

### Architecture: Phase-Based Slash Commands + CLAUDE.md

```
project/
├── .claude/
│   ├── commands/
│   │   ├── frontend-analyze.md      # Phase 0-1
│   │   ├── frontend-plan.md         # Phase 2
│   │   ├── frontend-implement.md    # Phase 3
│   │   └── frontend-validate.md     # Phase 4
│   ├── agents/
│   │   ├── code-scout.md            # Architecture analysis
│   │   ├── doc-researcher.md        # Documentation research
│   │   └── implementation-lead.md   # Execution lead
│   └── CLAUDE.md                    # Orchestration rules
├── docs/
│   ├── FRONTEND_ARCHITECTURE.md     # Auto-generated
│   ├── PLAN.md                      # Auto-generated
│   └── COMPLETION_REPORT.md         # Auto-generated
└── (source code)
```

### Workflow Example

**Session 1: Analysis**
```
user> /frontend-analyze "search" "filter capabilities"

→ Command runs Phase 0-1
→ Creates .temp/add-search/PRE_ANALYSIS.md
→ Presents findings to user
```

**Session 2: Planning**
```
user> /frontend-plan "search" "filter capabilities"

→ Command reads PRE_ANALYSIS.md
→ Creates MASTER_PLAN.md
→ Presents plan for approval
→ Waits for user feedback
```

**Session 3: Implementation**
```
user> /frontend-implement "search" "filter capabilities"

→ Command reads MASTER_PLAN.md
→ Spawns 3-5 parallel agents for components, stores, tests
→ Creates implementation reports
→ Commits changes
```

**Session 4: Validation**
```
user> /frontend-validate "search" "filter capabilities"

→ Runs tests
→ Checks build
→ Creates COMPLETION_REPORT.md
→ Shows results
```

---

## Part 8: When to Use Different Approaches

### Use Slash Commands For:
- ✅ Focused, single-phase tasks
- ✅ Reusable workflows (code review, security scan, test generation)
- ✅ Independent operations that don't require human feedback mid-execution
- ✅ Parallel agent spawning (all at once, not hierarchical)

### Use CLAUDE.md Interactive Workflows For:
- ✅ Multi-phase processes with approval gates
- ✅ Complex human-in-the-loop decision points
- ✅ Hierarchical agent coordination
- ✅ Context-dependent execution

### Use Plugins For:
- ✅ Shareable, versioned command collections
- ✅ Team-wide standardized workflows
- ✅ Encapsulated toolsets with multiple commands/agents/MCP servers

---

## Part 9: Technical Specifications & Limitations

### Official Constraints

| Constraint | Limit | Source |
|-----------|-------|--------|
| Sub-agent spawning depth | 1 level (can't nest) | Issue #4182 |
| Parallel task execution | ~10 concurrent max | Testing reports |
| TodoWrite session scope | Per conversation | Documentation |
| SlashCommand character budget | Configurable | SLASH_COMMAND_TOOL_CHAR_BUDGET env var |
| Sub-agent context window | Isolated/clean per task | Design |
| Slash command execution model | Task tool (isolated) | System instructions |

### Model Recommendations

Some users reported issues with Claude 3.7 on Bedrock not supporting parallel task execution. As soon as they switched to Sonnet 4 or Opus 4, problems were solved. The underlying model matters - ensure you're using a model that supports the features you need.

**Recommended:**
- Main agent: Claude Sonnet 4.5 or Opus 4.1
- Sub-agents: Sonnet 4.5 (best cost/performance for sub-tasks)

---

## Part 10: Quick Fixes for Your Current Command

### Immediate Changes (Minimum Viable)

1. **Split into 4 separate slash commands** - one per phase
2. **Remove nested agent spawning** - spawn all agents from main, not from sub-agents
3. **Use markdown files for state**, not todo assumptions
4. **Add explicit CLAUDE.md orchestration hints** so Claude knows to be proactive with agents

### Code Changes

**From:** One massive command trying to do everything
```markdown
## Phase 0: Initialization
[spawns agents, creates todo]

## Phase 1: Pre-Analysis
[spawns MORE agents - FAILS because nested spawning not supported]

## Phase 2: Planning
[tries to use todo state from Phase 1 - FAILS because todo doesn't carry over]

## Phase 3: Implementation
[tries to implement based on todo - FAILS because no todo context]
```

**To:** Four focused commands

```markdown
# frontend-analyze.md
(Phase 0-1: Analysis only)
→ Output: PRE_ANALYSIS.md
→ Stop and show user

# frontend-plan.md  
(Phase 2: Planning)
→ Input: PRE_ANALYSIS.md
→ Output: MASTER_PLAN.md
→ Stop and request approval

# frontend-implement.md
(Phase 3: Implementation)
→ Input: MASTER_PLAN.md
→ Run with parallel agents
→ Output: Implementation reports

# frontend-validate.md
(Phase 4: Validation)
→ Input: implementation reports
→ Output: COMPLETION_REPORT.md
```

---

## Summary & Action Items

### What's NOT Working
1. ❌ Nested agent spawning (sub-agents can't spawn sub-agents)
2. ❌ Cross-phase todo persistence
3. ❌ Automatic phase orchestration from command structure
4. ❌ Interactive approval gates within task-executed commands

### What IS Working
1. ✅ Single-phase focused commands
2. ✅ Explicit agent delegation via Task tool (flat hierarchy only)
3. ✅ File-based state persistence across sessions
4. ✅ Parallel agent execution at single level
5. ✅ Sub-agent specialization via custom `.claude/agents/` definitions

### Your Action Plan

**Priority 1 (This Week):**
- [ ] Refactor `frontend-add.md` into 4 separate commands
- [ ] Remove nested agent spawn logic
- [ ] Implement file-based state passing instead of todo assumptions
- [ ] Test Phase 0-1 command in isolation

**Priority 2 (Next Week):**
- [ ] Add explicit agent delegation to CLAUDE.md
- [ ] Create PRE_ANALYSIS.md template
- [ ] Create MASTER_PLAN.md template
- [ ] Test full 4-phase workflow

**Priority 3 (Future):**
- [ ] Consider creating a plugin once workflow is stable
- [ ] Document patterns for team reuse
- [ ] Monitor Issue #4182 for nested spawning support
- [ ] Evaluate claude-todo-emulator MCP for persistent todo needs

---

## Research Sources

### Official Documentation
- [Slash Commands Documentation](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Sub-Agents Documentation](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Claude Code System Prompt](https://gist.github.com/wong2/e0f34aac66caf890a332f7b6f9e2ba8f)
- [Plugins Documentation](https://www.anthropic.com/news/claude-code-plugins)

### Known Issues
- [Issue #4182: Nested Task Spawning Not Supported](https://github.com/anthropics/claude-code/issues/4182)
- [Issue #4745: Slash Commands Execute as Tasks](https://github.com/anthropics/claude-code/issues/4745)
- [Issue #4706: Sub-Agents Not Recognized](https://github.com/anthropics/claude-code/issues/4706)

### Community Implementations
- [Multi-agent orchestration patterns](https://claudelog.com/mechanics/task-agent-tools/)
- [7-Parallel-Task Method](https://claudelog.com/mechanics/task-agent-tools/)
- [Sub-Agent Deep Dive](https://cuong.io/blog/2025/06/24-claude-code-subagent-deep-dive)
- [CLAUDE.md Best Practices](https://thegroundtruth.substack.com/p/my-claude-code-workflow-and-personal-tips)
- [Agent Cluster Management](https://www.pulsemcp.com/posts/how-to-use-claude-code-to-wield-coding-agent-clusters)

---

## Conclusion

Your `frontend-add.md` is architecturally sound in **concept**, but runs into practical limitations with how Claude Code currently executes slash commands and spawns agents. The fix is straightforward: **decompose into smaller, focused commands** that work within the current architecture rather than against it.

The pattern that **works** is:
- One slash command = one phase
- File handoffs between phases
- Explicit, flat agent spawning (no nesting)
- Manual orchestration across sessions
- CLAUDE.md for intelligent guidance

This is actually more robust than trying to do everything in one command, as it creates natural checkpoints for validation and user feedback.

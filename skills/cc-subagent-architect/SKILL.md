---
name: CC Subagent Architect
description: MUST BE USED for designing specialized subagents with specific expertise, tool restrictions, and delegation patterns. Use when creating .claude/agents/ with auto-invocation triggers, building read-only reviewers (tools: [read, grep]), implementers (tools: [read, edit, write]), or specialized searchers. Handles subagent.md frontmatter, system prompt engineering, context isolation, error handling, and agent chaining. Provides templates for: code-reviewer (no modifications), security-checker, test-generator, documentation-writer. Use for "subagent", "agent design", "delegation", "auto-invoke", "tool restriction", "specialist agent", "expert".
version: 2.0.0
tags: [claude-code, subagents, agents, delegation, architecture, specialization, tool-restrictions, system-prompts, context-isolation, auto-invocation, templates]
---

# CC Subagent Architect

## Quick Start

A subagent is a specialized AI agent configured in `~/.claude/agents/` that Claude can automatically invoke to handle delegated tasks. Subagents reduce main context pollution and provide focused expertise.

### Minimal Subagent Structure
```yaml
---
name: Security Auditor
description: Reviews code for security vulnerabilities and suggests fixes
system_prompt: |
  You are a security expert. Review code for vulnerabilities. Be thorough but concise.
tools: [Read, Edit, Grep]
---
```

### File Location
Place agent config in `~/.claude/agents/my-agent.md`

### Frontmatter Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Display name for the agent |
| `description` | Yes | When Claude should invoke this agent |
| `system_prompt` | Yes | Agent's expertise and instructions |
| `tools` | No | Restrict to specific tools (default: all) |
| `model` | No | Override model (e.g., `claude-opus-4-1`) |
| `auto_invoke` | No | Auto-invoke when description matches (default: true) |

## Core Concepts

### System Prompt vs User Prompt (Critical!)

**System Prompt** = Agent's expertise and worldview
```
You are a performance optimization expert with 10+ years of experience.
You focus on identifying bottlenecks and suggesting concrete improvements.
Always measure impact and provide before/after comparisons.
```

**User Prompt** = The actual task
```
Review this function for performance issues and suggest optimizations.
```

The system prompt shapes HOW the agent thinks. The user prompt specifies WHAT to do.

### Description Field = Trigger Condition

The `description` field determines when Claude invokes the subagent:

```yaml
---
name: Git Analyzer
description: Analyzes git history, commits, and repository structure. Use when analyzing git patterns or repository metrics.
---
```

Claude reads this and automatically invokes the agent when:
- User asks to "analyze repository structure"
- Task involves "git history analysis"
- Problem relates to "commit patterns"

**Write descriptions as:** "Handles X, Y, Z. Use when [trigger conditions]"

### Tool Restriction Pattern

Default: subagents have ALL tools available (dangerous!)

Safe approach: Restrict tools to what agent actually needs

```yaml
---
name: Security Auditor
description: Reviews code for vulnerabilities
system_prompt: You are a security expert...
tools: [Read, Grep, Bash]  # Can read & search but NOT edit
---
```

Common tool restrictions:

| Agent Type | Tools | Rationale |
|-----------|-------|-----------|
| Code Reviewer | `[Read, Grep]` | Only review, no modifications |
| Security Auditor | `[Read, Grep, Bash]` | Analyze only, no changes |
| Refactoring Agent | `[Read, Edit, Grep]` | Make changes, but not Bash |
| Implementer | `[Read, Edit, Write, Bash]` | Full development access |

### Available Claude Code Tools

**File Operations:**
- `Read` - Read files (text, images, PDFs, Jupyter notebooks)
- `Write` - Write new files
- `Edit` - Exact string replacements in files
- `MultiEdit` - Multiple edits to a single file in one operation
- `NotebookEdit` - Edit Jupyter notebook cells (.ipynb)

**Search and Navigation:**
- `Glob` - Fast file pattern matching (`**/*.js`)
- `Grep` - Powerful search with regex (built on ripgrep)
- `LS` - List files and directories

**Command Execution:**
- `Bash` - Execute bash commands in persistent shell
- `BashOutput` - Retrieve output from background bash shells
- `KillShell` - Terminate background bash shells

**Web Operations:**
- `WebFetch` - Fetch and analyze content from URLs
- `WebSearch` - Search the web for up-to-date information

**Task Management:**
- `TodoWrite` - Create and manage structured task lists
- `TodoRead` - Read existing task lists
- `ExitPlanMode` - Exit planning mode when ready to implement

**Agent/Delegation:**
- `Task` - Launch specialized agents for complex tasks

**Special:**
- `SlashCommand` - Execute slash commands

**MCP Tools (if configured):**
- Any tools from connected MCP servers (e.g., `mcp__gemini-cli__*`, `mcp__ide__*`)

**To allow ALL tools (including MCP):**
```yaml
# Omit the tools field entirely
---
name: Full Access Agent
description: Agent with unrestricted tool access
system_prompt: You have access to all tools...
# No tools field = inherits all tools from main thread
---
```

## Patterns

### Pattern 1: Research Subagent
```yaml
---
name: Documentation Researcher
description: Researches frameworks, libraries, and technical concepts. Use when gathering background information or learning about new technologies.
system_prompt: |
  You are a thorough technical researcher. When investigating topics:
  1. Search multiple sources and cross-verify
  2. Provide balanced perspectives
  3. Cite source quality (official docs > blogs > forums)
  4. Highlight unknowns and edge cases
tools: [WebSearch, WebFetch, Read, Grep]
---
```

### Pattern 2: Specialist Auditor
```yaml
---
name: Performance Analyzer
description: Profiles and optimizes application performance. Use when analyzing performance bottlenecks, measuring impact, or suggesting optimizations.
system_prompt: |
  You are a performance expert. When analyzing code:
  1. Identify concrete metrics (time, memory, allocations)
  2. Prioritize high-impact improvements
  3. Measure before/after with benchmarks
  4. Suggest trade-offs between approaches
tools: [Read, Bash, Grep]
---
```

### Pattern 3: Implementation Specialist
```yaml
---
name: Vue Component Builder
description: Creates high-quality Vue 3 components with TypeScript and Tailwind CSS. Use when building new Vue components or refactoring existing ones.
system_prompt: |
  You are an expert Vue 3 developer. When creating components:
  1. Use Composition API with TypeScript
  2. Follow Vue 3 best practices
  3. Include proper type safety
  4. Use Tailwind for styling
  5. Support SSR compatibility
tools: [Read, Write, Edit, Grep]
---
```

## Best Practices

### DO: Craft Specific System Prompts
```yaml
# Good - specific expertise and approach
system_prompt: |
  You are a TypeScript expert specializing in type safety.
  When reviewing types:
  - Check for `any` types (flag as risks)
  - Verify generic constraints are sound
  - Suggest stricter types when appropriate
  - Reference TypeScript best practices
```

```yaml
# Bad - too generic
system_prompt: |
  You are a helpful assistant. Review code for issues.
```

### DO: Write Clear Descriptions
```yaml
# Good - specific triggers
description: Analyzes Git history, commits, and repository patterns. Use when understanding repository structure, analyzing commit trends, or examining git workflows.
```

```yaml
# Bad - too vague
description: A git expert
```

### DO: Restrict Tools Appropriately
```yaml
# Good - review-only, no modifications
tools: [Read, Grep]
```

```yaml
# Bad - unrestricted access
tools: []  # All tools available!
```

### DO: Use Descriptive Names
```yaml
name: TypeScript Type Validator    # Good - specific role
name: Code Reviewer               # Generic - multiple meanings
```

### DON'T: Hallucinate Project Knowledge
```yaml
# Bad - assumes knowledge of project internals
system_prompt: |
  Review this code against our company standards documented in /internal/standards.md
```

```yaml
# Good - focuses on general best practices
system_prompt: |
  Review code for common TypeScript issues:
  - Unsafe type assertions
  - Missing error handling
  - Inefficient patterns
```

### DON'T: Create Too Many Subagents
- Start with 3-5 core agents
- Add agents only when you repeatedly invoke specialized expertise
- Monitor usage patterns before creating new agents

## Advanced Configuration

### Model Override
```yaml
---
name: Complex Analyzer
description: Handles complex architectural analysis
system_prompt: Complex analysis requires deeper reasoning...
model: claude-opus-4-1  # Use bigger model for hard problems
tools: [Read, Grep]
---
```

### Disabling Auto-Invoke
```yaml
---
name: Experimental Agent
description: Only invoke manually with /invoke-agent command
system_prompt: Experimental features...
auto_invoke: false  # Don't auto-trigger this agent
---
```

### Agent Chains
Subagents can invoke other subagents through the Task tool:

```yaml
---
name: Full Stack Reviewer
description: Comprehensive code review combining multiple specialties
system_prompt: |
  You coordinate specialized review agents:
  1. Invoke the TypeScript type validator
  2. Invoke the performance analyzer
  3. Invoke the security auditor
  4. Synthesize findings into one report
---
```

### Agent Output Preservation

When orchestrating multiple subagents, preserve complete outputs for audit trails:

```yaml
---
name: Research Orchestrator
description: Coordinates multiple research agents and preserves outputs
system_prompt: |
  You orchestrate research agents. For each agent invoked:

  **CRITICAL OUTPUT RULES:**
  1. Create timestamped output directory: outputs/YYYY-MM-DD_HH-MM-SS/
  2. Write COMPLETE, UNMODIFIED agent responses to separate files
  3. DO NOT summarize, truncate, or modify agent outputs
  4. Preserve exact formatting, code blocks, and structure

  Naming convention:
  - outputs/<timestamp>/<category>/<agent-name>.md

  After all agents complete, create summary report:
  - outputs/<timestamp>/summary.md (separate from agent outputs)
tools: [Bash, Task, Write]
---
```

**Benefits:**
- Full context retention for later analysis
- Reproducibility - exact agent outputs preserved
- Audit compliance - complete record of reasoning
- Debugging - can trace exact agent behavior

**Timestamped Directory Structure:**
```
outputs/
└── 2025-10-29_19-30-45/
    ├── research/
    │   ├── agent1.md (complete, unmodified output)
    │   ├── agent2.md (complete, unmodified output)
    │   └── agent3.md (complete, unmodified output)
    └── summary.md (orchestrator's consolidation)
```

## Testing Your Subagent

### Test 1: Trigger Detection
```
"Review this component for performance issues"
→ Should invoke performance-analyzer subagent
```

### Test 2: Tool Restrictions
```
"Refactor this file"
→ Agent should suggest changes but not modify (if using Read-only tools)
```

### Test 3: Quality Output
```
"Analyze this git repository"
→ Agent should provide structured analysis with metrics
```

### Test 4: Context Isolation
```
Ask agent about project-specific knowledge it shouldn't have
→ Agent should indicate it lacks context, not hallucinate
```

## Troubleshooting

### Agent Isn't Invoked
- Check description field matches user request
- Verify agent file is in `~/.claude/agents/`
- Confirm auto_invoke is not set to `false`
- Read the agent's description as Claude would

### Agent Has Wrong Tools
- Verify `tools` field in frontmatter
- Check tool names exactly (case-sensitive)
- Use `[]` to disable all tools (review-only)
- Use empty `tools:` line for all tools

### Agent Hallucinating
- Sharpen system_prompt with specific constraints
- Remove assumptions about project knowledge
- Focus on general best practices instead
- Use Bash/Read tools to verify information

## Description Best Practices

The description field controls when Claude auto-invokes your subagent. Make it specific, keyword-rich, and trigger-focused.

### Key Principles

**1. Use "MUST BE USED" for High-Priority Invocation**
- Signals this agent should be triggered
- Use for critical specialties
- Front-loads the invocation pattern

```yaml
# Good - high-priority invocation
description: MUST BE USED for code review focusing on security vulnerabilities, authentication flaws, and data protection issues.

# Weaker - optional invocation
description: Reviews code for security issues
```

**2. Define Clear Boundaries and Expertise**
- Specify WHAT the agent does
- Describe its CONSTRAINTS and specialty
- Explain what it outputs

```yaml
# Good - clear boundaries
description: MUST BE USED for TypeScript type validation. Expert in identifying unsafe type assertions, missing error handling, and inefficient patterns. Provides structured type audit reports.

# Bad - unclear scope
description: TypeScript expert
```

**3. Include Trigger Scenarios**
- List specific situations that should invoke this agent
- Use natural language users will employ
- Map to user requests directly

```yaml
# Good - explicit triggers
description: MUST BE USED when analyzing code for performance bottlenecks, measuring optimization impact, or suggesting performance improvements. Use for "optimize this", "profile", or "performance issues".

# Bad - implicit triggers
description: Performance analyzer
```

**4. Distinguish from Commands and Styles**
- Agents are auto-invoked (user doesn't trigger manually)
- Agents make decisions (not just execute templates)
- Agents provide specialized expertise

```yaml
# For a subagent (auto-invoked)
description: MUST BE USED for security audits. Auto-detects vulnerabilities and suggests hardening steps.

# For a command (user-invoked)
description: Run security audit with specified scan level

# For a style (personality mode)
description: Security-focused response personality for code reviews
```

**5. Mention Tool Restrictions**
- Hint at what tools the agent uses
- Signal read-only vs modification capabilities

```yaml
# Good - signals read-only
description: MUST BE USED for code review. Read-only analysis providing improvement suggestions without modifications.

# Good - signals full capabilities
description: MUST BE USED for refactoring. Modifies code using best practices and provides explanations.
```

### Structure Template

```yaml
description: MUST BE USED for [SPECIALTY/DOMAIN]. [What it does]. Use when [trigger scenarios]. [Output/capability statement].

Example:
description: MUST BE USED for Vue component refactoring. Modernizes Vue 2 components to Vue 3 Composition API with TypeScript. Use when updating legacy components or improving type safety. Provides before/after examples and explains each change.
```

### Real Subagent Examples

```yaml
---
name: Security Auditor
description: MUST BE USED for security audits, vulnerability scanning, and secure coding reviews. Identifies authentication flaws, data protection issues, and injection risks. Read-only analysis, no code modifications.
tools: [Read, Grep, Bash]
---

---
name: Vue Component Builder
description: MUST BE USED when creating new Vue 3 components or refactoring existing ones. Expert in Composition API, TypeScript, and Tailwind CSS. Uses best practices and ensures SSR compatibility. Provides complete, working components.
tools: [Read, Write, Edit, Grep]
---
```

## References

For more information:
- CC Mastery: Integration patterns and decision framework
- CC Slash Command Builder: Automate agent creation
- CC Output Style Creator: Shape agent personality
- Full Subagents Guide: `documentation/claude/claude-code-docs/02-subagents-guide.md`

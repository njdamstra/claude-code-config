---
name: CC Mastery
description: MUST BE USED for Claude Code ecosystem architecture, decision frameworks, and integration patterns. Use when asking "how do I", "what's the difference", "which should I use", "best practice for", or designing Claude Code setups. Teaches when to choose skills (knowledge) vs subagents (delegation) vs slash commands (automation) vs hooks (lifecycle) vs MCP (external data) vs output styles (personality). Provides decision matrices, tradeoff analysis, and component interactions. Use for "skill vs subagent", "should I create", "architecture", "how does work", "Claude Code best practice".
version: 2.0.0
tags: [claude-code, ecosystem, decision-framework, architecture, skills, subagents, slash-commands, hooks, mcp, output-styles, integration, best-practices, design-patterns]
---

# CC Mastery

## Quick Start

Claude Code is a powerful CLI for AI-assisted development with five core components:

1. **Skills** - Model-invoked capabilities that activate on-demand for specific tasks
2. **Subagents** - Specialized AI agents that handle delegated work with isolated context
3. **Slash Commands** - Custom workflow automations via `/command` syntax
4. **Hooks** - Lifecycle automation triggered by tool execution events
5. **MCP Servers** - Model Context Protocol for accessing external data sources
6. **Output Styles** - Personality modes that shape how Claude responds to different task types

## Component Hierarchy

### Tier 1: Core Workflow (Closest to User)
- **Slash Commands** - Direct user interaction, command-driven workflows
- **Output Styles** - Personality adaptation, response shaping

### Tier 2: Smart Execution
- **Skills** - On-demand capabilities discovered during task execution
- **Subagents** - Task delegation with specialized expertise

### Tier 3: Integration & Automation
- **Hooks** - Lifecycle events and automation triggers
- **MCP Servers** - External data and API access

## Decision Framework: When to Use What

### Use **Skills** When:
- A task requires specific, self-contained knowledge
- You want Claude to automatically discover a capability
- Knowledge should be loaded on-demand, not in every session
- The knowledge is reusable across multiple projects
- **Example:** "Create a custom slash command" → slash-command-builder skill

### Use **Subagents** When:
- You need to delegate work to a specialized expert
- The agent needs restricted tools or isolated context
- Multiple complex steps require different expertise
- You want to reduce main agent context pollution
- **Example:** Create a security-focused subagent for code review

### Use **Slash Commands** When:
- You have a repeated workflow you want to automate
- The workflow requires user arguments or parameterization
- You want single-keystroke access to complex operations
- The command is project-specific or user-specific
- **Example:** `/commit` for AI-assisted git commits

### Use **Hooks** When:
- You want automatic actions on specific events
- Formatting/validation should happen automatically
- You need pre/post-processing of tool execution
- Testing/linting should trigger automatically
- **Example:** Auto-format on file save

### Use **MCP Servers** When:
- You need access to external systems or data
- Information changes frequently and requires real-time access
- You're integrating with APIs, databases, or services
- Context needs current external state
- **Example:** GitHub integration for repo operations

### Use **Output Styles** When:
- You want Claude to adapt its personality for a task type
- Response format needs to change (teaching vs. building)
- You want consistent behavior across multiple sessions
- Different user roles need different interaction patterns
- **Example:** "Claude Code Expert" style adapts to learn/plan/implement/troubleshoot modes

## Integration Patterns Matrix

### Pattern: Research → Plan → Execute
1. **Research Phase:** Use subagents to investigate and gather information
2. **Plan Phase:** Output style guides planning and decision-making
3. **Execute Phase:** Slash commands and skills implement the plan

### Pattern: Task Delegation with Expertise
1. **Main Agent:** Coordinates workflow, uses slash commands
2. **Subagent 1:** Security expertise (restricted to audit tools)
3. **Subagent 2:** Performance expertise (restricted to profiling tools)
4. **Integration:** Hooks validate and combine results

### Pattern: Knowledge-Driven Development
1. **Skills:** Load specific Claude Code knowledge on-demand
2. **Subagents:** Create specialized agents using skills as reference
3. **Commands:** Automate creation of new agents/skills/commands
4. **Output Styles:** Adapt teaching vs. implementation modes

## Quick Reference: Available Skills

- **cc-mastery** - You are here! Ecosystem knowledge and decision framework
- **cc-slash-command-builder** - Create custom slash commands with advanced options
- **cc-subagent-architect** - Design and implement specialized subagents
- **cc-hook-designer** - Create automation hooks for lifecycle events
- **cc-mcp-integration** - Configure and integrate MCP servers
- **cc-output-style-creator** - Design custom Claude personalities and response modes
- **cc-skill-builder** - Create and design Claude Code skills with proper structure

## Standard Patterns Across Components

### Timestamped Output Directories

**Standard Format:** `YYYY-MM-DD_HH-MM-SS` (e.g., `2025-10-29_19-30-45`)

All components should use this format for output organization:

**In Slash Commands:**
```bash
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
mkdir -p "outputs/${TIMESTAMP}/category"
```

**In Subagents:**
```yaml
system_prompt: |
  Create timestamped output directory: outputs/YYYY-MM-DD_HH-MM-SS/
  Save all outputs with timestamps for automatic versioning
```

**In Skills:**
```markdown
## Output Organization
1. Create: outputs/YYYY-MM-DD_HH-MM-SS/
2. Benefits: Automatic versioning, audit trails, easy comparison
```

**Benefits:**
- Never overwrite previous outputs
- Audit trail for tracking evolution
- Easy diff between sessions
- Consistent across all tools

### Agent Output Preservation

When orchestrating multiple agents/tools, preserve complete outputs:

**Critical Rule:** Write agent responses COMPLETE and UNMODIFIED to separate files

**Pattern:**
```
outputs/<timestamp>/
├── agent1.md (complete, unmodified output)
├── agent2.md (complete, unmodified output)
├── agent3.md (complete, unmodified output)
└── summary.md (orchestrator's consolidation)
```

**Implementation:**
- Slash commands: Write agent outputs directly to files
- Subagents: Include preservation rules in system_prompt
- Skills: Document output preservation in instructions

### Variable Declaration Standards

All components with parameters should document variables:

**In Slash Commands:**
```markdown
## Variables
- **FEATURE_NAME**: $1 or "default"
  - Description of variable
  - Used by: [list consumers]
  - Pattern: [validation rules]
```

**In Subagents:**
```yaml
system_prompt: |
  Variables passed to you:
  - TOPIC: The research topic (from $1)
  - DEPTH: shallow | deep (from $2, default: shallow)
```

**In Skills:**
```markdown
## Input Parameters
Document all expected inputs and their formats
```

### Execution Report Template

**Standard completion report format:**

```
✅ Command/Agent: [name]
📁 Output: outputs/YYYY-MM-DD_HH-MM-SS/
📊 Success: X/Y tasks completed
⏱️  Duration: Xm Ys

### Outputs Generated
- ✅ file1.md (1234 tokens)
- ✅ file2.md (5678 tokens)
- ❌ file3.md (failed: reason)

### Next Steps
- Review outputs at: [path]
- Run [next-command] to continue
```

Use across:
- Multi-agent slash commands
- Orchestrator subagents
- Research/analysis skills

## Best Practices

### Skill Design
- Keep skills focused on single concepts (one skill = one decision)
- Use descriptive names that indicate when to use the skill
- Include decision criteria in the description field
- Link to full documentation for progressive disclosure

### Subagent Design
- Give subagents single, well-defined responsibilities
- Write descriptive system prompts explaining the agent's expertise
- Restrict tools to what the agent actually needs
- Use consistent naming: `[role]-[domain]` (e.g., `security-auditor`)

### Slash Command Design
- Use imperative naming: `/command-verb-noun` (e.g., `/git-commit-ai`)
- Support argument interpolation for flexibility
- Include helpful argument hints in frontmatter
- Keep commands under 100 lines for maintainability

### Hook Strategy
- Use `PreToolUse` hooks for validation, `PostToolUse` for cleanup
- Keep hook scripts fast and focused
- Use matchers to target specific conditions
- Document security implications

### MCP Integration
- Load MCP servers only when needed
- Use environment variables for secrets
- Implement proper error handling
- Test connectivity before deployment

### Output Style Application
- Use output styles for consistent task adaptation
- Combine with subagents for specialized workflows
- Document when each style activates
- Test transitions between styles

## Architecture Decision Records (ADRs)

### ADR-1: Skills Over Documentation
**Decision:** Load knowledge via skills instead of monolithic documentation.
**Rationale:** Progressive disclosure reduces session context while maintaining accessibility.
**Tradeoff:** Slight learning curve vs. massive token savings.

### ADR-2: Unified Output Style
**Decision:** Single adaptive output style instead of multiple personalities.
**Rationale:** One style with adaptive modes is simpler to manage and maintain than four separate styles.
**Tradeoff:** Requires smart context detection, but eliminates mode-switching friction.

### ADR-3: Tool Restriction Pattern
**Decision:** Subagents restrict tools by default.
**Rationale:** Reduces hallucination risk and improves delegation reliability.
**Tradeoff:** Requires careful frontmatter planning.

## Description Best Practices

Descriptions are your primary lever for controlling skill/agent invocation. Claude uses descriptions to decide when to trigger your component. Make them specific, keyword-rich, and action-oriented.

### Key Principles

**1. Be Specific and Action-Oriented**
- Describe WHAT it does + WHEN to use it + TRIGGER KEYWORDS
- Front-load critical terms at the beginning
- Include domain-specific terminology users will naturally use

```yaml
# Good - specific and discoverable
description: Ecosystem decision framework. Use for ANY questions about Claude Code components, architecture decisions, when to use skills/subagents/slash commands/hooks/MCP/output styles, best practices, or tradeoffs.

# Bad - vague, won't trigger reliably
description: Helps with Claude Code questions
```

**2. Include Trigger Scenarios**
- List specific situations when to invoke
- Use phrases like "Use when...", "Use for..."
- Match natural language users will employ

```yaml
# Good - triggers are explicit
description: Use when deciding between components, comparing tradeoffs, analyzing architecture decisions, or building Claude Code systems

# Bad - triggers are implicit
description: Knows about Claude Code ecosystem
```

**3. Pack Keywords for Discoverability**
- Include technology/pattern names
- Add common task phrases
- Reference related concepts

```yaml
# Good - rich keyword density
description: Skills, subagents, slash commands, hooks, MCP, output styles decision framework. Use when choosing components, integration patterns, architecture decisions, best practices, or design tradeoffs.

# Bad - sparse keywords
description: Component selection
```

**4. Use "MUST BE USED" for Critical Skills**
- Signals high-priority invocation
- Use when skill covers essential knowledge

```yaml
# Optional - for core skills like mastery
description: MUST BE USED for ANY Claude Code ecosystem questions...
```

### For Your cc-* Skills

Each skill should include:
- **Component focus** (subagents, slash commands, hooks, etc.)
- **Trigger keywords** (create, design, build, troubleshoot, compare)
- **Use cases** (automation, delegation, workflow, etc.)
- **Relationship to other components** (vs subagents, vs commands, etc.)

### Structure Template

```yaml
description: [COMPONENT TYPE] for [PRIMARY USE CASE]. Use when:
  - Specific trigger condition 1
  - Specific trigger condition 2
  - Comparison pattern (vs other component)
  - Real-world use case
```

## References

For detailed information, see:
- Slash Commands Guide: `~/.claude/skills/cc-slash-command-builder/SKILL.md`
- Subagents Guide: `~/.claude/skills/cc-subagent-architect/SKILL.md`
- Hooks Guide: `~/.claude/skills/cc-hook-designer/SKILL.md`
- MCP Integration: `~/.claude/skills/cc-mcp-integration/SKILL.md`
- Output Styles: `~/.claude/skills/cc-output-style-creator/SKILL.md`
- Full Documentation: `documentation/claude/claude-code-docs/`

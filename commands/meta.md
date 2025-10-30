---
description: Manage Claude Code configuration areas (skills, agents, commands, docs, hooks, settings, mcps). Routes to appropriate skills. Use --ask for readonly, --user-level (default) or --project-level for scope.
argument-hint: <area> <description> [--ask] [--user-level|--project-level]
---

# Meta Configuration Manager

**Area:** $1
**Request:** $2
**Flags:** $3 $4

## Configuration Area Routing

Based on the area "$1", I'll route to the appropriate skill and configuration location:

### Area Mapping

- **general** (or unrecognized area) → cc-mastery (ecosystem guidance, decision framework, best practices)
- **skills** → cc-skill-builder (primary), cc-slash-command-builder (for command-invoking skills), cc-subagent-architect (for agent-based skills), or direct skill editing
- **agents** → cc-subagent-architect
- **commands** → cc-slash-command-builder
- **documentation** → Direct documentation management
- **scripts** → Bash script management in ~/.claude/scripts/
- **status_line** → statusline-setup agent
- **hooks** → cc-hook-designer
- **CLAUDE** → CLAUDE.md editing (global or project)
- **settings** → settings.json management
- **mcps** → cc-mcp-integration + ~/.claude.json management
- **output-styles** → cc-output-style-creator

### Scope Detection

- **Default:** User-level (~/.claude/)
- **--user-level:** Explicitly ~/.claude/
- **--project-level:** ./.claude/ in current directory
- **Special cases:**
  - mcps: ~/.claude.json (user) or ./.mcp.json (project)
  - settings: ~/.claude/settings.json (user) or ./.claude/settings.json (project)

### Mode Detection

- **--ask flag present:** Read-only mode (gather info, explain, no edits)
- **No --ask flag:** Edit mode (make changes based on description)

## Execution

Let me determine the configuration area and appropriate action:

**Step 1: Parse Arguments**
- Area: "$1"
- Description: "$2"
- Mode: $3 $4 contains "--ask" ? readonly : edit
- Scope: $3 $4 contains "--project-level" ? project : user

**Step 2: Validate Area**
Recognized areas: skills, agents, commands, documentation, scripts, status_line, hooks, CLAUDE, settings, mcps, output-styles, general

If area is not recognized or empty, default to "general" (cc-mastery).

**Step 3: Route to Appropriate Skill**

Based on area "$1", I'll invoke the appropriate skill(s):

**For "general" area (or unrecognized/empty area):**
- Invoke `cc-mastery` skill for ecosystem guidance
- Provides: decision frameworks, best practices, component selection
- Use when: asking "which should I use", "best practice", "how does X work"

**For "skills" area:**
- First, invoke `cc-skill-builder` skill for skill creation/design guidance
- Then apply the specific request: "$2"

**For other recognized areas:**
- Route to the appropriate skill as mapped above
- Execute the request: "$2"

---

## Implementation Notes

This command acts as a meta-interface for all Claude Code configuration. It:

1. **Intelligently routes** to the right skill based on area
2. **Respects scope** (user vs project level)
3. **Handles mode** (readonly --ask vs edit)
4. **Validates inputs** before execution
5. **Provides context** about what will be modified

### Example Usage

```bash
# General Claude Code questions (defaults to cc-mastery)
/meta general "which should I use: skill or subagent for code review?"
/meta "what's the best practice for organizing outputs?" # No area = general

# Edit user-level skill
/meta skills "add instructions for creating slash commands that invoke skills to cc-slash-command-builder"

# Ask about agents (readonly)
/meta agents "how do I create an agent that auto-reviews TypeScript changes?" --ask

# Edit project-level commands
/meta commands "create a /test-api command that runs integration tests" --project-level

# Manage MCP servers at user level
/meta mcps "add gemini-cli with proper environment variable setup"

# Update hooks
/meta hooks "create a hook that runs tests after Edit tool usage"

# Edit CLAUDE.md
/meta CLAUDE "add a section about preferred testing patterns" --project-level
```

### Skill Invocation Pattern

When invoking skills, I will:
1. Load the appropriate skill using the Skill tool
2. Pass your description as context
3. Handle scope and mode appropriately
4. Provide clear feedback about what was changed

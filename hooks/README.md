# Claude Code Hooks

## Available Hooks

### frontend-command-auto-spawn.md
**Purpose:** Automatically spawn agents in frontend commands

**When it applies:**
- Running `/frontend-add`, `/frontend-fix`, `/frontend-new`, `/frontend-improve`
- When the command contains `**Spawn @agent-name with mission:**` sections

**What it does:**
- Claude automatically detects `@agent-name` patterns
- Maps them to actual agent types (code-scout → Explore, etc.)
- Spawns agents using the Task tool
- Groups parallel agents in single calls
- Waits for results before proceeding

**You don't need to do anything** - Claude handles this automatically when processing these commands.

## How to Use Hooks

Hooks in this directory are read by Claude during execution to guide behavior. They work alongside the global CLAUDE.md configuration.

### Adding New Hooks
1. Create a `.md` or `.js` file in this directory
2. Follow the naming pattern: `{command}-{behavior}.{ext}`
3. Document the hook's purpose, trigger, and behavior
4. Claude will recognize and apply it

### Hook File Format
- **Markdown (.md)**: Configuration and behavioral guide
- **JavaScript (.js)**: Active pre-processing (if needed)

## Current Configuration

**CLAUDE.md:**
- Documents the auto-spawn pattern
- Explains agent detection and execution
- Maps agent aliases to agent types

**frontend-command-auto-spawn.md:**
- Detailed behavioral hook
- Step-by-step execution guide
- Agent type mapping table
- Example walkthrough

This combination ensures frontend commands work end-to-end without user intervention at each phase.

# Claude Code `/tools` Command

A comprehensive slash command that lists all available tools and capabilities in your Claude Code environment, including MCP servers, Agent Skills, Subagents, Slash Commands, Hooks, Plugins, and Output Styles.

## Features

✨ **Comprehensive Discovery**: Automatically discovers all tool types across your environment  
🎯 **Category Filtering**: Focus on specific tool categories with optional arguments  
📊 **Clear Organization**: Well-structured output with summaries and statistics  
🔍 **Progressive Disclosure**: Efficient token usage by loading only what's needed  
💡 **Actionable Insights**: Includes tips and next steps for each category  

## Installation

### Option 1: Personal (User-Level)

Install for all your projects:

```bash
# Create user commands directory if it doesn't exist
mkdir -p ~/.claude/commands

# Copy the tools.md file
cp tools.md ~/.claude/commands/tools.md
```

### Option 2: Project-Specific

Install for a specific project:

```bash
# From your project root
mkdir -p .claude/commands

# Copy the tools.md file
cp tools.md .claude/commands/tools.md

# Commit to version control to share with team
git add .claude/commands/tools.md
git commit -m "Add /tools discovery command"
```

### Verification

After installation, restart Claude Code or start a new session. You can verify the command is available:

```bash
/help
```

You should see `/tools` listed in the available commands.

## Usage

### Basic Usage

List all available tools across all categories:

```bash
/tools
```

### Category Filtering

Filter by specific category:

```bash
/tools mcps        # List only MCP servers
/tools skills      # List only Agent Skills
/tools agents      # List only Subagents
/tools commands    # List only Slash Commands
/tools hooks       # List only Hooks
/tools plugins     # List only Plugins
/tools styles      # List only Output Styles
/tools system      # List only built-in system commands
```

## What It Discovers

### 🔌 MCP Servers
- Connected Model Context Protocol servers
- Available tools and prompts from each server
- Connection details (HTTP/SSE/stdio)

### 🎓 Agent Skills
- Project skills (`.claude/skills/`)
- User skills (`~/.claude/skills/`)
- Public skills (like pdf, docx, pptx, xlsx)
- Custom domain expertise packages

### 🤖 Subagents
- Specialized autonomous assistants
- Project agents (`.claude/agents/`)
- User agents (`~/.claude/agents/`)
- Tool permissions and models

### ⚡ Slash Commands
- Project commands (`.claude/commands/`)
- User commands (`~/.claude/commands/`)
- Namespaced commands (from subdirectories)
- MCP-provided commands

### 🪝 Hooks
- PreToolUse, PostToolUse, Notification, Stop
- Configured automation triggers
- Shell commands and scripts

### 🧩 Plugins
- Installed plugin packages
- Plugin-provided commands, agents, skills
- Enabled/disabled status

### 🎨 Output Styles
- Built-in styles (efficient, explanatory, teaching)
- Custom project styles
- User-defined personalities

### ⚙️ System Commands
- Built-in Claude Code commands
- Core functionality reference

## Example Output

Here's what you might see when running `/tools`:

```markdown
# Available Tools in Claude Code

## MCP Servers (2 found)

### github (global)
**Type:** MCP Server (http)
**URL:** https://mcp.github.com
**Tools:** 12 tools for GitHub operations

### supabase (project)  
**Type:** MCP Server (stdio)
**Tools:** Database operations

---

## Agent Skills (4 found)

### pdf (public)
**Description:** PDF manipulation toolkit
**Location:** /mnt/skills/public/pdf/

### custom-analysis (project)
**Description:** Custom data analysis workflows
**Location:** .claude/skills/custom-analysis/

---

## Subagents (3 found)

### code-reviewer (project)
**Description:** Expert code review specialist
**Tools:** Read, Grep, Glob, Bash

---

## Slash Commands (12 found)

### /commit (user)
**Description:** Create conventional git commits
**Arguments:** [message]

### /workflows:feature-development (project)
**Description:** Multi-agent feature workflow

---

## Summary
**Total Tools:** 21
- MCP Servers: 2
- Skills: 4
- Agents: 3
- Commands: 12

## Next Steps
- Add MCP servers: `/mcp add`
- Create commands in `.claude/commands/`
```

## Technical Stack Compatibility

This command works perfectly with your tech stack:

- **Vue 3/Astro**: Use with your frontend projects
- **TypeScript**: Fully compatible with TS projects
- **Node/Appwrite**: Works with serverless function development
- **Cloudflare**: Compatible with Workers/Pages projects

## Advanced Usage

### Integrating with Your Workflow

**For Vue/Astro Projects:**
```bash
# Discover available tools before starting
/tools

# Find Vue-specific commands
/tools commands

# Check for frontend-related skills
/tools skills
```

**For API Development:**
```bash
# List MCP servers for API testing
/tools mcps

# Find database-related skills
/tools skills
```

**For CI/CD:**
```bash
# Check available hooks for automation
/tools hooks

# List deployment-related commands
/tools commands
```

### Creating Custom Categories

You can extend this command by:

1. **Adding new tool types** to the discovery process
2. **Creating wrapper commands** for specific use cases
3. **Combining with other commands** for workflows

Example wrapper command (`/my-stack`):
```markdown
---
name: my-stack
description: Show tools relevant to Vue/Astro/TypeScript stack
---

Run the tools command and filter for relevant categories:
/tools mcps
/tools skills

Then suggest Vue/Astro/TS specific MCPs or skills to install.
```

## Troubleshooting

### Command Not Showing Up

1. **Check Installation Path:**
   ```bash
   ls ~/.claude/commands/tools.md
   # or
   ls .claude/commands/tools.md
   ```

2. **Verify File Format:**
   - Must be `.md` extension
   - Must have YAML frontmatter
   - Must have `description` in frontmatter

3. **Restart Claude:**
   - Exit current session
   - Start new session: `claude`

### Permission Issues

If you see permission errors:

```bash
# Make sure directories are accessible
chmod 755 ~/.claude/commands
chmod 644 ~/.claude/commands/tools.md
```

### No Tools Found

If command returns empty results:

1. **Check Directory Structure:**
   ```bash
   ls -la ~/.claude/
   ls -la .claude/
   ```

2. **Initialize Directories:**
   ```bash
   mkdir -p ~/.claude/{commands,agents,skills,output-styles}
   mkdir -p .claude/{commands,agents,skills,output-styles}
   ```

## Contributing

Found a bug or want to add a feature? Here's how:

1. **Report Issues**: Describe what went wrong
2. **Suggest Features**: Propose new tool categories to discover
3. **Submit Improvements**: Enhance the discovery logic

## Related Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/)
- [MCP Servers](https://docs.claude.com/en/docs/claude-code/mcp)
- [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills)
- [Subagents](https://docs.claude.com/en/docs/claude-code/subagents)
- [Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands)

## Version History

### v1.0.0 (2025-10-22)
- Initial release
- Support for all major tool categories
- Category filtering
- Comprehensive documentation

## License

Feel free to use, modify, and distribute this command as needed.

---

**Note for Mac Users (2019 Mac Pro):** This command works perfectly on macOS. All paths use Unix-style conventions compatible with your system.

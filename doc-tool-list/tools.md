---
name: tools
description: List all available tools (MCPs, skills, agents, commands, hooks, plugins, output styles) with optional category filtering
argument-hint: [category]
allowed-tools: Read, Bash
---

# Tools Discovery Command

Comprehensive listing of all available tools and capabilities in your Claude Code environment.

## Usage

```bash
/tools                    # List all tools across all categories
/tools system            # List only built-in system commands
/tools mcps              # List only MCP servers
/tools skills            # List only Agent Skills
/tools agents            # List only subagents
/tools commands          # List only slash commands
/tools hooks             # List only hooks
/tools plugins           # List only installed plugins
/tools styles            # List only output styles
/tools all               # Same as no argument (list everything)
```

## Instructions

### Step 1: Parse Arguments

Check the value of `$ARGUMENTS`:
- If empty or "all": Show ALL categories
- Otherwise: Show only the specified category

Valid categories: `system`, `mcps`, `skills`, `agents`, `commands`, `hooks`, `plugins`, `styles`

### Step 2: Display Header

```
╔════════════════════════════════════════════════════════════════╗
║              CLAUDE CODE TOOLS DIRECTORY                       ║
║              Current Environment Capabilities                   ║
╚════════════════════════════════════════════════════════════════╝
```

### Step 3: Discover and Display Tools by Category

#### 📋 BUILT-IN SYSTEM COMMANDS (category: system)

Show if `$ARGUMENTS` is empty, "all", or "system":

```
📋 BUILT-IN SYSTEM COMMANDS
────────────────────────────────────────────────────────────────
Core Claude Code slash commands:

Session Management:
  /help         - Show all available slash commands
  /clear        - Clear conversation history
  /context      - View current context usage
  /compact      - Compact conversation history
  /checkpoint   - Create conversation checkpoint
  /resume       - Resume previous session

Project & Configuration:
  /init         - Initialize new project context
  /model        - Switch between Claude models
  /permissions  - View/modify tool permissions
  /hooks        - Configure lifecycle hooks interactively
  
Tool Management:
  /agents       - Manage subagents
  /skills       - Manage agent skills
  /plugin       - Manage plugins
  /mcp          - Manage MCP servers

Run `/help` for complete list and details
```

#### 🔌 MCP SERVERS (category: mcps)

Show if `$ARGUMENTS` is empty, "all", or "mcps":

1. Run this command:
```bash
claude mcp list
```

2. If that command is not available, check these locations:
```bash
# Project MCP config
cat .mcp.json 2>/dev/null

# Global MCP config (macOS)
cat ~/.config/claude/mcp.json 2>/dev/null
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json 2>/dev/null

# Global MCP config (Linux)  
cat ~/.config/claude/claude_desktop_config.json 2>/dev/null
```

3. For each MCP server found, display:
```
🔌 MCP SERVERS (X active)
────────────────────────────────────────────────────────────────
✓ [server-name] (scope: project|user)
  Transport: [stdio|http|sse]
  Command: [command if stdio]
  URL: [url if http]
  Status: Connected | Disconnected
  Tools: X tools available
  Prompts: Y prompts (invoke as /mcp__servername__promptname)
  
[Repeat for each server]

💡 Add MCP servers: claude mcp add <name> [args]
📖 Browse servers: https://github.com/modelcontextprotocol/servers
```

#### 🎯 AGENT SKILLS (category: skills)

Show if `$ARGUMENTS` is empty, "all", or "skills":

1. Run this command first:
```bash
claude skill list
```

2. Also scan the filesystem:
```bash
# Public/built-in skills (if available)
ls -la /mnt/skills/public/ 2>/dev/null | grep -v "^d" | awk '{print $NF}'

# User skills
ls -la ~/.claude/skills/ 2>/dev/null | grep "^d" | awk '{print $NF}' | grep -v "^\."

# Project skills
ls -la .claude/skills/ 2>/dev/null | grep "^d" | awk '{print $NF}' | grep -v "^\."
```

3. For each skill directory found, try to read `SKILL.md`:
```bash
# Example for a skill named "pdf"
head -20 ~/.claude/skills/pdf/SKILL.md 2>/dev/null | grep -E "^(name:|description:)"
```

4. Display:
```
🎯 AGENT SKILLS (X available)
────────────────────────────────────────────────────────────────
📦 [skill-name] (scope: public|user|project)
   Description: [from SKILL.md frontmatter]
   Location: [path to SKILL.md]
   Model-invoked: Yes (Claude decides when to use)
   
[Repeat for each skill]

💡 Create skill: mkdir -p ~/.claude/skills/myskill && touch ~/.claude/skills/myskill/SKILL.md
📖 Skill docs: https://docs.claude.com/en/docs/claude-code/skills
🎁 Browse skills: https://github.com/anthropics/skills
```

#### 🤖 SUBAGENTS (category: agents)

Show if `$ARGUMENTS` is empty, "all", or "agents":

1. Run this command first:
```bash
claude agent list
```

2. Also scan the filesystem:
```bash
# User agents
find ~/.claude/agents/ -name "*.md" -type f 2>/dev/null

# Project agents
find .claude/agents/ -name "*.md" -type f 2>/dev/null
```

3. For each agent file, extract frontmatter:
```bash
# Example
head -20 .claude/agents/code-reviewer.md | grep -E "^(name:|description:|tools:|model:)"
```

4. Display:
```
🤖 SUBAGENTS (X configured)
────────────────────────────────────────────────────────────────
👤 [agent-name] (scope: user|project)
   Description: [from frontmatter]
   Allowed tools: [list of tools from frontmatter]
   Model: [model from frontmatter, if specified]
   Location: [path to .md file]
   
[Repeat for each agent]

💡 Create agent: Use `/agents` command or create .md file in .claude/agents/
📖 Agent docs: https://docs.claude.com/en/docs/claude-code/agents
```

#### ⚡ CUSTOM SLASH COMMANDS (category: commands)

Show if `$ARGUMENTS` is empty, "all", or "commands":

1. Scan for command files:
```bash
# User commands
find ~/.claude/commands/ -name "*.md" -type f 2>/dev/null | sort

# Project commands
find .claude/commands/ -name "*.md" -type f 2>/dev/null | sort
```

2. For each command file:
   - Derive the command name from the file path
   - Extract description from frontmatter if available
   - Check for $ARGUMENTS to see if it accepts parameters
   - Note namespace from directory structure

3. Display:
```
⚡ CUSTOM SLASH COMMANDS (X available)
────────────────────────────────────────────────────────────────
/[command-name] (scope: user|project)
  Description: [from frontmatter]
  Arguments: [argument-hint from frontmatter or "none"]
  Location: [path]
  
/[namespace]:[command] (scope: user|project)
  Description: [from frontmatter]
  Arguments: [argument-hint or "none"]
  Location: [path in subdirectory]
  
[Repeat for each command]

💡 Create command: echo "# My Command" > ~/.claude/commands/mycommand.md
📖 Command docs: https://docs.claude.com/en/docs/claude-code/slash-commands
```

#### 🪝 HOOKS (category: hooks)

Show if `$ARGUMENTS` is empty, "all", or "hooks":

1. Check for hooks configuration:
```bash
# Check settings file for hooks
cat .claude/settings.json 2>/dev/null | grep -A 20 "hooks"
cat ~/.claude/settings.json 2>/dev/null | grep -A 20 "hooks"
```

2. Display:
```
🪝 LIFECYCLE HOOKS (X configured)
────────────────────────────────────────────────────────────────
Hook Types:
  PreToolUse:        [configured count]
  PostToolUse:       [configured count]
  PreEditAccepted:   [configured count]
  PostEditAccepted:  [configured count]
  SubagentStart:     [configured count]
  SubagentStop:      [configured count]
  Notification:      [configured count]

[For each configured hook, show:]
  Type: [hook type]
  Matcher: [pattern]
  Action: [command or script]

💡 Configure hooks: Use `/hooks` command for interactive setup
📖 Hook docs: https://docs.claude.com/en/docs/claude-code/hooks
```

#### 🔌 PLUGINS (category: plugins)

Show if `$ARGUMENTS` is empty, "all", or "plugins":

1. Run this command:
```bash
claude plugin list
```

2. If not available, check:
```bash
ls -la .claude-plugin/ 2>/dev/null
cat .claude-plugin/marketplace.json 2>/dev/null
```

3. Display:
```
🔌 INSTALLED PLUGINS (X found)
────────────────────────────────────────────────────────────────
📦 [plugin-name] (status: enabled|disabled)
   Provides: X commands, Y agents, Z skills, W MCP servers
   Marketplace: [marketplace URL if available]
   
[Repeat for each plugin]

💡 Add marketplace: /plugin marketplace add <url>
💡 Install plugin: /plugin install <name>
📖 Plugin docs: https://docs.claude.com/en/docs/claude-code/plugins
```

#### 🎨 OUTPUT STYLES (category: styles)

Show if `$ARGUMENTS` is empty, "all", or "styles":

1. Check for output style files:
```bash
# User styles
ls -la ~/.claude/output-styles/ 2>/dev/null

# Project styles
ls -la .claude/output-styles/ 2>/dev/null
```

2. Check if ccoutputstyles tool is installed:
```bash
which ccoutputstyles 2>/dev/null
```

3. Display:
```
🎨 OUTPUT STYLES (X available)
────────────────────────────────────────────────────────────────
Built-in Styles:
  - efficient       (Fast, direct coding assistant)
  - explanatory     (Teaching mode with insights)
  - concise         (Minimal, to-the-point responses)

[If custom styles found:]
Custom Styles:
  📝 [style-name] (scope: user|project)
     Location: [path]
     Description: [from frontmatter if available]

[If ccoutputstyles is installed:]
ccoutputstyles: ✓ Installed
  Run `ccoutputstyles` for template gallery

💡 Create style: Create .md file in .claude/output-styles/
📦 Get ccoutputstyles: npm install -g ccoutputstyles
```

### Step 4: Summary Statistics

Display a summary at the end:

```
╔════════════════════════════════════════════════════════════════╗
║                         SUMMARY                                 ║
╚════════════════════════════════════════════════════════════════╝

Total Capabilities: X items
├─ Built-in Commands: X
├─ MCP Servers: X (Y connected)
├─ Agent Skills: X
├─ Subagents: X
├─ Slash Commands: X
├─ Hooks: X
├─ Plugins: X
└─ Output Styles: X

📖 Full Documentation: https://docs.claude.com/en/docs/claude-code/
💬 Community: https://github.com/hesreallyhim/awesome-claude-code
```

### Step 5: Error Handling

If `$ARGUMENTS` contains an invalid category:
```
❌ Unknown category: $ARGUMENTS

Valid categories:
  • system    - Built-in Claude Code commands
  • mcps      - Model Context Protocol servers
  • skills    - Agent Skills (model-invoked capabilities)
  • agents    - Subagents (specialized AI agents)
  • commands  - Custom slash commands
  • hooks     - Lifecycle hooks
  • plugins   - Installed plugins
  • styles    - Output styles
  • all       - Everything (default)

Usage: /tools [category]
```

## Implementation Notes

- **Graceful Degradation**: If a CLI command like `claude mcp list` fails, fall back to filesystem inspection
- **Privacy**: Don't expose sensitive data like API keys or tokens from config files
- **Performance**: Use simple commands and avoid expensive operations
- **Caching**: Results can be cached briefly if the command is called multiple times
- **Format**: Use Unicode box characters and emojis for visual appeal, but keep it readable
- **Actionability**: Include "💡" tips for how to add more tools in each category

## Examples of Expected Behavior

### Example 1: List Everything
```bash
> /tools
# Shows all categories with full details
```

### Example 2: List Only MCP Servers
```bash
> /tools mcps
# Shows only the MCP SERVERS section
```

### Example 3: Invalid Category
```bash
> /tools xyz
# Shows error message with valid categories
```

## Key Features

✅ **Comprehensive**: Covers all major tool types in Claude Code
✅ **Organized**: Clear categorization and visual hierarchy  
✅ **Actionable**: Includes tips for adding more tools
✅ **Resilient**: Falls back to filesystem checks if CLI commands unavailable
✅ **Filterable**: Optional category argument for focused results
✅ **Well-documented**: Links to official documentation
✅ **User-friendly**: Clear formatting with emojis and box characters

This command serves as a "map" of your Claude Code environment, helping you discover and utilize all available capabilities!

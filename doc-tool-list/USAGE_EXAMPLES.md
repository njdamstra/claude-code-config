# `/tools` Command - Usage Examples

## Scenario 1: New Project Setup

**Situation:** You're starting a new Vue 3 + Astro project and want to see what tools are available.

```bash
# Start Claude Code in your project
claude

# Discover all available tools
/tools

# Check for web development related skills
/tools skills

# See what MCP servers might help with your stack
/tools mcps
```

**What to do next:**
- Install relevant MCP servers (e.g., GitHub, Cloudflare)
- Create project-specific commands for your workflow
- Set up hooks for auto-formatting TypeScript/Vue files

---

## Scenario 2: Finding the Right Tool

**Situation:** You remember there's a command for git commits but can't remember the exact name.

```bash
# List all slash commands
/tools commands

# The output shows:
# ### /commit (user)
# **Description:** Create conventional git commits
```

**Now you can use it:**
```bash
/commit
```

---

## Scenario 3: Debugging Missing Features

**Situation:** Someone mentioned a cool MCP server for Supabase but you're not sure if it's installed.

```bash
# Check MCP servers
/tools mcps

# Output shows what's installed:
# - github (global)
# - brave-search (global)
# (No Supabase found)

# Now you know to install it
/mcp add supabase
```

---

## Scenario 4: Team Onboarding

**Situation:** A new team member joins and needs to know what custom tools your team uses.

```bash
# From your project root
/tools

# They'll see:
# - Project-specific commands (commit workflow, deploy helpers)
# - Custom subagents (your team's code reviewer)
# - Project skills (your custom analysis tools)
# - Configured hooks (auto-formatting, linting)
```

This gives them a complete picture of your team's Claude Code setup!

---

## Scenario 5: Optimizing Your Workflow

**Situation:** You want to know what automation you have available for TypeScript projects.

```bash
# Check hooks for automatic formatting
/tools hooks

# Output might show:
# ### PostToolUse: TypeScript Formatting
# **Matcher:** Write(*.ts)
# **Command:** prettier --write "$file"

# Check for TypeScript-related skills
/tools skills

# Check for relevant subagents
/tools agents
```

---

## Scenario 6: Before a Big Refactor

**Situation:** You're about to start a major refactoring and want to make sure you have all the right tools.

```bash
# Full audit of available tools
/tools

# Verify you have:
# ✓ Code review subagent
# ✓ Testing automation
# ✓ Git workflow commands
# ✓ Linting hooks

# Missing something? Add it before starting
```

---

## Scenario 7: Using with Appwrite/Cloudflare

**Situation:** You're working on serverless functions and want to see what's available for your stack.

```bash
# Check for Cloudflare integration
/tools mcps
# Look for: cloudflare MCP server

# Check for serverless-related commands
/tools commands
# Look for: deploy, function-scaffold, etc.

# Check for API-related skills
/tools skills
# Look for: API testing, deployment, monitoring
```

---

## Scenario 8: Daily Standup Prep

**Situation:** Quick check of what tools you used yesterday.

```bash
# See all your custom commands
/tools commands

# Review your workflow automations
/tools hooks

# Check which agents are available for today's work
/tools agents
```

---

## Scenario 9: Comparing Environments

**Situation:** You have different setups on different machines and want to see the differences.

**On Machine 1:**
```bash
/tools > ~/tools-machine1.md
```

**On Machine 2:**
```bash
/tools > ~/tools-machine2.md
```

Now you can compare and sync your setups!

---

## Scenario 10: Plugin Discovery

**Situation:** You installed some plugins but aren't sure what they added.

```bash
# Check all plugins
/tools plugins

# Output shows:
# ### claude-code-essentials (enabled)
# **Provides:** 10 commands, 3 agents, 2 skills

# Now check what commands they added
/tools commands

# New commands from the plugin will be listed!
```

---

## Quick Reference

### Common Filters

```bash
/tools mcps      # Find API integrations
/tools skills    # Find specialized capabilities  
/tools agents    # Find automation helpers
/tools commands  # Find workflow shortcuts
/tools hooks     # Find automatic behaviors
/tools plugins   # Find installed packages
/tools styles    # Find personality modes
/tools system    # Find built-in commands
```

### When to Use Each Filter

| Category | Use When |
|----------|----------|
| `mcps` | Setting up API integrations, database connections |
| `skills` | Looking for domain expertise (PDF, Excel, etc.) |
| `agents` | Delegating specialized tasks |
| `commands` | Creating efficient workflows |
| `hooks` | Automating repetitive actions |
| `plugins` | Installing/managing tool bundles |
| `styles` | Changing Claude's behavior/tone |
| `system` | Learning Claude Code basics |

---

## Pro Tips

### 1. Run `/tools` at the Start of Each Session
Get a quick overview of your available capabilities before diving in.

### 2. Combine with `/help`
```bash
/help      # See all slash commands
/tools     # Get detailed info about each
```

### 3. Document Your Setup
```bash
/tools > my-claude-setup.md
```
Keep this in your project repo or dotfiles!

### 4. Check Before Installing
Before adding a new MCP or plugin:
```bash
/tools    # Make sure you don't already have it
```

### 5. After Installing New Tools
```bash
# Restart Claude Code, then verify
/tools [category]
```

---

## Integration with Your Stack

### For Vue 3 / Astro Projects

```bash
# Morning routine:
/tools mcps       # Check API connections
/tools hooks      # Verify auto-formatting is on
/tools commands   # See available Vue helpers

# During development:
/commit          # From your commands
/test            # From your commands
/deploy          # From your commands
```

### For TypeScript Projects

```bash
# Verify TS tooling:
/tools hooks      # Check for TS linting/formatting
/tools skills     # Look for TS-specific skills
/tools agents     # Find type-checking agents
```

### For Appwrite Projects

```bash
# Check serverless setup:
/tools mcps       # Look for Appwrite/database MCPs
/tools commands   # Find function scaffolding commands
/tools agents     # Find deployment agents
```

---

## Troubleshooting with `/tools`

### Problem: "Command not found"
**Solution:**
```bash
/tools commands   # List all commands
# If not there, check installation paths
```

### Problem: "Agent not responding"
**Solution:**
```bash
/tools agents     # Verify agent is configured
# Check the agent's tool permissions
```

### Problem: "Hook not running"
**Solution:**
```bash
/tools hooks      # See configured hooks
# Verify the matcher pattern and command
```

---

## Next Steps After Running `/tools`

1. **Missing tools?** Install them
   - MCPs: `/mcp add [server]`
   - Plugins: `/plugin install [plugin]`

2. **Have ideas?** Create them
   - Commands: Add to `.claude/commands/`
   - Agents: Add to `.claude/agents/`
   - Skills: Add to `.claude/skills/`

3. **Want automation?** Configure it
   - Hooks: Use `/hooks` command
   - Permissions: Use `/permissions` command

4. **Share with team?** Commit them
   ```bash
   git add .claude/
   git commit -m "Add Claude Code configuration"
   ```

# MCP Context Optimization Guide

## The Problem

MCP tools consume significant context window space even when not actively used:
- Chrome DevTools MCP: ~20.6k tokens (10.3% of 200k context)
- Gemini CLI MCP: ~6k tokens (3% of 200k context)
- **Total MCP overhead in your setup: 20.6k tokens**

This context pollution affects the main Claude Code conversation, reducing available space for actual work.

## Current Limitations

Based on research of Claude Code documentation and GitHub issues:

1. **No agent-scoped MCP configuration** (Issue #4476 - 98 upvotes, still open)
2. **No selective tool loading** (Issue #7328 - open feature request)
3. **Agents inherit ALL MCP tools** when tools field is omitted
4. **Global MCP servers load in every conversation** regardless of need

## Official Best Practice

From Claude Code docs:
> "Only grant tools that are necessary for the subagent's purpose. This improves security and helps the subagent focus on relevant actions."

The `tools` field in agent configuration:
- **If omitted**: Agent inherits ALL tools including ALL MCP tools
- **If specified**: Agent gets only the listed tools

## Workaround Solutions

### Solution 1: Explicit Tool Allowlisting (RECOMMENDED)

**Strategy**: Remove Chrome DevTools from global config, keep it project-scoped, and explicitly list MCP tools only in specialized agents.

**Implementation:**

```bash
# Remove from global/user scope
claude mcp remove --scope user chrome-devtools

# Add to project scope ONLY when needed
cd /path/to/project
claude mcp add chrome-devtools npx -- -y chrome-devtools-mcp
```

**Update chrome-master agent** to explicitly list tools (already done):
```yaml
tools: Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, TodoWrite, WebFetch, WebSearch,
  mcp__chrome-devtools__click, mcp__chrome-devtools__drag, [etc...]
```

**Benefits:**
- Main conversations have 0 Chrome DevTools context overhead
- Chrome-master agent still has full access when invoked
- Works in projects where `.claude.json` includes chrome-devtools
- Context savings: 20.6k tokens (10.3%) back to main agent

**Drawbacks:**
- Must configure chrome-devtools per-project
- Can't use chrome-devtools in main conversation
- Need to remember to add MCP to relevant projects

---

### Solution 2: Project-Scoped MCP Configuration

**Strategy**: Use project scope for specialized MCP servers, user scope only for universal tools.

**Decision Matrix:**

| MCP Server | Scope | Reason |
|------------|-------|--------|
| gemini-cli | user | Universal AI assistant, useful everywhere |
| chrome-devtools | project | Heavy context cost, specific use cases |
| playwright | project | Testing-specific, not needed globally |
| postgres | project | Project-specific database connection |
| github-docs | user | Documentation research, generally useful |

**Implementation:**

Create `.claude.json` in projects that need chrome-devtools:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp"],
      "env": {}
    }
  }
}
```

**Benefits:**
- Clear separation: universal tools vs specialized tools
- Main agent context pollution minimized
- Teams can share project-scoped MCP configs via git
- Context savings in non-browser projects: 20.6k tokens

**Drawbacks:**
- Must configure per-project
- `.claude.json` files need management (gitignore with secrets)
- May forget to add MCP when starting new projects

---

### Solution 3: Minimal Tool Selection for Agents

**Strategy**: Use the `/agents` interactive interface to selectively grant only essential tools.

**Process:**

1. Run `/agents` in Claude Code
2. Select the agent to configure
3. Choose "Edit tools"
4. Uncheck unnecessary MCP tools
5. Save configuration

**Example for a code-review agent:**

```yaml
# Before (inherits everything)
tools: [omitted]

# After (minimal set)
tools: Bash, Read, Grep, Glob, Write
# No MCP tools needed for code review
```

**Benefits:**
- Fine-grained control per agent
- Interactive UI makes it easy
- Reduces agent context pollution
- Improves agent focus and performance

**Drawbacks:**
- Tedious for agents with many tools
- Must maintain manually
- Still doesn't solve main conversation pollution

---

### Solution 4: Hybrid Approach (BEST FOR YOUR USE CASE)

**Strategy**: Combine project scoping + explicit agent tools + selective global MCPs.

**Configuration:**

1. **Global/User Scope** (lightweight, universal tools):
   ```bash
   # Keep only lightweight, universally useful MCPs
   claude mcp add --scope user gemini-cli npx gemini-mcp-tool --env GEMINI_API_KEY=xxx
   claude mcp add --scope user github-docs npx -- -y @modelcontextprotocol/server-github
   ```

2. **Remove heavy MCPs from global**:
   ```bash
   claude mcp remove --scope user chrome-devtools
   ```

3. **Project Templates** for different types of work:

   **Web Performance Project** (`.claude.json`):
   ```json
   {
     "mcpServers": {
       "chrome-devtools": {
         "type": "stdio",
         "command": "npx",
         "args": ["-y", "chrome-devtools-mcp"]
       }
     }
   }
   ```

   **Browser Testing Project** (`.claude.json`):
   ```json
   {
     "mcpServers": {
       "chrome-devtools": {...},
       "playwright": {
         "type": "stdio",
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-playwright"]
       }
     }
   }
   ```

4. **Specialized Agents** with explicit tools:
   - chrome-master: Lists all chrome-devtools MCP tools
   - browser-automation: Lists all playwright MCP tools
   - gemini-helper: Lists gemini-cli MCP tools
   - Most other agents: NO MCP tools

**Benefits:**
- Main conversation: minimal context overhead
- Specialized agents: full tool access when needed
- Project-specific: heavy MCPs only where relevant
- Context savings: 15-20k tokens in typical projects

**Drawbacks:**
- More complex initial setup
- Need project templates or scripts
- Some manual configuration per project type

---

## Implementation for Your Setup

### Immediate Action Plan

```bash
# 1. Remove chrome-devtools from global
claude mcp remove --scope user chrome-devtools

# 2. Keep gemini-cli global (it's lighter)
# (already configured)

# 3. Create project template directory
mkdir -p ~/.claude/templates
```

Create `~/.claude/templates/browser-perf.claude.json`:
```json
{
  "mcpServers": {
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp"],
      "env": {}
    }
  }
}
```

### Usage Pattern

When starting a project that needs Chrome DevTools:

```bash
cd /path/to/project
cp ~/.claude/templates/browser-perf.claude.json .claude.json
# Now chrome-master agent can access chrome-devtools MCP
```

For regular development work:
```bash
cd /path/to/normal-project
# No .claude.json needed
# Main conversation has full 200k context available
# chrome-master agent won't work (as intended)
```

---

## Context Savings Analysis

### Before Optimization (Current)
```
System prompt:    2.3k tokens (1.1%)
System tools:    16.4k tokens (8.2%)
MCP tools:       20.6k tokens (10.3%)  ← Problem
Custom agents:    2.1k tokens (1.0%)
Memory files:     0.6k tokens (0.3%)
Messages:        15.7k tokens (7.9%)
Free space:     142.0k tokens (71.2%)
```

### After Optimization (Hybrid Approach)
```
System prompt:    2.3k tokens (1.1%)
System tools:    16.4k tokens (8.2%)
MCP tools:        6.0k tokens (3.0%)   ← gemini-cli only
Custom agents:    2.1k tokens (1.0%)
Memory files:     0.6k tokens (0.3%)
Messages:        15.7k tokens (7.9%)
Free space:     156.6k tokens (78.3%)  ← +14.6k tokens
```

**Recovered: 14.6k tokens (7.3% of total context)**

---

## Advanced: MCP Configuration Automation

### Shell Function for Quick Setup

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Quick add chrome-devtools to current project
claude-add-chrome() {
  cat > .claude.json <<'EOF'
{
  "mcpServers": {
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp"],
      "env": {}
    }
  }
}
EOF
  echo "✓ Chrome DevTools MCP added to .claude.json"
}

# Quick add playwright to current project
claude-add-playwright() {
  cat > .claude.json <<'EOF'
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"],
      "env": {}
    }
  }
}
EOF
  echo "✓ Playwright MCP added to .claude.json"
}
```

Usage:
```bash
cd /path/to/project
claude-add-chrome
# Now chrome-master agent works in this project
```

---

## Slash Command Integration

Create `.claude/commands/enable-chrome.md`:

```markdown
---
name: enable-chrome
description: Enable Chrome DevTools MCP for current project
---

Create a .claude.json file in the current project directory with chrome-devtools MCP configuration:

{
  "mcpServers": {
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp"],
      "env": {}
    }
  }
}

After creating this file, the chrome-master agent will have access to all Chrome DevTools Protocol tools.
```

Usage in Claude Code:
```
/enable-chrome
```

---

## Measuring Context Usage

Monitor your context usage with:

```bash
# In Claude Code
/context
```

Compare before/after removing global chrome-devtools MCP.

---

## Future Improvements

### When Agent-Scoped MCP Arrives (Issue #4476)

If/when Anthropic implements agent-scoped MCP:

```yaml
# Ideal future state
name: chrome-master
tools: inherit  # Gets base tools
mcp_servers:    # Agent-specific MCP config
  - chrome-devtools
model: haiku-4.5
```

This would:
- Keep chrome-devtools out of main conversation
- Auto-load only when chrome-master agent is invoked
- Zero configuration per-project

### When Selective Tool Loading Arrives (Issue #7328)

If/when selective tool filtering is implemented:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp"],
      "allowedTools": [
        "take_screenshot",
        "performance_start_trace",
        "performance_stop_trace",
        "list_console_messages"
      ]
    }
  }
}
```

This would reduce chrome-devtools from 26 tools to 4 tools, saving ~15k tokens.

---

## Recommendations

### For Your Use Case

**Immediate (Today):**
1. Remove chrome-devtools from global: `claude mcp remove --scope user chrome-devtools`
2. Create project template: `~/.claude/templates/browser-perf.claude.json`
3. Copy template to projects needing browser automation

**Medium-term (This Month):**
1. Audit all agents and add explicit `tools` field
2. Remove MCP tools from agents that don't need them
3. Create slash commands for common MCP enablement patterns

**Long-term (Ongoing):**
1. Monitor GitHub issues #4476 and #7328 for updates
2. Periodically review `/context` to identify new context bloat
3. Keep lightweight MCPs global, heavy ones project-scoped

---

## Summary

**The Core Problem**: Global MCP servers load in every conversation, consuming context even when unused.

**The Best Solution**: Hybrid approach with:
- Global scope for lightweight, universal MCPs (gemini-cli)
- Project scope for heavy, specialized MCPs (chrome-devtools)
- Explicit tool allowlisting in agent configurations
- Template-based project setup for common scenarios

**Expected Results**:
- 7-15% context recovery in main conversations
- Specialized agents still fully functional
- Better performance and focus for all agents
- Cleaner separation of concerns

**Trade-offs**:
- More initial configuration work
- Per-project MCP setup for specialized tools
- Need to maintain project templates

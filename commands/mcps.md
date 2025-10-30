---
description: Manage MCP servers with preset bundles and individual control
argument-hint: <action:list|info|add|remove|config|audit|validate> [target] [scope]
allowed-tools: [Bash]
---

# MCP Server Management

Manage your MCP servers using preset bundles or individual server controls.

## Actions Available
- **list** - Show all configured servers and presets
- **info** - Get details about a server or preset
- **add** - Add server(s) to your configuration
- **remove** - Remove server(s) from configuration
- **config** - Edit MCP registry (shows guidance for Claude Code to edit ~/.claude/mcp-servers-config.json)
- **audit** - Security check for hardcoded secrets
- **validate** - Validate configuration file syntax

## Usage

Execute the MCP management script with your arguments. If no arguments provided, defaults to 'list':

```bash
if [ -z "$ARGUMENTS" ]; then
    ~/.claude/scripts/mcp-act.sh list
else
    ~/.claude/scripts/mcp-act.sh "$ARGUMENTS"
fi
```

After execution, explain what was done and show any relevant information to the user.

## Examples

When the user provides arguments, pass them directly to the script:

- `/mcps list` → Lists all servers and presets
- `/mcps add preset:webdev` → Adds web development preset
- `/mcps add gemini-cli user` → Adds Gemini CLI with user scope
- `/mcps add gemini user` → Adds using alias (gemini → gemini-cli)
- `/mcps info preset:ui` → Shows UI preset details
- `/mcps info chrome` → Shows info using alias (chrome → chrome-devtools)
- `/mcps config` → Shows guidance for editing the MCP registry
- `/mcps audit` → Checks for security issues
- `/mcps validate` → Validates configuration file
- `/mcps remove playwright` → Removes playwright server

## Notes

The script handles all validation, including:
- Environment variable checks before adding servers
- Security auditing for hardcoded secrets
- Error handling for failed operations
- Preset resolution to individual servers
- Alias resolution (use short names like `gemini` instead of `gemini-cli`)

## Environment Variable Setup (IMPORTANT!)

**Critical:** Claude Code does not automatically source `~/.zshrc` or `~/.bashrc`. When adding servers that require environment variables:

### Method 1: Add to Shell Profile (Recommended for Persistence)
```bash
# Add to ~/.zshrc (or ~/.bashrc)
echo 'export API_KEY_NAME="your-api-key-here"' >> ~/.zshrc

# Then FULLY RESTART Claude Code (Cmd+Q, then reopen)
# This is required for Claude Code to pick up the new environment variable
```

### Method 2: Inline Export (Quick Testing)
```bash
# Use inline export for immediate testing without restart
export API_KEY_NAME="your-key" && /mcps add server-name user
```

### Common Issues:
- ❌ **Adding to `~/.zshrc` but not restarting Claude Code** → Script validation fails
- ❌ **Restarting just the terminal session** → Not enough, need full app restart (Cmd+Q)
- ✅ **Add to `~/.zshrc` + Full Claude Code restart** → Environment variable available
- ✅ **Inline export before running `/mcps add`** → Works immediately for testing

### Verify Environment Variables:
```bash
# Check if variable is set in current session
echo $API_KEY_NAME

# Check if variable is in your shell profile
cat ~/.zshrc | grep API_KEY_NAME

# Audit all MCP-related environment variables
/mcps audit
```

### Special Action: config

When the user runs `/mcps config`, the script displays guidance and instructions. You should then:
1. Read the file at `~/.claude/mcp-servers-config.json`
2. Help the user add or edit MCP server entries
3. Ensure proper JSON structure with required fields (name, description, command, args)
4. Use `${VAR}` references for environment variables (never hardcode secrets)
5. Add aliases for convenient shortcuts
6. After editing, suggest running `/mcps validate` to check the configuration

Display the script output and provide context about what was configured.

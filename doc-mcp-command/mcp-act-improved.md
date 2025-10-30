---
description: Manage MCP servers with preset bundles and individual control
argument-hint: <action> [target] [scope]
allowed-tools: [Bash]
---

# MCP Server Management

Manage your MCP servers using preset bundles or individual server controls.

## Actions Available
- **list** - Show all configured servers and presets
- **info** - Get details about a server or preset
- **add** - Add server(s) to your configuration
- **remove** - Remove server(s) from configuration
- **audit** - Security check for hardcoded secrets
- **validate** - Validate configuration file syntax

## Usage

Execute the MCP management script with your arguments:

```bash
~/.local/bin/mcp-act $ARGUMENTS
```

After execution, explain what was done and show any relevant information to the user.

## Examples

When the user provides arguments, pass them directly to the script:

- `/mcp-act list` → Lists all servers and presets
- `/mcp-act add preset:webdev` → Adds web development preset
- `/mcp-act add gemini-cli user` → Adds Gemini CLI with user scope
- `/mcp-act info preset:ui` → Shows UI preset details
- `/mcp-act audit` → Checks for security issues
- `/mcp-act remove playwright` → Removes playwright server

## Notes

The script handles all validation, including:
- Environment variable checks before adding servers
- Security auditing for hardcoded secrets
- Error handling for failed operations
- Preset resolution to individual servers

Display the script output and provide context about what was configured.

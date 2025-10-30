---
description: "Manage MCP servers with presets and quick actions"
allowed-tools: ["bash", "str_replace", "view", "create_file"]
---

# MCP Server Management with Presets

Manage your MCP servers quickly with preset bundles and individual actions.

## Usage
/mcp-act <action> [server-name|preset-name] [scope]

**Actions:**
- `add` - Add server(s) to configuration
- `remove` - Remove server(s) from configuration  
- `list` - List all configured servers
- `enable` - Enable server(s) (via config edit)
- `disable` - Disable server(s) (via config edit)
- `info` - Show preset or server details

**Arguments:**
- `server-name|preset-name` - Name of individual server or preset (e.g., `gemini-cli`, `preset:webdev`)
- `scope` - Either `project` or `user` (defaults to `project`)

## Configuration File Location
The servers are configured in: `/home/claude/.mcp-servers-config.json`

## Available Presets

### preset:webdev
Web development essentials: firecrawl, playwright, chrome-devtools

### preset:ui
UI/Component tools: tailwind-css, shadcn, figma-to-react

### preset:ai-assist  
AI collaboration: gemini-cli, sequential-thinking

### preset:full-stack
Everything: All servers from webdev + ui + ai-assist

## Execution Steps

1. **Read the configuration file** at `/home/claude/.mcp-servers-config.json`
2. **Parse the action and arguments**:
   - Extract action (add/remove/list/etc)
   - Determine if it's a preset (starts with `preset:`) or individual server
   - Get scope (project/user, default: project)
3. **Execute the appropriate action**:
   - For `add`: Add the server(s) using `claude mcp add` or edit config directly
   - For `remove`: Use `claude mcp remove` (with fallback to manual config edit)
   - For `list`: Show all servers with `claude mcp list`
   - For `enable/disable`: Edit the ~/.claude.json file to comment/uncomment servers
   - For `info`: Display server configuration details
4. **Handle errors gracefully** and provide clear feedback

## Important Notes

- Always use absolute paths in configurations
- For API keys, use environment variables when possible
- The `claude mcp add` command has known bugs with `remove` - may need to edit ~/.claude.json directly
- Presets can be combined: `/mcp-act add preset:webdev gemini-cli`
- Run `/mcp` after configuration changes to verify servers are connected

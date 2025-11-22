# MCP Server Configuration Guide

This guide explains how to add and manage Model Context Protocol (MCP) servers in Claude Code at different scopes.

## Configuration Scopes

Claude Code supports three configuration scopes for MCP servers:

- **local**: Project-specific (current directory only)
- **user**: Global/user-level (applies to all projects)
- **project**: Project workspace level

## Adding MCP Servers

### Global/User Scope (All Projects)

Use the `--scope user` flag to add an MCP server globally:

```bash
claude mcp add --scope user <server-name> <command> [args...]
```

**Examples:**

```bash
# Gemini CLI (with API key)
claude mcp add --scope user gemini-cli npx gemini-mcp-tool --env GEMINI_API_KEY=your_key_here

# Chrome DevTools
claude mcp add --scope user chrome-devtools npx -- -y chrome-devtools-mcp

# GitHub Docs (with token)
claude mcp add --scope user github-docs npx -- -y @modelcontextprotocol/server-github --env GITHUB_PERSONAL_ACCESS_TOKEN=your_token_here
```

### Local/Project Scope (Single Project)

Omit the `--scope` flag or use `--scope local` for project-specific configuration:

```bash
claude mcp add <server-name> <command> [args...]
```

**Examples:**

```bash
# Add Playwright for browser automation (project-specific)
claude mcp add playwright npx -- -y @modelcontextprotocol/server-playwright

# Add Puppeteer (project-specific)
claude mcp add puppeteer npx -- -y @modelcontextprotocol/server-puppeteer

# Add filesystem server for specific project
claude mcp add filesystem npx -- -y @modelcontextprotocol/server-filesystem --env ALLOWED_DIRECTORIES=/path/to/project
```

## Environment Variables

Add environment variables using the `--env` flag:

```bash
claude mcp add --scope user <server-name> <command> --env KEY=value --env ANOTHER_KEY=value -- [args...]
```

**Example:**

```bash
claude mcp add --scope user postgres npx @modelcontextprotocol/server-postgres \
  --env POSTGRES_CONNECTION_STRING=postgresql://user:pass@localhost:5432/db -- -y
```

## Command Argument Separator

When passing arguments that start with `-` to the MCP server command, use `--` to separate them:

```bash
claude mcp add <server-name> <command> -- <args-with-dashes>
```

**Example:**

```bash
# Correct: Uses -- to separate -y flag
claude mcp add chrome-devtools npx -- -y chrome-devtools-mcp

# Incorrect: Would try to parse -y as claude command flag
claude mcp add chrome-devtools npx -y chrome-devtools-mcp
```

## Managing MCP Servers

### List All Servers

```bash
claude mcp list
```

Shows health status and connection state for all configured servers.

### Remove a Server

```bash
# Remove from current scope (local by default)
claude mcp remove <server-name>

# Remove from specific scope
claude mcp remove --scope user <server-name>
```

### Check Configuration

View the raw configuration:

```bash
# User scope configuration
cat ~/.claude.json | jq '.mcpServers'

# Project scope configuration
cat .claude.json | jq '.mcpServers'
```

## Configuration Files

- **User scope**: `~/.claude.json` or `/Users/username/.claude.json`
- **Local/Project scope**: `./.claude.json` (in project directory)

## Common MCP Servers

### Development Tools

```bash
# Chrome DevTools Protocol
claude mcp add --scope user chrome-devtools npx -- -y chrome-devtools-mcp

# Playwright Browser Automation
claude mcp add playwright npx -- -y @modelcontextprotocol/server-playwright

# Puppeteer Browser Automation
claude mcp add puppeteer npx -- -y @modelcontextprotocol/server-puppeteer
```

### AI & APIs

```bash
# Gemini CLI
claude mcp add --scope user gemini-cli npx gemini-mcp-tool --env GEMINI_API_KEY=your_key

# GitHub (requires PAT)
claude mcp add --scope user github-docs npx -- -y @modelcontextprotocol/server-github \
  --env GITHUB_PERSONAL_ACCESS_TOKEN=your_token
```

### Data & Databases

```bash
# PostgreSQL
claude mcp add postgres npx @modelcontextprotocol/server-postgres \
  --env POSTGRES_CONNECTION_STRING=postgresql://localhost:5432/db -- -y

# SQLite
claude mcp add sqlite npx @modelcontextprotocol/server-sqlite -- -y
```

### File Operations

```bash
# Filesystem (restricted to specific directories)
claude mcp add filesystem npx @modelcontextprotocol/server-filesystem \
  --env ALLOWED_DIRECTORIES=/path/to/dir1,/path/to/dir2 -- -y
```

## Best Practices

### When to Use User Scope

Use `--scope user` for:
- Development tools you use across all projects (Chrome DevTools, Playwright)
- AI/API integrations with personal API keys (Gemini, GitHub)
- Common utilities needed everywhere

### When to Use Local/Project Scope

Use local scope (default) for:
- Project-specific database connections
- Tools that require project-specific configuration
- Security-sensitive servers that shouldn't be global
- Testing new MCP servers before making them global

### Security Considerations

- Never commit `.claude.json` files containing API keys or tokens
- Add `.claude.json` to `.gitignore` for project-specific configurations
- Use environment variables for sensitive data
- User-scope configuration in `~/.claude.json` is automatically private

## Troubleshooting

### Server Fails to Connect

1. Check the command is correct: `claude mcp list`
2. Verify the package exists: `npx -y <package-name> --version`
3. Check for missing environment variables
4. Ensure proper use of `--` separator for command arguments

### Server Shows as Disconnected

- The server may require environment variables (API keys, tokens)
- The command syntax may be incorrect
- The package may not be installed or available via npx

### Removing and Re-adding

If a server isn't working, try:

```bash
claude mcp remove <server-name>
claude mcp add --scope user <server-name> <command> [args...]
claude mcp list  # Verify connection
```

## Examples from This Setup

### Gemini CLI (User Scope)

```bash
claude mcp add --scope user gemini-cli npx gemini-mcp-tool \
  --env GEMINI_API_KEY=${GEMINI_API_KEY}
```

Result in `~/.claude.json`:
```json
{
  "mcpServers": {
    "gemini-cli": {
      "type": "stdio",
      "command": "npx",
      "args": ["gemini-mcp-tool"],
      "env": {
        "GEMINI_API_KEY": "AIzaSyAWNiGGAljfd2RlB7HHot1YkqcvY7T8B_4"
      }
    }
  }
}
```

### Chrome DevTools (User Scope)

```bash
claude mcp add --scope user chrome-devtools npx -- -y chrome-devtools-mcp
```

Result in `~/.claude.json`:
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

## Further Reading

- [MCP Documentation](https://modelcontextprotocol.io/)
- [Claude Code MCP Guide](https://docs.claude.com/claude-code)
- [Available MCP Servers](https://github.com/modelcontextprotocol/servers)

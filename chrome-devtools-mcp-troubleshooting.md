# Chrome DevTools MCP Troubleshooting Guide

## Issue Summary

**Date:** 2025-10-16
**Status:** ✅ Resolved
**Duration:** ~2 hours of debugging

### Problem
The `chrome-devtools-mcp` server was failing to connect to Claude Code with the error:
```
chrome-devtools: npx -y chrome-devtools-mcp@latest - ✗ Failed to connect
```

### Root Cause
**Incorrect MCP Configuration Format** - The MCP server configuration had the command and arguments combined into a single string instead of being properly separated.

**Incorrect Configuration:**
```json
{
  "type": "stdio",
  "command": "npx -y chrome-devtools-mcp@latest --logFile /tmp/chrome-devtools-mcp.log",
  "args": [],
  "env": {}
}
```

**Correct Configuration:**
```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "chrome-devtools-mcp@latest"],
  "env": {}
}
```

## What We Tried (and what didn't work)

### ❌ Attempted Solutions That Failed:
1. **Starting Chrome with remote debugging** - Chrome was running fine on port 9222, but this wasn't the issue
2. **Using `--browserUrl` flag** - Added unnecessary complexity
3. **Using `--isolated` flag** - Would create temporary Chrome instance
4. **NPM cache cleaning** - `npm cache clean --force` didn't resolve the issue
5. **Upgrading NPM** - Went from v10.9.3 to v11.6.2 (good practice but didn't fix the connection)
6. **Trying alternative package** - `@benjaminr/chrome-devtools-mcp` doesn't exist on npm
7. **Adding debug logging** - `--logFile` flag helped identify that MCP was starting, but not connecting

### ✅ What Actually Fixed It:
**Properly formatting the MCP configuration** by separating the command from its arguments in the `~/.claude.json` file.

## Prerequisites for Success

Before configuring chrome-devtools-mcp, ensure:

1. **Node.js version** ≥ v22.12.0
   ```bash
   node --version  # Should show v22.12.0 or higher
   ```

2. **NPM version** ≥ v11.6.2 (recommended)
   ```bash
   npm --version  # Upgrade with: npm install -g npm@latest
   ```

3. **Chrome installed** (current stable version or newer)

4. **NPM health check**
   ```bash
   npm doctor  # Verify all checks pass
   ```

## Correct Installation Process

### Method 1: Manual Configuration (Recommended)

1. **Edit `~/.claude.json` directly:**
   ```bash
   # Open in your editor
   code ~/.claude.json
   ```

2. **Add the MCP server configuration:**
   ```json
   {
     "mcpServers": {
       "chrome-devtools": {
         "type": "stdio",
         "command": "npx",
         "args": ["-y", "chrome-devtools-mcp@latest"],
         "env": {}
       }
     }
   }
   ```

3. **Restart Claude Code**

### Method 2: Using Claude CLI

**⚠️ WARNING:** The `claude mcp add` command may not properly separate arguments. If using this method, verify the configuration manually afterward.

```bash
# Add the MCP
claude mcp add --scope user chrome-devtools "npx -y chrome-devtools-mcp@latest"

# Verify the configuration
cat ~/.claude.json | jq '.mcpServers["chrome-devtools"]'

# If args are empty, manually fix the configuration using Method 1
```

## Verification Steps

After installation:

1. **Check MCP health:**
   ```bash
   claude mcp list
   ```

   Should show:
   ```
   chrome-devtools: npx -y chrome-devtools-mcp@latest - ✓ Connected
   ```

2. **Test in Claude Code:**
   - Restart Claude Code
   - Tools like `mcp__chrome-devtools__list_pages` should be available
   - Try navigating to a URL and taking a screenshot

## Prevention: How to Avoid This Issue in the Future

### 1. Always Verify MCP Configuration Format
After adding any MCP server, verify the configuration:
```bash
cat ~/.claude.json | jq '.mcpServers["YOUR_MCP_NAME"]'
```

**Check for:**
- ✅ `command` is a single executable (e.g., `"npx"`, `"python"`, `"node"`)
- ✅ `args` is an array with all arguments separated
- ❌ Command does NOT contain spaces or multiple arguments

### 2. Prefer Manual Configuration for Complex MCPs
For MCPs with multiple flags or arguments, manually edit `~/.claude.json` rather than using `claude mcp add`.

### 3. Test MCP Independently
Before adding to Claude Code, test the MCP runs correctly:
```bash
npx -y chrome-devtools-mcp@latest --help
```

### 4. Enable Debug Logging During Setup
Add debug flags temporarily to diagnose issues:
```json
{
  "args": ["-y", "chrome-devtools-mcp@latest", "--logFile", "/tmp/mcp-debug.log"]
}
```

Set environment variable:
```json
{
  "env": {
    "DEBUG": "*"
  }
}
```

### 5. Check System Requirements First
Before debugging connection issues, verify:
- [ ] Node.js version meets minimum requirements
- [ ] NPM is up to date
- [ ] `npm doctor` shows all green
- [ ] MCP package installs and runs independently

## Common Pitfalls

### Pitfall 1: Combining Command and Args
```json
❌ "command": "npx -y chrome-devtools-mcp@latest"
✅ "command": "npx", "args": ["-y", "chrome-devtools-mcp@latest"]
```

### Pitfall 2: Using Absolute Paths Incorrectly
```json
❌ "command": "/usr/local/bin/npx -y chrome-devtools-mcp"
✅ "command": "/usr/local/bin/npx", "args": ["-y", "chrome-devtools-mcp"]
```

### Pitfall 3: Forgetting to Restart
Changes to `~/.claude.json` require a Claude Code restart to take effect.

### Pitfall 4: Assuming CLI Command Works Correctly
The `claude mcp add` command may create incorrect configurations. Always verify manually.

## Troubleshooting Checklist

If chrome-devtools-mcp fails to connect:

- [ ] Verify Node.js ≥ v22.12.0: `node --version`
- [ ] Verify NPM ≥ v11.6.2: `npm --version`
- [ ] Run `npm doctor` - all checks should pass
- [ ] Test MCP independently: `npx -y chrome-devtools-mcp@latest --help`
- [ ] Check configuration format: `cat ~/.claude.json | jq '.mcpServers["chrome-devtools"]'`
- [ ] Ensure `command` and `args` are properly separated
- [ ] Restart Claude Code after configuration changes
- [ ] Check `claude mcp list` for connection status

## Additional Resources

- **Official Repo:** https://github.com/ChromeDevTools/chrome-devtools-mcp
- **NPM Package:** https://www.npmjs.com/package/chrome-devtools-mcp
- **Chrome DevTools Protocol:** https://chromedevtools.github.io/devtools-protocol/
- **Issue Tracker:** https://github.com/ChromeDevTools/chrome-devtools-mcp/issues/182

## Final Working Configuration

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "env": {}
    }
  }
}
```

**Note:** The MCP will automatically start Chrome when needed. You don't need to pre-start Chrome with debugging ports unless using `--browserUrl` for a specific use case.

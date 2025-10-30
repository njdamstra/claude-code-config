# Gemini CLI settings.json - Chrome DevTools Configuration

## Full Example Configuration

Save this as `~/.gemini/settings.json`:

```json
{
  "theme": "GitHub",
  "selectedAuthType": "oauth-personal",
  "checkpointing": {
    "enabled": true
  },
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000
    }
  }
}
```

## If You Already Have Other MCP Servers

Just add chrome-devtools to your existing `mcpServers` object:

```json
{
  "theme": "your-theme",
  "selectedAuthType": "your-auth",
  "mcpServers": {
    "your-existing-server": {
      "command": "your-command",
      "args": ["your-args"]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000
    }
  }
}
```

## Multiple Heavy MCP Servers (Recommended)

Configure ALL heavy MCPs in Gemini CLI, keep Claude Code lean:

```json
{
  "theme": "GitHub",
  "selectedAuthType": "oauth-personal",
  "checkpointing": {
    "enabled": true
  },
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000,
      "trust": false
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"],
      "timeout": 60000,
      "trust": false
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"],
      "timeout": 60000,
      "trust": false
    }
  }
}
```

## Advanced: With Tool Filtering

Limit which tools Gemini can use (reduces context even in Gemini):

```json
{
  "theme": "GitHub",
  "selectedAuthType": "oauth-personal",
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000,
      "includeTools": [
        "navigate",
        "screenshot",
        "console_log",
        "performance_start_trace",
        "performance_stop_trace",
        "network_log"
      ],
      "trust": false
    }
  }
}
```

## With Auto-Approval (Use Carefully!)

Skip confirmation prompts for trusted servers:

```json
{
  "theme": "GitHub",
  "selectedAuthType": "oauth-personal",
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000,
      "trust": true
    }
  }
}
```

⚠️ **Warning:** `trust: true` bypasses ALL confirmation prompts. Only use for servers you completely control.

## Configuration Options Reference

```json
{
  "mcpServers": {
    "server-name": {
      // Required
      "command": "npx",              // Command to start server
      "args": ["..."],                // Arguments for command
      
      // Optional
      "timeout": 60000,               // Request timeout (ms), default 600000
      "trust": false,                 // Auto-approve tools, default false
      "cwd": "/path/to/dir",          // Working directory
      "env": {                        // Environment variables
        "API_KEY": "${YOUR_API_KEY}"
      },
      "includeTools": ["tool1"],      // Whitelist specific tools
      "excludeTools": ["tool2"]       // Blacklist specific tools
    }
  }
}
```

## Environment Variables

Reference environment variables in your config:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

Then set in your shell:

```bash
export GITHUB_TOKEN="ghp_your_token_here"
```

## Complete Real-World Example

```json
{
  "theme": "GitHub",
  "selectedAuthType": "oauth-personal",
  "checkpointing": {
    "enabled": true
  },
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": [
        "-y", 
        "chrome-devtools-mcp@latest",
        "--headless=true",
        "--isolated=true"
      ],
      "timeout": 60000,
      "trust": false,
      "includeTools": [
        "navigate",
        "screenshot",
        "console_log",
        "performance_start_trace",
        "performance_stop_trace",
        "network_log"
      ]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      },
      "timeout": 30000,
      "trust": false
    }
  },
  "mcp": {
    "allowed": ["chrome-devtools", "github"]
  }
}
```

## Global MCP Settings

Control which servers load:

```json
{
  "mcpServers": {
    "chrome-devtools": { ... },
    "playwright": { ... },
    "puppeteer": { ... }
  },
  "mcp": {
    "allowed": ["chrome-devtools"],     // Only load these
    "excluded": ["puppeteer"]           // Never load these
  }
}
```

## Installation Steps

1. **Find your config file:**
   ```bash
   # macOS/Linux
   ~/.gemini/settings.json
   
   # Windows
   %USERPROFILE%\.gemini\settings.json
   ```

2. **Create if doesn't exist:**
   ```bash
   mkdir -p ~/.gemini
   touch ~/.gemini/settings.json
   ```

3. **Edit the file:**
   ```bash
   code ~/.gemini/settings.json
   # or
   vim ~/.gemini/settings.json
   # or
   nano ~/.gemini/settings.json
   ```

4. **Paste your configuration**

5. **Restart Gemini CLI** (if it was running)

6. **Verify:**
   ```bash
   gemini
   /mcp
   
   # Should show chrome-devtools as CONNECTED
   ```

## Testing Your Configuration

After configuring, test in Gemini CLI:

```bash
# Start Gemini CLI
gemini

# Check MCP status
/mcp

# Test chrome-devtools
Please check the LCP of https://web.dev

# If successful, gemini will:
# - Launch Chrome
# - Navigate to the URL
# - Run performance trace
# - Analyze LCP
# - Return results
```

## Quick Copy-Paste

**Minimal configuration** (add to existing or create new):

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000
    }
  }
}
```

That's it! You're ready to use gemini-cli as your MCP router in Claude Code.

---
name: CC MCP Integration
description: MUST BE USED for connecting Claude Code to external systems via Model Context Protocol (MCP) servers for real-time data access. Use when integrating GitHub (repos, PRs, issues), Slack (messages, channels), databases (queries, schemas), or custom internal APIs. Handles MCP server setup, tool definitions, authentication (tokens, credentials), data transformations, and decision-making with fresh context. Provides ready-to-use servers: GitHub MCP (fetch repos, create issues), Slack MCP (read messages), database connections. Troubleshoots connection failures, permissions, data freshness. Use for "MCP", "external data", "GitHub integration", "Slack", "database access", "real-time", "API integration".
version: 2.0.0
tags: [claude-code, mcp, model-context-protocol, external-integration, github, slack, databases, api-integration, real-time-data, authentication, data-transformation, server-setup]
---

# CC MCP Integration

## Quick Start

MCP (Model Context Protocol) servers connect Claude Code to external systems and APIs. They provide tools for accessing real-time data like GitHub repositories, databases, Slack workspaces, or custom services.

### Minimal MCP Configuration
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"]
    }
  }
}
```

### File Location
Add MCP servers to `~/.claude/settings.json` under `mcpServers` object.

### Configuration Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `command` | Yes | Executable to run (npx, python, node, etc) |
| `args` | No | Arguments to pass to command |
| `env` | No | Environment variables for server |

## Core Concepts

### What is MCP?

MCP (Model Context Protocol) is a standardized interface that lets Claude:
1. Discover what tools a server provides
2. Call remote tools through the server
3. Access real-time external data

**Examples:**
- GitHub MCP: access repos, PRs, issues in real-time
- Slack MCP: read channels, messages, user info
- Database MCP: query databases, run migrations
- Custom MCP: integrate your own APIs

### MCP vs Skills vs Subagents

| Aspect | MCP Server | Skill | Subagent |
|--------|-----------|-------|----------|
| **Access** | External data | Local knowledge | Specialized AI |
| **Updates** | Real-time | Static (session) | Real-time reasoning |
| **Example** | "Get latest GitHub issues" | "How to create a PR" | "Security auditor" |
| **When** | Current data needed | Reference knowledge | Decision-making |

## Common MCP Servers

### GitHub MCP
Real-time access to GitHub repositories, PRs, issues, commits.

**Setup:**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {
        "GITHUB_TOKEN": "your-token-here"
      }
    }
  }
}
```

**Provides Tools:**
- List repositories
- Get repository details
- List pull requests
- Get PR details and reviews
- List issues
- Create/update issues
- Comment on PRs/issues

**Example Usage:**
```
"Get all open PRs in my repo"
→ GitHub MCP provides PR data
```

### Slack MCP
Access Slack channels, messages, users, and workspace data.

**Setup:**
```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "slack-mcp"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-token",
        "SLACK_SIGNING_SECRET": "your-signing-secret"
      }
    }
  }
}
```

**Provides Tools:**
- List channels
- Get channel history
- Send messages
- Search messages
- Get user profiles
- List users

**Example Usage:**
```
"Summarize #engineering channel for today"
→ Slack MCP fetches messages and provides context
```

### PostgreSQL MCP
Query PostgreSQL databases directly.

**Setup:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "postgres-mcp"],
      "env": {
        "DATABASE_URL": "postgresql://user:password@localhost:5432/mydb"
      }
    }
  }
}
```

**Provides Tools:**
- Query database (SELECT)
- Execute migrations
- Get schema information
- List tables

**Example Usage:**
```
"What are the top 10 users by activity?"
→ PostgreSQL MCP queries the database
```

### Custom REST API MCP
Build your own MCP for custom APIs.

**Example Structure:**
```javascript
// Simple custom MCP server
const { Server } = require("@modelcontextprotocol/sdk/server/stdio");

const server = new Server({
  name: "my-api",
  version: "1.0.0"
});

server.setRequestHandler(async (request) => {
  if (request.method === "tools/list") {
    return {
      tools: [
        {
          name: "get_user",
          description: "Get user by ID",
          inputSchema: {
            type: "object",
            properties: {
              id: { type: "string" }
            }
          }
        }
      ]
    };
  }
});
```

## Patterns

### Pattern 1: Data Aggregation
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "slack-mcp"],
      "env": {"SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"}
    }
  }
}
```

**Use Case:** Access GitHub and Slack together
- Get PRs from GitHub
- Post PR summaries to Slack channel

### Pattern 2: Real-Time Decision Making
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "postgres-mcp"],
      "env": {"DATABASE_URL": "${DATABASE_URL}"}
    }
  }
}
```

**Use Case:** Query database before making recommendations
- Check current database state
- Analyze patterns
- Make informed decisions

### Pattern 3: Development Context
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    }
  }
}
```

**Use Case:** Understand codebase changes
- Check recent commits
- Review open PRs
- Understand issue context

## Best Practices

### DO: Use Environment Variables for Secrets
```json
// Good - uses env variables
{
  "env": {
    "GITHUB_TOKEN": "${GITHUB_TOKEN}",
    "API_KEY": "${API_KEY}"
  }
}

// Bad - secrets in config
{
  "env": {
    "GITHUB_TOKEN": "ghp_1234567890abcdef"
  }
}
```

### DO: Set Environment Variables Securely
```bash
# Export before running Claude Code
export GITHUB_TOKEN="ghp_your_token_here"
export SLACK_BOT_TOKEN="xoxb_your_token_here"

# Or set in ~/.zshrc or ~/.bashrc
echo 'export GITHUB_TOKEN="..."' >> ~/.zshrc
```

### DO: Test MCP Connection
```bash
# Test if MCP server starts correctly
npx -y github-mcp
# Should output: {"jsonrpc": "2.0", "id": 1, "method": "initialize", ...}
```

### DO: Start with One Server
```json
// Good - single, tested server
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    }
  }
}

// Bad - too many servers at once
{
  "mcpServers": {
    "github": {...},
    "slack": {...},
    "postgres": {...},
    "custom": {...}
  }
}
```

### DON'T: Commit Secrets to Version Control
```bash
# Good - use .env.local or environment variables
GITHUB_TOKEN=... node app.js

# Bad - secrets in git history
echo "GITHUB_TOKEN=ghp_..." >> settings.json
git add settings.json
```

### DON'T: Use Free Tier APIs for Production
```json
// Bad - unreliable for important work
{
  "mcpServers": {
    "api": {
      "command": "npx",
      "args": ["-y", "free-api-mcp"]
    }
  }
}

// Good - production-ready API with SLA
{
  "mcpServers": {
    "api": {
      "command": "npx",
      "args": ["-y", "production-api-mcp"],
      "env": {"API_TIER": "paid"}
    }
  }
}
```

### DON'T: Overload with Too Many Servers
```json
// Bad - too many servers = slower startup
{
  "mcpServers": {
    "github": {...},
    "gitlab": {...},
    "bitbucket": {...},
    "slack": {...},
    "discord": {...},
    "postgres": {...},
    "mysql": {...},
    "redis": {...}
  }
}

// Good - only what you need
{
  "mcpServers": {
    "github": {...},
    "slack": {...},
    "postgres": {...}
  }
}
```

## Advanced Configuration

### Server with Custom Environment
```json
{
  "mcpServers": {
    "my-service": {
      "command": "node",
      "args": ["./mcp-server.js"],
      "env": {
        "NODE_ENV": "production",
        "LOG_LEVEL": "info",
        "API_URL": "https://api.example.com",
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

### Python-Based MCP Server
```json
{
  "mcpServers": {
    "python-service": {
      "command": "python3",
      "args": ["-m", "mcp_server"],
      "env": {
        "PYTHONPATH": "./lib",
        "DB_CONNECTION": "${DB_CONNECTION}"
      }
    }
  }
}
```

### Docker-Based MCP Server
```json
{
  "mcpServers": {
    "docker-service": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "my-mcp-server:latest"],
      "env": {
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

## Troubleshooting

### MCP Server Won't Start
```bash
# Check server command is executable
npx -y github-mcp --help

# Check for missing dependencies
npm list @modelcontextprotocol/sdk

# Test with verbose output
CLAUDE_DEBUG=1 claude-code
```

### Authentication Failed
```bash
# Verify token format and validity
echo $GITHUB_TOKEN
# Should start with ghp_ for personal access token

# Test token with curl
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

### Server Timeout
```json
// Increase timeout if server is slow
{
  "mcpServers": {
    "slow-service": {
      "command": "node",
      "args": ["./server.js"],
      "timeout": 30000  // 30 seconds
    }
  }
}
```

### Permission Denied
```bash
# Ensure script is executable
chmod +x mcp-server.js

# Or specify with node/python explicitly
{
  "command": "node",
  "args": ["./mcp-server.js"]
}
```

## Real-World Examples

### GitHub + Slack Integration
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "slack-mcp"],
      "env": {"SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"}
    }
  }
}
```

**Usage:** Get PR updates and post summaries to Slack

### Database Analysis Setup
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "postgres-mcp"],
      "env": {"DATABASE_URL": "${DATABASE_URL}"}
    }
  }
}
```

**Usage:** Analyze database queries and performance

## Description Best Practices

MCP servers don't have descriptions, but their configuration names and documentation should make their purpose clear and discoverable.

### Key Principles

**1. Use Clear, Service-Specific Names**
- Name servers after the service they integrate
- Make the purpose immediately obvious
- Follow naming convention: `service-name`

```json
// Good - clear what service this is
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"]
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "slack-mcp"]
    }
  }
}

// Bad - unclear purpose
{
  "mcpServers": {
    "api1": {...},
    "service2": {...}
  }
}
```

**2. Document Server Capabilities in Comments**
- Add comments explaining what each server provides
- Show what tools/methods are available
- Explain when to use it

```json
// GitHub Integration - Real-time repo, PR, issue access
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
      // Provides: list repos, get PRs, manage issues, comment on discussions
    }
  }
}

// Slack Integration - Channel and message access
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "slack-mcp"],
      "env": {"SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"}
      // Provides: list channels, get history, send messages, search
    }
  }
}
```

**3. Signal Data vs Execution**
- Make clear whether server reads or writes data
- Show real-time vs cached
- Indicate required permissions

```json
// Read-only - information access
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
      // Read-only: Lists repos, PRs, issues. Does not modify.
    }
  }
}

// Read-write - data modification
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "postgres-mcp"],
      "env": {"DATABASE_URL": "${DATABASE_URL}"}
      // Read-write: Query and modify database. Requires elevated permissions.
    }
  }
}
```

**4. Document Environment Variables**
- Show required vs optional vars
- Explain how to obtain credentials
- Indicate security implications

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {
        // REQUIRED: GitHub personal access token
        // Get at: https://github.com/settings/tokens
        // Needs: repo, read:org scopes
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**5. Include Startup/Connectivity Information**
- Note how to test the server
- Show expected behavior
- Indicate timeout/performance expectations

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "postgres-mcp"],
      "env": {"DATABASE_URL": "${DATABASE_URL}"},
      "timeout": 30000
      // PostgreSQL MCP: Connects to database on startup.
      // Test connectivity: psql $DATABASE_URL -c "SELECT 1"
      // Typical latency: <500ms for queries
      // Max connection pool: 10 connections
    }
  }
}
```

### Configuration Template

```json
{
  "mcpServers": {
    "[service-name]": {
      "command": "[executable]",
      "args": ["[args]"],
      "env": {
        "[REQUIRED_VAR]": "${ENVIRONMENT_VAR}",
        "[OPTIONAL_VAR]": "default-value"
      },
      // Service: [What service this connects to]
      // Purpose: [Real-time data access, API integration, etc]
      // Capabilities: [What operations are supported]
      // Required: [Environment variables or setup needed]
    }
  }
}

Example:
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"},
      // Service: GitHub
      // Purpose: Real-time repo, PR, issue, discussion access
      // Capabilities: List repos, get PRs, manage issues, comment, search
      // Required: GITHUB_TOKEN with repo and read:org scopes
    }
  }
}
```

### Real MCP Server Example

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "github-mcp"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"},
      // GitHub MCP - Real-time repository and PR access
      // Provides: repos, PRs, issues, comments, search
      // Use for: Understanding codebase changes, tracking PRs, managing issues
      // Required: GITHUB_TOKEN (get at https://github.com/settings/tokens)
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "postgres-mcp"],
      "env": {"DATABASE_URL": "${DATABASE_URL}"},
      "timeout": 30000,
      // PostgreSQL MCP - Direct database access
      // Provides: queries, migrations, schema info, table lists
      // Use for: Data analysis, business logic queries, schema exploration
      // Required: DATABASE_URL pointing to PostgreSQL instance
      // Warning: Unrestricted access - be careful with production dbs
    }
  }
}
```

## References

For more information:
- MCP Documentation: https://modelcontextprotocol.io/
- MCP Ecosystem: `documentation/claude/claude-code-docs/3-MCP-MODEL-CONTEXT-PROTOCOL-GUIDE.md`
- Settings Guide: `documentation/claude/claude-code-docs/8-CLAUDE-CODE-SETTINGS-GUIDE.md`
- GitHub MCP: https://github.com/modelcontextprotocol/servers/tree/main/src/github

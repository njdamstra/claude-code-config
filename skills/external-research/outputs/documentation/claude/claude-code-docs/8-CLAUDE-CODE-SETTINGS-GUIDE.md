# Claude Code Settings: Comprehensive Reference Guide

**Author:** Verified from Anthropic Official Documentation + Community Best Practices  
**Last Updated:** October 2025  
**Status:** Single Source of Truth - Complete Technical Reference

---

## TABLE OF CONTENTS

1. [What Are Claude Code Settings](#what-are-claude-code-settings)
2. [File Locations & Hierarchy](#file-locations--hierarchy)
3. [JSON Configuration Structure](#json-configuration-structure)
4. [Permissions Settings](#permissions-settings)
5. [Environment Variables](#environment-variables-in-settings)
6. [Tool Configuration](#tool-configuration)
7. [Session Settings](#session-settings)
8. [Real-World Examples](#real-world-examples)
9. [Troubleshooting & Edge Cases](#troubleshooting--edge-cases)

---

## WHAT ARE CLAUDE CODE SETTINGS?

### Definition

Claude Code settings are JSON-based configuration files that control Claude Code's behavior, permissions, environment variables, and tool access. They provide a way to standardize how Claude Code works across projects and teams.

### Key Characteristics

- **JSON Format**: Standard JSON syntax (no special parsers needed)
- **Hierarchical**: User-level, project-level, and local overrides
- **Team-Shareable**: Can be committed to git for team consistency
- **Runtime Applied**: Takes effect when Claude Code starts
- **Multi-Purpose**: Permissions, env vars, tool config, MCP servers, hooks

### What Settings Control

| Setting | Purpose | Example |
|---------|---------|---------|
| **Permissions** | What Claude can access | Allow/deny file edits |
| **Environment Vars** | System configuration | API keys, paths, flags |
| **Tool Config** | Tool behavior | Git config, npm registry |
| **MCP Servers** | External integrations | GitHub, Slack, databases |
| **Hooks** | Automated actions | Auto-format, lint, test |
| **Model** | Which Claude model | Sonnet, Opus |
| **Plugins** | Extensions | Custom commands, agents |

---

## FILE LOCATIONS & HIERARCHY

### Directory Structure (macOS)

```
Project Root:
.claude/
├── settings.json                    # Committed to git (team settings)
└── settings.local.json              # NOT committed (personal settings)

User Level:
~/.claude/
├── settings.json                    # All projects use this
└── settings.local.json              # User-level personal settings

Enterprise:
~/enterprise-config/
└── settings.json                    # Managed policy (enterprise only)
```

### Settings File Priority (Highest to Lowest)

```
1. .claude/settings.local.json      (Project-local, NOT committed)
2. .claude/settings.json            (Project, committed to git)
3. ~/.claude/settings.json          (User-level, all projects)
4. Enterprise settings              (Organization-wide)
```

Lower priority settings are merged with higher priority.

**Example**:
- User level: `{ "permissions": { "allowed_tools": ["Bash"] } }`
- Project level: `{ "permissions": { "deny": ["*.env"] } }`
- Result: Both rules apply

### File Creation & Setup

```bash
# Create project-level settings
mkdir -p .claude
touch .claude/settings.json

# Configure gitignore
echo ".claude/settings.local.json" >> .gitignore

# Verify gitignore
cat .gitignore | grep "settings.local"

# Create user-level settings (first time)
mkdir -p ~/.claude
touch ~/.claude/settings.json
```

### What to Commit vs Ignore

```bash
# Commit to git (team standards):
.claude/settings.json              # Team rules, permissions, env vars
.claude/commands/                  # Custom commands
.claude/output-styles/             # Team output styles
.claude/skills/                    # Team-shared skills

# Add to .gitignore (personal):
.claude/settings.local.json        # Personal settings, secrets
.claude/.mcp.json                  # MCP auto-generated
```

---

## JSON CONFIGURATION STRUCTURE

### Minimal Settings File

```json
{
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write"]
  }
}
```

### Complete Settings Structure

```json
{
  "version": "1.0.0",
  
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write", "Notebook"],
    "deny": [".env*", "*.key", "node_modules/*"]
  },
  
  "environment": {
    "NODE_ENV": "development",
    "API_KEY": "${API_KEY}",
    "DATABASE_URL": "${DATABASE_URL}"
  },
  
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-github-server"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    }
  },
  
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{"type": "command", "command": "npx prettier --write"}]
      }
    ]
  },
  
  "model": "claude-sonnet-4-20250514",
  
  "enabledPlugins": {
    "formatter": true,
    "deployer": false
  }
}
```

### Field Reference

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `version` | String | No | Config version for tracking | "1.0.0" |
| `permissions` | Object | No | Tool access control | See Permissions section |
| `environment` | Object | No | Environment variables | `{"KEY": "value"}` |
| `mcpServers` | Object | No | External integrations | See MCP section |
| `hooks` | Object | No | Automated actions | See Hooks section |
| `model` | String | No | Claude model to use | "claude-sonnet-4-20250514" |
| `enabledPlugins` | Object | No | Plugin toggles | `{"pluginName": true}` |

---

## PERMISSIONS SETTINGS

### Permissions Structure

```json
{
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write"],
    "deny": [".env", "*.key", ".git/"],
    "gitAllowed": true,
    "environmentVariablesEnabled": true
  }
}
```

### allowed_tools (What Claude CAN do)

```json
{
  "allowed_tools": [
    "Bash",        // Run shell commands
    "Edit",        // Edit existing files
    "Write",       // Create new files
    "Notebook",    // Run Jupyter notebooks
    "Read",        // Read files (always allowed)
    "Search",      // Search codebase (always allowed)
    "ListDir"      // List directories (always allowed)
  ]
}
```

**Default**: All tools allowed if not specified.

### deny (What Claude CANNOT do)

Pattern-based file blocking:

```json
{
  "deny": [
    ".env",              // Exact filename
    "*.key",             // File pattern
    "*.pem",             // SSL certificates
    "*.sql",             // Database files
    ".git/",             // Git directory
    "node_modules/*",    // Dependencies
    "secrets/*",         // Secrets folder
    "database.db",       // SQLite database
    "config/prod.json"   // Specific file
  ]
}
```

**How it works**:
- Prevents Edit/Write/Read to matched files
- Uses glob patterns
- Case-sensitive by default

### gitAllowed

```json
{
  "gitAllowed": true    // Allow git commands (default: true)
}
```

If `false`: Claude cannot run `git commit`, `git push`, etc.

### environmentVariablesEnabled

```json
{
  "environmentVariablesEnabled": true  // Allow env var access (default: true)
}
```

### Tool-Specific Permissions

```json
{
  "permissions": {
    "allowed_tools": ["Bash"],
    "tool_specific": {
      "Bash": {
        "allowed_commands": ["npm", "python", "node"]
      }
    }
  }
}
```

Restricts specific tools to only certain commands.

### Practical Permission Examples

**Restrictive (Maximum Safety)**:
```json
{
  "permissions": {
    "allowed_tools": ["Read", "Search"],
    "deny": [".*", "**/*.env", "**/*.key"],
    "gitAllowed": false
  }
}
```

**Development (Permissive)**:
```json
{
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write", "Notebook"],
    "deny": [".env", "*.key", ".git/"],
    "gitAllowed": true
  }
}
```

**Production Review (Balanced)**:
```json
{
  "permissions": {
    "allowed_tools": ["Read", "Search", "Bash"],
    "deny": [".env*", "*.key", "node_modules", ".git"],
    "gitAllowed": false
  }
}
```

---

## ENVIRONMENT VARIABLES IN SETTINGS

### Setting Environment Variables

```json
{
  "environment": {
    "NODE_ENV": "development",
    "API_KEY": "${API_KEY}",
    "DATABASE_URL": "postgresql://localhost:5432/mydb",
    "PORT": "3000",
    "DEBUG": "false"
  }
}
```

### Variable Types

| Syntax | Behavior | Use Case |
|--------|----------|----------|
| `"${VAR_NAME}"` | References shell environment | Secrets, dynamic values |
| `"literal_value"` | Fixed string value | Static config |
| `"123"` | String (quote needed) | Numbers as config |
| `true/false` | Boolean | Flags |

### Shell Variable Substitution

```bash
# Set in shell
export GITHUB_TOKEN="ghp_xxxxx"
export DATABASE_URL="postgresql://..."

# Reference in settings.json
{
  "environment": {
    "GITHUB_TOKEN": "${GITHUB_TOKEN}",
    "DATABASE_URL": "${DATABASE_URL}"
  }
}
```

**Important**: Shell variable must be set BEFORE starting Claude Code.

### Default Values

```json
{
  "environment": {
    "API_KEY": "${API_KEY:default-value}",
    "PORT": "${PORT:3000}",
    "DEBUG": "${DEBUG:false}"
  }
}
```

Colon syntax provides default if variable not set.

### Accessing in Claude Code

Claude sees these as environment variables:

```bash
claude
# In session, Claude can:
- Access env vars via shell: echo $API_KEY
- Use in scripts: python script.py
- Reference in hooks
```

---

## TOOL CONFIGURATION

### Git Configuration

```json
{
  "tools": {
    "git": {
      "merge_strategy": "rebase",
      "default_branch": "main",
      "require_commit_message": true,
      "auto_sign_commits": false
    }
  }
}
```

### Bash Configuration

```json
{
  "tools": {
    "bash": {
      "shell": "/bin/bash",
      "working_directory": ".",
      "timeout": 300000,
      "allowed_commands": ["npm", "python", "node", "git"]
    }
  }
}
```

### Edit/Write Configuration

```json
{
  "tools": {
    "file_operations": {
      "max_file_size": 10485760,
      "create_backups": true,
      "backup_dir": ".claude/backups"
    }
  }
}
```

---

## SESSION SETTINGS

### Model Selection

```json
{
  "model": "claude-sonnet-4-20250514"
}
```

**Available models**:
- `claude-opus-4-1-20250805` (Opus 4.1 - most capable)
- `claude-sonnet-4-20250514` (Sonnet 4.5 - fast, default)
- `claude-haiku-4-5-20251001` (Haiku 4.5 - fastest)

### Thinking Budget (Claude o3)

```json
{
  "model": "claude-opus-4-1-20250805",
  "thinking": {
    "enabled": true,
    "budget": "high"
  }
}
```

Levels: `low`, `medium`, `high`, `ultrathink`.

### Context Window Management

```json
{
  "context": {
    "max_tokens": 200000,
    "auto_compact": true,
    "compact_threshold": 0.9
  }
}
```

---

## REAL-WORLD EXAMPLES

### Example 1: Vue3 + Astro + Node Project Settings

```json
{
  "version": "1.0.0",
  
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write", "Read", "Search"],
    "deny": [
      ".env*",
      "*.key",
      "*.pem",
      ".git/",
      "node_modules/*",
      "dist/*",
      ".next/*"
    ],
    "gitAllowed": true
  },
  
  "environment": {
    "NODE_ENV": "development",
    "VITE_API_URL": "http://localhost:3001",
    "DATABASE_URL": "${DATABASE_URL}",
    "GITHUB_TOKEN": "${GITHUB_TOKEN}"
  },
  
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-github-server"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    }
  },
  
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write $CLAUDE_FILE_PATHS"
          }
        ]
      }
    ]
  },
  
  "model": "claude-sonnet-4-20250514",
  
  "tools": {
    "git": {
      "default_branch": "main",
      "merge_strategy": "rebase"
    }
  }
}
```

### Example 2: Production Review Settings (Restrictive)

```json
{
  "permissions": {
    "allowed_tools": ["Read", "Search", "Bash"],
    "deny": [
      ".env*",
      "*.key",
      "*.sql",
      ".git/",
      "node_modules/*"
    ],
    "gitAllowed": false
  },
  
  "model": "claude-opus-4-1-20250805",
  
  "tools": {
    "bash": {
      "allowed_commands": ["grep", "find", "cat"],
      "timeout": 60000
    }
  }
}
```

### Example 3: Local Development (Permissive)

```json
{
  "permissions": {
    "allowed_tools": ["Bash", "Edit", "Write", "Notebook"],
    "deny": [".git/"],
    "gitAllowed": true,
    "environmentVariablesEnabled": true
  },
  
  "environment": {
    "NODE_ENV": "development",
    "DEBUG": "true",
    "PORT": "3000"
  },
  
  "model": "claude-sonnet-4-20250514"
}
```

---

## TROUBLESHOOTING & EDGE CASES

### Q: Settings not taking effect

**A**: Check file location and restart Claude Code.

```bash
# Verify file exists
ls .claude/settings.json       # Project level
ls ~/.claude/settings.json     # User level

# Verify JSON is valid
cat .claude/settings.json | python -m json.tool

# Restart session to load settings
exit
claude
```

**Common issues**:
- JSON syntax error (missing comma, quote, etc.)
- File in wrong directory
- Settings not applied mid-session (need restart)

---

### Q: Environment variable not substituting

**A**: Check variable is set in shell.

```bash
# Verify variable is set
echo $API_KEY
# Should output value, not empty

# If empty, set it
export API_KEY="value"

# Restart Claude Code
exit
claude
```

**Common issues**:
- Variable set in one shell, Claude Code in another
- Wrong variable name in settings
- Syntax error: `${VAR}` not `$VAR` or `{VAR}`

---

### Q: deny pattern not blocking files

**A**: Check pattern syntax.

```json
{
  "deny": [
    ".env",          // ✅ Matches .env exactly
    "*.env",         // ✅ Matches .env, prod.env, etc.
    ".env*",         // ✅ Matches .env, .env.local, .env.prod
    "config/*",      // ✅ Matches all in config/ folder
    ".git/",         // ✅ Matches .git/ directory
    "**/*.key"       // ✅ Matches *.key in any folder
  ]
}
```

**Why blocked files might still be accessible**:
- Glob pattern doesn't match (test with `find`)
- Settings not reloaded (restart Claude Code)
- Different settings layer overrides (check hierarchy)

---

### Q: Multiple settings files - which one applies?

**A**: Higher priority wins, and they merge.

```
Priority:
.claude/settings.local.json > .claude/settings.json > ~/.claude/settings.json

Merging:
- Permissions combine (union of allow/deny)
- Env vars merge (local overrides user)
- MCP servers merge (combine all servers)
- Hooks merge (all hooks run)
```

**Example**:
```
User: { "environment": { "NODE_ENV": "development" } }
Project: { "environment": { "API_KEY": "${API_KEY}" } }
Result: { "environment": { "NODE_ENV": "development", "API_KEY": "${API_KEY}" } }
```

---

### Q: Can I set permissions to completely lock down Claude?

**A**: Yes, use minimal allowed_tools.

```json
{
  "permissions": {
    "allowed_tools": ["Read", "Search"],
    "deny": [".*"],
    "gitAllowed": false,
    "environmentVariablesEnabled": false
  }
}
```

This allows:
- ✅ Reading files
- ✅ Searching code
- ❌ Running bash
- ❌ Editing files
- ❌ Using git
- ❌ Accessing env vars

---

### Q: I forgot what settings I have configured

**A**: Check all layers:

```bash
# View project-local settings
cat .claude/settings.local.json

# View project settings
cat .claude/settings.json

# View user settings
cat ~/.claude/settings.json

# In Claude Code session, use /config
/config
```

---

### Q: How do I reset settings to defaults?

**A**: Remove the files:

```bash
# Remove project settings
rm .claude/settings.json
rm .claude/settings.local.json

# Remove user settings (affects all projects!)
rm ~/.claude/settings.json

# Restart Claude Code
exit
claude
# Will use built-in defaults
```

---

### Q: Can I version-control personal API keys in .env?

**A**: NO. Use `.env.example` instead.

```bash
# ❌ WRONG - Never commit
.env               # Has real API key

# ✅ RIGHT - Commit template
.env.example       # Has placeholder
```

Add to `.gitignore`:
```bash
echo ".env" >> .gitignore
echo ".env.local" >> .gitignore
```

Then in settings.json:
```json
{
  "environment": {
    "API_KEY": "${API_KEY}"
  }
}
```

---

### Q: Settings.local.json - should I commit it?

**A**: NO. Add to .gitignore.

```bash
# .gitignore
.claude/settings.local.json    # Never commit

# Commit only:
.claude/settings.json          # Team settings
```

`settings.local.json` is for personal, experiment-specific settings.

---

### Q: Can I use settings for different projects differently?

**A**: Yes, project-level settings override user-level.

```
my-project-1/
└── .claude/settings.json      # Project-specific

my-project-2/
└── .claude/settings.json      # Different settings

~/.claude/settings.json        # Fallback for all projects
```

Each project can have different permissions, env vars, MCP servers.

---

### Q: Settings.json for enterprise team - what's best practice?

**A**: Commit team standards, allow local overrides.

```
.claude/
├── settings.json           # Committed: team standards
└── settings.local.json     # Local: personal experiments
  (Not committed)
```

**In settings.json**:
```json
{
  "permissions": {
    "allowed_tools": ["Edit", "Write", "Bash"],
    "deny": [".env*", "*.key"],
    "gitAllowed": true
  },
  "model": "claude-sonnet-4-20250514",
  "hooks": {
    "PreToolUse": [...]
  }
}
```

Team members get same base settings but can override in `.local.json`.

---

## QUICK REFERENCE CHECKLIST

- [ ] Created `.claude/settings.json` for project
- [ ] Syntax is valid JSON (use `python -m json.tool` to verify)
- [ ] Committed `.claude/settings.json` to git
- [ ] Added `.claude/settings.local.json` to `.gitignore`
- [ ] Used `${VAR}` syntax for environment variables
- [ ] Environment variables are set in shell before starting Claude Code
- [ ] Permissions are appropriate (allowed_tools + deny list)
- [ ] File patterns use correct glob syntax
- [ ] MCP servers are configured correctly
- [ ] Hooks are syntactically valid
- [ ] Tested by running `claude --debug` and checking logs
- [ ] No secrets hardcoded (use env vars instead)
- [ ] Team members have documented how to set required env vars

---

## RELATED RESOURCES

- Official Claude Code Settings Docs: https://docs.claude.com/en/docs/claude-code/settings
- Claude Code Best Practices: https://www.anthropic.com/engineering/claude-code-best-practices
- ClaudeLog Settings Guide: https://claudelog.com/
- Awesome Claude Code: https://github.com/hesreallyhim/awesome-claude-code
- JSON Validator: https://jsonlint.com/

---

## SUMMARY

**Claude Code Settings = Control Panel for Your Workflow**

1. **Files**: `.claude/settings.json` (project), `~/.claude/settings.json` (user)
2. **Priority**: Local > Project > User > Defaults
3. **Format**: Standard JSON (no special syntax)
4. **Key Sections**: Permissions, environment, mcpServers, hooks, model
5. **Permissions**: allowed_tools + deny patterns
6. **Env Vars**: Use `${VAR}` syntax for shell variables
7. **Commit**: `.claude/settings.json` yes, `.local.json` no
8. **Secrets**: Never hardcode - use env vars
9. **Restart**: Settings apply when Claude Code starts new session
10. **Debugging**: Use `/config` in session or `cat .claude/settings.json`

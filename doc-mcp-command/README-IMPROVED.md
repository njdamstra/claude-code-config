# MCP-Act v2.0: Secure MCP Server Management

A powerful, secure slash command and CLI tool for managing Model Context Protocol (MCP) servers with preset bundles for Claude Code.

## 🎯 Features

- ✅ **Preset Management**: Bundle commonly-used MCP servers into micro-presets
- ✅ **Security First**: Environment variable validation and audit tools
- ✅ **Thin Wrapper Architecture**: Simple slash command, powerful bash script
- ✅ **Micro-Presets**: Granular control (browser, ai, docs, webdev, ui)
- ✅ **Validation**: Pre-flight checks for API keys and config syntax
- ✅ **Flexible Configuration**: JSON-based config with extensibility
- ✅ **Dual Interface**: Works in Claude (`/mcp-act`) and terminal (`mcp-act`)
- ✅ **Smart Defaults**: Project-scoped by default, user-scoped when needed

## 🚀 Quick Start

```bash
# Install (5 minutes)
mkdir -p ~/.claude/commands ~/.local/bin
cp mcp-act-improved.sh ~/.local/bin/mcp-act
cp mcp-act-improved.md ~/.claude/commands/mcp-act.md
cp mcp-servers-config-improved.json ~/.mcp-servers-config.json
chmod +x ~/.local/bin/mcp-act

# Set environment variables (IMPORTANT!)
export GEMINI_API_KEY="your-key"
export FIRECRAWL_API_KEY="your-key"

# Add your first servers
mcp-act add preset:browser
```

See [QUICKSTART-IMPROVED.md](QUICKSTART-IMPROVED.md) for detailed installation.

## 📚 Usage

### In Claude Code (Slash Command)

```bash
# List all available presets and servers
/mcp-act list

# Get info about a preset or server
/mcp-act info preset:webdev
/mcp-act info gemini-cli

# Add a preset
/mcp-act add preset:browser

# Add individual server
/mcp-act add gemini-cli user

# Remove servers
/mcp-act remove playwright
/mcp-act remove preset:ui

# Security audit
/mcp-act audit

# Validate config
/mcp-act validate
```

### Via CLI (Terminal)

```bash
# List everything
mcp-act list

# Add web development preset
mcp-act add preset:webdev

# Add individual server with user scope
mcp-act add gemini-cli user

# Security check
mcp-act audit

# Get help
mcp-act help
```

## 🎨 Available Presets

### Micro-Presets (Recommended)

#### `preset:browser`
Browser automation and debugging
- **playwright** - Browser automation for testing
- **chrome-devtools** - Chrome debugging protocol
- **Use for:** E2E testing, UI debugging, automation

#### `preset:ai`
AI assistance and problem-solving
- **gemini-cli** - Large context window (2M tokens)
- **sequential-thinking** - Problem decomposition
- **Use for:** Complex analysis, large file processing

#### `preset:docs`
Documentation and reference lookup
- **context7** - Up-to-date library docs
- **tailwind-css** - Tailwind utilities
- **shadcn** - Component library docs
- **Use for:** API references, framework documentation

### Full Presets

#### `preset:webdev`
Web development essentials
- firecrawl, playwright, chrome-devtools
- **Use for:** Full-stack web development

#### `preset:ui`
UI and component development
- tailwind-css, shadcn, figma-to-react
- **Use for:** Frontend component work

#### `preset:ai-assist`
AI collaboration tools
- gemini-cli, sequential-thinking, context7
- **Use for:** Research and complex problem-solving

## 🔧 Configured Servers

| Server | Description | API Key Required? | Preset |
|--------|-------------|-------------------|--------|
| gemini-cli | Google Gemini (2M context) | Yes (GEMINI_API_KEY) | ai, ai-assist |
| gemini-cli-oauth | Gemini with OAuth | No (OAuth) | - |
| firecrawl | Web scraping | Yes (FIRECRAWL_API_KEY) | webdev |
| playwright | Browser automation | No | browser, webdev |
| chrome-devtools | Chrome debugging | No | browser, webdev |
| tailwind-css | Tailwind utilities | No | docs, ui |
| shadcn | shadcn/ui components | No | docs, ui |
| figma-to-react | Figma to code | Yes (FIGMA_API_KEY) | ui |
| sequential-thinking | Problem decomposition | No | ai, ai-assist |
| context7 | Library documentation | No | docs, ai-assist |
| memory | Persistent knowledge | No | - |
| github | GitHub integration | Yes (GITHUB_TOKEN) | - |

## 🔒 Security Features

### Environment Variable Validation

MCP-Act validates that required environment variables are set BEFORE adding servers:

```bash
$ mcp-act add firecrawl

ℹ Processing: firecrawl
⚠ Server 'firecrawl' requires environment variables:
  ✗ FIRECRAWL_API_KEY (not set)
💡 Get API key from https://firecrawl.dev
ℹ Set with: export FIRECRAWL_API_KEY='your-value-here'
```

### Security Audit

Run `mcp-act audit` to check for:
- ❌ Hardcoded secrets in `~/.claude.json`
- ❌ Missing environment variables
- ✅ Proper `${VAR}` templating

```bash
$ mcp-act audit

ℹ Auditing ~/.claude.json for security issues...
✓ No hardcoded secrets detected!

ℹ Checking environment variables...
⚠ Environment variables not set in current shell:
  ✗ FIRECRAWL_API_KEY
💡 Set in ~/.zshrc or ~/.bashrc for persistence
```

### Config Validation

Validate JSON syntax and required fields:

```bash
$ mcp-act validate

ℹ Validating configuration file...
✓ JSON syntax valid
✓ Found 6 preset(s)
✓ Found 12 server(s)
✓ Configuration file is valid!
```

## 🛠️ Customization

### Adding Custom Servers

Edit `~/.mcp-servers-config.json`:

```json
{
  "servers": {
    "my-custom-server": {
      "name": "my-custom-server",
      "description": "My custom MCP server",
      "command": "npx",
      "args": ["-y", "my-custom-package"],
      "env": {
        "MY_API_KEY": "${MY_API_KEY}"
      },
      "notes": "Get API key from https://example.com"
    }
  }
}
```

Then use immediately:
```bash
mcp-act add my-custom-server
```

### Creating Custom Presets

```json
{
  "presets": {
    "my-workflow": {
      "description": "My daily development workflow",
      "servers": ["gemini-cli", "playwright", "shadcn"]
    }
  }
}
```

## 📖 Examples

### Scenario 1: Starting New Vue 3 Project

```bash
# Add UI tools
/mcp-act add preset:ui

# Add browser debugging
/mcp-act add preset:browser

# Add AI for large file analysis
/mcp-act add gemini-cli user

# Verify
/mcp
```

### Scenario 2: Quick Component Building

```bash
# Just need component docs
/mcp-act add shadcn
/mcp-act add tailwind-css

# When done, clean up
/mcp-act remove shadcn tailwind-css
```

### Scenario 3: Debugging Session

```bash
# Add debugging tools
/mcp-act add preset:browser

# Add Gemini for analysis
/mcp-act add gemini-cli user

# Verify running
claude mcp list
```

### Scenario 4: Full-Stack Development

```bash
# Combine multiple presets
/mcp-act add preset:browser
/mcp-act add preset:ai
/mcp-act add preset:docs

# Or add specific servers
/mcp-act add github user
/mcp-act add memory user
```

## 🏗️ Architecture

```
User: /mcp-act add preset:browser
         ↓
Claude executes: ~/.local/bin/mcp-act add preset:browser
         ↓
Script reads: ~/.mcp-servers-config.json
         ↓
Resolves preset → ["playwright", "chrome-devtools"]
         ↓
For each server:
  1. Validate environment variables
  2. Build: claude mcp add <server> <command> <args>
  3. Execute and report
         ↓
Updates: ~/.claude.json
         ↓
Result displayed to user
```

### File Structure

```
~/.claude/commands/mcp-act.md          # Slash command (thin wrapper)
~/.local/bin/mcp-act                   # Bash script (all logic)
~/.mcp-servers-config.json             # Server & preset definitions
~/.claude.json                         # Active MCP servers (managed)
```

## 🐛 Troubleshooting

### Environment Variable Not Set

```bash
# Check if set
echo $GEMINI_API_KEY

# Set temporarily
export GEMINI_API_KEY="your-key"

# Set permanently
echo 'export GEMINI_API_KEY="your-key"' >> ~/.zshrc
source ~/.zshrc
```

### Server Won't Add

```bash
# Try with user scope
mcp-act add gemini-cli user

# Check for errors
mcp-act validate

# Manual fallback: edit ~/.claude.json directly
```

### "claude mcp remove" Bug

Known issue with built-in command. MCP-Act handles this:

```bash
# Script will warn and suggest manual edit
mcp-act remove playwright

# If fails, manually edit ~/.claude.json
# Remove the server block from "mcpServers"
```

### Hardcoded Secrets Detected

```bash
# Run audit to find them
mcp-act audit

# Fix in ~/.claude.json
# Replace: "API_KEY": "abc123..."
# With:    "API_KEY": "${API_KEY}"

# Set environment variable
export API_KEY="abc123..."
```

## 🎓 Best Practices

### DO: Use Environment Variables

```bash
# Good - secure
export GEMINI_API_KEY="your-key"
mcp-act add gemini-cli

# Bad - hardcoded
# Don't manually edit ~/.claude.json with raw keys!
```

### DO: Start with Micro-Presets

```bash
# Good - add only what you need
mcp-act add preset:browser
mcp-act add preset:ai

# Avoid - too broad (8+ servers)
# mcp-act add preset:full-stack  # (removed from v2.0)
```

### DO: Run Security Audit

```bash
# Before committing or deploying
mcp-act audit
```

### DO: Validate Config Changes

```bash
# After editing ~/.mcp-servers-config.json
mcp-act validate
```

### DON'T: Commit Secrets

```bash
# Add to .gitignore
echo ".claude.json" >> .gitignore
echo ".mcp-servers-config.json" >> .gitignore  # If customized

# Never commit:
git add ~/.claude.json  # ❌ NEVER!
```

## 🆚 Comparison with Built-in Tools

| Feature | `claude mcp add` | MCP-Act v2.0 |
|---------|------------------|--------------|
| Preset bundles | ❌ No | ✅ Yes (6 presets) |
| Env var validation | ❌ No | ✅ Yes (pre-flight) |
| Security audit | ❌ No | ✅ Yes |
| Config validation | ❌ No | ✅ Yes |
| Remove bug fix | ❌ No | ✅ Workaround |
| Documentation | ⚠️ Basic | ✅ Comprehensive |
| Custom servers | ✅ Yes | ✅ Yes (easier) |

## 📋 Command Reference

### Actions

| Command | Description |
|---------|-------------|
| `list` | Show all configured servers and presets |
| `info <name>` | Display details about server or preset |
| `add <name> [scope]` | Add server(s), validate env vars |
| `remove <name>` | Remove server(s) from configuration |
| `audit` | Security check for hardcoded secrets |
| `validate` | Validate configuration file syntax |
| `help` | Show help message |

### Scopes

| Scope | Location | Use Case |
|-------|----------|----------|
| `project` (default) | `./.claude.json` | Project-specific servers |
| `user` | `~/.claude.json` | Global, cross-project servers |

## 🔗 Tech Stack Alignment

Optimized for:
- ✅ **Frontend:** Vue 3, Astro, TypeScript
- ✅ **Styling:** Tailwind CSS, shadcn-ui/vue
- ✅ **Backend:** Appwrite, Cloudflare
- ✅ **Validation:** Zod
- ✅ **State:** Nanostores

All MCP servers chosen work perfectly with this stack!

## 📝 What's New in v2.0

✨ **New Features:**
- ✅ Environment variable validation (pre-flight checks)
- ✅ Security audit command (`mcp-act audit`)
- ✅ Config validation command (`mcp-act validate`)
- ✅ Micro-presets (browser, ai, docs)
- ✅ Thin wrapper architecture (simpler slash command)
- ✅ Improved error messages with tips

🔒 **Security Enhancements:**
- ✅ No hardcoded secrets in examples
- ✅ Audit tool detects exposed API keys
- ✅ Validates environment variables before adding servers
- ✅ Clear security checklist in QUICKSTART

🏗️ **Architecture Improvements:**
- ✅ Slash command is now a thin wrapper
- ✅ All logic in testable bash script
- ✅ Better separation of concerns
- ✅ Easier to maintain and extend

## 🤝 Contributing

Want to add more presets or servers?

1. Edit `~/.mcp-servers-config.json`
2. Add your server/preset
3. Run `mcp-act validate`
4. Share your configuration!

## 📄 License

MIT - Use freely for your projects

## 🔗 Resources

- [MCP Documentation](https://modelcontextprotocol.io)
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
- [Slash Commands Guide](https://docs.claude.com/en/docs/claude-code/slash-commands)
- Configuration: `~/.mcp-servers-config.json`

---

**Pro Tip:** Start with `preset:browser` and `preset:docs`, then add `gemini-cli` for large context. This gives you powerful tools without token overhead! 🚀🔒

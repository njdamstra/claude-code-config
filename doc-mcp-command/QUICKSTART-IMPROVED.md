# Quick Start Guide - MCP-Act v2.0

Get up and running with secure MCP server management in 5 minutes!

## Prerequisites

```bash
# Install jq (for JSON parsing)
brew install jq  # macOS
# OR
sudo apt-get install jq  # Ubuntu/Debian
# OR
sudo dnf install jq  # Fedora/RHEL
```

## Installation

### Step 1: Copy Files

```bash
# Create directories
mkdir -p ~/.claude/commands ~/.local/bin

# Copy improved files
cp mcp-act-improved.sh ~/.local/bin/mcp-act
cp mcp-act-improved.md ~/.claude/commands/mcp-act.md
cp mcp-servers-config-improved.json ~/.mcp-servers-config.json

# Make script executable
chmod +x ~/.local/bin/mcp-act
```

### Step 2: Verify Installation

```bash
# Check script is executable
which mcp-act
# Should output: /Users/yourusername/.local/bin/mcp-act

# Check slash command exists
ls -la ~/.claude/commands/mcp-act.md

# Check config file exists
ls -la ~/.mcp-servers-config.json

# Test the script
mcp-act help
```

## ⚠️ Security Setup (IMPORTANT!)

### Step 3: Set Environment Variables

**NEVER hardcode API keys in config files!** Always use environment variables.

```bash
# Add to ~/.zshrc (macOS) or ~/.bashrc (Linux)
echo 'export GEMINI_API_KEY="your-key-here"' >> ~/.zshrc
echo 'export FIRECRAWL_API_KEY="your-key-here"' >> ~/.zshrc
echo 'export FIGMA_API_KEY="your-key-here"' >> ~/.zshrc
echo 'export GITHUB_TOKEN="your-token-here"' >> ~/.zshrc

# Reload shell config
source ~/.zshrc
```

**Get API Keys:**
- **Gemini:** https://aistudio.google.com/app/apikey
- **Firecrawl:** https://firecrawl.dev (sign up for free tier)
- **Figma:** https://figma.com/settings/account (Generate personal access token)
- **GitHub:** https://github.com/settings/tokens (Create classic token with `repo` scope)

### Step 4: Security Audit

```bash
# Run security audit
mcp-act audit

# Should show:
# ✓ No hardcoded secrets detected!
# ✓ All required environment variables are set!
```

**If you see warnings:**
```bash
# Fix hardcoded secrets in ~/.claude.json
# Replace: "GEMINI_API_KEY": "AIzaSy..."
# With:    "GEMINI_API_KEY": "${GEMINI_API_KEY}"

# Set missing environment variables
export MISSING_VAR="your-value"
```

## First Use

### List Available Servers and Presets

```bash
# In Claude Code:
/mcp-act list

# Or via terminal:
mcp-act list
```

### Add Your First Preset

```bash
# Add browser tools (no API keys needed!)
/mcp-act add preset:browser

# Output:
# ℹ Processing: playwright
# ✓ Environment variables validated for 'playwright'
# ✓ Added: playwright
# ℹ Processing: chrome-devtools
# ✓ Environment variables validated for 'chrome-devtools'
# ✓ Added: chrome-devtools
```

### Verify Servers Are Running

```bash
# In Claude Code:
/mcp

# Or via terminal:
claude mcp list
```

## Common Workflows

### For Vue 3 + Tailwind Development

```bash
# Add UI tools
/mcp-act add preset:ui

# Add AI assistance
/mcp-act add gemini-cli user

# Verify
claude mcp list
```

### For Web Development

```bash
# Add web dev tools
/mcp-act add preset:webdev

# Note: firecrawl requires FIRECRAWL_API_KEY
# If not set, you'll see a helpful error message
```

### For Documentation Research

```bash
# Add docs preset
/mcp-act add preset:docs

# Now you have: context7, tailwind-css, shadcn
```

## Troubleshooting

### "jq: command not found"

```bash
brew install jq  # macOS
sudo apt-get install jq  # Linux
```

### "Configuration file not found"

```bash
# Check file exists
ls -la ~/.mcp-servers-config.json

# If missing, copy again
cp mcp-servers-config-improved.json ~/.mcp-servers-config.json
```

### "Server requires FIRECRAWL_API_KEY"

```bash
# Set the environment variable
export FIRECRAWL_API_KEY="your-key-from-firecrawl.dev"

# Make it permanent
echo 'export FIRECRAWL_API_KEY="your-key"' >> ~/.zshrc
source ~/.zshrc

# Try adding again
/mcp-act add firecrawl
```

### Slash Command Not Showing

```bash
# Restart Claude Code
# OR check file location
ls -la ~/.claude/commands/mcp-act.md

# File should be there with proper permissions
```

### "Failed to add server"

```bash
# Known bug with claude mcp add
# Option 1: Try with user scope
/mcp-act add gemini-cli user

# Option 2: Manual edit of ~/.claude.json
# Add server configuration manually
```

## Security Checklist

✅ **Before deploying to production:**

1. Run security audit:
   ```bash
   mcp-act audit
   ```

2. Check for hardcoded secrets:
   ```bash
   grep -r "AIza\|xoxb-\|ghp_" ~/.claude.json
   # Should return nothing!
   ```

3. Verify environment variables are set:
   ```bash
   echo $GEMINI_API_KEY
   echo $FIRECRAWL_API_KEY
   # Should show your keys (not empty)
   ```

4. Never commit `.claude.json` to git:
   ```bash
   # Add to .gitignore
   echo ".claude.json" >> ~/.gitignore
   ```

## What's Next?

1. ✅ Read the [full README](README-IMPROVED.md) for advanced usage
2. ✅ Customize `~/.mcp-servers-config.json` with your own servers
3. ✅ Create custom presets for your workflow
4. ✅ Run `/mcp-act audit` regularly to check security

## Quick Reference

### Most Used Commands

```bash
# List everything
/mcp-act list

# Add a preset
/mcp-act add preset:browser

# Add individual server with user scope
/mcp-act add gemini-cli user

# Get server details
/mcp-act info gemini-cli

# Remove servers
/mcp-act remove playwright

# Security check
/mcp-act audit

# Validate config
/mcp-act validate
```

## Recommended Starting Setup

For Vue 3 + Astro + Appwrite development:

```bash
# 1. Browser tools (no API keys)
/mcp-act add preset:browser

# 2. UI tools (no API keys except figma)
/mcp-act add tailwind-css
/mcp-act add shadcn

# 3. AI assistance (requires GEMINI_API_KEY)
/mcp-act add gemini-cli user

# 4. Verify all connected
/mcp
```

Happy coding with secure MCP management! 🚀🔒

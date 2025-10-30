# Quick Start Guide - MCP-Act

Get up and running in 5 minutes!

## Prerequisites

```bash
# Install jq (for JSON parsing)
brew install jq  # macOS
```

## Installation (Copy-Paste)

```bash
# 1. Create directories
mkdir -p ~/.claude/commands ~/.local/bin

# 2. Copy files (adjust paths to where you downloaded them)
cp mcp-act.md ~/.claude/commands/
cp .mcp-servers-config.json ~/
cp mcp-act.sh ~/.local/bin/mcp-act
chmod +x ~/.local/bin/mcp-act

# 3. Set API keys (optional - only if you need these services)
echo 'export FIRECRAWL_API_KEY="your-key"' >> ~/.zshrc
echo 'export FIGMA_API_KEY="your-key"' >> ~/.zshrc  
echo 'export GITHUB_TOKEN="your-token"' >> ~/.zshrc
source ~/.zshrc
```

## First Use

```bash
# In Claude Code:
/mcp-act list

# Or via CLI:
mcp-act list
```

## Quick Examples

```bash
# Add web development tools
/mcp-act add preset:webdev

# Add shadcn for component work
/mcp-act add shadcn

# Remove when done
/mcp-act remove shadcn

# See what's running
/mcp
```

## Verify Installation

```bash
# Check config file exists
ls -la ~/.mcp-servers-config.json

# Check slash command exists
ls -la ~/.claude/commands/mcp-act.md

# Check CLI exists
which mcp-act

# Test it
mcp-act list
```

## Troubleshooting

**Issue**: "jq: command not found"
```bash
brew install jq
```

**Issue**: "Permission denied"
```bash
chmod +x ~/.local/bin/mcp-act
```

**Issue**: Slash command not showing up
```bash
# Restart Claude Code
# Or check file location
ls -la ~/.claude/commands/mcp-act.md
```

## What's Next?

1. Read the [full README](README.md) for detailed usage
2. Customize `~/.mcp-servers-config.json` with your own servers
3. Create custom presets for your workflow
4. Check `/mcp` after adding servers to verify they're connected

## Your First Preset

Try this for Vue 3 + Tailwind development:

```bash
/mcp-act add preset:ui
/mcp-act add gemini-cli
```

That's it! You now have:
- shadcn/ui components
- Tailwind CSS utilities  
- Gemini's 2M token context window

Happy coding! 🚀

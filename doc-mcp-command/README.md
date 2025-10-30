# MCP-Act: MCP Server Management for Claude Code

A powerful slash command and CLI tool for managing your Model Context Protocol (MCP) servers with preset bundles for Claude Code.

## Features

- 🎯 **Preset Management**: Bundle commonly-used MCP servers into presets
- 🚀 **Quick Actions**: Add, remove, list, and manage servers with simple commands  
- 🔧 **Flexible Configuration**: JSON-based config with environment variable support
- 📦 **Pre-configured Servers**: Your common tools ready to go
- 🎨 **Smart Defaults**: Project-scoped by default, user-scoped when needed

## Installation

### Step 1: Place Files in Claude Commands Directory

```bash
# For project-specific (recommended)
mkdir -p .claude/commands
cp mcp-act.md .claude/commands/

# For user-global
mkdir -p ~/.claude/commands
cp mcp-act.md ~/.claude/commands/
```

### Step 2: Copy Configuration Files

```bash
# Copy the config file to your home directory
cp .mcp-servers-config.json ~/.mcp-servers-config.json

# Copy the helper script (optional but recommended)
cp mcp-act.sh ~/.local/bin/mcp-act
chmod +x ~/.local/bin/mcp-act
```

### Step 3: Set Environment Variables

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# MCP Server API Keys
export FIRECRAWL_API_KEY="your-key-here"  # Get from https://firecrawl.dev
export FIGMA_API_KEY="your-key-here"      # Get from figma.com > Settings > Security
export GITHUB_TOKEN="your-token-here"     # Get from github.com > Settings > Developer settings
```

Then reload: `source ~/.zshrc`

### Step 4: Install jq (Required for CLI)

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

## Usage

### In Claude Code (Slash Command)

```bash
# List all available presets and servers
/mcp-act list

# Get info about a preset or server
/mcp-act info preset:webdev
/mcp-act info gemini-cli

# Add a preset
/mcp-act add preset:webdev

# Add individual server
/mcp-act add firecrawl

# Add with user scope
/mcp-act add gemini-cli user

# Remove servers
/mcp-act remove playwright
/mcp-act remove preset:ui
```

### Via CLI (Direct)

```bash
# List everything
mcp-act list

# Add web development preset
mcp-act add preset:webdev

# Add individual server with user scope
mcp-act add gemini-cli user

# Remove a preset
mcp-act remove preset:webdev

# Get server info
mcp-act info shadcn
```

## Available Presets

### `preset:webdev`
Web development essentials
- firecrawl (web scraping)
- playwright (browser automation)
- chrome-devtools (browser debugging)

### `preset:ui`
UI and component development
- tailwind-css (utility classes)
- shadcn (component library)
- figma-to-react (design to code)

### `preset:ai-assist`
AI collaboration tools
- gemini-cli (large context window)
- sequential-thinking (problem decomposition)
- context7 (up-to-date docs)

### `preset:full-stack`
Everything you need for full-stack development
- All servers from webdev, ui, and ai-assist presets

## Configured Servers

| Server | Description | API Key Required? |
|--------|-------------|-------------------|
| gemini-cli | Google Gemini CLI with OAuth | No (OAuth) |
| firecrawl | Web scraping and extraction | Yes |
| playwright | Browser automation | No |
| tailwind-css | Tailwind utilities and docs | No |
| shadcn | shadcn/ui components | No |
| chrome-devtools | Chrome debugging | No |
| figma-to-react | Figma to React conversion | Yes |
| sequential-thinking | Problem decomposition | No |
| context7 | Library documentation | No |
| memory | Persistent knowledge | No |
| github | GitHub integration | Yes |

## Customization

### Adding Your Own Servers

Edit `~/.mcp-servers-config.json`:

```json
{
  "servers": {
    "my-custom-server": {
      "name": "my-custom-server",
      "description": "My custom MCP server",
      "command": "npx",
      "args": ["-y", "my-custom-server"],
      "env": {
        "MY_API_KEY": "${MY_API_KEY}"
      },
      "notes": "Custom notes here"
    }
  }
}
```

### Creating Your Own Presets

```json
{
  "presets": {
    "my-preset": {
      "description": "My custom preset",
      "servers": ["server1", "server2", "server3"]
    }
  }
}
```

## Troubleshooting

### Claude MCP Add Issues

If `claude mcp add` fails or `claude mcp remove` doesn't work (known bug):

1. **Manual Configuration**: Edit `~/.claude.json` directly
2. **Check Logs**: Look at Claude Code logs for errors
3. **Verify Paths**: Ensure all paths are absolute
4. **Environment Variables**: Check they're set with `echo $FIRECRAWL_API_KEY`

### Servers Not Showing Up

```bash
# After adding servers, verify with:
/mcp

# Or in terminal:
claude mcp list
```

### Permission Issues

```bash
# Make sure script is executable
chmod +x ~/.local/bin/mcp-act

# Check file permissions
ls -la ~/.mcp-servers-config.json
```

### Finding Your .claude.json

```bash
# macOS/Linux
cat ~/.claude.json

# Check project-specific configs
cat .claude/.mcp.json
```

## Architecture

```
mcp-act.md              # Slash command definition
├── Uses →  .mcp-servers-config.json  # Server definitions
└── Calls → mcp-act.sh               # Helper script

~/.claude.json          # Claude Code config (managed by commands)
└── Contains → Active MCP server configurations
```

## Tech Stack Alignment

Optimized for your stack:
- ✅ Vue 3, Astro, nanostore, TypeScript
- ✅ Appwrite (databases, functions)
- ✅ Cloudflare
- ✅ Zod, headless-ui/vue, floating-ui/vue
- ✅ shadcn-ui/vue, Tailwind CSS

## Examples

### Scenario: Starting a New Vue 3 + Appwrite Project

```bash
# Add all UI and component tools
/mcp-act add preset:ui

# Add web development tools
/mcp-act add preset:webdev

# Add Gemini for large file analysis
/mcp-act add gemini-cli

# Verify everything is connected
/mcp
```

### Scenario: Quick Component Building Session

```bash
# Just need UI tools
/mcp-act add shadcn
/mcp-act add tailwind-css

# When done, remove to reduce context
/mcp-act remove shadcn tailwind-css
```

### Scenario: Full Development Environment

```bash
# Load everything
/mcp-act add preset:full-stack

# Verify all tools are running
claude mcp list
```

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [MCP Specification](https://modelcontextprotocol.io)
- [Slash Commands Guide](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Your Configuration](#) - `~/.mcp-servers-config.json`

## Contributing

Want to add more presets or servers? Edit the configuration files and submit suggestions!

## License

MIT - Use freely for your projects

---

**Pro Tip**: Start with `preset:webdev` and `preset:ui`, then add individual servers as needed. This keeps your context window cleaner while still having access to essential tools.

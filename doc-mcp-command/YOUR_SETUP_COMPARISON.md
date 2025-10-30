# Your Current MCP Setup vs. mcp-act Configuration

## Current Setup Analysis

You have **2 MCP servers** configured at user level in `~/.claude.json`:

### 1. gemini-cli
```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["gemini-mcp-tool"],
  "env": {
    "GEMINI_API_KEY": "AIzaSyAWNiGGAljfd2RlB7HHot1YkqcvY7T8B_4"
  }
}
```

**Package**: `gemini-mcp-tool` (by jamubc)  
**Authentication**: API key  
**What it does**: Provides Gemini integration with your API key

### 2. chrome-devtools
```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "chrome-devtools-mcp@latest"],
  "env": {}
}
```

**Package**: Official `chrome-devtools-mcp`  
**Authentication**: None needed  
**What it does**: Browser automation and debugging

---

## ✅ Configuration Updated!

I've updated `.mcp-servers-config.json` to match your actual setup:

### Changes Made:

1. **gemini-cli** → Now uses `gemini-mcp-tool` (your current package)
   - Uses `GEMINI_API_KEY` environment variable
   - Matches your existing setup exactly

2. **gemini-cli-oauth** → Added as alternative option
   - Uses `@jacob/gemini-cli-mcp` (OAuth-based, no API key)
   - Available if you want to try OAuth instead

3. **chrome-devtools** → Updated to include `-y` flag
   - Now matches your configuration exactly

---

## Your Setup Now Works With mcp-act!

Since your servers are configured at **user level**, they're available globally across all projects.

### Try it now:

```bash
# List all available servers (including your current ones)
/mcp-act list

# Add more servers without affecting your existing ones
/mcp-act add firecrawl

# Add a preset (project-scoped by default, won't interfere)
/mcp-act add preset:ui

# View your current servers
/mcp
```

---

## Understanding Scopes

### User Scope (Your Current Setup)
- Location: `~/.claude.json`
- Available: In ALL projects
- Your current servers: `gemini-cli`, `chrome-devtools`

### Project Scope (mcp-act Default)
- Location: `.claude/.mcp.json` (in project directory)
- Available: Only in specific project
- Use for: Project-specific tools

### Recommendation:
Keep your frequently-used servers (gemini-cli, chrome-devtools) at **user scope** ✅  
Add project-specific servers at **project scope** using mcp-act ✅

---

## Gemini Package Options

You have **two Gemini MCP options** now:

### Option 1: gemini-mcp-tool (Your Current Choice) ✅
```bash
Package: gemini-mcp-tool
Auth: API key
Pros: 
  - Simple setup with API key
  - Direct control
Cons:
  - Need to manage API key
  - Rate limits based on your plan
```

### Option 2: gemini-cli-oauth (Alternative)
```bash
Package: @jacob/gemini-cli-mcp  
Auth: OAuth (Google account)
Pros:
  - No API key needed
  - 60 req/min, 1,000 req/day free
  - Uses your Google account
Cons:
  - OAuth flow required
  - May need browser authentication
```

To switch to OAuth version:
```bash
/mcp-act remove gemini-cli
/mcp-act add gemini-cli-oauth user
```

---

## Environment Variables You Need

Based on your setup and the additional servers available:

```bash
# Required for your current setup
export GEMINI_API_KEY="AIzaSyAWNiGGAljfd2RlB7HHot1YkqcvY7T8B_4"

# Optional - for additional servers
export FIRECRAWL_API_KEY="your-key"      # If using firecrawl
export FIGMA_API_KEY="your-key"          # If using figma-to-react
export GITHUB_TOKEN="your-token"         # If using github MCP
```

Add to `~/.zshrc`:
```bash
# Add this line:
export GEMINI_API_KEY="AIzaSyAWNiGGAljfd2RlB7HHot1YkqcvY7T8B_4"

# Then reload:
source ~/.zshrc
```

---

## What Happens When You Use mcp-act?

### Adding Project-Scoped Server (Default):
```bash
/mcp-act add shadcn
```
Creates/updates: `.claude/.mcp.json` in your current project  
**Does NOT affect** your user-level `~/.claude.json`  
Result: shadcn only available in this project

### Adding User-Scoped Server:
```bash
/mcp-act add playwright user
```
Updates: `~/.claude.json`  
Result: playwright available globally

### Your Current Servers Are Safe! ✅
mcp-act won't remove or modify your existing user-level servers unless you explicitly tell it to.

---

## Testing Your Updated Setup

```bash
# 1. List all available servers and presets
/mcp-act list

# 2. Check your current active servers
/mcp

# Should show:
# ✓ gemini-cli (user scope)
# ✓ chrome-devtools (user scope)

# 3. Test adding a project-scoped server
/mcp-act add shadcn

# 4. Verify it was added
/mcp

# Should now show:
# ✓ gemini-cli (user scope)
# ✓ chrome-devtools (user scope)  
# ✓ shadcn (project scope)
```

---

## Preset Compatibility

Your existing servers are included in presets:

### preset:ai-assist
- ✅ gemini-cli (your current one!)
- sequential-thinking
- context7

### preset:webdev
- ✅ chrome-devtools (your current one!)
- firecrawl
- playwright

So if you run:
```bash
/mcp-act add preset:ai-assist
```

It will:
- Skip gemini-cli (you already have it at user level)
- Add sequential-thinking and context7 at project level

---

## Summary

✅ **Your setup is now correctly configured**  
✅ **Both your existing servers are preserved**  
✅ **You can add more servers safely**  
✅ **Presets won't duplicate your existing servers**  

The configuration now matches your actual `~/.claude.json` setup!

## Next Steps

1. **Test it**: Run `/mcp-act list` to see all options
2. **Add more**: Try `/mcp-act add preset:ui` in a project
3. **Customize**: Edit `~/.mcp-servers-config.json` as needed

Need to switch Gemini packages or have questions? The config file has both options ready to go!

# Quick Start: Chrome DevTools Sidecar

## Installation (5 minutes)

### 1. Install Dependencies

```bash
# Install Claude Agent SDK (Python)
pip install claude-agent-sdk

# Install Chrome DevTools MCP (Node.js)
npm install -g chrome-devtools-mcp

# Verify installations
python3 -c "from claude_agent_sdk import ClaudeSDKClient; print('✓ Agent SDK OK')"
npx chrome-devtools-mcp --help | head -3
```

### 2. Set API Key

```bash
# Get your API key from: https://console.anthropic.com/
export ANTHROPIC_API_KEY='sk-ant-...'

# Make permanent (choose your shell):
# For bash:
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
source ~/.bashrc

# For zsh:
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc
source ~/.zshrc
```

### 3. Install the Sidecar Script

```bash
# Create tools directory
mkdir -p ~/.claude/tools

# Copy the working sidecar script
cp chrome-sidecar-working.py ~/.claude/tools/chrome-sidecar.py

# Make executable
chmod +x ~/.claude/tools/chrome-sidecar.py

# Test it directly
python3 ~/.claude/tools/chrome-sidecar.py --url https://example.com --task "quick test"
```

### 4. Install the Slash Command

```bash
# Create commands directory
mkdir -p ~/.claude/commands

# Copy the slash command
cp chrome-tools-command.md ~/.claude/commands/chrome-tools.md
```

### 5. Test in Claude Code

```bash
# Start Claude Code in any project
cd ~/your-project
claude

# Try the slash command
/chrome-tools https://example.com "check console errors"
```

---

## Expected Behavior

**First run (~60 seconds):**
```
🚀 Starting Chrome DevTools sidecar...
📍 Target: https://example.com
📋 Task: check console errors
💾 Output: /path/to/.reports/chrome-1234567890

🔧 navigate
🔧 console_log

## Key Findings
- Found 2 console errors
- 3 warnings detected

✅ Complete!
📄 /path/to/.reports/chrome-1234567890/summary.md
```

**What you'll see in main Claude Code conversation:**
- Just the summary (~300 tokens)
- No Chrome DevTools tools loaded
- Clean context window

---

## Troubleshooting Common Issues

### "ANTHROPIC_API_KEY not set"
```bash
# Check if set
echo $ANTHROPIC_API_KEY

# Set temporarily
export ANTHROPIC_API_KEY='sk-ant-...'

# Set permanently (add to ~/.bashrc or ~/.zshrc)
```

### "chrome-devtools-mcp: command not found"
```bash
# Reinstall globally
npm install -g chrome-devtools-mcp

# Check npm global path
npm config get prefix
# Ensure it's in your PATH
```

### "No module named 'claude_agent_sdk'"
```bash
# Check Python version (need 3.10+)
python3 --version

# Install SDK
pip install claude-agent-sdk

# If using virtual environment, activate it first
source venv/bin/activate
pip install claude-agent-sdk
```

### Sidecar hangs indefinitely
1. **Check if Chrome is already running:**
   ```bash
   # Kill any existing Chrome processes
   pkill -f chrome
   ```

2. **Check the error log:**
   ```bash
   # Look in the output directory
   cat .reports/chrome-*/error.log
   ```

3. **Run with verbose output:**
   ```bash
   python3 ~/.claude/tools/chrome-sidecar.py --url https://example.com --task "test" -v
   ```

---

## Quick Reference

### Command Format
```bash
/chrome-tools <url> "<task description>"
```

### Example Tasks

**Performance:**
```bash
/chrome-tools https://myapp.com "run full performance audit and identify LCP bottlenecks"
```

**Console Errors:**
```bash
/chrome-tools https://myapp.com "check all console errors and warnings"
```

**Network Analysis:**
```bash
/chrome-tools https://myapp.com "analyze network requests and find slow endpoints"
```

**Screenshots:**
```bash
/chrome-tools https://myapp.com "take screenshots of the homepage in different viewport sizes"
```

**Combined:**
```bash
/chrome-tools https://myapp.com "full audit: performance, console errors, network, and screenshots"
```

---

## File Structure

After installation, you'll have:

```
~/.claude/
├── tools/
│   └── chrome-sidecar.py          # Sidecar agent script
└── commands/
    └── chrome-tools.md             # Slash command definition

your-project/
└── .reports/                       # Created on first run
    └── chrome-1234567890/          # Timestamped output
        ├── summary.md              # Analysis summary
        ├── screenshot-*.png        # Screenshots (if any)
        └── trace-*.json            # Traces (if any)
```

---

## Next Steps

1. **Read the full guide:** `mcp-sidecar-honest-guide.md` for in-depth understanding
2. **Customize the script:** Edit system prompt in `chrome-sidecar.py` for your needs
3. **Share with team:** Create a plugin for one-command installation
4. **Consider alternatives:** Review "Better Alternatives" section in full guide

---

## When to Use vs. Skip

### ✅ Use the sidecar when:
- Your main conversation is >150k tokens
- You need Chrome analysis 1-5 times per day
- You're generating large artifacts (traces, many screenshots)

### ❌ Skip the sidecar when:
- You need fast iteration (use dynamic toggle: `/mcp chrome-devtools enable`)
- You analyze frequently (just add to .mcp.json)
- Your main conversation has plenty of room

---

## Getting Help

- **Issues with Agent SDK:** https://github.com/anthropics/claude-agent-sdk-python/issues
- **Chrome DevTools MCP:** https://github.com/modelcontextprotocol/servers/tree/main/src/chrome-devtools
- **Claude Code docs:** https://docs.claude.com/en/docs/claude-code/overview

---

## Clean Uninstall

If you want to remove everything:

```bash
# Remove the sidecar
rm ~/.claude/tools/chrome-sidecar.py

# Remove the slash command
rm ~/.claude/commands/chrome-tools.md

# Remove generated reports
rm -rf .reports/

# Uninstall packages (optional)
pip uninstall claude-agent-sdk
npm uninstall -g chrome-devtools-mcp
```

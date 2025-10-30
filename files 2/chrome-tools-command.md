---
name: chrome-tools
description: Run Chrome DevTools analysis via sidecar agent (reduced main context cost)
allowed-tools: 
  - Bash(python3:*)
argument-hint: <url> "<task description>"
---

# Chrome DevTools Analysis (Sidecar Mode)

Analyzing: $ARGUMENTS

**Note:** This runs a separate Agent SDK process. The Chrome DevTools MCP tools (~20k tokens) load in the sidecar, not your main conversation.

## Running Analysis...

```bash
python3 ~/.claude/tools/chrome-sidecar.py $ARGUMENTS
```

---

**First run?** Install dependencies:
```bash
pip install claude-agent-sdk
npm install -g chrome-devtools-mcp
export ANTHROPIC_API_KEY='your-key-here'
```

**Performance:** Each run spawns Chrome + MCP server (~30-60s). This is a trade-off for keeping your main context clean.

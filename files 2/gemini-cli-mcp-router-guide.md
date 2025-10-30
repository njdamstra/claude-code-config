# Gemini-CLI as MCP Router: The Smart Solution

## The Brilliant Insight

Instead of loading heavy MCP servers in Claude Code, configure them in **gemini-cli** and let Claude Code delegate to Gemini when needed. This keeps your Claude Code context clean while giving you access to powerful tools.

## How It Works

```
┌─────────────────────────────────────┐
│  Main Claude Code Conversation      │
│  Context: Clean (no chrome tools)   │
│                                     │
│  "Use gemini-cli to analyze..."    │
└──────────────┬──────────────────────┘
               │ gemini-cli:ask-gemini tool
               ↓
┌─────────────────────────────────────┐
│  Gemini CLI (Separate Process)      │
│  Has chrome-devtools MCP configured │
│  - Gemini uses chrome tools         │
│  - Performs analysis                │
│  - Returns summary                  │
└──────────────┬──────────────────────┘
               │ Returns ~300 token summary
               ↓
┌─────────────────────────────────────┐
│  Main Claude Code Conversation      │
│  Receives: Summary only             │
│  Cost: ~500 tokens total            │
│  (Not 20k+ for chrome tools!)       │
└─────────────────────────────────────┘
```

## Why This is Better Than Sidecars

| Aspect | Sidecar Pattern | Gemini-CLI Router |
|--------|----------------|------------------|
| Setup | Complex (Python SDK, scripts) | Simple (edit JSON) |
| Speed | 30-60s (spawn process) | 2-5s (already running) |
| Cost | Claude pricing (both agents) | Gemini pricing (cheaper) |
| Integration | Custom slash command | Native gemini-cli tool |
| Persistence | Fresh each time | Persistent connection |
| File reading | Limited | Excellent (Gemini strength) |

## Step-by-Step Setup

### 1. Verify gemini-cli is in Claude Code

Check if you already have it:

```bash
# In Claude Code
/tools

# Look for: gemini-cli:ask-gemini
```

If you don't see it, add the gemini-cli MCP:

```bash
claude mcp add gemini-cli --scope user
```

### 2. Configure Chrome DevTools in Gemini CLI

Edit `~/.gemini/settings.json`:

```bash
# Open the file
code ~/.gemini/settings.json
# or
vim ~/.gemini/settings.json
```

Add chrome-devtools to the `mcpServers` section:

```json
{
  "theme": "your-theme",
  "selectedAuthType": "your-auth",
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000
    }
  }
}
```

**If you already have other MCP servers configured**, just add chrome-devtools:

```json
{
  "mcpServers": {
    "existing-server": {
      "command": "...",
      "args": ["..."]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000
    }
  }
}
```

### 3. Verify Gemini CLI Sees Chrome Tools

Open Gemini CLI separately (not in Claude Code):

```bash
gemini

# Check MCP servers
/mcp

# You should see chrome-devtools listed as CONNECTED
```

### 4. Test the Setup

In Gemini CLI directly:

```bash
Please check the LCP of https://web.dev
```

Gemini should use chrome-devtools MCP tools to analyze the page.

### 5. Use in Claude Code

Now in your **main Claude Code conversation**, delegate to Gemini:

```
Use gemini-cli to analyze https://example.com with Chrome DevTools:
1. Navigate to the page
2. Check console for errors
3. Run performance audit
4. Take screenshot
5. Provide summary with key issues
```

Claude Code will:
1. Call `gemini-cli:ask-gemini` tool
2. Gemini uses chrome-devtools MCP internally
3. Returns summary to Claude Code
4. Your main conversation stays clean!

---

## Advanced Configuration

### Multiple Heavy MCP Servers in Gemini

You can configure ALL heavy MCP servers in Gemini CLI:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "timeout": 60000
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"],
      "timeout": 60000
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"],
      "timeout": 60000
    }
  }
}
```

Now Gemini can use **all** these tools while Claude Code stays lean!

### Custom Gemini Instructions

Create `~/.gemini/GEMINI.md` to guide how Gemini uses these tools:

```markdown
# Gemini Chrome Analysis Guidelines

When analyzing web pages with Chrome DevTools:

1. **Always navigate first** before running traces
2. **Save artifacts** to /tmp/gemini-chrome-reports/
3. **Return concise summaries** (<500 words)
4. **Prioritize actionable findings**
5. **Include specific metrics** (LCP, CLS, TBT)

## Response Format

### Key Findings
- [3-5 bullet points]

### Critical Issues
- [Specific problems with severity]

### Recommendations
1. [Actionable fix with expected impact]
2. [Another specific recommendation]

### Artifacts
- [Paths to saved files]
```

### Trust Settings for Automation

If you want Gemini to use chrome-devtools without confirmation:

```json
{
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

⚠️ **Warning:** Only use `trust: true` for tools you completely control.

### Filtering Tools

Limit which chrome-devtools tools Gemini can use:

```json
{
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
        "performance_stop_trace"
      ]
    }
  }
}
```

This reduces context even in Gemini CLI.

---

## Usage Patterns in Claude Code

### Pattern 1: Direct Delegation

```
Use gemini-cli to check https://myapp.com for console errors and performance issues
```

Claude Code calls gemini-cli → Gemini uses chrome-devtools → Returns summary

### Pattern 2: Explicit Instructions

```
Delegate to gemini-cli:

Task: Comprehensive Chrome analysis of https://myapp.com
Requirements:
- Performance trace (focus on LCP)
- Console errors and warnings
- Network requests (identify slow endpoints)
- Screenshots (desktop and mobile viewports)
- Accessibility issues

Format: Concise report with actionable recommendations
```

### Pattern 3: As Part of Workflow

```
I need to optimize this page's performance:

1. First, use gemini-cli to run Chrome DevTools analysis on https://myapp.com
2. Review the findings and identify the top 3 issues
3. Create a plan to fix each issue
4. Implement the fixes in the codebase
5. Use gemini-cli again to verify improvements
```

### Pattern 4: Large File Analysis + Chrome

```
Use gemini-cli to:
1. Read the full implementation from largefile.js (you're good at large files!)
2. Analyze the live site at https://myapp.com with Chrome DevTools
3. Compare expected behavior vs actual behavior
4. Identify discrepancies
```

---

## Real-World Examples

### Example 1: Pre-Deploy Performance Check

**You:** "Before deploying, use gemini-cli to audit the staging site at https://staging.myapp.com - focus on Core Web Vitals"

**Claude Code calls gemini-cli → Gemini uses chrome-devtools →** Returns:

```markdown
## Performance Audit Results

### Core Web Vitals
- LCP: 3.2s (❌ Needs Improvement, target <2.5s)
- CLS: 0.05 (✅ Good)
- FID: 45ms (✅ Good)

### Critical Issues
1. **Large hero image** (2.4MB) delays LCP
   - Recommendation: Use WebP format, lazy load
   - Expected improvement: 1.5s faster LCP

2. **Render-blocking CSS** delays initial paint
   - Recommendation: Inline critical CSS
   - Expected improvement: 0.5s faster

### Artifacts
- Full trace: /tmp/gemini-chrome-reports/trace-1234567890.json
```

### Example 2: Debug Console Errors

**You:** "Users report checkout isn't working. Use gemini-cli to check https://myapp.com/checkout for JS errors"

**Gemini returns:**

```markdown
## Console Errors Found

### Critical Error
```
Uncaught TypeError: Cannot read property 'price' of undefined
  at checkout.js:145
```

### Root Cause
The `cart.items` array is empty when `calculateTotal()` runs

### Recommendation
Add null check before accessing item properties:
```javascript
const total = cart.items?.reduce((sum, item) => 
  sum + (item?.price ?? 0), 0) ?? 0;
```
```

### Example 3: Compare Implementations

**You:** "Use gemini-cli to read the full spec from design-doc.md (20k tokens), then analyze how we actually implemented it at https://myapp.com"

**Gemini leverages:**
- Its large file reading capability
- Chrome DevTools for live analysis
- Returns comparison showing mismatches

---

## Cost Comparison

### Traditional Approach (Chrome MCP in Claude Code)

```
Main conversation:
├─ Chrome DevTools MCP tools: 20,600 tokens
├─ Your conversation: 50,000 tokens
├─ File context: 30,000 tokens
└─ Total: 100,600 tokens

Analysis:
└─ Claude API: 100,600 tokens × $3/M = $0.30

Every conversation: $0.30+ before you even start
```

### Gemini-CLI Router Approach

```
Main conversation:
├─ gemini-cli tool: 200 tokens
├─ Your conversation: 50,000 tokens
├─ File context: 30,000 tokens
└─ Total: 80,200 tokens

Gemini analysis:
└─ Gemini API: 5,000 tokens × $0.075/M = $0.0004

Per analysis:
├─ Claude: 80,200 tokens × $3/M = $0.24
├─ Gemini: 5,000 tokens × $0.075/M = $0.0004
└─ Total: $0.2404

Savings: $0.06 per conversation
        + 20k tokens freed for other context
```

**Over 100 analyses:** Save $6 + 2M tokens of context

---

## Troubleshooting

### "Gemini CLI not found in Claude Code tools"

```bash
# Add gemini-cli MCP to Claude Code
claude mcp add gemini-cli --scope user
```

### "chrome-devtools server not connecting in Gemini"

```bash
# Test in standalone Gemini CLI
gemini
/mcp

# If status shows DISCONNECTED, check:
1. Node.js installed? (node --version)
2. NPM access? (npm --version)
3. Chrome installed?

# Try manual install:
npm install -g chrome-devtools-mcp
npx chrome-devtools-mcp --help
```

### "Gemini says it can't use Chrome tools"

Edit `~/.gemini/settings.json` and ensure:
1. `chrome-devtools` is in `mcpServers`
2. Command is correct: `"npx"`
3. Args include: `["-y", "chrome-devtools-mcp@latest"]`
4. Restart Gemini CLI after changes

### "Claude Code doesn't call gemini-cli automatically"

Be explicit in your prompt:

```
❌ Bad: "Check the page performance"
✅ Good: "Use gemini-cli to check the page performance with Chrome DevTools"
```

Claude Code needs clear instruction to use the tool.

### "Response is too verbose"

Add instructions to your prompt:

```
Use gemini-cli to analyze https://example.com
Return: Concise summary (<300 words), top 3 issues only
```

Or configure in `~/.gemini/GEMINI.md` as shown in Advanced Configuration.

---

## Expanding the Pattern

### Other Heavy MCPs to Route Through Gemini

```json
{
  "mcpServers": {
    "chrome-devtools": { ... },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    },
    "selenium": {
      "command": "python",
      "args": ["-m", "selenium_mcp"]
    },
    "database-heavy": {
      "command": "npx",
      "args": ["-y", "your-heavy-db-mcp"]
    }
  }
}
```

**When to route through Gemini:**
- ✅ Tool has 15+ functions (heavy context)
- ✅ Used infrequently (1-5x per session)
- ✅ Generates large outputs (traces, dumps)
- ✅ Benefits from Gemini's strengths (large files, cheap)

**When to keep in Claude Code:**
- ❌ Used constantly (file operations, bash)
- ❌ Small tool set (<5 functions)
- ❌ Needs tight integration with code changes

---

## Best Practices

### 1. Clear Delegation Prompts

```
✅ "Use gemini-cli to analyze https://example.com with Chrome DevTools"
✅ "Delegate to gemini-cli: check console errors on the site"
✅ "Have gemini-cli run performance audit using chrome-devtools MCP"

❌ "Check the website" (unclear which tool to use)
❌ "Use chrome tools" (claude doesn't have them)
```

### 2. Leverage Gemini's Strengths

```
Use gemini-cli to:
- Read the 50k line file (gemini handles large files well)
- Analyze it with Chrome DevTools
- Compare actual vs expected behavior
```

### 3. Structured Requests

```
Use gemini-cli for Chrome analysis:

Site: https://myapp.com
Focus:
  - Performance (LCP, CLS, TBT)
  - Console errors
  - Network issues

Format:
  - Key findings (3-5 bullets)
  - Critical issues with severity
  - Actionable recommendations
```

### 4. Iterative Analysis

```
1. Use gemini-cli to audit https://myapp.com
2. [Review results]
3. Use gemini-cli again to verify fix for [specific issue]
```

---

## When This Pattern Shines

### ✅ Perfect Use Cases

1. **Infrequent heavy operations**
   - Pre-deploy checks
   - Weekly performance audits
   - Incident debugging

2. **Large file + browser analysis**
   - Read 20k line spec
   - Verify implementation in browser
   - Gemini excels at both

3. **Cost-sensitive workflows**
   - High-volume analysis
   - Budget constraints
   - Gemini is 40x cheaper

4. **Multiple heavy MCPs**
   - Chrome + Playwright + Selenium
   - All routed through Gemini
   - Claude Code stays pristine

### ❌ Not Ideal For

1. **Rapid iteration**
   - Need immediate tool access
   - No delegation overhead
   - Keep tools in Claude Code

2. **Tight code integration**
   - Edit file → test in browser → edit again
   - Direct access is faster

---

## Comparison: All Approaches

| Approach | Context Cost | Setup | Speed | Best For |
|----------|-------------|-------|-------|----------|
| **Direct MCP** | 20k+ tokens | Simple | Instant | Frequent use |
| **Dynamic Toggle** | 20k when on | Simple | Instant | Occasional use |
| **Sidecar Agent** | ~500 tokens | Complex | 30-60s | Rare, isolated |
| **Gemini Router** | ~500 tokens | Easy | 2-5s | Infrequent, cheap ✨ |

---

## Conclusion

The gemini-cli router pattern is the **sweet spot** for most use cases:

- ✅ Simple setup (edit one JSON file)
- ✅ Cheap (Gemini pricing)
- ✅ Fast (no subprocess spawning)
- ✅ Clean (Claude Code context pristine)
- ✅ Powerful (full chrome-devtools access)
- ✅ Extensible (add more heavy MCPs)

You've discovered a better mousetrap. This is how you **should** handle heavy MCP servers in Claude Code.

---

## Quick Start Checklist

- [ ] Verify gemini-cli tool in Claude Code (`/tools`)
- [ ] Edit `~/.gemini/settings.json`
- [ ] Add chrome-devtools to mcpServers
- [ ] Test in standalone Gemini CLI
- [ ] Verify with `/mcp` command
- [ ] Try analysis in Claude Code
- [ ] Celebrate clean context! 🎉

---

## Resources

- [Gemini CLI Docs](https://google-gemini.github.io/gemini-cli/)
- [Gemini MCP Configuration](https://google-gemini.github.io/gemini-cli/docs/tools/mcp-server.html)
- [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp)
- [MCP Specification](https://spec.modelcontextprotocol.io/)

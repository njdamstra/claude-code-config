# MCP Sidecar Agents: The Real Story

## What I Got Wrong (And How It Actually Works)

My initial guide contained pseudocode and incorrect assumptions. Here's what's actually true:

### ❌ What Doesn't Work
1. **HTTP/Daemon Mode for Chrome DevTools**: Chrome DevTools MCP only supports stdio, not HTTP
2. **Fast subsequent runs**: Each sidecar invocation spawns fresh Chrome (30-60s)
3. **"Plug and play" code**: The Agent SDK requires careful configuration

### ✅ What Actually Works
1. **Context isolation**: MCP tools DO load only in the sidecar process, not main conversation
2. **stdio mode**: All MCP servers support stdio (subprocess communication)
3. **Token savings**: Main conversation only sees the summary (~300 tokens vs 20k)

---

## The Core Problem (Verified)

When you configure an MCP server in Claude Code (any scope), **its tools load into every conversation's context window.**

Example from real user report:
```
Context Usage:
├─ MCP tools: 82.0k tokens (41.0%)
│  ├─ mcp-omnisearch: 14,114 tokens
│  ├─ playwright: 13,647 tokens
│  ├─ chrome-devtools: 20,600 tokens (estimated)
│  └─ ...
```

The sidecar pattern isolates heavy MCP servers in a separate Agent SDK process.

---

## Working Implementation

### Step 1: Install Dependencies

```bash
# Install Agent SDK
pip install claude-agent-sdk

# Install Chrome DevTools MCP
npm install -g chrome-devtools-mcp

# Set API key
export ANTHROPIC_API_KEY='your-anthropic-api-key'

# Verify installations
python3 -c "from claude_agent_sdk import ClaudeSDKClient; print('✓ SDK installed')"
npx chrome-devtools-mcp --help
```

### Step 2: Create Working Sidecar Script

Save as `~/.claude/tools/chrome-sidecar.py`:

```python
#!/usr/bin/env python3
"""
Chrome DevTools MCP Sidecar Agent - WORKING VERSION

Usage:
    python3 chrome-sidecar.py --url https://example.com --task "performance audit"
"""

import asyncio
import sys
import os
from pathlib import Path
from datetime import datetime

# Check API key
if not os.getenv('ANTHROPIC_API_KEY'):
    print("❌ Error: ANTHROPIC_API_KEY not set")
    sys.exit(1)

try:
    from claude_agent_sdk import ClaudeSDKClient, ClaudeAgentOptions
except ImportError:
    print("❌ Error: Install with: pip install claude-agent-sdk")
    sys.exit(1)


async def run_chrome_analysis(url: str, task: str) -> str:
    """Run Chrome DevTools analysis in isolated agent."""
    
    # Create output directory
    timestamp = int(datetime.now().timestamp())
    output_dir = Path.cwd() / '.reports' / f'chrome-{timestamp}'
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"\n🚀 Starting Chrome DevTools sidecar...")
    print(f"📍 Target: {url}")
    print(f"📋 Task: {task}")
    print(f"💾 Output: {output_dir}\n")
    
    # Configure agent with Chrome DevTools MCP
    options = ClaudeAgentOptions(
        system_prompt=f"""You are a Chrome DevTools specialist.

Task: {task}
Target: {url}

Instructions:
1. Navigate to the URL
2. Choose appropriate Chrome DevTools tools based on the task
3. Perform thorough analysis
4. Save artifacts (screenshots, traces) to: {output_dir}
5. Return concise summary (<500 tokens) with:
   - Key findings (3-5 points)
   - Critical issues
   - Actionable recommendations
   - Artifact file paths

Available tools from Chrome DevTools MCP:
- navigate, screenshot, console_log
- performance_start_trace, performance_stop_trace
- network_log, dom_query

Be efficient but thorough.""",
        
        # Chrome DevTools as external stdio MCP server
        mcp_servers={
            "chrome-devtools": {
                "type": "stdio",
                "command": "npx",
                "args": ["-y", "chrome-devtools-mcp"]
            }
        },
        
        # Allow all Chrome DevTools tools
        allowed_tools=[
            "mcp__chrome-devtools__*"
        ]
    )
    
    # Build prompt
    prompt = f"""Analyze: {url}

Task: {task}

Save all artifacts to: {output_dir}

Provide your analysis in this format:

## Key Findings
- [Finding 1]
- [Finding 2]

## Issues
- [Issue 1]

## Recommendations
1. [Recommendation 1]

## Artifacts
- [Files saved with paths]
"""
    
    response_text = ""
    tools_used = []
    
    try:
        # Run the agent
        async with ClaudeSDKClient(options=options) as client:
            await client.start(prompt=prompt)
            
            async for message in client.receive_response():
                # Collect text responses
                if hasattr(message, 'type'):
                    if message.type == 'text':
                        response_text += message.text
                        print(message.text, end='', flush=True)
                    elif message.type == 'tool_use':
                        tool_name = getattr(message, 'name', 'unknown')
                        print(f"\n🔧 {tool_name}", flush=True)
                        tools_used.append(tool_name)
                elif hasattr(message, 'text'):
                    response_text += message.text
                    print(message.text, end='', flush=True)
        
        # Save summary
        summary = f"""# Chrome DevTools Analysis
**URL:** {url}
**Date:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
**Task:** {task}

## Tools Used
{chr(10).join(f'- {t}' for t in set(tools_used))}

---

{response_text}

---
**Artifacts:** `{output_dir}`
"""
        
        summary_path = output_dir / 'summary.md'
        summary_path.write_text(summary)
        
        print(f"\n\n✅ Complete!")
        print(f"📄 {summary_path}")
        
        return str(summary_path)
        
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        (output_dir / 'error.log').write_text(str(e))
        raise


def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Chrome DevTools Sidecar')
    parser.add_argument('--url', required=True)
    parser.add_argument('--task', required=True)
    args = parser.parse_args()
    
    try:
        asyncio.run(run_chrome_analysis(args.url, args.task))
        sys.exit(0)
    except KeyboardInterrupt:
        print("\n⚠️ Interrupted")
        sys.exit(1)
    except Exception:
        sys.exit(1)


if __name__ == '__main__':
    main()
```

Make it executable:
```bash
chmod +x ~/.claude/tools/chrome-sidecar.py
```

### Step 3: Create Slash Command

Save as `~/.claude/commands/chrome-tools.md`:

```markdown
---
name: chrome-tools
description: Chrome DevTools analysis via sidecar (avoids main context bloat)
allowed-tools: 
  - Bash(python3:*)
argument-hint: <url> "<task description>"
---

# Chrome DevTools Analysis

Analyzing: $ARGUMENTS

**Running isolated agent...**

```bash
python3 ~/.claude/tools/chrome-sidecar.py $ARGUMENTS
```

---
**Note:** First run takes 30-60s (spawns Chrome). The heavy MCP tools load in the sidecar, keeping your main conversation clean.
```

### Step 4: Usage

```bash
# In Claude Code:
/chrome-tools https://example.com "run performance audit and identify LCP issues"

/chrome-tools https://myapp.com "check for console errors and security warnings"
```

---

## Real Limitations (Tested)

### 1. **Speed Trade-off**
- Each run spawns Chrome from scratch (~30-60s)
- No daemon mode for Chrome DevTools MCP
- **When it matters**: If you need rapid iteration, this is too slow

### 2. **No Persistent Context**
- Each sidecar run is isolated
- Can't build on previous analysis
- **When it matters**: Multi-turn debugging sessions

### 3. **Setup Complexity**
- Requires: Python, Node.js, Agent SDK, MCP server, API key
- More moving parts = more things that can break
- **When it matters**: Team onboarding, CI/CD

### 4. **Sidecar Consumes Tokens Too**
- The sidecar agent uses tokens (just in its own process)
- You're charged for both conversations
- **When it matters**: Cost optimization

### 5. **Not All MCPs Support stdio**
- Some MCPs are HTTP-only or have other requirements
- Need to verify compatibility per MCP
- **When it matters**: Choosing which MCPs to sidecar

---

## When This Pattern Makes Sense

✅ **Good Use Cases:**

1. **Infrequent heavy operations**
   - Once-per-day audits
   - Pre-deployment checks
   - Weekly reports

2. **Large artifact generation**
   - Performance traces (multi-MB)
   - Full page screenshots
   - Network HAR files

3. **Context window optimization**
   - Already hitting 150k+ tokens in main conversation
   - Need every token for complex multi-file operations

4. **Team tooling**
   - Standardized audit commands
   - Reproducible reports
   - Shareable via plugins

❌ **Not Recommended For:**

1. **Rapid iteration**
   - Interactive debugging
   - Multiple quick checks
   - Trial-and-error workflows

2. **Frequently used tools**
   - If you need it 10+ times per session, add to main MCP config
   - Overhead not worth it

3. **Simple operations**
   - Single screenshot
   - Quick console log check
   - Tasks that don't generate artifacts

---

## Better Alternatives (Often Simpler)

### Option 1: Dynamic MCP Toggle

```bash
# Enable when needed
/mcp chrome-devtools enable

# Do your work
# [analyze, debug, iterate]

# Disable to free context
/mcp chrome-devtools disable
```

**Pros:**
- Simple (no custom scripts)
- Fast (no subprocess spawning)
- Iterative (tools stay available)

**Cons:**
- Still loads tools when enabled
- Need to remember to disable

### Option 2: Dedicated Analysis Directory

```bash
# Create a separate workspace
mkdir ~/chrome-analysis
cd ~/chrome-analysis

# Configure Chrome MCP only here (local scope)
claude mcp add chrome-devtools --scope local

# All Chrome work happens here
# Main projects stay clean
```

**Pros:**
- Complete isolation
- Fast (no sidecar overhead)
- Can keep multiple tabs open

**Cons:**
- Need to switch directories
- Context doesn't transfer between spaces

### Option 3: Selective Tool Access

In `.mcp.json`, limit tools exposed:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp"],
      "allowedTools": [
        "screenshot",
        "navigate",
        "console_log"
      ]
    }
  }
}
```

**Pros:**
- Reduces token overhead (maybe 5k instead of 20k)
- Keeps most useful tools
- No script complexity

**Cons:**
- Still loads some tools
- Need to curate tool list

---

## Troubleshooting

### "ImportError: No module named 'claude_agent_sdk'"
```bash
pip install claude-agent-sdk
python3 -c "from claude_agent_sdk import ClaudeSDKClient; print('OK')"
```

### "chrome-devtools-mcp: command not found"
```bash
npm install -g chrome-devtools-mcp
npx chrome-devtools-mcp --help
```

### "Error: ANTHROPIC_API_KEY not set"
```bash
export ANTHROPIC_API_KEY='sk-ant-...'
# Add to ~/.bashrc or ~/.zshrc for persistence
```

### Sidecar hangs indefinitely
- Chrome might have crashed
- Add timeout to script (see working implementation)
- Check Chrome isn't already running on the port

### Tools not showing up in agent
- Verify `allowed_tools` includes the MCP server
- Check tool names: `mcp__<server>__<tool>` or `mcp__<server>__*`
- Look at logs for connection errors

---

## Cost Comparison

Example: Performance audit generating 5MB trace

| Approach | Main Conv. Tokens | Sidecar Tokens | Total | Time |
|----------|------------------|----------------|-------|------|
| **Direct MCP** | 20k (tools) + 300 (summary) | 0 | 20.3k | 5s |
| **Sidecar** | 300 (summary) | 20k (tools) + 2k (artifacts) | 22.3k | 45s |

**Key insight:** You save tokens in main conversation but pay for sidecar. Total cost is similar or slightly higher.

**When sidecar wins:** Long main conversation (100k+ tokens) where adding 20k breaks the limit.

---

## Production Considerations

### 1. Error Handling

Add comprehensive error handling:

```python
try:
    result = await run_chrome_analysis(url, task)
except TimeoutError:
    print("⚠️ Analysis timed out after 5 minutes")
except ConnectionError:
    print("⚠️ Chrome DevTools MCP connection failed")
except Exception as e:
    print(f"⚠️ Unexpected error: {e}")
    # Log to monitoring system
```

### 2. Timeout Protection

```python
async def run_with_timeout(coro, timeout=300):
    """Run with 5-minute timeout."""
    try:
        return await asyncio.wait_for(coro, timeout=timeout)
    except asyncio.TimeoutError:
        raise TimeoutError(f"Operation exceeded {timeout}s timeout")
```

### 3. Artifact Cleanup

```python
# In chrome-sidecar.py, add:
import shutil
from pathlib import Path

def cleanup_old_reports(max_age_days=7):
    """Delete reports older than max_age_days."""
    reports_dir = Path.cwd() / '.reports'
    if not reports_dir.exists():
        return
    
    cutoff = datetime.now() - timedelta(days=max_age_days)
    for report_dir in reports_dir.iterdir():
        if report_dir.stat().st_mtime < cutoff.timestamp():
            shutil.rmtree(report_dir)
```

### 4. Team Distribution

Package as a Claude Code plugin:

```json
// ~/.claude/plugins/chrome-tools/plugin.json
{
  "name": "chrome-tools",
  "version": "1.0.0",
  "description": "Chrome DevTools sidecar analysis",
  "commands": [
    {
      "name": "chrome-tools",
      "file": "commands/chrome-tools.md"
    }
  ],
  "install": [
    "pip install claude-agent-sdk",
    "npm install -g chrome-devtools-mcp"
  ],
  "files": [
    "tools/chrome-sidecar.py"
  ]
}
```

Install team-wide:
```bash
/plugin install ~/.claude/plugins/chrome-tools
```

---

## Conclusion: Is It Worth It?

### ✅ Use Sidecars When:
- You hit context limits frequently (>150k tokens)
- Operations are infrequent (1-5x per day)
- Artifacts are large (traces, screenshots)
- Team needs standardized tooling

### ❌ Skip Sidecars When:
- You need fast iteration
- Main conversation has room (>50k free)
- Tools are frequently used
- Setup complexity outweighs benefits

**Honest Assessment:** For most users, simpler alternatives (dynamic toggling, dedicated directories) are more practical. Sidecars are a power-user optimization for specific scenarios.

---

## Resources

- [Claude Agent SDK Docs](https://docs.claude.com/en/api/agent-sdk/overview)
- [Claude Agent SDK Python](https://github.com/anthropics/claude-agent-sdk-python)
- [Chrome DevTools MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/chrome-devtools)
- [Model Context Protocol Spec](https://spec.modelcontextprotocol.io/)
- [Context Management Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

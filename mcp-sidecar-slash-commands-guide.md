# MCP Sidecar Agents: Slash Command Pattern for Claude Code

## The Problem

**MCP tools configured in Claude Code always load into your conversation context**, regardless of scope (local/project/user). This creates significant token overhead:

- Chrome DevTools MCP: ~20,600 tokens (10.3% of 200k context)
- Multiple MCP servers can consume 40%+ of your context window before you even start
- Scope only controls WHERE tools are available, not WHEN they load

**The Solution:** Sidecar agents - isolated Agent SDK processes that run heavy MCPs separately and return only summaries to your main conversation.

## How Sidecar Agents Work

```
┌─────────────────────────────────────┐
│   Main Claude Code Conversation    │
│   (Clean, minimal context)          │
│                                     │
│   User: /chrome-tools https://...  │
│         ↓                           │
│   Slash command triggers script     │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│   Sidecar Agent (Separate Process)  │
│   - Spawns with Agent SDK           │
│   - Loads Chrome DevTools MCP       │
│   - Runs agentic analysis          │
│   - Saves artifacts to disk         │
│   - Returns compact summary         │
└──────────────┬──────────────────────┘
               │
               ↓ (Only summary + paths)
┌─────────────────────────────────────┐
│   Main Conversation                 │
│   Gets: markdown summary + links    │
│   Cost: ~300 tokens (not 20k)       │
└─────────────────────────────────────┘
```

## Key Limitations

1. **Setup Complexity**: Requires Node.js, Agent SDK, and MCP servers installed separately
2. **No MCP in Main Config**: The heavy MCP server must NOT be in your `.mcp.json` or Claude Code will load it anyway
3. **Sidecar Isolation**: Each sidecar run is a fresh process with no memory of previous runs
4. **Token Budget**: Sidecar still consumes tokens, just in a separate process
5. **Best For**: Infrequent, heavy operations (audits, traces, bulk analysis) - not rapid iteration

## When to Use This Pattern

✅ **Good Use Cases:**
- Heavy MCP servers (20+ tools, verbose descriptions)
- Infrequent operations (once per session/day)
- Generates large artifacts (traces, screenshots, reports)
- Needs isolation from main conversation

❌ **Not Recommended For:**
- Frequently used tools (use main MCP config instead)
- Interactive debugging (too slow)
- Tools you need in multi-turn conversations
- Simple operations (overhead not worth it)

---

## Implementation: Chrome DevTools Example

### Prerequisites

```bash
# 1. Install Claude Agent SDK
npm install -g @anthropic-ai/claude-agent-sdk
# or for Python
pip install claude-agent-sdk

# 2. Install Chrome DevTools MCP server
npm install -g @modelcontextprotocol/server-chrome-devtools

# 3. Verify installations
npx @modelcontextprotocol/server-chrome-devtools --help
```

### Step 1: Create the Sidecar Script

Create `tools/chrome-sidecar.js`:

```javascript
#!/usr/bin/env node
/**
 * Chrome DevTools MCP Sidecar Agent
 * 
 * Runs Chrome analysis in isolation without loading tools into main conversation.
 * Usage: node chrome-sidecar.js --url https://example.com --task "performance audit"
 */

import { spawn } from 'child_process';
import { writeFileSync, mkdirSync } from 'fs';
import { join } from 'path';

// Parse arguments
const args = process.argv.slice(2);
const urlIndex = args.indexOf('--url');
const taskIndex = args.indexOf('--task');

if (urlIndex === -1 || taskIndex === -1) {
  console.error('Usage: node chrome-sidecar.js --url <url> --task "<task description>"');
  process.exit(1);
}

const targetUrl = args[urlIndex + 1];
const task = args[taskIndex + 1];

// Create output directory
const timestamp = Date.now();
const outputDir = join(process.cwd(), '.reports', `chrome-${timestamp}`);
mkdirSync(outputDir, { recursive: true });

console.log(`\n🚀 Starting Chrome DevTools sidecar agent...`);
console.log(`📍 Target: ${targetUrl}`);
console.log(`📋 Task: ${task}`);
console.log(`💾 Output: ${outputDir}\n`);

// Step 1: Spawn Chrome DevTools MCP server
const mcpServer = spawn('npx', [
  '@modelcontextprotocol/server-chrome-devtools',
  '--stdio'
], {
  stdio: ['pipe', 'pipe', 'pipe']
});

// Step 2: Use Claude Agent SDK to interact with MCP server
// This is pseudocode - adapt to actual Agent SDK API
async function runAnalysis() {
  try {
    // Import Agent SDK (syntax varies by version)
    const { ClaudeSDKClient, ClaudeAgentOptions } = await import('@anthropic-ai/claude-agent-sdk');
    
    const options = {
      systemPrompt: `You are a Chrome DevTools specialist. Your task: ${task}
      
Rules:
- Be agentic: examine the URL, choose appropriate tools, run analysis
- Save all artifacts (traces, screenshots, HAR files) to the output directory
- Return a concise markdown summary with key findings
- Keep your response under 500 tokens - focus on actionable insights`,
      
      mcpServers: {
        'chrome-devtools': {
          type: 'stdio',
          command: 'npx',
          args: ['@modelcontextprotocol/server-chrome-devtools', '--stdio']
        }
      },
      
      allowedTools: [
        'mcp__chrome-devtools__navigate',
        'mcp__chrome-devtools__performance_start_trace',
        'mcp__chrome-devtools__performance_stop_trace',
        'mcp__chrome-devtools__screenshot',
        'mcp__chrome-devtools__console_log',
        'mcp__chrome-devtools__network_log'
      ],
      
      workingDirectory: outputDir
    };
    
    const client = new ClaudeSDKClient({ options });
    
    // Run the analysis
    const prompt = `Analyze ${targetUrl}. ${task}`;
    
    let response = '';
    for await (const message of client.query(prompt)) {
      if (message.type === 'text') {
        response += message.text;
        process.stdout.write(message.text);
      }
    }
    
    // Save summary
    const summaryPath = join(outputDir, 'summary.md');
    writeFileSync(summaryPath, response);
    
    console.log(`\n\n✅ Analysis complete!`);
    console.log(`📄 Summary: ${summaryPath}`);
    
    return response;
    
  } catch (error) {
    console.error('❌ Error running analysis:', error);
    throw error;
  } finally {
    mcpServer.kill();
  }
}

// Run the analysis
runAnalysis().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
```

**Python Version** (if you prefer Python):

```python
#!/usr/bin/env python3
"""
Chrome DevTools MCP Sidecar Agent (Python)
Usage: python chrome-sidecar.py --url https://example.com --task "performance audit"
"""

import sys
import subprocess
import asyncio
from pathlib import Path
from datetime import datetime
from claude_agent_sdk import ClaudeSDKClient, ClaudeAgentOptions

async def run_analysis(url: str, task: str):
    # Create output directory
    timestamp = int(datetime.now().timestamp())
    output_dir = Path.cwd() / '.reports' / f'chrome-{timestamp}'
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"\n🚀 Starting Chrome DevTools sidecar agent...")
    print(f"📍 Target: {url}")
    print(f"📋 Task: {task}")
    print(f"💾 Output: {output_dir}\n")
    
    options = ClaudeAgentOptions(
        system_prompt=f"""You are a Chrome DevTools specialist. Your task: {task}

Rules:
- Be agentic: examine the URL, choose appropriate tools, run analysis
- Save all artifacts (traces, screenshots, HAR files) to the output directory
- Return a concise markdown summary with key findings
- Keep your response under 500 tokens - focus on actionable insights""",
        
        mcp_servers={
            'chrome-devtools': {
                'type': 'stdio',
                'command': 'npx',
                'args': ['@modelcontextprotocol/server-chrome-devtools', '--stdio']
            }
        },
        
        allowed_tools=[
            'mcp__chrome-devtools__navigate',
            'mcp__chrome-devtools__performance_start_trace',
            'mcp__chrome-devtools__performance_stop_trace',
            'mcp__chrome-devtools__screenshot',
            'mcp__chrome-devtools__console_log',
            'mcp__chrome-devtools__network_log'
        ],
        
        working_directory=str(output_dir)
    )
    
    async with ClaudeSDKClient(options=options) as client:
        prompt = f"Analyze {url}. {task}"
        
        response_text = ""
        async for message in client.query(prompt):
            if hasattr(message, 'text'):
                response_text += message.text
                print(message.text, end='', flush=True)
        
        # Save summary
        summary_path = output_dir / 'summary.md'
        summary_path.write_text(response_text)
        
        print(f"\n\n✅ Analysis complete!")
        print(f"📄 Summary: {summary_path}")
        
        return str(summary_path)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--url', required=True)
    parser.add_argument('--task', required=True)
    args = parser.parse_args()
    
    asyncio.run(run_analysis(args.url, args.task))
```

### Step 2: Create the Slash Command

Create `.claude/commands/chrome-tools.md`:

```markdown
---
name: chrome-tools
description: Run Chrome DevTools analysis via isolated sidecar agent (no context bloat)
allowed-tools: 
  - Bash(node:*)
  - Bash(python:*)
argument-hint: <url> "<task description>"
---

# Chrome DevTools Analysis

Running isolated Chrome analysis for: $ARGUMENTS

This command runs a separate Agent SDK process with Chrome DevTools MCP attached.
The main conversation stays clean - you'll only see the summary and artifact links.

## Executing Analysis...

```bash
# Choose your runtime (Node.js or Python)
node ./tools/chrome-sidecar.js $ARGUMENTS

# OR if using Python:
# python ./tools/chrome-sidecar.py $ARGUMENTS
```

---

**Note:** First run may take 30-60 seconds as it spawns Chrome and the MCP server.
Subsequent runs will be faster if Chrome stays warm.
```

### Step 3: Make Script Executable

```bash
chmod +x tools/chrome-sidecar.js
# or
chmod +x tools/chrome-sidecar.py
```

### Step 4: Usage Examples

```bash
# In Claude Code, use the slash command:
/chrome-tools https://example.com "Run performance audit and identify LCP issues"

/chrome-tools https://myapp.com "Check console errors and network failures"

/chrome-tools https://competitor.com "Take screenshots and analyze page structure"
```

**What Happens:**
1. Slash command triggers the sidecar script
2. Script spawns a separate Agent SDK process
3. That process loads Chrome DevTools MCP (in isolation)
4. Agent analyzes the site, saves artifacts
5. Returns compact summary to main conversation (~300 tokens)
6. Main conversation never loaded the 20k tokens of Chrome tools

---

## Advanced Patterns

### Pattern 1: Multiple Tool Choice

Make the sidecar smarter by letting it choose from multiple analysis types:

```javascript
// In chrome-sidecar.js system prompt:
systemPrompt: `Analyze the task and choose appropriate Chrome DevTools approaches:

Available analyses:
- Performance: LCP, CLS, TBT, JS execution time
- Network: Resource loading, failed requests, slow endpoints  
- Console: Errors, warnings, security issues
- Accessibility: ARIA, contrast, semantic HTML
- SEO: Meta tags, structured data, crawlability

Choose 1-3 relevant analyses based on the task. Run them sequentially.
Provide a unified summary with prioritized recommendations.`
```

### Pattern 2: Daemon Mode for Speed

Keep the MCP server running as a daemon:

```bash
# Start daemon once
npx @modelcontextprotocol/server-chrome-devtools --http 8787 &

# In sidecar script, connect via HTTP instead of stdio:
mcpServers: {
  'chrome-devtools': {
    type: 'http',
    url: 'http://localhost:8787'
  }
}

# Much faster subsequent runs (no cold start)
```

### Pattern 3: Team Sharing via Plugin

Package as a Claude Code plugin for one-command install:

```json
// .claude/plugins/chrome-tools/plugin.json
{
  "name": "chrome-tools",
  "version": "1.0.0",
  "description": "Chrome DevTools analysis without context bloat",
  "commands": [
    {
      "name": "chrome-tools",
      "file": "commands/chrome-tools.md"
    }
  ],
  "install": [
    "npm install -g @modelcontextprotocol/server-chrome-devtools",
    "npm install -g @anthropic-ai/claude-agent-sdk"
  ],
  "files": [
    "tools/chrome-sidecar.js"
  ]
}
```

Team members install with:
```bash
/plugin install ./chrome-tools
```

---

## Troubleshooting

### "Cannot find module @anthropic-ai/claude-agent-sdk"
```bash
npm install -g @anthropic-ai/claude-agent-sdk
# Ensure it's in your PATH
```

### "Chrome DevTools MCP connection failed"
```bash
# Test the MCP server directly
npx @modelcontextprotocol/server-chrome-devtools --stdio
# Should output JSON-RPC messages

# If fails, reinstall:
npm uninstall -g @modelcontextprotocol/server-chrome-devtools
npm install -g @modelcontextprotocol/server-chrome-devtools
```

### "Command hangs indefinitely"
- Sidecar agents have no timeout by default
- Add timeout to your script:
```javascript
const timeout = setTimeout(() => {
  console.error('Timeout after 5 minutes');
  mcpServer.kill();
  process.exit(1);
}, 5 * 60 * 1000);
```

### "Still seeing Chrome tools in /context"
You've configured Chrome DevTools in your `.mcp.json` or Claude Code config. Remove it:
```bash
claude mcp remove chrome-devtools
# The sidecar handles it separately
```

---

## Comparison: Sidecar vs Direct MCP

| Aspect | Direct MCP Config | Sidecar Pattern |
|--------|------------------|-----------------|
| Context cost | 20k tokens always | ~300 tokens per use |
| Setup | Simple (`claude mcp add`) | Complex (script + SDK) |
| Speed | Instant | 30-60s first run |
| Memory | Tools available all conversation | Fresh each run |
| Best for | Frequent operations | Rare, heavy operations |
| Team sharing | `.mcp.json` in repo | Plugin or script |

---

## Alternative Approaches

Before implementing sidecars, consider simpler alternatives:

### 1. Dynamic MCP Toggling
```bash
# Enable only when needed
/mcp chrome-devtools enable
# Use the tools
# Disable to free context
/mcp chrome-devtools disable
```

### 2. Dedicated Project
Create a separate project directory just for Chrome analysis:
```bash
mkdir ~/chrome-workspace
cd ~/chrome-workspace
claude mcp add chrome-devtools --scope local
# Use this directory only for Chrome tasks
```

### 3. Selective Tool Access
In `.mcp.json`, configure limited tools:
```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-chrome-devtools"],
      "allowedTools": [
        "screenshot",
        "navigate"
      ]
    }
  }
}
```

---

## Best Practices

1. **Return Artifacts, Not Data**: Save large outputs to files, return only paths
2. **Concise Summaries**: Instruct sidecar to return <500 token summaries
3. **Clear Instructions**: Be specific in task descriptions for better agentic behavior
4. **Error Handling**: Always wrap in try-catch and kill MCP subprocess
5. **Timeout Protection**: Add reasonable timeouts (2-5 minutes)
6. **Cache When Possible**: Use daemon mode for repeated analyses
7. **Document Requirements**: List prerequisites in README/CLAUDE.md

---

## Conclusion

The sidecar pattern trades setup complexity for context efficiency. It's powerful when:
- You need heavy MCPs occasionally (not constantly)
- Context optimization is critical
- You're hitting 200k token limits
- The operation generates large artifacts

For most use cases, standard MCP configuration is simpler and sufficient. Use sidecars judiciously for truly heavy operations where the benefits outweigh the complexity.

---

## Resources

- [Claude Agent SDK Documentation](https://docs.claude.com/en/api/agent-sdk/overview)
- [Model Context Protocol Spec](https://spec.modelcontextprotocol.io/)
- [Chrome DevTools MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/chrome-devtools)
- [Claude Code Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Context Management Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

#!/usr/bin/env python3
"""
Working Chrome DevTools MCP Sidecar Agent

This is a WORKING implementation using the Claude Agent SDK correctly.
Chrome DevTools MCP only supports stdio (not HTTP), so each run spawns a fresh process.

Usage:
    python3 chrome-sidecar.py --url https://example.com --task "performance audit"
"""

import asyncio
import sys
import os
from pathlib import Path
from datetime import datetime
import json

# Ensure ANTHROPIC_API_KEY is set
if not os.getenv('ANTHROPIC_API_KEY'):
    print("❌ Error: ANTHROPIC_API_KEY environment variable not set")
    print("Set it with: export ANTHROPIC_API_KEY='your-api-key'")
    sys.exit(1)

try:
    from claude_agent_sdk import ClaudeSDKClient, ClaudeAgentOptions
except ImportError:
    print("❌ Error: claude-agent-sdk not installed")
    print("Install with: pip install claude-agent-sdk")
    sys.exit(1)


async def run_chrome_analysis(url: str, task: str) -> str:
    """
    Run Chrome DevTools analysis using Agent SDK with MCP server.
    
    Args:
        url: Target URL to analyze
        task: Task description for the agent
    
    Returns:
        Path to the summary markdown file
    """
    # Create output directory
    timestamp = int(datetime.now().timestamp())
    output_dir = Path.cwd() / '.reports' / f'chrome-{timestamp}'
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"\n🚀 Starting Chrome DevTools sidecar agent...")
    print(f"📍 Target: {url}")
    print(f"📋 Task: {task}")
    print(f"💾 Output: {output_dir}\n")
    
    # Configure the agent with Chrome DevTools MCP server (stdio mode)
    options = ClaudeAgentOptions(
        system_prompt=f"""You are a Chrome DevTools specialist analyzing web pages.

Your task: {task}

Rules:
1. Use Chrome DevTools MCP tools to analyze {url}
2. Be thorough but efficient - choose the right tools for the task
3. Save any large outputs (traces, screenshots) to disk
4. Return a concise markdown summary with:
   - Key findings (3-5 bullet points)
   - Specific issues found
   - Actionable recommendations
   - Paths to any artifacts you saved
5. Keep your response under 500 tokens

Available tools:
- navigate: Load a URL in Chrome
- screenshot: Capture page screenshots
- console_log: Get console errors/warnings
- performance_start_trace/stop_trace: Capture performance data
- network_log: Analyze network requests

Start by navigating to the URL, then choose appropriate analysis tools based on the task.""",
        
        # Configure Chrome DevTools MCP as external stdio server
        mcp_servers={
            "chrome-devtools": {
                "type": "stdio",
                "command": "npx",
                "args": ["-y", "chrome-devtools-mcp"]
            }
        },
        
        # Allow Chrome DevTools tools (use wildcard for all tools from this server)
        # Note: This still loads tool descriptions into THIS agent's context,
        # but NOT into the main Claude Code conversation
        allowed_tools=[
            "mcp__chrome-devtools__*"
        ],
        
        # Working directory for saving artifacts
        # Note: This may not work as expected - the agent may save to CWD instead
        # We'll need to instruct it explicitly in the prompt
    )
    
    # Run the analysis
    try:
        prompt = f"""Analyze {url}.

Task details: {task}

Save any artifacts (traces, screenshots, logs) to: {output_dir}

After your analysis, provide a summary in this format:

## Analysis Summary

### Key Findings
- [Finding 1]
- [Finding 2]
- [Finding 3]

### Issues Detected
- [Issue 1 with severity]
- [Issue 2 with severity]

### Recommendations
1. [Actionable recommendation 1]
2. [Actionable recommendation 2]

### Artifacts
- [List any files you saved with their paths]
"""
        
        response_text = ""
        tool_uses = []
        
        async with ClaudeSDKClient(options=options) as client:
            await client.start(prompt=prompt)
            
            async for message in client.receive_response():
                # Handle different message types
                if hasattr(message, 'type'):
                    if message.type == 'text':
                        response_text += message.text
                        print(message.text, end='', flush=True)
                    elif message.type == 'tool_use':
                        tool_name = getattr(message, 'name', 'unknown')
                        print(f"\n🔧 Using tool: {tool_name}", flush=True)
                        tool_uses.append(tool_name)
                elif hasattr(message, 'text'):
                    response_text += message.text
                    print(message.text, end='', flush=True)
        
        # Save summary
        summary_path = output_dir / 'summary.md'
        
        full_summary = f"""# Chrome DevTools Analysis
**URL:** {url}
**Date:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
**Task:** {task}

## Tools Used
{chr(10).join(f'- {tool}' for tool in set(tool_uses))}

---

{response_text}

---

**Output Directory:** `{output_dir}`
"""
        
        summary_path.write_text(full_summary)
        
        print(f"\n\n✅ Analysis complete!")
        print(f"📄 Summary: {summary_path}")
        print(f"📁 All artifacts: {output_dir}")
        
        return str(summary_path)
        
    except Exception as e:
        error_msg = f"❌ Error during analysis: {str(e)}"
        print(error_msg, file=sys.stderr)
        
        # Save error log
        error_path = output_dir / 'error.log'
        error_path.write_text(f"{error_msg}\n\nTask: {task}\nURL: {url}")
        
        raise


def main():
    """Parse arguments and run analysis."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Chrome DevTools MCP Sidecar Agent',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 chrome-sidecar.py --url https://example.com --task "performance audit"
  python3 chrome-sidecar.py --url https://myapp.com --task "check console errors"
  
Environment:
  ANTHROPIC_API_KEY must be set
        """
    )
    
    parser.add_argument('--url', required=True, help='URL to analyze')
    parser.add_argument('--task', required=True, help='Analysis task description')
    
    args = parser.parse_args()
    
    # Run the analysis
    try:
        summary_path = asyncio.run(run_chrome_analysis(args.url, args.task))
        print(f"\n💡 View full report: {summary_path}")
        sys.exit(0)
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ Fatal error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()

# Claude Code Hooks: Comprehensive Reference Guide

**Author:** Verified from Anthropic Official Documentation + Community Best Practices  
**Last Updated:** October 2025  
**Status:** Single Source of Truth - Complete Technical Reference

---

## TABLE OF CONTENTS

1. [What Are Hooks](#what-are-hooks)
2. [Configuration Locations](#configuration-locations)
3. [Lifecycle Events Reference](#lifecycle-events-reference)
4. [JSON Payload Specifications](#json-payload-specifications)
5. [Hook Response Format](#hook-response-format)
6. [Environment Variables](#environment-variables)
7. [Best Practices & Patterns](#best-practices--patterns)
8. [Security Considerations](#security-considerations)
9. [Real-World Examples](#real-world-examples)
10. [Troubleshooting & Edge Cases](#troubleshooting--edge-cases)

---

## WHAT ARE HOOKS?

### Definition

Hooks are user-defined shell commands that execute at various points in Claude Code's lifecycle. They provide **deterministic, guaranteed control** over Claude Code's behavior—ensuring certain actions always happen rather than relying on the LLM to choose to run them.

### Key Characteristics

- **Deterministic**: Execute every time their trigger fires (unlike prompts which may vary)
- **Non-blocking** (optional): Can run in background without waiting for completion
- **Flexible Input/Output**: Receive JSON via stdin, output JSON or exit codes
- **Security-Aware**: Full environment context available, requires intentional configuration
- **Event-Based**: Triggered at specific lifecycle points, not arbitrary conditions

### When NOT to Use Hooks

Hooks are for automation **at Claude Code's lifecycle level**. They cannot:
- Automate business workflows (CRM, helpdesk, Slack automation)
- Make runtime decisions beyond yes/no approvals
- Access services outside your local environment
- Run on a schedule (only on Claude Code events)

---

## CONFIGURATION LOCATIONS

### Settings File Hierarchy

```
Scope Priority (highest to lowest):
1. .claude/settings.local.json      (Local project, NOT version controlled)
2. .claude/settings.json            (Project-level, version controlled)
3. ~/.claude/settings.json          (User-level, all projects)
```

Local overrides project, which overrides user.

### File Locations for macOS (2019 Mac Pro)

| File | Full Path | Scope | Use Case |
|------|-----------|-------|----------|
| User-level | `~/.claude/settings.json` | All projects | Personal hooks (formatting, notifications) |
| Project | `.claude/settings.json` | Single project | Team standards (linting, security checks) |
| Local | `.claude/settings.local.json` | Single session | Temporary overrides, API keys |

### Create Directory Structure

```bash
# User-level (first time)
mkdir -p ~/.claude
touch ~/.claude/settings.json

# Project-level
mkdir -p .claude
touch .claude/settings.json
```

### Gitignore Rules

```bash
# .gitignore
.claude/settings.local.json    # Never commit local settings
.claude/hooks/node_modules/    # Hook dependencies
.claude/*.local.*              # Any local files
```

**DO commit**: `.claude/settings.json` (team standards)  
**DO NOT commit**: `~/.claude/` (personal settings)

---

## LIFECYCLE EVENTS REFERENCE

### Complete Event Timeline

```
Claude Code Session
│
├─ SessionStart
│   └─ Fires: When new session starts
│   └─ Receives: Session ID, initial context
│   └─ Use: Initialize logging, setup MCP, warm up resources
│
├─ UserPromptSubmit
│   └─ Fires: User submits prompt (before Claude processes)
│   └─ Receives: Prompt text, session_id, timestamp
│   └─ Use: Validate prompt, add context, security filtering
│
├─ PreToolUse ─────────── ** MOST USED **
│   └─ Fires: Before Claude executes ANY tool
│   └─ Receives: tool_name, tool_input (full parameters)
│   └─ Use: Block dangerous commands, validate inputs, modify parameters
│
├─ [Tool Executes]
│   └─ File editing, bash commands, etc.
│
├─ PostToolUse ────────── ** SECOND MOST USED **
│   └─ Fires: After successful tool execution
│   └─ Receives: tool_name, tool_input, tool_response
│   └─ Use: Run formatters, linters, tests, logging
│
├─ Notification
│   └─ Fires: When Claude needs user input (permission, timeout)
│   └─ Receives: Notification message
│   └─ Use: Desktop notifications, audio alerts, custom messaging
│
├─ PreCompact
│   └─ Fires: Before Claude compacts context
│   └─ Receives: Context being discarded
│   └─ Use: Archive important context, create summary
│
├─ Stop ──────────────── ** USEFUL FOR CLEANUP **
│   └─ Fires: When Claude finishes (main agent stops)
│   └─ Receives: Session summary
│   └─ Use: Commit changes, cleanup, final logging
│
├─ SubagentStop
│   └─ Fires: When subagent completes
│   └─ Receives: Subagent results
│   └─ Use: Aggregate results, validate completion
│
└─ SessionEnd
    └─ Fires: Session completely ends
    └─ Receives: Final session metadata
    └─ Use: Cleanup resources, final archival
```

---

## JSON PAYLOAD SPECIFICATIONS

### 1. SessionStart

**When it fires**: Session begins  
**Format**: JSON via stdin

```json
{
  "session_id": "claude-session-abc123",
  "timestamp": "2025-10-17T14:30:00Z",
  "project_dir": "/Users/username/my-project",
  "working_dir": "/Users/username/my-project/src"
}
```

**Example hook**:
```bash
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Session started at $(date)' >> .claude/session.log"
          }
        ]
      }
    ]
  }
}
```

---

### 2. UserPromptSubmit

**When it fires**: User submits prompt (before Claude processes)  
**Allows**: Prompt validation, context injection, security filtering  
**Format**: JSON via stdin

```json
{
  "prompt": "Build a login form component",
  "session_id": "claude-session-abc123",
  "timestamp": "2025-10-17T14:30:05Z",
  "conversation_index": 1,
  "append": false
}
```

**Exit Code Behavior**:
- Exit 0: Prompt accepted, stdout injected as context
- Exit 2: Prompt rejected, stderr shown to Claude

**Example - Validate dangerous prompts**:
```bash
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -c 'import sys, json; data=json.load(sys.stdin); prompt=data.get(\"prompt\",\"\"); sys.exit(2 if \"rm -rf\" in prompt else 0)'"
          }
        ]
      }
    ]
  }
}
```

---

### 3. PreToolUse

**When it fires**: Before Claude executes ANY tool call  
**Allows**: Block execution, modify inputs, validate  
**Frequency**: Fires for EVERY tool (Edit, Write, Bash, Notebook, etc.)  
**Format**: JSON via stdin

```json
{
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/file.ts",
    "original_str": "old code",
    "new_str": "new code"
  },
  "session_id": "claude-session-abc123",
  "timestamp": "2025-10-17T14:30:10Z"
}
```

**Tool Names** (use in matcher field):
```
File Operations:
  - Edit         (modify file - has original_str, new_str)
  - MultiEdit    (multiple edits in one file)
  - Write        (create new file - has file_path, content)

Execution:
  - Bash         (run shell command - has command)
  - Notebook     (execute Python - has code)

Code Tools:
  - Task         (subagent task - has description)
  - MCP_*        (MCP tool calls)

All tools can be matched with regex: "Edit|Write|Bash"
```

**Exit Code Behavior**:
- Exit 0: Tool allowed to execute
- Exit 1: No output (default continue=true)
- Exit 2: Tool blocked, stderr shown to Claude

**Example - Block .env file edits**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -c \"import json, sys; data=json.load(sys.stdin); path=data.get('tool_input',{}).get('file_path',''); sys.exit(2 if any(p in path for p in ['.env', '.secrets', 'credentials.json']) else 0)\""
          }
        ]
      }
    ]
  }
}
```

**⚠️ CRITICAL**: Avoid expensive operations in PreToolUse for Bash commands. If matcher is "Bash", it fires for EVERY bash command including `ls`, `pwd`, `echo`. Use smart routing:

```bash
# ❌ WRONG - Runs expensive validation for every bash call
{
  "matcher": "Bash",
  "hooks": [{"type": "command", "command": "./expensive-security-check.sh"}]
}

# ✅ RIGHT - Only runs for specific commands
{
  "matcher": "Bash",
  "hooks": [{"type": "command", "command": "python3 route_hook.py"}]
}
```

Router script:
```python
#!/usr/bin/env python3
import json, sys, subprocess

data = json.load(sys.stdin)
command = data.get('tool_input', {}).get('command', '')

if 'npm run deploy' in command:
    subprocess.run(['./security-check.sh'], stdin=sys.stdin)
```

---

### 4. PostToolUse

**When it fires**: After tool executes successfully  
**Allows**: Format code, run tests, logging  
**Format**: JSON via stdin

```json
{
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/component.tsx",
    "original_str": "function App() { return <div> }</div>",
    "new_str": "function App() {\n  return <div>Hello</div>\n}"
  },
  "tool_response": {
    "exit_code": 0,
    "stdout": "File edited successfully",
    "stderr": ""
  },
  "session_id": "claude-session-abc123"
}
```

**Example - Auto-format TypeScript**:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -c \"import json, sys, subprocess; data=json.load(sys.stdin); file=data['tool_input']['file_path']; file.endswith('.ts') and subprocess.run(['npx', 'prettier', '--write', file])\""
          }
        ]
      }
    ]
  }
}
```

---

### 5. Notification

**When it fires**: Claude sends notification (awaiting input, permission needed, timeout)  
**Use**: Desktop alerts, audio, Slack messages  
**Format**: JSON via stdin

```json
{
  "notification": "Claude Code needs your permission to run: npm run deploy",
  "type": "permission_request",
  "session_id": "claude-session-abc123"
}
```

Possible notification types:
- `permission_request`: User needs to approve tool execution
- `idle_timeout`: Claude has been waiting 60+ seconds
- `status_update`: General status notification

**Example - macOS notification**:
```bash
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -c \"import json, sys, subprocess; data=json.load(sys.stdin); subprocess.run(['osascript', '-e', f'display notification \\\"{data[\\\"notification\\\"]}\\\"'])\""
          }
        ]
      }
    ]
  }
}
```

---

### 6. Stop (and SubagentStop)

**When it fires**: Main agent finishes responding (or subagent completes)  
**Use**: Commit changes, cleanup, final validation  
**Format**: JSON via stdin

```json
{
  "session_id": "claude-session-abc123",
  "prompts_count": 5,
  "tools_executed": 12,
  "duration_seconds": 145,
  "stopped_by": "user"  // or "success", "error"
}
```

**Example - Git commit on completion**:
```bash
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "git add -A && git commit -m 'Claude Code session: $(date)' || true"
          }
        ]
      }
    ]
  }
}
```

---

### 7. Notification (Detailed)

```json
{
  "notification_id": "notif-12345",
  "notification": "Claude Code needs your permission to run: npm install",
  "notification_type": "permission_request",
  "context": {
    "tool_name": "Bash",
    "command": "npm install"
  },
  "timestamp": "2025-10-17T14:31:00Z"
}
```

---

## HOOK RESPONSE FORMAT

### Simple: Exit Codes

```bash
Exit 0        → Success, continue execution
Exit 1        → Generic error, continue anyway
Exit 2        → Block action, show stderr to Claude
              (For PreToolUse: blocks tool; PostToolUse: logs error)
```

**Example**:
```bash
#!/bin/bash
if [ -z "$1" ]; then
  echo "Error: Missing required argument" >&2
  exit 2  # Block and show error
fi
exit 0  # Allow
```

---

### Advanced: JSON Output

Return structured JSON from stdout for sophisticated control:

```json
{
  "continue": true,
  "stopReason": "Custom message shown when continue=false",
  "suppressOutput": false,
  "systemMessage": "Warning message shown to user",
  "decision": "approve|block|undefined",
  "reason": "Explanation for decision"
}
```

**All JSON Fields**:

| Field | Type | Optional | Behavior |
|-------|------|----------|----------|
| `continue` | Boolean | Yes (default: true) | If false, stops Claude processing |
| `stopReason` | String | Yes | Message shown to user when continue=false |
| `suppressOutput` | Boolean | Yes (default: false) | Hide stdout from transcript |
| `systemMessage` | String | Yes | Warning displayed to user |
| `decision` | String | Yes | "approve", "block", or undefined |
| `reason` | String | If blocking | Explain decision to Claude |

**Example - Block with detailed reasoning**:
```python
#!/usr/bin/env python3
import json, sys

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')

if '.env' in file_path:
    print(json.dumps({
        "continue": False,
        "stopReason": "Cannot edit .env files - use .env.example instead",
        "decision": "block",
        "reason": "Security policy: environment variables cannot be modified via Claude Code"
    }))
else:
    print(json.dumps({"continue": True}))
```

---

## ENVIRONMENT VARIABLES

### Available During Hook Execution

When a hook runs, these environment variables are available:

```bash
$CLAUDE_PROJECT_DIR          # Absolute path to project root
                             # Example: /Users/username/my-project

$CLAUDE_TOOL_NAME            # Name of tool triggering hook
                             # Example: "Edit", "Bash", "Write"

$CLAUDE_TOOL_INPUT           # Full tool input as JSON string
                             # Example: '{"file_path":"...","content":"..."}'

$CLAUDE_FILE_PATHS           # Space-separated file paths involved
                             # Example: "src/App.tsx src/utils.ts"

$CLAUDE_NOTIFICATION         # (Notification hook only)
                             # Content of notification message

$CLAUDE_TOOL_OUTPUT          # (PostToolUse only)
                             # Output from tool execution

$CLAUDE_EVENT_TYPE           # Type of hook event
                             # Example: "PreToolUse", "PostToolUse"
```

### Example - Use Environment Variables

```bash
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"Tool $CLAUDE_TOOL_NAME executed in $CLAUDE_PROJECT_DIR at $(date)\" >> .claude/audit.log"
          }
        ]
      }
    ]
  }
}
```

---

## BEST PRACTICES & PATTERNS

### 1. PreToolUse: Smart Command Routing

**Problem**: PreToolUse fires for EVERY bash command, including `ls`, `pwd`, `echo`.

**Solution**: Intelligent router that only runs expensive checks for specific commands.

```bash
# .claude/hooks/route.py
#!/usr/bin/env python3
import json, sys, subprocess, os

data = json.load(sys.stdin)
command = data.get('tool_input', {}).get('command', '')
project_dir = os.environ.get('CLAUDE_PROJECT_DIR', '')

# Only run expensive checks for deployment/database commands
expensive_ops = ['npm run deploy', 'npm run migrate', 'npm run seed', 'rm -rf']

should_check = any(op in command for op in expensive_ops)

if should_check:
    # Run security check
    result = subprocess.run([
        'python3', f'{project_dir}/.claude/hooks/security-check.py'
    ], input=sys.stdin.read(), text=True)
    sys.exit(result.returncode)

sys.exit(0)  # Allow by default
```

**Hook config**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/route.py"
          }
        ]
      }
    ]
  }
}
```

---

### 2. PostToolUse: Format + Test Pipeline

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/format_and_test.py"
          }
        ]
      }
    ]
  }
}
```

```python
#!/usr/bin/env python3
import json, sys, subprocess, os

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')
project_dir = os.environ.get('CLAUDE_PROJECT_DIR', '')

results = {
    "format": "✓",
    "test": "✓"
}

# Format
if file_path.endswith('.ts') or file_path.endswith('.tsx'):
    format_result = subprocess.run(
        ['npx', 'prettier', '--write', file_path],
        cwd=project_dir
    )
    results["format"] = "✓" if format_result.returncode == 0 else "✗"

# Run related tests
test_file = file_path.replace('src/', 'src/__tests__/').replace('.ts', '.test.ts')
if os.path.exists(os.path.join(project_dir, test_file)):
    test_result = subprocess.run(
        ['npm', 'test', '--', test_file],
        cwd=project_dir
    )
    results["test"] = "✓" if test_result.returncode == 0 else "✗"

print(json.dumps(results))
```

---

### 3. Notification: Desktop Alerts (macOS)

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/notify.py"
          }
        ]
      }
    ]
  }
}
```

```python
#!/usr/bin/env python3
import json, sys, subprocess, os

data = json.load(sys.stdin)
notification = data.get('notification', '')
notification_type = data.get('notification_type', '')

# Use osascript for native macOS notification
script = f'''
tell application "System Events"
  display notification "{notification}" with title "Claude Code"
end tell
'''

subprocess.run(['osascript', '-e', script])
```

---

### 4. Stop: Auto-commit Session

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/session-commit.py"
          }
        ]
      }
    ]
  }
}
```

```python
#!/usr/bin/env python3
import json, sys, subprocess, os
from datetime import datetime

data = json.load(sys.stdin)
session_id = data.get('session_id', 'unknown')

# Create meaningful commit message
now = datetime.now().strftime('%Y-%m-%d %H:%M')
commit_msg = f'Claude Code session {session_id[:8]} - {now}'

# Commit
result = subprocess.run([
    'git', 'add', '-A'
], capture_output=True)

result = subprocess.run([
    'git', 'commit', '-m', commit_msg, '--allow-empty'
], capture_output=True)

print("Session committed" if result.returncode == 0 else "Commit failed")
```

---

## SECURITY CONSIDERATIONS

### ⚠️ CRITICAL WARNINGS

**Hooks run with your environment's credentials.** Malicious or poorly-written hooks can:
- Exfiltrate secrets from `.env` files
- Send data to external services
- Modify/delete files
- Access your git credentials

### Best Practices

1. **Review all hook code before adding**
   - Understand what each script does
   - Check for external API calls
   - Verify file permissions

2. **Use least-privilege principles**
   - Only match specific tools: `matcher: "Edit|Write"` not `matcher: "Bash"`
   - Only block when necessary
   - Log actions for audit trails

3. **Protect secrets**
   - Never log `.env` file contents
   - Don't pass secrets to external services
   - Use local commands only

4. **Version control hooks**
   - Commit `.claude/hooks/` scripts to git
   - Team review before merging
   - Track changes to hook definitions

### Example - Secure Hook Template

```python
#!/usr/bin/env python3
"""
Secure hook template with logging and error handling.
Never logs sensitive data.
"""
import json, sys, logging, os
from pathlib import Path

# Setup logging (to file only, not stdout/stderr to Claude)
log_file = Path(os.environ.get('CLAUDE_PROJECT_DIR', '.')) / '.claude' / 'hooks.log'
logging.basicConfig(filename=log_file, level=logging.INFO)

try:
    data = json.load(sys.stdin)
    
    # Example: Block sensitive file paths
    sensitive_patterns = ['.env', '.secrets', 'credentials', 'private_key']
    file_path = data.get('tool_input', {}).get('file_path', '')
    
    if any(pattern in file_path for pattern in sensitive_patterns):
        logging.warning(f"Blocked access to: {file_path}")
        print(json.dumps({
            "continue": False,
            "reason": "File matches security policy"
        }))
        sys.exit(0)
    
    logging.info(f"Allowed tool: {data.get('tool_name')}")
    print(json.dumps({"continue": True}))

except Exception as e:
    logging.error(f"Hook error: {str(e)}")
    print(json.dumps({"continue": True}))  # Fail open
    sys.exit(0)
```

---

## REAL-WORLD EXAMPLES

### Example 1: Prevent Sensitive File Edits

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -c \"import json, sys; data=json.load(sys.stdin); path=data.get('tool_input',{}).get('file_path',''); blocked=['.env', '.secrets', 'keys', 'credentials']; sys.exit(2 if any(b in path for b in blocked) else 0)\""
          }
        ]
      }
    ]
  }
}
```

---

### Example 2: Auto-Format on Save

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'file=$CLAUDE_FILE_PATHS; [[ $file == *.ts ]] && npx prettier --write \"$file\"; [[ $file == *.py ]] && python3 -m black \"$file\"'"
          }
        ]
      }
    ]
  }
}
```

---

### Example 3: Run Tests on Changes

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'file=$CLAUDE_FILE_PATHS; if [[ $file == *test* ]]; then npm test -- \"$file\"; fi'"
          }
        ]
      }
    ]
  }
}
```

---

### Example 4: GitButler Integration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "but claude pre-tool"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "but claude post-tool"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "but claude stop"
          }
        ]
      }
    ]
  }
}
```

---

### Example 5: Comprehensive Logging

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -c \"import json, sys, datetime; data=json.load(sys.stdin); log_entry={'timestamp': datetime.datetime.now().isoformat(), 'prompt': data.get('prompt')}; print(json.dumps(log_entry))\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "python3 -c \"import json, sys; data=json.load(sys.stdin); print(f\\\"Executing: {data.get('tool_input',{}).get('command','')}\\\") >> .claude/tool-log.txt\""
          }
        ]
      }
    ]
  }
}
```

---

## TROUBLESHOOTING & EDGE CASES

### Q: Hook isn't firing. How do I debug?

**A**: Use `claude --debug` to see hook execution logs.

```bash
claude --debug
# Look for: [HOOK] PreToolUse fired...
# Or: [HOOK] Not matched (reason)
```

Also check:
1. **Syntax**: Run `/hooks` command to verify hook is loaded
2. **Matcher**: Verify matcher regex is correct
3. **File path**: Check `.claude/settings.json` exists and is valid JSON
4. **Permissions**: Script must be executable `chmod +x script.py`

---

### Q: PreToolUse runs for every bash command and is slowing things down

**A**: Use smart routing to only check specific commands.

```bash
# ❌ WRONG
{ "matcher": "Bash", "hooks": [{"command": "./expensive-check.sh"}] }

# ✅ RIGHT
{ "matcher": "Bash", "hooks": [{"command": "python3 smart-router.py"}] }
```

Router reads command and decides:
```python
if 'deploy' in command or 'rm -rf' in command:
    run_check()
else:
    exit(0)
```

---

### Q: My hook modifies tool input but Claude doesn't use it

**A**: PreToolUse must output modified JSON to stdout.

```python
# ❌ WRONG - Just prints
print("Modified:", modified_input)

# ✅ RIGHT - JSON to stdout
import json
print(json.dumps(modified_input))
```

**Important**: Preserve all required fields when modifying.

```python
# ❌ WRONG - Lost required field
modified = {"file_path": "/path"}

# ✅ RIGHT - Keep all fields
modified = {
    "file_path": "/path",
    "original_str": data["original_str"],
    "new_str": data["new_str"]
}
```

---

### Q: Hook runs but output isn't shown in transcript

**A**: PostToolUse by default hides stdout unless you return JSON.

```json
{
  "continue": true,
  "suppressOutput": false
}
```

Or use stderr for warnings that Claude will see:

```python
import sys
print("Warning message", file=sys.stderr)
```

---

### Q: How do I pass data between hooks?

**A**: Hooks are isolated. Options:

1. **Write to file in project** (read in next hook)
```python
# Hook 1
with open('.claude/hook-state.json', 'w') as f:
    json.dump(data, f)

# Hook 2
with open('.claude/hook-state.json', 'r') as f:
    data = json.load(f)
```

2. **Use environment variables** (limited to current session)
```bash
export HOOK_DATA="value"
# Available in next hook via $HOOK_DATA
```

3. **Use system logs**
```bash
# Write to syslog
logger "hook-data: $HOOK_DATA"
```

---

### Q: Can I have multiple hooks for the same event?

**A**: Yes, they execute in order.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {"type": "command", "command": "prettier --write $FILE"},
          {"type": "command", "command": "npm test"},
          {"type": "command", "command": "git add $FILE"}
        ]
      }
    ]
  }
}
```

Executes: prettier → npm test → git add

---

### Q: Edge case - Hook fails, what happens?

**A**: Depends on exit code and hook type:

| Exit | PreToolUse | PostToolUse | Stop |
|------|-----------|-----------|------|
| 0 | Allow tool | Log result | Continue |
| 1 | Allow tool | Log error | Continue |
| 2 | **Block tool**, show error | Log error | Continue |
| Other | Allow tool | Log error | Continue |

**Default behavior**: Fail open (continue=true). Tool executes unless hook returns exit code 2.

---

### Q: Can hooks interact with MCP servers?

**A**: Hooks can call MCP tools through bash/python, but indirectly.

```bash
# Hook can call tool that uses MCP
python3 -c "
import json
# Make API call that MCP server facilitates
result = call_external_service()
print(json.dumps(result))
"
```

---

## QUICK CONFIGURATION CHECKLIST

- [ ] Hook file in `.claude/settings.json` (project) or `~/.claude/settings.json` (user)
- [ ] Valid JSON syntax (use `jq` to validate)
- [ ] Matcher regex is specific (not too broad)
- [ ] Script is executable (`chmod +x script.py`)
- [ ] Script handles stdin properly (`json.load(sys.stdin)`)
- [ ] Exit codes or JSON output match expected format
- [ ] No secrets logged (especially in PostToolUse/logging hooks)
- [ ] Tested with `claude --debug`
- [ ] `.claude/hooks/` scripts are version controlled
- [ ] .gitignore excludes `.claude/settings.local.json`

---

## RELATED RESOURCES

- Official Hooks Documentation: https://docs.claude.com/en/docs/claude-code/hooks
- Hooks Mastery Repository: https://github.com/disler/claude-code-hooks-mastery
- Claude Code Best Practices: https://www.anthropic.com/engineering/claude-code-best-practices
- Awesome Claude Code: https://github.com/hesreallyhim/awesome-claude-code

# Claude Code Hooks System

**Comprehensive lifecycle automation with UV single-file Python scripts**

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Available Hooks](#available-hooks)
- [How It Works](#how-it-works)
- [Creating New Hooks](#creating-new-hooks)
- [Configuration](#configuration)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)

---

## Overview

This hooks system provides deterministic control over Claude Code's behavior through lifecycle event handlers. Each hook is a self-contained UV Python script that executes at specific points in Claude's workflow.

### Key Features

- ✅ **Security blocking** - Prevent dangerous commands (`rm -rf`, `.env` access)
- ✅ **Comprehensive logging** - JSON logs for all events in `~/.claude/logs/`
- ✅ **Context loading** - Automatic git status and session data at startup
- ✅ **Transcript backup** - Pre-compaction backups with timestamps
- ✅ **UV single-file scripts** - Self-contained dependencies, no venv needed
- ✅ **JSON flow control** - Exit codes control blocking behavior
- ✅ **Optional TTS/LLM** - Text-to-speech and AI-generated messages (disabled by default)

---

## Architecture

```
~/.claude/
├── hooks/
│   ├── user_prompt_submit.py    # Validates and logs user prompts
│   ├── pre_tool_use.py          # Security blocking before tool execution
│   ├── post_tool_use.py         # Logs tool results after execution
│   ├── notification.py          # Handles notification events
│   ├── stop.py                  # Logs session completion
│   ├── subagent_stop.py         # Logs subagent completion
│   ├── pre_compact.py           # Backs up transcripts before compaction
│   ├── session_start.py         # Loads context at session start
│   └── utils/
│       ├── tts/                 # Text-to-speech providers (optional)
│       │   ├── elevenlabs_tts.py
│       │   ├── openai_tts.py
│       │   └── pyttsx3_tts.py
│       └── llm/                 # LLM providers for messages (optional)
│           ├── oai.py
│           ├── anth.py
│           └── ollama.py
├── logs/                        # JSON log files
│   ├── user_prompt_submit.json
│   ├── pre_tool_use.json
│   ├── post_tool_use.json
│   ├── session_start.json
│   ├── stop.json
│   ├── subagent_stop.json
│   └── pre_compact.json
└── settings.json                # Hook configuration
```

---

## Available Hooks

### 1. UserPromptSubmit

**Triggers:** When user submits a prompt (before Claude processes it)

**Purpose:**
- Logs all user prompts
- Stores last prompt for context
- Optional: LLM-based agent naming (disabled)

**Flags:**
- `--log-only` - Only log, no validation
- `--store-last-prompt` - Save prompt to session data
- `--name-agent` - Use LLM to name agent (disabled)

**Current config:**
```bash
uv run ~/.claude/hooks/user_prompt_submit.py --log-only --store-last-prompt
```

**Can block:** ✅ Yes (exit code 2 blocks prompt entirely)

---

### 2. PreToolUse

**Triggers:** Before Claude executes any tool

**Purpose:**
- **Security blocking** for dangerous commands
- Logs tool calls before execution
- Validates tool inputs

**Security checks:**
- ❌ Blocks `rm -rf` commands
- ❌ Blocks `.env` file access (allows `.env.sample`)
- ❌ Blocks dangerous path deletions

**Current config:**
```bash
uv run ~/.claude/hooks/pre_tool_use.py
```

**Can block:** ✅ Yes (exit code 2 blocks tool execution)

**Example blocking:**
```bash
# This will be BLOCKED:
rm -rf /
rm -rf ~/.config
cat .env
echo "SECRET=key" > .env

# These are ALLOWED:
rm -rf ./temp/
cat .env.sample
mkdir -p ~/.config
```

---

### 3. PostToolUse

**Triggers:** After Claude executes any tool

**Purpose:**
- Logs tool calls with results
- Captures stdout/stderr from Bash commands
- Tracks tool success/failure

**Current config:**
```bash
uv run ~/.claude/hooks/post_tool_use.py
```

**Can block:** ❌ No (tool already ran)

**Log structure:**
```json
{
  "session_id": "...",
  "hook_event_name": "PostToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "ls -lh",
    "description": "List files"
  },
  "tool_response": {
    "stdout": "...",
    "stderr": "",
    "interrupted": false
  }
}
```

---

### 4. Notification

**Triggers:** On Claude notifications

**Purpose:**
- Logs notification events
- Optional: TTS audio alerts (disabled)

**Flags:**
- `--notify` - Enable TTS notifications (disabled)

**Current config:**
```bash
uv run ~/.claude/hooks/notification.py
```

**Can block:** ❌ No (informational only)

---

### 5. Stop

**Triggers:** When conversation ends

**Purpose:**
- Logs session completion
- Optional: AI-generated completion messages (disabled)
- Optional: TTS farewell (disabled)

**Flags:**
- `--chat` - Enable AI-generated messages (disabled)
- `--notify` - Enable TTS audio (disabled)

**Current config:**
```bash
uv run ~/.claude/hooks/stop.py
```

**Can block:** ⚠️ Yes (but not recommended - forces continuation)

---

### 6. SubagentStop

**Triggers:** When subagent (Task tool) completes

**Purpose:**
- Logs subagent completion
- Optional: TTS announcement (disabled)
- Optional: AI summary (disabled)

**Flags:**
- `--chat` - Enable AI-generated messages (disabled)
- `--notify` - Enable TTS audio (disabled)

**Current config:**
```bash
uv run ~/.claude/hooks/subagent_stop.py
```

**Can block:** ⚠️ Yes (blocks subagent stopping)

---

### 7. PreCompact

**Triggers:** Before transcript compaction

**Purpose:**
- Backs up transcripts before compaction
- Preserves conversation history

**Flags:**
- `--backup` - Enable transcript backup
- `--verbose` - Show detailed output

**Current config:**
```bash
uv run ~/.claude/hooks/pre_compact.py --backup
```

**Can block:** ❌ No (informational only)

**Backup location:**
```
~/.claude/logs/transcript_backups/
└── <session_id>_<timestamp>.jsonl
```

---

### 8. SessionStart

**Triggers:** When Claude session starts

**Purpose:**
- Loads git status and context
- Checks for recent issues
- Optional: TTS welcome (disabled)

**Flags:**
- `--load-context` - Load git status, recent files
- `--announce` - TTS announcement (disabled)

**Current config:**
```bash
uv run ~/.claude/hooks/session_start.py --load-context
```

**Can block:** ❌ No (informational only)

**Context loaded:**
- Git branch
- Git status (uncommitted changes)
- Recent GitHub issues
- Session metadata

---

## How It Works

### UV Single-File Script Pattern

Each hook is a **UV single-file script** with embedded dependencies:

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "python-dotenv",
#     "anthropic",
# ]
# ///

import json
import sys
from dotenv import load_dotenv

load_dotenv()  # Loads from ~/.zshrc or .env

def main():
    # Read JSON from stdin
    input_data = json.load(sys.stdin)

    # Process hook logic
    # ...

    # Exit codes control flow:
    # 0 = success, continue
    # 2 = BLOCK action, show stderr to Claude
    # other = non-blocking error
    sys.exit(0)

if __name__ == '__main__':
    main()
```

### Benefits of UV Scripts

- **Self-contained** - Each hook declares its own dependencies
- **Fast** - UV caches dependencies, subsequent runs are instant
- **Isolated** - Dependencies don't pollute project environment
- **Portable** - Scripts work across different machines

### JSON Flow Control

Hooks communicate with Claude through **exit codes**:

| Exit Code | Behavior | Use Case |
|-----------|----------|----------|
| `0` | Success | Hook executed, continue normally |
| `2` | **BLOCKS ACTION** | stderr automatically fed to Claude |
| Other | Non-blocking error | stderr shown to user, continues |

**Example: Blocking dangerous command**

```python
if is_dangerous_rm_command(command):
    print("BLOCKED: Dangerous rm -rf command detected", file=sys.stderr)
    sys.exit(2)  # Exit code 2 blocks the tool execution
```

### Logging Pattern

All hooks follow this logging pattern:

```python
def log_event(session_id, input_data):
    """Log event to logs directory."""
    log_dir = Path("logs")
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / 'hook_name.json'

    # Read existing logs
    if log_file.exists():
        with open(log_file, 'r') as f:
            log_data = json.load(f)
    else:
        log_data = []

    # Append new event
    log_data.append(input_data)

    # Write back with formatting
    with open(log_file, 'w') as f:
        json.dump(log_data, f, indent=2)
```

---

## Creating New Hooks

### Step 1: Choose Hook Type

Decide which lifecycle event to hook into:

- **UserPromptSubmit** - Validate/transform user input
- **PreToolUse** - Validate/block tool execution
- **PostToolUse** - Process tool results
- **Notification** - React to notifications
- **Stop** - Session cleanup/summary
- **SubagentStop** - Subagent completion handling
- **PreCompact** - Backup/archive before compaction
- **SessionStart** - Load context/setup

### Step 2: Create Hook Script

Create `~/.claude/hooks/my_custom_hook.py`:

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "python-dotenv",
# ]
# ///

import json
import sys
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()  # Load environment variables

def main():
    # Read input from stdin
    input_data = json.load(sys.stdin)

    # Extract common fields
    session_id = input_data.get('session_id')
    hook_event_name = input_data.get('hook_event_name')

    # Hook-specific logic
    if hook_event_name == 'PreToolUse':
        tool_name = input_data.get('tool_name')
        tool_input = input_data.get('tool_input', {})

        # Example: Block specific tool
        if tool_name == 'Write' and 'sensitive' in tool_input.get('file_path', ''):
            print("BLOCKED: Cannot write to sensitive files", file=sys.stderr)
            sys.exit(2)  # Block the action

    # Log the event
    log_event(session_id, input_data)

    # Success - allow action to continue
    sys.exit(0)

def log_event(session_id, data):
    """Log event to logs/my_custom_hook.json"""
    log_dir = Path("logs")
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / 'my_custom_hook.json'

    if log_file.exists():
        with open(log_file, 'r') as f:
            try:
                log_data = json.load(f)
            except json.JSONDecodeError:
                log_data = []
    else:
        log_data = []

    log_data.append(data)

    with open(log_file, 'w') as f:
        json.dump(log_data, f, indent=2)

if __name__ == '__main__':
    main()
```

### Step 3: Make Executable

```bash
chmod +x ~/.claude/hooks/my_custom_hook.py
```

### Step 4: Add to settings.json

Edit `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/my_custom_hook.py"
          }
        ]
      }
    ]
  }
}
```

### Step 5: Test Hook

```bash
# Test manually with sample input
echo '{"session_id": "test", "hook_event_name": "PreToolUse", "tool_name": "Write"}' | \
  uv run ~/.claude/hooks/my_custom_hook.py

# Check logs
cat ~/.claude/logs/my_custom_hook.json
```

---

## Configuration

### Current Configuration

**File:** `~/.claude/settings.json`

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/user_prompt_submit.py --log-only --store-last-prompt"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/pre_tool_use.py"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/post_tool_use.py"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/notification.py"
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
            "command": "uv run ~/.claude/hooks/stop.py"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/subagent_stop.py"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/pre_compact.py --backup"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "uv run ~/.claude/hooks/session_start.py --load-context"
          }
        ]
      }
    ]
  }
}
```

### Matchers

Matchers allow conditional hook execution:

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/bash_validator.py"
        }
      ]
    },
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/file_validator.py"
        }
      ]
    }
  ]
}
```

**Matcher patterns:**
- `""` - Match all events (empty string)
- `"Bash"` - Match only Bash tool
- `"Write|Edit"` - Match Write OR Edit tools
- `"Write.*\\.ts$"` - Regex: Write tool on .ts files

---

## Environment Variables

### Current Setup

Environment variables are read from `~/.zshrc` (or your shell config):

```bash
# ~/.zshrc
export OPENAI_API_KEY="sk-..."
export ENGINEER_NAME="Nathan"
```

### Priority Order

1. **Shell environment variables** (from `~/.zshrc`) ← **Current setup**
2. `.env` file (fallback - currently documentation-only)

### Available Variables

| Variable | Purpose | Required | Current Status |
|----------|---------|----------|----------------|
| `OPENAI_API_KEY` | LLM and TTS | Optional | ✅ Set in ~/.zshrc |
| `ANTHROPIC_API_KEY` | LLM fallback | Optional | ❌ Not set |
| `ELEVENLABS_API_KEY` | High-quality TTS | Optional | ❌ Not needed |
| `ENGINEER_NAME` | TTS personalization | Optional | ✅ Set to "Nathan" |

### Enabling TTS/LLM Features

**Currently disabled.** To enable:

1. **Add flags in settings.json:**
```json
{
  "Stop": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/stop.py --chat --notify"
        }
      ]
    }
  ]
}
```

2. **Ensure API keys are set:**
```bash
# Already set:
echo $OPENAI_API_KEY  # Should show your key
echo $ENGINEER_NAME   # Should show "Nathan"
```

### Adding New Variables

```bash
# Add to ~/.zshrc
echo 'export MY_CUSTOM_VAR="value"' >> ~/.zshrc

# Reload shell
source ~/.zshrc

# Access in hook
import os
my_var = os.getenv('MY_CUSTOM_VAR')
```

---

## Troubleshooting

### Hook Not Triggering

**Check:**
```bash
# Verify hook file exists and is executable
ls -lh ~/.claude/hooks/my_hook.py

# Make executable if needed
chmod +x ~/.claude/hooks/my_hook.py

# Check settings.json syntax
cat ~/.claude/settings.json | python3 -m json.tool
```

### Hook Errors

**View logs:**
```bash
# Check if log file was created
ls -lh ~/.claude/logs/

# View specific hook log
cat ~/.claude/logs/pre_tool_use.json | python3 -m json.tool
```

**Test hook manually:**
```bash
# Create test input
echo '{"session_id": "test", "hook_event_name": "PreToolUse", "tool_name": "Bash", "tool_input": {"command": "ls"}}' > /tmp/test_input.json

# Run hook with test input
cat /tmp/test_input.json | uv run ~/.claude/hooks/pre_tool_use.py

# Check exit code
echo $?
# 0 = success, 2 = blocked, other = error
```

### UV Not Found

```bash
# Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
which uv
uv --version
```

### Dependencies Not Installing

```bash
# UV caches dependencies - clear cache if needed
rm -rf ~/.cache/uv

# Force reinstall
uv run --refresh ~/.claude/hooks/my_hook.py
```

### Environment Variables Not Loading

```bash
# Check current environment
env | grep -E "(OPENAI_API_KEY|ENGINEER_NAME)"

# Reload shell config
source ~/.zshrc

# Verify in hook
echo '{"session_id": "test"}' | uv run -c 'import os; print(os.getenv("ENGINEER_NAME"))'
```

### Hook Blocking Unexpectedly

**Check PreToolUse logic:**
```bash
# View blocking rules
cat ~/.claude/hooks/pre_tool_use.py | grep -A 10 "is_dangerous_rm_command"

# Test specific command
echo '{"tool_name": "Bash", "tool_input": {"command": "rm -rf ./test"}}' | \
  uv run ~/.claude/hooks/pre_tool_use.py
```

---

## Advanced Patterns

### Multiple Hooks on Same Event

```json
{
  "PreToolUse": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/security_check.py"
        },
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/audit_log.py"
        }
      ]
    }
  ]
}
```

**Execution order:** Sequential (security_check → audit_log)

### Conditional Execution with Matchers

```json
{
  "PostToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "prettier --write $CLAUDE_FILE_PATHS",
          "timeout": 10000
        }
      ]
    },
    {
      "matcher": "Write.*\\.ts$|Edit.*\\.ts$",
      "hooks": [
        {
          "type": "command",
          "command": "tsc --noEmit",
          "timeout": 30000
        }
      ]
    }
  ]
}
```

### Using Utilities

```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["python-dotenv"]
# ///

import sys
import os
from pathlib import Path

# Import shared utilities
sys.path.insert(0, str(Path(__file__).parent / 'utils'))

from tts.pyttsx3_tts import speak_text
from llm.oai import get_completion

def main():
    # Use TTS
    speak_text("Hook executed successfully")

    # Use LLM
    response = get_completion("Summarize this event")
    print(response)

if __name__ == '__main__':
    main()
```

---

## Quick Reference

### Hook Types & Blocking

| Hook | Can Block? | Best For |
|------|------------|----------|
| UserPromptSubmit | ✅ Yes | Validate user input |
| PreToolUse | ✅ Yes | Security checks, validation |
| PostToolUse | ❌ No | Logging, formatting |
| Notification | ❌ No | Alerts, notifications |
| Stop | ⚠️ Yes* | Session cleanup |
| SubagentStop | ⚠️ Yes* | Subagent summaries |
| PreCompact | ❌ No | Backup, archiving |
| SessionStart | ❌ No | Context loading |

*Not recommended to block

### Common Exit Codes

```python
sys.exit(0)  # Success - allow action
sys.exit(2)  # Block action (stderr to Claude)
sys.exit(1)  # Non-blocking error (stderr to user)
```

### Log File Locations

```
~/.claude/logs/user_prompt_submit.json
~/.claude/logs/pre_tool_use.json
~/.claude/logs/post_tool_use.json
~/.claude/logs/notification.json
~/.claude/logs/stop.json
~/.claude/logs/subagent_stop.json
~/.claude/logs/pre_compact.json
~/.claude/logs/session_start.json
```

---

## Credits

Hook system based on [claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) by disler.

Integrated and configured for Nathan's Claude Code setup on 2025-10-29.

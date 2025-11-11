# Disabled Logging Hooks

The following hooks were disabled to stop logging. They can be restored by uncommitting them from git history or by copying them from below:

## Disabled Hooks Configuration

### UserPromptSubmit
```json
"UserPromptSubmit": [
  {
    "hooks": [
      {
        "type": "command",
        "command": "uv run ~/.claude/hooks/user_prompt_submit.py --log-only --store-last-prompt"
      }
    ]
  }
]
```
Logged to: `logs/user_prompt_submit.json`, `.claude/data/sessions/{session_id}.json`

---

### PreToolUse
```json
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
]
```
Logged to: `logs/pre_tool_use.json`

---

### PostToolUse (Logging Hook Only)
```json
{
  "matcher": "",
  "hooks": [
    {
      "type": "command",
      "command": "uv run ~/.claude/hooks/post_tool_use.py"
    }
  ]
}
```
Logged to: `logs/post_tool_use.json`, `logs/bash_history.json`, `logs/subagent_invocations.json`

---

### Notification
```json
"Notification": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "uv run ~/.claude/hooks/notification.py --notify"
      }
    ]
  }
]
```
Logged to: `logs/notification.json`

---

### Stop
```json
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
```
Logged to: `logs/stop.json`, `logs/chat.json`

---

### SubagentStop
```json
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
]
```
Logged to: `logs/subagent_stop.json`

---

### PreCompact
```json
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
]
```
Logged to: `logs/pre_compact.json`, `logs/transcript_backups/`

---

### SessionStart
```json
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
```
Logged to: `logs/session_start.json`

---

### statusLine
```json
"statusLine": {
  "type": "command",
  "command": "uv run ~/.claude/status_lines/status_line.py",
  "padding": 0
}
```
Logged to: `logs/status_line.json`

---

## Active Hooks (NOT Disabled)

The following validation hooks remain active:

### PostToolUse - TypeScript Validation
```json
{
  "matcher": "Write.*\\.ts$|Edit.*\\.ts$",
  "hooks": [
    {
      "type": "command",
      "command": "pnpm run typecheck 2>&1 | head -n 50",
      "timeout": 30000
    }
  ]
}
```

### PostToolUse - Zod Schema Validation
```json
{
  "matcher": "Write.*schemas.*\\.ts$|Edit.*schemas.*\\.ts$",
  "hooks": [
    {
      "type": "command",
      "command": "uv run ~/.claude/hooks/validate_zod_schema.py"
    }
  ]
}
```

---

## To Re-enable Logging Hooks

1. Copy the desired hook configuration from above
2. Add it to the `"hooks"` object in `~/.claude/settings.json`
3. Save the file

Or use git to restore: `git checkout HEAD~1 ~/.claude/settings.json`

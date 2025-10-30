# Claude Code Status Line

Custom status line script that displays contextual session information in the Claude Code terminal.

## Features

### Display Components

1. **Agent Name** (Bright Red) - The current agent/subagent name
2. **Model Name** (Blue) - Claude model being used (e.g., "Sonnet 4.5")
3. **Git Branch** (Color-coded) - Current git branch with icon
4. **Output Style** (Magenta) - Active output style/personality mode
5. **Recent Prompt** (White) - Most recent user prompt with icon
6. **Extras** (Cyan) - Session metadata key-value pairs
7. **Token Usage** (Color-coded) - Cumulative token consumption with budget

### Git Branch Display

The git branch is displayed with color coding and icons based on branch type:

- 🌳 **main/master** (Green) - Main production branches
- ✨ **feature/** (Blue) - Feature development branches
- 🐛 **fix/bugfix/** (Yellow) - Bug fix branches
- 🚨 **hotfix/** (Red) - Critical hotfix branches
- 🚀 **release/** (Magenta) - Release preparation branches
- 🔀 **other** (Cyan) - All other branch types
- ⚠️ **detached** (Gray) - Detached HEAD state with commit hash

Branch names longer than 25 characters are truncated with "...".

### Token Usage Display

Token usage is color-coded based on consumption:

- 🟢 Green: 0-75% (0-150k tokens)
- 🟡 Yellow: 75-87.5% (150k-175k tokens)
- 🟠 Orange: 87.5-95% (175k-190k tokens)
- 🔴 Red: 95-100% (190k-200k tokens)

Format: `[142k/200k (71%)]`

## Token Calculation Methodology

### Understanding Claude's Token Budget

Claude Code's 200k token budget refers to the **INPUT context window** - the amount of conversation history and context that can be maintained in a single session. This is separate from output tokens and billing.

### Weighted Token Calculation

The status line uses **weighted token calculation** to accurately reflect context usage:

1. **Regular Input Tokens** (`input_tokens`): Full weight (1x)
   - New tokens sent to the API
   - Count fully toward the 200k context budget

2. **Cache Creation Tokens** (`cache_creation_input_tokens`): Full weight (1x)
   - Tokens cached for the first time
   - Count fully toward context budget

3. **Cache Read Tokens** (`cache_read_input_tokens`): Reduced weight (0.1x)
   - Tokens read from prompt cache (90% discount)
   - Only count 10% toward effective context usage
   - Example: 50,000 cached tokens = 5,000 effective tokens

4. **Output Tokens** (`output_tokens`): Not counted (0x)
   - Responses from Claude
   - Don't count toward INPUT context budget

### Formula

```python
effective_input_tokens = (
    input_tokens +
    cache_creation_input_tokens +
    (cache_read_input_tokens * 0.1)
)
```

### Deduplication

Transcript files may contain duplicate message entries (same message ID appearing multiple times). The calculation automatically deduplicates by tracking unique message IDs to ensure each message is only counted once.

### Why This Matters

Without weighted calculation, the status line would show:
- `[6465k/200k (3232%)]` ❌ Incorrect - counts cache reads fully

With weighted calculation, it correctly shows:
- `[142k/200k (71%)]` ✅ Correct - accounts for cache discount

### Color Coding

The token display uses color coding to indicate usage levels:
- 🟢 **Green** (<75%): Plenty of context remaining
- 🟡 **Yellow** (75-87.5%): Moderate usage
- 🟠 **Orange** (87.5-95%): High usage, consider wrapping up
- 🔴 **Red** (95%+): Critical - near context limit

### References

- [Claude API Token Limits](https://docs.claude.com/en/release-notes/overview)
- [Prompt Caching Documentation](https://docs.claude.com/)
- Standard context window: 200k tokens (Sonnet 4/4.5)
- Extended context window: 1M tokens (beta, API only)

## Configuration

The status line is configured in `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "uv run ~/.claude/status_lines/status_line.py",
    "padding": 0
  }
}
```

## Input Data

The script receives JSON input via stdin from Claude Code:

```json
{
  "session_id": "abc-123",
  "model": {
    "display_name": "Sonnet 4.5"
  },
  "output_style": {
    "name": "builder-mode"
  },
  "transcript_path": "/path/to/transcript.jsonl"
}
```

## Session Data

Session data is stored in `.claude/data/sessions/{session_id}.json`:

```json
{
  "agent_name": "Agent",
  "prompts": ["Create a feature", "Fix the bug"],
  "extras": {
    "project": "my-app",
    "feature": "auth"
  }
}
```

## Logging

All status line events are logged to `logs/status_line.json` with:
- Timestamp
- Input data
- Generated status line output
- Any error messages

## Requirements

- Python 3.11+
- `uv` package manager
- `python-dotenv` (optional)
- Git (for branch display)

## Development

To test the status line locally:

```bash
echo '{
  "session_id": "test",
  "model": {"display_name": "Claude"},
  "output_style": {"name": "test-mode"}
}' | uv run ~/.claude/status_lines/status_line.py
```

## Error Handling

The script handles errors gracefully:
- Missing session files
- JSON decode errors
- Git command failures
- Subprocess timeouts
- Missing git installation
- Non-git directories

In all error cases, a minimal status line is displayed instead of crashing.

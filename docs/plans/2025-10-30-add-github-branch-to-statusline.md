# Add GitHub Branch to Status Line Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Display the current GitHub branch name in the Claude Code status line alongside agent name, model, output style, and token usage.

**Architecture:** Extend the existing `status_line.py` script to detect and display the current git branch. Add git branch detection function, format the branch name with appropriate styling, and integrate it into the status line display between model name and output style.

**Tech Stack:** Python 3.11+, subprocess (git command execution), ANSI color codes for terminal styling

---

## Task 1: Add Git Branch Detection Function

**Files:**
- Modify: `~/.claude/status_lines/status_line.py:1-285`

**Step 1: Write failing test for git branch detection**

First, let's add a test to verify our git branch detection works. Create a simple test at the end of the file (before `if __name__ == "__main__"`):

```python
def test_get_git_branch():
    """Test git branch detection."""
    branch = get_git_branch()
    # Should return a string (branch name or None)
    assert isinstance(branch, (str, type(None)))
    print(f"✓ Git branch detection test passed: {branch}")
```

**Step 2: Run test to verify it fails**

Run: `python3 ~/.claude/status_lines/status_line.py`

Expected: `NameError: name 'get_git_branch' is not defined`

**Step 3: Implement git branch detection function**

Add this function after the `format_extras()` function (around line 118):

```python
def get_git_branch():
    """Get the current git branch name."""
    import subprocess

    try:
        # Try to get the current branch using git
        result = subprocess.run(
            ["git", "branch", "--show-current"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=os.getcwd()
        )

        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

        # Fallback: try git symbolic-ref for older git versions
        result = subprocess.run(
            ["git", "symbolic-ref", "--short", "HEAD"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=os.getcwd()
        )

        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

        return None

    except (subprocess.TimeoutExpired, FileNotFoundError, Exception):
        # Git not installed, not a git repo, or command timed out
        return None
```

**Step 4: Run test to verify function works**

Run: `python3 ~/.claude/status_lines/status_line.py`

Expected: `✓ Git branch detection test passed: main` (or current branch name)

**Step 5: Remove test function**

Since this is a status line script (not a test suite), remove the `test_get_git_branch()` function we added.

**Step 6: Commit**

```bash
git add ~/.claude/status_lines/status_line.py
git commit -m "feat: add git branch detection function to status line"
```

---

## Task 2: Format Git Branch Display

**Files:**
- Modify: `~/.claude/status_lines/status_line.py:118-180`

**Step 1: Write branch formatting function**

Add this function right after `get_git_branch()`:

```python
def format_git_branch(branch):
    """Format git branch name with color coding and icon."""
    if not branch:
        return None

    # Truncate very long branch names
    if len(branch) > 25:
        branch = branch[:22] + "..."

    # Color code by branch type
    if branch == "main" or branch == "master":
        # Green for main branches
        color = "\033[92m"
        icon = "🌳"
    elif branch.startswith("feature/") or branch.startswith("feat/"):
        # Blue for feature branches
        color = "\033[94m"
        icon = "✨"
    elif branch.startswith("fix/") or branch.startswith("bugfix/"):
        # Yellow for bugfix branches
        color = "\033[93m"
        icon = "🐛"
    elif branch.startswith("hotfix/"):
        # Red for hotfix branches
        color = "\033[91m"
        icon = "🚨"
    elif branch.startswith("release/"):
        # Magenta for release branches
        color = "\033[95m"
        icon = "🚀"
    else:
        # Cyan for other branches
        color = "\033[96m"
        icon = "🔀"

    return f"{color}{icon} {branch}\033[0m"
```

**Step 2: Test branch formatting manually**

Create a small test script to verify formatting:

```bash
python3 -c "
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from status_line import get_git_branch, format_git_branch

branch = get_git_branch()
print(f'Branch: {branch}')
formatted = format_git_branch(branch)
print(f'Formatted: {formatted}')
"
```

Expected: Should show current branch with appropriate color and icon

**Step 3: Verify output looks correct**

Run the test command and visually verify:
- Main/master branches show green with 🌳
- Feature branches show blue with ✨
- Bugfix branches show yellow with 🐛
- Other branches show cyan with 🔀

**Step 4: Commit**

```bash
git add ~/.claude/status_lines/status_line.py
git commit -m "feat: add git branch formatting with color coding"
```

---

## Task 3: Integrate Branch Into Status Line

**Files:**
- Modify: `~/.claude/status_lines/status_line.py:182-258`

**Step 1: Add branch detection in generate_status_line()**

In the `generate_status_line()` function, add branch detection after line 196 (after getting output_style_name):

```python
    # Get git branch
    git_branch = get_git_branch()
    formatted_branch = format_git_branch(git_branch)
```

**Step 2: Insert formatted branch into status line parts**

Find the section where parts are being built (around line 226-230). After the model name is added, insert the git branch:

Change this section:
```python
    # Model name - Blue
    parts.append(f"\033[34m[{model_name}]\033[0m")

    # Output style - Magenta
    if output_style_name:
        parts.append(f"\033[35m[{output_style_name}]\033[0m")
```

To this:
```python
    # Model name - Blue
    parts.append(f"\033[34m[{model_name}]\033[0m")

    # Git branch (if available)
    if formatted_branch:
        parts.append(formatted_branch)

    # Output style - Magenta
    if output_style_name:
        parts.append(f"\033[35m[{output_style_name}]\033[0m")
```

**Step 3: Test status line generation**

Test the complete status line by feeding it mock input:

```bash
echo '{
  "session_id": "test-session",
  "model": {"display_name": "Sonnet 4.5"},
  "output_style": {"name": "builder-mode"},
  "transcript_path": null
}' | uv run ~/.claude/status_lines/status_line.py
```

Expected: Should show status line with git branch between model name and output style

**Step 4: Verify in actual Claude Code session**

The status line updates automatically. Open a new prompt in Claude Code and verify the status line shows:

`[Agent] | [Model] | 🌳 main | [output-style] | 💬 prompt...`

**Step 5: Test branch changes**

Test that branch display updates when switching branches:

```bash
# Create and switch to a test feature branch
git checkout -b feature/test-branch-display

# Trigger status line update (send any prompt to Claude Code)
# Verify status line now shows: ✨ feature/test-branch-display

# Switch back
git checkout main
```

Expected: Status line should update to show new branch with appropriate icon/color

**Step 6: Commit**

```bash
git add ~/.claude/status_lines/status_line.py
git commit -m "feat: integrate git branch into status line display"
```

---

## Task 4: Handle Edge Cases

**Files:**
- Modify: `~/.claude/status_lines/status_line.py:120-180`

**Step 1: Add error handling for detached HEAD**

Update `get_git_branch()` to handle detached HEAD state:

```python
def get_git_branch():
    """Get the current git branch name."""
    import subprocess

    try:
        # Try to get the current branch using git
        result = subprocess.run(
            ["git", "branch", "--show-current"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=os.getcwd()
        )

        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

        # Fallback: try git symbolic-ref for older git versions
        result = subprocess.run(
            ["git", "symbolic-ref", "--short", "HEAD"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=os.getcwd()
        )

        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

        # Check if we're in detached HEAD state
        result = subprocess.run(
            ["git", "rev-parse", "--short", "HEAD"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=os.getcwd()
        )

        if result.returncode == 0 and result.stdout.strip():
            # Return detached HEAD indicator
            return f"detached:{result.stdout.strip()[:7]}"

        return None

    except (subprocess.TimeoutExpired, FileNotFoundError, Exception):
        # Git not installed, not a git repo, or command timed out
        return None
```

**Step 2: Add formatting for detached HEAD**

Update `format_git_branch()` to handle detached HEAD:

```python
def format_git_branch(branch):
    """Format git branch name with color coding and icon."""
    if not branch:
        return None

    # Handle detached HEAD state
    if branch.startswith("detached:"):
        commit_hash = branch.split(":")[1]
        return f"\033[90m⚠️  detached:{commit_hash}\033[0m"

    # Truncate very long branch names
    if len(branch) > 25:
        branch = branch[:22] + "..."

    # Color code by branch type
    if branch == "main" or branch == "master":
        # Green for main branches
        color = "\033[92m"
        icon = "🌳"
    elif branch.startswith("feature/") or branch.startswith("feat/"):
        # Blue for feature branches
        color = "\033[94m"
        icon = "✨"
    elif branch.startswith("fix/") or branch.startswith("bugfix/"):
        # Yellow for bugfix branches
        color = "\033[93m"
        icon = "🐛"
    elif branch.startswith("hotfix/"):
        # Red for hotfix branches
        color = "\033[91m"
        icon = "🚨"
    elif branch.startswith("release/"):
        # Magenta for release branches
        color = "\033[95m"
        icon = "🚀"
    else:
        # Cyan for other branches
        color = "\033[96m"
        icon = "🔀"

    return f"{color}{icon} {branch}\033[0m"
```

**Step 3: Test detached HEAD state**

```bash
# Enter detached HEAD state
git checkout HEAD~1

# Trigger status line update
# Verify status line shows: ⚠️ detached:abc1234

# Return to branch
git checkout main
```

Expected: Status line should show detached HEAD indicator with commit hash

**Step 4: Test non-git directory**

```bash
# Navigate to non-git directory
cd /tmp

# Run status line script
echo '{"session_id": "test", "model": {"display_name": "Claude"}}' | uv run ~/.claude/status_lines/status_line.py

# Return to repo
cd ~/.claude
```

Expected: Status line should work without git branch (gracefully omit branch display)

**Step 5: Commit**

```bash
git add ~/.claude/status_lines/status_line.py
git commit -m "feat: handle edge cases for git branch display"
```

---

## Task 5: Add Documentation

**Files:**
- Create: `~/.claude/status_lines/README.md`

**Step 1: Create README documenting the status line features**

```markdown
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
```

**Step 2: Save README**

```bash
cat > ~/.claude/status_lines/README.md << 'EOF'
[paste content from Step 1]
EOF
```

**Step 3: Verify README renders correctly**

```bash
cat ~/.claude/status_lines/README.md
```

Expected: README content displays correctly with proper markdown formatting

**Step 4: Commit**

```bash
git add ~/.claude/status_lines/README.md
git commit -m "docs: add comprehensive README for status line script"
```

---

## Task 6: Final Testing & Validation

**Files:**
- Test: `~/.claude/status_lines/status_line.py`

**Step 1: Test main branch display**

```bash
git checkout main
# Send any prompt to Claude Code
# Verify: 🌳 main appears in status line
```

Expected: Green "🌳 main" between model and output style

**Step 2: Test feature branch display**

```bash
git checkout -b feature/status-line-enhancement
# Send any prompt to Claude Code
# Verify: ✨ feature/status-line-enhancement appears
git checkout main
git branch -D feature/status-line-enhancement
```

Expected: Blue "✨ feature/status-line-enhancement" in status line

**Step 3: Test bugfix branch display**

```bash
git checkout -b fix/branch-display-bug
# Send any prompt to Claude Code
# Verify: 🐛 fix/branch-display-bug appears
git checkout main
git branch -D fix/branch-display-bug
```

Expected: Yellow "🐛 fix/branch-display-bug" in status line

**Step 4: Test long branch name truncation**

```bash
git checkout -b feature/very-long-branch-name-that-exceeds-twenty-five-characters
# Send any prompt to Claude Code
# Verify: Branch name is truncated with "..."
git checkout main
git branch -D feature/very-long-branch-name-that-exceeds-twenty-five-characters
```

Expected: Truncated branch name ending with "..."

**Step 5: Test non-git directory behavior**

```bash
cd /tmp
# Trigger status line in non-git directory
# Verify: Status line works without branch display
cd ~/.claude
```

Expected: Status line functions normally, git branch omitted

**Step 6: Visual inspection of complete status line**

Send a prompt to Claude Code and verify the complete status line format:

```
[Agent] | [Sonnet 4.5] | 🌳 main | [builder-mode] | 💬 Add git branch to status line | [142k/200k (71%)]
```

Expected: All components display correctly with proper spacing and colors

**Step 7: Final commit**

```bash
git add -A
git commit -m "test: verify all git branch display scenarios"
```

---

## Completion Checklist

- ✅ Git branch detection function implemented
- ✅ Branch formatting with color coding and icons
- ✅ Integration into status line display
- ✅ Edge case handling (detached HEAD, non-git dirs)
- ✅ Documentation (README.md)
- ✅ All scenarios tested and verified
- ✅ Code committed with descriptive messages

## Branch Display Reference

| Branch Pattern | Icon | Color | Example |
|----------------|------|-------|---------|
| `main`, `master` | 🌳 | Green | `🌳 main` |
| `feature/*`, `feat/*` | ✨ | Blue | `✨ feature/auth` |
| `fix/*`, `bugfix/*` | 🐛 | Yellow | `🐛 fix/login-error` |
| `hotfix/*` | 🚨 | Red | `🚨 hotfix/security` |
| `release/*` | 🚀 | Magenta | `🚀 release/v1.2.0` |
| Other | 🔀 | Cyan | `🔀 experimental` |
| Detached HEAD | ⚠️ | Gray | `⚠️ detached:abc1234` |

## Expected Status Line Format

```
[Agent Name] | [Model] | 🌳 branch | [output-style] | 💬 prompt | [tokens]
```

## Notes

- The status line updates automatically with each Claude Code interaction
- Git branch detection has a 2-second timeout to prevent hanging
- Branch display gracefully degrades if git is unavailable
- Long branch names (>25 chars) are automatically truncated
- All status line events are logged to `logs/status_line.json`

---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-status.sh:*)
argument-hint: <feature-name>
description: Show detailed status of a feature worktree
---

# Worktree Status

Shows comprehensive status information for a feature worktree.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-status.sh $ARGUMENTS
```

---

## Usage Example

```bash
/worktree-status user-auth
```

---

## Status Information Shown

### Working Tree Status
- ✅ Clean (no uncommitted changes)
- ⚠️ Modified files (with count)

### Remote Sync
- ✅ In sync with remote
- ⚠️ Behind remote (commits to pull)
- 📤 Ahead of remote (commits to push)
- ⚠️ No remote tracking branch

### Dev Server
- 📦 Running on port (with PID)
- 📦 Not running (port assigned)

### Statistics
- Files changed vs main branch
- Commits ahead of main
- Last commit time

### Pull Request Status
- PR number and state (if `gh` CLI available)
- PR title

---

## Next Steps

The status will suggest actions:
- Commit uncommitted changes
- Push unpushed commits
- Pull latest changes
- Create a pull request

---

## Requirements

- **Basic**: Git repository info
- **Optional**: `nc` or `lsof` for port checking
- **Optional**: `gh` CLI for PR information

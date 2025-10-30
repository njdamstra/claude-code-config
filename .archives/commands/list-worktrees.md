---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/list-worktrees.sh:*)
argument-hint:
description: Show all active worktrees and function workspaces
---

# List All Worktrees

Displays all active feature worktrees and function workspaces with their current status.

!`~/.local/bin/socialaize-worktree/list-worktrees.sh`

---

## What You'll See

### Feature Worktrees
- Feature name
- Port status (🟢 running, ⚪️ not running)
- Branch name
- File path

### Function Workspaces
- Workspace name
- Primary function
- Number of related functions

---

## Available Commands

After listing, you can:
- `/cleanup-worktree <name>` - Remove a feature worktree
- `/cleanup-functions-workspace <name>` - Remove a function workspace
- `/worktree-status <name>` - Show detailed status for a worktree

---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/wt-dispatcher.sh:*)
argument-hint: <action> [branch] [options]
description: Unified feature worktree management
---

# Feature Worktree Management

**Unified command for all feature worktree operations.**

Replaces: `/worktree-feature`, `/worktree-status`, `/worktree-actions`, `/cleanup-worktree`

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/wt-dispatcher.sh $ARGUMENTS
```

---

## Quick Reference

### Create Worktree
```bash
/wt create <branch> --existing-branch <name>
/wt create user-auth --existing-branch feat-auth --port 7000
```

### Development Workflow
```bash
/wt status user-auth         # Check status
/wt add-ai user-auth         # AI-assisted staging
/wt commit user-auth         # Show staged (then commit manually)
/wt push user-auth           # Push changes
```

### Cleanup
```bash
/wt cleanup user-auth        # Remove worktree (with safety checks)
/wt cleanup user-auth --force  # Force remove
```

### List All
```bash
/wt list                     # Show all feature worktrees
```

---

## Actions Reference

**create** - Create new feature worktree
**status** - Show worktree status (branch, port, changes)
**pull** - Pull latest changes from remote
**add** - Stage all changes
**add-ai** - AI-assisted staging (analyzes changes)
**commit** - Show staged changes (ready for commit message)
**push** - Push to remote
**cleanup** - Remove worktree (safety checks included)
**list** - List all feature worktrees
**help** - Show detailed help

---

## Safety Features

✅ **Fullstack Protection** - Cannot accidentally cleanup fullstack workspace
✅ **Uncommitted Changes Detection** - Warns before destructive operations
✅ **Unpushed Commits Detection** - Prevents loss of local commits
✅ **Port Conflict Prevention** - Auto-assigns unique ports
✅ **Race-Condition Safe** - Flock locking for concurrent operations

---

## Migration from Old Commands

Old commands still work but are deprecated:

| Old | New |
|-----|-----|
| `/worktree-feature <name>` | `/wt create <name>` |
| `/worktree-status <name>` | `/wt status <name>` |
| `/worktree-actions <name> add` | `/wt add <name>` |
| `/worktree-actions <name> push` | `/wt push <name>` |
| `/cleanup-worktree <name>` | `/wt cleanup <name>` |

---

For fullstack workspace management, see: `/wt-full help`

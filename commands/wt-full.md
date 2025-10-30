---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/wt-full-dispatcher.sh:*)
argument-hint: <action> [options]
description: Unified fullstack workspace management
---

# Fullstack Workspace Management

**Unified command for permanent fullstack workspace operations.**

Replaces: `/worktree-init`, `/worktree-switch`, `/worktree-add-function`, `/worktree-remove-function`

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/wt-full-dispatcher.sh $ARGUMENTS
```

---

## Quick Reference

### One-Time Setup
```bash
/wt-full init                              # Initialize workspace
/wt-full init --frontend main --port 6942  # With options
```

### Switch Frontend Branch
```bash
/wt-full switch feat-auth                  # Switch to feature branch
/wt-full switch main                       # Back to main
/wt-full switch feat-ui --port 7000        # With custom port
```

### Function Management
```bash
/wt-full add-fn NewNotificationHandler     # Add function worktree
/wt-full rm-fn DeprecatedFunction          # Remove function worktree
```

### Status
```bash
/wt-full status                            # Show workspace details
/wt-full list                              # Same as status
```

---

## Actions Reference

**init** - Initialize fullstack workspace (one-time setup)
**switch** - Switch frontend branch (functions unchanged)
**status** - Show workspace status (frontend branch, functions count)
**add-fn** - Add new function worktree
**rm-fn** - Remove function worktree
**list** - Show workspace details
**help** - Show detailed help

---

## Workspace Structure

```
~/socialaize-worktrees/fullstack/
├── frontend/                 # Switchable branch (main, feat-*, etc.)
│   ├── src/                  # Full frontend code
│   ├── functions/            # Full access to all functions
│   └── .env.local            # PORT=6942 (or custom)
└── functions/                # All functions (sparse checkout)
    ├── EmailHandler/         # Only functions/EmailHandler/ (~50KB)
    ├── WorkflowManager/      # Only functions/WorkflowManager/
    └── ... (27+ functions total)
```

**Storage:**
- Total workspace: ~50-100MB
- Each function: ~50KB (sparse checkout - 99% savings)
- Frontend: ~45MB (full checkout)

---

## Common Workflows

### Start Development
```bash
cd ~/socialaize-worktrees/fullstack/frontend
pnpm dev  # Opens on configured PORT
```

### Work on Feature Branch
```bash
/wt-full switch feat-auth              # Switch to feature
# ... make changes ...
cd ~/socialaize-worktrees/fullstack/frontend
git add . && git commit -m "feat: auth"
git push origin feat-auth
```

### Edit Function
```bash
cd ~/socialaize-worktrees/fullstack/functions/EmailHandler/functions/EmailHandler/
# ... make changes ...
cd ~/socialaize-worktrees/fullstack/functions/EmailHandler
git add . && git commit -m "fix: email bug"
git push origin functions-EmailHandler
```

---

## Migration from Old Commands

Old commands still work but are deprecated:

| Old | New |
|-----|-----|
| `/worktree-init` | `/wt-full init` |
| `/worktree-switch <branch>` | `/wt-full switch <branch>` |
| `/worktree-add-function <name>` | `/wt-full add-fn <name>` |
| `/worktree-remove-function <name>` | `/wt-full rm-fn <name>` |

---

For feature worktrees, see: `/wt help`

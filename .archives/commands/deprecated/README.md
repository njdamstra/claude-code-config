# Deprecated Commands

These commands have been replaced by the new unified worktree system.

## Old System (Deprecated)
- `/worktree-fullstack` → Use `/worktree-init` instead
- `/worktree-functions` → Functions now included in `/worktree-init`
- `/cleanup-fullstack-workspace` → Workspace is now permanent
- `/cleanup-functions-workspace` → N/A

## Current Worktree System

### Fullstack Development (Multi-function work)
- `/worktree-init` - One-time fullstack workspace setup with ALL functions
- `/worktree-switch` - Switch frontend branch
- `/worktree-add-function` - Add function worktree
- `/worktree-remove-function` - Remove function worktree

### Feature Development (Single-branch isolated work)
- `/worktree-feature` - Create isolated feature worktree (NOT deprecated)
  - Use when working on a single frontend branch
  - Lighter weight than fullstack workspace
  - Auto-assigns port, creates isolated environment
- `/cleanup-worktree` - Remove feature worktree

### Utilities
- `/list-worktrees` - View all worktrees
- `/worktree-status` - Show detailed worktree status
- `/worktree-actions` - Perform git actions on feature worktree


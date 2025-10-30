---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/cleanup-fullstack-workspace.sh:*)
argument-hint: <workspace-name> [--force]
description: Remove fullstack workspace safely with validation
---

# Cleanup Fullstack Workspace

Safely removes a fullstack workspace including frontend and all function worktrees.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/cleanup-fullstack-workspace.sh $ARGUMENTS
```

---

## Usage Examples

### Interactive Cleanup (with confirmation)
```bash
/cleanup-fullstack-workspace automations-improved
```

### Force Cleanup (skip confirmation)
```bash
/cleanup-fullstack-workspace automations-improved --force
```

---

## What This Does

1. **Validates** workspace exists at `~/socialaize-fullstack/<workspace-name>/`
2. **Lists** all worktrees to be removed (frontend + functions)
3. **Prompts for confirmation** (unless `--force` is used)
4. **Removes worktrees**:
   - Frontend worktree
   - All function worktrees
5. **Deletes workspace directory** with safety checks
6. **Preserves branches** in your repository (only removes worktrees)

---

## Safety Features

- ✅ Validates workspace path before deletion
- ✅ Shows what will be removed before proceeding
- ✅ Requires explicit confirmation (unless `--force`)
- ✅ Safety check ensures deletion only within `~/socialaize-fullstack/`
- ✅ Gracefully handles already-removed worktrees
- ✅ Never deletes git branches (only worktrees)

---

## Important Notes

- **Worktrees are removed**, but **branches remain** in your repository
- If you want to delete the branches too, do it manually:
  ```bash
  git branch -d <branch-name>              # Delete local branch
  git push origin --delete <branch-name>   # Delete remote branch
  ```
- Any uncommitted changes in the worktrees will be lost
- Make sure to commit and push your work before cleanup

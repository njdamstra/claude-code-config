---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/cleanup-functions-workspace.sh:*)
argument-hint: <workspace-name> [--force]
description: Remove function workspace safely with validation
---

# Cleanup Functions Workspace

Removes a function workspace after validating all changes are committed and pushed.

**Workspace Name:** `$1`
**Force Flag:** `$2`

!`~/.local/bin/socialaize-worktree/cleanup-functions-workspace.sh $1 $2`

---

## Usage Examples

### Normal Cleanup (with safety checks)
```bash
/cleanup-functions-workspace workflow-ai-integration
```

### Force Cleanup (skip safety checks)
```bash
/cleanup-functions-workspace workflow-ai-integration --force
```

---

## Safety Checks (Skip with --force)

The script validates **each function** in the workspace:
1. ✅ **No uncommitted changes** - All work is committed
2. ✅ **No unpushed commits** - All commits are pushed to remote

---

## What Happens

1. **Validates** all worktrees in the workspace
2. **Removes** all function worktrees
3. **Removes** the workspace directory
4. **Keeps** the function branches (delete manually if needed)

---

## If Cleanup Fails

The script will show which functions have issues:
- Uncommitted changes → Commit them
- Unpushed commits → Push to remote

You can use `--force` to skip all checks (⚠️ may lose work across multiple functions).

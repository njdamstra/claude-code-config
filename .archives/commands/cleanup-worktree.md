---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/cleanup-worktree.sh:*)
argument-hint: <feature-name> [--force]
description: Remove feature worktree safely with validation
---

# Cleanup Feature Worktree

Removes a feature worktree after validating all changes are committed and pushed.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/cleanup-worktree.sh $ARGUMENTS
```

---

## Usage Examples

### Normal Cleanup (with safety checks)
```bash
/cleanup-worktree user-auth
```

### Force Cleanup (skip safety checks)
```bash
/cleanup-worktree user-auth --force
```

---

## Safety Checks (Skip with --force)

The script validates before cleanup:
1. ✅ **No uncommitted changes** - All work is committed
2. ✅ **No unpushed commits** - All commits are pushed to remote
3. ✅ **Branch merged to main** - Work is integrated
4. ✅ **No open PRs** - Pull request is closed or merged

---

## What Happens

1. **Validates** the worktree is safe to remove
2. **Removes** the worktree directory
3. **Keeps** the branch (you can delete it manually if needed)
4. **Shows** instructions for deleting the branch

---

## If Cleanup Fails

The script will tell you exactly what's blocking cleanup:
- Uncommitted changes → Commit or stash them
- Unpushed commits → Push to remote first
- Not merged → Create and merge PR first
- Open PR → Close or merge the PR

You can use `--force` to skip all checks (⚠️ may lose work).

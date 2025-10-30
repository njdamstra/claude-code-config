---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-feature.sh:*)
argument-hint: <feature-name> [--existing-branch <branch>] [--type <frontend|backend|fullstack>] [--port <port>]
description: Create feature worktree with isolated dev server
---

# Create Feature Worktree

Creates an isolated worktree for parallel feature development with automatic port assignment.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-feature.sh $ARGUMENTS
```

---

## Usage Examples

### New Feature Branch
```bash
/worktree-feature user-auth
```

### With Custom Options
```bash
/worktree-feature payment-integration --type frontend --port 7000
```

### Existing Remote Branch
```bash
/worktree-feature hotfix --existing-branch feature/critical-fix
```

---

## What This Does

1. **Creates isolated worktree** in `~/socialaize-worktrees/feature-<name>/`
2. **Auto-assigns port** from range 6943-7020 (avoids conflicts)
3. **Sets up environment**:
   - `.env.local` with PORT configuration
   - Symlinks `.env.shared` from main repo
   - Adds `dev:worktree` script to package.json
4. **Creates documentation**: WORKTREE_README.md with full instructions
5. **VS Code workspace**: `<feature-name>.code-workspace`

---

## Next Steps After Creation

The command output will show you:
- Worktree location
- Assigned port (for frontend/fullstack)
- How to open in VS Code
- How to start dev server

Check the WORKTREE_README.md in the new worktree for complete workflow instructions.

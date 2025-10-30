---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-switch.sh:*)
argument-hint: <branch> [--port <port>]
description: Switch frontend branch in fullstack workspace (functions stay unchanged)
---

# Switch Frontend Branch

Switch the frontend branch in your permanent fullstack workspace.

**Functions remain unchanged** - only the frontend branch switches!

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-switch.sh $ARGUMENTS
```

---

## Usage Examples

### Switch to Feature Branch
```bash
/worktree-switch feat-email-marketing
```

### Switch with Custom Port
```bash
/worktree-switch feat-auth-system --port 7000
```

### Switch Back to Main
```bash
/worktree-switch main
```

---

## What This Does

1. **Removes** current frontend worktree
2. **Creates** new frontend worktree on specified branch
3. **Preserves** ALL function worktrees (untouched!)
4. **Updates** `.env.local` with port configuration
5. **Updates** WORKSPACE_README.md with new branch info

---

## Before and After

**Before:**
```
~/socialaize-worktrees/fullstack/
├── frontend/          # Branch: main
└── functions/         # 25 functions
```

**Command:**
```bash
/worktree-switch feat-email-marketing
```

**After:**
```
~/socialaize-worktrees/fullstack/
├── frontend/          # Branch: feat-email-marketing ✅ CHANGED
└── functions/         # 25 functions ✅ UNCHANGED
```

---

## Important Notes

⚠️ **Uncommitted Changes**:
- Command will FAIL if frontend has uncommitted changes
- Commit or stash changes before switching

🔧 **Functions Unchanged**:
- ALL function worktrees remain intact
- No need to recreate functions
- Switching is fast (~2 seconds)

📝 **Port Configuration**:
- If not specified, preserves current port
- Or uses default port 6942
- Specify `--port <number>` to change

---

## Common Workflows

### Feature Development Workflow
```bash
# Start new feature
/worktree-switch feat-new-feature

# Work on it
cd ~/socialaize-worktrees/fullstack/frontend
# ... make changes ...

# Switch to another feature
/worktree-switch feat-other-feature

# Back to main
/worktree-switch main
```

### Multi-Feature Workflow
```bash
# Morning: Work on authentication
/worktree-switch feat-auth-system
pnpm dev  # Port 6942

# Afternoon: Switch to email marketing
/worktree-switch feat-email-marketing
pnpm dev  # Same port reused

# Evening: Quick bug fix on main
/worktree-switch main
```

---

## Error Handling

### Uncommitted Changes Error
```bash
❌ Error: Uncommitted changes in frontend worktree
   Please commit or stash changes before switching
```

**Solution:**
```bash
cd ~/socialaize-worktrees/fullstack/frontend
git add .
git commit -m "wip: save progress"
# OR
git stash
```

### Branch Not Found Error
```bash
❌ Error: Branch 'feat-nonexistent' not found
```

**Solution:**
- Check available branches: `git branch -a`
- Create branch first: `git checkout -b feat-nonexistent`
- Then switch: `/worktree-switch feat-nonexistent`

---

## After Switching

### Start Development
```bash
cd ~/socialaize-worktrees/fullstack/frontend
pnpm install  # If needed (package.json might have changed)
pnpm dev
```

### Verify Switch
```bash
/list-worktrees
# Shows: Frontend: feat-email-marketing
```

### Check Status
```bash
/worktree-status fullstack
```

---

## Pro Tips

💡 **Fast Iteration**: Switching takes ~2 seconds vs ~5 minutes recreating workspace

💡 **Functions Persist**: All 25+ function worktrees stay forever - no recreation needed

💡 **Port Flexibility**: Each branch can have different port if needed

💡 **No Data Loss**: Old branch code preserved in git - just switching worktree

---

## Related Commands

- `/list-worktrees` - See current frontend branch and all worktrees
- `/worktree-status fullstack` - Detailed status of fullstack workspace
- `/worktree-init` - Create fullstack workspace (one-time)
- `/worktree-add-function <name>` - Add function worktree

---

**Remember**: This only switches the frontend. Functions stay on their respective `functions-FunctionName` branches and are always available!

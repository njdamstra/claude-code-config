---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-remove-function.sh:*)
argument-hint: <FunctionName> [--force]
description: Remove a function worktree from fullstack workspace
---

# Remove Function Worktree

Remove a function worktree from the fullstack workspace.

**Use when:** You never work on a specific function and want to reduce clutter.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-remove-function.sh $ARGUMENTS
```

---

## Usage Examples

### Remove Single Function
```bash
/worktree-remove-function OldDeprecatedFunction
```

### Force Remove (with uncommitted changes)
```bash
/worktree-remove-function ExperimentalFeature --force
```

---

## What This Does

1. **Checks** for uncommitted changes (fails if found, unless `--force`)
2. **Removes** the function worktree
3. **Frees** storage (~50KB per function)
4. **Preserves** the branch in git (can re-add later)

---

## Before and After

**Before:**
```
~/socialaize-worktrees/fullstack/functions/
├── EmailHandler/
├── OldDeprecatedFunction/
└── WorkflowManager/
```

**Command:**
```bash
/worktree-remove-function OldDeprecatedFunction
```

**After:**
```
~/socialaize-worktrees/fullstack/functions/
├── EmailHandler/
└── WorkflowManager/
```

---

## When to Use

✅ **Use this when:**
- You never edit a specific function
- Want to reduce workspace clutter
- Temporarily removed a function from codebase
- Freed up function worktree after experimentation

❌ **Don't use this when:**
- You might need to edit the function soon
- Function has uncommitted changes (commit first or use `--force`)
- You're unsure - functions use minimal storage (~50KB each)

---

## Safety Features

### Uncommitted Changes Check
```bash
# If function has uncommitted changes:
❌ Error: Uncommitted changes in function worktree
   Use --force to remove anyway, or commit changes first
```

**Options:**
1. Commit changes first:
```bash
cd ~/socialaize-worktrees/fullstack/functions/MyFunction
git add . && git commit -m "save progress"
/worktree-remove-function MyFunction
```

2. Force remove (loses changes):
```bash
/worktree-remove-function MyFunction --force
```

---

## Re-adding Later

Removed functions can be re-added anytime:

```bash
# Remove function
/worktree-remove-function EmailTemplateRenderer

# Later, need it again
/worktree-add-function EmailTemplateRenderer
```

The git branch still exists, so re-adding is fast and preserves history.

---

## Storage Impact

Each function worktree uses ~50KB (sparse checkout).

**Removing 5 functions:**
- Storage freed: ~250KB
- Impact: Minimal (functions use very little space)

**Recommendation:** Only remove functions you're 100% sure you won't edit. Storage savings are minimal due to sparse checkout.

---

## Error Handling

### Function Not Found
```bash
⚠️  Function worktree not found: NonExistentFunction
   Available functions:
   EmailHandler
   EmailFlowProcessor
   ...
```

**Solution:** Function not in workspace - nothing to remove!

### Uncommitted Changes
```bash
❌ Error: Uncommitted changes in function worktree
   Use --force to remove anyway, or commit changes first
```

**Solution:** Commit changes or use `--force` flag

---

## Common Use Cases

### Cleanup Deprecated Functions
```bash
/worktree-remove-function OldEmailHandler
/worktree-remove-function DeprecatedAuthService
/worktree-remove-function LegacyPostProcessor
```

### Temporary Experiment Cleanup
```bash
# After finishing experiment
/worktree-remove-function ExperimentalAI
/worktree-remove-function TestNotificationService
```

### Minimize Workspace for Focused Work
```bash
# Only keep functions you actively develop
/list-worktrees  # See all functions
/worktree-remove-function FunctionA
/worktree-remove-function FunctionB
# Keep only EmailHandler, WorkflowManager, AI_API
```

---

## Verification

### Check Function Removed
```bash
/list-worktrees
# Function should not appear in list
```

### Verify Storage Freed
```bash
du -sh ~/socialaize-worktrees/fullstack/functions/
# Should be slightly smaller
```

### Confirm Branch Still Exists
```bash
git branch -a | grep functions-RemovedFunction
# Should still show the branch in git
```

---

## Related Commands

- `/list-worktrees` - See all functions in workspace
- `/worktree-add-function <name>` - Re-add removed function
- `/worktree-status fullstack` - Show workspace status
- `/worktree-init --force` - Recreate entire workspace (adds all functions)

---

💡 **Pro Tip**: Functions use minimal storage (~50KB each) due to sparse checkout. Only remove functions you're absolutely sure you won't edit. It's usually better to keep them all!

---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-add-function.sh:*)
argument-hint: <FunctionName>
description: Add a function worktree to fullstack workspace (sparse checkout)
---

# Add Function Worktree

Add a new function worktree to the fullstack workspace with sparse checkout.

**Use when:** A new function is created in the codebase and you want it in your workspace.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-add-function.sh $ARGUMENTS
```

---

## Usage Examples

### Add Single Function
```bash
/worktree-add-function NotificationHandler
```

### Add Multiple Functions (run separately)
```bash
/worktree-add-function EmailTemplateRenderer
/worktree-add-function SMSHandler
/worktree-add-function PushNotificationService
```

---

## What This Does

1. **Checks** if function exists in `functions/FunctionName/`
2. **Creates** sparse checkout worktree for the function
3. **Adds** to `~/socialaize-worktrees/fullstack/functions/`
4. **Auto-creates** `functions-FunctionName` branch if needed
5. **Applies** sparse checkout (only function code, ~50KB)

---

## Before and After

**Before:**
```
~/socialaize-worktrees/fullstack/functions/
├── EmailHandler/
├── EmailFlowProcessor/
└── WorkflowManager/
```

**Command:**
```bash
/worktree-add-function NotificationHandler
```

**After:**
```
~/socialaize-worktrees/fullstack/functions/
├── EmailHandler/
├── EmailFlowProcessor/
├── NotificationHandler/      ✅ NEW
│   └── functions/
│       └── NotificationHandler/   # Only this directory (~50KB)
└── WorkflowManager/
```

---

## When to Use

✅ **Use this when:**
- A new function was created in the main repository
- You want to work on a function not in your workspace
- Team member added a function you need to edit

❌ **Don't use this when:**
- Function already exists in workspace (check with `/list-worktrees`)
- Function doesn't exist in repository yet (create it first)

---

## Working with the New Function

### After Adding
```bash
# Navigate to function
cd ~/socialaize-worktrees/fullstack/functions/NotificationHandler/functions/NotificationHandler/

# Install dependencies
npm install

# Build
npm run build

# Make changes
# ... edit files ...

# Commit (from worktree root)
cd ~/socialaize-worktrees/fullstack/functions/NotificationHandler
git add .
git commit -m "feat: add notification handler"
git push origin functions-NotificationHandler
```

---

## Sparse Checkout Details

**What gets included:**
- `functions/NotificationHandler/` - ONLY this directory
- ~50KB storage per function

**What doesn't get included:**
- Frontend code (`src/`)
- Other functions
- Root config files
- Total savings: ~99.97% (50KB vs 200MB)

**Why sparse checkout?**
- Minimal storage
- Faster operations
- Only relevant code
- Git still works normally

---

## Error Handling

### Function Not Found
```bash
❌ Error: Function 'functions/NotificationHandler' not found in repository
   Available functions:
   EmailHandler
   EmailFlowProcessor
   ...
```

**Solution:** Create the function in the main repository first, then add to workspace

### Function Already Exists
```bash
⚠️  Function worktree already exists: NotificationHandler
   Path: ~/socialaize-worktrees/fullstack/functions/NotificationHandler
```

**Solution:** Function already in workspace - no action needed!

---

## Branch Creation

If `functions-NotificationHandler` branch doesn't exist:
1. Script creates it from current HEAD
2. Pushes to origin automatically
3. Ready for development

If branch exists:
1. Script checks out existing branch
2. Pulls latest changes
3. Ready for development

---

## Verification

### Check Function Added
```bash
/list-worktrees
# Should show NotificationHandler in functions list
```

### Verify Sparse Checkout
```bash
cd ~/socialaize-worktrees/fullstack/functions/NotificationHandler
ls -la
# Should only see: functions/NotificationHandler/
```

### Check Storage
```bash
du -sh ~/socialaize-worktrees/fullstack/functions/NotificationHandler
# Should be ~50KB (sparse checkout working!)
```

---

## Common Use Cases

### New Function Created by Team
```bash
# Team created NotificationHandler
cd ~/socialaize/functions/NotificationHandler  # Verify it exists
cd ~/socialaize
/worktree-add-function NotificationHandler
```

### Multiple Related Functions
```bash
# Adding email-related functions
/worktree-add-function EmailTemplateRenderer
/worktree-add-function EmailAttachmentProcessor
/worktree-add-function EmailScheduler
```

### Temporary Function Work
```bash
# Add function
/worktree-add-function TemporaryExperiment

# Work on it
cd ~/socialaize-worktrees/fullstack/functions/TemporaryExperiment

# Remove when done
/worktree-remove-function TemporaryExperiment
```

---

## Related Commands

- `/list-worktrees` - See all functions in workspace
- `/worktree-remove-function <name>` - Remove function worktree
- `/worktree-status fullstack` - Show workspace status
- `/worktree-init` - Create fullstack workspace (includes all functions)

---

💡 **Pro Tip**: When `/worktree-init` runs, it adds ALL 25+ functions automatically. You only need this command for NEW functions created after initialization!

---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-init.sh:*)
argument-hint: [--frontend <branch>] [--port <port>] [--force]
description: Initialize permanent fullstack workspace with all functions (sparse checkout)
---

# Initialize Fullstack Workspace

**One-time setup** of the permanent Socialaize fullstack development workspace.

Creates `~/socialaize-worktrees/fullstack/` with:
- ✅ Frontend worktree (switchable branch)
- ✅ ALL 25+ function worktrees (sparse checkout)
- ✅ ~99% storage savings (~2MB vs ~200MB per function)

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-init.sh $ARGUMENTS
```

---

## Usage Examples

### Basic Initialization (Default: main, port 6942)
```bash
/worktree-init
```

### Initialize with Specific Frontend Branch
```bash
/worktree-init --frontend feat-email-marketing
```

### Initialize with Custom Port
```bash
/worktree-init --frontend main --port 7000
```

### Force Recreate (if already exists)
```bash
/worktree-init --force
```

---

## What This Creates

```
~/socialaize-worktrees/fullstack/
├── WORKSPACE_README.md          # Complete workspace guide
├── frontend/                     # Frontend worktree (switchable)
│   ├── src/
│   ├── functions/                # Full access to all functions
│   └── .env.local                # PORT=6942 (or custom)
└── functions/                    # ALL functions (sparse checkout)
    ├── EmailHandler/             # Only functions/EmailHandler/ (~50KB)
    ├── EmailFlowProcessor/       # Only functions/EmailFlowProcessor/
    ├── NotifHandler/            # Only functions/NotifHandler/
    ├── WorkflowManager/         # Only functions/WorkflowManager/
    └── ... (25+ functions total)
```

---

## Sparse Checkout Benefits

**Storage Comparison:**
- **Old system**: ~200MB × 25 functions = ~5GB
- **New system**: ~2MB × 25 functions = ~50MB
- **Savings**: ~99% reduction!

**What sparse checkout means:**
- Each function worktree ONLY contains `functions/FunctionName/`
- Frontend worktree has FULL repository access
- Massive storage savings, faster operations
- All functions still available for editing

---

## After Initialization

The workspace is **permanent** - you only run this once!

### Common Workflows

**Start Dev Server:**
```bash
cd ~/socialaize-worktrees/fullstack/frontend
pnpm dev  # Opens on port 6942 (or your custom port)
```

**Switch Frontend Branch:**
```bash
/worktree-switch feat-auth-system
/worktree-switch main
```

**Edit a Function:**
```bash
cd ~/socialaize-worktrees/fullstack/functions/EmailHandler/functions/EmailHandler/
# Make changes, then commit
cd ~/socialaize-worktrees/fullstack/functions/EmailHandler
git add . && git commit -m "fix: email handler"
```

**Add New Function (when created in codebase):**
```bash
/worktree-add-function NewFunctionName
```

---

## Important Notes

⚠️ **One-Time Setup**:
- Only run this command ONCE to create the workspace
- To change frontend branch, use `/worktree-switch` instead
- Workspace is permanent - functions stay, only frontend changes

📦 **Storage**:
- Total workspace: ~50-100MB (vs ~5GB+ old system)
- Each function: ~50KB (sparse checkout)
- Frontend: ~45MB (full checkout)

🔧 **Functions**:
- All 25+ functions created automatically
- Each on its own `functions-FunctionName` branch
- Sparse checkout applied (only function code)
- Can add/remove functions later if needed

---

## Next Steps

After initialization:
1. Read the guide: `cat ~/socialaize-worktrees/fullstack/WORKSPACE_README.md`
2. Start coding: `cd ~/socialaize-worktrees/fullstack/frontend && pnpm dev`
3. Switch branches: `/worktree-switch <branch-name>`
4. View status: `/list-worktrees`

---

## Troubleshooting

**If initialization fails:**
1. Check you're in the socialaize repository root
2. Ensure you have git worktree support (Git 2.5+)
3. Try with `--force` to recreate if it exists

**If workspace exists:**
- Use `--force` to recreate (destroys existing workspace!)
- Or use `/worktree-switch` to change frontend branch

---

💡 **Pro Tip**: This is a one-time setup. Once created, you'll use `/worktree-switch` to change frontend branches and `/worktree-add-function` to add new functions. The workspace stays permanent!

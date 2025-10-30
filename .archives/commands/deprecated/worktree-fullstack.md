---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-fullstack.sh:*)
argument-hint: <feature-name> --feature-branch <branch> --functions <func1> <func2> [...] [--workspace-name <name>] [--port <port>]
description: Create fullstack workspace combining feature branch with function branches
---

# Create Fullstack Workspace

Sets up an all-in-one workspace combining a frontend feature branch with related function branches for coordinated full-stack development.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-fullstack.sh $ARGUMENTS
```

---

## Usage Examples

### Basic Fullstack Workspace
```bash
/worktree-fullstack automations-improved --feature-branch feat-automations-improved --functions WorkflowManager AI_API
```

### With Custom Workspace Name
```bash
/worktree-fullstack my-feature --feature-branch feat-my-feature --functions WorkflowManager PostManager --workspace-name full-feature-dev
```

### With Custom Port
```bash
/worktree-fullstack auth-system --feature-branch feat-auth --functions UserManager SessionManager --port 7000
```

---

## What This Does

1. **Creates workspace** in `~/socialaize-fullstack/<feature-name>/`
2. **Sets up worktrees**:
   - `frontend/` - Your feature branch for frontend code
   - `functions/<FunctionName>/` - Each function on its `functions-<FunctionName>` branch
3. **Configures environment**:
   - `.env.local` with auto-assigned port (or custom port)
   - Symlinks to shared environment files
4. **Creates WORKSPACE_README.md** with:
   - Complete workspace structure
   - File paths for all worktrees
   - Build, test, commit, and PR workflows
   - Important reminders about separate branches

---

## Workspace Structure

```
~/socialaize-fullstack/<feature-name>/
├── WORKSPACE_README.md          # Master workspace guide
├── frontend/                     # Feature branch worktree
│   ├── src/
│   ├── functions/                # All functions (read-only reference)
│   └── .env.local                # PORT and workspace config
└── functions/
    ├── WorkflowManager/         # functions-WorkflowManager branch
    │   └── functions/WorkflowManager/
    └── AI_API/                  # functions-AI_API branch
        └── functions/AI_API/
```

---

## How Claude Works With This

After creation, Claude can:
- Read/edit files across frontend and all function worktrees simultaneously
- See the complete workspace structure in one place
- Understand relationships between frontend and backend code
- Build and test frontend and functions independently
- Commit changes to separate branches (frontend + each function)
- Create separate PRs for each modified branch

---

## Important Notes

⚠️ **Critical**:
- **Frontend** is on the **feature branch** (e.g., `feat-automations-improved`)
- **Each function** is on a **separate branch** (e.g., `functions-WorkflowManager`)
- Changes in one worktree **don't affect others** until merged
- You must **commit each worktree separately** to its branch
- Create **separate PRs** for the feature branch and each modified function branch
- Always **build functions** before committing to catch errors

📋 **Best Practices**:
- Use this when feature work requires changes to both frontend and functions
- Keep frontend and function changes logically related
- Test each component independently before integration
- Document cross-worktree dependencies in commit messages

🧹 **Cleanup**:
When done, use: `/cleanup-fullstack-workspace <feature-name>`

Check the WORKSPACE_README.md for complete instructions and file paths.

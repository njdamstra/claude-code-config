---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-functions.sh:*)
argument-hint: <primary-function> [related-functions...] [--workspace-name <name>]
description: Create function workspace for cross-function development
---

# Create Functions Workspace

Sets up multiple function worktrees for cross-function development in the same session.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-functions.sh $ARGUMENTS
```

---

## Usage Examples

### Single Function
```bash
/worktree-functions WorkflowManager
```

### Multiple Related Functions
```bash
/worktree-functions WorkflowManager AI_API PostManager
```

### Custom Workspace Name
```bash
/worktree-functions AI_API --workspace-name ai-integration-project
```

---

## What This Does

1. **Creates workspace** in `~/socialaize-functions-workspace/<name>/`
2. **Sets up worktrees** for each function from their `functions-<FunctionName>` branches
3. **Creates WORKSPACE_README.md** with:
   - Complete workspace structure
   - File paths for reading/editing
   - Build and test commands
   - Commit and PR workflows
4. **Detects automatically**:
   - Entry points (src/main.ts, src/index.ts, etc.)
   - Package managers (npm, pnpm, yarn)

---

## How Claude Works With This

After creation, Claude can:
- Read/edit files across all function worktrees simultaneously
- See the complete workspace structure
- Build and test each function independently
- Commit changes to separate branches
- Create separate PRs for each modified function

---

## Important Notes

- Each function is on a **separate branch** (`functions-FunctionName`)
- Changes in one worktree **don't affect others** until merged
- You must **build each function separately** before committing
- Create **separate PRs** for each function branch

Check the WORKSPACE_README.md for complete instructions and file paths.

---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/worktree-actions.sh:*), Bash(git add:*), Bash(git commit:*), Bash(git diff:*), Bash(git status:*)
argument-hint: <feature-name> <action>
description: Perform git actions on a feature worktree (pull, add, add-ai, commit, push)
---

# Worktree Actions

Perform common git operations on a feature worktree branch.

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/worktree-actions.sh $ARGUMENTS
```

---

## Available Actions

### `pull`
Pull latest changes from the remote branch.

```bash
/worktree-actions user-auth pull
```

### `add`
Stage all changes in the worktree.

```bash
/worktree-actions user-auth add
```

### `add-ai`
**AI-assisted intelligent staging.** Claude Code will:
1. Analyze all current changes
2. Stage only meaningful files (excludes: `.md`, `.orig`, `.rej`, temp files, docs)
3. Provide detailed feedback on the changes
4. Report any concerns or issues detected

```bash
/worktree-actions user-auth add-ai
```

**After running `add-ai`, Claude will:**
- Review the git status and diff output
- Intelligently select which files to stage using `git add <file>`
- Exclude documentation, temporary, and generated files
- Analyze code changes for potential issues
- Provide a summary of what was staged and why

### `commit`
Show staged changes and prompt for commit (commit message required separately).

```bash
/worktree-actions user-auth commit
```

### `push`
Push commits to the remote branch.

```bash
/worktree-actions user-auth push
```

---

## Usage Examples

### Standard Workflow
```bash
# Pull latest changes
/worktree-actions my-feature pull

# Stage all changes
/worktree-actions my-feature add

# Check what's staged
/worktree-actions my-feature commit

# Push to remote
/worktree-actions my-feature push
```

### AI-Assisted Workflow
```bash
# Pull latest
/worktree-actions my-feature pull

# Let Claude analyze and stage intelligently
/worktree-actions my-feature add-ai

# (Claude will stage files and provide feedback)

# Commit with message
cd ~/socialaize-worktrees/feature-my-feature
git commit -m "feat: add user authentication"

# Push
/worktree-actions my-feature push
```

---

## Action Details

### Pull
- Fetches and merges changes from `origin/<branch>`
- Reports merge status
- Handles conflicts if any

### Add (Standard)
- Stages all modified, new, and deleted files
- Reports number of files staged
- Use when you want to commit everything

### Add-AI (Intelligent)
- **Analyzes changes** using Claude Code
- **Filters out** documentation (`.md`), merge artifacts (`.orig`, `.rej`)
- **Excludes** temporary files, build artifacts, config files
- **Provides feedback** on code quality and potential issues
- **Reports concerns** about breaking changes, missing tests, etc.

**Files typically excluded by add-ai:**
- `*.md` - Documentation files
- `*.orig`, `*.rej` - Merge conflict artifacts
- `*.log` - Log files
- `.env.local` - Local environment config
- `package-lock.json`, `pnpm-lock.yaml` - Lock files (unless intentional)
- `node_modules/**` - Dependencies

### Commit
- Shows what's currently staged
- Prompts you to provide commit message
- Does not auto-commit (you control the message)

### Push
- Pushes all unpushed commits to remote
- Reports number of commits pushed
- Skips if already in sync

---

## Special Instructions for add-ai

When `/worktree-actions <name> add-ai` is run, Claude Code should:

1. **Analyze the output** from the script showing `git status` and `git diff`

2. **Review each changed file** and determine:
   - Is it a meaningful code change?
   - Is it documentation that should be excluded?
   - Is it a temporary/generated file?
   - Are there any concerning patterns in the changes?

3. **Stage files selectively** using:
   ```bash
   cd ~/socialaize-worktrees/feature-<name>
   git add src/components/MyComponent.vue
   git add src/utils/helper.ts
   # etc.
   ```

4. **Provide detailed feedback**:
   - Summary of staged files
   - Explanation of excluded files
   - Code quality observations
   - Potential issues or concerns
   - Suggestions for commit message

5. **Report concerns** such as:
   - Breaking changes detected
   - Missing tests for new features
   - Security issues
   - Performance concerns
   - Inconsistent code style

---

## Requirements

- Git repository with worktree
- Branch must exist
- For `push`: remote tracking branch must be set
- For `pull`: internet connection to fetch from remote

---

## Tips

- Use `add-ai` for complex changes where you want review feedback
- Use regular `add` for simple, straightforward changes
- Always run `pull` before starting work to stay in sync
- Use `/worktree-status <name>` to check state before actions

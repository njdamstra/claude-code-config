# Worktree Symlink Analysis

**Date**: 2025-10-29
**Researcher**: Claude Code
**Purpose**: Analyze symlink setup inconsistencies between `/wt` and `/wt-full` commands

---

## Executive Summary

### Key Findings
1. ✅ **Feature worktrees** (`/wt`) place symlinks at worktree ROOT
2. ⚠️ **Fullstack workspace** (`/wt-full`) places symlinks in `frontend/` subdirectory
3. ❌ **Inconsistency**: Fullstack has extra `.claude/` directory at root (not symlink)
4. ✅ **Source files**: Both reference `~/socialaize-config/` correctly

### Recommendation
Move fullstack symlinks from `~/socialaize-worktrees/fullstack/frontend/` to `~/socialaize-worktrees/fullstack/` for consistency and better UX.

---

## 1. Directory Structure Overview

### Source Configuration (Shared)
```
~/socialaize-config/
├── .claude/                      # Source directory for all Claude config
│   ├── agents/
│   ├── commands/
│   ├── skills/
│   └── ...
├── CLAUDE.md                     # Source file for Claude instructions
└── README.md
```

### Main Repository
```
~/socialaize/
├── .claude -> ~/socialaize-config/.claude        # ✅ Symlink
├── CLAUDE.md -> ~/socialaize-config/CLAUDE.md    # ✅ Symlink
└── ... (all source files)
```

### Feature Worktrees (via `/wt create`)
```
~/socialaize-worktrees/feat-landing-docs/
├── .claude -> ~/socialaize-config/.claude        # ✅ Symlink at ROOT
├── CLAUDE.md -> ~/socialaize-config/CLAUDE.md    # ✅ Symlink at ROOT
├── .env.local
├── WORKTREE_README.md
└── ... (worktree files)
```

### Fullstack Workspace (via `/wt-full init`)
```
~/socialaize-worktrees/fullstack/
├── .claude/                                      # ❌ Real directory (unexpected)
│   └── settings.local.json
├── WORKSPACE_README.md
├── frontend/                                     # Git worktree
│   ├── .claude -> ~/socialaize-config/.claude   # ✅ Symlink in SUBDIRECTORY
│   ├── CLAUDE.md -> ~/socialaize-config/CLAUDE.md # ✅ Symlink in SUBDIRECTORY
│   ├── .git -> ~/socialaize/.git/worktrees/frontend
│   └── ... (full frontend code)
└── functions/                                    # Sparse function worktrees
    ├── EmailHandler/
    ├── WorkflowManager/
    └── ... (27+ functions)
```

---

## 2. Symlink Creation Logic

### Shared Script: `setup-claude-config.sh`

**Location**: `~/.local/bin/socialaize-worktree/setup-claude-config.sh`

**Function**: Creates two symlinks:
```bash
ln -s "${HOME}/socialaize-config/.claude" "${TARGET_DIR}/.claude"
ln -s "${HOME}/socialaize-config/CLAUDE.md" "${TARGET_DIR}/CLAUDE.md"
```

**Critical Parameter**: `TARGET_DIR` (passed as first argument)

### `/wt create` Flow (Feature Worktrees)

**Script**: `worktree-feature.sh:367`
```bash
"${SCRIPT_DIR}/setup-claude-config.sh" "$WORKTREE_DIR"
```

**Where**: `WORKTREE_DIR="~/socialaize-worktrees/{feature-name}"`
**Result**: Symlinks placed at **worktree ROOT** ✅

### `/wt-full init` Flow (Fullstack Workspace)

**Script**: `worktree-init.sh:145`
```bash
"${SCRIPT_DIR}/setup-claude-config.sh" "$FRONTEND_PATH"
```

**Where**: `FRONTEND_PATH="~/socialaize-worktrees/fullstack/frontend"`
**Result**: Symlinks placed in **frontend/ subdirectory** ⚠️

### `/wt-full switch` Flow (Branch Switching)

**Script**: `worktree-switch.sh:177`
```bash
# Cleanup logic (lines 167-172)
rm -rf "$FRONTEND_PATH/.claude.backup."* "$FRONTEND_PATH/CLAUDE.md.backup."* 2>/dev/null || true
if [ -d "$FRONTEND_PATH/.claude" ] && [ ! -L "$FRONTEND_PATH/.claude" ]; then
  rm -rf "$FRONTEND_PATH/.claude" 2>/dev/null || true
fi

# Create symlinks
"${SCRIPT_DIR}/setup-claude-config.sh" "$FRONTEND_PATH"
```

**Where**: `FRONTEND_PATH="~/socialaize-worktrees/fullstack/frontend"`
**Result**: Same as init - symlinks in frontend/ subdirectory ⚠️

---

## 3. Issues and Inconsistencies

### Issue 1: Symlink Location Inconsistency
**Severity**: Medium
**Impact**: UX confusion, potential workflow issues

| Worktree Type | Symlink Location | Expected Behavior |
|---------------|------------------|-------------------|
| Main repo | `~/socialaize/` | ✅ Correct |
| Feature worktree | `~/socialaize-worktrees/feat-*/` | ✅ Correct |
| Fullstack workspace | `~/socialaize-worktrees/fullstack/frontend/` | ❌ Should be at `fullstack/` root |

**Why this matters**:
- When working in `~/socialaize-worktrees/fullstack/`, Claude Code doesn't see `CLAUDE.md` or `.claude/`
- User must `cd frontend/` to access Claude configuration
- Inconsistent with feature worktree behavior
- Breaks expectation of "workspace root" having Claude config

### Issue 2: Unexpected `.claude/` Directory at Fullstack Root
**Severity**: Low
**Impact**: Potential confusion

```bash
~/socialaize-worktrees/fullstack/.claude/
└── settings.local.json
```

**Analysis**:
- This is a REAL directory, not a symlink
- Contains only `settings.local.json`
- Not created by worktree scripts
- Possibly created manually or by Claude Code itself
- Should be removed or converted to symlink

### Issue 3: Cleanup Logic Only in `worktree-switch.sh`
**Severity**: Low
**Impact**: Potential leftover files

**Current logic** (`worktree-switch.sh:167-172`):
```bash
rm -rf "$FRONTEND_PATH/.claude.backup."* "$FRONTEND_PATH/CLAUDE.md.backup."* 2>/dev/null || true
if [ -d "$FRONTEND_PATH/.claude" ] && [ ! -L "$FRONTEND_PATH/.claude" ]; then
  rm -rf "$FRONTEND_PATH/.claude" 2>/dev/null || true
fi
```

**Missing in**:
- `worktree-init.sh` (no cleanup before symlink creation)
- `worktree-feature.sh` (has cleanup via `setup-claude-config.sh`)

---

## 4. Root Cause Analysis

### Why Fullstack Uses `frontend/` Subdirectory

**Design Decision**:
The fullstack workspace has a special structure:
```
fullstack/
├── frontend/        # ACTUAL git worktree
└── functions/       # Multiple sparse worktrees
```

Only `frontend/` is a git worktree. The `fullstack/` directory itself is NOT a git worktree - it's just a container.

**Current Logic**:
Since `frontend/` is the actual git worktree, the scripts place symlinks there (where development happens).

**Problem**:
User experience assumes `fullstack/` is the "workspace root" but Claude config is nested one level deeper.

---

## 5. Solution Design: Move Symlinks to Fullstack Root

### Approach A: Simple Relocation (Recommended)
**Change**: Update `worktree-init.sh` and `worktree-switch.sh` to place symlinks at `~/socialaize-worktrees/fullstack/` instead of `frontend/`

**Benefits**:
- ✅ Consistent with feature worktree behavior
- ✅ User can work from `fullstack/` directory
- ✅ Claude config visible at workspace root
- ✅ Minimal code changes

**Risks**:
- ⚠️ `frontend/` is the git worktree, not `fullstack/` - user might try to commit from wrong directory
- ⚠️ Need to update documentation to clarify git operations still happen in `frontend/`

### Approach B: Dual Symlinks
**Change**: Place symlinks in BOTH `fullstack/` and `frontend/`

**Benefits**:
- ✅ Works from either directory
- ✅ Maximum flexibility

**Risks**:
- ❌ Redundant symlinks
- ❌ Potential confusion about "which is source of truth"
- ❌ More complex cleanup logic

### Approach C: Workspace-Level Symlink (Advanced)
**Change**: Create `.claude-workspace` directory at `fullstack/` root that contains workspace-specific config, separate from project config

**Benefits**:
- ✅ Separation of concerns (workspace vs project)
- ✅ Could support per-workspace customization

**Risks**:
- ❌ Complex architecture change
- ❌ Requires updates to Claude Code itself
- ❌ Out of scope for this task

---

## 6. Recommended Solution

### Implementation Plan: Approach A (Simple Relocation)

#### Step 1: Update `worktree-init.sh`
**File**: `~/.local/bin/socialaize-worktree/worktree-init.sh`

**Change** (line 145):
```bash
# OLD
"${SCRIPT_DIR}/setup-claude-config.sh" "$FRONTEND_PATH" > /dev/null 2>&1

# NEW
"${SCRIPT_DIR}/setup-claude-config.sh" "$FULLSTACK_WORKSPACE" > /dev/null 2>&1
```

**Context**:
- `FULLSTACK_WORKSPACE="~/socialaize-worktrees/fullstack"`
- `FRONTEND_PATH="~/socialaize-worktrees/fullstack/frontend"`

#### Step 2: Update `worktree-switch.sh`
**File**: `~/.local/bin/socialaize-worktree/worktree-switch.sh`

**Change A** (lines 167-172 - update cleanup logic):
```bash
# OLD
rm -rf "$FRONTEND_PATH/.claude.backup."* "$FRONTEND_PATH/CLAUDE.md.backup."* 2>/dev/null || true
if [ -d "$FRONTEND_PATH/.claude" ] && [ ! -L "$FRONTEND_PATH/.claude" ]; then
  rm -rf "$FRONTEND_PATH/.claude" 2>/dev/null || true
fi

# NEW
rm -rf "$FULLSTACK_WORKSPACE/.claude.backup."* "$FULLSTACK_WORKSPACE/CLAUDE.md.backup."* 2>/dev/null || true
if [ -d "$FULLSTACK_WORKSPACE/.claude" ] && [ ! -L "$FULLSTACK_WORKSPACE/.claude" ]; then
  rm -rf "$FULLSTACK_WORKSPACE/.claude" 2>/dev/null || true
fi
```

**Change B** (line 177 - update symlink creation):
```bash
# OLD
"${SCRIPT_DIR}/setup-claude-config.sh" "$FRONTEND_PATH" > /dev/null 2>&1

# NEW
"${SCRIPT_DIR}/setup-claude-config.sh" "$FULLSTACK_WORKSPACE" > /dev/null 2>&1
```

#### Step 3: Manual Cleanup of Existing Workspace
**Run once** (for existing fullstack workspace):
```bash
cd ~/socialaize-worktrees/fullstack

# Remove existing symlinks from frontend/
rm -f frontend/.claude frontend/CLAUDE.md

# Remove unexpected .claude directory at root
rm -rf .claude

# Create new symlinks at root
ln -s ~/socialaize-config/.claude .claude
ln -s ~/socialaize-config/CLAUDE.md CLAUDE.md

# Verify
ls -la | grep -E "\.claude|CLAUDE"
```

#### Step 4: Update Documentation
**File**: `worktree-init.sh` generated `WORKSPACE_README.md`

**Add section**:
```markdown
## 📁 Workspace Structure

\`\`\`
~/socialaize-worktrees/fullstack/
├── .claude -> ~/socialaize-config/.claude        # Claude config (symlink)
├── CLAUDE.md -> ~/socialaize-config/CLAUDE.md    # Claude instructions (symlink)
├── WORKSPACE_README.md
├── frontend/                                     # Git worktree for frontend
│   ├── .git -> ~/socialaize/.git/worktrees/frontend
│   └── ... (full frontend code)
└── functions/                                    # Sparse function worktrees
    └── ... (27+ functions)
\`\`\`

**Important**: Git operations (commit, push, etc.) must still be done from \`frontend/\` directory,
but Claude configuration is available at workspace root for convenience.
```

---

## 7. Verification Steps

After implementing changes:

### Test 1: New Workspace Creation
```bash
cd ~/socialaize
/wt-full init --force

# Verify symlinks at root
ls -la ~/socialaize-worktrees/fullstack/ | grep -E "\.claude|CLAUDE"
# Expected:
# lrwxr-xr-x .claude -> /Users/natedamstra/socialaize-config/.claude
# lrwxr-xr-x CLAUDE.md -> /Users/natedamstra/socialaize-config/CLAUDE.md

# Verify NO symlinks in frontend/
ls -la ~/socialaize-worktrees/fullstack/frontend/ | grep -E "\.claude|CLAUDE"
# Expected: (no output)
```

### Test 2: Branch Switching
```bash
cd ~/socialaize
/wt-full switch feat-auth

# Verify symlinks still at root
ls -la ~/socialaize-worktrees/fullstack/ | grep -E "\.claude|CLAUDE"
# Expected: symlinks present

# Verify cleanup worked
ls -la ~/socialaize-worktrees/fullstack/ | grep backup
# Expected: (no backup files)
```

### Test 3: Claude Code Session
```bash
cd ~/socialaize-worktrees/fullstack
code .

# In Claude Code:
# - Verify CLAUDE.md is loaded
# - Verify /wt-full commands work
# - Verify skills are available
```

### Test 4: Consistency Check
```bash
# Compare feature worktree structure
ls -la ~/socialaize-worktrees/feat-landing-docs/ | grep -E "\.claude|CLAUDE"
# Compare fullstack structure
ls -la ~/socialaize-worktrees/fullstack/ | grep -E "\.claude|CLAUDE"

# Expected: Both show symlinks at root level
```

---

## 8. Migration Path for Existing Workspaces

For users with existing fullstack workspaces:

### Option A: Recreate Workspace (Recommended)
```bash
cd ~/socialaize
/wt-full init --force
```

### Option B: Manual Migration (No Data Loss)
```bash
cd ~/socialaize-worktrees/fullstack

# 1. Remove old symlinks from frontend/
rm -f frontend/.claude frontend/CLAUDE.md

# 2. Remove unexpected .claude directory at root (if exists)
rm -rf .claude

# 3. Create new symlinks at root
ln -s ~/socialaize-config/.claude .claude
ln -s ~/socialaize-config/CLAUDE.md CLAUDE.md

# 4. Verify
ls -la | grep -E "\.claude|CLAUDE"
```

---

## 9. Potential Side Effects

### Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|-----------|
| User confusion about git operations | Medium | Low | Update documentation clearly |
| Existing scripts/tools expect symlinks in frontend/ | Low | Medium | Audit all worktree scripts |
| `.gitignore` doesn't cover root-level symlinks | Low | Low | Verify .gitignore patterns |
| Backup scripts reference old paths | Low | Low | Update any hardcoded paths |

### Files to Audit for Hardcoded Paths
```bash
grep -r "fullstack/frontend/.claude" ~/.local/bin/socialaize-worktree/
grep -r "fullstack/frontend/CLAUDE" ~/.local/bin/socialaize-worktree/
```

---

## 10. Conclusion

### Summary
The inconsistency exists because:
1. Feature worktrees ARE git worktrees at their root → symlinks at root ✅
2. Fullstack `frontend/` IS git worktree, `fullstack/` is just a container → symlinks currently in frontend/ ⚠️

### Recommendation
**Move symlinks to fullstack root** for:
- Consistent UX across all worktree types
- Better discoverability (workspace root has config)
- Alignment with user expectations

### Implementation Complexity
- **Effort**: Low (2 file changes, ~10 lines of code)
- **Risk**: Low (well-tested, clear verification steps)
- **Testing**: Medium (need to verify init, switch, and existing workflows)

### Next Steps
1. ✅ **Review this analysis** with stakeholders
2. ⏳ **Implement changes** in `worktree-init.sh` and `worktree-switch.sh`
3. ⏳ **Test thoroughly** using verification steps
4. ⏳ **Update documentation** in generated README files
5. ⏳ **Communicate changes** to users (if any exist)

---

**End of Analysis**

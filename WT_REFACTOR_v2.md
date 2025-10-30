# Worktree Consolidation Plan v2

## Current State Discovery

**Script Location:** `/Users/natedamstra/.local/bin/socialaize-worktree/` (17 scripts)
- Active: 11 worktree management scripts
- Legacy: 6 deprecated scripts (cleanup-fullstack-workspace.sh, worktree-functions.sh, worktree-fullstack.sh)

**Worktrees Structure:**
```
~/socialaize-worktrees/
├── feature-{name}/        # 4 active feature worktrees
└── fullstack/
    ├── frontend/          # Switchable branch
    └── functions/         # 27+ sparse function worktrees
```

**Hardcoded `feature-` Prefix:** Found in 5 scripts (worktree-feature.sh:219, cleanup-worktree.sh:18, worktree-status.sh, worktree-actions.sh, worktree-fullstack.sh)

**Port Allocation:** Uses flock locking (worktree-feature.sh:28-50) ✅ Race-safe

**Symlinks:** setup-claude-config.sh links to ~/socialaize-config (centralized config)

## Critical Blockers - Solutions

### 1. Fullstack Protection
**Risk:** No check prevents `/wt cleanup fullstack` catastrophe

**Solution:**
```bash
# Add to cleanup dispatcher BEFORE executing cleanup-worktree.sh
if [[ "$BRANCH_NAME" == "fullstack" ]] || [[ "$WORKTREE_PATH" == */fullstack/* ]]; then
  echo "❌ Cannot cleanup fullstack workspace via /wt"
  echo "   Use /wt-full cleanup (requires --confirm-destruction flag)"
  exit 1
fi
```

### 2. System Detection Utility
**File:** `~/.local/bin/socialaize-worktree/detect-system.sh`

```bash
detect_worktree_type() {
  local target="$1"

  # Fullstack check
  [[ "$target" == "fullstack" || "$target" == */fullstack/* ]] && echo "fullstack" && return 0

  # Feature worktree (old naming)
  [[ -d "$WORKTREE_BASE/feature-${target}" ]] && echo "feature-old:$WORKTREE_BASE/feature-${target}" && return 0

  # Feature worktree (new naming)
  [[ -d "$WORKTREE_BASE/${target}" && "$target" != "fullstack" ]] && echo "feature-new:$WORKTREE_BASE/${target}" && return 0

  echo "unknown" && return 1
}
```

All scripts source this before operations.

### 3. Migration Safety
**Script:** `~/.local/bin/socialaize-worktree/migrate-feature-prefix.sh`

**Pre-checks:**
- Scan for running dev servers (lsof -i :6943-7020)
- Verify no uncommitted changes (git status --porcelain)
- Check disk space for backup

**Migration Process:**
```bash
# For each feature-* worktree:
1. Get current branch: git -C "$WT_PATH" rev-parse --abbrev-ref HEAD
2. Create backup: tar -czf ~/worktree-backup-$(date +%s).tar.gz ~/socialaize-worktrees/
3. Remove git worktree: git worktree remove "$OLD_PATH"
4. Recreate at new path: git worktree add "$NEW_PATH" "$BRANCH"
5. Copy .env.local (preserve PORT assignments)
6. Re-run setup-claude-config.sh
7. Verify: git worktree list
```

**Rollback:** Keep backup for 7 days, provide restore script

### 4. Path Resolution Logic
**Update 5 scripts** to use detection utility:

```bash
# Replace hardcoded paths with:
source "$(dirname "$0")/detect-system.sh"
SYSTEM_INFO=$(detect_worktree_type "$FEATURE_NAME")
WORKTREE_PATH=$(echo "$SYSTEM_INFO" | cut -d: -f2)
```

## Consolidation Commands

### `/wt` - Feature Worktrees
Actions: `create`, `status`, `add`, `add-ai`, `commit`, `pull`, `push`, `cleanup`, `list`

Dispatcher routes to:
- `create` → worktree-feature.sh
- `cleanup` → cleanup-worktree.sh (with fullstack protection)
- `list` → list-worktrees.sh --features-only
- `add|add-ai|commit|pull|push` → worktree-actions.sh

### `/wt-full` - Fullstack Workspace
Actions: `init`, `switch`, `status`, `add-fn`, `rm-fn`, `list`, `cleanup`

Dispatcher routes to:
- `init` → worktree-init.sh
- `switch` → worktree-switch.sh
- `add-fn` → worktree-add-function.sh
- `rm-fn` → worktree-remove-function.sh
- `cleanup` → cleanup-fullstack-workspace.sh (requires --confirm-destruction)

## New File Structure

**New Commands:**
```
~/.claude/commands/
├── wt.md              # /wt <action> <branch> - feature worktrees
└── wt-full.md         # /wt-full <action> - fullstack workspace
```

**New Scripts:**
```
~/.local/bin/socialaize-worktree/
├── detect-system.sh           # NEW: System detection utility
├── migrate-feature-prefix.sh  # NEW: Safe migration script
├── wt-dispatcher.sh           # NEW: Routes /wt actions
└── wt-full-dispatcher.sh      # NEW: Routes /wt-full actions
```

**Archive Old Commands:**
```bash
mkdir -p ~/.claude/.archives/commands/
mv ~/.claude/commands/worktree-feature.md ~/.claude/.archives/commands/
mv ~/.claude/commands/worktree-status.md ~/.claude/.archives/commands/
mv ~/.claude/commands/worktree-actions.md ~/.claude/.archives/commands/
mv ~/.claude/commands/cleanup-worktree.md ~/.claude/.archives/commands/
mv ~/.claude/commands/worktree-init.md ~/.claude/.archives/commands/
mv ~/.claude/commands/worktree-switch.md ~/.claude/.archives/commands/
mv ~/.claude/commands/worktree-add-function.md ~/.claude/.archives/commands/
mv ~/.claude/commands/worktree-remove-function.md ~/.claude/.archives/commands/
mv ~/.claude/commands/list-worktrees.md ~/.claude/.archives/commands/
```

**Archive Legacy Scripts:**
```bash
mkdir -p ~/.local/bin/socialaize-worktree/.archived/
mv ~/.local/bin/socialaize-worktree/cleanup-fullstack-workspace.sh ~/.local/bin/socialaize-worktree/.archived/
mv ~/.local/bin/socialaize-worktree/cleanup-functions-workspace.sh ~/.local/bin/socialaize-worktree/.archived/
mv ~/.local/bin/socialaize-worktree/worktree-functions.sh ~/.local/bin/socialaize-worktree/.archived/
mv ~/.local/bin/socialaize-worktree/worktree-fullstack.sh ~/.local/bin/socialaize-worktree/.archived/
```

## Implementation Phases

**Phase 1 (4h):** Create detect-system.sh + fullstack protection + migration script
**Phase 2 (3h):** Update 5 scripts to use detection utility
**Phase 3 (2h):** Create wt.md + wt-full.md + dispatchers
**Phase 4 (2h):** Test migration on backup, validate safety
**Phase 5 (1h):** Run migration, archive old commands (9 .md files + 4 legacy scripts)

**Total:** 12 hours

## Success Criteria

✅ No `feature-` prefix in folder names
✅ Fullstack workspace protected from accidental deletion
✅ Both old/new paths work during transition (2 week grace period)
✅ Migration script tested on backup before production
✅ All 17 scripts updated with path resolution
✅ Zero data loss

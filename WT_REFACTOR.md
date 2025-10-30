# Worktree Command Consolidation Plan

## Current State

**7 Commands** managing two distinct worktree systems:
1. **Feature worktrees** (`~/socialaize-worktrees/feature-*`) - individual feature branches with dev servers
2. **Fullstack workspace** (`~/socialaize-worktrees/fullstack/`) - permanent workspace with frontend + all functions

**Commands:**
- `worktree-feature` - Create feature branch worktree
- `worktree-status` - Show feature worktree status
- `worktree-actions` - Git operations on feature worktree
- `cleanup-worktree` - Remove feature worktree
- `worktree-init` - Initialize fullstack workspace
- `worktree-switch` - Switch frontend branch in fullstack
- `worktree-add-function` - Add function to fullstack
- `worktree-remove-function` - Remove function from fullstack
- `list-worktrees` - Show all worktrees

## Consolidation Strategy

### Command 1: `/wt` - Feature Branch Management

**Signature:** `/wt <action> <branch-name> [...args]`

**Actions:**
- `create <branch>` - Create new feature worktree (replaces `worktree-feature`)
- `use <branch>` - Switch to existing feature worktree
- `status <branch>` - Show worktree status (replaces `worktree-status`)
- `add <branch>` - Stage changes (replaces `worktree-actions add`)
- `add-ai <branch>` - AI-assisted staging (replaces `worktree-actions add-ai`)
- `commit <branch>` - Show staged changes (replaces `worktree-actions commit`)
- `pull <branch>` - Pull from remote (replaces `worktree-actions pull`)
- `push <branch>` - Push to remote (replaces `worktree-actions push`)
- `cleanup <branch>` - Remove worktree (replaces `cleanup-worktree`)
- `list` - Show all feature worktrees (replaces `list-worktrees` partially)

**Key Changes:**
- ❌ Remove `feature-` prefix from folder names
- ✅ Use branch name directly: `~/socialaize-worktrees/<branch>/`
- ✅ Consolidate all feature worktree actions into single command
- ✅ Shorter syntax: `/wt create auth` instead of `/worktree-feature auth`

**Examples:**
```bash
# Old way
/worktree-feature user-auth --port 7000
/worktree-status user-auth
/worktree-actions user-auth add-ai
/worktree-actions user-auth commit
/worktree-actions user-auth push
/cleanup-worktree user-auth

# New way
/wt create user-auth --port 7000
/wt status user-auth
/wt add-ai user-auth
/wt commit user-auth
/wt push user-auth
/wt cleanup user-auth
```

### Command 2: `/wt-full` - Fullstack Workspace Management

**Signature:** `/wt-full <action> [...args]`

**Actions:**
- `init` - Initialize fullstack workspace (replaces `worktree-init`)
- `switch <branch>` - Switch frontend branch (replaces `worktree-switch`)
- `status` - Show workspace status
- `add-fn <FunctionName>` - Add function worktree (replaces `worktree-add-function`)
- `rm-fn <FunctionName>` - Remove function worktree (replaces `worktree-remove-function`)
- `list` - Show fullstack workspace details
- `cleanup` - Remove entire fullstack workspace

**Key Changes:**
- ✅ Balanced naming: `wt-full` (consistent with `/wt`)
- ✅ All fullstack operations centralized
- ✅ Consistent action naming pattern

**Examples:**
```bash
# Old way
/worktree-init --frontend main --port 6942
/worktree-switch feat-auth
/worktree-add-function EmailHandler
/worktree-remove-function OldFunction

# New way
/wt-full init --frontend main --port 6942
/wt-full switch feat-auth
/wt-full add-fn EmailHandler
/wt-full rm-fn OldFunction
```

## Implementation Plan

### Phase 0: Standardize Script Naming (30 min)
**Create archive directory:**
```bash
mkdir -p ~/.claude/.archives/commands/
```

**Rename scripts for consistency:**
```bash
cd ~/.local/bin/socialaize-worktree/
mv cleanup-worktree.sh worktree-cleanup.sh
mv list-worktrees.sh worktree-list.sh
```

**Rationale:** Consistent `worktree-*.sh` naming pattern makes maintenance easier.

**Script Compatibility Check:**
- Review each script to ensure it handles both feature and fullstack worktrees correctly
- Feature worktrees: `~/socialaize-worktrees/<branch>/`
- Fullstack workspace: `~/socialaize-worktrees/fullstack/`
- Scripts may need updates to differentiate between the two systems

### Phase 1: Create Core Infrastructure (4-6 hours)
1. **Create `/wt.md` + `/wt-full.md`** commands
   - Argument parsing for action + args
   - Help system with decision guide

2. **Create dispatcher scripts** with explicit routing:
   ```bash
   # wt-dispatcher.sh - Consistent worktree-*.sh routing
   case "$action" in
     create) exec worktree-feature.sh "$@" ;;
     status) exec worktree-status.sh "$@" ;;
     cleanup) exec worktree-cleanup.sh "$@" ;;  # Renamed
     list) exec worktree-list.sh "$@" ;;        # Renamed
     add|add-ai|commit|pull|push) exec worktree-actions.sh "$action" "$@" ;;
     help) show_help ;;
     *) error "Unknown action: $action" ;;
   esac
   ```

3. **Create `migrate-worktrees.sh`** (2 hours)
   - Detect `feature-*` prefix folders
   - Rename preserving git worktree state
   - Update `.env.local` paths
   - Idempotent (safe to run multiple times)

4. **Create shared utilities**
   ```bash
   shared/
   ├── port-manager.sh      # Extract from worktree-feature.sh
   └── validation.sh        # Shared validation logic
   ```

### Phase 2: Update & Validate Scripts (3-4 hours)
1. **Review script compatibility with both systems:**
   - `worktree-feature.sh` - Feature worktrees only
   - `worktree-status.sh` - Should work for both?
   - `worktree-cleanup.sh` - Needs to handle both systems
   - `worktree-list.sh` - Must show both feature + fullstack
   - `worktree-actions.sh` - Feature worktrees only
   - `worktree-init.sh` - Fullstack only
   - `worktree-switch.sh` - Fullstack only (switches frontend branch)
   - `worktree-add-function.sh` - Fullstack only
   - `worktree-remove-function.sh` - Fullstack only

2. **Update scripts as needed:**
   - **`worktree-feature.sh`**: Remove `feature-` prefix, use branch name directly
   - **`worktree-list.sh`**: Display both feature worktrees AND fullstack workspace
   - **`worktree-cleanup.sh`**: Handle cleanup for both systems (don't touch fullstack)
   - **`worktree-status.sh`**: Detect if in feature vs fullstack worktree, show appropriate info

3. **Add help actions:**
   - `/wt help` - Decision guide (feature vs fullstack)
   - `/wt <action> --help` - Action-specific help

### Phase 3: Testing (2 hours)
**Formal test suite:**
```bash
tests/
├── test-dispatcher-routing.sh   # All actions route correctly
├── test-concurrent-creation.sh  # Port allocation race conditions
├── test-migration.sh            # Old → new folder migration
└── test-argument-passing.sh     # Flags pass through correctly
```

### Phase 4: Deprecate Old Commands (Week 2-3)
1. **Old commands redirect to dispatchers**
   ```bash
   # Example: worktree-feature.md calls dispatcher
   ~/.local/bin/socialaize-worktree/wt-dispatcher.sh create "$@"
   ```

2. **Add deprecation warnings**
   - Show conversion command
   - Suggest migration script for old folders

3. **Update documentation**
   - WORKSPACE_README.md references
   - WORKTREE_README.md references

### Phase 5: Cleanup (Week 4)
1. **Move deprecated commands to archive:**
   ```bash
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

2. **Keep all scripts** (dispatchers route to them)

3. Final migration reminder and announcement

## File Structure

### New Commands
```
~/.claude/commands/
├── wt.md                          # Feature worktree unified command
└── wt-full.md                     # Fullstack workspace unified command

~/.local/bin/socialaize-worktree/
├── wt-dispatcher.sh               # NEW: Routes /wt actions
├── wt-full-dispatcher.sh          # NEW: Routes /wt-full actions
├── migrate-worktrees.sh           # NEW: Migrate feature-* → branch-name folders
├── shared/
│   ├── port-manager.sh           # NEW: Extracted port allocation
│   └── validation.sh             # NEW: Shared validation
├── tests/
│   ├── test-dispatcher-routing.sh
│   ├── test-concurrent-creation.sh
│   ├── test-migration.sh
│   ├── test-argument-passing.sh
│   └── test-dual-system.sh       # NEW: Test feature + fullstack coexistence
├── worktree-feature.sh            # UPDATED: No feature- prefix, detects system type
├── worktree-status.sh             # UPDATED: Works for both feature + fullstack
├── worktree-actions.sh            # Feature worktrees only
├── worktree-cleanup.sh            # RENAMED + UPDATED: Handles both systems safely
├── worktree-list.sh               # RENAMED + UPDATED: Shows feature + fullstack
├── worktree-init.sh               # Fullstack only
├── worktree-switch.sh             # Fullstack only
├── worktree-add-function.sh       # Fullstack only
└── worktree-remove-function.sh    # Fullstack only
```

### Deprecated Commands (moved to .archives/)
```
~/.claude/.archives/commands/
├── worktree-feature.md
├── worktree-status.md
├── worktree-actions.md
├── cleanup-worktree.md
├── worktree-init.md
├── worktree-switch.md
├── worktree-add-function.md
├── worktree-remove-function.md
└── list-worktrees.md
```

## Benefits

### User Experience
- ✅ **Simpler mental model** - Two clear commands: `/wt` for features, `/wt-full` for fullstack
- ✅ **Shorter syntax** - Less typing, autocomplete-friendly
- ✅ **Cleaner folders** - No `feature-` prefix pollution
- ✅ **Help system** - `/wt help` provides decision guide
- ✅ **Balanced naming** - `/wt` and `/wt-full` (consistent pattern)

### Maintainability
- ✅ **Centralized routing** - Explicit case statements (not string interpolation)
- ✅ **Easier testing** - Formal test suite catches regressions
- ✅ **Shared utilities** - Port allocation, validation extracted
- ✅ **Clear separation** - Feature vs fullstack concerns isolated
- ✅ **Future extensibility** - Add new actions without new files

### Migration Path
- ✅ **Automatic migration** - `migrate-worktrees.sh` handles folder renames
- ✅ **Graceful transition** - Old commands redirect to dispatchers
- ✅ **Zero breaking changes** - Old structure detected and migrated
- ✅ **Clear guidance** - Deprecation warnings show exact new syntax

## Action Mapping Reference

### Feature Worktrees (`/wt`)
| Old Command | New Command |
|-------------|-------------|
| `/worktree-feature <name>` | `/wt create <name>` |
| `/worktree-status <name>` | `/wt status <name>` |
| `/worktree-actions <name> pull` | `/wt pull <name>` |
| `/worktree-actions <name> add` | `/wt add <name>` |
| `/worktree-actions <name> add-ai` | `/wt add-ai <name>` |
| `/worktree-actions <name> commit` | `/wt commit <name>` |
| `/worktree-actions <name> push` | `/wt push <name>` |
| `/cleanup-worktree <name>` | `/wt cleanup <name>` |
| `/list-worktrees` | `/wt list` |

### Fullstack Workspace (`/wt-full`)
| Old Command | New Command |
|-------------|-------------|
| `/worktree-init` | `/wt-full init` |
| `/worktree-switch <branch>` | `/wt-full switch <branch>` |
| `/worktree-add-function <name>` | `/wt-full add-fn <name>` |
| `/worktree-remove-function <name>` | `/wt-full rm-fn <name>` |
| `/list-worktrees` | `/wt-full list` |

## Implementation Notes

### Dispatcher Pattern - Consistent worktree-*.sh Naming
**All scripts renamed to `worktree-*.sh` pattern for consistency:**

```bash
# wt-dispatcher.sh - Routes to renamed scripts
case "$action" in
  create) exec "$(dirname "$0")/worktree-feature.sh" "$@" ;;
  status) exec "$(dirname "$0")/worktree-status.sh" "$@" ;;
  cleanup) exec "$(dirname "$0")/worktree-cleanup.sh" "$@" ;;
  list) exec "$(dirname "$0")/worktree-list.sh" "$@" ;;
  add|add-ai|commit|pull|push) exec "$(dirname "$0")/worktree-actions.sh" "$action" "$@" ;;
  help) show_help ;;
  *) echo "Unknown action: $action" >&2; exit 1 ;;
esac
```

**Benefits of consistent naming:**
- Easier to find all worktree-related scripts
- Pattern-based operations (`ls worktree-*.sh`)
- Clearer script organization

### Migration Script Requirements
**`migrate-worktrees.sh` must:**
1. Detect `feature-*` prefix in `~/socialaize-worktrees/`
2. Rename directories preserving git worktree state
3. Update `.env.local` PORT references
4. Be idempotent (safe to run multiple times)
5. Create backup before changes
6. Provide rollback option

### Testing Strategy - Formal Suite Required
```bash
# tests/test-dispatcher-routing.sh
- All actions route to correct scripts
- Invalid actions show helpful error
- Help action works

# tests/test-concurrent-creation.sh
- Simultaneous /wt create doesn't assign same port
- Lock file mechanism works

# tests/test-migration.sh
- feature-* folders rename correctly
- .env.local paths update
- Git worktree state preserved

# tests/test-argument-passing.sh
- --port flag reaches script
- --existing-branch flag works
- Multiple args pass through

# tests/test-dual-system.sh (NEW - IMPORTANT)
- Feature worktrees and fullstack workspace coexist
- /wt list shows both systems correctly
- /wt cleanup doesn't touch fullstack workspace
- /wt status works in both feature and fullstack contexts
- Scripts correctly identify which system they're operating on
```

### Script Compatibility Requirements
**Critical:** Scripts must handle two distinct systems:

1. **Feature Worktrees** (`~/socialaize-worktrees/<branch>/`)
   - Temporary, isolated development
   - Each has own dev server port
   - Can be cleaned up independently

2. **Fullstack Workspace** (`~/socialaize-worktrees/fullstack/`)
   - Permanent workspace
   - Contains frontend + all function worktrees
   - Should NEVER be cleaned up by feature worktree commands

**Detection Logic Needed:**
```bash
# Scripts should detect which system they're in
if [[ "$WORKTREE_PATH" == */fullstack/* ]]; then
  # Fullstack system behavior
else
  # Feature worktree behavior
fi
```

## Timeline (Revised - 3-4 Weeks)

**Week 1: Core Implementation (10-12 hours)**
- Phase 0: Rename scripts + create archives (30 min)
- Phase 1: Create infrastructure (4-6 hours)
  - Dispatchers with explicit routing
  - Migration script
  - Help system
  - Shared utilities
- Phase 2: Update & validate scripts (3-4 hours)
  - Review each script for dual-system compatibility
  - Update feature.sh, list.sh, cleanup.sh, status.sh
  - Add detection logic for feature vs fullstack
- Phase 3: Testing (2-3 hours)
  - All 5 test suites including dual-system tests

**Week 2: Migration & Testing**
- Run migration script on existing worktrees
- User testing with both old/new commands
- Fix issues, iterate

**Week 3-4: Deprecation Period**
- Old commands show warnings
- Monitor usage patterns
- Update all documentation

**Week 4-5: Cleanup**
- Remove old command files
- Archive deprecated scripts
- Final announcement

## Success Metrics

✅ **All existing functionality preserved** - No regressions
✅ **Reduced command count** - From 7+ to 2 (`/wt`, `/wt-full`)
✅ **Cleaner folder structure** - No `feature-` prefix pollution
✅ **Migration successful** - All existing worktrees migrated automatically
✅ **Tests pass** - All 4 test suites (routing, concurrency, migration, args)
✅ **Help system works** - `/wt help` provides clear decision guide
✅ **Zero data loss** - Existing worktrees continue working
✅ **No breaking changes** - Old commands redirect seamlessly

## Critical Success Factors (Must Have)

🔴 **MUST rename scripts** for consistency (`worktree-*.sh` pattern)
🔴 **MUST validate dual-system compatibility** (feature + fullstack coexistence)
🔴 **MUST create migration script** (existing worktrees will break without it)
🔴 **MUST test concurrency** (port allocation race conditions)
🔴 **MUST add detection logic** (scripts identify feature vs fullstack context)
🔴 **MUST add help system** (`/wt help` decision guide)
🔴 **MUST archive old commands** to `~/.claude/.archives/commands/`

## Risk Assessment

### ✅ LOW RISK (with proper validation)
- Script renaming is straightforward (2 files)
- Migration script tested on real worktrees
- Explicit routing with consistent naming
- Old commands redirect to dispatchers (no breaking changes)

### ⚠️ MEDIUM RISK (manageable with testing)
- **Dual-system compatibility** → Scripts must detect context correctly
- **Feature vs fullstack conflicts** → Test cleanup doesn't touch fullstack
- User confusion during transition → Mitigate with clear warnings
- Documentation updates needed → Automated search/replace
- `.archives/` directory creation → Phase 0 setup

### ❌ HIGH RISK (original plan - FIXED)
- ~~Dispatcher breaks on naming mismatch~~ → FIXED: Route to existing names
- ~~No migration path~~ → FIXED: migrate-worktrees.sh
- ~~10-week timeline too long~~ → FIXED: 3-4 weeks

## Verdict

**Rating: 9/10** (with critical fixes implemented)

**GO with conditions:**
1. ✅ Rename scripts to consistent `worktree-*.sh` pattern (Phase 0)
2. ✅ Validate dual-system compatibility (Phase 2 - CRITICAL)
3. ✅ Add detection logic to scripts (feature vs fullstack context)
4. ✅ Create migration script in Phase 1
5. ✅ Add help system with decision guide
6. ✅ Create formal test suite (5 test files including dual-system)
7. ✅ Archive old commands to `.archives/`

**Time Investment:** 10-12 hours core implementation + 2-3 weeks rollout
**Risk Reduction:** Dual-system testing prevents cleanup disasters!

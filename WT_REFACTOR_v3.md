# Worktree System Consolidation - Master Plan v3

## Executive Summary

**Goal:** Consolidate 9 worktree commands into 2 unified commands (`/wt` and `/wt-full`), remove `feature-` prefix from folder names, add critical safety protections, and streamline the developer experience.

**Current State:**
- 15 shell scripts (3,163 lines total)
- 9 command files
- 4 active feature worktrees with `feature-` prefix
- 1 fullstack workspace with 27 function worktrees
- Hardcoded paths in 4 scripts
- No fullstack protection in cleanup
- Missing rollback implementation

**Target State:**
- 2 unified commands with dispatcher pattern
- Clean folder names (`~/socialaize-worktrees/{branch}/`)
- Fullstack protection preventing accidental deletion
- Backwards compatibility during migration
- All functionality preserved
- Full rollback capability with migration log
- Symlink validation post-migration

---

## Part 1: Current System Analysis

### Scripts Inventory (15 files, 3,163 lines)

**Active Feature Scripts (4):**
1. `worktree-feature.sh` (466 lines) - Creates feature worktrees
2. `worktree-status.sh` (126 lines) - Shows worktree status
3. `worktree-actions.sh` (105 lines) - Git operations (pull/add/commit/push)
4. `cleanup-worktree.sh` (104 lines) - Removes feature worktrees with safety checks

**Active Fullstack Scripts (5):**
5. `worktree-init.sh` (412 lines) - Initializes fullstack workspace
6. `worktree-switch.sh` (211 lines) - Switches frontend branch
7. `worktree-add-function.sh` (93 lines) - Adds function worktree
8. `worktree-remove-function.sh` (100 lines) - Removes function worktree
9. `list-worktrees.sh` (168 lines) - Lists all worktrees

**Shared Utilities (2):**
10. `setup-claude-config.sh` (91 lines) - Creates symlinks to ~/socialaize-config
11. `sparse-checkout-helpers.sh` (157 lines) - Sparse checkout utilities for functions

**Legacy/Deprecated (4):**
12. `cleanup-fullstack-workspace.sh` (124 lines)
13. `cleanup-functions-workspace.sh` (92 lines)
14. `worktree-fullstack.sh` (500 lines)
15. `worktree-functions.sh` (414 lines)

### Command Files (9)

1. `worktree-feature.md` → `worktree-feature.sh`
2. `worktree-status.md` → `worktree-status.sh`
3. `worktree-actions.md` → `worktree-actions.sh`
4. `cleanup-worktree.md` → `cleanup-worktree.sh`
5. `worktree-init.md` → `worktree-init.sh`
6. `worktree-switch.md` → `worktree-switch.sh`
7. `worktree-add-function.md` → `worktree-add-function.sh`
8. `worktree-remove-function.md` → `worktree-remove-function.sh`
9. `list-worktrees.md` → `list-worktrees.sh`

### Hardcoded Path Locations

**Scripts with `feature-` prefix:**
- `worktree-feature.sh:219` - `WORKTREE_DIR="$WORKTREE_BASE/feature-${FEATURE_NAME}"`
- `cleanup-worktree.sh:18` - `WORKTREE_DIR="$HOME/socialaize-worktrees/feature-${FEATURE_NAME}"`
- `worktree-actions.sh:22` - `WORKTREE_DIR="$HOME/socialaize-worktrees/feature-${FEATURE_NAME}"`
- `worktree-status.sh:12` - `WORKTREE_DIR="$HOME/socialaize-worktrees/feature-${FEATURE_NAME}"`
- `list-worktrees.sh` - Pattern matching for `feature-*` directories

### Key Features to Preserve

**Port Allocation (worktree-feature.sh:28-91):**
- Uses flock for race-condition safety
- Scans .env.local files in all worktrees
- Range: 6943-7020
- Fallback to nc/lsof for port checking
- ✅ Already safe, no changes needed

**Cleanup Safety Checks (cleanup-worktree.sh:33-88):**
- Uncommitted changes detection
- Unpushed commits detection
- Merge status checking
- Open PR detection via gh CLI
- ✅ Preserve all checks

**Sparse Checkout (sparse-checkout-helpers.sh):**
- Creates function worktrees with only `functions/FunctionName/`
- ~99% storage savings
- ✅ Keep unchanged

**Claude Config Symlinks (setup-claude-config.sh):**
- Links CLAUDE.md and .claude/ to ~/socialaize-config
- Preserves existing files as backups
- ✅ Keep unchanged

---

## Part 2: New Consolidated System

### Command Structure

**`/wt` - Feature Worktree Management**

```
/wt <action> [branch-name] [options]
```

**Actions:**
- `create <branch> [--existing-branch <name>] [--port <port>]` - Create feature worktree
- `status <branch>` - Show worktree status
- `pull <branch>` - Pull latest changes
- `add <branch>` - Stage all changes
- `add-ai <branch>` - AI-assisted staging
- `commit <branch>` - Show staged changes (prompt for message)
- `push <branch>` - Push to remote
- `cleanup <branch> [--force]` - Remove worktree
- `list` - List all feature worktrees
- `help` - Show usage guide

**`/wt-full` - Fullstack Workspace Management**

```
/wt-full <action> [options]
```

**Actions:**
- `init [--frontend <branch>] [--port <port>] [--force]` - Initialize workspace
- `switch <branch> [--port <port>]` - Switch frontend branch
- `status` - Show workspace status
- `add-fn <name>` - Add function worktree
- `rm-fn <name>` - Remove function worktree
- `list` - Show fullstack workspace details
- `help` - Show usage guide

### File Structure After Consolidation

```
~/.claude/commands/
├── wt.md                              # NEW: Unified feature command
└── wt-full.md                         # NEW: Unified fullstack command

~/.local/bin/socialaize-worktree/
├── wt-dispatcher.sh                   # NEW: Routes /wt actions
├── wt-full-dispatcher.sh              # NEW: Routes /wt-full actions
├── detect-worktree-type.sh            # NEW: System detection utility
├── migrate-feature-prefix.sh          # NEW: Migration script
├── shared/
│   ├── common-functions.sh            # NEW: Shared logging & validation
│   └── port-manager.sh                # NEW: Extracted port allocation
├── worktree-feature.sh                # UPDATED: Remove prefix, use detection
├── worktree-status.sh                 # UPDATED: Use detection utility
├── worktree-actions.sh                # UPDATED: Use detection utility
├── cleanup-worktree.sh                # UPDATED: Add fullstack protection
├── list-worktrees.sh                  # UPDATED: Show both systems clearly
├── worktree-init.sh                   # KEEP: Fullstack init
├── worktree-switch.sh                 # KEEP: Fullstack switch
├── worktree-add-function.sh           # KEEP: Add function
├── worktree-remove-function.sh        # KEEP: Remove function
├── setup-claude-config.sh             # KEEP: Unchanged
├── sparse-checkout-helpers.sh         # KEEP: Unchanged
└── .archived/
    ├── cleanup-fullstack-workspace.sh # MOVED: Legacy
    ├── cleanup-functions-workspace.sh # MOVED: Legacy
    ├── worktree-fullstack.sh          # MOVED: Legacy
    └── worktree-functions.sh          # MOVED: Legacy

~/.claude/.archives/commands/
├── worktree-feature.md                # MOVED: Old command
├── worktree-status.md                 # MOVED: Old command
├── worktree-actions.md                # MOVED: Old command
├── cleanup-worktree.md                # MOVED: Old command
├── worktree-init.md                   # MOVED: Old command
├── worktree-switch.md                 # MOVED: Old command
├── worktree-add-function.md           # MOVED: Old command
├── worktree-remove-function.md        # MOVED: Old command
└── list-worktrees.md                  # MOVED: Old command
```

---

## Part 3: New Script Implementations

### 1. Shared Common Functions (`shared/common-functions.sh`)

**Purpose:** Extract duplicated logging and validation across all scripts

```bash
#!/usr/bin/env bash

# Logging functions
log_info() { echo "ℹ️  $*"; }
log_success() { echo "✅ $*"; }
log_error() { echo "❌ Error: $*" >&2; }
log_warn() { echo "⚠️  Warning: $*"; }

# Validation
validate_git_repo() {
  git rev-parse --git-dir >/dev/null 2>&1 || {
    log_error "Not in a git repository"
    return 1
  }
}

validate_branch_name() {
  local branch="$1"
  [[ "$branch" =~ ^[a-zA-Z0-9/_-]+$ ]] || {
    log_error "Invalid branch name format"
    return 1
  }
}

# Configuration
export WORKTREE_BASE="${WORKTREE_BASE:-$HOME/socialaize-worktrees}"
export FULLSTACK_WORKSPACE="${FULLSTACK_WORKSPACE:-$WORKTREE_BASE/fullstack}"
```

**Changes Required:**
- Create new file
- Source this in all scripts
- Replace duplicate log functions

### 2. Port Manager (`shared/port-manager.sh`)

**Purpose:** Extract port allocation logic from worktree-feature.sh

```bash
#!/usr/bin/env bash

# Port configuration
PORT_MIN=6943
PORT_MAX=7020
LOCK_FILE="/tmp/socialaize-worktree-port.lock"

# Get next available port (RACE-CONDITION SAFE)
get_next_port() {
  (
    if command -v flock >/dev/null 2>&1; then
      flock -n 200 || {
        log_error "Another worktree is being created. Please wait and retry."
        return 1
      }
    else
      local lock_dir="/tmp/socialaize-worktree.lock"
      trap 'rmdir "$lock_dir" 2>/dev/null' EXIT RETURN
      mkdir "$lock_dir" 2>/dev/null || {
        log_error "Another worktree is being created. Please wait and retry."
        exit 1
      }
    fi

    # Scan existing .env.local files for used ports
    local used_ports=()
    while IFS= read -r line; do
      if [[ "$line" =~ ^worktree[[:space:]](.+)$ ]]; then
        local wt_path="${BASH_REMATCH[1]}"
        if [[ -f "$wt_path/.env.local" ]]; then
          local port=$(grep -E "^PORT=" "$wt_path/.env.local" 2>/dev/null | cut -d= -f2 | tr -d ' ')
          [[ -n "$port" ]] && used_ports+=("$port")
        fi
      fi
    done < <(git worktree list --porcelain)

    # Find first available port
    for port in $(seq $PORT_MIN $PORT_MAX); do
      if [[ ${#used_ports[@]} -gt 0 ]] && printf '%s\n' "${used_ports[@]}" | grep -q -w "$port"; then
        continue
      fi

      # Check if port is in use
      if command -v nc >/dev/null 2>&1; then
        nc -z localhost "$port" 2>/dev/null && continue
      elif command -v lsof >/dev/null 2>&1; then
        lsof -Pi ":$port" -sTCP:LISTEN -t >/dev/null 2>&1 && continue
      fi

      echo "$port"
      return 0
    done

    log_error "No available ports in range $PORT_MIN-$PORT_MAX"
    return 1
  ) 200>"$LOCK_FILE"
}

# Validate custom port
validate_port() {
  local port="$1"
  [[ ! "$port" =~ ^[0-9]+$ ]] && {
    log_error "Port must be a number"
    return 1
  }

  [[ "$port" -lt 3000 || "$port" -gt 9999 ]] && {
    log_error "Port must be between 3000-9999"
    return 1
  }

  # Check if port is in use
  if command -v nc >/dev/null 2>&1; then
    nc -z localhost "$port" 2>/dev/null && {
      log_error "Port $port is already in use"
      return 1
    }
  elif command -v lsof >/dev/null 2>&1; then
    lsof -Pi ":$port" -sTCP:LISTEN -t >/dev/null 2>&1 && {
      log_error "Port $port is already in use"
      return 1
    }
  fi
  return 0
}
```

**Changes Required:**
- Extract from worktree-feature.sh:28-91
- Create new shared file
- Update worktree-feature.sh to source this

### 3. System Detection Utility (`detect-worktree-type.sh`)

**Purpose:** Centralize logic for detecting feature vs fullstack worktrees

```bash
#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/shared/common-functions.sh"

# Detect worktree type: feature, fullstack, or unknown
# Returns: "feature:old:PATH", "feature:new:PATH", "fullstack", or "unknown"
detect_worktree_type() {
  local target="${1:-}"

  [[ -z "$target" ]] && {
    echo "unknown"
    return 1
  }

  # Check 1: Is it the fullstack workspace?
  if [[ "$target" == "fullstack" ]] || [[ "$target" == */fullstack || "$target" == */fullstack/* ]]; then
    # Additional validation: check for frontend/ and functions/ subdirs
    if [[ -d "$FULLSTACK_WORKSPACE/frontend" ]] || [[ -d "$FULLSTACK_WORKSPACE/functions" ]]; then
      echo "fullstack"
      return 0
    fi
  fi

  # Check 2: Feature worktree (OLD naming with feature- prefix)
  local feature_old="$WORKTREE_BASE/feature-${target}"
  if [[ -d "$feature_old" ]]; then
    echo "feature:old:$feature_old"
    return 0
  fi

  # Check 3: Feature worktree (NEW naming without prefix)
  local feature_new="$WORKTREE_BASE/${target}"
  if [[ -d "$feature_new" ]] && [[ "$target" != "fullstack" ]]; then
    # Validate it's NOT a fullstack subdirectory
    if [[ "$feature_new" != */fullstack/* ]]; then
      echo "feature:new:$feature_new"
      return 0
    fi
  fi

  # Check 4: Provided as full path
  if [[ -d "$target" ]]; then
    # Check if it's inside fullstack/
    if [[ "$target" == */fullstack/* ]]; then
      echo "fullstack"
      return 0
    # Check if it's a feature worktree
    elif [[ "$target" == "$WORKTREE_BASE"/feature-* ]]; then
      echo "feature:old:$target"
      return 0
    elif [[ "$target" == "$WORKTREE_BASE"/* ]] && [[ "$target" != "$FULLSTACK_WORKSPACE" ]]; then
      echo "feature:new:$target"
      return 0
    fi
  fi

  echo "unknown"
  return 1
}

# Get worktree path from detection result
get_worktree_path() {
  local detection="$1"
  case "$detection" in
    feature:old:*|feature:new:*)
      echo "$detection" | cut -d: -f3
      ;;
    fullstack)
      echo "$FULLSTACK_WORKSPACE"
      ;;
    *)
      return 1
      ;;
  esac
}

# Main execution when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  detect_worktree_type "$@"
fi
```

**Changes Required:**
- Create new file
- Update all scripts to use this instead of hardcoded paths

### 4. Feature Worktree Dispatcher (`wt-dispatcher.sh`)

**Purpose:** Route `/wt` actions to appropriate scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/shared/common-functions.sh"
source "${SCRIPT_DIR}/detect-worktree-type.sh"

# Show help
show_help() {
  cat <<EOF
Usage: /wt <action> [branch-name] [options]

FEATURE WORKTREE ACTIONS:
  create <branch> [options]   Create new feature worktree
    --existing-branch <name>  Use existing branch
    --port <port>             Custom port (default: auto-assigned)
    --type <type>             frontend|backend|fullstack (default: fullstack)

  status <branch>             Show worktree status
  pull <branch>               Pull latest changes
  add <branch>                Stage all changes
  add-ai <branch>             AI-assisted staging
  commit <branch>             Show staged changes (ready to commit)
  push <branch>               Push to remote
  cleanup <branch> [--force]  Remove worktree (with safety checks)
  list                        List all feature worktrees
  help                        Show this help

EXAMPLES:
  /wt create user-auth --existing-branch feat-auth
  /wt status user-auth
  /wt add-ai user-auth
  /wt commit user-auth
  /wt push user-auth
  /wt cleanup user-auth

SAFETY FEATURES:
  • Fullstack workspace protection (cannot cleanup via /wt)
  • Uncommitted changes detection
  • Unpushed commits detection
  • Port conflict prevention
  • Race-condition safe port allocation

For fullstack workspace management, use: /wt-full help
EOF
}

# Parse arguments
ACTION="${1:-}"
shift || true

# Show help if no action
[[ -z "$ACTION" ]] && {
  show_help
  exit 0
}

# Handle help
[[ "$ACTION" == "help" || "$ACTION" == "--help" || "$ACTION" == "-h" ]] && {
  show_help
  exit 0
}

# Handle list (no branch name needed)
if [[ "$ACTION" == "list" ]]; then
  exec "${SCRIPT_DIR}/list-worktrees.sh" --features-only
fi

# All other actions need a branch name
BRANCH_NAME="${1:-}"
shift || true

[[ -z "$BRANCH_NAME" ]] && {
  log_error "Branch name required for action: $ACTION"
  echo "Usage: /wt $ACTION <branch-name>"
  exit 1
}

# CRITICAL: Fullstack protection
detection=$(detect_worktree_type "$BRANCH_NAME" 2>/dev/null || echo "unknown")
if [[ "$detection" == "fullstack" ]]; then
  log_error "Cannot perform feature worktree operations on fullstack workspace"
  echo ""
  echo "Fullstack workspace detected. Use these commands instead:"
  echo "  /wt-full status        - Show workspace status"
  echo "  /wt-full switch <branch> - Switch frontend branch"
  echo "  /wt-full help          - Show fullstack commands"
  exit 1
fi

# Additional check: prevent cleanup of fullstack even if detection fails
if [[ "$ACTION" == "cleanup" ]] && [[ "$BRANCH_NAME" == "fullstack" ]]; then
  log_error "Cannot cleanup fullstack workspace via /wt"
  echo "Use: /wt-full help (for fullstack management)"
  exit 1
fi

# Route actions to scripts
case "$ACTION" in
  create)
    exec "${SCRIPT_DIR}/worktree-feature.sh" "$BRANCH_NAME" "$@"
    ;;

  status)
    exec "${SCRIPT_DIR}/worktree-status.sh" "$BRANCH_NAME" "$@"
    ;;

  pull|add|add-ai|commit|push)
    exec "${SCRIPT_DIR}/worktree-actions.sh" "$BRANCH_NAME" "$ACTION" "$@"
    ;;

  cleanup)
    exec "${SCRIPT_DIR}/cleanup-worktree.sh" "$BRANCH_NAME" "$@"
    ;;

  *)
    log_error "Unknown action: $ACTION"
    echo ""
    echo "Run '/wt help' to see available actions"
    exit 1
    ;;
esac
```

**Changes Required:**
- Create new file
- Set execute permissions

### 5. Fullstack Dispatcher (`wt-full-dispatcher.sh`)

**Purpose:** Route `/wt-full` actions to fullstack scripts

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/shared/common-functions.sh"

show_help() {
  cat <<EOF
Usage: /wt-full <action> [options]

FULLSTACK WORKSPACE ACTIONS:
  init [options]              Initialize fullstack workspace (one-time)
    --frontend <branch>       Frontend branch (default: main)
    --port <port>             Dev server port (default: 6942)
    --force                   Recreate if exists

  switch <branch> [options]   Switch frontend branch
    --port <port>             Update dev server port

  status                      Show workspace status
  add-fn <name>               Add function worktree
  rm-fn <name>                Remove function worktree
  list                        Show workspace details
  help                        Show this help

EXAMPLES:
  /wt-full init
  /wt-full init --frontend feat-auth --port 7000
  /wt-full switch main
  /wt-full add-fn NewNotificationHandler
  /wt-full rm-fn DeprecatedFunction

WORKSPACE STRUCTURE:
  ~/socialaize-worktrees/fullstack/
  ├── frontend/               # Switchable branch
  └── functions/              # 27+ sparse function worktrees

For feature worktrees, use: /wt help
EOF
}

ACTION="${1:-}"
shift || true

[[ -z "$ACTION" ]] && {
  show_help
  exit 0
}

[[ "$ACTION" == "help" || "$ACTION" == "--help" || "$ACTION" == "-h" ]] && {
  show_help
  exit 0
}

case "$ACTION" in
  init)
    exec "${SCRIPT_DIR}/worktree-init.sh" "$@"
    ;;

  switch)
    BRANCH="${1:-}"
    [[ -z "$BRANCH" ]] && {
      log_error "Branch name required"
      echo "Usage: /wt-full switch <branch> [--port <port>]"
      exit 1
    }
    shift || true
    exec "${SCRIPT_DIR}/worktree-switch.sh" "$BRANCH" "$@"
    ;;

  status)
    exec "${SCRIPT_DIR}/list-worktrees.sh" --fullstack-only
    ;;

  add-fn)
    FUNC_NAME="${1:-}"
    [[ -z "$FUNC_NAME" ]] && {
      log_error "Function name required"
      echo "Usage: /wt-full add-fn <name>"
      exit 1
    }
    exec "${SCRIPT_DIR}/worktree-add-function.sh" "$FUNC_NAME"
    ;;

  rm-fn)
    FUNC_NAME="${1:-}"
    [[ -z "$FUNC_NAME" ]] && {
      log_error "Function name required"
      echo "Usage: /wt-full rm-fn <name>"
      exit 1
    }
    exec "${SCRIPT_DIR}/worktree-remove-function.sh" "$FUNC_NAME"
    ;;

  list)
    exec "${SCRIPT_DIR}/list-worktrees.sh" --fullstack-only
    ;;

  *)
    log_error "Unknown action: $ACTION"
    echo ""
    echo "Run '/wt-full help' to see available actions"
    exit 1
    ;;
esac
```

**Changes Required:**
- Create new file
- Set execute permissions

### 6. Migration Script (`migrate-feature-prefix.sh`)

**Purpose:** Safely migrate existing `feature-*` worktrees to new naming

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/shared/common-functions.sh"

WORKTREE_BASE="$HOME/socialaize-worktrees"
BACKUP_DIR="/tmp/worktree-migration-backup-$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --help|-h)
      cat <<EOF
Usage: migrate-feature-prefix.sh [--dry-run]

Migrates feature worktrees from old naming (feature-*) to new naming (no prefix).

Example:
  feature-user-auth/ → user-auth/
  feature-email-flow/ → email-flow/

Safely preserves:
  • Git worktree registration
  • .env.local PORT assignments
  • Claude config symlinks
  • All uncommitted changes

Flags:
  --dry-run    Show what would happen without making changes

Safety features:
  • Pre-migration validation (uncommitted changes, running servers)
  • Automatic backup creation
  • Rollback script generation
  • Idempotent (safe to run multiple times)
EOF
      exit 0
      ;;
    *)
      log_error "Unknown argument: $1"
      exit 1
      ;;
  esac
done

echo "🔄 Worktree Migration: feature-* → new naming"
echo ""

# Pre-migration validation
log_info "Running pre-migration checks..."

# Check 1: Verify we're in git repo
validate_git_repo || exit 1

# Check 2: Find all feature-* worktrees
FEATURE_WORKTREES=()
if [[ -d "$WORKTREE_BASE" ]]; then
  while IFS= read -r dir; do
    dirname=$(basename "$dir")
    if [[ "$dirname" == feature-* ]]; then
      FEATURE_WORKTREES+=("$dir")
    fi
  done < <(find "$WORKTREE_BASE" -maxdepth 1 -type d -name "feature-*")
fi

if [[ ${#FEATURE_WORKTREES[@]} -eq 0 ]]; then
  log_success "No feature worktrees with 'feature-' prefix found"
  log_info "Migration already complete or no worktrees to migrate"
  exit 0
fi

log_info "Found ${#FEATURE_WORKTREES[@]} worktree(s) to migrate:"
for wt in "${FEATURE_WORKTREES[@]}"; do
  echo "  • $(basename "$wt")"
done
echo ""

# Check 3: Detect running dev servers
log_info "Checking for running dev servers..."
RUNNING_SERVERS=()
for wt in "${FEATURE_WORKTREES[@]}"; do
  if [[ -f "$wt/.env.local" ]]; then
    port=$(grep -E "^PORT=" "$wt/.env.local" 2>/dev/null | cut -d= -f2 | tr -d ' ')
    if [[ -n "$port" ]]; then
      if lsof -Pi ":$port" -sTCP:LISTEN -t >/dev/null 2>&1; then
        RUNNING_SERVERS+=("$(basename "$wt"):$port")
      fi
    fi
  fi
done

if [[ ${#RUNNING_SERVERS[@]} -gt 0 ]]; then
  log_error "Running dev servers detected. Stop them before migration:"
  for server in "${RUNNING_SERVERS[@]}"; then
    echo "  • $server"
  done
  exit 1
fi
log_success "No running dev servers"

# Check 4: Verify no uncommitted changes
log_info "Checking for uncommitted changes..."
DIRTY_WORKTREES=()
for wt in "${FEATURE_WORKTREES[@]}"; do
  if ! git -C "$wt" diff-index --quiet HEAD -- 2>/dev/null; then
    DIRTY_WORKTREES+=("$(basename "$wt")")
  fi
done

if [[ ${#DIRTY_WORKTREES[@]} -gt 0 ]]; then
  log_error "Uncommitted changes detected in:"
  for dirty in "${DIRTY_WORKTREES[@]}"; do
    echo "  • $dirty"
  done
  echo ""
  echo "Commit or stash changes before migration"
  exit 1
fi
log_success "No uncommitted changes"

# Check 5: Verify no naming conflicts
log_info "Checking for naming conflicts..."
CONFLICTS=()
for wt in "${FEATURE_WORKTREES[@]}"; do
  old_name=$(basename "$wt")
  new_name="${old_name#feature-}"
  new_path="$WORKTREE_BASE/$new_name"

  if [[ -e "$new_path" ]] && [[ "$new_path" != "$wt" ]]; then
    CONFLICTS+=("$old_name → $new_name (target already exists)")
  fi
done

if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
  log_error "Naming conflicts detected:"
  for conflict in "${CONFLICTS[@]}"; do
    echo "  • $conflict"
  done
  exit 1
fi
log_success "No naming conflicts"

# Dry run mode
if [[ "$DRY_RUN" == true ]]; then
  log_info "DRY RUN MODE - No changes will be made"
  echo ""
  echo "Migration plan:"
  for wt in "${FEATURE_WORKTREES[@]}"; do
    old_name=$(basename "$wt")
    new_name="${old_name#feature-}"
    echo "  ${old_name} → ${new_name}"
  done
  echo ""
  log_info "Run without --dry-run to execute migration"
  exit 0
fi

# Create backup
log_info "Creating backup..."
mkdir -p "$BACKUP_DIR"

# Backup git worktree list
git worktree list --porcelain > "$BACKUP_DIR/worktree-list.txt"

# Backup .env.local files
for wt in "${FEATURE_WORKTREES[@]}"; do
  if [[ -f "$wt/.env.local" ]]; then
    cp "$wt/.env.local" "$BACKUP_DIR/$(basename "$wt").env.local"
  fi
done

log_success "Backup created: $BACKUP_DIR"

# Generate rollback script
cat > "$BACKUP_DIR/rollback.sh" <<'ROLLBACK_EOF'
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKTREE_BASE="$HOME/socialaize-worktrees"

echo "⚠️  ROLLBACK: Reverting worktree migration"
echo ""
echo "This will restore the original feature- prefix naming"
echo ""
read -p "Are you sure? (yes/no): " confirm

[[ "$confirm" != "yes" ]] && {
  echo "Rollback cancelled"
  exit 0
}

# Read migration log
if [[ ! -f "$BACKUP_DIR/migration.log" ]]; then
  echo "❌ Migration log not found - cannot rollback safely"
  exit 1
fi

echo "🔄 Starting rollback..."

# Parse migration log and reverse operations
while IFS='|' read -r old_name new_name branch port; do
  [[ -z "$old_name" ]] && continue

  old_path="$WORKTREE_BASE/feature-$old_name"
  new_path="$WORKTREE_BASE/$new_name"

  echo "  Reverting: $new_name → feature-$old_name"

  # Remove new worktree
  git worktree remove "$new_path" --force 2>/dev/null || {
    echo "    ⚠️  Failed to remove $new_path"
    continue
  }

  # Restore old worktree
  git worktree add "$old_path" "$branch" >/dev/null 2>&1 || {
    echo "    ❌ Failed to restore $old_path"
    continue
  }

  # Restore .env.local from backup
  if [[ -f "$BACKUP_DIR/feature-${old_name}.env.local" ]]; then
    cp "$BACKUP_DIR/feature-${old_name}.env.local" "$old_path/.env.local"
  fi

  echo "    ✅ Restored feature-$old_name"
done < "$BACKUP_DIR/migration.log"

echo ""
echo "✅ Rollback complete"
ROLLBACK_EOF

chmod +x "$BACKUP_DIR/rollback.sh"

# Execute migration
log_info "Starting migration..."
echo ""

# Create migration log for rollback
echo "# Migration log: old_name|new_name|branch|port" > "$BACKUP_DIR/migration.log"

MIGRATED_COUNT=0
for wt in "${FEATURE_WORKTREES[@]}"; do
  old_path="$wt"
  old_name=$(basename "$old_path")
  new_name="${old_name#feature-}"
  new_path="$WORKTREE_BASE/$new_name"

  log_info "Migrating: $old_name → $new_name"

  # Get branch name
  branch=$(git -C "$old_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

  # Preserve PORT from .env.local
  port=""
  if [[ -f "$old_path/.env.local" ]]; then
    port=$(grep -E "^PORT=" "$old_path/.env.local" 2>/dev/null | cut -d= -f2 | tr -d ' ')
  fi

  # Log migration for rollback
  echo "${old_name#feature-}|$new_name|$branch|$port" >> "$BACKUP_DIR/migration.log"

  # Remove old git worktree registration
  git worktree remove "$old_path" --force 2>/dev/null || {
    log_error "Failed to remove old worktree: $old_path"
    continue
  }

  # Create new worktree at new location
  git worktree add "$new_path" "$branch" >/dev/null 2>&1 || {
    log_error "Failed to create new worktree: $new_path"
    # Attempt to restore old worktree
    git worktree add "$old_path" "$branch" >/dev/null 2>&1
    continue
  }

  # Restore .env.local with preserved PORT
  if [[ -n "$port" ]]; then
    cat > "$new_path/.env.local" <<EOF
# Worktree-specific configuration
PORT=$port
WORKTREE_NAME=$new_name
WORKTREE_TYPE=fullstack
EOF
  fi

  # Re-run Claude config setup
  "${SCRIPT_DIR}/setup-claude-config.sh" "$new_path" >/dev/null 2>&1 || {
    log_warn "Could not setup Claude config for: $new_name"
  }

  # Verify symlink creation
  if [[ ! -L "$new_path/.claude" ]]; then
    log_warn "  ⚠️  Claude config symlink not created for: $new_name"
  fi

  log_success "  ✓ $old_name → $new_name"
  MIGRATED_COUNT=$((MIGRATED_COUNT + 1))
done

echo ""
log_success "Migration complete! Migrated $MIGRATED_COUNT worktree(s)"
echo ""
echo "📦 Backup: $BACKUP_DIR"
echo "🔄 Rollback: $BACKUP_DIR/rollback.sh"
echo ""
log_info "Verify migration: /wt list"
```

**Changes Required:**
- Create new file
- Set execute permissions
- Test on backup copy before production

---

## Part 4: Script Updates Required

### Update 1: worktree-feature.sh

**Line 219 - Remove hardcoded prefix:**

```bash
# OLD:
WORKTREE_DIR="$WORKTREE_BASE/feature-${FEATURE_NAME}"

# NEW:
source "$(dirname "${BASH_SOURCE[0]}")/detect-worktree-type.sh"
WORKTREE_DIR="$WORKTREE_BASE/${FEATURE_NAME}"
```

**Additional Changes:**
- Source `shared/common-functions.sh` at top
- Source `shared/port-manager.sh` and use `get_next_port()`
- Update WORKTREE_README.md template to reference new `/wt` commands

### Update 2: cleanup-worktree.sh

**Line 18 - Remove hardcoded prefix + Add fullstack protection:**

```bash
# OLD:
WORKTREE_DIR="$HOME/socialaize-worktrees/feature-${FEATURE_NAME}"

# NEW:
source "$(dirname "${BASH_SOURCE[0]}")/detect-worktree-type.sh"

# Detect worktree type
detection=$(detect_worktree_type "$FEATURE_NAME" 2>/dev/null || echo "unknown")

# CRITICAL: Fullstack protection
if [[ "$detection" == "fullstack" ]]; then
  log_error "Cannot cleanup fullstack workspace"
  echo "The fullstack workspace is permanent. Use these instead:"
  echo "  /wt-full rm-fn <name>  - Remove individual function"
  exit 1
fi

# Get worktree path
WORKTREE_DIR=$(get_worktree_path "$detection")
[[ -z "$WORKTREE_DIR" ]] && {
  log_error "Worktree not found: $FEATURE_NAME"
  exit 1
}
```

**Additional Changes:**
- Source common functions
- Update help text to reference `/wt cleanup`

### Update 3: worktree-actions.sh

**Line 22 - Use detection utility:**

```bash
# OLD:
WORKTREE_DIR="$HOME/socialaize-worktrees/feature-${FEATURE_NAME}"

# NEW:
source "$(dirname "${BASH_SOURCE[0]}")/detect-worktree-type.sh"

detection=$(detect_worktree_type "$FEATURE_NAME" 2>/dev/null || echo "unknown")
WORKTREE_DIR=$(get_worktree_path "$detection")

[[ -z "$WORKTREE_DIR" ]] || [[ "$detection" == "unknown" ]]; then
  log_error "Worktree not found: $FEATURE_NAME"
  exit 1
fi

# Prevent use on fullstack (should use /wt-full instead)
if [[ "$detection" == "fullstack" ]]; then
  log_error "Cannot use worktree-actions on fullstack workspace"
  echo "Use /wt-full commands for fullstack operations"
  exit 1
fi
```

### Update 4: worktree-status.sh

**Complete rewrite to use detection:**

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/shared/common-functions.sh"
source "${SCRIPT_DIR}/detect-worktree-type.sh"

FEATURE_NAME="${1:-}"

[[ -z "$FEATURE_NAME" ]] && {
  log_error "Feature name is required"
  echo "Usage: /wt status <branch-name>"
  exit 1
}

# Detect worktree
detection=$(detect_worktree_type "$FEATURE_NAME" 2>/dev/null || echo "unknown")

if [[ "$detection" == "unknown" ]]; then
  log_error "Worktree not found: $FEATURE_NAME"
  exit 1
fi

WORKTREE_DIR=$(get_worktree_path "$detection")

# Show status based on type
if [[ "$detection" == "fullstack" ]]; then
  log_info "Fullstack workspace detected - use /wt-full status instead"
  exit 0
fi

# Feature worktree status (existing logic)
cd "$WORKTREE_DIR"

echo "📦 Worktree: $FEATURE_NAME"
echo "📁 Path: $WORKTREE_DIR"
echo ""

# Rest of existing status logic...
```

### Update 5: list-worktrees.sh

**Add filters for --features-only and --fullstack-only:**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Parse arguments
FILTER="all"
[[ "${1:-}" == "--features-only" ]] && FILTER="features"
[[ "${1:-}" == "--fullstack-only" ]] && FILTER="fullstack"

WORKSPACE_BASE="${HOME}/socialaize-worktrees"
FULLSTACK_WORKSPACE="${WORKSPACE_BASE}/fullstack"

# ... existing color definitions ...

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📋 Socialaize Worktrees${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Show fullstack if requested
if [[ "$FILTER" == "all" || "$FILTER" == "fullstack" ]]; then
  # ... existing fullstack display logic ...
fi

# Show feature worktrees if requested
if [[ "$FILTER" == "all" || "$FILTER" == "features" ]]; then
  # Find all non-fullstack worktrees
  FEATURE_WORKTREES=()
  if [[ -d "$WORKSPACE_BASE" ]]; then
    while IFS= read -r dir; do
      dirname=$(basename "$dir")
      # Skip fullstack and any feature- prefix (legacy)
      if [[ "$dirname" != "fullstack" ]]; then
        FEATURE_WORKTREES+=("$dir")
      fi
    done < <(find "$WORKSPACE_BASE" -maxdepth 1 -type d 2>/dev/null | tail -n +2)
  fi

  if [[ ${#FEATURE_WORKTREES[@]} -gt 0 ]]; then
    echo -e "${GREEN}🚀 Feature Worktrees (${#FEATURE_WORKTREES[@]})${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    for wt_path in "${FEATURE_WORKTREES[@]}"; do
      wt_name=$(basename "$wt_path")

      # ... existing feature display logic ...
    done
  else
    echo -e "${YELLOW}📁 No feature worktrees${NC}"
    echo -e "   Create one: ${BLUE}/wt create <branch>${NC}"
  fi
fi
```

**Additional Changes:**
- Update help text to reference new commands
- Show migration status if old `feature-*` worktrees detected

---

## Part 5: Command File Creation

### Command: wt.md

```markdown
---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/wt-dispatcher.sh:*)
argument-hint: <action> [branch] [options]
description: Unified feature worktree management
---

# Feature Worktree Management

**Unified command for all feature worktree operations.**

Replaces: `/worktree-feature`, `/worktree-status`, `/worktree-actions`, `/cleanup-worktree`

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/wt-dispatcher.sh $ARGUMENTS
```

---

## Quick Reference

### Create Worktree
```bash
/wt create <branch> --existing-branch <name>
/wt create user-auth --existing-branch feat-auth --port 7000
```

### Development Workflow
```bash
/wt status user-auth         # Check status
/wt add-ai user-auth         # AI-assisted staging
/wt commit user-auth         # Show staged (then commit manually)
/wt push user-auth           # Push changes
```

### Cleanup
```bash
/wt cleanup user-auth        # Remove worktree (with safety checks)
/wt cleanup user-auth --force  # Force remove
```

### List All
```bash
/wt list                     # Show all feature worktrees
```

---

## Actions Reference

**create** - Create new feature worktree
**status** - Show worktree status (branch, port, changes)
**pull** - Pull latest changes from remote
**add** - Stage all changes
**add-ai** - AI-assisted staging (analyzes changes)
**commit** - Show staged changes (ready for commit message)
**push** - Push to remote
**cleanup** - Remove worktree (safety checks included)
**list** - List all feature worktrees
**help** - Show detailed help

---

## Safety Features

✅ **Fullstack Protection** - Cannot accidentally cleanup fullstack workspace
✅ **Uncommitted Changes Detection** - Warns before destructive operations
✅ **Unpushed Commits Detection** - Prevents loss of local commits
✅ **Port Conflict Prevention** - Auto-assigns unique ports
✅ **Race-Condition Safe** - Flock locking for concurrent operations

---

## Migration from Old Commands

Old commands still work but are deprecated:

| Old | New |
|-----|-----|
| `/worktree-feature <name>` | `/wt create <name>` |
| `/worktree-status <name>` | `/wt status <name>` |
| `/worktree-actions <name> add` | `/wt add <name>` |
| `/worktree-actions <name> push` | `/wt push <name>` |
| `/cleanup-worktree <name>` | `/wt cleanup <name>` |

---

For fullstack workspace management, see: `/wt-full help`
```

### Command: wt-full.md

```markdown
---
allowed-tools: Bash(~/.local/bin/socialaize-worktree/wt-full-dispatcher.sh:*)
argument-hint: <action> [options]
description: Unified fullstack workspace management
---

# Fullstack Workspace Management

**Unified command for permanent fullstack workspace operations.**

Replaces: `/worktree-init`, `/worktree-switch`, `/worktree-add-function`, `/worktree-remove-function`

**Arguments:** `$ARGUMENTS`

Please use the Bash tool to run:
```bash
~/.local/bin/socialaize-worktree/wt-full-dispatcher.sh $ARGUMENTS
```

---

## Quick Reference

### One-Time Setup
```bash
/wt-full init                              # Initialize workspace
/wt-full init --frontend main --port 6942  # With options
```

### Switch Frontend Branch
```bash
/wt-full switch feat-auth                  # Switch to feature branch
/wt-full switch main                       # Back to main
/wt-full switch feat-ui --port 7000        # With custom port
```

### Function Management
```bash
/wt-full add-fn NewNotificationHandler     # Add function worktree
/wt-full rm-fn DeprecatedFunction          # Remove function worktree
```

### Status
```bash
/wt-full status                            # Show workspace details
/wt-full list                              # Same as status
```

---

## Actions Reference

**init** - Initialize fullstack workspace (one-time setup)
**switch** - Switch frontend branch (functions unchanged)
**status** - Show workspace status (frontend branch, functions count)
**add-fn** - Add new function worktree
**rm-fn** - Remove function worktree
**list** - Show workspace details
**help** - Show detailed help

---

## Workspace Structure

```
~/socialaize-worktrees/fullstack/
├── frontend/                 # Switchable branch (main, feat-*, etc.)
│   ├── src/                  # Full frontend code
│   ├── functions/            # Full access to all functions
│   └── .env.local            # PORT=6942 (or custom)
└── functions/                # All functions (sparse checkout)
    ├── EmailHandler/         # Only functions/EmailHandler/ (~50KB)
    ├── WorkflowManager/      # Only functions/WorkflowManager/
    └── ... (27+ functions total)
```

**Storage:**
- Total workspace: ~50-100MB
- Each function: ~50KB (sparse checkout - 99% savings)
- Frontend: ~45MB (full checkout)

---

## Common Workflows

### Start Development
```bash
cd ~/socialaize-worktrees/fullstack/frontend
pnpm dev  # Opens on configured PORT
```

### Work on Feature Branch
```bash
/wt-full switch feat-auth              # Switch to feature
# ... make changes ...
cd ~/socialaize-worktrees/fullstack/frontend
git add . && git commit -m "feat: auth"
git push origin feat-auth
```

### Edit Function
```bash
cd ~/socialaize-worktrees/fullstack/functions/EmailHandler/functions/EmailHandler/
# ... make changes ...
cd ~/socialaize-worktrees/fullstack/functions/EmailHandler
git add . && git commit -m "fix: email bug"
git push origin functions-EmailHandler
```

---

## Migration from Old Commands

Old commands still work but are deprecated:

| Old | New |
|-----|-----|
| `/worktree-init` | `/wt-full init` |
| `/worktree-switch <branch>` | `/wt-full switch <branch>` |
| `/worktree-add-function <name>` | `/wt-full add-fn <name>` |
| `/worktree-remove-function <name>` | `/wt-full rm-fn <name>` |

---

For feature worktrees, see: `/wt help`
```

---

## Part 6: Implementation Timeline

### Phase 1: Foundation (8 hours)

**Create New Scripts:**
- `shared/common-functions.sh` (1h)
- `shared/port-manager.sh` (1h)
- `detect-worktree-type.sh` (2h)
- `migrate-feature-prefix.sh` (4h)

**Deliverables:**
- All new utility scripts created
- Unit tests for detection logic
- Migration script tested on backup

### Phase 2: Dispatchers (4 hours)

**Create Dispatchers:**
- `wt-dispatcher.sh` (2h)
- `wt-full-dispatcher.sh` (1h)
- Test routing for all actions (1h)

**Deliverables:**
- Both dispatchers functional
- Help systems complete
- All actions route correctly

### Phase 3: Script Updates (6 hours)

**Update Existing Scripts:**
- `worktree-feature.sh` - Remove prefix, use detection (1h)
- `cleanup-worktree.sh` - Add fullstack protection (1h)
- `worktree-actions.sh` - Use detection utility (1h)
- `worktree-status.sh` - Use detection utility (1h)
- `list-worktrees.sh` - Add filters, update display (2h)

**Deliverables:**
- All 5 scripts updated
- Fullstack protection tested
- Detection working in all contexts

### Phase 4: Commands & Archives (2 hours)

**Create New Commands:**
- `wt.md` (30min)
- `wt-full.md` (30min)

**Archive Old Commands:**
- Move 9 commands to `.archives/commands/` (15min)
- Move 4 legacy scripts to `.archived/` (15min)
- Create archive README (30min)

**Deliverables:**
- New commands created
- Old commands archived
- Archive documented

### Phase 5: Migration & Testing (6 hours)

**Run Migration:**
- Test migration on backup copy (2h)
- Run migration on production worktrees (1h)
- Verify all worktrees functional (1h)

**Comprehensive Testing:**
- Test all `/wt` actions (1h)
- Test all `/wt-full` actions (30min)
- Test edge cases and error handling (30min)

**Deliverables:**
- All existing worktrees migrated
- All tests passing
- No data loss

### Phase 6: Documentation & Cleanup (2 hours)

**Update Documentation:**
- Update WORKSPACE_README.md templates (30min)
- Create MIGRATION_GUIDE.md (1h)
- Update any project docs referencing old commands (30min)

**Deliverables:**
- All docs updated
- Migration guide complete
- Team notified

**Total Estimated Time: 28 hours**

---

## Part 7: Testing Strategy

### Unit Tests

**Test 1: System Detection**
```bash
test_detect_worktree_type() {
  # Test feature worktree (old naming)
  assert_eq "$(detect_worktree_type "feature-user-auth")" "feature:old:..."

  # Test feature worktree (new naming)
  assert_eq "$(detect_worktree_type "user-auth")" "feature:new:..."

  # Test fullstack
  assert_eq "$(detect_worktree_type "fullstack")" "fullstack"

  # Test unknown
  assert_eq "$(detect_worktree_type "nonexistent")" "unknown"
}
```

**Test 2: Fullstack Protection**
```bash
test_fullstack_protection() {
  # Should fail
  /wt cleanup fullstack 2>&1 | grep -q "Cannot cleanup fullstack"

  # Should succeed
  /wt-full status >/dev/null
}
```

**Test 3: Port Allocation**
```bash
test_port_allocation() {
  # Create 5 worktrees concurrently
  for i in {1..5}; do
    /wt create test-$i --existing-branch main &
  done
  wait

  # Verify all have unique ports
  ports=($(grep "^PORT=" ~/socialaize-worktrees/test-*/env.local | cut -d= -f2))
  assert_unique_array "${ports[@]}"
}
```

### Integration Tests

**Test 4: Migration**
```bash
test_migration() {
  # Create old-style worktree
  create_legacy_worktree "feature-test"

  # Run migration (dry-run)
  ./migrate-feature-prefix.sh --dry-run

  # Run migration (real)
  ./migrate-feature-prefix.sh

  # Verify new path exists
  assert_dir_exists "~/socialaize-worktrees/test"

  # Verify old path gone
  assert_not_exists "~/socialaize-worktrees/feature-test"

  # Verify PORT preserved
  assert_eq "$(get_port ~/socialaize-worktrees/test)" "6943"
}
```

**Test 5: Dispatcher Routing**
```bash
test_dispatcher_routing() {
  # Test all /wt actions
  /wt help >/dev/null
  /wt list >/dev/null
  /wt status test-branch 2>&1 | grep -q "Worktree not found" # Expected

  # Test all /wt-full actions
  /wt-full help >/dev/null
  /wt-full list >/dev/null
}
```

### Manual Test Scenarios

**Scenario 1: Complete Feature Development**
```bash
/wt create user-profile --existing-branch feat-profile
cd ~/socialaize-worktrees/user-profile
# ... make changes ...
/wt add-ai user-profile
/wt commit user-profile
# (provide commit message)
/wt push user-profile
/wt cleanup user-profile
```

**Scenario 2: Fullstack Development**
```bash
/wt-full init
/wt-full switch feat-email
cd ~/socialaize-worktrees/fullstack/frontend
# ... make changes ...
/wt-full switch main
/wt-full add-fn NewEmailHandler
```

**Scenario 3: Migration**
```bash
# Before migration
ls ~/socialaize-worktrees/feature-*

# Run migration
./migrate-feature-prefix.sh

# After migration
ls ~/socialaize-worktrees/
# Should show: user-auth/, email-flow/, etc. (no feature- prefix)
```

---

## Part 8: Rollback Plan

### If Migration Fails

**Option 1: Automatic Rollback**
```bash
# Run generated rollback script
/tmp/worktree-migration-backup-*/rollback.sh
```

**Option 2: Manual Restoration**
```bash
# Restore from backup
BACKUP_DIR="/tmp/worktree-migration-backup-YYYYMMDD_HHMMSS"

# For each worktree
git worktree add ~/socialaize-worktrees/feature-NAME BRANCH
cp "$BACKUP_DIR/feature-NAME.env.local" ~/socialaize-worktrees/feature-NAME/.env.local
```

### If New Commands Break

**Revert to old commands:**
```bash
# Move old commands back
mv ~/.claude/.archives/commands/worktree-*.md ~/.claude/commands/

# Delete new commands
rm ~/.claude/commands/wt.md
rm ~/.claude/commands/wt-full.md
```

---

## Part 9: Success Criteria

### Critical Requirements

✅ **Zero Data Loss**
- All worktrees migrated successfully
- All .env.local PORTs preserved
- All git branches intact
- All uncommitted changes preserved (or blocked migration)

✅ **Functionality Preserved**
- All original features still work
- Port allocation remains race-safe
- Cleanup safety checks still function
- Sparse checkout still works

✅ **User Experience Improved**
- Commands are shorter (/wt vs /worktree-feature)
- Help system is clear
- Error messages are helpful
- Backwards compatibility during transition

✅ **Safety Enhanced**
- Fullstack protection prevents accidental deletion
- Migration has dry-run mode
- Rollback capability exists
- All edge cases handled

### Validation Checklist

**Before Production Migration:**
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Manual test scenarios complete
- [ ] Migration tested on backup copy
- [ ] Rollback script tested
- [ ] Documentation complete

**After Production Migration:**
- [ ] All worktrees show in `/wt list`
- [ ] Fullstack workspace intact (`/wt-full status`)
- [ ] No feature- prefix in folder names
- [ ] All PORTs preserved
- [ ] Claude config symlinks working
- [ ] Dev servers start successfully

---

## Part 10: Risk Mitigation

### High-Risk Areas

**Risk 1: Git Worktree State Corruption**
- **Mitigation**: Test on backup copy first
- **Mitigation**: Backup git worktree list before migration
- **Mitigation**: Validate each worktree after migration

**Risk 2: PORT Conflicts After Migration**
- **Mitigation**: Preserve .env.local files
- **Mitigation**: Verify PORT uniqueness after migration
- **Mitigation**: Test dev server startup

**Risk 3: Claude Config Symlink Breakage**
- **Mitigation**: Re-run setup-claude-config.sh after migration
- **Mitigation**: Verify symlinks point to ~/socialaize-config

**Risk 4: User Confusion During Transition**
- **Mitigation**: Keep old commands working (archived but functional)
- **Mitigation**: Show deprecation warnings with exact new syntax
- **Mitigation**: Provide MIGRATION_GUIDE.md

### Medium-Risk Areas

**Risk 5: Concurrent Operations During Migration**
- **Mitigation**: Migration script checks for running dev servers
- **Mitigation**: Migration script checks for uncommitted changes
- **Mitigation**: Lock file prevents concurrent migrations

**Risk 6: Incomplete Documentation**
- **Mitigation**: Update all templates immediately after migration
- **Mitigation**: Test help systems thoroughly
- **Mitigation**: Create comprehensive MIGRATION_GUIDE.md

---

## Summary

This comprehensive plan consolidates the worktree system from 9 commands to 2, removes the `feature-` prefix, adds critical safety protections, and preserves all existing functionality while improving the developer experience.

**Key Achievements:**
- ✅ 9 commands → 2 commands (78% reduction)
- ✅ Cleaner folder structure (no feature- prefix)
- ✅ Fullstack protection (prevents catastrophic deletion)
- ✅ All functionality preserved (port allocation, sparse checkout, safety checks)
- ✅ Backwards compatible (old commands still work during transition)
- ✅ Comprehensive testing (unit + integration + manual)
- ✅ Safe migration (dry-run, backup, rollback)
- ✅ Detailed documentation (MIGRATION_GUIDE.md, updated templates)

**Estimated Effort:** 28 hours over 1-2 weeks
**Risk Level:** LOW (with proper testing and backup procedures)
**Recommendation:** PROCEED with phased approach

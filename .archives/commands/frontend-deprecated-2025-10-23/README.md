# Archived Frontend Commands

**Date Archived:** 2025-10-23
**Reason:** Consolidated into unified `/frontend` command

---

## What Happened

These 10 frontend commands were consolidated into a single `/frontend` command with action routing and composable flags.

### Archived Commands (10)

1. `frontend-new.md` - Create new feature
2. `frontend-add.md` - Add to existing feature
3. `frontend-quick-task.md` - Quick addition without approval
4. `frontend-initiate.md` - Analyze + plan (no implementation)
5. `frontend-implement.md` - Execute implementation only
6. `frontend-analyze.md` - Analysis phase only
7. `frontend-plan.md` - Planning phase only
8. `frontend-validate.md` - Validation phase only
9. `frontend-fix.md` - Bug fixing workflow
10. `frontend-improve.md` - Code improvement/refactoring

**Total Archived:** ~5,000 lines with 80%+ duplication

---

## New Unified Command

**Location:** `~/.claude/commands/frontend.md`

**Usage:**
```bash
/frontend <action> <feature-name> <description> [--flags]
```

**Actions:**
- `new` - Replaces `frontend-new`
- `add` - Replaces `frontend-add`, `frontend-quick-task` (with --quick)
- `fix` - Replaces `frontend-fix`
- `improve` - Replaces `frontend-improve`

**Flags:**
- `--quick` - Skip approval gates
- `--skip-analysis` - Skip analysis phase
- `--skip-plan` - Skip planning phase
- `--skip-validation` - Skip validation phase
- `--stop-after <phase>` - Stop at specific phase
- `--resume` - Resume from cached state

**Replaced workflows:**
- `frontend-initiate` → `/frontend new feat "desc" --stop-after plan`
- `frontend-implement` → `/frontend new feat --resume --skip-analysis --skip-plan`
- `frontend-analyze` → `/frontend new feat "desc" --stop-after analysis`
- `frontend-plan` → `/frontend new feat "desc" --skip-analysis --stop-after plan`

---

## Migration Guide

| Old Command | New Command |
|-------------|-------------|
| `/frontend-new feat "desc"` | `/frontend new feat "desc"` |
| `/frontend-add feat "add"` | `/frontend add feat "add"` |
| `/frontend-quick-task feat "add"` | `/frontend add feat "add" --quick` |
| `/frontend-initiate feat "desc"` | `/frontend new feat "desc" --stop-after plan` |
| `/frontend-implement feat` | `/frontend new feat --resume --skip-analysis --skip-plan` |
| `/frontend-analyze feat "add"` | `/frontend add feat "add" --stop-after analysis` |
| `/frontend-plan feat "add"` | `/frontend add feat "add" --skip-analysis --stop-after plan` |
| `/frontend-validate feat` | Manual: `pnpm run typecheck && pnpm run lint` |
| `/frontend-fix feat "bug"` | `/frontend fix feat "bug"` |
| `/frontend-improve feat "refactor"` | `/frontend improve feat "refactor"` |

---

## Why Consolidate?

### Problems with Old System
1. **Massive duplication** - 2,800+ lines of identical code
2. **Maintenance burden** - Bug fixes required updating 5-10 files
3. **User confusion** - 10+ commands to remember
4. **Inconsistencies** - Different commands had different behaviors
5. **No composability** - Couldn't mix and match workflow phases

### Benefits of New System
1. **67% code reduction** - 5,000 → 1,650 lines
2. **Single source of truth** - Templates defined once
3. **One command to learn** - `/frontend` with actions
4. **Composable flags** - Mix and match workflow control
5. **Easier maintenance** - Update templates, all workflows benefit

---

## Template System

Agent prompts extracted to reusable templates:

```
~/.claude/templates/frontend/
├── code-scout-new.md           # New feature analysis
├── code-scout-add.md           # Extension analysis
├── documentation-researcher.md # Solution research
├── plan-master-new.md          # New feature planning
└── plan-master-add.md          # Extension planning
```

**Template loader:** `~/.claude/scripts/load-template.sh`

---

## Metrics

### Code Reduction
- **Before:** 5,020 lines
- **After:** 1,650 lines
- **Reduction:** 67%

### Duplication Elimination
- **Before:** 2,800+ duplicated lines
- **After:** 0 duplicated lines
- **Improvement:** 100%

### Command Count
- **Before:** 10 commands
- **After:** 1 command with 4 actions
- **Reduction:** 90%

---

## Documentation

**Analysis:** `/Users/natedamstra/.claude/COMMAND_ANALYSIS.md`
**Summary:** `/Users/natedamstra/.claude/FRONTEND_CONSOLIDATION_SUMMARY.md`
**Quick Ref:** `/Users/natedamstra/.claude/FRONTEND_COMMAND_QUICK_REF.md`

---

## Recovery

If you need to restore these commands:
```bash
cp ~/.claude/.archives/commands/frontend-deprecated-2025-10-23/*.md ~/.claude/commands/
```

But we recommend using the new `/frontend` command instead!

---

**Archived by:** Claude Code Consolidation Project
**Status:** Successfully replaced by `/frontend` command
**Recommendation:** Use new unified command for all frontend work

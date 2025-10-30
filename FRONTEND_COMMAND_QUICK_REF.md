# `/frontend` Command - Quick Reference

**NEW unified command for all frontend workflows** 🚀

---

## Basic Usage

```bash
/frontend <action> <feature-name> <description> [--flags]
```

---

## Actions

| Action | Purpose | Example |
|--------|---------|---------|
| `new` | Create new feature from scratch | `/frontend new user-profile "Profile page with avatar"` |
| `add` | Add to existing feature | `/frontend add user-profile "Add bio section"` |
| `fix` | Debug and fix issues | `/frontend fix user-profile "Fix mobile layout"` |
| `improve` | Refactor and improve | `/frontend improve user-profile "Extract avatar component"` |

---

## Flags

| Flag | Purpose | Example |
|------|---------|---------|
| `--quick` | Skip approval gates, run full pipeline | `/frontend add feat "desc" --quick` |
| `--skip-analysis` | Skip analysis phase | `/frontend add feat "desc" --skip-analysis` |
| `--skip-plan` | Skip planning phase | `/frontend add feat "desc" --skip-plan` |
| `--skip-validation` | Skip validation phase | `/frontend add feat "desc" --skip-validation` |
| `--stop-after <phase>` | Stop at phase (analysis, plan) | `/frontend new feat "desc" --stop-after plan` |
| `--resume` | Resume from last phase | `/frontend new feat --resume` |

---

## Common Workflows

### 1. Create New Feature (Full Workflow)
```bash
/frontend new user-dashboard "Dashboard with stats and recent activity"
```
**What happens:**
- ✅ Analysis (code-scout + doc-researcher)
- ✅ Planning (plan-master)
- ⏸️ **Approval gate** - Review plan
- ✅ Implementation (specialist agents)
- ✅ Validation (type check, lint, build, tests)

---

### 2. Add to Existing Feature (Extension)
```bash
/frontend add user-dashboard "Add notification bell"
```
**What happens:**
- ✅ Analysis (maps existing feature + extension points)
- ✅ Planning (minimal-change extension plan)
- ⏸️ **Approval gate** - Review plan
- ✅ Implementation (extends existing code)
- ✅ Validation

---

### 3. Quick Addition (No Approval Gates)
```bash
/frontend add user-dashboard "Add logout button" --quick
```
**What happens:**
- ✅ Analysis → Planning → Implementation → Validation
- ✅ **No approval gates** (runs full pipeline automatically)
- Use when: Small changes, trusted automation

---

### 4. Planning Only (Review Before Implementation)
```bash
/frontend new user-settings "Settings page" --stop-after plan
```
**What happens:**
- ✅ Analysis
- ✅ Planning
- ⏸️ **Stops** - Review plans in `.temp/new-user-settings-*/`

**Then resume:**
```bash
/frontend new user-settings --resume --skip-analysis --skip-plan
```

---

### 5. Fix Bug (Root Cause Analysis)
```bash
/frontend fix user-dashboard "Stats not updating on mobile"
```
**What happens:**
- ✅ Analysis (finds bug root cause, traces code flow)
- ✅ Planning (minimal fix approach)
- ⏸️ **Approval gate**
- ✅ Fix implementation
- ✅ Validation + regression tests

---

### 6. Improve Code (Refactoring)
```bash
/frontend improve user-dashboard "Extract DashboardCard into reusable component"
```
**What happens:**
- ✅ Analysis (identifies refactoring opportunities)
- ✅ Planning (safe refactoring approach)
- ⏸️ **Approval gate**
- ✅ Refactoring with backward compatibility
- ✅ Validation (ensure no regressions)

---

## Migration from Old Commands

| Old Command | New Command |
|-------------|-------------|
| `/frontend-new feat "desc"` | `/frontend new feat "desc"` |
| `/frontend-add feat "add"` | `/frontend add feat "add"` |
| `/frontend-quick-task feat "add"` | `/frontend add feat "add" --quick` |
| `/frontend-initiate feat "desc"` | `/frontend new feat "desc" --stop-after plan` |
| `/frontend-implement feat` | `/frontend new feat --resume --skip-analysis --skip-plan` |
| `/frontend-analyze feat "add"` | `/frontend add feat "add" --stop-after analysis` |
| `/frontend-plan feat "add"` | `/frontend add feat "add" --skip-analysis --stop-after plan` |
| `/frontend-validate feat` | (Run validation manually: `pnpm run typecheck && pnpm run lint`) |
| `/frontend-fix feat "bug"` | `/frontend fix feat "bug"` |
| `/frontend-improve feat "refactor"` | `/frontend improve feat "refactor"` |

---

## Workflow Phases

Every `/frontend` command follows this structure:

```
Phase 0: Initialization
  ├─ Create workspace (.temp/action-feature-timestamp/)
  ├─ Create todo list
  └─ Store context (FEATURE_CONTEXT.md)

Phase 1: Analysis (Parallel)
  ├─ code-scout (architecture mapping)
  ├─ documentation-researcher (VueUse/solutions)
  └─ Output: PRE_ANALYSIS.md

Phase 2: Planning
  ├─ plan-master (implementation plan)
  ├─ Output: MASTER_PLAN.md
  └─ ⚠️ APPROVAL GATE (unless --quick)

Phase 3: Implementation (Multi-Agent)
  ├─ code-reuser-scout (find existing patterns)
  ├─ Specialist agents (vue-architect, nanostore, etc.)
  └─ Output: Agent reports in reports/

Phase 4: Validation
  ├─ Type check (pnpm run typecheck)
  ├─ Lint (pnpm run lint)
  ├─ Build (pnpm run build)
  ├─ Tests (pnpm run test)
  └─ Output: COMPLETION_REPORT.md
```

---

## Templates Used

Behind the scenes, `/frontend` uses these templates:

### Action: `new`
- `frontend/code-scout-new.md` - Discover project patterns
- `frontend/documentation-researcher.md` - Research solutions
- `frontend/plan-master-new.md` - Plan new feature from scratch

### Action: `add`
- `frontend/code-scout-add.md` - Map existing + extension points
- `frontend/documentation-researcher.md` - Research solutions
- `frontend/plan-master-add.md` - Plan minimal-change extension

### Action: `fix` (TODO)
- `frontend/code-scout-fix.md` - Root cause analysis
- `frontend/plan-master-fix.md` - Minimal fix approach

### Action: `improve` (TODO)
- `frontend/code-scout-improve.md` - Refactoring opportunities
- `frontend/plan-master-improve.md` - Safe refactoring plan

---

## Workspace Structure

Each run creates a workspace:

```
.temp/
└── <action>-<feature>-<timestamp>/
    ├── FEATURE_CONTEXT.md      # Stores context for --resume
    ├── PRE_ANALYSIS.md          # Analysis findings
    ├── MASTER_PLAN.md           # Implementation plan
    ├── COMPLETION_REPORT.md     # Final report
    └── reports/                 # Agent reports
        ├── code-scout-report.md
        ├── doc-researcher-report.md
        ├── plan-master-report.md
        └── [specialist]-report.md
```

---

## Tips & Best Practices

### 1. Review Plans Before Implementation
```bash
# Generate plan first
/frontend new feat "desc" --stop-after plan

# Review .temp/new-feat-*/MASTER_PLAN.md
# Make manual edits if needed

# Then implement
/frontend new feat --resume --skip-analysis --skip-plan
```

### 2. Use --quick for Small Changes
```bash
# Small addition you trust
/frontend add feat "add button" --quick
```

### 3. Always Use Descriptive Names
```bash
# Good ✅
/frontend add user-profile "Add social media links section with icons"

# Bad ❌
/frontend add profile "add stuff"
```

### 4. Let Analysis Find Existing Code
```bash
# The analysis phase finds reusable code automatically
# Don't skip analysis unless you're absolutely sure
```

### 5. Resume Failed Runs
```bash
# If implementation fails, fix issues manually, then:
/frontend add feat --resume --skip-analysis --skip-plan
```

---

## Troubleshooting

### "Template not found"
**Problem:** Template file missing
**Solution:** Check `~/.claude/templates/frontend/` exists with templates

### "Variable not substituted"
**Problem:** `{{VAR}}` still in prompt
**Solution:** Check template loader syntax: `VAR=value` (no spaces)

### "Agent didn't spawn"
**Problem:** Task tool failed
**Solution:** Check agent name matches available agents

### "Approval gate stuck"
**Problem:** Command waiting for approval
**Solution:** Review plans in workspace, then respond "proceed" or use `--quick` next time

---

## Examples by Use Case

### E-commerce Feature
```bash
# New product listing page
/frontend new product-listing "Product grid with filters and sort"

# Add shopping cart
/frontend add product-listing "Add to cart button with quantity"

# Fix mobile issue
/frontend fix product-listing "Cart button not visible on mobile"
```

### Authentication System
```bash
# OAuth login
/frontend new auth-system "OAuth login with Google and GitHub"

# Add password reset
/frontend add auth-system "Password reset via email"

# Fix security issue
/frontend fix auth-system "Fix CSRF vulnerability in login"
```

### Dashboard
```bash
# Analytics dashboard
/frontend new analytics-dashboard "Dashboard with charts and metrics"

# Add export feature
/frontend add analytics-dashboard "Export to CSV button" --quick

# Improve performance
/frontend improve analytics-dashboard "Lazy load charts for performance"
```

---

## Next Steps

**Ready to use?** Try your first command:

```bash
/frontend new my-feature "Description of what you want to build"
```

**Need help?** Check:
- Full analysis: `/Users/natedamstra/.claude/COMMAND_ANALYSIS.md`
- Summary: `/Users/natedamstra/.claude/FRONTEND_CONSOLIDATION_SUMMARY.md`
- Templates: `~/.claude/templates/frontend/`

**Found a bug?** Let me know and we'll iterate!

---

**Status:** ✅ Ready for production use
**Version:** 1.0.0
**Last Updated:** 2025-10-23

---
description: ⚠️ DEPRECATED - Use /ui-screenshot --compare instead
argument-hint: [component-path] [--update-baselines]
allowed-tools: read
---

# ⚠️ DEPRECATED COMMAND

This command has been **integrated into `/ui-screenshot`** with the `--compare` and `--baseline` flags.

## Migration

```bash
# Old
/ui-visual-regression Button.vue
/ui-visual-regression Button.vue --update-baselines

# New
/ui-screenshot Button.vue --compare
/ui-screenshot Button.vue --baseline
```

## What Changed

The new `/ui-screenshot` command includes:
- ✅ **Standard screenshots** (no flags)
- ✅ **Baseline management** (`--baseline`)
- ✅ **Visual regression** (`--compare`)
- ✅ **Multiple states** (`--all-states`)
- ✅ **Multiple viewports** (`--viewports`)

## Examples

```bash
# Capture screenshot
/ui-screenshot Button.vue

# Set as baseline
/ui-screenshot Button.vue --baseline

# Compare against baseline
/ui-screenshot Button.vue --compare

# Capture all states and compare
/ui-screenshot Button.vue --all-states --compare
```

## Workflow

```bash
# 1. Initial baseline
/ui-screenshot ComponentName.vue --baseline

# 2. Make changes to component
# ... edit component code ...

# 3. Compare against baseline
/ui-screenshot ComponentName.vue --compare

# 4. If approved, update baseline
/ui-screenshot ComponentName.vue --baseline
```

## See Also
- `/ui-screenshot` - Unified screenshot command
- `/ui-review` - Quality review
- `/ui-validate` - Design system validation

**Deprecated**: October 23, 2025
**Removal Date**: November 7, 2025 (2 weeks)

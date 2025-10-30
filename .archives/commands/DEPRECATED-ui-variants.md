---
description: ⚠️ DEPRECATED - Use /ui-new --variants N instead
argument-hint: [count] [component description]
allowed-tools: read
---

# ⚠️ DEPRECATED COMMAND

This command has been **integrated into `/ui-new`** with the `--variants` flag.

## Migration

```bash
# Old
/ui-variants 5 User card with avatar

# New
/ui-new User card with avatar --variants 5
```

## What Changed

The new `/ui-new --variants N` command includes:
- ✅ **Planning phase with wireframes** (optional)
- ✅ **Custom variant count** (default: 3)
- ✅ **Automatic refinement** for chosen variant
- ✅ **Optional validation** and screenshot

## Examples

```bash
# Quick 3 variants (default)
/ui-new Badge component

# Custom 5 variants with planning
/ui-new Button component --variants 5

# Skip planning, generate 3 variants
/ui-new Card layout --variants 3 --skip-plan
```

## See Also
- `/ui-new` - Full component creation workflow
- `/ui-plan` - Planning phase only

**Deprecated**: October 23, 2025
**Removal Date**: November 7, 2025 (2 weeks)

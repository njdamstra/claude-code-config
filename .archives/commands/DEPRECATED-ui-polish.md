---
description: ⚠️ DEPRECATED - Use /ui-review --polish instead
argument-hint: [component-path]
allowed-tools: read
---

# ⚠️ DEPRECATED COMMAND

This command has been **integrated into `/ui-review`** with the `--polish` flag.

## Migration

```bash
# Old
/ui-polish src/components/vue/UserCard.vue

# New
/ui-review src/components/vue/UserCard.vue --polish
```

## What Changed

The new `/ui-review --polish` command includes:
- ✅ **All polish enhancements** from old command
- ✅ **Plus quality scoring** and issue detection
- ✅ **Combined with `--fix`** for comprehensive improvements
- ✅ **Detailed before/after reporting**

## Example

```bash
# Review with polish and auto-fix
/ui-review UserCard.vue --polish --fix
```

## See Also
- `/ui-review` - Comprehensive quality review
- `/ui-review --fix` - Auto-fix issues
- `/ui-review --polish` - Apply polish enhancements

**Deprecated**: October 23, 2025
**Removal Date**: November 7, 2025 (2 weeks)

---
description: ⚠️ DEPRECATED - Use /ui-refactor --batch instead
argument-hint: [pattern] [change description]
allowed-tools: read
---

# ⚠️ DEPRECATED COMMAND

This command has been **integrated into `/ui-refactor`** with the `--batch` flag.

## Migration

```bash
# Old
/ui-batch-update buttons/* Update all buttons to new focus ring

# New
/ui-refactor buttons/* Update all buttons to new focus ring --batch
```

## What Changed

The new `/ui-refactor --batch` command includes:
- ✅ **All batch update features** from old command
- ✅ **Plus composition mode** (`--compose`)
- ✅ **Auto-detection** when no flag provided
- ✅ **Unified refactoring interface**

## Examples

```bash
# Batch update
/ui-refactor buttons/* Standardize focus states --batch

# Compose components (new)
/ui-refactor Card + Avatar --compose

# Auto-detect best approach
/ui-refactor **/*.vue Migrate to new tokens
```

## See Also
- `/ui-refactor` - Unified refactoring command
- `/ui-refactor --compose` - Component composition
- `/ui-provider-refactor` - Provider pattern (separate command)

**Deprecated**: October 23, 2025
**Removal Date**: November 7, 2025 (2 weeks)

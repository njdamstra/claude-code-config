---
description: ⚠️ DEPRECATED - Use /ui-refactor --compose instead
argument-hint: [component1] + [component2] [+ ...]
allowed-tools: read
---

# ⚠️ DEPRECATED COMMAND

This command has been **integrated into `/ui-refactor`** with the `--compose` flag.

## Migration

```bash
# Old
/ui-compose BaseModal + TextInput

# New
/ui-refactor BaseModal + TextInput --compose
```

## What Changed

The new `/ui-refactor --compose` command includes:
- ✅ **All composition features** from old command
- ✅ **Plus batch update mode** (`--batch`)
- ✅ **Unified refactoring interface**
- ✅ **Better integration** with validation

## Examples

```bash
# Compose two components
/ui-refactor Card + Avatar --compose

# Compose multiple components
/ui-refactor Card + Avatar + Badge + Button --compose

# Let it auto-detect composition opportunity
/ui-refactor Card Avatar Badge
```

## See Also
- `/ui-refactor` - Unified refactoring command
- `/ui-refactor --batch` - Batch updates
- `/ui-provider-refactor` - Provider pattern (separate command)

**Deprecated**: October 23, 2025
**Removal Date**: November 7, 2025 (2 weeks)

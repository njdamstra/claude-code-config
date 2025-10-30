---
description: ⚠️ DEPRECATED - Use /ui-validate --tokens instead
argument-hint: [--fix] [--report]
allowed-tools: read
---

# ⚠️ DEPRECATED COMMAND

This command has been **integrated into `/ui-validate`** with the `--tokens` flag.

## Migration

```bash
# Old
/ui-validate-tokens
/ui-validate-tokens --fix

# New
/ui-validate --tokens
/ui-validate --tokens --fix
```

## What Changed

The new `/ui-validate` command includes:
- ✅ **Token validation** (`--tokens`)
- ✅ **Accessibility validation** (`--a11y`)
- ✅ **Full validation** (`--all`, default)
- ✅ **Unified auto-fix** (`--fix`)

## Examples

```bash
# Token validation only
/ui-validate --tokens

# Token validation with auto-fix
/ui-validate --tokens --fix

# Full validation (tokens + accessibility + quality)
/ui-validate --all --fix

# Accessibility only
/ui-validate --a11y
```

## See Also
- `/ui-validate` - Unified validation command
- `/ui-review` - Component-specific review
- `/ui-screenshot --compare` - Visual regression

**Deprecated**: October 23, 2025
**Removal Date**: November 7, 2025 (2 weeks)

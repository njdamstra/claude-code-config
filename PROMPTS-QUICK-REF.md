# Prompts System - Quick Reference

## Core Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/prompts list` | List all prompts | `/prompts list` |
| `/prompts <name> [msg]` | Use prompt | `/prompts bug-fix "hydration error"` |
| `/prompts preview <name>` | Preview without executing | `/prompts preview doc-research "SSR"` |
| `/prompts search <keyword>` | Search prompts | `/prompts search security` |
| `/prompts filter --tag <tag>` | Filter by tag | `/prompts filter --tag debugging` |
| `/prompts stats` | Show usage statistics | `/prompts stats` |

## Management

| Command | Description | Example |
|---------|-------------|---------|
| `/prompts store <name> <desc>` | Create/update prompt | `/prompts store my-task "Description"` |
| `/prompts delete <name>` | Delete prompt | `/prompts delete old-prompt` |
| `/prompts export [file]` | Export to JSON | `/prompts export backup.json` |
| `/prompts import <file>` | Import from JSON | `/prompts import shared.json` |

## Starter Prompts

| Name | Tags | Use For |
|------|------|---------|
| `doc-research` | research, documentation, learning | Documentation questions |
| `bug-fix` | debugging, troubleshooting, fixes | Systematic debugging |
| `refactor-safe` | refactoring, code-quality, safety | Safe refactoring |
| `code-review` | review, quality, validation | Pre-PR review |
| `security-audit` | security, audit, vulnerabilities | Security analysis |
| `optimize` | performance, optimization, speed | Performance tuning |
| `learn-concept` | learning, education, concepts | Learning new tech |
| `plan-feature` | planning, architecture, features | Feature planning |

## Storage Locations

- **User-level:** `~/.claude/prompts.json` (global, personal)
- **Project-level:** `./.claude/prompts.json` (team, version controlled)
- **Merging:** Project prompts override user prompts with same name

## Variables

- **{{USER_MESSAGE}}** - Your message (automatically substituted)
- **{{CUSTOM_VAR}}** - Custom variables (pass with `inject` command)

## Quick Workflows

### Research Something
```bash
/prompts doc-research "Vue 3 composables"
```

### Debug a Bug
```bash
/prompts preview bug-fix "memory leak"
/prompts bug-fix "memory leak in component"
```

### Review Code
```bash
/prompts code-review "my latest changes"
```

### Plan Feature
```bash
/prompts plan-feature "user authentication flow"
```

### Create Custom Prompt
```bash
/prompts store my-workflow "Quick task workflow" --tags productivity
# Then enter prompt text, press Ctrl+D when done
```

## Tips

✅ **Preview first** - Use `/prompts preview` to test before executing
✅ **Check stats** - See what prompts you use most
✅ **Tag wisely** - Use 2-4 descriptive tags per prompt
✅ **Team sync** - Put team prompts in `./.claude/prompts.json` and commit
✅ **Export backups** - Regular exports for prompt library backups

## Full Documentation

📖 See `~/.claude/PROMPTS-USAGE.md` for complete guide

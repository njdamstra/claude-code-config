---
name: CC Hook Designer
description: MUST BE USED for lifecycle automation with hooks that trigger on tool events. Use when automating prettier/eslint on file writes, running tests on code changes, pre-commit validation, security scans, or command logging. Handles PostToolUse (after tool execution), PreToolUse (before execution), matcher patterns (regex matching files/tools), and hook configuration in settings.json. Provides templates: format-on-save, test-on-edit, commit-validator, security-scanner, performance-monitor. Controls continue vs blocking behavior, ignoreErrors flags, run_in_background. Use for "hook", "automation", "on save", "on change", "lifecycle", "trigger", "format", "lint".
version: 2.0.0
tags: [claude-code, hooks, automation, lifecycle-events, post-tooluse, pre-tooluse, prettier, eslint, testing, commit-validation, settings-json, matchers, background-execution]
---

# CC Hook Designer

## Quick Start

A hook is an automated action triggered by Claude Code events. Hooks run scripts when you execute tools, allowing you to automate formatting, testing, validation, and other repetitive tasks.

### Minimal Hook
```yaml
name: Format on Save
when: PostToolUse
matchers:
  - tool: Edit
script: npm run format
```

### File Location
Add hooks to `~/.claude/settings.json` under `hooks` array:

```json
{
  "hooks": [
    {
      "name": "Format on Save",
      "when": "PostToolUse",
      "matchers": [{"tool": "Edit"}],
      "script": "npm run format"
    }
  ]
}
```

## Core Concepts

### Hook Types (When They Execute)

| Hook Type | Timing | Use Case |
|-----------|--------|----------|
| `PreToolUse` | Before tool executes | Validate input, check preconditions |
| `PostToolUse` | After tool completes | Format, lint, test |
| `Start` | When Claude starts | Initialize, setup state |
| `Stop` | When Claude stops | Cleanup, save state |
| `SubagentStop` | When subagent completes | Validate subagent output |

### Matchers: Targeting Specific Events

Hooks use matchers to target specific conditions:

```yaml
matchers:
  - tool: Edit              # Only when Edit tool is used
  - tool: Bash
    args_pattern: "npm test"  # Only for npm test commands
```

**Matcher Fields:**

| Field | Type | Purpose |
|-------|------|---------|
| `tool` | string | Target tool (Read, Edit, Bash, etc) |
| `file_pattern` | glob | Match file paths (*.ts, src/**, etc) |
| `args_pattern` | regex | Match command arguments |
| `exclude_pattern` | glob | Exclude matching files |

### Continue vs Block Behavior

```yaml
# continue: true (default) - Hook runs, execution continues
script: npm run lint
continue: true

# continue: false - Hook runs, blocks if exit code != 0
script: npm run typecheck
continue: false  # Block if types fail
```

**When to Block:**
- Validation that must succeed (type checking)
- Critical requirements (security checks)
- Never proceed on failure

**When to Continue:**
- Optional improvements (formatting)
- Notifications (running tests)
- Nice-to-have automation

## Hook Execution Model

```
Tool Execution
  ↓
PreToolUse Hooks Match?
  ├─ Yes: Run script
  │  ├─ continue: false → Check exit code, block if failed
  │  └─ continue: true → Proceed regardless
  ├─ No: Proceed
  ↓
Tool Executes (Bash, Edit, Read, etc)
  ↓
PostToolUse Hooks Match?
  ├─ Yes: Run script
  │  ├─ continue: false → Check exit code, block if failed
  │  └─ continue: true → Proceed regardless
  ├─ No: Complete
  ↓
Tool Complete
```

## Patterns

### Pattern 1: Format on Save
```json
{
  "name": "Auto-format JavaScript",
  "when": "PostToolUse",
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "**/*.{js,ts,jsx,tsx}"
    }
  ],
  "script": "npx prettier --write \"${file}\""
}
```

### Pattern 2: Test on File Change
```json
{
  "name": "Run tests on TypeScript changes",
  "when": "PostToolUse",
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "src/**/*.ts"
    }
  ],
  "script": "npm test -- --testPathPattern=\"${file}.test.ts\"",
  "continue": true
}
```

### Pattern 3: Pre-commit Validation
```json
{
  "name": "Validate before bash git commit",
  "when": "PreToolUse",
  "matchers": [
    {
      "tool": "Bash",
      "args_pattern": "git commit"
    }
  ],
  "script": "npm run typecheck && npm run lint",
  "continue": false
}
```

### Pattern 4: Security Check
```json
{
  "name": "Security scan on code changes",
  "when": "PostToolUse",
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "src/**/*.ts"
    }
  ],
  "script": "npm audit --audit-level=moderate",
  "continue": true
}
```

### Pattern 5: Dependency Update Hook
```json
{
  "name": "Check lock file after package.json change",
  "when": "PostToolUse",
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "**/package.json"
    }
  ],
  "script": "npm install",
  "continue": false
}
```

## Best Practices

### DO: Keep Hooks Fast
```json
// Good - runs in <1 second
{
  "script": "npm run lint:quick"
}

// Bad - runs in 30+ seconds on every change
{
  "script": "npm test"  // Full test suite is slow
}
```

### DO: Be Specific with Matchers
```json
// Good - only triggers for relevant files
{
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "src/**/*.ts"
    }
  ]
}

// Bad - runs on everything
{
  "matchers": [{"tool": "Edit"}]
}
```

### DO: Use continue: false for Critical Checks
```json
// Good - type checking must pass
{
  "script": "npm run typecheck",
  "continue": false
}

// Good - formatting is optional
{
  "script": "npm run format",
  "continue": true
}
```

### DO: Document Hook Purpose
```json
// Good - clear why this exists
{
  "name": "Enforce type safety on edits",
  "when": "PostToolUse",
  "matchers": [{"tool": "Edit", "file_pattern": "src/**/*.ts"}],
  "script": "npm run typecheck",
  "continue": false
}

// Bad - mysterious
{
  "name": "run script",
  "when": "PostToolUse",
  "script": "npx something"
}
```

### DON'T: Create Infinite Loops
```json
// Bad - edit hook that modifies files triggers another edit
{
  "name": "Auto-format and save",
  "when": "PostToolUse",
  "matchers": [{"tool": "Edit"}],
  "script": "npm run format && git add ."  // Don't re-trigger Edit!
}

// Good - only notify, don't modify
{
  "name": "Alert after edit",
  "when": "PostToolUse",
  "matchers": [{"tool": "Edit"}],
  "script": "echo 'File edited' | mail -s 'Change' admin@example.com"
}
```

### DON'T: Store Secrets in Hooks
```json
// Bad - secrets exposed
{
  "script": "curl -H 'Auth: sk-1234567890' https://api.example.com"
}

// Good - use environment variables
{
  "script": "curl -H \"Auth: $API_KEY\" https://api.example.com"
}
```

### DON'T: Rely on Order Between Hooks
```json
// Bad - depends on hook execution order
{
  "name": "Hook 1",
  "script": "echo step1 > /tmp/state.txt"
},
{
  "name": "Hook 2",
  "script": "cat /tmp/state.txt"  // Assumes Hook 1 ran first
}

// Good - hooks are independent
{
  "name": "Independent hook",
  "script": "npm run validate"
}
```

## Advanced Techniques

### Conditional Hooks with Bash
```json
{
  "name": "Smart test runner",
  "when": "PostToolUse",
  "matchers": [{"tool": "Edit"}],
  "script": "bash -c 'if grep -q \"test\" \"${file}\"; then npm test; fi'",
  "continue": true
}
```

### Environment Variable Access
```json
{
  "name": "Run in project context",
  "when": "PostToolUse",
  "script": "bash -c 'cd \"$PROJECT_ROOT\" && npm run build'",
  "continue": false
}
```

### Multi-Step Hook
```json
{
  "name": "Full validation pipeline",
  "when": "PostToolUse",
  "matchers": [{"tool": "Edit", "file_pattern": "src/**/*.ts"}],
  "script": "bash -c 'npm run lint && npm run typecheck && npm run format'",
  "continue": false
}
```

### Exclude Patterns
```json
{
  "name": "Format except node_modules",
  "when": "PostToolUse",
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "**/*.ts",
      "exclude_pattern": "node_modules/**"
    }
  ],
  "script": "npm run format"
}
```

## Troubleshooting

### Hook Not Triggering
- Check `when` matches event type (PostToolUse, PreToolUse, etc)
- Verify `matchers` conditions are met
- Check tool name matches exactly (Read, Edit, Bash)
- Verify file_pattern matches the file being edited

### Hook Running Too Often
- Make matchers more specific
- Use exclude_pattern to skip certain files
- Reduce tool scope

### Hook Performance Issue
- Check hook script execution time
- Use faster linters/formatters
- Split into multiple hooks with smaller scopes
- Consider running hooks less frequently

### Hook Blocking Work
- Review `continue: false` hooks
- Check exit codes of blocking hooks
- Consider making hook non-blocking (`continue: true`)
- Ensure hook script completes successfully

## Real-World Hook Examples

### Vue Project Setup
```json
[
  {
    "name": "Format Vue files",
    "when": "PostToolUse",
    "matchers": [{"tool": "Edit", "file_pattern": "**/*.vue"}],
    "script": "npx prettier --write \"${file}\""
  },
  {
    "name": "Type check Vue components",
    "when": "PostToolUse",
    "matchers": [{"tool": "Edit", "file_pattern": "src/**/*.vue"}],
    "script": "npm run typecheck",
    "continue": false
  }
]
```

### Python Project Setup
```json
[
  {
    "name": "Format Python on save",
    "when": "PostToolUse",
    "matchers": [{"tool": "Edit", "file_pattern": "**/*.py"}],
    "script": "black \"${file}\" && isort \"${file}\""
  },
  {
    "name": "Run pytest on test change",
    "when": "PostToolUse",
    "matchers": [{"tool": "Edit", "file_pattern": "tests/**/*.py"}],
    "script": "pytest \"${file}\" -v",
    "continue": true
  }
]
```

## Description Best Practices

While hooks don't have "descriptions" in the traditional sense, their configuration should be clear and discoverable. Focus on making hook names and matchers self-explanatory.

### Key Principles

**1. Use Descriptive Hook Names**
- Make the purpose immediately clear
- Use pattern: [TRIGGER] [ACTION]
- Avoid generic names

```json
// Good - clear purpose
{
  "name": "Format TypeScript files on edit",
  "matcher": "Edit.*\\.ts$"
}

// Bad - too vague
{
  "name": "Do formatting",
  "matcher": "Edit"
}
```

**2. Target Specific Matchers**
- Be precise with file patterns and tool types
- Avoid overly broad matchers
- Document why each hook exists

```json
// Good - specific targeting
{
  "name": "Enforce type safety on src changes",
  "matcher": "Edit.*src/.*\\.ts$",
  "script": "tsc --noEmit"
}

// Bad - too broad
{
  "name": "Run typecheck",
  "matcher": "Edit"
}
```

**3. Signal Blocking vs Non-Blocking**
- Make continue behavior explicit in name
- Indicate whether hook can fail

```json
// Good - signals blocking
{
  "name": "Validate types before save (BLOCKING)",
  "script": "npm run typecheck",
  "continue": false
}

// Good - signals optional
{
  "name": "Format code (optional)",
  "script": "prettier --write $CLAUDE_FILE_PATHS",
  "continue": true
}
```

**4. Document Hook Grouping**
- Group related hooks with comments
- Explain the purpose of each group
- Make relationships explicit

```json
// Code Quality Hooks
[
  {
    "name": "Format on save",
    "when": "PostToolUse",
    "matcher": "Write|Edit"
  },
  {
    "name": "Lint on TypeScript change",
    "when": "PostToolUse",
    "matcher": "Edit.*\\.ts$"
  }
]

// Validation Hooks
[
  {
    "name": "Type check before commit",
    "when": "PreToolUse",
    "matcher": "Bash.*git commit"
  }
]
```

**5. Include Hook Lifecycle Comments**
- Explain WHEN hook runs (PreToolUse, PostToolUse, Start, Stop)
- Document what triggers it
- Show what it accomplishes

```json
{
  "name": "Format on file write",
  "when": "PostToolUse",  // Runs AFTER Edit tool completes
  "matchers": [{"tool": "Edit"}],  // Triggered by file edits
  "script": "prettier --write $CLAUDE_FILE_PATHS"  // Keeps code formatted
}
```

### Configuration Template

```json
{
  "name": "[VERB] [WHAT] on [TRIGGER]",
  "when": "PostToolUse",  // or PreToolUse, Start, Stop
  "matchers": [
    {
      "tool": "Edit",  // Or Read, Bash, etc
      "file_pattern": "src/**/*.ts"  // Optional file filter
    }
  ],
  "script": "npm run format",
  "continue": false  // true = optional, false = blocking
}

Example:
{
  "name": "Format TypeScript on edit",
  "when": "PostToolUse",
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "src/**/*.ts"
    }
  ],
  "script": "prettier --write $CLAUDE_FILE_PATHS",
  "continue": true
}
```

### Real Hook Example

```json
{
  "name": "Type-check Vue components on edit (BLOCKING)",
  "when": "PostToolUse",
  "matchers": [
    {
      "tool": "Edit",
      "file_pattern": "src/**/*.vue"
    }
  ],
  "script": "npm run typecheck",
  "continue": false  // Blocks if types fail
}
```

## References

For more information:
- CC Mastery: When to use hooks vs commands
- Hook Configuration: `documentation/claude/claude-code-docs/5-CLAUDE-CODE-HOOKS-COMPREHENSIVE-GUIDE.md`
- Settings Guide: `documentation/claude/claude-code-docs/8-CLAUDE-CODE-SETTINGS-GUIDE.md`

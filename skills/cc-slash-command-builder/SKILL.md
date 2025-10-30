---
name: CC Slash Command Builder
description: MUST BE USED for creating custom /slash commands, workflow templates, and automation shortcuts. Use when building /command files in .claude/commands/, automating multi-step workflows (git commit, run tests, deploy), parameter passing with $ARGUMENTS, template composition, or comparing commands vs subagents. Provides complete templates for: /git-commit (message generation), /test-runner, /deploy-check, /code-summary, /api-docs-gen. Each command supports tool restrictions and execution scope. Use for "/command", "automation", "reusable workflow", "shortcut", "script template", "$ARGUMENTS".
version: 2.0.0
tags: [claude-code, slash-commands, workflows, automation, templates, tools, parameters, reusable-workflows, git, testing, deployment]
---

# CC Slash Command Builder

## Quick Start

A slash command is a reusable workflow template you can invoke with `/command-name` syntax. Commands can accept arguments, use specific tools, and automate complex tasks.

### Minimal Slash Command
```markdown
---
description: Format and lint all JavaScript files
allowed-tools: [Bash]
---

# Format JavaScript Files

Run prettier and ESLint on your project:

npm run format && npm run lint
```

### File Location
Place command in `~/.claude/commands/command-name.md`

### Frontmatter Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `description` | Yes | Shows in command palette |
| `allowed-tools` | No | Restrict to specific tools |
| `argument-hint` | No | Show usage example (e.g., `<filename>`) |
| `model` | No | Override model for command execution |

## Core Concepts

### Command vs Slash Command

**Slash Command** (what we're building):
- User types: `/format-code`
- Claude executes the template
- Reusable workflow automation

**Subagent Invocation:**
- Automatic, trigger-based
- Specialized expertise
- Use when you need AI decision-making

**Comparison Table:**

| Aspect | Slash Command | Subagent |
|--------|---------------|----------|
| Invocation | User types `/command` | Claude auto-invokes |
| Use Case | Defined workflows | Specialized expertise |
| Arguments | Flexible via $ARGUMENTS | Fixed system prompt |
| Discovery | Command palette | Description matching |

### Argument Interpolation

Commands support three ways to access arguments:

```markdown
---
description: Search for a term in code
argument-hint: <search-term>
---

# Code Search

Search term: $1

Find all occurrences:
\`\`\`bash
grep -r "$1" src/ --include="*.ts"
\`\`\`
```

**Argument Forms:**

| Form | Usage | Example |
|------|-------|---------|
| `$1` | First argument | Search term |
| `$2` | Second argument | File pattern |
| `$ARGUMENTS` | All arguments | `npm run $ARGUMENTS` |

### Scopes: Project vs User

**Project Scope** (`~/.claude/commands/` at project root):
- Specific to current project
- Use for project-specific workflows
- Example: `/run-tests`, `/build-prod`

**User Scope** (`~/.claude/commands/` in home directory):
- Available everywhere
- General-purpose workflows
- Example: `/git-commit`, `/format-code`

## Patterns

### Pattern 1: Simple Workflow Command
```markdown
---
description: Run tests with coverage report
---

# Test with Coverage

Run the project test suite and generate coverage:

npm test -- --coverage
```

### Pattern 2: Parameterized Command
```markdown
---
description: Search codebase for a term
argument-hint: <search-term> [file-pattern]
---

# Code Search

Search for: $1
Files: $2

\`\`\`bash
grep -r "$1" . ${2:---include="*.ts"} --exclude-dir=node_modules
\`\`\`
```

### Pattern 3: Multi-Step Workflow
```markdown
---
description: Build and deploy application
argument-hint: [environment]
---

# Build and Deploy

Build and deploy to $1 environment:

1. Type: npm run build
2. Verify dist/ exists
3. Type: npm run deploy:$1
4. Check deployment status
```

### Pattern 4: Tool-Restricted Command
```markdown
---
description: Analyze project structure
allowed-tools: [Bash, Read, Grep]
---

# Project Analysis

Analyze project structure and complexity:

1. Count files by type: find . -type f | cut -d. -f2 | sort | uniq -c
2. Show largest files: find . -type f -exec wc -l {} + | sort -rn | head -20
3. List main directories: ls -d */
```

### Pattern 5: Integration with Subagents
```markdown
---
description: Security audit of codebase
---

# Security Audit

Run comprehensive security review:

This command will invoke the security-auditor subagent to:
1. Review code for vulnerabilities
2. Check dependencies for known issues
3. Verify secure coding practices
4. Generate security report

Type the path to files to audit, then I'll invoke the auditor.
```

### Pattern 6: Timestamped Output Directories
```markdown
---
description: Research and document findings with automatic archival
argument-hint: [topic]
---

# Research Command

## Variables
- **TIMESTAMP**: $(date +"%Y-%m-%d_%H-%M-%S")
- **TOPIC**: $1 or "general"
- **OUTPUT_DIR**: outputs/${TIMESTAMP}/${TOPIC}

## Execution
1. Create timestamped directory:
   ```bash
   TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
   mkdir -p "outputs/${TIMESTAMP}/$1"
   ```

2. Execute research agents

3. Save outputs to `outputs/${TIMESTAMP}/$1/`

## Benefits
- Automatic versioning - never overwrite previous work
- Audit trail - track evolution over time
- Easy comparison - diff between sessions
```

### Pattern 7: Agent Output Preservation
```markdown
---
description: Multi-agent research with complete output preservation
allowed-tools: [Bash, Task, Write]
---

# Multi-Agent Research

## Output Format

**CRITICAL**: Write each agent's complete response directly to its
respective file with NO modifications, NO summarization, and NO
changes whatsoever. The exact response from each agent must be preserved.

## Execution
1. Create output directories
2. Invoke agents in parallel
3. **Preserve complete, unmodified agent outputs**:
   - `outputs/<timestamp>/agent1.md` - Full agent 1 response
   - `outputs/<timestamp>/agent2.md` - Full agent 2 response
4. Create summary separately (do not modify agent outputs)
```

### Pattern 8: Variable Declaration Section
```markdown
---
description: Feature creation with documented variables
argument-hint: [feature-name] [--flags]
---

# Create Feature

## Variables

- **FEATURE_NAME**: $1 or "unnamed-feature"
  - The name of the feature to create
  - Used by: directory creation, git branch, planning docs
  - Pattern: kebab-case, no spaces

- **FLAGS**: $2 $3 $4
  - Optional flags (--quick, --full, --no-tests)
  - Used by: workflow selection, tool restrictions

- **TIMESTAMP**: $(date +"%Y-%m-%d_%H-%M-%S")
  - Current timestamp for output organization
  - Used by: all output file paths

## Instructions
[Use variables defined above...]
```

### Pattern 9: Execution Report Template
```markdown
---
description: Research with standardized completion report
---

# Research Command

[...execution steps...]

## Completion Report

When all agents complete, output:

```
✅ Command: /research
📁 Output: outputs/YYYY-MM-DD_HH-MM-SS/topic/
📊 Success: X/Y agents completed
⏱️  Duration: Xm Ys

### Outputs Generated
- ✅ agent1.md (1234 tokens)
- ✅ agent2.md (5678 tokens)
- ❌ agent3.md (failed: timeout)

### Next Steps
- Review outputs at: [path]
- Run /consolidate to merge findings
```
```

## Best Practices

### DO: Write Clear Descriptions
```yaml
# Good - specific and actionable
description: Format all JavaScript/TypeScript files with Prettier and lint with ESLint

# Bad - too vague
description: Format code
```

### DO: Use Naming Conventions
```
/git-commit-ai         # Good - verb-noun-descriptor
/format-code           # Good - clear action
/x                     # Bad - meaningless
/veryLongCommandName   # Bad - hard to type
```

### DO: Include Argument Hints
```yaml
argument-hint: <filename> [options]  # Clear usage
argument-hint: <search-term>         # Required argument
# Missing - unclear what command expects
```

### DO: Restrict Tools When Possible
```yaml
allowed-tools: [Bash, Read, Grep]     # Review-only
allowed-tools: [Read, Edit, Write]    # Modify files
# Unrestricted - potential safety risk
```

### DO: Document Complex Commands
```markdown
---
description: Advanced performance profiling
---

# Performance Profiling

Use this command to:
1. Run application with profiling enabled
2. Collect CPU and memory metrics
3. Generate HTML report
4. Show top hotspots

Arguments: [service-name] [duration-seconds]
```

### DON'T: Create Commands for Simple Tasks
```yaml
# Bad - too trivial for a command
description: List files in current directory
```

### DON'T: Put Secrets in Commands
```markdown
# Bad - secrets exposed in template
API_KEY=sk-1234567890abcdef npm deploy
```

```markdown
# Good - use environment variables
API_KEY=$API_KEY npm deploy
```

### DON'T: Make Commands Too Complex
```markdown
# Bad - try to do everything
description: Build, test, lint, format, and deploy

# Good - focused purpose
description: Format all source files with Prettier
```

## Advanced Usage

### Model-Specific Commands
```yaml
---
description: Generate comprehensive test cases
model: claude-opus-4-1  # Use more powerful model
allowed-tools: [Read, Write, Bash]
---

# Generate Tests

Generate comprehensive test suite for:
```

### Conditional Logic in Commands
```markdown
---
description: Conditional deployment script
argument-hint: [prod|staging]
---

# Deploy Conditional

Environment: $1

Check environment variable and deploy accordingly:
\`\`\`bash
if [ "$1" = "prod" ]; then
  npm run deploy:production
  npm run smoke:tests
else
  npm run deploy:staging
fi
\`\`\`
```

### Combining Multiple Arguments
```markdown
---
description: Git commit with scope and type
argument-hint: <type> <scope> [message]
---

# Git Commit Structured

Type: $1 (feat|fix|docs|style|refactor|perf|test|chore)
Scope: $2
Message: $3

\`\`\`bash
git commit -m "$1($2): $3"
\`\`\`
```

### Stacking with Hooks
Commands can work with hooks:

```markdown
---
description: Save with auto-format hook
allowed-tools: [Edit]
---

# Smart Save

When you edit a file:
1. Format with prettier (via hook)
2. Lint with eslint (via hook)
3. Type tests pass (via hook)
```

## Testing Your Command

### Test 1: Discovery
```
/help or command palette
→ Your command shows with correct description
```

### Test 2: Execution
```
/your-command arg1 arg2
→ Command executes with correct arguments
```

### Test 3: Tool Restrictions
```
→ Command only uses allowed-tools
→ Restricted tools are not accessible
```

### Test 4: Argument Substitution
```
/search-code "query" "*.ts"
→ $1 = "query", $2 = "*.ts"
```

## Troubleshooting

### Command Not Appearing
- Verify file is in `~/.claude/commands/`
- Check filename doesn't have spaces
- Ensure frontmatter has `description` field

### Arguments Not Substituting
- Use `$1`, `$2` (not `$arg1`)
- Verify argument count matches usage
- Check for typos in substitution syntax

### Tool Restrictions Not Working
- Verify `allowed-tools` field is present
- Check tool names match exactly (case-sensitive)
- Test with restricted tools first

### Command Too Slow
- Break into smaller commands
- Cache expensive operations
- Consider delegating to subagent

## Real-World Examples

### Example 1: Git Workflow
```markdown
---
description: Create feature branch and push
argument-hint: <feature-name>
---

# Feature Branch

Create and push feature branch:

\`\`\`bash
git checkout -b feature/$1
git push -u origin feature/$1
\`\`\`
```

### Example 2: Project Analysis
```markdown
---
description: Analyze project for duplicate code
allowed-tools: [Bash, Grep]
---

# Find Duplicates

Find potentially duplicated code:

\`\`\`bash
find src -name "*.ts" -exec wc -l {} + | sort -rn | head -20
\`\`\`
```

### Example 3: Development Setup
```markdown
---
description: Initialize new project with all dependencies
---

# Project Setup

Initialize new project:

1. npm install
2. npm run build
3. npm run test
4. npm run dev
```

## Description Best Practices

The description field is crucial for command discovery and invocation. Make it specific, keyword-rich, and action-oriented.

### Key Principles

**1. Front-Load Critical Terms**
- Put the most important keywords at the start
- Users will scan the beginning first

```yaml
# Good - specific action-oriented
description: Format and lint all JavaScript/TypeScript files with Prettier and ESLint

# Bad - vague, buried keywords
description: Various code quality tools available for different purposes
```

**2. Include Use Cases and Triggers**
- Describe WHAT the command does
- List specific scenarios when to use it
- Include command-specific keywords (arguments, tools)

```yaml
# Good - clear triggers
description: Search codebase for a term. Use when finding code patterns, locating references, or analyzing usage.

# Bad - unclear
description: Search thing
```

**3. Mention Parameter Types**
- Hint at expected arguments
- Show argument names or patterns

```yaml
# Good - users understand what to provide
description: Create feature branch. Accepts branch name and optional push flag.

# Bad - unclear expectations
description: Branch management
```

**4. Distinguish from Subagents**
- Commands are user-invoked workflows
- Subagents are auto-invoked specialists
- Make the distinction clear in description

```yaml
# For a command
description: Build and deploy application. User specifies environment (prod/staging/dev).

# For a subagent (different!)
description: MUST BE USED for automated deployment validation and rollback planning
```

### Structure Template

```yaml
description: [ACTION VERB] [WHAT]. Use when [trigger scenarios]. Accepts [arguments/parameters].

Example:
description: Format and lint TypeScript code with Prettier and ESLint. Use when adding new files or after bulk edits. Accepts optional file pattern.
```

### Real Command Example

```yaml
---
description: Create and push feature branch with conventional name pattern. Use when starting new features. Accepts feature name as argument.
argument-hint: <feature-name>
---
```

## References

For more information:
- CC Mastery: When to use commands vs subagents
- Slash Commands Full Guide: `documentation/claude/claude-code-docs/01-slash-commands-guide.md`
- CC Subagent Architect: When to delegate to specialized agents

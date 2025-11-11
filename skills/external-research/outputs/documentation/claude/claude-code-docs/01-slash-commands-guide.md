# Claude for Code: Slash Commands - Complete Reference Guide

## Table of Contents
1. [Overview](#overview)
2. [Command Types & Scopes](#command-types--scopes)
3. [File Locations](#file-locations)
4. [Syntax & Structure](#syntax--structure)
5. [Frontmatter Options](#frontmatter-options)
6. [Arguments & Interpolation](#arguments--interpolation)
7. [Built-in Commands](#built-in-commands)
8. [Creating Custom Commands](#creating-custom-commands)
9. [MCP-Based Commands](#mcp-based-commands)
10. [Plugin Commands](#plugin-commands)
11. [Best Practices](#best-practices)
12. [Limitations & Edge Cases](#limitations--edge-cases)

---

## Overview

Slash commands in Claude for Code are **user-invoked** reusable prompt templates stored as Markdown files. They differ from other extension points:

- **User-Invoked**: You explicitly type `/command` to trigger them
- **Model-Invoked**: Skills and subagents are automatically invoked by Claude
- **Token Efficiency**: Extract fixed workflows from CLAUDE.md to reduce token consumption
- **Team Sharing**: Project commands can be version controlled and shared via git

### Key Difference from Skills
- **Slash Commands**: User explicitly calls `/command-name`
- **Skills**: Claude automatically decides when to use based on description
- **Use Case**: Commands for workflows you want to trigger; Skills for capabilities Claude should discover

---

## Command Types & Scopes

### Project-Scoped Commands
**Location**: `.claude/commands/` (in project root)

**Characteristics**:
- Shared with team via git
- Specific to the project
- Show `(project)` suffix in `/help`
- Take precedence over user commands in case of name conflicts

**Example Structure**:
```
project/
├── .claude/
│   └── commands/
│       ├── optimize.md
│       ├── security-review.md
│       └── git/
│           └── commit.md
```

### User-Scoped Commands
**Location**: `~/.claude/commands/` (home directory)

**Characteristics**:
- Available across ALL projects
- Personal commands not shared with team
- Show `(user)` suffix in `/help`
- Lower precedence than project commands

**Example Structure**:
```
~/.claude/
└── commands/
    ├── personal-workflow.md
    ├── review.md
    └── utils/
        └── format.md
```

### Invocation Patterns

```bash
# Simple command
/optimize

# With arguments
/fix-github-issue 1234

# Namespaced (subdirectories)
/project:git:commit "feat: add feature"
/user:utils:format

# Plugin commands
/plugin-name:command-name
# or just
/command-name  # if no name conflicts
```

---

## File Locations

### Directory Structure Priority

Claude searches in this order:
1. `.claude/commands/` (project-level)
2. `~/.claude/commands/` (user-level)
3. Plugin-provided commands

### Subdirectory Namespacing

Commands can be organized in folders for better structure:

```
.claude/commands/
├── git/
│   ├── commit.md        # /project:git:commit
│   └── review.md        # /project:git:review
├── tests/
│   ├── unit.md          # /project:tests:unit
│   └── integration.md   # /project:tests:integration
└── deploy/
    └── production.md    # /project:deploy:production
```

**Namespace Syntax**:
- File: `.claude/commands/category/command.md`
- Invocation: `/project:category:command` or `/user:category:command`

---

## Syntax & Structure

### Basic Command File

**Filename**: `command-name.md` (no spaces, use hyphens)

**Content**:
```markdown
# Command Title

Brief description of what this command does.

## Instructions
1. Step one
2. Step two
3. Step three

## Examples
Show concrete examples here.
```

### With Frontmatter

```markdown
---
description: Brief description shown in /help and used by SlashCommand tool
argument-hint: [arg1] [arg2]
allowed-tools: Bash(git add:*), Bash(git status:*), Write
model: claude-3-5-haiku-20241022
disable-model-invocation: false
---

# Command Title

Instructions here...

Use $ARGUMENTS to insert command arguments.
Use $1, $2, $3 for positional arguments.
```

---

## Frontmatter Options

### `description` (Required for SlashCommand tool)
```yaml
---
description: Review code for security vulnerabilities and best practices
---
```
- **Purpose**: Shown in `/help` output and included in context for SlashCommand tool
- **Requirement**: MUST be present for Claude to programmatically invoke the command
- **Best Practice**: Be specific about when to use the command

### `argument-hint`
```yaml
---
argument-hint: [pr-number] [priority] [assignee]
---
```
- **Purpose**: Shows expected arguments in help text
- **Format**: Use square brackets for required, angle brackets for optional
- **Example**: `[required] <optional>`

### `allowed-tools`
```yaml
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Write
---
```
- **Purpose**: Restricts which tools Claude can use during command execution
- **Syntax**: 
  - `ToolName` for any use
  - `ToolName(pattern)` for specific patterns
  - `ToolName(arg:*)` for wildcard matching
- **Security**: Prevents command from using dangerous tools

### `model`
```yaml
---
model: claude-3-5-haiku-20241022
---
```
- **Purpose**: Override default model for this command
- **Options**:
  - `claude-opus-4-20250514`
  - `claude-sonnet-4-20250514`
  - `claude-3-5-haiku-20241022`
- **Use Case**: Use Haiku for simple commands to save costs

### `disable-model-invocation`
```yaml
---
disable-model-invocation: true
---
```
- **Purpose**: Prevents Claude from automatically invoking this command via SlashCommand tool
- **Effect**: Command still available for manual `/command` usage
- **Use Case**: Commands you only want to trigger explicitly

---

## Arguments & Interpolation

### `$ARGUMENTS` - All Arguments

```markdown
---
description: Create a git commit with message
---

# Git Commit

Create a conventional commit with message: $ARGUMENTS
```

**Usage**:
```bash
/commit "feat: add user authentication"
# Result: "feat: add user authentication" is inserted where $ARGUMENTS appears
```

### Positional Arguments - `$1`, `$2`, `$3`, etc.

```markdown
---
argument-hint: [pr-number] [priority] [assignee]
---

# Review PR

Review PR #$1 with priority $2 and assign to $3.
Focus on security, performance, and code style.
```

**Usage**:
```bash
/review-pr 456 high john@example.com
# $1 = 456
# $2 = high  
# $3 = john@example.com
```

### Best Practices for Arguments

1. **Always provide `argument-hint`** in frontmatter
2. **Validate in instructions**: Tell Claude to check arguments are provided
3. **Provide defaults**: Include fallback behavior for optional arguments
4. **Use examples**: Show Claude how to handle different argument patterns

---

## Built-in Commands

Claude for Code includes several built-in commands:

### `/help`
Lists all available commands (built-in, custom, MCP-based, plugin)

### `/init`
Analyzes codebase and creates CLAUDE.md with essential project info

### `/compact`
Manually compacts (summarizes) conversation context to save tokens

### `/hooks`
Interactive menu for configuring hooks

### `/agents`
Interactive menu for managing subagents

### `/config`
Opens settings configuration interface

### `/plugin`
Manage plugins (install, remove, enable/disable)

### `/output-style`
Change Claude's communication style (default, explanatory, learning, custom)

### `/model`
Switch between models (sonnet, opus, haiku)

### `/permissions`
Manage tool permissions interactively

### `/mcp`
Manage MCP server connections

### `/terminal-setup`
Configure terminal settings (Shift+Enter for newlines, etc.)

### SlashCommand Tool Limitations

**NOT supported by SlashCommand tool**:
- Built-in commands (like `/compact`, `/init`)
- Commands without `description` frontmatter
- Commands with `disable-model-invocation: true`

**Only custom user-defined commands** with descriptions can be invoked programmatically.

---

## Creating Custom Commands

### Step 1: Create Directory Structure

```bash
# Project-specific
mkdir -p .claude/commands

# Personal (user-level)
mkdir -p ~/.claude/commands
```

### Step 2: Create Command File

**Example: `.claude/commands/fix-github-issue.md`**

```markdown
---
description: Analyze and fix a GitHub issue using gh CLI
argument-hint: [issue-number]
allowed-tools: Bash(gh:*), Read, Write, Edit, Grep
---

# Fix GitHub Issue

Resolve the GitHub issue specified by the issue number.

## Steps

1. Use `gh issue view $ARGUMENTS` to retrieve issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files using Grep
4. Implement necessary changes to fix the issue
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Create a descriptive commit message using conventional commits
8. Push changes and create a PR using `gh pr create`

## Requirements

- Always use GitHub CLI (`gh`) for GitHub operations
- Follow conventional commit format
- Include tests for all fixes
- Update documentation if needed

## Error Handling

If issue number is not provided or invalid:
- Ask user to provide valid issue number
- Show example: `/project:fix-github-issue 1234`
```

### Step 3: Use the Command

```bash
# Invoke the command
/project:fix-github-issue 1234

# Or if in commands root
/fix-github-issue 1234
```

### Advanced Example: Git Commit Workflow

**File**: `~/.claude/commands/commit.md`

```markdown
---
description: Create a conventional commit with all changes and push
allowed-tools: Bash(git *)
---

# Commit and Push Changes

Create a conventional commit with all current changes and push to remote.

## Steps

1. Run `git status` to see all changes
2. Run `git diff` to review the changes
3. Analyze changes and determine appropriate commit type:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `style:` for formatting changes
   - `refactor:` for code refactoring
   - `test:` for test additions/changes
   - `chore:` for maintenance tasks
4. Stage all changes with `git add -A`
5. Create a conventional commit with descriptive message
6. Push to current branch with `git push`

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Important

- This project follows Conventional Commits specification
- Do NOT add co-authors to commit message
- Ensure commit message is clear and descriptive
```

---

## MCP-Based Commands

MCP servers can expose prompts as slash commands that appear in Claude for Code.

### How MCP Commands Work

1. **MCP Server Exposes Prompts**: Server defines available prompts
2. **Auto-Discovery**: Claude for Code detects them on connection
3. **Namespace Pattern**: Commands use `mcp__servername__promptname` format
4. **Invocation**: Use like any other slash command

### Syntax Patterns

```bash
# Without arguments
/mcp__github__list_prs

# With arguments  
/mcp__github__pr_review 456
/mcp__jira__create_issue "Bug title" high

# Incorrect (wildcards not supported)
/mcp__github__*  # ❌ WRONG
```

### Permissions for MCP Commands

In `.claude/settings.json`:

```json
{
  "permissions": {
    "allowedTools": [
      // Approve all tools from a server
      "mcp__github",
      
      // Or approve specific tools only
      "mcp__github__list_prs",
      "mcp__github__pr_review"
    ]
  }
}
```

### Example: GitHub MCP Commands

After connecting GitHub MCP server:

```bash
# List pull requests
/mcp__github__list_prs

# Review specific PR
/mcp__github__pr_review 456

# Create issue
/mcp__github__create_issue
```

---

## Plugin Commands

Plugins can provide custom slash commands bundled with other components.

### How Plugin Commands Work

1. **Plugin Structure**: Plugins have `commands/` directory
2. **Installation**: Commands available after plugin install
3. **Namespacing**: Optional `plugin-name:command` format
4. **Distribution**: Shared via plugin marketplaces

### Installing Plugin with Commands

```bash
# Add marketplace
/plugin marketplace add company-tools https://github.com/company/plugins

# Install plugin  
/plugin install code-review@company-tools

# Commands now available
/code-review:security
/code-review:performance
```

### Plugin Command Structure

```
plugin-repo/
├── .claude-plugin/
│   └── marketplace.json
└── plugins/
    └── code-review/
        └── commands/
            ├── security.md
            ├── performance.md
            └── style.md
```

### Using Plugin Commands

```bash
# With namespace (always works)
/plugin-name:command-name

# Without namespace (if no conflicts)
/command-name
```

---

## Best Practices

### 1. Command Organization

**DO**:
```
.claude/commands/
├── git/
│   ├── commit.md
│   └── review.md
├── test/
│   └── generate.md
└── deploy/
    └── production.md
```

**DON'T**:
```
.claude/commands/
├── command1.md
├── command2.md
├── command3.md
└── ... (dozens of files in root)
```

### 2. Description Writing

**DO**:
```yaml
---
description: Review code for security vulnerabilities focusing on injection attacks, auth issues, and data exposure
---
```

**DON'T**:
```yaml
---
description: Review code
---
```

### 3. Command Complexity

**Simple Commands** (single responsibility):
```markdown
---
description: Format Python files using Black
---

Format all Python files in the current directory using Black formatter.

Run: `black .`
```

**Complex Workflows** (multi-step):
```markdown
---
description: Complete feature development workflow from spec to PR
---

1. Create feature branch
2. Implement feature
3. Write tests
4. Run test suite
5. Update documentation
6. Create PR with description
```

### 4. Argument Handling

**DO**: Validate and provide feedback
```markdown
## Validation

If $ARGUMENTS is empty:
- Prompt user for issue number
- Show usage example: `/fix-issue 1234`
```

**DON'T**: Assume arguments are always correct
```markdown
Fix issue $ARGUMENTS
# What if no argument provided?
```

### 5. Tool Restrictions

**DO**: Limit to necessary tools
```yaml
---
allowed-tools: Read, Grep, Bash(npm test:*), Bash(npm run:*)
---
```

**DON'T**: Grant unrestricted access
```yaml
---
allowed-tools: Bash  # Allows ANY bash command!
---
```

### 6. Documentation

**Every command should include**:
- Clear description in frontmatter
- Step-by-step instructions
- Examples of usage
- Error handling guidance
- Requirements/prerequisites

### 7. Token Efficiency

**Extract from CLAUDE.md**:

Before (in CLAUDE.md, loaded every session):
```markdown
# Testing Workflow
When asked to test:
1. Write tests
2. Run test suite
3. Check coverage
...
```

After (as `/test` command, loaded only when used):
```markdown
# .claude/commands/test.md
Run complete test workflow...
```

### 8. Team Collaboration

**DO**: Version control project commands
```bash
git add .claude/commands/
git commit -m "feat: add deployment commands"
```

**DO**: Document in README
```markdown
## Custom Commands

- `/project:deploy:staging` - Deploy to staging
- `/project:deploy:production` - Deploy to production (requires approval)
```

**DON'T**: Store sensitive data in commands
```markdown
# ❌ WRONG
Deploy using API_KEY="sk-secret-key-here"

# ✅ CORRECT  
Deploy using API key from environment ($API_KEY)
```

---

## Limitations & Edge Cases

### Character Budget for SlashCommand Tool

The SlashCommand tool has a **character budget** for command descriptions:
- Keeps token usage reasonable
- Long descriptions may be truncated
- Keep descriptions concise (1-2 sentences)

### Viewing Available Commands

```bash
# See all commands Claude can invoke programmatically
claude --debug
# Then trigger any query - check logs for SlashCommand tool context
```

### Name Conflicts

**Resolution Order**:
1. Project commands (`.claude/commands/`)
2. User commands (`~/.claude/commands/`)
3. Plugin commands
4. MCP commands

**Example**:
```
.claude/commands/review.md         # This wins
~/.claude/commands/review.md       # Ignored
plugin/commands/review.md          # Ignored
```

### Command Not Appearing

**Checklist**:
- [ ] File is `.md` extension
- [ ] File in correct directory
- [ ] Contains `description` frontmatter (for SlashCommand tool)
- [ ] No `disable-model-invocation: true` (if want auto-invoke)
- [ ] Restart Claude for Code session

### Extended Thinking Trigger

Commands can trigger extended thinking mode by including **keywords**:

```markdown
# Complex Analysis Command

Analyze this codebase thoroughly and identify architectural patterns...
[Claude automatically enters extended thinking mode]
```

**Trigger words**: complex, analyze, comprehensive, deep, thorough, extensive

### Bash Integration

Commands can execute shell scripts:

```markdown
---
description: Run custom deployment script
---

Execute the deployment script:

```bash
#!/bin/bash
./scripts/deploy.sh --environment production
```
```

### File References

Commands can reference project files:

```markdown
Review the authentication implementation in:
- `src/auth/login.ts`
- `src/auth/session.ts`
- `tests/auth.test.ts`

Check for security vulnerabilities.
```

### Debugging Commands

To see command execution:

```bash
# Enable debug mode
claude --debug

# Or set environment variable
export CLAUDE_DEBUG=1
claude
```

---

## Integration with Other Features

### Slash Commands + Subagents

Commands can explicitly invoke subagents:

```markdown
---
description: Comprehensive code review using specialized agents
---

# Multi-Agent Code Review

1. Use the security-reviewer subagent to check for vulnerabilities
2. Use the performance-analyzer subagent to identify bottlenecks  
3. Use the test-engineer subagent to verify test coverage
4. Compile findings into final review
```

### Slash Commands + Hooks

Hooks can run after commands complete:

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "echo 'Command /deploy completed' | notify"
      }]
    }]
  }
}
```

### Slash Commands + Skills

Commands can reference skills:

```markdown
Use the docx skill to create a professional report of findings.
```

### Slash Commands + MCP

Commands can use MCP tools:

```markdown
1. Use GitHub MCP to fetch PR details
2. Use Slack MCP to notify team
3. Use Jira MCP to update ticket
```

---

## Advanced Patterns

### Workflow Orchestration

```markdown
---
description: Complete feature development from start to finish
---

# Feature Development Workflow

## Phase 1: Planning
1. Review issue details
2. Create technical spec
3. Get approval

## Phase 2: Implementation  
4. Create feature branch
5. Implement core functionality
6. Write comprehensive tests

## Phase 3: Quality
7. Run test suite
8. Run linter
9. Check code coverage

## Phase 4: Deployment
10. Create PR with description
11. Request reviews
12. Merge after approval
```

### Command Chaining

```markdown
After completing this command, suggest running:
- `/project:test:unit` to verify changes
- `/project:deploy:staging` to deploy
```

### Conditional Logic

```markdown
If $1 equals "staging":
  - Deploy to staging environment
  - Use staging database
  
If $1 equals "production":
  - Require additional approval
  - Use production database
  - Create deployment record
```

---

## Real-World Examples

### Example 1: API Scaffolding

**File**: `.claude/commands/api-scaffold.md`

```markdown
---
description: Scaffold REST API endpoints with tests and documentation
argument-hint: [resource-name]
allowed-tools: Write, Bash(npm *)
model: claude-sonnet-4-20250514
---

# API Scaffold

Create complete REST API for resource: $ARGUMENTS

## Generate

1. **Controller**: `src/controllers/$ARGUMENTS.controller.ts`
   - GET /api/$ARGUMENTS
   - GET /api/$ARGUMENTS/:id
   - POST /api/$ARGUMENTS
   - PUT /api/$ARGUMENTS/:id
   - DELETE /api/$ARGUMENTS/:id

2. **Service**: `src/services/$ARGUMENTS.service.ts`
   - Business logic layer
   - Data validation
   - Error handling

3. **Model**: `src/models/$ARGUMENTS.model.ts`
   - Database schema
   - TypeScript types
   - Validation rules

4. **Tests**: `tests/$ARGUMENTS.test.ts`
   - Unit tests for service
   - Integration tests for controller
   - Mock data fixtures

5. **Documentation**: `docs/api/$ARGUMENTS.md`
   - API endpoint documentation
   - Request/response examples
   - Error codes

## Stack Compliance

- Follow existing project architecture
- Use TypeScript with strict mode
- Include input validation with Zod
- Add OpenAPI/Swagger annotations
- Follow RESTful conventions
```

### Example 2: Security Audit

**File**: `~/.claude/commands/security-review.md`

```markdown
---
description: Comprehensive security audit focusing on OWASP Top 10
allowed-tools: Read, Grep, Bash(npm audit)
---

# Security Review

Perform comprehensive security audit of codebase.

## Check For

### 1. Injection Attacks
- SQL injection vulnerabilities
- Command injection risks
- LDAP injection
- Search for: raw SQL, exec(), eval()

### 2. Authentication Issues
- Weak password policies
- Missing MFA
- Insecure session management
- Search for: password, auth, session

### 3. Sensitive Data Exposure
- Hardcoded secrets
- Unencrypted sensitive data
- Logs containing PII
- Search for: password, api_key, secret

### 4. XML External Entities (XXE)
- XML parsing vulnerabilities
- Search for: xml, parsexml

### 5. Broken Access Control
- Missing authorization checks
- Insecure direct object references
- Search for: auth, permission, role

### 6. Security Misconfiguration  
- Default configurations
- Unnecessary features enabled
- Check: config files, env variables

### 7. Cross-Site Scripting (XSS)
- Unescaped output
- Dangerous innerHTML usage
- Search for: innerHTML, dangerouslySetInnerHTML

### 8. Insecure Deserialization
- Untrusted data deserialization
- Search for: deserialize, pickle, unserialize

### 9. Using Components with Known Vulnerabilities
- Run: `npm audit`
- Check for outdated dependencies

### 10. Insufficient Logging & Monitoring
- Missing security event logging
- No alerting for suspicious activity

## Output Format

Create markdown report with:
- Executive summary
- Findings by severity (Critical, High, Medium, Low)
- Remediation recommendations
- Code samples showing issues
```

---

## Quick Reference

### Command Invocation Patterns

```bash
/command                          # Simple command
/command arg1 arg2                # With arguments
/project:category:command         # Project namespaced
/user:category:command            # User namespaced
/plugin-name:command              # Plugin command
/mcp__server__prompt              # MCP-based command
```

### File Locations

```
Project:   .claude/commands/*.md
User:      ~/.claude/commands/*.md
Plugin:    plugin/commands/*.md (managed by plugin system)
```

### Essential Frontmatter

```yaml
---
description: Brief description (REQUIRED for SlashCommand tool)
argument-hint: [arg1] [arg2] <optional>
allowed-tools: ToolName, ToolName(pattern)
model: claude-sonnet-4-20250514 | claude-opus-4-20250514 | claude-3-5-haiku-20241022
disable-model-invocation: true | false
---
```

### Argument Variables

```
$ARGUMENTS    - All arguments as single string
$1, $2, $3    - Positional arguments
```

---

## Documentation Sources

- **Official Docs**: https://docs.claude.com/en/docs/claude-code/slash-commands
- **Best Practices**: https://www.anthropic.com/engineering/claude-code-best-practices
- **GitHub Examples**: https://github.com/hesreallyhim/awesome-claude-code

---

## Summary

Slash commands provide a powerful way to:
- **Reduce token usage** by extracting fixed workflows from CLAUDE.md
- **Share workflows** with team via version control
- **Standardize processes** across projects
- **Customize** Claude's behavior for specific tasks
- **Integrate** with other Claude for Code features (subagents, hooks, skills, MCP)

**Remember**: 
- Commands are **user-invoked** (you type `/command`)
- Skills are **model-invoked** (Claude decides when to use)
- Commands with `description` can be invoked programmatically via SlashCommand tool
- Project commands override user commands in case of conflicts

Start simple with a few essential commands, then expand based on your workflow needs!

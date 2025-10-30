# Prompts Management System - Usage Guide

## Overview

The `/prompts` slash command provides a powerful prompt template management system with:

- **Dual-tier storage**: User-level (~/.claude/prompts.json) and project-level (./.claude/prompts.json)
- **Variable substitution**: Support for {{USER_MESSAGE}} and custom variables
- **Usage analytics**: Track prompt usage count and timestamps
- **Tag-based organization**: Categorize and filter prompts
- **Search capabilities**: Find prompts by keyword
- **Import/export**: Share prompt libraries

## Quick Start

### List Available Prompts
```bash
/prompts list
```

### Use a Prompt
```bash
/prompts doc-research "explain Astro SSR patterns"
```
This injects the `doc-research` prompt template, substitutes {{USER_MESSAGE}}, and executes.

### Preview Before Using
```bash
/prompts preview bug-fix "hydration mismatch"
```
Shows what will be injected WITHOUT executing.

## Complete Command Reference

### 1. List Prompts
```bash
/prompts list                    # List all prompts
/prompts list --tag research     # Filter by tag
```

**Output includes:**
- Prompt name and description
- Tags
- Usage count and last used timestamp

### 2. Use a Prompt (Injection)
```bash
/prompts <name> [user-message]
```

**Examples:**
```bash
/prompts doc-research "Vue 3 composables best practices"
/prompts bug-fix "memory leak in component"
/prompts code-review "my latest changes"
```

**What happens:**
1. Loads prompt template
2. Substitutes {{USER_MESSAGE}} with your message
3. Updates usage statistics
4. Executes the injected prompt in Claude

### 3. Preview Prompt
```bash
/prompts preview <name> [user-message]
```

**Use cases:**
- Test variable substitution before executing
- Review prompt content
- Verify correct prompt is selected

### 4. Store New Prompt
```bash
/prompts store <name> <description> [options]
```

**Options:**
- `--tags tag1,tag2` - Comma-separated categorization tags
- `--notes "..."` - Additional usage notes
- `--scope user|project` - Storage location (default: user)
- `--prompt "..."` - Prompt text (if omitted, enters interactive mode)

**Interactive mode example:**
```bash
/prompts store my-workflow "Custom debugging workflow" --tags debugging,custom

# Then enter your prompt text (press Ctrl+D when done):
Debug {{USER_MESSAGE}} by:
1. Check error logs
2. Reproduce locally
3. Fix and verify
```

**One-line example:**
```bash
/prompts store quick-task "Fast task completion" --tags productivity --prompt "Complete {{USER_MESSAGE}} efficiently"
```

### 5. Edit Existing Prompt
```bash
/prompts store <existing-name> <new-description> --prompt "updated text"
```

Updates the prompt if it exists, creates new if it doesn't.

### 6. Delete Prompt
```bash
/prompts delete <name>
```

Removes prompt from storage (checks both user and project levels).

### 7. Search Prompts
```bash
/prompts search <keyword>
```

Searches across:
- Prompt names
- Descriptions
- Prompt content
- Tags

**Example:**
```bash
/prompts search security
# Returns: security-audit prompt
```

### 8. Filter by Tag
```bash
/prompts filter --tag <tag>
```

**Examples:**
```bash
/prompts filter --tag debugging
/prompts filter --tag research
/prompts filter --tag team
```

### 9. Usage Statistics
```bash
/prompts stats
```

Shows all prompts sorted by usage count with:
- Total uses
- Last used timestamp
- "Never used" for unused prompts

### 10. Export Prompts
```bash
/prompts export [filename]
```

Exports merged prompts (user + project) to JSON file.

**Default:** `prompts-export.json`

**Example:**
```bash
/prompts export team-prompts.json
```

### 11. Import Prompts
```bash
/prompts import <filename> [user|project]
```

Imports prompts from JSON file. Merges with existing, keeping newer versions based on `updatedAt` timestamp.

**Examples:**
```bash
/prompts import team-prompts.json user      # Import to user-level
/prompts import shared.json project         # Import to project-level
```

## Storage Architecture

### Two-Tier System

**User-level: `~/.claude/prompts.json`**
- Personal prompts available globally
- Persists across all projects
- Your private prompt library

**Project-level: `./.claude/prompts.json`**
- Team/project-specific prompts
- Can be version controlled (git)
- Shared across team

### Merging Behavior

When loading prompts:
1. Load user-level prompts
2. Load project-level prompts
3. Merge: **project prompts override user prompts** with the same name

**Example:**
```
User-level has:  doc-research (generic research workflow)
Project-level has: doc-research (team-specific research standards)
Result: Uses project-level version
```

This allows:
- Teams to standardize workflows via project-level prompts
- Individuals to keep personal prompts via user-level
- Project requirements to take precedence

## Variable Substitution

### Built-in Variables

**{{USER_MESSAGE}}** - Automatically replaced with the message you provide when invoking

```
Prompt template:
Research {{USER_MESSAGE}} using these steps...

Usage:
/prompts doc-research "Vue 3 best practices"

Result:
Research Vue 3 best practices using these steps...
```

### Custom Variables

Define custom variables in your prompt using `{{VAR_NAME}}` syntax.

**Prompt template:**
```
Analyze {{TOPIC}} in the context of {{FRAMEWORK}}.
User request: {{USER_MESSAGE}}
```

**Usage:**
```bash
/prompts inject analyze-tech "performance implications" TOPIC=SSR FRAMEWORK=Astro
```

**Note:** Custom variables require using the `inject` subcommand directly with variable assignments.

## Starter Prompts

Your installation includes 8 production-ready prompts:

### 1. doc-research
**Tags:** research, documentation, learning
**Use for:** Technical documentation questions

Systematic research workflow:
- Local documentation search first
- Web research fallback
- Comprehensive answers with references

### 2. bug-fix
**Tags:** debugging, troubleshooting, fixes
**Use for:** Systematic bug investigation

5-step debugging process:
1. Understand the bug
2. Reproduce the issue
3. Trace root cause
4. Propose solutions (root cause vs quick fix)
5. Implement & verify

### 3. refactor-safe
**Tags:** refactoring, code-quality, safety
**Use for:** Safe refactoring with validation

Incremental refactoring workflow:
- Map dependencies first
- Create detailed plan
- Refactor incrementally with `tsc --noEmit` validation
- Prioritize REUSE over recreation

### 4. code-review
**Tags:** review, quality, validation
**Use for:** Pre-PR comprehensive review

8-category checklist:
- Functionality, TypeScript safety, Vue components
- Accessibility, Security, Performance
- Code quality, Testing

### 5. security-audit
**Tags:** security, audit, vulnerabilities
**Use for:** Security-focused analysis

7-area security audit:
- Input validation, Authentication/Authorization
- Data exposure, API security
- Appwrite security, Dependencies, SSR security

### 6. optimize
**Tags:** performance, optimization, speed
**Use for:** Performance optimization with measurement

5-phase optimization:
1. Measure baseline
2. Identify bottlenecks
3. Apply optimization strategies
4. Implement & measure impact
5. Monitor over time

### 7. learn-concept
**Tags:** learning, education, concepts
**Use for:** Learning new technologies

6-part learning framework:
- Mental model, Core concepts
- Practical example, Common patterns
- Integration with current stack
- Next steps

### 8. plan-feature
**Tags:** planning, architecture, features
**Use for:** Strategic feature planning

8-stage planning:
- Requirements, Research existing code
- Architecture design, Technical decisions
- Implementation plan, Testing strategy
- Rollout plan, Documentation needs

## Workflow Examples

### Example 1: Quick Research
```bash
# List research-related prompts
/prompts filter --tag research

# Preview before using
/prompts preview doc-research "Astro SSR patterns"

# Use it
/prompts doc-research "Astro SSR patterns"
```

### Example 2: Team Standardization
```bash
# Create project-level prompt for team code reviews
/prompts store team-review "Team code review standards" \
  --scope project \
  --tags review,team \
  --prompt "Review {{USER_MESSAGE}} against our team standards:
1. Check style guide compliance
2. Verify test coverage > 80%
3. Ensure documentation updated
4. Validate accessibility"

# Share via git
git add .claude/prompts.json
git commit -m "Add team code review prompt"
git push

# Team members can now use it
/prompts team-review "my PR #123"
```

### Example 3: Personal Productivity
```bash
# Create personal quick-task prompt
/prompts store quick "Fast task completion" \
  --tags productivity \
  --prompt "Complete {{USER_MESSAGE}} with:
- Minimal changes
- Focus on the exact requirement
- Test immediately
- Document if needed"

# Use throughout the day
/prompts quick "add loading spinner to button"
/prompts quick "fix typo in header"
```

### Example 4: Analytics-Driven Improvement
```bash
# Check what prompts you use most
/prompts stats

# Output shows:
# 📊 doc-research - 45 uses | Last: 2025-10-29T18:30:00Z
# 📊 bug-fix - 23 uses | Last: 2025-10-29T15:20:00Z
# 📊 quick - 19 uses | Last: 2025-10-29T19:45:00Z
# 📊 security-audit - 0 uses | Never used

# Insight: You might want to improve your security-audit prompt
# or create a more accessible version
```

### Example 5: Import/Export Workflow
```bash
# Export your prompts
/prompts export my-prompts-2025.json

# Share with team or backup
# Later, on a new machine or project:

/prompts import my-prompts-2025.json user
```

## Prompt Schema

Each prompt includes:

```json
{
  "name": "unique-identifier",
  "description": "What the prompt does",
  "prompt": "The actual prompt text with {{VARIABLES}}",
  "tags": ["category", "keywords"],
  "notes": "Optional usage notes or context",
  "usageCount": 0,
  "lastUsed": null,
  "variables": ["USER_MESSAGE", "CUSTOM_VAR"],
  "createdAt": "2025-10-29T19:30:00Z",
  "updatedAt": "2025-10-29T19:30:00Z"
}
```

## Best Practices

### 1. Naming Conventions
- Use kebab-case: `doc-research`, `bug-fix`
- Keep names short but descriptive
- Avoid generic names: prefer `security-audit` over `audit`

### 2. Description Writing
- Front-load key terms
- Describe WHAT the prompt does
- Include when to use it
- Mention expected parameters

**Good:** "Systematic bug investigation and resolution workflow"
**Bad:** "Debug stuff"

### 3. Tagging Strategy
- Use 2-4 tags per prompt
- Mix category tags (debugging, research) with context tags (team, ssr)
- Create tag taxonomy for your team

### 4. Variable Design
- Always use {{USER_MESSAGE}} for main input
- Use {{SCREAMING_CASE}} for custom variables
- Document variables in prompt notes field

### 5. Scope Selection
- User-level: Personal workflows, experiments, learning prompts
- Project-level: Team standards, project-specific workflows, shared best practices

### 6. Maintenance
- Review usage stats monthly
- Delete unused prompts
- Update high-use prompts based on learnings
- Export backups regularly

## Troubleshooting

### Prompt not found
**Issue:** `/prompts my-prompt "message"` returns "Prompt not found"

**Solution:**
1. List all prompts: `/prompts list`
2. Check spelling of prompt name
3. Verify scope (user vs project)

### Variable not substituting
**Issue:** {{USER_MESSAGE}} appears in output instead of being replaced

**Solution:**
- Ensure you're providing a message: `/prompts name "your message"`
- Check prompt template has correct syntax: `{{USER_MESSAGE}}` (not `{USER_MESSAGE}`)

### Project prompt not overriding user prompt
**Issue:** User-level version loading instead of project-level

**Solution:**
1. Verify project-level file exists: `ls -la ./.claude/prompts.json`
2. Check both prompts have exact same `name` field
3. Use `/prompts preview <name>` to see which version loads

### Permission denied on import
**Issue:** Cannot write to prompts.json file

**Solution:**
```bash
# Check file permissions
ls -la ~/.claude/prompts.json

# Fix if needed
chmod 644 ~/.claude/prompts.json
```

## Advanced Usage

### Conditional Prompts
Create different prompts for different scenarios:

```bash
/prompts store debug-ssr "SSR-specific debugging" --tags debugging,ssr
/prompts store debug-client "Client-side debugging" --tags debugging,client
```

Use based on context:
```bash
/prompts debug-ssr "hydration mismatch"
/prompts debug-client "event handler not firing"
```

### Chained Workflows
Combine prompts for complex workflows:

```bash
# Step 1: Research
/prompts doc-research "feature flags in Astro"

# Step 2: Plan
/prompts plan-feature "implement feature flags"

# Step 3: Build (use output from planning)
# ... implement based on plan ...

# Step 4: Review
/prompts code-review "feature flag implementation"
```

### Team Synchronization
```bash
# Team lead creates/updates prompts
/prompts store api-design "API design standards" --scope project

# Commit and push
git add .claude/prompts.json
git commit -m "Update API design standards"
git push

# Team members pull and use
git pull
/prompts api-design "user authentication endpoint"
```

## Integration with Other Claude Code Features

### With Skills
Prompts can invoke skills:
```
Prompt:
Use the vue-component-builder skill to create {{USER_MESSAGE}}
```

### With Subagents
Prompts can delegate to subagents:
```
Prompt:
Invoke the code-scout subagent to find existing patterns for {{USER_MESSAGE}}
```

### With Hooks
Combine with hooks for automation:
```json
{
  "PostToolUse": {
    "matcher": "Write",
    "command": "/prompts code-review \"recent changes\""
  }
}
```

## Resources

- Prompts Manager Script: `~/.claude/scripts/prompts-manager.sh`
- User-level Storage: `~/.claude/prompts.json`
- Project-level Storage: `./.claude/prompts.json`
- Slash Command Definition: `~/.claude/commands/prompts.md`

## Future Enhancements

Potential improvements:
- Prompt versioning
- Prompt templates with multiple variable sets
- Interactive prompt builder UI
- Prompt effectiveness scoring
- AI-suggested prompts based on usage patterns

---

**Need help?**
- List all commands: `/prompts list`
- Preview before using: `/prompts preview <name>`
- Check usage: `/prompts stats`

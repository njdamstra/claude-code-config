---
description: Manage and inject reusable prompt templates with variable substitution and usage tracking
argument-hint: <subcommand> [args]
---

# Prompts Management System

Manage reusable prompt templates with support for:
- Dual-tier storage (user + project level)
- Variable substitution ({{USER_MESSAGE}}, custom vars)
- Usage analytics and tagging
- Search, filter, preview capabilities

## Available Subcommands

### List Prompts
```bash
/prompts list [--tag <tag>]
```
Lists all available prompts with metadata (description, tags, usage count).

### Use a Prompt
```bash
/prompts <name> [user-message]
```
Injects the named prompt followed by the user message. Updates usage statistics.

**Example:**
```bash
/prompts doc-research "explain Astro SSR patterns"
```

This will inject the `doc-research` prompt template, then append your message.

### Preview Prompt
```bash
/prompts preview <name> [user-message]
```
Shows what will be injected WITHOUT executing. Useful for testing variable substitution.

### Store New Prompt
```bash
/prompts store <name> <description> [options]
```

**Options:**
- `--tags tag1,tag2` - Comma-separated tags
- `--notes "..."` - Additional notes about the prompt
- `--scope user|project` - Storage location (default: user)
- `--prompt "..."` - Prompt text (if omitted, enters interactive mode)

**Interactive mode:**
If `--prompt` is not provided, you'll be prompted to enter multi-line text (end with Ctrl+D).

**Example:**
```bash
/prompts store debug-ssr "Systematic SSR debugging workflow" --tags debugging,ssr --scope project
```

Then enter your prompt text when prompted.

### Edit Prompt
```bash
/prompts store <existing-name> <new-description> --prompt "updated text"
```
Updates an existing prompt (same as store, but replaces if exists).

### Delete Prompt
```bash
/prompts delete <name>
```
Removes a prompt from storage. Checks both user and project levels.

### Search Prompts
```bash
/prompts search <keyword>
```
Searches prompt names, descriptions, content, and tags for the keyword.

### Filter by Tag
```bash
/prompts filter --tag <tag>
```
Shows only prompts with the specified tag.

### Usage Statistics
```bash
/prompts stats
```
Shows all prompts sorted by usage count with timestamps.

### Export Prompts
```bash
/prompts export [filename]
```
Exports all prompts (merged from user + project) to JSON file.
Default filename: `prompts-export.json`

### Import Prompts
```bash
/prompts import <filename> [user|project]
```
Imports prompts from JSON file. Merges with existing, keeping newer versions.

## Storage Behavior

**Two-tier architecture:**
- User-level: `~/.claude/prompts.json` (personal prompts, available globally)
- Project-level: `./.claude/prompts.json` (team/project prompts, version controlled)

**Merging:**
- At runtime, prompts from both levels are merged
- Project-level prompts **override** user-level prompts with the same name
- This allows teams to standardize prompts while users keep personal ones

## Variable Substitution

Prompts support dynamic variables:

### Built-in Variables
- `{{USER_MESSAGE}}` - Automatically replaced with the message you provide

### Custom Variables
Define custom variables in your prompt text using `{{VAR_NAME}}` syntax.
Pass values when injecting:

```bash
/prompts inject <name> "user message" VAR1=value1 VAR2=value2
```

**Example prompt:**
```
Research {{TOPIC}} by checking {{SOURCE}}.
User request: {{USER_MESSAGE}}
```

**Usage:**
```bash
/prompts inject research-template "find best practices" TOPIC=authentication SOURCE=official-docs
```

## Prompt Schema

Each prompt includes:
- `name` - Unique identifier
- `description` - What the prompt does
- `prompt` - The actual prompt text
- `tags` - Array of categorization tags
- `notes` - Optional usage notes
- `usageCount` - How many times it's been used
- `lastUsed` - Timestamp of last usage
- `variables` - Detected variables in prompt text
- `createdAt` - Creation timestamp
- `updatedAt` - Last modification timestamp

## Workflow Examples

### Example 1: Quick Research
```bash
# Store a research prompt
/prompts store quick-research "Fast web + local doc research" --tags research

# Use it
/prompts quick-research "latest Vue 3 patterns"
```

### Example 2: Bug Investigation
```bash
# Preview before using
/prompts preview bug-fix "hydration mismatch in SSR"

# If looks good, inject it
/prompts bug-fix "hydration mismatch in SSR"
```

### Example 3: Team Workflow
```bash
# Store project-level prompt for team
/prompts store code-review "Standard code review checklist" --scope project --tags review,team

# Anyone on team can now use it
/prompts code-review "review my latest changes"
```

### Example 4: Find the Right Prompt
```bash
# Search for debugging prompts
/prompts search debug

# Filter by tag
/prompts filter --tag security

# Check usage stats to find most useful
/prompts stats
```

## Implementation

Now let me parse your command and route to the appropriate action:

**Parsing arguments:**
- Subcommand: $1
- Arguments: $2, $3, $4, ...

**Routing logic:**

1. **If subcommand is a known prompt name:**
   - Check if prompt exists
   - Inject prompt text + user message
   - Execute in Claude

2. **If subcommand is a management command:**
   - Route to prompts-manager.sh script
   - Handle CRUD operations
   - Return results to user

3. **Default (no args or 'list'):**
   - Show available prompts

Let me execute the appropriate action based on your input.

---

## Actual Execution

I'll now check what subcommand you provided and execute accordingly.

**Step 1: Detect subcommand type**

If `$1` matches: list, search, filter, store, delete, preview, stats, export, import
→ Run: `bash ~/.claude/scripts/prompts-manager.sh $1 $2 $3 ...`

Otherwise, treat `$1` as a prompt name:
→ Run: `bash ~/.claude/scripts/prompts-manager.sh inject $1 "$2 $3 $4 ..."`

**Step 2: Execute and return results**

The script will handle:
- Loading and merging prompts
- Performing the requested operation
- Updating analytics if injecting
- Returning formatted output

**Step 3: If injecting a prompt, use the output**

When injecting a prompt, the script returns the substituted prompt text.
I'll then use that text as if the user had typed it directly.

---

Let me now execute based on your arguments:

```bash
bash ~/.claude/scripts/prompts-manager.sh $ARGUMENTS
```

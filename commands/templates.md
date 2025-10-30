---
description: Discover, list, and retrieve templates for documentation, planning, and components
tags: [project, gitignored]
---

# Template System

Execute the templates.sh script with user arguments to manage templates.

## Usage

The user invoked: `/templates $ARGUMENTS`

Parse `$ARGUMENTS` to determine the command and pass to the script:

- If no arguments or "help": Show help
- If "list" [category]: List templates (optionally filtered by category)
- If "retrieve" <id>: Retrieve and display template content
- If "search" <query>: Search templates by keywords
- If "categories": List available categories
- If "info" <id>: Show detailed template information
- If "config": Show how to add/edit templates

## Execution

Run: `~/.claude/scripts/templates.sh <command> [args]`

Then present the output to the user in a clear, formatted way.

## Special Handling

### For "retrieve" command:
After displaying the template, ask the user if they want to:
1. Use this template directly (you'll help fill it in)
2. Save to a specific location
3. Just view it for reference

### For "list" command:
Present results in organized format with clear categories and descriptions.

### For "config" command:
Display the configuration guide and offer to help the user add a new template if they want.

## Examples

- `/templates` or `/templates help` → Show help message
- `/templates list` → List all templates by category
- `/templates list planning` → List only planning templates
- `/templates retrieve feature-plan` → Display feature-plan template
- `/templates search component` → Search for component-related templates
- `/templates info vue-component` → Show details about vue-component template
- `/templates config` → Show how to add/edit templates

## Error Handling

If the script returns an error (missing jq, registry not found, etc.), clearly communicate the issue to the user and suggest resolution steps.

## Follow-up Actions

After showing a template, proactively offer to:
- Help the user fill in the template for their specific use case
- Create a new file based on the template
- Explain any sections of the template they're unsure about

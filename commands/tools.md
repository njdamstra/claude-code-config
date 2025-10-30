---
name: tools  
description: List all available tools (MCPs, skills, agents, commands, hooks, plugins, output styles) with optional category filtering
argument-hint: [category]
---

# Tools Discovery Command

## Instructions

Execute the list-tools script and then create a formatted summary of the results as your own text (not tool output):

```bash
~/.claude/scripts/list-tools.sh $ARGUMENTS
```

**Critical**: After reading the script output, compose your response as follows:

1. Start with the header box
2. For each category, show:
   - Category icon and name
   - Count of items
   - First 5-10 items with brief descriptions
   - "... and X more" if there are additional items
3. End with the summary statistics

**Format your response as regular conversation text**, embedding the results directly so they appear immediately without any "ctrl+o to expand" sections.

## Example Response Format

```
╔═══════════════════════════════════╗
║  CLAUDE CODE TOOLS DIRECTORY      ║
╚═══════════════════════════════════╝

🎯 AGENT SKILLS (17 total)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• cc-mastery - Claude Code ecosystem architecture
• vue-component-builder - Build Vue 3 components  
• typescript-fixer - Fix TypeScript errors
• nanostore-builder - State management patterns
• astro-routing - Astro pages and API routes
... and 12 more

[Continue for each category]

SUMMARY: 110 total capabilities discovered
```

Use this condensed format to keep output under 100 lines so it displays fully.

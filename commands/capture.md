---
argument-hint: [title] [--tags <tags>]
description: Quickly capture insights from current conversation without interrupting flow
---

# /capture - Quick Insight Capture

**Usage:** `/capture [title]`

Quickly capture insights from the current conversation without interrupting your flow.

## Examples

```bash
# Capture with title
/capture "jwt refresh token pattern"

# Capture without title (will prompt)
/capture

# Capture and tag
/capture "vue ssr gotcha" --tags vue,ssr,gotcha
```

## What This Command Does

1. **Analyzes recent conversation** (last 10-15 messages)
2. **Extracts key insights** using insight-extractor agent
3. **Saves to active/ folder** with timestamp
4. **Prompts to promote** to knowledge/ if valuable

## Why Use Capture Instead of Learn?

| Feature | `/capture` | `/learn` |
|---------|-----------|----------|
| **Speed** | Instant | Slower (more thorough) |
| **Location** | `active/` | `knowledge/` |
| **Processing** | Lightweight | Comprehensive |
| **Use Case** | Quick notes | Permanent knowledge |
| **Follow-up** | Manual review | Auto-indexed |

**Use `/capture` when:**
- In the middle of coding
- Don't want to break flow
- Quick "note to self"
- Will organize later

**Use `/learn` when:**
- Ready to document properly
- Want searchable knowledge
- Creating reference material
- Done with feature

## Implementation

Please execute the following steps when this command is run:

### Step 1: Parse Arguments
```typescript
const args = parseArgs(input);
const title = args.title || await promptUser("What's this insight about?");
const tags = args.tags ? args.tags.split(',') : [];
```

### Step 2: Get Recent Context
```typescript
// Get last 10-15 messages from conversation
const messages = getRecentMessages(15);

// Filter for meaningful content (skip tool outputs, short messages)
const meaningfulMessages = messages.filter(m =>
  m.content.length > 50 &&
  !m.isToolOutput &&
  !m.isSystemMessage
);

const context = meaningfulMessages.map(m => m.content).join('\n\n');
```

### Step 3: Quick Extract
```typescript
// Spawn insight-extractor agent with "quick mode"
const insights = await spawnAgent('insight-extractor', {
  context,
  mode: 'quick', // Faster, less thorough
  focusOn: title // What to focus extraction on
});

// If no insights extracted, create placeholder
if (insights.length === 0) {
  insights.push({
    title,
    type: 'discovery',
    confidence: 'low',
    tags,
    content: context.slice(0, 500) // First 500 chars as placeholder
  });
}
```

### Step 4: Create Capture File
```typescript
const timestamp = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
const slug = slugify(title);
const capturePath = `claude-docs/active/${timestamp}-${slug}`;

// Create folder
await mkdir(capturePath);

// Save capture
await writeFile(
  `${capturePath}/capture.md`,
  `# ${title}

**Captured:** ${new Date().toISOString()}
**Tags:** ${tags.join(', ') || 'untagged'}
**Status:** 📝 To Review

---

${insights.map(i => formatInsight(i)).join('\n\n---\n\n')}

---

## Original Context

<details>
<summary>View conversation excerpt</summary>

${context}

</details>

---

## Next Steps

- [ ] Review and refine this insight
- [ ] Add code examples if missing
- [ ] Move to appropriate knowledge/ topic with \`/learn\`
- [ ] Or archive if not valuable
`
);
```

### Step 5: Prompt for Immediate Action (Optional)
```typescript
console.log(`
✅ Captured: ${title}

**Saved to:** ${capturePath}/capture.md
**Insights:** ${insights.length}

**Do you want to promote to knowledge/ now?** (y/n)
`);

const shouldPromote = await confirm();

if (shouldPromote) {
  // Ask which topic
  const topic = await promptUser(
    "Which topic should this belong to?",
    suggestTopicFromTags(tags)
  );

  // Run /learn on the capture file
  await runCommand(`/learn ${topic} --from-file ${capturePath}/capture.md`);

  // Archive the capture
  await moveToArchive(capturePath);
} else {
  console.log(`
💡 Review later:
- \`Read ${capturePath}/capture.md\`
- \`/learn [topic] --from-file ${capturePath}/capture.md\`
  `);
}
```

### Step 6: Report Results
```typescript
console.log(`
✅ Insight captured!

**File:** ${capturePath}/capture.md
**Insights:** ${insights.length}
**Tags:** ${tags.join(', ')}

**To organize later:**
\`\`\`bash
# Review capture
Read ${capturePath}/capture.md

# Promote to knowledge
/learn [topic-name] --from-file ${capturePath}/capture.md

# Or delete if not useful
rm -rf ${capturePath}
\`\`\`

**Continue your work!** 🚀
`);
```

## Capture Format

Captures are saved in this structure:

```
active/
└── 2025-01-06-jwt-refresh-pattern/
    └── capture.md          # The captured insight
```

The capture.md file contains:
- Title and metadata
- Extracted insights
- Original conversation context (collapsed)
- Next steps checklist

## Batch Review Workflow

When you have multiple captures to review:

```bash
# List all captures
ls -la claude-docs/active/*/capture.md

# Review each one
for file in claude-docs/active/*/capture.md; do
  echo "Reviewing: $file"
  Read "$file"

  # Decide: promote, archive, or delete
done
```

Or use the knowledge-organizer agent:

```bash
# Review all captures and suggest organization
Task .claude/agents/knowledge-organizer.md \
  "Review all captures in active/ and suggest which topics they belong to"
```

## Error Handling

```typescript
// No meaningful conversation
if (meaningfulMessages.length < 3) {
  console.log(`
⚠️  Not enough conversation context to capture

**Need at least 3 meaningful messages.**

Current messages: ${meaningfulMessages.length}

**Try:**
- Have a longer conversation first
- Use \`/learn --from-code\` to extract from files
- Manually create insight in knowledge/
  `);
  return;
}

// Invalid title
if (!title || title.length < 3) {
  console.log(`
❌ Title too short: "${title}"

**Requirements:**
- At least 3 characters
- Descriptive of the insight
- Example: "vue ssr dom access pattern"
  `);
  return;
}
```

## Integration with Other Commands

### With `/learn`
```bash
# Capture quick note
/capture "authentication flow"

# Later, promote to knowledge
/learn auth --from-file active/2025-01-06-authentication-flow/capture.md
```

### With `/checkpoint`
```bash
# Capture multiple insights during work
/capture "insight 1"
/capture "insight 2"
/capture "insight 3"

# At checkpoint, review and organize all
/checkpoint  # Prompts to organize captures
```

### With `/complete`
```bash
# When completing feature
/complete user-auth  # Automatically processes captures
```

## Pro Tips

1. **Capture Often** - Don't wait for "perfect" insights
2. **Tag Immediately** - Tags help with later organization
3. **Review Weekly** - Process captures in batch
4. **Delete Freely** - Not every capture needs to be permanent
5. **Use Placeholders** - Better to capture something than nothing

## Implementation Location

This command should be implemented as a bash script that:
1. Gets recent conversation messages
2. Spawns insight-extractor in quick mode
3. Writes to active/ directory
4. Optionally prompts for immediate promotion
5. Returns to user's work quickly

The script will be triggered when user types `/capture [args]` in Claude Code.

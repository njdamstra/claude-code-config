---
argument-hint: [topic] [--from-code] [--from-web] [--from-file <path>]
description: Extract insights from various sources and store in knowledge base
---

# /learn - Extract and Store Knowledge

**Usage:** `/learn [topic] [--from-code] [--from-web]`

Extract insights from various sources and store them in the knowledge base.

## Examples

```bash
# Extract from current conversation
/learn authentication

# Extract from codebase
/learn "vue composition patterns" --from-code

# Research web and extract
/learn "jwt security best practices" --from-web

# Extract from specific file
/learn animations --from-file AnimationPlan.md
```

## What This Command Does

1. **Analyzes source** based on flags:
   - No flag: Current conversation (last 10-15 messages)
   - `--from-code`: Scans codebase for patterns related to topic
   - `--from-web`: Searches web, scrapes docs, extracts insights
   - `--from-file [path]`: Extracts from specific file

2. **Spawns insight-extractor agent** to identify:
   - Patterns and best practices
   - Gotchas and pitfalls
   - Technical decisions
   - Discoveries and learnings

3. **Creates/updates topic folder:**
   ```
   claude-docs/knowledge/[topic]/
   ├── insights.md     # Appends new insights
   ├── gotchas.md      # Appends new gotchas
   └── procedures.md   # Appends new procedures
   ```

4. **Updates INDEX.md** with new topic entry and tags

5. **Suggests `/reindex`** to update search database

## Implementation

Please execute the following steps when this command is run:

### Step 1: Parse Arguments
```typescript
const args = parseArgs(input);
const topic = args.topic || promptUser("What topic to learn about?");
const source = args.fromCode ? 'code' : args.fromWeb ? 'web' : args.fromFile || 'conversation';
```

### Step 2: Gather Source Material
```typescript
if (source === 'conversation') {
  // Get last 10-15 messages from conversation history
  const context = getRecentMessages(15);
}

if (source === 'code') {
  // Search codebase for topic-related files
  const files = await searchCodebase(topic);
  // Read relevant files
  const context = await Promise.all(files.map(f => readFile(f)));
}

if (source === 'web') {
  // Use WebSearch or Firecrawl to research topic
  const results = await searchWeb(topic);
  const context = await scrapeRelevantPages(results);
}

if (typeof source === 'string' && source.endsWith('.md')) {
  // Read specific file
  const context = await readFile(source);
}
```

### Step 3: Extract Insights
```typescript
// Spawn insight-extractor agent
const insights = await spawnAgent('insight-extractor', {
  context,
  topic,
  source
});

// Agent returns structured insights in markdown format
```

### Step 4: Organize by Type
```typescript
const organized = {
  insights: insights.filter(i => i.type === 'pattern' || i.type === 'discovery'),
  gotchas: insights.filter(i => i.type === 'gotcha'),
  procedures: insights.filter(i => i.type === 'decision' || i.hasSteps)
};
```

### Step 5: Create/Update Topic Folder
```typescript
const topicPath = `claude-docs/knowledge/${slugify(topic)}`;

// Create folder if doesn't exist
if (!exists(topicPath)) {
  await mkdir(topicPath);
  await createTemplateFiles(topicPath);
}

// Append insights to appropriate files
if (organized.insights.length > 0) {
  await appendFile(
    `${topicPath}/insights.md`,
    `\n\n---\n\n${organized.insights.join('\n\n---\n\n')}`
  );
}

if (organized.gotchas.length > 0) {
  await appendFile(
    `${topicPath}/gotchas.md`,
    `\n\n---\n\n${organized.gotchas.join('\n\n---\n\n')}`
  );
}

if (organized.procedures.length > 0) {
  await appendFile(
    `${topicPath}/procedures.md`,
    `\n\n---\n\n${organized.procedures.join('\n\n---\n\n')}`
  );
}
```

### Step 6: Update INDEX.md
```typescript
// Read current INDEX.md
const index = await readFile('claude-docs/knowledge/INDEX.md');

// Extract tags from insights
const tags = [...new Set(insights.flatMap(i => i.tags))];

// Add entry if topic doesn't exist
if (!index.includes(`### ${topic}`)) {
  const entry = `
### ${topic}
**Tags:** ${tags.join(', ')}
**Last Updated:** ${new Date().toISOString().split('T')[0]}
**Files:** insights.md, gotchas.md, procedures.md
**Description:** ${generateDescription(insights)}
`;

  await appendToSection(index, '## Active Topics', entry);
}
```

### Step 7: Report Results
```typescript
console.log(`
✅ Learned about: ${topic}

**Extracted:**
- ${organized.insights.length} insights
- ${organized.gotchas.length} gotchas
- ${organized.procedures.length} procedures

**Saved to:** claude-docs/knowledge/${slugify(topic)}/

**Next steps:**
- Run \`/reindex\` to update search database
- Use \`/recall ${topic}\` to load insights into context
`);
```

## Error Handling

```typescript
// No insights extracted
if (insights.length === 0) {
  console.log(`
⚠️  No insights extracted from ${source}

**Try:**
- Use \`--from-code\` to search codebase
- Use \`--from-web\` to research online
- Provide more context in conversation
  `);
  return;
}

// Invalid topic name
if (!isValidTopicName(topic)) {
  console.log(`
❌ Invalid topic name: "${topic}"

**Requirements:**
- Lowercase with hyphens
- No special characters
- Example: "vue-composition-api"
  `);
  return;
}
```

## Integration with Agents

This command **spawns the insight-extractor agent**:
```bash
Task /path/to/.claude/agents/insight-extractor.md
```

The agent receives:
- Context material (code/docs/conversation)
- Topic name for categorization
- Source type (affects extraction strategy)

The agent returns:
- Structured markdown insights
- Proper formatting and metadata
- Tagged and categorized

## Implementation Location

This command should be implemented as a bash script that:
1. Parses arguments with `$1`, `$2`, etc.
2. Calls appropriate tools (Read, Grep, WebSearch)
3. Spawns insight-extractor agent via Task tool
4. Writes to knowledge/ directory
5. Updates INDEX.md
6. Reports results

The script will be triggered when user types `/learn [args]` in Claude Code.

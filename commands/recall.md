---
argument-hint: [topic] [--depth shallow|deep]
description: Load relevant documentation into Claude's context for current session
---

# /recall - Load Knowledge into Context

**Usage:** `/recall [topic] [--depth shallow|deep]`

Load relevant documentation into Claude's context for the current session.

## Examples

```bash
# Load topic with default depth (shallow)
/recall authentication

# Load just core files
/recall "vue composition" --depth shallow

# Load topic + related topics
/recall animations --depth deep

# Load multiple topics
/recall auth database api
```

## What This Command Does

1. **Searches for topic** in knowledge base using doc-searcher agent
2. **Loads files** based on depth:
   - **Shallow**: insights.md + procedures.md
   - **Deep**: All files in topic + related topics
3. **Checks active/** for current work on this topic
4. **Returns summary** of loaded content

## Depth Levels

### Shallow (Default)
Loads only core files:
- `knowledge/[topic]/insights.md`
- `knowledge/[topic]/procedures.md`

**Use when:**
- Quick reference needed
- Context window is tight
- You know exactly what you need

### Deep
Loads comprehensive content:
- All files in `knowledge/[topic]/`
- Related topics (via tags)
- Relevant architecture docs
- Active work if exists

**Use when:**
- Implementing complex feature
- Need full context
- Exploring unfamiliar area

## Implementation

Please execute the following steps when this command is run:

### Step 1: Parse Arguments
```typescript
const args = parseArgs(input);
const topics = args.topics || []; // Can handle multiple topics
const depth = args.depth || 'shallow';
```

### Step 2: Search for Topics
```typescript
// Spawn doc-searcher agent to find relevant files
const searchResults = await spawnAgent('doc-searcher', {
  query: topics.join(' OR '),
  scope: ['knowledge/', 'architecture/']
});

// Agent returns ranked file paths
const files = searchResults.matches.map(m => m.filePath);
```

### Step 3: Check Active Work
```typescript
// Check if there's active work on this topic
for (const topic of topics) {
  const activeFiles = await glob(`claude-docs/active/*${topic}*/*.md`);

  if (activeFiles.length > 0) {
    console.log(`
📝 Found active work on ${topic}:
${activeFiles.map(f => `  - ${f}`).join('\n')}
    `);

    // Optionally add to files to load
    files.push(...activeFiles);
  }
}
```

### Step 4: Load Files Based on Depth
```typescript
let filesToLoad = [];

if (depth === 'shallow') {
  // Load only insights.md and procedures.md
  filesToLoad = files.filter(f =>
    f.endsWith('/insights.md') || f.endsWith('/procedures.md')
  );
}

if (depth === 'deep') {
  // Load all files in topic folders
  filesToLoad = files;

  // Add related topics via tags
  const tags = await getTagsFromFiles(files);
  const relatedTopics = await findTopicsByTags(tags);

  for (const relatedTopic of relatedTopics) {
    const relatedFiles = await glob(`claude-docs/knowledge/${relatedTopic}/*.md`);
    filesToLoad.push(...relatedFiles);
  }

  // Add relevant architecture docs
  const architectureFiles = await glob('claude-docs/architecture/*.md');
  filesToLoad.push(...architectureFiles);
}

// Remove duplicates
filesToLoad = [...new Set(filesToLoad)];
```

### Step 5: Load and Display Content
```typescript
// Read all files
const contents = await Promise.all(
  filesToLoad.map(async (path) => {
    const content = await readFile(path);
    return { path, content };
  })
);

// Display each file with clear separation
for (const { path, content } of contents) {
  console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 ${path}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

${content}

  `);
}
```

### Step 6: Update Recent Access
```typescript
// Track which files were accessed for future optimization
const recentPath = 'claude-docs/.index/recent.json';
const recent = await readJSON(recentPath) || {};

for (const file of filesToLoad) {
  recent[file] = {
    lastAccessed: new Date().toISOString(),
    accessCount: (recent[file]?.accessCount || 0) + 1
  };
}

await writeJSON(recentPath, recent);
```

### Step 7: Provide Summary
```typescript
console.log(`
✅ Loaded knowledge about: ${topics.join(', ')}

**Files Loaded:** ${filesToLoad.length}
- Insights: ${filesToLoad.filter(f => f.includes('/insights.md')).length}
- Gotchas: ${filesToLoad.filter(f => f.includes('/gotchas.md')).length}
- Procedures: ${filesToLoad.filter(f => f.includes('/procedures.md')).length}
- Architecture: ${filesToLoad.filter(f => f.includes('architecture/')).length}
- Active Work: ${filesToLoad.filter(f => f.includes('active/')).length}

**Depth:** ${depth}
${depth === 'shallow' ? '\n💡 Use `--depth deep` for related topics and architecture docs' : ''}

**Next steps:**
- Reference loaded insights while coding
- Use \`/capture\` to add new learnings
- Use \`/checkpoint\` to save progress
`);
```

## Priority Order

When loading files, use this priority:

1. **Active work** (most recent, most relevant)
2. **Topic insights** (core patterns)
3. **Topic procedures** (how-to guides)
4. **Topic gotchas** (avoid mistakes)
5. **Related topics** (deeper context)
6. **Architecture docs** (system-wide patterns)

## Error Handling

```typescript
// Topic not found
if (files.length === 0) {
  console.log(`
⚠️  No knowledge found for: ${topics.join(', ')}

**Suggestions:**
- Check spelling: Use \`/recall --help\` to see available topics
- Create knowledge: Use \`/learn ${topics[0]}\` to extract insights
- Search broader: Try related terms

**Available Topics:**
${await listAllTopics()}
  `);
  return;
}

// Too many files (context overflow warning)
if (filesToLoad.length > 20) {
  console.log(`
⚠️  Found ${filesToLoad.length} files (may exceed context limit)

**Options:**
1. Use \`--depth shallow\` to load fewer files
2. Be more specific with topic name
3. Load in batches (split topics across multiple /recall calls)

**Proceed anyway?** (y/n)
  `);

  if (!await confirm()) {
    return;
  }
}
```

## Integration with Agents

This command **spawns the doc-searcher agent**:
```bash
Task /path/to/.claude/agents/doc-searcher.md
```

The agent receives:
- Query string (topic names)
- Search scope (knowledge/, architecture/)
- Options (limit, ranking strategy)

The agent returns:
- Ranked file paths
- Snippets for preview
- Related topics suggestions
- Tag mappings

## Token Optimization

To avoid context overflow:

1. **Shallow by default** - Only load core files
2. **Summarize long files** - Show first N lines + headings
3. **Lazy loading** - Load related topics only if requested
4. **Cache recent** - Track frequently accessed files

```typescript
// Smart truncation for long files
if (content.length > 10000) {
  const summary = extractHeadings(content);
  console.log(`
📄 ${path} (truncated - ${content.length} chars)

${summary}

💡 Full content available, use Read tool if needed: ${path}
  `);
}
```

## Implementation Location

This command should be implemented as a bash script that:
1. Parses arguments (`$1`, `$2`, `--depth`)
2. Spawns doc-searcher agent
3. Reads relevant files
4. Displays formatted content
5. Updates recent access tracking
6. Provides helpful summary

The script will be triggered when user types `/recall [args]` in Claude Code.

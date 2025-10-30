---
argument-hint: [--force] [--verbose]
description: Rebuild SQLite FTS5 search database and JSON tag mappings from markdown files
---

# /reindex - Rebuild Search Database

**Usage:** `/reindex [--force]`

Rebuild the SQLite FTS5 search database and JSON tag mappings from markdown files.

## Examples

```bash
# Standard reindex
/reindex

# Force rebuild even if recent
/reindex --force

# Reindex with progress
/reindex --verbose
```

## What This Command Does

1. **Deletes** existing `.index/search.db` (SQL is disposable)
2. **Scans** all markdown files in `knowledge/` and `architecture/`
3. **Builds** fresh SQLite FTS5 full-text search index
4. **Extracts** tags from all files → `tags.json`
5. **Updates** recent access log → `recent.json`

## When to Run

### Automatically
- After `/learn` adds new knowledge
- After moving/renaming topics
- If search.db is missing or corrupted

### Manually
- Weekly maintenance
- After bulk edits
- When search results seem stale
- Before important context loading

## Implementation

Please execute the following steps when this command is run:

### Step 1: Check if Needed
```typescript
const indexPath = 'claude-docs/.index/search.db';
const args = parseArgs(input);

// Check last reindex time
const lastReindex = await getLastModified(indexPath);
const hoursSinceReindex = (Date.now() - lastReindex) / (1000 * 60 * 60);

if (hoursSinceReindex < 1 && !args.force) {
  console.log(`
⏭️  Reindex not needed

Last indexed: ${formatRelativeTime(lastReindex)}

**Use \`--force\` to rebuild anyway**
  `);
  return;
}
```

### Step 2: Delete Old Index
```typescript
console.log('🗑️  Removing old index...');

if (await exists(indexPath)) {
  await rm(indexPath);
}

// Clean up any temp files
await rm('claude-docs/.index/*.tmp');
```

### Step 3: Scan Markdown Files
```typescript
console.log('📂 Scanning markdown files...');

// Get all .md files in knowledge/ and architecture/
const files = await glob([
  'claude-docs/knowledge/**/*.md',
  'claude-docs/architecture/**/*.md'
]);

console.log(`Found ${files.length} files to index`);
```

### Step 4: Create SQLite Database
```typescript
console.log('💾 Creating SQLite FTS5 database...');

// Create Node.js script to build SQLite database
const dbScript = `
const sqlite3 = require('better-sqlite3');
const fs = require('fs');

const db = sqlite3('${indexPath}');

// Create FTS5 table
db.exec(\`
  CREATE VIRTUAL TABLE fts_docs USING fts5(
    file_path UNINDEXED,
    content,
    tags UNINDEXED,
    title UNINDEXED,
    date UNINDEXED,
    tokenize = 'porter'
  )
\`);

const insert = db.prepare(\`
  INSERT INTO fts_docs (file_path, content, tags, title, date)
  VALUES (?, ?, ?, ?, ?)
\`);

// Process each file
const files = ${JSON.stringify(files)};

for (const file of files) {
  const content = fs.readFileSync(file, 'utf-8');

  // Extract metadata
  const metadata = extractMetadata(content);

  insert.run(
    file,
    content,
    metadata.tags?.join(', ') || '',
    metadata.title || file,
    metadata.date || ''
  );

  if (files.indexOf(file) % 10 === 0) {
    console.log(\`Indexed \${files.indexOf(file) + 1}/\${files.length} files...\`);
  }
}

db.close();
console.log('✅ Database created');

function extractMetadata(content) {
  const tags = content.match(/\\*\\*Tags:\\*\\* (.+)/)?.[1]?.split(',').map(t => t.trim()) || [];
  const title = content.match(/^# (.+)/m)?.[1] || '';
  const date = content.match(/\\*\\*Date.*:\\*\\* (\\d{4}-\\d{2}-\\d{2})/)?.[1] || '';

  return { tags, title, date };
}
`;

// Write and execute script
await writeFile('claude-docs/.index/build-db.js', dbScript);
await exec('node claude-docs/.index/build-db.js');
```

### Step 5: Build Tag Mappings
```typescript
console.log('🏷️  Building tag mappings...');

const tagMap = new Map<string, Set<string>>();

for (const file of files) {
  const content = await readFile(file);
  const tags = extractTags(content);

  for (const tag of tags) {
    if (!tagMap.has(tag)) {
      tagMap.set(tag, new Set());
    }
    tagMap.get(tag).add(file);
  }
}

// Convert to JSON-friendly format
const tagMappings = {};
for (const [tag, files] of tagMap.entries()) {
  tagMappings[tag] = Array.from(files);
}

await writeFile(
  'claude-docs/.index/tags.json',
  JSON.stringify(tagMappings, null, 2)
);

console.log(`Mapped ${tagMap.size} unique tags`);
```

### Step 6: Update Recent Access
```typescript
console.log('⏰ Updating access log...');

// Preserve existing recent.json if exists
let recent = {};
if (await exists('claude-docs/.index/recent.json')) {
  recent = await readJSON('claude-docs/.index/recent.json');
}

// Add reindex timestamp
recent.__lastReindex = new Date().toISOString();

await writeJSON('claude-docs/.index/recent.json', recent);
```

### Step 7: Report Results
```typescript
// Get database stats
const stats = await getDBStats(indexPath);

console.log(`
✅ Reindex complete!

**Database Stats:**
- Files indexed: ${stats.fileCount}
- Total words: ${stats.wordCount.toLocaleString()}
- Unique tags: ${Object.keys(tagMappings).length}
- Database size: ${formatBytes(stats.dbSize)}
- Index time: ${stats.duration}ms

**Files:**
${indexPath}
claude-docs/.index/tags.json
claude-docs/.index/recent.json

**Test search:**
\`/recall [topic]\` - Should be faster now!
`);
```

## Performance Benchmarks

Expected performance:
- **100 files**: ~2-3 seconds
- **500 files**: ~10-15 seconds
- **1000 files**: ~30-40 seconds

Rate: ~100 files/second

## Database Schema

The SQLite FTS5 table structure:

```sql
CREATE VIRTUAL TABLE fts_docs USING fts5(
  file_path UNINDEXED,     -- Full path to file
  content,                  -- Full markdown content (indexed)
  tags UNINDEXED,          -- Comma-separated tags
  title UNINDEXED,         -- Document title
  date UNINDEXED,          -- Date added/modified
  tokenize = 'porter'      -- Porter stemming for better matching
);
```

**Indexed columns:** `content` only (for full-text search)
**Unindexed columns:** Metadata for filtering/display

## Tag Extraction

Tags are extracted from these patterns:

```markdown
**Tags:** tag1, tag2, tag3
**Tags**: tag1, tag2
Tags: tag1, tag2
#tag1 #tag2
```

Multiple formats supported for flexibility.

## Error Handling

```typescript
// SQLite not installed
try {
  await exec('which sqlite3');
} catch (err) {
  console.log(`
❌ SQLite not found

**Install SQLite:**
\`\`\`bash
# macOS
brew install sqlite3

# Ubuntu/Debian
sudo apt-get install sqlite3

# Or use better-sqlite3 npm package
npm install better-sqlite3
\`\`\`
  `);
  return;
}

// No files found
if (files.length === 0) {
  console.log(`
⚠️  No markdown files found in knowledge/ or architecture/

**Check:**
- Are you in the project root?
- Does claude-docs/ directory exist?
- Have you run \`/learn\` to create knowledge?
  `);
  return;
}

// Permission errors
try {
  await mkdir('claude-docs/.index');
} catch (err) {
  console.log(`
❌ Cannot write to claude-docs/.index/

**Error:** ${err.message}

**Fix:** Check directory permissions
  `);
  return;
}
```

## Optimization Strategies

### For Large Knowledge Bases (1000+ files)

1. **Incremental Indexing**
   - Only reindex changed files
   - Track file hashes
   - Partial rebuilds

2. **Parallel Processing**
   ```typescript
   const chunks = chunkArray(files, 100);
   await Promise.all(chunks.map(processChunk));
   ```

3. **Progress Reporting**
   ```typescript
   const progress = new ProgressBar(files.length);
   for (const file of files) {
     await indexFile(file);
     progress.tick();
   }
   ```

## Dependency: Node.js SQLite Library

This command requires `better-sqlite3` npm package:

```bash
# Install if needed
npm install better-sqlite3
```

Add to project `package.json`:
```json
{
  "dependencies": {
    "better-sqlite3": "^9.0.0"
  }
}
```

## Testing the Index

After reindex, test with:

```bash
# Test exact match
sqlite3 claude-docs/.index/search.db \
  "SELECT file_path FROM fts_docs WHERE fts_docs MATCH 'authentication' LIMIT 5"

# Test phrase match
sqlite3 claude-docs/.index/search.db \
  "SELECT file_path FROM fts_docs WHERE fts_docs MATCH '\"vue composition api\"' LIMIT 5"

# Test ranking
sqlite3 claude-docs/.index/search.db \
  "SELECT file_path, rank FROM fts_docs WHERE fts_docs MATCH 'pattern' ORDER BY rank LIMIT 10"
```

## Implementation Location

This command should be implemented as a bash script that:
1. Checks if reindex is needed (unless --force)
2. Creates Node.js script for SQLite operations
3. Executes the script to build database
4. Generates tag mappings JSON
5. Reports statistics and success

The script will be triggered when user types `/reindex` in Claude Code.

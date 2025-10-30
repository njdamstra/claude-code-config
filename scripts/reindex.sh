#!/bin/bash
# /reindex - Rebuild SQLite FTS5 search database and JSON tag mappings

set -e

# Parse arguments
FORCE=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --force)
      FORCE=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      echo "Usage: /reindex [--force] [--verbose]"
      exit 1
      ;;
  esac
done

# Configuration
PROJECT_ROOT="$PWD"
INDEX_DIR="$PROJECT_ROOT/claude-docs/.index"
DB_PATH="$INDEX_DIR/search.db"
TAGS_JSON="$INDEX_DIR/tags.json"
RECENT_JSON="$INDEX_DIR/recent.json"

# Check if we're in the right directory
if [ ! -d "$PROJECT_ROOT/claude-docs" ]; then
  echo "❌ Error: claude-docs/ directory not found"
  echo ""
  echo "Are you in the project root?"
  exit 1
fi

# Check if reindex is needed (unless --force)
if [ -f "$DB_PATH" ] && [ "$FORCE" = false ]; then
  # Get last modified time of database
  if [ "$(uname)" = "Darwin" ]; then
    # macOS
    LAST_MODIFIED=$(stat -f "%m" "$DB_PATH")
  else
    # Linux
    LAST_MODIFIED=$(stat -c "%Y" "$DB_PATH")
  fi

  CURRENT_TIME=$(date +%s)
  HOURS_SINCE=$((($CURRENT_TIME - $LAST_MODIFIED) / 3600))

  if [ $HOURS_SINCE -lt 1 ]; then
    echo "⏭️  Reindex not needed"
    echo ""
    echo "Last indexed: $HOURS_SINCE hour(s) ago"
    echo ""
    echo "**Use \`--force\` to rebuild anyway**"
    exit 0
  fi
fi

echo "🗑️  Removing old index..."
rm -f "$DB_PATH"
rm -f "$INDEX_DIR"/*.tmp

echo "📂 Scanning markdown files..."

# Find all markdown files
cd "$PROJECT_ROOT"
FILES=$(find claude-docs/knowledge claude-docs/architecture -name "*.md" 2>/dev/null | sort)
FILE_COUNT=$(echo "$FILES" | wc -l | tr -d ' ')

if [ $FILE_COUNT -eq 0 ]; then
  echo "⚠️  No markdown files found in knowledge/ or architecture/"
  echo ""
  echo "**Check:**"
  echo "- Are you in the project root?"
  echo "- Does claude-docs/ directory exist?"
  echo "- Have you run \`/extract\` to create knowledge?"
  exit 1
fi

echo "Found $FILE_COUNT files to index"
echo ""

# Create Node.js reindex script
cat > "$INDEX_DIR/reindex.js" << 'NODEJS_SCRIPT'
const fs = require('fs');
const path = require('path');

const INDEX_DIR = process.env.INDEX_DIR;
const DB_PATH = process.env.DB_PATH;
const TAGS_JSON = process.env.TAGS_JSON;
const RECENT_JSON = process.env.RECENT_JSON;
const FILES = process.env.FILES.split('\n').filter(f => f.trim());
const VERBOSE = process.env.VERBOSE === 'true';

let Database;
try {
  Database = require('better-sqlite3');
} catch (err) {
  console.log('❌ better-sqlite3 not installed');
  console.log('');
  console.log('**Install with:**');
  console.log('```bash');
  console.log('cd ~/.claude');
  console.log('npm install better-sqlite3');
  console.log('```');
  process.exit(1);
}

// Helper to extract metadata from markdown content
function extractMetadata(content) {
  const lines = content.split('\n');

  // Extract tags
  const tagPatterns = [
    /\*\*Tags:\*\*\s*(.+)/,
    /\*\*Tags\*\*:\s*(.+)/,
    /Tags:\s*(.+)/,
  ];

  let tags = [];
  for (const pattern of tagPatterns) {
    const match = content.match(pattern);
    if (match) {
      tags = match[1].split(',').map(t => t.trim()).filter(t => t);
      break;
    }
  }

  // Also extract hashtags
  const hashtagMatches = content.match(/#(\w+)/g);
  if (hashtagMatches) {
    const hashtags = hashtagMatches.map(h => h.slice(1));
    tags = [...new Set([...tags, ...hashtags])];
  }

  // Extract title (first # heading)
  const titleMatch = content.match(/^#\s+(.+)/m);
  const title = titleMatch ? titleMatch[1] : '';

  // Extract date
  const dateMatch = content.match(/\*\*Date.*:\*\*\s*(\d{4}-\d{2}-\d{2})/);
  const date = dateMatch ? dateMatch[1] : '';

  return { tags, title, date };
}

console.log('💾 Creating SQLite FTS5 database...');
console.log('');

// Create database
const db = new Database(DB_PATH);

// Enable WAL mode for better concurrent access
db.pragma('journal_mode = WAL');

// Create FTS5 table
db.exec(`
  CREATE VIRTUAL TABLE IF NOT EXISTS fts_docs USING fts5(
    file_path UNINDEXED,
    content,
    tags UNINDEXED,
    title UNINDEXED,
    date UNINDEXED,
    tokenize = 'porter'
  )
`);

// Prepare insert statement
const insert = db.prepare(`
  INSERT INTO fts_docs (file_path, content, tags, title, date)
  VALUES (?, ?, ?, ?, ?)
`);

// Tag mapping
const tagMap = new Map();

// Process files
const startTime = Date.now();
let processedCount = 0;

for (const file of FILES) {
  try {
    const content = fs.readFileSync(file, 'utf-8');
    const metadata = extractMetadata(content);

    // Insert into database
    insert.run(
      file,
      content,
      metadata.tags.join(', '),
      metadata.title,
      metadata.date
    );

    // Build tag map
    for (const tag of metadata.tags) {
      if (!tagMap.has(tag)) {
        tagMap.set(tag, []);
      }
      tagMap.get(tag).push(file);
    }

    processedCount++;

    if (VERBOSE && processedCount % 10 === 0) {
      console.log(`Indexed ${processedCount}/${FILES.length} files...`);
    }
  } catch (err) {
    console.error(`Failed to index ${file}: ${err.message}`);
  }
}

db.close();

const duration = Date.now() - startTime;

console.log('✅ Database created');
console.log('');

// Save tag mappings
console.log('🏷️  Building tag mappings...');

const tagMappings = {};
for (const [tag, files] of tagMap.entries()) {
  tagMappings[tag] = files;
}

fs.writeFileSync(TAGS_JSON, JSON.stringify(tagMappings, null, 2));

console.log(`Mapped ${tagMap.size} unique tags`);
console.log('');

// Update recent access log
console.log('⏰ Updating access log...');

let recent = {};
if (fs.existsSync(RECENT_JSON)) {
  try {
    recent = JSON.parse(fs.readFileSync(RECENT_JSON, 'utf-8'));
  } catch (err) {
    // Ignore parse errors
  }
}

recent.__lastReindex = new Date().toISOString();
fs.writeFileSync(RECENT_JSON, JSON.stringify(recent, null, 2));

console.log('');

// Get database size
const stats = fs.statSync(DB_PATH);
const dbSizeKB = (stats.size / 1024).toFixed(2);

// Calculate word count estimate
const avgWordsPerFile = 500; // rough estimate
const totalWords = processedCount * avgWordsPerFile;

// Report results
console.log('✅ Reindex complete!');
console.log('');
console.log('**Database Stats:**');
console.log(`- Files indexed: ${processedCount}`);
console.log(`- Total words: ~${totalWords.toLocaleString()}`);
console.log(`- Unique tags: ${tagMap.size}`);
console.log(`- Database size: ${dbSizeKB} KB`);
console.log(`- Index time: ${duration}ms`);
console.log('');
console.log('**Files:**');
console.log(`${DB_PATH}`);
console.log(`${TAGS_JSON}`);
console.log(`${RECENT_JSON}`);
console.log('');
console.log('**Test search:**');
console.log('`/recall [topic]` - Should be faster now!');

NODEJS_SCRIPT

# Export environment variables for Node.js script
export INDEX_DIR
export DB_PATH
export TAGS_JSON
export RECENT_JSON
export FILES="$FILES"
export VERBOSE

# Run the Node.js script
node "$INDEX_DIR/reindex.js"

# Clean up script
rm -f "$INDEX_DIR/reindex.js"

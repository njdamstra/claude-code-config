# Documentation Research Skill

Research official documentation, API references, and best practices for your tech stack using a cache-first, parallel execution strategy.

## Quick Usage

This skill automatically activates when you ask questions like:
- "How do I use Vue Suspense in Astro?"
- "What's the correct way to handle Appwrite auth in SSR?"
- "Show me Tailwind v4 dark mode best practices"
- "Find documentation for Zod schema validation"

## How It Works

### Three-Phase Workflow

1. **Phase 1: Cache Check** (Always first)
   - Searches `outputs/` for recent findings (< 60 days old)
   - If found: Uses cached documentation
   - If not found: Proceeds to Phase 2

2. **Phase 2: Parallel Research** (Only if cache insufficient)
   - **MCP Researcher:** Queries Context7 for official documentation
   - **Best Practice Researcher:** Searches web via Tavily for community patterns
   - Both run simultaneously for maximum speed

3. **Phase 3: Synthesis**
   - Combines all findings (cache + new research)
   - Creates comprehensive summary
   - Presents actionable insights

## Directory Structure

```
~/.claude/skills/doc-research/
├── SKILL.md                    # Main skill instructions
├── SITEMAP.md                  # Curated documentation sources
├── README.md                   # This file
└── outputs/                    # Cached research findings
    ├── README.md
    ├── doc_[topic]_YYYY-MM-DD.md    # Official documentation
    └── web_[topic]_YYYY-MM-DD.md    # Community patterns

~/.claude/agents/research/      # Specialized researcher agents
├── cache-researcher.md         # Cache discovery agent
├── mcp-researcher.md           # Official docs via MCP
└── best-practice-researcher.md # Web research via Tavily
```

## Tech Stack Covered

- **Frontend:** Astro, Vue 3, TypeScript
- **State:** Nanostores, VueUse
- **Backend:** Appwrite (auth, database, storage, functions)
- **Styling:** Tailwind CSS v4
- **Validation:** Zod
- **UI:** headlessui/vue, floating-ui/vue, shadcn-ui/vue
- **More:** See SITEMAP.md for complete list

## Example Outputs

### Cache Hit (Fast)
```
User: "How to use Appwrite auth in Astro SSR?"

Phase 1: Found cached doc_appwrite-auth-ssr_2025-10-15.md
Phase 2: SKIPPED (cache sufficient)
Phase 3: Summary presented from cache

Time: ~5 seconds
```

### Cache Miss (Comprehensive)
```
User: "Vue Suspense with async components in Astro?"

Phase 1: No cache found
Phase 2: Both researchers deployed in parallel
  - MCP: doc_vue-suspense-astro_2025-10-31.md (official API)
  - Web: web_vue-suspense-patterns_2025-10-31.md (community patterns)
Phase 3: Combined summary with official + community insights

Time: ~45 seconds
```

## Features

✅ **Cache-First:** Reuses recent research (< 60 days)
✅ **Parallel Execution:** MCP + Web research run simultaneously
✅ **Timestamped Outputs:** Never overwrites, builds knowledge base
✅ **Comprehensive:** Combines official docs + community best practices
✅ **Cites Sources:** All findings linked to authoritative sources
✅ **Fast:** Cache hits in ~5 seconds, full research in ~45 seconds

## Subagent Details

### Cache Researcher
- **Tools:** Read, Glob, Grep, Bash
- **Mission:** Find recent cached documentation
- **Output:** FOUND or INSUFFICIENT status
- **Time:** < 5 seconds

### MCP Researcher
- **Tools:** Context7 MCP, Tailwind CSS MCP, Read, Write
- **Mission:** Query official documentation
- **MCP Selection:** Context7 for most libraries, Tailwind CSS MCP for Tailwind-specific queries
- **Output:** `outputs/doc_[topic]_[YYYY-MM-DD].md`
- **Time:** < 30 seconds

### Best Practice Researcher
- **Tools:** Tavily MCP, Read, Write
- **Mission:** Find community patterns and real-world examples
- **Output:** `outputs/web_[topic]_[YYYY-MM-DD].md`
- **Time:** < 45 seconds

## Maintenance

### Cache Management

Files are automatically dated in their filename. To clean stale cache:

```bash
# Remove files older than 60 days
find ~/.claude/skills/doc-research/outputs/ -name "*.md" -mtime +60 -delete
```

### Updating SITEMAP.md

Add new authoritative documentation sources to SITEMAP.md when you discover them:

```markdown
## New Category

- **Library Name**: https://docs.example.com - Description of what's documented
```

## Advanced Usage

### Custom Cache Age

When invoking the skill, you can specify custom cache age:

```
"Research Vue Suspense (accept cache up to 90 days old)"
```

### Specific Sources

Request research from specific sources:

```
"Find Appwrite auth patterns from Stack Overflow and GitHub discussions"
```

### Depth Control

Control research depth:

```
"Quick research on Tailwind dark mode" → Uses cache if available, minimal web search
"Comprehensive research on Zod validation" → Full parallel research even if cache exists
```

## Troubleshooting

### Skill not triggering automatically

**Symptom:** Claude doesn't invoke doc-research when asking documentation questions

**Solution:**
- Include trigger keywords: "documentation", "how to use", "best practices", "API reference"
- Mention specific libraries: "Vue", "Astro", "Appwrite", etc.
- Specify file types: ".vue", ".ts", ".astro"

### MCP researcher failing

**Symptom:** MCP researcher can't find documentation

**Solution:**
- Verify Context7 MCP is installed and configured
- Check SITEMAP.md for correct library names
- Fall back to web researcher results

### Web researcher returning low-quality results

**Symptom:** Best practice researcher finds spam or outdated content

**Solution:**
- Check search queries in output file
- Verify Tavily MCP is configured with API key
- Manually review and update SITEMAP.md with better sources

## Version History

- **v1.0.0** (2025-10-31): Initial release
  - Cache-first research workflow
  - Parallel MCP + web research
  - Three specialized subagents
  - Timestamped output files

## Related Skills

- **cc-mastery** - Understanding Claude Code ecosystem
- **planner** - Planning implementation based on research findings
- **astro-vue-architect** - Implementing Astro + Vue patterns
- **nanostore-builder** - Creating stores based on researched patterns

## Credits

Created following Claude Code skill builder best practices with inspiration from:
- Superpowers library (workflow enforcement patterns)
- CC Skill Builder guidelines (progressive disclosure)
- Real-world documentation research workflows

---
name: Documentation Research
description: |
  Research official documentation, API references, and best practices for tech stack
  (Astro, Vue 3, Appwrite, TypeScript, Tailwind, Nanostores, VueUse, Zod, headlessui/vue).
  Use when verifying correct usage, finding implementation patterns, debugging library-specific
  issues, or understanding framework conventions. Use for "how to use", "documentation for",
  "API reference", "best practices", "official docs", working with .vue, .ts, .astro files.
version: 1.0.0
tags: [documentation, research, api-reference, best-practices, tech-stack]
---

# Documentation Research

## Quick Start

- Cache-first approach: Check recent findings before new research
- Parallel execution: Deploy MCP + web research simultaneously
- Timestamped outputs: All findings saved for future reuse
- Comprehensive synthesis: Combine official docs + community patterns

## Tech Stack Coverage

This skill researches documentation for:

- **Frontend:** Astro, Vue 3 (Composition API), TypeScript
- **State:** Nanostores, @nanostores/vue, @nanostores/persistent, VueUse
- **Backend:** Appwrite (client SDK, functions, auth, database, storage)
- **Styling:** Tailwind CSS v4 (via dedicated MCP), @tailwindcss/vite
- **Validation:** Zod
- **UI Libraries:** headlessui/vue, floating-ui/vue, shadcn-ui/vue, @iconify/vue
- **Additional:** See [SITEMAP.md](SITEMAP.md) for complete list

## MCP Server Support

**Context7 MCP** - Library documentation with code examples
- Most libraries (Vue, Astro, Appwrite, etc.)
- Resolve library IDs, fetch docs with topic filters

**Tailwind CSS MCP** - Comprehensive Tailwind CSS utilities and documentation
- Search official Tailwind docs (`search_tailwind_docs`)
- Get utilities by category/property (`get_tailwind_utilities`)
- Color palette information (`get_tailwind_colors`)
- Framework-specific setup guides (`get_tailwind_config_guide`)
- CSS to Tailwind conversion (`convert_css_to_tailwind`)
- Custom color palette generation (`generate_color_palette`)
- Component templates with Tailwind (`generate_component_template`)

**Tavily MCP** - Web research for community patterns
- Search articles, tutorials, Stack Overflow
- Extract content from URLs for deep dives

## Research Workflow

**Announce at start:** "I'm using the doc-research skill to find authoritative documentation and best practices."

### Phase 1: Cache Review (Always First)

1. **Check Recent Findings**
   - Search `outputs/` folder for relevant cached documentation
   - Look for files matching topic (e.g., `doc_vue-suspense_*.md`, `web_tailwind-patterns_*.md`)
   - Ignore files older than 60 days (stale)

2. **Evaluate Cache Status**
   - **FOUND:** Recent, relevant documentation exists → Use cached findings
   - **INSUFFICIENT:** No cache or outdated → Proceed to Phase 2

3. **Cache Decision**
   ```
   IF recent relevant docs found:
     → Skip to Phase 3 (Synthesis)
   ELSE:
     → Continue to Phase 2 (Active Research)
   ```

### Phase 2: Active Research (Only if Cache Insufficient)

**Deploy both researchers IN PARALLEL:**

1. **MCP Researcher** (Official Documentation)
   - Uses Context7 MCP for library docs
   - Searches official sources from SITEMAP.md
   - Writes findings to: `outputs/doc_[topic]_[YYYY-MM-DD].md`

2. **Best Practice Researcher** (Community Patterns)
   - Uses Tavily for web research
   - Finds articles, tutorials, real-world patterns
   - Writes findings to: `outputs/web_[topic]_[YYYY-MM-DD].md`

**CRITICAL:** Deploy both using Task tool in parallel. Do not wait for one to finish.

### Phase 3: Synthesis & Handoff

1. **Collect All Relevant Files**
   - Read cached files (if found in Phase 1)
   - Read newly created files (if Phase 2 executed)

2. **Synthesize Findings**
   - Combine official documentation + community best practices
   - Highlight key implementation approaches
   - Note version-specific considerations
   - Flag potential gotchas or common pitfalls

3. **Present Summary**
   Include:
   - What was found in cache (if anything)
   - What new research uncovered (if Phase 2 ran)
   - Recommended implementation approach
   - Links to authoritative sources
   - Practical next steps

## Instructions for Claude

When this skill is invoked:

### Step 1: Understand the Request

Extract the research topic from user request:
- Library/framework name (e.g., "Vue 3", "Appwrite Auth")
- Specific feature (e.g., "Suspense", "OAuth flow")
- Use case context (e.g., "SSR compatibility", "TypeScript types")

### Step 2: Deploy Cache Researcher

**REQUIRED SUB-AGENT:** Use cache-researcher

Launch with:
```
Topic: [extracted topic]
Keywords: [search terms for finding relevant cache files]
Max age: 60 days
```

Cache researcher will:
- Search outputs/ folder
- Return FOUND or INSUFFICIENT status
- Provide file paths if found

### Step 3: Evaluate Cache Results

**IF cache-researcher returns FOUND:**
- Read the cached files it identified
- Skip to Step 5 (Synthesis)

**IF cache-researcher returns INSUFFICIENT:**
- Proceed to Step 4 (Parallel Research)

### Step 4: Deploy Parallel Researchers (Only if Cache Insufficient)

**Deploy BOTH researchers in parallel using Task tool:**

**Researcher 1: MCP Researcher**
- Subagent: mcp-researcher
- Tools: Context7, Tailwind CSS MCP, ReadMcpResourceTool
- Output: `outputs/doc_[topic]_[YYYY-MM-DD].md`
- Uses Context7 for most libraries, Tailwind CSS MCP for Tailwind-specific queries

**Researcher 2: Best Practice Researcher**
- Subagent: best-practice-researcher
- Tools: Tavily (tavily_search, tavily_extract)
- Output: `outputs/web_[topic]_[YYYY-MM-DD].md`

**Wait for both to complete before proceeding.**

### Step 5: Synthesize Findings

1. **Read All Relevant Files**
   - From cache (if Phase 1 found files)
   - From new research (if Phase 2 executed)

2. **Create Comprehensive Summary**
   - Official documentation findings
   - Community best practices
   - Code examples (if available)
   - Implementation recommendations
   - Known issues or gotchas

3. **Structure Output:**
   ```markdown
   ## Research Summary: [Topic]

   **Sources Used:**
   - [List of files/sources consulted]

   **Key Findings:**
   - [Official documentation highlights]
   - [Best practices from community]

   **Recommended Approach:**
   [Specific implementation guidance]

   **Important Notes:**
   - [Version-specific considerations]
   - [Common pitfalls to avoid]
   - [Related topics to explore]

   **References:**
   - [Links to authoritative sources]
   ```

### Step 6: Present to User

Provide the synthesized summary in a concise, information-dense format. No fluff, just actionable insights.

## Output File Naming Conventions

All research findings saved to `outputs/` directory:

- **MCP Research:** `doc_[topic]_[YYYY-MM-DD].md`
  - Example: `doc_vue-suspense-astro_2025-10-31.md`
  - Contains: Official documentation excerpts, API references

- **Web Research:** `web_[topic]_[YYYY-MM-DD].md`
  - Example: `web_tailwind-dark-mode-patterns_2025-10-31.md`
  - Contains: Community articles, tutorials, real-world examples

**Topic Naming:**
- Lowercase with hyphens
- Specific and descriptive
- Framework-feature format when applicable
- Examples: `appwrite-auth-ssr`, `vue-composition-api`, `tailwind-v4-vue`

## Examples

### Example 1: Cache Hit

```
User: "What's the proper way to handle Appwrite authentication in Astro SSR?"

Phase 1: Deploy cache-researcher
Result: Found doc_appwrite-auth-ssr_2025-10-15.md (recent)

Phase 2: SKIPPED (cache sufficient)

Phase 3: Read cached file, synthesize summary
Output: Comprehensive summary from cached documentation
```

### Example 2: Cache Miss - Full Research

```
User: "How do I implement Suspense in Vue 3 with async components in Astro?"

Phase 1: Deploy cache-researcher
Result: INSUFFICIENT (no recent files found)

Phase 2: Deploy in parallel:
- mcp-researcher → outputs/doc_vue-suspense-astro_2025-10-31.md
- best-practice-researcher → outputs/web_vue-suspense-patterns_2025-10-31.md

Phase 3: Read both files, synthesize comprehensive summary
Output: Combined official docs + community patterns
```

### Example 3: Partial Cache - Supplement Research

```
User: "What's new in Tailwind v4 for Vue components?"

Phase 1: Deploy cache-researcher
Result: Found doc_tailwind-v4_2025-09-20.md (relevant but older)

Phase 2: Deploy mcp-researcher for updated info
Creates: doc_tailwind-v4-vue_2025-10-31.md

Phase 3: Synthesize findings from both cache + new research
Output: Updated information combining both sources
```

## Quick Reference

| Phase | Action | Success Criteria |
|-------|--------|------------------|
| **1. Cache** | Deploy cache-researcher | FOUND or INSUFFICIENT status returned |
| **2. Research** | Deploy mcp + web researchers in parallel | Both output files created |
| **3. Synthesis** | Read all files, create summary | Comprehensive, actionable summary presented |

## Red Flags - STOP and Reconsider

If you catch yourself:
- Skipping cache check ("I'll just do fresh research")
- Running researchers sequentially instead of parallel
- Not reading SITEMAP.md for known documentation sources
- Guessing at implementation details instead of researching
- Providing answers without consulting authoritative sources

**ALL of these mean: Follow the three-phase workflow exactly.**

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Cache check is slow, skip to research" | Cache check is fastest path. Saves tokens + time. |
| "This is simple, I know the answer" | Official docs may have updated. Always verify. |
| "Sequential research is fine" | Parallel execution is 2x faster. Use it. |
| "Don't need web research for this" | Community patterns reveal real-world gotchas. |

## Notes

- **SITEMAP.md** contains curated authoritative documentation sources
- **Subagents are autonomous:** They handle writing to outputs/ themselves
- **This skill does NOT analyze codebase:** Assumes user provides context
- **This skill does NOT implement solutions:** Only provides research findings
- **Main agent uses findings** to determine implementation approach

## Troubleshooting

### Issue: Cache researcher not finding relevant files

**Solution:**
- Check topic keywords are specific enough
- Files may be older than 60 days (stale)
- Proceed to Phase 2 (active research)

### Issue: MCP researcher can't find documentation

**Solution:**
- Check SITEMAP.md for correct documentation URLs
- Verify Context7 MCP is configured and working
- Fall back to web researcher results

### Issue: Researchers taking too long

**Solution:**
- Verify both launched in parallel (not sequential)
- Check network connectivity for MCP servers
- Timeout after 2 minutes, use partial results

### Issue: Synthesis is too verbose

**Solution:**
- Focus on actionable insights only
- Remove redundant information
- Prioritize official docs over community content
- Be information-dense, not comprehensive

## Reference

For complete list of authoritative documentation sources, see [SITEMAP.md](SITEMAP.md).

For subagent implementation details:
- [~/.claude/agents/research/cache-researcher.md](~/.claude/agents/research/cache-researcher.md)
- [~/.claude/agents/research/mcp-researcher.md](~/.claude/agents/research/mcp-researcher.md)
- [~/.claude/agents/research/best-practice-researcher.md](~/.claude/agents/research/best-practice-researcher.md)

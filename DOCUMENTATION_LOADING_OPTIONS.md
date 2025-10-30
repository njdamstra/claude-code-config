# Documentation Loading Options - Comprehensive Analysis

This document analyzes different approaches for loading generated documentation into Claude's context.

## Context

You've created an extensive **codebase-documentation** skill and `/docs` slash command that generates comprehensive documentation about codebase topics. Now you need a strategy for actually loading that documentation when needed.

---

## Option 1: Slash Command (`/recall`)

### How It Works
User-invoked command that searches and loads documentation files into context.

**Current Implementation:** `/recall [topic] [--depth shallow|deep]`

### Architecture
```
User types /recall authentication
  ↓
Slash command parses arguments
  ↓
Spawns doc-searcher agent (subagent)
  ↓
Agent searches ~/.claude/documentation/ using Grep/Glob
  ↓
Agent reads matched files with Read tool
  ↓
Returns formatted documentation to context
  ↓
Main Claude agent has documentation loaded
```

### Strengths
✅ **User control** - Explicit, intentional loading
✅ **Token efficiency** - Load only what's needed, when needed
✅ **Depth options** - Shallow (core files) vs deep (everything)
✅ **Active work detection** - Checks for in-progress work on topic
✅ **Multi-topic support** - Can load multiple related topics
✅ **Already implemented** - `/recall` exists and works

### Weaknesses
❌ **Manual invocation** - User must remember to run it
❌ **No auto-discovery** - Doesn't suggest what to load
❌ **Session-only** - Documentation not persistent across sessions
❌ **Subagent overhead** - Spawning agent adds latency

### Token Usage
- **Shallow:** 2-10K tokens (insights.md + procedures.md)
- **Deep:** 10-50K tokens (all files + related topics)

### Best For
- Developers who know what they need
- Just-in-time documentation access
- Token-conscious workflows
- Explicit knowledge retrieval

### Example Usage
```bash
# Quick reference
/recall authentication --depth shallow

# Comprehensive context
/recall authentication database api --depth deep

# Before implementing feature
/recall vue-components nanostores --depth shallow
```

---

## Option 2: MCP Server (Documentation Server)

### How It Works
Custom MCP server exposes documentation as tools that Claude can call.

**Hypothetical Implementation:** Documentation MCP with search/retrieve tools

### Architecture
```
Claude identifies need for documentation
  ↓
Calls MCP tool: mcp__docs__search(query: "authentication")
  ↓
MCP server searches ~/.claude/documentation/
  ↓
Returns search results with snippets
  ↓
Claude calls mcp__docs__retrieve(path: "auth/oauth.md")
  ↓
MCP server returns full documentation content
  ↓
Claude has documentation in context
```

### Potential MCP Tools
```json
{
  "tools": [
    {
      "name": "search_documentation",
      "description": "Search documentation by keywords",
      "parameters": {
        "query": "string",
        "scope": "frontend|backend|both",
        "limit": "number"
      }
    },
    {
      "name": "retrieve_documentation",
      "description": "Retrieve full documentation file",
      "parameters": {
        "path": "string"
      }
    },
    {
      "name": "list_topics",
      "description": "List all documented topics",
      "parameters": {}
    },
    {
      "name": "get_related_topics",
      "description": "Get related topics by tags",
      "parameters": {
        "topic": "string"
      }
    }
  ]
}
```

### Strengths
✅ **Auto-discovery** - Claude can search when needed
✅ **Tool-based** - Natural MCP tool calling pattern
✅ **Lazy loading** - Fetch only what's needed
✅ **Real-time** - Always accesses latest documentation
✅ **No subagent overhead** - Direct tool calls
✅ **Structured queries** - Search with filters (scope, tags, etc)

### Weaknesses
❌ **Implementation required** - Must build custom MCP server
❌ **Setup complexity** - Users must install and configure
❌ **Maintenance burden** - Another service to maintain
❌ **Limited context** - Each tool call returns limited data
❌ **Multiple calls** - May need several calls to build full context

### Token Usage (per call)
- **Search:** 1-5K tokens (results with snippets)
- **Retrieve:** 2-15K tokens per file
- **Total:** Depends on number of tool calls

### Best For
- Auto-discovery workflows ("what docs exist?")
- Incremental context building
- Users comfortable with MCP setup
- When documentation changes frequently

### Implementation Sketch
```javascript
// documentation-mcp-server.js
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { glob } from 'glob';
import { readFile } from 'fs/promises';
import { join } from 'path';

const server = new Server({
  name: 'documentation-server',
  version: '1.0.0'
}, {
  capabilities: {
    tools: {}
  }
});

// Register search_documentation tool
server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'search_documentation',
      description: 'Search documentation by keywords',
      inputSchema: {
        type: 'object',
        properties: {
          query: { type: 'string' },
          scope: { type: 'string', enum: ['frontend', 'backend', 'both'] }
        }
      }
    }
  ]
}));

server.setRequestHandler('tools/call', async (request) => {
  if (request.params.name === 'search_documentation') {
    const { query, scope } = request.params.arguments;
    // Search logic here
    return { content: [{ type: 'text', text: results }] };
  }
});
```

### Configuration
```json
{
  "mcpServers": {
    "documentation": {
      "command": "node",
      "args": ["~/.claude/mcp-servers/documentation-server.js"]
    }
  }
}
```

---

## Option 3: Skill-Based Auto-Loading

### How It Works
Skills automatically load relevant documentation when invoked.

**Enhancement to existing skills:** Skills detect topic and load docs before executing

### Architecture
```
User asks: "How do I implement authentication?"
  ↓
Claude recognizes topic matches appwrite-integration skill
  ↓
Skill invokes automatically
  ↓
FIRST STEP: Skill loads relevant documentation
  - Reads ~/.claude/documentation/appwrite/auth/*.md
  - Injects into skill context
  ↓
SECOND STEP: Skill executes with full context
  ↓
Provides answer with documentation-backed knowledge
```

### Implementation Pattern
Each skill includes documentation loading in frontmatter or early steps:

```markdown
---
name: appwrite-integration
documentation:
  - ~/.claude/documentation/appwrite/auth/*.md
  - ~/.claude/documentation/appwrite/database/*.md
auto-load: true
---

# Appwrite Integration Skill

## Step 1: Load Documentation (Auto)
Before proceeding, I'll load relevant Appwrite documentation...

[Skill uses Read tool to load specified docs]

## Step 2: Execute Skill Logic
[Rest of skill with documentation context loaded]
```

### Strengths
✅ **Zero user action** - Fully automatic
✅ **Context-aware** - Loads only relevant docs for skill
✅ **Coupled with expertise** - Docs loaded when expert skill activates
✅ **No new infrastructure** - Uses existing skill system
✅ **Consistent pattern** - All skills can follow same approach

### Weaknesses
❌ **Skill-specific** - Only loads docs when skill invokes
❌ **No standalone access** - Can't load docs without skill
❌ **Frontmatter complexity** - Must maintain doc paths in every skill
❌ **No user override** - Can't control what's loaded
❌ **Token overhead** - May load docs even if not needed for simple queries

### Token Usage
- **Per skill invocation:** 5-20K tokens (skill-specific docs)
- **Automatic:** No user control over amount

### Best For
- Skills that heavily rely on documentation
- Ensuring skills always have current reference
- Users who want zero-config experience
- Tightly coupled skill-documentation workflows

### Example Enhancement
```markdown
---
name: vue-component-builder
documentation:
  - ~/.claude/documentation/vue/composition-api.md
  - ~/.claude/documentation/vue/ssr-patterns.md
  - ~/.claude/documentation/tailwind/dark-mode.md
auto-load: true
load-depth: shallow
---

# Vue Component Builder

When invoked, I automatically load:
- Vue Composition API patterns
- SSR safety guidelines
- Tailwind dark mode best practices

Then I help you build components with full context.
```

---

## Option 4: CLAUDE.md References

### How It Works
Include documentation paths directly in CLAUDE.md to load at session start.

**Simple pattern:** Reference docs in global configuration

### Architecture
```
Claude Code session starts
  ↓
Reads ~/.claude/CLAUDE.md
  ↓
Encounters documentation references:
  @include ~/.claude/documentation/core-patterns.md
  @include ~/.claude/documentation/tech-stack.md
  ↓
Loads specified files into context
  ↓
Documentation available for entire session
```

### Implementation
```markdown
# Global Claude Code Configuration

## Core Documentation (Auto-Loaded)

The following documentation is loaded at session start:

@include ~/.claude/documentation/vue/core-patterns.md
@include ~/.claude/documentation/appwrite/quick-ref.md
@include ~/.claude/documentation/nanostores/patterns.md

## Project-Specific Patterns
[Rest of CLAUDE.md]
```

### Strengths
✅ **Always available** - Docs loaded every session
✅ **Zero invocation cost** - No commands needed
✅ **Centralized control** - Single place to manage
✅ **Session-persistent** - Available throughout conversation

### Weaknesses
❌ **Token cost upfront** - Consumes context from session start
❌ **No lazy loading** - All docs loaded even if not needed
❌ **Not dynamic** - Can't change loaded docs during session
❌ **Context pollution** - May load irrelevant docs
❌ **Session startup latency** - Slower session initialization

### Token Usage
- **Session start:** 10-50K tokens (depending on docs)
- **Persistent:** Cost paid once per session

### Best For
- Core patterns used in every session
- Small, frequently-referenced docs
- Users who value always-on context
- When token budget allows

---

## Option 5: Hybrid: `/recall` + Skill Auto-Load

### How It Works
Combine manual `/recall` for explicit loading with automatic skill-based loading.

**Best of both worlds**

### Architecture
```
Scenario 1: User needs docs NOW
  User: /recall authentication
  → Slash command loads immediately

Scenario 2: User asks skill question
  User: "How do I implement OAuth?"
  → appwrite-integration skill auto-invokes
  → Skill auto-loads authentication docs
  → Provides answer with full context

Scenario 3: Deep research session
  User: /recall authentication database api --depth deep
  → Loads comprehensive context
  User: "Now help me implement user registration"
  → Skills work with already-loaded docs
```

### Strengths
✅ **Flexible** - Manual OR automatic
✅ **Token efficient** - Load only when needed
✅ **No redundancy** - Skills check if docs already loaded
✅ **User control** - Can pre-load with /recall
✅ **Auto-discovery** - Skills load if user forgets

### Weaknesses
❌ **Complexity** - Two systems to maintain
❌ **Potential duplication** - Same docs loaded twice?
❌ **Coordination needed** - Skills must check existing context

### Best For
- Power users who want control + automation
- Mixed workflows (research + implementation)
- Maximum flexibility

---

## Comparison Matrix

| Feature | /recall | MCP Server | Skill Auto-Load | CLAUDE.md | Hybrid |
|---------|---------|------------|-----------------|-----------|--------|
| **User Control** | ✅ High | ⚠️ Medium | ❌ None | ❌ None | ✅ High |
| **Token Efficiency** | ✅ High | ✅ High | ⚠️ Medium | ❌ Low | ✅ High |
| **Auto-Discovery** | ❌ No | ✅ Yes | ✅ Yes | ❌ No | ✅ Yes |
| **Setup Complexity** | ✅ Low | ❌ High | ✅ Low | ✅ Low | ⚠️ Medium |
| **Implementation** | ✅ Done | ❌ Custom | ⚠️ Partial | ✅ Easy | ⚠️ Multi |
| **Latency** | ⚠️ Medium | ✅ Low | ⚠️ Medium | ❌ High | ⚠️ Medium |
| **Session Persistence** | ❌ No | ❌ No | ❌ No | ✅ Yes | ❌ No |
| **Dynamic Loading** | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No | ✅ Yes |

---

## Recommendations by Use Case

### For New Users (Simplicity Priority)
**Recommended: Option 1 (`/recall`)**
- Already implemented
- Easy to understand
- Explicit control
- No setup required

**Quick Start:**
```bash
/recall [topic]  # When you need docs
```

---

### For Power Users (Flexibility Priority)
**Recommended: Option 5 (Hybrid)**
- Combines manual + automatic
- Maximum control + convenience
- Token efficient
- Scales with expertise

**Pattern:**
```bash
# Pre-load comprehensive context
/recall authentication database --depth deep

# Skills auto-load if you forget
# Ask questions, skills have context
```

---

### For Auto-Discovery Workflows
**Recommended: Option 2 (MCP Server)**
- Claude discovers available docs
- Lazy loads on demand
- No manual commands
- Search-driven

**When to build:**
- Documentation changes frequently
- Want Claude to explore docs independently
- Comfortable with MCP infrastructure

---

### For Session-Long Context
**Recommended: Option 4 (CLAUDE.md)**
- Core patterns always available
- No repeated loading
- Zero invocation overhead

**Best for:**
- Small, frequently-used docs (< 10K tokens)
- Core patterns referenced constantly
- When token budget supports it

---

### For Skill-Heavy Workflows
**Recommended: Option 3 (Skill Auto-Load)**
- Documentation couples with expertise
- Zero user action
- Context-aware loading

**Enhancement Pattern:**
```markdown
# Enhance existing skills
Add to frontmatter:
  documentation: [paths]
  auto-load: true
```

---

## Recommended Implementation Path

### Phase 1: Leverage Existing (`/recall`)
**Status:** Already implemented ✅
**Action:** None needed, document usage patterns

### Phase 2: Enhance Skills with Auto-Load
**Effort:** Low (1-2 hours)
**Impact:** High
**Steps:**
1. Add `documentation` frontmatter to top 5 skills:
   - `vue-component-builder`
   - `nanostore-builder`
   - `appwrite-integration`
   - `typescript-fixer`
   - `astro-routing`
2. Each skill checks and loads docs before execution
3. Document pattern for future skills

### Phase 3: Optional MCP Server (Future)
**Effort:** Medium (4-6 hours)
**Impact:** Medium
**When:** If auto-discovery becomes critical
**Steps:**
1. Build documentation MCP server
2. Expose search/retrieve tools
3. Test tool calling patterns
4. Document setup for users

---

## Token Budget Considerations

### Documentation Size Estimates
Based on codebase-documentation skill output:

- **Quick Reference:** 2-5K tokens
- **How-To Guide:** 5-15K tokens
- **Comprehensive Doc:** 20-50K tokens
- **Architecture Doc:** 15-40K tokens

### Loading Strategies by Budget

**Conservative (50K token session budget):**
- Load 2-3 shallow docs via `/recall`
- Rely on skill auto-load for specific needs
- Avoid CLAUDE.md loading

**Moderate (100K token session budget):**
- Load 5-7 docs via `/recall --depth shallow`
- Include core patterns in CLAUDE.md (< 10K)
- Skills auto-load supplementary docs

**Generous (200K+ token session budget):**
- Load comprehensive context via `/recall --depth deep`
- Include all core patterns in CLAUDE.md
- Skills have full documentation access

---

## Decision Framework

### Choose `/recall` if:
- ✅ You want explicit control
- ✅ You know what docs you need
- ✅ Token efficiency is critical
- ✅ You prefer manual workflows

### Choose MCP Server if:
- ✅ You want auto-discovery
- ✅ Documentation changes frequently
- ✅ You're comfortable with MCP setup
- ✅ You want Claude to explore docs

### Choose Skill Auto-Load if:
- ✅ Skills heavily use documentation
- ✅ You want zero-config experience
- ✅ Documentation is skill-specific
- ✅ You prioritize convenience

### Choose CLAUDE.md if:
- ✅ Core patterns used every session
- ✅ Docs are small (< 10K tokens)
- ✅ Session-long context needed
- ✅ Token budget supports it

### Choose Hybrid if:
- ✅ You want maximum flexibility
- ✅ You're a power user
- ✅ You mix research + implementation
- ✅ You want both control + automation

---

## Next Steps

### Immediate (No Work)
1. ✅ Use existing `/recall` command
2. ✅ Document best practices for users
3. ✅ Create usage examples in docs

### Short-Term (Low Effort)
1. Enhance 5 core skills with auto-load
2. Test hybrid `/recall` + skill pattern
3. Measure token usage across workflows

### Long-Term (If Needed)
1. Build documentation MCP server
2. Implement search/retrieve tools
3. Test auto-discovery workflows
4. Gather user feedback

---

## Conclusion

**Recommended Approach: Hybrid (`/recall` + Skill Auto-Load)**

**Why:**
- ✅ Leverages existing `/recall` (already working)
- ✅ Adds skill auto-load (low implementation effort)
- ✅ Provides both manual control + automation
- ✅ Token efficient (load only what's needed)
- ✅ Scales from beginners to power users
- ✅ No infrastructure overhead (no MCP server needed)

**Implementation:**
1. **Keep `/recall`** for explicit loading
2. **Enhance top 5 skills** with documentation auto-load
3. **Document patterns** for users
4. **Evaluate MCP server** after usage data

**Token Efficiency:**
- Users control loading via `/recall`
- Skills load supplementary docs automatically
- No upfront session cost
- Scales with actual usage

This provides the best balance of **control, convenience, and token efficiency** without requiring new infrastructure.

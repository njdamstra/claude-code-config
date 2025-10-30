# Global Claude Code Configuration

## Token Optimization Rules

### Core Philosophy
- **Focused agents are performant agents**
- Minimize context pollution through strategic delegation
- Use specialized agents for research, main agent for implementation
- When responding, be concise, don't worry about grammar, do no give me an article to read.

### Context Management
- Keep CLAUDE.md files under 15,000 tokens when possible
- Use context bundles for session restoration
- Delegate token-intensive research to sub-agents
- Load MCP servers selectively based on task requirements

### Agent Orchestration Strategy
1. **Research Phase**: Use specialist agents to investigate and plan
2. **Implementation Phase**: Main agent executes with focused context
3. **Review Phase**: Code review agents validate only when needed

### File Access Patterns
- Prefer `/context/priming/` files for domain-specific startup context
- Use `/agents/memory/` for persistent agent knowledge
- Store session state in `/context/bundles/` for restoration

## Development Preferences

### Code Style
- Follow existing project conventions
- Minimal comments unless explicitly requested
- Security-first approach - never expose secrets
- Prefer editing existing files over creating new ones

### Testing Strategy
- Run project-specific test commands after implementation
- Use `npm run lint` and `npm run typecheck` for TypeScript projects
- Check README.md for project-specific testing instructions

### Sub-Agent Usage
- **typescript-master**: TypeScript compilation errors, type safety
- **minimal-change-analyzer**: Surgical changes to existing codebases
- **problem-decomposer-orchestrator**: Complex multi-step implementations
- **astro-vue-architect**: SSR-compatible Vue components in Astro
- **python-pipeline-architect**: Python systems and data processing

### Context Engineering Commands
- `/prime [domain]`: Load domain-specific context and tools
- `/bundle [name]`: Save/restore session context state
- `/research [topic]`: Delegate research to specialist agents
- `/ultratask [name] [description]`: Complex task breakdown with parallel execution

## MCP Server Management

Use the `/mcps` slash command for preset-based MCP management with environment variable validation.

### Quick Start
```bash
/mcps                          # List all servers (default action)
/mcps add preset:browser       # Add browser automation preset (project scope)
/mcps add gemini-cli user      # Add Gemini CLI globally
/mcps audit                    # Security check for hardcoded secrets
/mcps info preset:ui           # Show preset details
```

### Available Presets
- **preset:browser** - playwright, chrome-devtools
- **preset:ai** - gemini-cli, sequential-thinking
- **preset:docs** - context7, tailwind-css, shadcn
- **preset:webdev** - firecrawl, playwright, chrome-devtools
- **preset:ui** - tailwind-css, shadcn, figma-to-react
- **preset:ai-assist** - gemini-cli, sequential-thinking, context7

### Scope Behavior
- **Default scope:** project (local to current directory)
- **User scope:** Add `user` as third argument for global access
- **Project-level:** Stored in `./.mcp.json` or `./.claude/.mcp.json`
- **User-level:** Stored in `~/.claude.json`

### Security
- Environment variables validated before adding servers
- Use `${ENV_VAR}` refs in config, never hardcode secrets
- Run `/mcps audit` to detect hardcoded API keys
- Required vars: `GEMINI_API_KEY`, `FIRECRAWL_API_KEY`, `FIGMA_API_KEY`, `GITHUB_TOKEN`

## Memory Management
- Agent memory files track domain-specific learnings
- Context bundles provide 60-70% session restoration capability
- Append-only logs maintain operation history

## Workflow Patterns
- **Research-First**: Investigate → Plan → Implement → Validate
- **Parallel Development**: Independent tasks run simultaneously
- **Token-Optimized**: Minimize context, maximize focus


**Pattern Recognition:**
- Detect patterns like `@code-scout`, `@documentation-researcher`, `@plan-master`, etc.
- These appear in markdown sections describing what agents should do
- Each `@agent-name` triggers automatic Task tool invocation


### Main Agent Consolidates Findings

This triggers spawning both agents in parallel, waiting for completion, then proceeding to consolidation.

**Agent Availability:** Check available agents via Task tool documentation. Common agents:
- `@code-scout` → Explore agent - codebase analysis and exploration
- `@documentation-researcher` → web-researcher agent - documentation and research
- `@plan-master` → problem-decomposer-orchestrator - planning and decomposition
- `@vue-architect` → astro-vue-architect - Vue/Astro component architecture
- Other specialized agents as needed

## Claude Code Knowledge & Skills

### Available Skills (Loaded On-Demand)
When questions relate to Claude Code, the following skills activate automatically:

- **cc-mastery** - Core ecosystem knowledge, component hierarchy, decision framework, integration patterns
- **cc-skill-builder** - Create and design Claude Code skills with proper structure, frontmatter, and progressive disclosure
- **cc-slash-command-builder** - Create custom slash commands, workflow templates, automation patterns
- **cc-subagent-architect** - Design specialized subagents, system prompts, tool restrictions, delegation patterns
- **cc-hook-designer** - Lifecycle automation, event hooks, trigger patterns, script creation
- **cc-mcp-integration** - MCP server configuration, external data access, API integration
- **cc-output-style-creator** - Custom personality modes, response adaptation, communication styles

## Domain Skills (Project Development)

Your projects use Vue 3 + Astro + Appwrite tech stack. These skills activate automatically:

### Domain Skills Overview
- **code-scout** - Search for existing patterns before creating new code
  - Finds composables, components, stores, utilities
  - Analyzes match percentages (80%+ = REUSE, 50-80% = EXTEND, <50% = CREATE)
  - Maps features, identifies reusability opportunities, detects code duplications
  - Creates PRE_ANALYSIS.md reports with match percentages

- **vue-component-builder** - Build Vue 3 SFCs with Composition API and Tailwind
  - CRITICAL: Never scoped styles, always dark: mode, useMounted for SSR safety
  - Handles forms with Zod, modals with Teleport, composables with VueUse
  - Enforces ARIA labels for accessibility

- **nanostore-builder** - Create state management with BaseStore pattern
  - Extends BaseStore for Appwrite collections
  - Enforces Zod schema validation matching Appwrite attributes
  - Provides type-safe store methods and Vue integration

- **appwrite-integration** - Integrate Appwrite SDK securely
  - Handles auth flows (OAuth, JWT), database queries, file uploads, realtime
  - Documents error codes (401=permission, 400=schema)
  - Enforces permission checks and environment variable patterns

- **typescript-fixer** - Fix TypeScript errors with root cause analysis
  - CRITICAL: Never use 'any' or assertions
  - Fixes source types (Zod schemas, API responses, component interfaces)
  - Type errors indicate architectural issues, not just syntax problems

- **astro-routing** - Create Astro pages and API routes with SSR patterns
  - Prevents hydration mismatches with proper server vs client scoping
  - API routes use .json.ts pattern with Zod validation
  - Client directives: client:load, client:visible, client:idle

## Specialized Subagents (Project-Specific)

Six specialized subagents handle complex tasks automatically:

### cc-maintainer
- **Triggered by:** `@remember` prefix in messages
- **Purpose:** Update skill memories, create new skills, manage config files
- **Process:** Minimal one-line edits to SKILL.md "Core Patterns" sections
- **Example:** `@remember Always check BaseStore before creating stores`
- **Auto-logs:** All changes to ~/.claude/changelog.md

### code-scout
- **Triggered by:** builder-mode, refactor-mode automatically (via Explore agent)
- **Purpose:** Deep search for existing patterns before ANY new code
- **Output:** Search results → match percentages → REUSE/EXTEND/CREATE recommendation
- **Prevents:** Code duplication through systematic pattern discovery
- **Note:** Invoked via Task tool with subagent_type="Explore"

### refactor-specialist
- **Triggered by:** refactor-mode for complex refactors (3+ files)
- **Purpose:** Refactor while maintaining patterns and reusing existing code
- **Process:** Map dependencies → create plan → refactor incrementally → verify types
- **Prevents:** Breaking changes through incremental verification (tsc --noEmit)

### bug-investigator
- **Triggered by:** debug-mode for complex bugs (3+ symptoms)
- **Purpose:** Systematic root cause analysis
- **Output:** Bug report → root cause → 2+ fix options (with tradeoffs)
- **Diagnoses:** SSR hydration, TypeScript propagation, Zod cascades, Appwrite permission chains

### code-reviewer
- **Triggered by:** review-mode (auto-invocation before PR/merge)
- **Purpose:** Comprehensive code quality audit
- **Checks:** 50+ criteria across Vue components, TypeScript, Zod, Tailwind, accessibility, Appwrite, SSR
- **Output:** Checklist → issues by severity (Critical, High, Medium, Low) → fixes → status

### security-reviewer
- **Triggered by:** review-mode (alongside code-reviewer)
- **Purpose:** Security-focused vulnerability detection
- **Checks:** Input validation, auth/authorization, data exposure, file uploads, API security, dependencies
- **Output:** Vulnerabilities by severity → specific fixes → threat level

## Effective Workflows

### Workflow 1: Creating New Features (builder-mode)
1. Activate: `/output-style builder-mode`
2. Describe feature: "Create a user profile component"
3. What happens:
   - ✅ code-scout auto-invoked (via Explore agent) → finds existing patterns
   - ✅ Creates .temp/YYYY-MM-DD-feature/plan.md if medium-complexity
   - ✅ Invokes vue-component-builder, nanostore-builder, appwrite-integration skills
   - ✅ Hooks auto-format code (prettier + eslint)

### Workflow 2: Refactoring Code (refactor-mode)
1. Activate: `/output-style refactor-mode`
2. Describe refactor: "Consolidate duplicate FormInput components"
3. What happens:
   - ✅ code-scout auto-invoked (via Explore agent) → maps all affected files
   - ✅ refactor-specialist auto-invoked for complex refactors
   - ✅ Incremental verification after each change (tsc --noEmit)
   - ✅ Prevents breaking changes with dependency mapping

### Workflow 3: Debugging Issues (debug-mode)
1. Activate: `/output-style debug-mode`
2. Describe bug: "Component hydration mismatch on SSR"
3. What happens:
   - ✅ bug-investigator auto-invoked → traces root cause
   - ✅ Searches codebase for similar issues
   - ✅ Presents: root cause fix vs quick fix (with tradeoffs)
   - ✅ Explains WHY bug occurs (prevents symptom patching)

### Workflow 4: Code Review Before PR (review-mode)
1. Activate: `/output-style review-mode`
2. Say: "Review my changes"
3. What happens:
   - ✅ code-reviewer auto-invoked → 50+ criteria audit
   - ✅ security-reviewer auto-invoked → vulnerability detection
   - ✅ Issues grouped by severity (Critical → High → Medium → Low)
   - ✅ Output: "Ready for PR" or "X issues to fix"

### Workflow 5: Fast Iterations (quick-mode)
1. Activate: `/output-style quick-mode`
2. Say: "Just add a loading spinner to the button"
3. What happens:
   - ✅ Skips planning, goes straight to implementation
   - ✅ Still invokes vue-component-builder skill
   - ✅ Assumes you know what you want
   - ✅ Fast feedback for rapid iterations

### Workflow 6: Learning Claude Code (@remember)
1. During work: `@remember Always validate props with Zod schemas`
2. What happens:
   - ✅ cc-maintainer auto-invoked
   - ✅ Updates vue-component-builder SKILL.md with one-line addition
   - ✅ Logs change to changelog.md
   - ✅ Pattern becomes available for future sessions


**Auto-actions:**
- ✅ After any Write/Edit: Prettier formats, ESLint fixes code
- ✅ After TypeScript file changes: tsc validates types
- ✅ Before Bash commands: Logged to ~/.claude/logs/commands.log

## Tech Stack Memory

Your projects use this stack (embedded in all skills/subagents):

- **Frontend:** Vue 3 Composition API with `<script setup lang="ts">`
- **Framework:** Astro for SSR pages and API routes (.json.ts pattern)
- **Backend:** Appwrite (database, auth, storage, functions)
- **State:** Nanostores with BaseStore pattern extending Appwrite collections
- **Validation:** Zod for all schemas (frontend and backend)
- **Styling:** Tailwind CSS ONLY (never scoped styles, ALWAYS dark: mode)
- **Utilities:** VueUse composables, TypeScript strict mode
- **Accessibility:** ARIA labels on all interactive elements


## Reference Documentation
Complete documentation available at:
- `~/.claude/output-styles/` - All 6 output style definitions with detailed behaviors
- `~/.claude/skills/` - All 12 skills (6 domain + 6 cc-* meta-skills)
- `~/.claude/agents/` - All 6 specialized subagents
- `~/.claude/settings.json` - Hooks configuration
- `~/.claude/changelog.md` - History of all changes via @remember
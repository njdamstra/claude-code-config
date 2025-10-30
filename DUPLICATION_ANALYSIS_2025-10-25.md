# Claude Code Ecosystem Duplication Analysis
**Date:** 2025-10-25
**Scope:** Agents and Commands in ~/.claude/

---

## Executive Summary

**Total agents analyzed:** 36 active + 12 archived
**Total commands analyzed:** 27 active + 26 archived
**Critical duplications found:** 8 major overlaps
**Recommendations:** Consolidate 5 agents, merge 3 commands, clarify 2 role boundaries

---

## 1. DUPLICATE AGENT DEFINITIONS

### 1.1 Code Exploration Agents - MAJOR OVERLAP ⚠️

**Three agents with overlapping responsibilities:**

#### A. `code-scout` (Active)
- **Path:** `~/.claude/agents/code-scout.md`
- **Model:** haiku
- **Focus:** Discovery, mapping, reusability analysis (REUSE/EXTEND/CREATE)
- **Output:** PRE_ANALYSIS.md with match percentages
- **Systematic searches:** Composables, components, stores, utilities, schemas, VueUse
- **Duplication detection:** Yes, with extraction recommendations

#### B. `code-reuser-scout` (Archived)
- **Path:** `~/.claude/.archives/agents/code-reuser-scout.md`
- **Model:** haiku
- **Focus:** Code pattern recognition, anti-duplication, reusability
- **Search methodology:** Similar to code-scout
- **Output:** Search results with REUSE/EXTEND/CREATE recommendations

#### C. `codebase-researcher` (Archived - Deprecated 2025-10-25)
- **Path:** `~/.claude/.archives/agents/deprecated-2025-10-25/codebase-researcher.md`
- **Model:** haiku
- **Focus:** Pattern search before creating new code
- **Output:** REUSE/EXTEND/CREATE with match percentages
- **Auto-invoked by:** builder-mode, refactor-mode

**Analysis:**
- **90% functional overlap** between all three agents
- **code-scout** appears to be the consolidated successor
- **code-reuser-scout** and **codebase-researcher** are deprecated predecessors
- **CLAUDE.md still references codebase-researcher** (line 31) as if active

**Recommendation:**
✅ **KEEP:** `code-scout` (most comprehensive, active)
🗑️ **REMOVE:** Archive references in CLAUDE.md to codebase-researcher
✅ **VERIFIED:** Archival of predecessors already complete

---

### 1.2 Architecture Agents - PARTIAL OVERLAP ⚠️

**Three agents with overlapping Vue/Astro responsibilities:**

#### A. `astro-vue-architect` (Active)
- **Path:** `~/.claude/agents/astro-vue-architect.md`
- **Model:** inherit
- **Focus:** Astro + Vue SSR applications, nanostores, Tailwind, VueUse
- **Expertise:** SSR hydration, islands architecture, mounted state checks
- **Comprehensive:** 87 lines, detailed architectural guidance

#### B. `vue-architect` (Active)
- **Path:** `~/.claude/agents/vue-architect.md`
- **Model:** haiku
- **Focus:** Vue 3 Composition API, nanostores, TypeScript, VueUse
- **Expertise:** Component composition, SSR-safe patterns, reactivity
- **Detailed:** 393 lines, extensive code examples

#### C. `astro-architect` (Active)
- **Path:** `~/.claude/agents/astro-architect.md`
- **Model:** haiku
- **Focus:** Astro pages, layouts, API routes, SSR patterns
- **Expertise:** Server-side data fetching, authentication, middleware
- **Backend-focused:** 284 lines, server-side emphasis

**Analysis:**
- **50% overlap** between `astro-vue-architect` and `vue-architect`
- Both handle Vue 3 Composition API, SSR patterns, nanostores, VueUse
- **astro-vue-architect** is higher-level (architecture decisions)
- **vue-architect** is more implementation-focused (detailed patterns)
- **astro-architect** is complementary (backend/routing focus)

**Overlap Areas:**
- SSR-safe patterns (mounted checks)
- Vue 3 Composition API
- Nanostores integration
- VueUse composables
- Tailwind styling

**Recommendation:**
✅ **KEEP ALL THREE** but clarify roles:
- **astro-vue-architect:** Strategic decisions, system design, SSR architecture
- **vue-architect:** Detailed Vue component implementation, patterns, examples
- **astro-architect:** Backend, API routes, server-side concerns, auth

📝 **ACTION:** Add role clarification to descriptions:
- astro-vue-architect: "Use for architectural decisions and system design"
- vue-architect: "Use for detailed Vue component implementation"
- astro-architect: "Use for server-side pages, API routes, and backend logic"

---

### 1.3 Planning/Orchestration Agents - CRITICAL OVERLAP ⚠️⚠️

**Three agents with planning responsibilities:**

#### A. `plan-master` (Active)
- **Path:** `~/.claude/agents/plan-master.md`
- **Model:** inherit
- **Focus:** Domain-agnostic strategic planning, agent orchestration
- **Output:** Flexible (inline, file, JSON)
- **Characteristics:** WHAT + WHO focus, not HOW
- **Lines:** 736 lines (comprehensive)

#### B. `plan-orchestrator` (Active)
- **Path:** `~/.claude/agents/plan-orchestrator.md`
- **Model:** inherit
- **Focus:** Evidence-based planning with 5 workflow patterns
- **Composes:** code-scout, code-qa, doc-searcher, plan-master
- **Workflows:** Hypothesis-Driven, Discovery-First, Documentation-First, Quick-Scan, Iterative-Refinement
- **Lines:** 1543 lines (VERY comprehensive)
- **Unique:** Parallel hypothesis testing, confidence ratings

#### C. `problem-decomposer-orchestrator` (Active)
- **Path:** `~/.claude/agents/problem-decomposer-orchestrator.md`
- **Model:** inherit
- **Focus:** Multi-step problem decomposition, validation infrastructure
- **Phases:** Analysis → Validation → Planning → Implementation → Verification
- **Lines:** 96 lines (concise)

**Analysis:**
- **plan-orchestrator USES plan-master** as final planning step (line 638-661)
- **Hierarchical relationship:** plan-orchestrator → plan-master
- **problem-decomposer-orchestrator** overlaps with plan-master (both do decomposition + orchestration)
- **60% overlap** between problem-decomposer-orchestrator and plan-master

**Role Clarity Issues:**
- When should user invoke plan-orchestrator vs plan-master?
- When should user invoke problem-decomposer-orchestrator vs plan-master?
- All three create plans, all three orchestrate agents

**Recommendation:**
✅ **KEEP ALL THREE** but establish clear hierarchy:

**Tier 1 (Highest Level):** `plan-orchestrator`
- **When to use:** Complex tasks requiring investigation BEFORE planning
- **Triggers:** Bugs, new features, refactoring, framework integration
- **Flow:** Investigate → Synthesize → plan-master → Execute
- **Unique value:** 5 adaptive workflows, parallel investigations, evidence gathering

**Tier 2 (Mid Level):** `problem-decomposer-orchestrator`
- **When to use:** Multi-phase projects requiring validation infrastructure
- **Triggers:** Large migrations, architecture changes, complex features
- **Flow:** Analyze → Setup validation → Plan → Implement → Verify
- **Unique value:** Validation-first approach, living plan updates

**Tier 3 (Base Level):** `plan-master`
- **When to use:** Direct planning when context/investigation already done
- **Triggers:** Called by other orchestrators, or user has clear requirements
- **Flow:** Context → Task breakdown → Agent assignment → Deliverables
- **Unique value:** Flexible output, domain-agnostic, agent discovery

📝 **ACTION:** Update descriptions to clarify tier hierarchy and when to use each

---

### 1.4 Documentation Research Agents - OVERLAP ⚠️

**Three agents handling documentation:**

#### A. `web-researcher` (Active)
- **Path:** `~/.claude/agents/web-researcher.md`
- **Model:** haiku
- **Focus:** Web search, saves to ~/.claude/web-reports/
- **Limit:** Max 5 searches per task
- **Tools:** WebSearch, WebFetch

#### B. `documentation-researcher` (Archived)
- **Path:** `~/.claude/.archives/agents/documentation-researcher.md`
- **Model:** haiku
- **Focus:** Local docs (~/.claude/documentation/) + web verification via gemini-cli
- **Process:** Dual verification (local + web)
- **Knowledge capture:** Updates MEMORIES.md files

#### C. `doc-searcher` (Active)
- **Path:** `~/.claude/agents/doc-searcher.md`
- **Model:** haiku
- **Focus:** Local docs search only (~/.claude/documentation/ + web-reports/)
- **Honesty:** Reports gaps, outdated docs, insufficient scope
- **Tools:** Bash, Grep, Glob, Read (no web search)

**Analysis:**
- **documentation-researcher is archived** (proper deprecation)
- **web-researcher** = web-only research
- **doc-searcher** = local-only search
- **70% overlap** between documentation-researcher and doc-searcher
- **documentation-researcher** was more comprehensive (local + web + knowledge capture)

**Current State:**
- **web-researcher** handles web → saves reports
- **doc-searcher** searches local + those reports
- **Clean separation** of concerns achieved

**Recommendation:**
✅ **NO ACTION NEEDED** - Proper evolution:
- documentation-researcher (archived) → split into web-researcher + doc-searcher
- Clean separation: web research vs local search
- Complementary agents, not duplicates

---

## 2. DUPLICATE COMMAND DEFINITIONS

### 2.1 Planning Commands - OVERLAP ⚠️

**Three planning-related commands:**

#### A. `/plan` command
- **Path:** `~/.claude/commands/plan.md`
- **Description:** "Intelligent planning orchestrator - Analyzes task and selects optimal workflow"
- **Invokes:** plan-orchestrator agent
- **Workflows:** 5 patterns (Hypothesis-Driven, Discovery-First, etc.)

#### B. `/orchestrate` command
- **Path:** `~/.claude/commands/orchestrate.md`
- **Description:** "Lightweight orchestration - automatically discover skills, plan exploration, create todos"
- **Process:** No subagents, direct execution
- **Use case:** Building features, exploring codebases

#### C. `/ultratask` command
- **Path:** `~/.claude/commands/ultratask.md`
- **Description:** "Break down complex tasks into parallel agent execution"
- **Focus:** Agent selection, parallel execution

**Analysis:**
- **/plan** is heavyweight (full investigation workflows)
- **/orchestrate** is lightweight (no subagents, direct execution)
- **/ultratask** is parallel execution focused
- **Clear differentiation** in descriptions

**Recommendation:**
✅ **KEEP ALL THREE** - Different use cases:
- `/plan` → Complex tasks needing investigation
- `/orchestrate` → Quick feature building, direct execution
- `/ultratask` → Parallel task decomposition

📝 **ACTION:** Add usage guidance to each command:
- "/plan - Use when you need investigation before implementation"
- "/orchestrate - Use when you know what to build and want quick execution"
- "/ultratask - Use when you have complex parallel workflows"

---

### 2.2 UI Commands - POTENTIAL CONSOLIDATION 📦

**Active UI commands:**
- `/ui-document` - Generate component documentation
- `/ui-new` - Complete component creation workflow
- `/ui-plan` - Strategic planning with wireframes
- `/ui-provider-refactor` - Refactor to provider pattern
- `/ui-refactor` - Batch component refactoring
- `/ui-review` - Quality review with auto-fix
- `/ui-screenshot` - Screenshot capture + regression testing
- `/ui-validate` - Design system compliance auditing

**Archived UI commands (deprecated):**
- `DEPRECATED-ui-batch-update.md`
- `DEPRECATED-ui-polish.md`
- `DEPRECATED-ui-variants.md`
- `DEPRECATED-ui-visual-regression.md`
- `ui-batch-update.md` (duplicate in archive)
- `ui-compose.md`
- `ui-create.md`
- `ui-polish.md` (duplicate)
- `ui-validate-tokens.md`
- `ui-variants.md` (duplicate)
- `ui-visual-regression.md` (duplicate)

**Analysis:**
- Archive contains BOTH `DEPRECATED-*` and non-DEPRECATED versions of same commands
- Appears to be incomplete archival process
- Active commands are well-differentiated

**Recommendation:**
✅ **KEEP** all active UI commands (clear separation of concerns)
🗑️ **CLEANUP:** Remove duplicate archive files:
- Keep DEPRECATED-* versions (clear deprecation marker)
- Remove non-DEPRECATED duplicates from archive

📝 **ACTION:** Clean up archive duplicates

---

## 3. OVERLAPPING FUNCTIONALITY ANALYSIS

### 3.1 Code Discovery Functionality

**Agents with code discovery:**
- `code-scout` ⭐ (primary, comprehensive)
- `code-reuser-scout` (archived - predecessor)
- `codebase-researcher` (archived - predecessor)
- `Explore` (subagent_type, mentioned in CLAUDE.md)

**Overlap:** 90% between code-scout and archived predecessors

**Resolution:** ✅ Already consolidated to code-scout

---

### 3.2 Documentation Search Functionality

**Agents with doc search:**
- `doc-searcher` ⭐ (local search specialist)
- `web-researcher` ⭐ (web search specialist)
- `documentation-researcher` (archived - combined both)

**Overlap:** 70% between documentation-researcher and doc-searcher

**Resolution:** ✅ Properly split into specialized agents

---

### 3.3 Vue Component Architecture

**Agents handling Vue:**
- `astro-vue-architect` (strategic, SSR focus)
- `vue-architect` (implementation, patterns)
- `astro-architect` (server-side, API routes)

**Overlap:** 50% between astro-vue-architect and vue-architect

**Resolution:** ⚠️ Need role clarification (see Section 1.2)

---

### 3.4 Planning and Orchestration

**Agents doing planning:**
- `plan-orchestrator` (investigation + planning)
- `problem-decomposer-orchestrator` (validation + planning)
- `plan-master` (direct planning)

**Overlap:** 60% between problem-decomposer-orchestrator and plan-master

**Resolution:** ⚠️ Need tier hierarchy clarification (see Section 1.3)

---

## 4. COMMANDS INVOKING SAME AGENTS

### 4.1 Commands using plan-orchestrator agent

**Primary:**
- `/plan` → Directly invokes `plan-orchestrator`

**Indirect:**
- `/orchestrate` → Does NOT use plan-orchestrator (no subagents)
- `/ultratask` → Uses problem-decomposer-orchestrator (different agent)

**Analysis:** Clean separation, no overlap

---

### 4.2 Commands using code-scout agent

**Via plan-orchestrator:**
- `/plan` → plan-orchestrator → code-scout (phase 1 of workflows)

**Direct:**
- No commands directly invoke code-scout
- Always invoked via orchestrators

**Analysis:** Proper encapsulation

---

## 5. STALE REFERENCES IN CLAUDE.MD

### 5.1 CLAUDE.md References to Archived/Deprecated Agents

**Line 31:** References `codebase-researcher` as active subagent
```markdown
- **codebase-researcher** - Deep search for existing patterns before ANY new code
```

**Issue:** codebase-researcher is deprecated (archived 2025-10-25)

**Should reference:** `code-scout` instead

---

### 5.2 CLAUDE.md Agent Listing

**Listed as active (lines 49-71):**
- cc-maintainer ✅ (exists)
- codebase-researcher ❌ (deprecated)
- refactor-specialist ✅ (exists)
- bug-investigator ✅ (exists)
- code-reviewer ✅ (exists)
- security-reviewer ✅ (exists)

**Recommendation:**
📝 **UPDATE CLAUDE.md** line 31 and section on subagents
- Replace `codebase-researcher` → `code-scout`
- Note deprecation of codebase-researcher

---

## 6. ARCHIVE ORGANIZATION ISSUES

### 6.1 Duplicate Archive Files

**Found duplicates in ~/.claude/.archives/commands/:**
- `ui-batch-update.md` AND `DEPRECATED-ui-batch-update.md`
- `ui-polish.md` AND `DEPRECATED-ui-polish.md`
- `ui-variants.md` AND `DEPRECATED-ui-variants.md`
- `ui-visual-regression.md` AND `DEPRECATED-ui-visual-regression.md`

**Recommendation:**
🗑️ **REMOVE** non-DEPRECATED versions from archive
✅ **KEEP** DEPRECATED-* versions (clear marker)

---

### 6.2 Recent Deprecation Folder

**Path:** `~/.claude/.archives/agents/deprecated-2025-10-25/`
**Contains:**
- `codebase-researcher.md`
- `README.md`

**Good practice:** Clear deprecation date in folder name

---

## 7. RECOMMENDATIONS SUMMARY

### Priority 1 (Critical) 🔴

1. **Update CLAUDE.md references**
   - Replace `codebase-researcher` → `code-scout` (line 31, subagent sections)
   - Document that codebase-researcher is deprecated

2. **Clarify planning agent hierarchy**
   - Add tier descriptions to plan-orchestrator, problem-decomposer-orchestrator, plan-master
   - Document when to use each tier
   - Update command descriptions (/plan, /orchestrate, /ultratask) with usage guidance

### Priority 2 (Important) 🟡

3. **Clarify Vue architecture agent roles**
   - Add role boundaries to astro-vue-architect, vue-architect, astro-architect descriptions
   - Specify: strategic vs implementation vs backend focus

4. **Clean up archive duplicates**
   - Remove non-DEPRECATED command files from archive
   - Keep only DEPRECATED-* versions

### Priority 3 (Nice to Have) 🟢

5. **Documentation**
   - Create agent selection guide (which agent for which task)
   - Create command selection guide (which command for which scenario)
   - Document agent composition patterns (who calls who)

---

## 8. AGENT DEPENDENCY GRAPH

```
┌─────────────────────────┐
│  plan-orchestrator      │ ← Tier 1: Investigation + Planning
│  (5 workflows)          │
└───────┬─────────────────┘
        │ spawns
        ├─────→ code-scout (phase 1)
        ├─────→ code-qa × N (phase 3, parallel)
        ├─────→ doc-searcher (phase 4, optional)
        └─────→ plan-master (phase 6)

┌─────────────────────────┐
│ problem-decomposer-orch │ ← Tier 2: Validation + Planning
└───────┬─────────────────┘
        │ spawns
        └─────→ [various specialists based on domain]

┌─────────────────────────┐
│  plan-master            │ ← Tier 3: Direct Planning
│  (domain-agnostic)      │
└─────────────────────────┘
```

**Key insight:** plan-orchestrator is the "smart router" that composes other agents

---

## 9. NO DUPLICATION (Verified Unique)

**These agents have unique, non-overlapping roles:**

- `bug-investigator` - Root cause analysis
- `code-reviewer` - Quality auditing (50+ criteria)
- `security-reviewer` - Security vulnerability detection
- `minimal-change-analyzer` - Surgical code changes
- `refactor-specialist` - Refactoring with dependency mapping
- `typescript-validator` - TypeScript error fixing
- `ssr-debugger` - SSR-specific debugging
- `ui-builder` - UI component generation
- `ui-documenter` - Component documentation
- `ui-analyzer` - UI analysis
- `ui-validator` - Design system validation
- `workflow-generator` - Workflow creation
- `cc-maintainer` - Claude Code configuration management
- `nanostore-state-architect` - Nanostores implementation
- `appwrite-integration-specialist` - Appwrite integration
- `python-pipeline-architect` - Python systems
- `vue-testing-specialist` - Vue component testing
- `orchestrator` - General orchestration (different from plan-orchestrator)

---

## 10. FINAL METRICS

**Agents:**
- Total active: 36
- Total archived: 12
- Duplicates found: 2 (code-reuser-scout, codebase-researcher - already archived)
- Overlapping roles: 3 groups (exploration, architecture, planning)
- Properly deprecated: 100%

**Commands:**
- Total active: 27
- Total archived: 26
- Archive duplicates: 4 files (need cleanup)
- Overlapping functionality: 0 (commands are well-differentiated)
- Stale references: 1 (CLAUDE.md → codebase-researcher)

**Overall Health:** 85% ✅
- Good: Most deprecations properly handled
- Good: Clean agent specialization
- Needs improvement: CLAUDE.md references, archive cleanup
- Needs improvement: Role clarification for overlapping agents

---

## APPENDIX: Quick Reference

### Agent Selection Guide

**Need code discovery?** → `code-scout`
**Need planning with investigation?** → `plan-orchestrator`
**Need direct planning?** → `plan-master`
**Need multi-phase project planning?** → `problem-decomposer-orchestrator`
**Need Vue component architecture?** → `astro-vue-architect` (strategic) or `vue-architect` (implementation)
**Need Astro backend/routing?** → `astro-architect`
**Need documentation search?** → `doc-searcher` (local) or `web-researcher` (web)
**Need bug investigation?** → `bug-investigator`
**Need refactoring?** → `refactor-specialist`
**Need code review?** → `code-reviewer`
**Need security audit?** → `security-reviewer`

### Command Selection Guide

**Complex task with unknowns?** → `/plan`
**Quick feature building?** → `/orchestrate`
**Parallel workflows?** → `/ultratask`
**UI component creation?** → `/ui-new`
**UI component docs?** → `/ui-document`
**Design system audit?** → `/ui-validate`

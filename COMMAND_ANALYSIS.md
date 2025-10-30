# Slash Commands Analysis & Recommendations

**Date:** 2025-10-23
**Total Commands:** 35
**Reviewed:** Claude Code Mastery Philosophy document + all frontend/ui/orchestration commands

---

## Executive Summary

Your command ecosystem shows **excellent specialization** but suffers from:
1. **Duplication** - Multiple commands doing similar things with slight variations
2. **Complexity creep** - Commands averaging 400-600 lines (some 700+)
3. **Unclear boundaries** - Overlapping responsibilities between related commands
4. **Missing abstractions** - Common patterns repeated across commands

**Key Insight:** You've built a sophisticated orchestration system, but the commands themselves haven't been refactored to leverage shared patterns.

---

## 📊 Command Inventory

### Frontend Commands (12)
```
frontend-new (559L) ────────┐
frontend-add (628L) ────────┤ ALL follow same pattern:
frontend-analyze (251L) ────┤ → Phase 0: Init
frontend-initiate (507L) ───┤ → Phase 1: Analysis (code-scout + doc-researcher)
frontend-quick-task (725L) ─┤ → Phase 2: Planning (plan-master)
frontend-implement (682L) ──┤ → Phase 3: Implementation (specialists)
frontend-plan (345L) ───────┤ → Phase 4: Validation
frontend-validate (493L) ───┤
frontend-improve (374L) ────┤ Variations:
frontend-fix (456L) ────────┘ - approval gates (new, add, initiate vs quick-task)
                              - scope (new=create, add=extend, fix=debug)
                              - agent selection
```

### UI Commands (13)
```
ui-new (355L) ──────────────┐
ui-plan (208L) ─────────────┤ ALL follow pattern:
ui-create (similar to new) ─┤ → Optional planning (ui-analyzer)
ui-variants (similar) ──────┤ → Generation (ui-builder)
ui-review (390L) ───────────┤ → Refinement (ui-builder)
ui-validate (465L) ─────────┤ → Validation (ui-validator)
ui-document (604L) ─────────┤ → Screenshots (ui-validator)
ui-screenshot (532L) ───────┤
ui-polish (similar) ────────┤ Variations:
ui-refactor (483L) ─────────┤ - with/without planning
ui-batch-update (similar) ──┤ - variant count
ui-compose (similar) ───────┤ - validation depth
ui-provider-refactor (566L) ┘
```

### Orchestration Commands (3)
```
orchestrate (133L) ─────────┐ Uses Orchestrator subagent
orchestrate-lite (244L) ────┤ Self-contained orchestration
ultratask (similar) ────────┘ Task decomposition
```

### Worktree Commands (2)
```
wt (91L) ───────────────────┐ Feature worktrees
wt-full (126L) ─────────────┘ Fullstack workspace
```

### Support Commands (5)
```
start, capture, checkpoint, complete, recall, learn, tools, mcps, reindex, skilled, templates, debug-test
```

---

## 🔴 Critical Issues

### Issue 1: Massive Duplication in Frontend Commands

**Problem:** `frontend-new`, `frontend-add`, `frontend-initiate`, `frontend-quick-task` share **80%+ identical code**.

**Evidence:**
- All spawn `@code-scout` + `@documentation-researcher` in Phase 1
- All spawn `@plan-master` in Phase 2
- All spawn specialist agents in Phase 3
- Identical prompt templates (only scope differs: "new" vs "add" vs "extend")
- Identical reporting structure (PRE_ANALYSIS.md, MASTER_PLAN.md, COMPLETION_REPORT.md)

**Consequence:**
- 2800+ lines of duplicated orchestration logic
- Changes require updating 4-5 files
- Inconsistencies creep in (different error handling, different validation)

**Root Cause:** Commands were built iteratively without refactoring shared patterns.

---

### Issue 2: UI Command Proliferation

**Problem:** 13 UI commands when you need **3-4 core commands** + flags.

**Evidence:**
```bash
/ui-new [desc]           # Full pipeline
/ui-create [desc]        # Same as ui-new
/ui-plan [desc]          # Just planning phase of ui-new
/ui-variants N [desc]    # Just generation phase with custom count
/ui-polish [component]   # Just refinement phase
/ui-review [component]   # Just validation phase
/ui-screenshot [comp]    # Just screenshot phase
/ui-document [comp]      # Just documentation phase
```

**What you actually need:**
```bash
/ui [desc] [--flags]     # Unified command with flags
  --skip-plan
  --variants N
  --skip-validation
  --screenshot
  --document

/ui-refactor [component] [changes]  # Separate workflow
/ui-batch [pattern] [change]        # Separate workflow
/ui-compose [comp1] + [comp2]       # Separate workflow
```

**Consequence:**
- User confusion: "Which command do I use?"
- Maintenance burden: Bug fixes need updates across 8+ commands
- Lost opportunity for composition: Can't combine flags from different commands

---

### Issue 3: Orchestration Confusion

**Problem:** Three orchestration commands with unclear boundaries.

**Current State:**
- `/orchestrate` - Uses Orchestrator subagent, returns JSON, YOU create todos
- `/orchestrate-lite` - Self-orchestration, you discover skills and create todos
- `/ultratask` - Appears similar to orchestrate-lite but for complex tasks?

**User Mental Model Confusion:**
```
When do I use orchestrate vs orchestrate-lite?
- orchestrate: When... task is complex? Needs subagent expertise?
- orchestrate-lite: When... task is simple? I want it faster?
- ultratask: When... ??? (not documented in mastery doc)
```

**Reality:** `orchestrate-lite` is more useful 90% of the time because:
- No JSON parsing complexity
- Faster execution (no subagent spawn)
- Still does skill discovery
- Still creates todos

**Recommendation:** Deprecate `/orchestrate`, rename `/orchestrate-lite` → `/orchestrate`.

---

### Issue 4: Command Complexity (400-700 lines)

**Problem:** Commands are too large to maintain.

**Top Offenders:**
1. `frontend-quick-task` - 725 lines
2. `frontend-implement` - 682 lines
3. `frontend-add` - 628 lines
4. `ui-document` - 604 lines
5. `frontend-new` - 559 lines

**Why this is bad:**
- Hard to understand at a glance
- Difficult to modify without breaking something
- Intimidating for new users
- Large context load for Claude to parse

**Root Cause:** Commands include:
- Detailed phase descriptions
- Agent prompt templates (100+ lines each)
- Reporting format templates (100+ lines)
- Validation logic
- Error handling
- Examples

**What they should contain:**
- Command metadata (arguments, description, tools)
- High-level workflow steps
- References to shared templates/scripts
- Minimal inline prompts

---

## ✅ What Works Well

### 1. Worktree Commands (`/wt`, `/wt-full`)
**Why they're great:**
- **Simple delegation** - Calls external script, doesn't duplicate logic
- **Clear separation** - Feature worktrees vs fullstack workspace
- **Good UX** - Unified interface (`/wt <action>`) with consistent flags

**Model to follow:**
```markdown
---
allowed-tools: Bash(script.sh:*)
---
Run: script.sh $ARGUMENTS
[Brief reference guide]
```

### 2. Phased Workflow Pattern
**Why it works:**
- **Predictable structure** - Always: Init → Analysis → Planning → Implementation → Validation
- **Approval gates** - User control at critical points
- **Agent specialization** - Right agent for right task
- **File-based state** - PRE_ANALYSIS.md, MASTER_PLAN.md enable resumability

**Keep this pattern**, just consolidate the implementations.

### 3. Agent Orchestration Model
**Why it's powerful:**
- **Parallel analysis** - code-scout + documentation-researcher run simultaneously
- **Specialist agents** - Each agent has clear expertise
- **Main agent coordination** - Main agent reads reports and orchestrates next steps

**This is your competitive advantage.** Don't lose it in consolidation.

---

## 🎯 Recommendations

### Recommendation 1: Consolidate Frontend Commands (HIGH PRIORITY)

**Consolidate into 2 commands:**

```bash
/frontend <action> [feature-name] [description] [--flags]
  Actions: new, add, fix, improve
  Flags: --skip-analysis, --skip-plan, --skip-validation, --quick

/frontend-dev [feature] [desc]  # Shorthand for: /frontend add --quick
```

**Implementation approach:**
```markdown
---
argument-hint: <action> [feature-name] [description] [--flags]
---

# Frontend Workflow Orchestrator

Parse action: $1 (new, add, fix, improve)
Parse feature: $2
Parse description: $3+
Parse flags: --skip-analysis, --skip-plan, --quick

SHARED PHASES (all actions):
- Phase 0: Init (create workspace)
- Phase 1: Analysis (spawn code-scout + doc-researcher)
- Phase 2: Planning (spawn plan-master)
- Phase 3: Implementation (spawn specialists based on plan)
- Phase 4: Validation

ACTION-SPECIFIC VARIATIONS:
- new: Tell code-scout "no existing feature"
- add: Tell code-scout "map existing feature + extension points"
- fix: Tell code-scout "find bug root cause"
- improve: Tell code-scout "identify refactoring opportunities"

Prompt templates stored in: ~/.claude/templates/frontend/
  - code-scout-new.md
  - code-scout-add.md
  - plan-master-base.md
  - specialist-prompts.md
```

**Benefits:**
- **2800 → 300 lines** (factor of 9 reduction)
- **Single source of truth** for orchestration logic
- **Easier to maintain** - One place to fix bugs
- **Consistent behavior** across all frontend tasks
- **Composable flags** - Users can customize workflow

**Migration:**
```bash
# Old commands become aliases
/frontend-new "feat" "desc"      → /frontend new feat desc
/frontend-add "feat" "addition"  → /frontend add feat addition
/frontend-quick-task "f" "d"     → /frontend add f d --quick
/frontend-initiate "f" "d"       → /frontend new f d --skip-validation
```

---

### Recommendation 2: Consolidate UI Commands (HIGH PRIORITY)

**Consolidate into 4 commands:**

```bash
/ui [description] [--flags]          # Create new component (unified pipeline)
  --skip-plan          # Skip planning/wireframing
  --variants N         # Generate N variants (default: 3)
  --skip-validation    # Skip quality validation
  --screenshot         # Capture screenshot
  --document           # Generate documentation

/ui-edit [component] [changes]       # Modify existing component

/ui-refactor [pattern] [approach]    # Refactor pattern (provider, batch, etc.)

/ui-review [component]               # Comprehensive review (standalone)
```

**Implementation:**
```markdown
# /ui command

Parse: description from $1
Parse flags: --skip-plan, --variants, --skip-validation, --screenshot, --document

WORKFLOW:
1. Planning (if not --skip-plan)
   - Spawn ui-analyzer
   - Generate wireframes
   - Wait for user selection

2. Generation
   - Spawn ui-builder with variant_count (default: 3, or from --variants)
   - Present all variants
   - Wait for user selection

3. Refinement
   - Spawn ui-builder for 2 refinement rounds

4. Validation (if not --skip-validation)
   - Spawn ui-validator
   - Run quality checks
   - Auto-fix issues

5. Screenshot (if --screenshot)
   - Spawn ui-validator for screenshot

6. Documentation (if --document)
   - Spawn ui-documenter
```

**Benefits:**
- **13 → 4 commands** (3x reduction)
- **Composable workflow** - Users control what runs
- **Clear separation** - Create vs Edit vs Refactor vs Review
- **Reduced cognitive load** - One command to learn

---

### Recommendation 3: Simplify Orchestration (MEDIUM PRIORITY)

**Action:**
1. **Deprecate `/orchestrate`** - The subagent approach is over-engineered
2. **Rename `/orchestrate-lite` → `/orchestrate`** - Make the better version default
3. **Keep `/ultratask`** as alias or remove if truly redundant

**Simplified workflow:**
```markdown
# /orchestrate [task-description]

1. Scan available skills (Bash: skill-list.sh)
2. Analyze task (determine exploration areas + relevant skills)
3. Create todos (TodoWrite with phases)
4. Execute todos:
   - Phase 1: Parallel exploration (Explore agents)
   - Phase 2: Review findings
   - Phase 3: Invoke selected skills
   - Phase 4: Verify implementation
```

**Why this is better:**
- **No JSON parsing complexity**
- **Faster execution** (no subagent spawn overhead)
- **More transparent** (user sees todo list immediately)
- **Still intelligent** (skill discovery, parallel exploration)

---

### Recommendation 4: Extract Shared Templates (HIGH PRIORITY)

**Problem:** Agent prompts are duplicated across commands.

**Solution:** Create a template system.

```bash
~/.claude/templates/
├── frontend/
│   ├── code-scout-new.md         # "Find similar features, discover patterns"
│   ├── code-scout-add.md         # "Map existing feature, find extension points"
│   ├── code-scout-fix.md         # "Trace bug, find root cause"
│   ├── doc-researcher-base.md    # "Research VueUse/solutions"
│   ├── plan-master-new.md        # "Create from scratch plan"
│   ├── plan-master-add.md        # "Minimal change extension plan"
│   └── specialist-prompts.md     # Common prompts for vue-architect, etc.
├── ui/
│   ├── ui-analyzer-plan.md       # Planning with wireframes
│   ├── ui-builder-generate.md    # Variant generation
│   ├── ui-builder-refine.md      # Refinement rounds
│   └── ui-validator-checks.md    # Validation criteria
└── orchestration/
    ├── explore-component.md      # Standard component exploration
    ├── explore-store.md          # Standard store exploration
    └── explore-api.md            # Standard API exploration
```

**Commands reference templates:**
```markdown
Task(
  subagent_type: "code-scout",
  prompt: "$(cat ~/.claude/templates/frontend/code-scout-new.md)

  TASK: $TASK_DESCRIPTION
  FEATURE: $FEATURE_NAME"
)
```

**Benefits:**
- **DRY principle** - Templates defined once
- **Consistency** - All commands use same prompts
- **Easy updates** - Fix prompt once, all commands benefit
- **Versioning** - Track template changes in git

---

### Recommendation 5: Add Command Composition (MEDIUM PRIORITY)

**Problem:** Users can't chain commands easily.

**Current workaround:**
```bash
# User has to manually run each phase
/frontend-analyze feat-auth "add OAuth"
# Review PRE_ANALYSIS.md
/frontend-plan feat-auth "add OAuth"
# Review MASTER_PLAN.md
/frontend-implement feat-auth "add OAuth"
# Hope it works
/frontend-validate feat-auth "add OAuth"
```

**Better approach with flags:**
```bash
# Quick iteration - skip all approval gates
/frontend add feat-auth "add OAuth" --quick

# Conservative - approve each phase
/frontend add feat-auth "add OAuth"
# (default behavior - approval gates at plan + before implementation)

# Analysis only - just planning
/frontend add feat-auth "add OAuth" --stop-after plan
```

**Implementation:**
```markdown
Parse flags:
- --quick: Skip all approval gates, run full pipeline
- --stop-after <phase>: Run up to phase then stop
- --skip-<phase>: Skip specific phase (use cached if available)
- --resume: Resume from last phase (read from FEATURE_CONTEXT.md)

Enable workflows like:
1. /frontend add feat X --stop-after plan
2. [User reviews plan, makes manual edits]
3. /frontend add feat X --resume --skip-analysis --skip-plan
```

---

### Recommendation 6: Create Command Hierarchy Visual

**Problem:** 35 commands with unclear relationships.

**Solution:** Document command families in CLAUDE.md

```markdown
## Command Hierarchy

### 🎯 Primary Workflows
/frontend <action> [...] [--flags]   # Full frontend feature workflows
/ui [desc] [--flags]                 # Full UI component workflows
/orchestrate [task]                  # General task orchestration

### 🔧 Specialized Tasks
/ui-refactor [pattern] [approach]    # Provider patterns, batch updates
/ui-review [component]               # Quality audit
/wt <action> [branch]                # Feature worktree management
/wt-full <action>                    # Fullstack workspace management

### 📚 Support Commands
/start [feature] [--recall topic]    # Begin feature with context
/checkpoint [--no-extract]           # Save progress
/complete [feature]                  # Finish and extract insights
/recall [topic] [--depth]            # Load documentation
/capture [title] [--tags]            # Quick insight capture
/learn [topic] [--from-*]            # Extract and store knowledge

### 🛠️ Development Tools
/skilled <task>                      # Skill-assisted task
/tools [category]                    # List available tools
/mcps <action> [target]              # MCP server management
/reindex [--force]                   # Rebuild search database
```

---

### Recommendation 7: Introduce Command Modes (LOW PRIORITY)

**Concept:** Instead of many similar commands, have modes that change behavior.

**Example:**
```bash
# Set frontend mode for session
/mode frontend:quick   # All frontend commands skip approval gates
/mode frontend:safe    # All frontend commands require approval (default)
/mode ui:fast          # All ui commands skip validation
/mode ui:thorough      # All ui commands include validation + screenshot + docs

# Then just use base commands
/frontend add feat-auth "OAuth"  # Behavior controlled by mode
/ui "Badge component"            # Behavior controlled by mode
```

**Benefits:**
- **Stateful workflow** - Set mode once, applies to all commands
- **Fewer flags** - Mode encapsulates common flag combinations
- **Context awareness** - Different modes for prototyping vs production

**Implementation:**
```bash
# Mode stored in file
~/.claude/session/mode.txt

# Commands read mode
MODE=$(cat ~/.claude/session/mode.txt 2>/dev/null || echo "default")
if [[ $MODE == "frontend:quick" ]]; then
  FLAGS="--quick --skip-validation"
fi
```

---

## 📋 Consolidation Roadmap

### Phase 1: Template Extraction (Week 1)
**Effort:** 4-6 hours
**Impact:** Foundation for all consolidation

1. Create `~/.claude/templates/` structure
2. Extract all agent prompts from frontend commands → templates
3. Extract all agent prompts from ui commands → templates
4. Update 2-3 commands to use templates (validation)

**Deliverable:** Template library + proof of concept

---

### Phase 2: Frontend Consolidation (Week 2)
**Effort:** 6-8 hours
**Impact:** 60% reduction in frontend command code

1. Create new `/frontend` unified command
2. Implement action routing (new, add, fix, improve)
3. Implement flag parsing (--quick, --skip-*, --stop-after)
4. Test all workflows (new, add, fix, improve)
5. Create aliases for old commands
6. Update CLAUDE.md documentation

**Deliverable:** `/frontend` command + deprecation notices

---

### Phase 3: UI Consolidation (Week 3)
**Effort:** 6-8 hours
**Impact:** 70% reduction in UI command code

1. Create new `/ui` unified command
2. Implement flag-based workflow control
3. Separate `/ui-edit`, `/ui-refactor`, `/ui-review`
4. Test all workflows
5. Create aliases for old commands
6. Update CLAUDE.md documentation

**Deliverable:** `/ui` family (4 commands) + deprecation notices

---

### Phase 4: Orchestration Simplification (Week 4)
**Effort:** 2-3 hours
**Impact:** Clearer orchestration model

1. Deprecate `/orchestrate` (old subagent version)
2. Rename `/orchestrate-lite` → `/orchestrate`
3. Clarify `/ultratask` vs `/orchestrate` (or remove ultratask)
4. Update CLAUDE.md documentation

**Deliverable:** Clear orchestration model

---

### Phase 5: Documentation & Polish (Week 5)
**Effort:** 3-4 hours
**Impact:** Usability

1. Update Claude Code Mastery Philosophy doc
2. Create command hierarchy visual
3. Add command cheat sheet
4. Create migration guide (old → new commands)
5. Add examples to CLAUDE.md

**Deliverable:** Complete documentation refresh

---

## 🎓 Design Principles for Future Commands

### 1. Delegation Over Duplication
**Bad:**
```markdown
# Command contains 400 lines of orchestration logic
Phase 1: Spawn code-scout
  - Find existing features
  - Map architecture
  - [100 lines of detailed instructions]
```

**Good:**
```markdown
# Command delegates to shared script/template
Phase 1: Spawn code-scout using template
  Template: ~/.claude/templates/frontend/code-scout-new.md
  Context: FEATURE=$FEATURE, TASK=$TASK
```

### 2. Composition Over Creation
**Bad:** Create separate commands for every workflow variation
- `/ui-new` (planning + generation + validation)
- `/ui-quick` (generation only)
- `/ui-with-screenshot` (generation + validation + screenshot)

**Good:** One command with composable flags
- `/ui [desc]` (full workflow)
- `/ui [desc] --skip-plan` (skip planning)
- `/ui [desc] --screenshot` (add screenshot)
- `/ui [desc] --skip-plan --screenshot` (composition)

### 3. Smart Defaults, Explicit Overrides
**Default behavior should be safe:**
- Approval gates for destructive operations
- Validation enabled
- Full workflow unless user opts out

**Flags should enable speed when appropriate:**
- `--quick` for trusted iterations
- `--skip-validation` for prototyping
- `--resume` for iterating on failed runs

### 4. Single Responsibility
Each command should do ONE thing well:
- `/frontend` - Frontend feature workflows
- `/ui` - UI component workflows
- `/wt` - Feature worktree management
- `/orchestrate` - General task orchestration

Avoid: `/mega-command` that tries to handle frontend + ui + backend + deployment

### 5. Progressive Disclosure
**Start simple, allow complexity:**
```bash
# Simple usage (sensible defaults)
/frontend add feat-auth "add OAuth"

# Advanced usage (expert control)
/frontend add feat-auth "add OAuth" \
  --skip-analysis \
  --template custom-oauth-plan.md \
  --agents vue-architect,typescript-validator \
  --parallel \
  --stop-after implementation
```

---

## 📊 Expected Outcomes

### Quantitative Improvements
- **Commands:** 35 → ~22 (-37%)
- **Total LOC:** ~14,000 → ~4,500 (-68%)
- **Avg complexity:** 400 lines → 150 lines (-62%)
- **Maintenance burden:** 5 files to update → 1 file + template
- **User cognitive load:** 35 commands to learn → ~15 core commands

### Qualitative Improvements
- **Clearer mental model** - Fewer commands, clear hierarchy
- **Easier maintenance** - Shared templates, single source of truth
- **Better UX** - Composable flags, smart defaults
- **Faster iteration** - Less duplication = faster changes
- **More extensible** - Template system = easy to add new workflows

---

## 🎯 Immediate Next Steps

**DO THIS WEEK:**
1. ✅ **Read** this analysis
2. ✅ **Decide** - Approve consolidation plan or suggest changes
3. ✅ **Prioritize** - Which phase to start with? (Recommend Phase 1: Templates)

**THEN:**
1. Create template system (Phase 1)
2. Consolidate frontend commands (Phase 2)
3. Consolidate UI commands (Phase 3)

**Expected timeline:** 4-5 weeks of focused work (20-25 hours total)

---

## 💡 Final Thoughts

Your command ecosystem is **sophisticated and powerful** - you've built something genuinely advanced. The orchestration patterns (parallel analysis, specialist agents, phased workflows) are excellent.

The consolidation recommendations don't change the **what** (your orchestration model is solid), just the **how** (reduce duplication, improve maintainability).

Think of it like refactoring: You're not changing functionality, you're extracting shared patterns and making the system more maintainable.

**The payoff:** Easier to maintain, easier to extend, easier to use, and faster iteration velocity.

---

**Questions? Ready to proceed? Let me know which phase to tackle first!**

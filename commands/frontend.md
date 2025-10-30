---
allowed-tools: Bash, Read, Write, Edit, TodoWrite, Task, Glob, Grep, WebSearch, WebFetch
argument-hint: <action> [feature-name] [description] [--flags]
description: Unified frontend feature workflows (new, add, fix, improve)
---

# Frontend Workflow Orchestrator

**Unified command for all frontend feature work**

**Usage:** `/frontend <action> [feature-name] [description] [--flags]`

---

## Actions

- `new` - Create brand new feature from scratch
- `add` - Add functionality to existing feature
- `fix` - Debug and fix issues in existing feature
- `improve` - Refactor and improve existing code

---

## Flags

- `--quick` - Skip approval gates, run full pipeline
- `--skip-analysis` - Skip analysis phase (use cached if available)
- `--skip-plan` - Skip planning phase (use cached if available)
- `--skip-validation` - Skip validation phase
- `--stop-after <phase>` - Run up to phase then stop (analysis, plan, implementation)
- `--resume` - Resume from last phase (read from FEATURE_CONTEXT.md)

---

## Parse Arguments

**Arguments:** `$ARGUMENTS`

```bash
# Parse action (first argument)
ACTION=$(echo "$ARGUMENTS" | awk '{print $1}')

# Parse feature name (second argument)
FEATURE_NAME=$(echo "$ARGUMENTS" | awk '{print $2}')

# Parse description (remaining arguments before flags)
# Extract everything after feature name until flags start
DESCRIPTION=$(echo "$ARGUMENTS" | sed -E 's/^[^ ]+ [^ ]+ //; s/ --.*$//')

# Parse flags
FLAGS=$(echo "$ARGUMENTS" | grep -oE '\--[a-z-]+' || echo "")

# Validate action
case "$ACTION" in
    new|add|fix|improve)
        ;;
    *)
        echo "Error: Invalid action '$ACTION'. Use: new, add, fix, or improve"
        exit 1
        ;;
esac

# Validate feature name
if [ -z "$FEATURE_NAME" ]; then
    echo "Error: Feature name required"
    echo "Usage: /frontend <action> <feature-name> <description> [--flags]"
    exit 1
fi

# Validate description (unless --resume)
if [ -z "$DESCRIPTION" ] && ! echo "$FLAGS" | grep -q "\--resume"; then
    echo "Error: Description required (or use --resume)"
    exit 1
fi
```

---

## Workflow Configuration

**Action-Specific Template Selection:**

```bash
# Select templates based on action
case "$ACTION" in
    new)
        CODE_SCOUT_TEMPLATE="frontend/code-scout-new"
        PLAN_MASTER_TEMPLATE="frontend/plan-master-new"
        ;;
    add)
        CODE_SCOUT_TEMPLATE="frontend/code-scout-add"
        PLAN_MASTER_TEMPLATE="frontend/plan-master-add"
        ;;
    fix)
        CODE_SCOUT_TEMPLATE="frontend/code-scout-fix"  # TODO: Create this template
        PLAN_MASTER_TEMPLATE="frontend/plan-master-fix"
        ;;
    improve)
        CODE_SCOUT_TEMPLATE="frontend/code-scout-improve"  # TODO: Create this template
        PLAN_MASTER_TEMPLATE="frontend/plan-master-improve"
        ;;
esac
```

---

## Phase 0: Initialization

### Create Todo List

```json
{
  "todos": [
    {
      "content": "Initialize workspace and context",
      "status": "in_progress",
      "activeForm": "Initializing workspace"
    },
    {
      "content": "Phase 1: Analysis (code-scout + doc-researcher)",
      "status": "pending",
      "activeForm": "Running analysis"
    },
    {
      "content": "Consolidate analysis findings",
      "status": "pending",
      "activeForm": "Consolidating analysis"
    },
    {
      "content": "Phase 2: Planning (plan-master)",
      "status": "pending",
      "activeForm": "Creating implementation plan"
    },
    {
      "content": "Present plan for approval",
      "status": "pending",
      "activeForm": "Presenting plan"
    },
    {
      "content": "Phase 3: Implementation (specialist agents)",
      "status": "pending",
      "activeForm": "Executing implementation"
    },
    {
      "content": "Phase 4: Validation and completion",
      "status": "pending",
      "activeForm": "Validating implementation"
    }
  ]
}
```

### Create Workspace

```bash
WORKSPACE_PATH=".temp/${ACTION}-${FEATURE_NAME}-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$WORKSPACE_PATH"
mkdir -p "$WORKSPACE_PATH/reports"

# Store feature context
cat > "$WORKSPACE_PATH/FEATURE_CONTEXT.md" <<EOF
# Feature Context

**Action:** $ACTION
**Feature Name:** $FEATURE_NAME
**Description:** $DESCRIPTION
**Created:** $(date)
**Command:** /frontend $ACTION

---

This file stores context for resuming work with --resume flag.
EOF
```

---

## Phase 1: Analysis

**Skip if:** `--skip-analysis` or `--resume` (and PRE_ANALYSIS.md exists)

### Step 1: Spawn Analysis Agents in Parallel

**Load templates and spawn agents:**

#### Agent 1: Code Scout

```bash
# Load template with variable substitution
CODE_SCOUT_PROMPT=$(~/.claude/scripts/load-template.sh \
    "$CODE_SCOUT_TEMPLATE" \
    "FEATURE_NAME=$FEATURE_NAME" \
    "FEATURE_DESCRIPTION=$DESCRIPTION" \
    "WORKSPACE_PATH=$WORKSPACE_PATH")

# Spawn agent with Task tool
Task(
  subagent_type: "code-scout",
  description: "Analyze codebase for $ACTION: $FEATURE_NAME",
  prompt: """$CODE_SCOUT_PROMPT"""
)
```

#### Agent 2: Web Researcher

```bash
# Load template
WEB_RESEARCHER_PROMPT=$(~/.claude/scripts/load-template.sh \
    "frontend/web-researcher" \
    "FEATURE_DESCRIPTION=$DESCRIPTION" \
    "WORKSPACE_PATH=$WORKSPACE_PATH")

# Spawn agent with Task tool
Task(
  subagent_type: "web-researcher",
  description: "Research solutions for $DESCRIPTION",
  prompt: """$WEB_RESEARCHER_PROMPT"""
)
```

**Wait for both agents to complete.**

### Step 2: Consolidate Analysis

After both agents complete:
1. Read both agent outputs
2. Consolidate into `PRE_ANALYSIS.md`
3. Update todo list

---

## Phase 2: Planning

**Skip if:** `--skip-plan` or `--stop-after analysis`

### Spawn Planning Agent

```bash
# Load plan-master template
PLAN_MASTER_PROMPT=$(~/.claude/scripts/load-template.sh \
    "$PLAN_MASTER_TEMPLATE" \
    "FEATURE_NAME=$FEATURE_NAME" \
    "FEATURE_DESCRIPTION=$DESCRIPTION" \
    "WORKSPACE_PATH=$WORKSPACE_PATH")

# Spawn plan-master
Task(
  subagent_type: "plan-master",
  description: "Create implementation plan for $ACTION: $FEATURE_NAME",
  prompt: """$PLAN_MASTER_PROMPT"""
)
```

**Wait for plan-master to complete.**

### Review Plan

Read `MASTER_PLAN.md` and update todo list with tasks from plan.

### ⚠️ APPROVAL GATE (unless --quick)

**Stop and present plan to user:**

```markdown
## Plan Ready for Review ✅

**Action:** $ACTION
**Feature:** $FEATURE_NAME
**Description:** $DESCRIPTION

### Analysis Summary
[Summarize key findings from PRE_ANALYSIS.md]

### Implementation Plan
[Summarize approach from MASTER_PLAN.md]

### Documents
- Analysis: $WORKSPACE_PATH/PRE_ANALYSIS.md
- Plan: $WORKSPACE_PATH/MASTER_PLAN.md

**Ready to proceed with implementation?**
(Or run: `/frontend $ACTION $FEATURE_NAME --resume --skip-analysis --skip-plan`)
```

**If --quick flag:** Skip approval, proceed directly to Phase 3.

**If --stop-after plan:** Stop here, allow user to review.

---

## Phase 3: Implementation

**Skip if:** `--stop-after plan`

### Intelligent Agent Selection

Read `MASTER_PLAN.md` and determine which specialist agents to spawn based on tasks defined.

**Available Specialist Agents:**
- `code-scout` - Find existing patterns (ALWAYS RUN FIRST)
- `nanostore-state-architect` - State management
- `vue-architect` - Vue 3 components
- `astro-architect` - Astro pages/routes
- `ui-builder` - Component generation
- `typescript-validator` - Type safety
- `appwrite-integration-specialist` - Backend integration
- `ssr-debugger` - SSR issues

### Pre-Implementation: Reusability Check

```bash
Task(
  subagent_type: "code-scout",
  description: "Find existing patterns before implementation",
  prompt: """
Read: $WORKSPACE_PATH/MASTER_PLAN.md

Search codebase for:
1. Existing components similar to [list from plan]
2. Existing composables that solve [functionality from plan]
3. Existing stores managing [state from plan]
4. Similar implementations elsewhere

Report:
- EXACT MATCHES (100%)
- NEAR MATCHES (70-90%)
- BASE COMPONENTS to extend/compose
- PATTERNS TO FOLLOW

Recommendation: REUSE, EXTEND, or CREATE NEW
"""
)
```

### Execute Plan Phases

Based on MASTER_PLAN.md, execute phases:

**Phase 1: Foundation**
- Spawn foundation agents (stores, composables, types)
- Wait for completion
- Collect reports

**Phase 2: Implementation**
- Spawn implementation agents (components, pages)
- Wait for completion
- Collect reports

**Phase 3: Integration**
- Spawn integration agents (backend, API routes)
- Wait for completion
- Collect reports

**Phase 4: Quality**
- Run validation
- Spawn testing agents if needed

---

## Phase 4: Validation

**Skip if:** `--skip-validation`

### Automated Validation

```bash
# Type checking
pnpm run typecheck

# Linting
pnpm run lint

# Build verification
pnpm run build

# Tests
pnpm run test
```

### Create Completion Report

```markdown
# Completion Report: $ACTION - $FEATURE_NAME

**Action:** $ACTION
**Feature:** $FEATURE_NAME
**Description:** $DESCRIPTION
**Date:** $(date)
**Status:** [Success/Partial/Blocked]

## Summary

**What Was Done:**
[Brief description]

**Approach:**
[Summary of implementation strategy]

**Files Changed:**
- Modified: [N] files
- Created: [N] files
- Lines: ~[X] added, ~[Y] removed

## Validation Results

- Type check: [Pass/Fail]
- Lint: [Pass/Fail]
- Build: [Success/Fail]
- Tests: [All passing / X failing]

## Artifacts

- Analysis: $WORKSPACE_PATH/PRE_ANALYSIS.md
- Plan: $WORKSPACE_PATH/MASTER_PLAN.md
- Agent Reports: $WORKSPACE_PATH/reports/

## Next Steps

[Any follow-up tasks]
```

### Present Results

```markdown
# $ACTION Complete ✅

**Feature:** $FEATURE_NAME
**Description:** $DESCRIPTION

**Summary:**
[What was built/modified]

**Status:**
[Success/Partial details]

**Validation:**
- ✅ Type check passed
- ✅ Lint passed
- ✅ Build successful
- ✅ Tests passing

**Full Report:**
$WORKSPACE_PATH/COMPLETION_REPORT.md

**Ready for:**
- Code review
- PR creation
- Deployment
```

---

## Usage Examples

### Create New Feature
```bash
/frontend new user-profile "User profile page with avatar and bio"
```

### Add to Existing Feature
```bash
/frontend add user-profile "Add social media links section"
```

### Quick Addition (No Approval Gates)
```bash
/frontend add user-profile "Add edit button" --quick
```

### Fix Bug
```bash
/frontend fix user-profile "Profile not loading on mobile"
```

### Improve Code
```bash
/frontend improve user-profile "Extract profile card into reusable component"
```

### Resume After Planning
```bash
# First: Analyze and plan
/frontend add feat-auth "OAuth" --stop-after plan

# Review plans...

# Then: Resume implementation
/frontend add feat-auth --resume --skip-analysis --skip-plan
```

---

## Migration from Old Commands

Old commands are deprecated but still work:

| Old | New |
|-----|-----|
| `/frontend-new feat "desc"` | `/frontend new feat "desc"` |
| `/frontend-add feat "add"` | `/frontend add feat "add"` |
| `/frontend-quick-task feat "add"` | `/frontend add feat "add" --quick` |
| `/frontend-initiate feat "desc"` | `/frontend new feat "desc" --stop-after plan` |
| `/frontend-implement feat` | `/frontend new feat --resume --skip-analysis --skip-plan` |

---

## Key Benefits

✅ **Single command** for all frontend workflows
✅ **Composable flags** for workflow control
✅ **Template-based** prompts (DRY principle)
✅ **Consistent orchestration** across all actions
✅ **Resumable** workflows with --resume flag
✅ **Flexible** approval gates with --quick flag

---

## Execution Instructions

**Claude, follow this workflow:**

1. Parse arguments and select action-specific templates
2. Create todo list and workspace
3. Execute phases (Analysis → Planning → Implementation → Validation)
4. Respect flags (--quick, --skip-*, --stop-after)
5. Present results at completion

**Remember:**
- Use template loader: `~/.claude/scripts/load-template.sh`
- Spawn agents with proper template prompts
- Update todo list after each phase
- Present clear approval gates (unless --quick)
- Collect reports from all agents

# Orchestrator System Documentation

## Overview

The Orchestrator System is an intelligent task planning framework that:
1. Clarifies vague user requests autonomously
2. Discovers and selects relevant skills from ~/.claude/skills/
3. Plans codebase exploration via Explore agents
4. Auto-creates structured todos via SubagentStop hook

## Architecture

```
User: "/orchestrate [vague request]"
         ↓
   Main Agent
         ↓
   Invokes Orchestrator Subagent
         ↓
   Orchestrator:
     - Interprets request
     - Discovers skills (via Bash)
     - Plans exploration
     - Outputs JSON
         ↓
   SubagentStop Hook Triggered
         ↓
   Hook Script (process-orchestrator.sh):
     - Parses JSON
     - Creates todos
     - Generates summary
         ↓
   Main Agent:
     - Executes exploration todos
     - Executes implementation todos
         ↓
   Task Complete!
```

## Components

### 1. Orchestrator Subagent
**File:** `~/.claude/agents/orchestrator.md`

**Capabilities:**
- Autonomous request clarification (no user questions)
- Skill discovery via `ls ~/.claude/skills/` and `grep`
- Exploration planning with glob patterns
- Structured JSON output

**Tools:** `[Read, Bash, Grep, Glob]` (read-only)

**Invocation:** Manual - user says "use orchestrator" or uses `/orchestrate`

### 2. SubagentStop Hook
**Configuration:** `~/.claude/settings.json` → `SubagentStop` section

**Matcher:** `"orchestrator"` (triggers only for orchestrator subagent)

**Script:** `~/.claude/hooks/process-orchestrator.sh`

**Actions:**
- Reads orchestrator JSON from stdin
- Validates JSON structure
- Extracts exploration and implementation todos
- Creates combined todo list
- Sets first todo to `in_progress`
- Outputs summary message for main agent

### 3. Hook Script
**File:** `~/.claude/hooks/process-orchestrator.sh`

**Input:** Orchestrator JSON via stdin

**Output:**
```json
{
  "systemMessage": "Summary of orchestrator analysis...",
  "todoFile": "/tmp/orchestrator-todos-$$.json",
  "orchestratorOutput": "/tmp/orchestrator-output-$$.json"
}
```

**Logging:** `~/.claude/logs/orchestrator.log`

### 4. Slash Command
**File:** `~/.claude/commands/orchestrate.md`

**Usage:** `/orchestrate <user_request>`

**Purpose:** Convenient wrapper for invoking orchestrator

## Workflow

### Example Request: "I need a profile thing"

**Step 1: User Invokes**
```
/orchestrate I need a profile thing
```

**Step 2: Orchestrator Analyzes**
- Clarifies: "User wants to create a user profile component with authentication"
- Discovers skills:
  - vue-component-builder (Vue component creation)
  - appwrite-integration (User data fetching)
  - nanostore-builder (State management)
- Plans exploration:
  - src/components/**/Profile*.vue
  - src/stores/**/user*.ts
- Outputs JSON with todos

**Step 3: Hook Processes JSON**
- Parses orchestrator output
- Creates todos:
  - Exploration: "Explore src/components for Profile components"
  - Exploration: "Explore src/stores for user state"
  - Implementation: "Create UserProfile using vue-component-builder"
  - Implementation: "Integrate auth using appwrite-integration"
- Sets first todo to in_progress

**Step 4: Main Agent Executes**
1. ✓ Invoke Explore agent for src/components/**/Profile*.vue
2. ✓ Invoke Explore agent for src/stores/**/user*.ts
3. ✓ Review findings
4. ✓ Invoke vue-component-builder skill
5. ✓ Invoke appwrite-integration skill
6. ✓ Complete!

## Orchestrator JSON Format

```json
{
  "original_request": "User's exact words",
  "clarified_request": "Detailed interpretation with assumptions",
  "assumptions_made": [
    "Assumption 1 with reasoning",
    "Assumption 2 with reasoning"
  ],
  "selected_skills": [
    {
      "name": "skill-name",
      "path": "~/.claude/skills/skill-name",
      "reason": "Why this skill is needed"
    }
  ],
  "exploration_plan": [
    {
      "area": "src/components/**/Profile*",
      "glob_pattern": "src/components/**/Profile*.vue",
      "reason": "Find existing profile patterns",
      "priority": "high"
    }
  ],
  "todos": {
    "exploration": [
      {
        "content": "Explore X for Y",
        "activeForm": "Exploring X for Y",
        "glob": "src/**/*.vue",
        "priority": "high"
      }
    ],
    "implementation": [
      {
        "content": "Create X using Y skill",
        "activeForm": "Creating X",
        "skill": "skill-name"
      }
    ]
  },
  "estimated_complexity": "low|medium|high",
  "suggested_approach": "Research-first strategy description"
}
```

## Usage Patterns

### Pattern 1: Vague Feature Request
```
/orchestrate make a settings page
```
**Orchestrator:**
- Clarifies: "Create user settings page with Astro SSR + Vue components"
- Skills: astro-routing, vue-component-builder, nanostore-builder
- Exploration: existing settings pages, form components
- Todos: explore → implement

### Pattern 2: Bug Fix
```
/orchestrate fix the broken auth
```
**Orchestrator:**
- Clarifies: "Debug Appwrite authentication - likely session/token issue"
- Skills: appwrite-integration, typescript-fixer
- Exploration: auth utilities, auth stores, API routes
- Todos: explore auth code → debug → fix

### Pattern 3: Refactor
```
/orchestrate consolidate the duplicate forms
```
**Orchestrator:**
- Clarifies: "Find and consolidate duplicate form components"
- Skills: vue-component-builder, codebase-researcher
- Exploration: all form components, shared utilities
- Todos: map duplicates → create base component → refactor

## Configuration

### Enable/Disable Hook

**Disable:**
```json
{
  "SubagentStop": [
    {
      "matcher": "orchestrator",
      "hooks": []  // Empty hooks array
    }
  ]
}
```

**Enable:**
```json
{
  "SubagentStop": [
    {
      "matcher": "orchestrator",
      "hooks": [
        {
          "type": "command",
          "command": "~/.claude/hooks/process-orchestrator.sh",
          "timeout": 5000,
          "continueOnError": true
        }
      ]
    }
  ]
}
```

### Adjust Hook Timeout

Default: 5000ms (5 seconds)

For complex projects, increase:
```json
{
  "timeout": 10000  // 10 seconds
}
```

### View Hook Logs

```bash
tail -f ~/.claude/logs/orchestrator.log
```

## Troubleshooting

### Hook Not Triggering

**Check 1:** Verify orchestrator subagent exists
```bash
ls -l ~/.claude/agents/orchestrator.md
```

**Check 2:** Verify hook script is executable
```bash
ls -l ~/.claude/hooks/process-orchestrator.sh
# Should show: -rwxr-xr-x
```

**Check 3:** Check hook configuration
```bash
jq '.hooks.SubagentStop' ~/.claude/settings.json
```

**Check 4:** View hook logs
```bash
cat ~/.claude/logs/orchestrator.log
```

### Invalid JSON from Orchestrator

**Symptom:** Hook logs show "ERROR: Invalid JSON"

**Solution:**
1. Check orchestrator output:
   ```bash
   cat /tmp/orchestrator-output-*.json
   ```
2. Validate JSON:
   ```bash
   jq empty /tmp/orchestrator-output-*.json
   ```
3. Review orchestrator system prompt for JSON-only output requirement

### Todos Not Created

**Check 1:** Verify hook output contains systemMessage
```bash
grep "systemMessage" ~/.claude/logs/orchestrator.log
```

**Check 2:** Check todo file exists
```bash
ls -l /tmp/orchestrator-todos-*.json
```

**Check 3:** Validate todo JSON structure
```bash
jq . /tmp/orchestrator-todos-*.json
```

### Skills Not Discovered

**Check 1:** Verify skills directory exists
```bash
ls -1 ~/.claude/skills/
```

**Check 2:** Verify orchestrator has Bash tool
```bash
grep "^tools:" ~/.claude/agents/orchestrator.md
# Should include Bash
```

**Check 3:** Test skill discovery manually
```bash
for skill in ~/.claude/skills/*/SKILL.md; do
  echo "=== $(basename $(dirname $skill)) ==="
  grep "^description:" "$skill"
done
```

## Future Enhancements

### Phase 2: Hybrid Invocation
- Add auto-detection of complex requests
- Trigger orchestrator automatically when needed
- Update description field with auto-invoke patterns

### Phase 3: Custom MCP Tool
- Create `list_skills` MCP tool with parsed frontmatter
- Replace Bash skill discovery with structured API
- Add skill metadata (tags, version, dependencies)

### Phase 4: Learning System
- Track orchestrator decisions over time
- Learn from successful orchestrations
- Suggest skills based on historical patterns

### Phase 5: Confidence Scoring
- Orchestrator assigns confidence to assumptions
- Low confidence triggers user clarification
- High confidence proceeds autonomously

## Testing

### Test 1: Simple Feature Request
```
/orchestrate create a button component
```

**Expected:**
- Clarified: "Create reusable button Vue component"
- Skills: vue-component-builder
- Exploration: existing button components
- Todos: explore buttons → create component

### Test 2: Complex Multi-Step Request
```
/orchestrate add user authentication with OAuth
```

**Expected:**
- Clarified: "Implement OAuth authentication flow with Appwrite"
- Skills: appwrite-integration, astro-routing, vue-component-builder
- Exploration: existing auth code, API routes, components
- Todos: explore auth → create routes → add UI → integrate

### Test 3: Vague Request
```
/orchestrate make it better
```

**Expected:**
- Clarified: [Reasonable interpretation based on project context]
- Low confidence acknowledgment
- Suggested user clarification if too vague

## Files Created

```
~/.claude/agents/orchestrator.md           # Orchestrator subagent
~/.claude/hooks/process-orchestrator.sh    # Hook script
~/.claude/commands/orchestrate.md          # Slash command
~/.claude/settings.json                    # Updated with SubagentStop hook
~/.claude/logs/orchestrator.log            # Hook execution log
~/.claude/docs/orchestrator-system.md      # This documentation
```

## Quick Reference

| Action | Command |
|--------|---------|
| **Invoke orchestrator** | `/orchestrate <request>` |
| **View hook logs** | `tail -f ~/.claude/logs/orchestrator.log` |
| **View orchestrator output** | `cat /tmp/orchestrator-output-*.json` |
| **View generated todos** | `cat /tmp/orchestrator-todos-*.json` |
| **Test hook script** | `echo '{}' \| ~/.claude/hooks/process-orchestrator.sh` |
| **Disable hook** | Remove from settings.json → SubagentStop |
| **List available skills** | `ls -1 ~/.claude/skills/` |

---

**Status:** ✅ Fully Implemented
**Version:** 1.0.0
**Last Updated:** 2025-10-21

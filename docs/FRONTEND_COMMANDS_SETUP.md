# Frontend Commands Auto-Setup

## Overview

Your frontend commands (`/frontend-add`, `/frontend-fix`, `/frontend-new`, `/frontend-improve`) are now fully configured with:

1. **Automatic agent spawning** - `@agent-name` patterns trigger Task tool
2. **Auto-generated todo lists** - Tracks multi-phase execution
3. **Behavioral hooks** - Guide Claude through complex workflows

## What's Configured

### 1. Agent Auto-Spawn (Global CLAUDE.md)

When Claude sees `@code-scout` or similar patterns in the command files, it automatically:
- Detects the pattern
- Maps it to the correct agent type (e.g., `@code-scout` → `Explore` agent)
- Spawns agents using the Task tool
- Groups parallel agents in single calls
- Waits for results before proceeding

**Pattern Recognition Examples:**
```markdown
**Spawn @code-scout with mission:**
[mission description]

**Spawn @documentation-researcher with mission:**
[mission description]
```

This triggers both agents in parallel.

### 2. Todo List Integration

Each command file (frontend-add.md, frontend-fix.md, frontend-new.md, frontend-improve.md) includes a JSON todo list in Phase 0:

```json
{
  "todos": [
    {
      "content": "Run Phase 1: Pre-Analysis (spawn agents)",
      "status": "pending",
      "activeForm": "Running Phase 1 pre-analysis"
    },
    {
      "content": "Consolidate pre-analysis findings",
      "status": "pending",
      "activeForm": "Consolidating pre-analysis findings"
    },
    ...
  ]
}
```

**How Claude Uses This:**
1. Extract the JSON from the command file
2. Call TodoWrite at the start of Phase 0
3. Mark tasks as `in_progress` when starting them
4. Mark tasks as `completed` when finished
5. Provides clear visibility into execution progress

### 3. Behavioral Hooks

Located in `~/.claude/hooks/`:

- **frontend-command-auto-spawn.md** - Detailed behavioral guide
- **command-processor.js** - Optional JS pre-processor
- **README.md** - Hook overview

These guide Claude's execution without needing script files.

## How It Works (End-to-End)

### Example: `/frontend-add onboarding-navbar-name "add users name to top"`

1. **Phase 0 - Initialization**
   - Claude extracts the todo list from the command file
   - Calls TodoWrite to create todos (all pending)
   - Marks first todo as `in_progress`

2. **Phase 1 - Pre-Analysis**
   - Claude detects `@code-scout` and `@documentation-researcher`
   - Spawns both agents in parallel via Task tool
   - Waits for results
   - Consolidates findings
   - Marks first todo as `completed`, moves to second

3. **Phase 2 - Planning**
   - Claude detects `@plan-master`
   - Spawns plan agent
   - Waits for MASTER_PLAN.md
   - Updates todo for planning task
   - Presents plan to user for approval

4. **Phase 3 - Implementation**
   - Upon user approval, spawns specialist agents
   - Collects implementation reports
   - Marks implementation todo as `completed`

5. **Phase 4 - Completion**
   - Runs validation
   - Creates completion report
   - Marks completion todo as `completed`
   - Presents final results

## Key Files Modified

### Command Files (Updated)
- `/Users/natedamstra/.claude/commands/frontend-add.md`
- `/Users/natedamstra/.claude/commands/frontend-fix.md`
- `/Users/natedamstra/.claude/commands/frontend-new.md`
- `/Users/natedamstra/.claude/commands/frontend-improve.md`

**Changes Made:**
- Removed bash execution attempts (`!` prefix)
- Updated to use `pnpm` instead of `npm`
- Removed invalid commands (pnpm test)
- Added todo list JSON in Phase 0
- Simplified initialization sections

### Global Configuration (Updated)
- `/Users/natedamstra/.claude/CLAUDE.md`

**Added:**
- Frontend Command Agent Spawning section
- Auto-spawn pattern documentation
- Agent type mappings
- Todo list initialization instructions

### Hooks (New)
- `/Users/natedamstra/.claude/hooks/frontend-command-auto-spawn.md`
- `/Users/natedamstra/.claude/hooks/command-processor.js`
- `/Users/natedamstra/.claude/hooks/README.md`

## Usage

Just run your command as normal:

```bash
/frontend-add onboarding-navbar-name "add users name to top"
```

Claude will automatically:
1. Initialize todos
2. Spawn agents when needed
3. Update todo status
4. Guide you through each phase

No manual agent spawning needed!

## Testing

To verify it's working:

1. Run `/frontend-add my-test-feature "test description"`
2. You should see:
   - Todo list initialization
   - Auto-spawning of @code-scout and @documentation-researcher
   - Phase progression
   - Status updates

## Benefits

✅ **Automatic agent orchestration** - No manual spawning
✅ **Progress tracking** - Todo list shows what's happening
✅ **Phase structure** - Clear workflow stages
✅ **No bash scripts** - Uses proper tool execution
✅ **Async-friendly** - Agents run in parallel when possible
✅ **User approval gates** - Still pauses for your decisions

## Next Steps

Everything is ready to use! Try running a frontend command and watch it automatically handle agent spawning and progress tracking.

If you want to add more commands or modify the todo structure, follow the same pattern:
1. Add `@agent-name` patterns where agents should spawn
2. Include a JSON todo list in Phase 0
3. Claude will detect and execute automatically

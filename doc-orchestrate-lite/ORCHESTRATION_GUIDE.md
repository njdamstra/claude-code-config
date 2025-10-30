# Orchestration Systems Comparison

## Overview

You have two orchestration systems available:

1. **`/orchestrate`** - Full orchestration with dedicated Orchestrator subagent
2. **`/orchestrate-lite`** - Lightweight orchestration with main agent only

---

## `/orchestrate` (Subagent-Based)

### Architecture
```
User → Main Agent → Orchestrator Subagent → Main Agent
                    (JSON planner)          (executes todos)
```

### How It Works
1. Main agent invokes `Orchestrator` subagent
2. Orchestrator analyzes request, scans skills, outputs JSON
3. Main agent parses JSON and calls `TodoWrite`
4. Main agent executes the todos

### Pros
✅ **Isolated planning context** - Orchestrator has dedicated context for analysis  
✅ **Structured output** - Guaranteed JSON format for parsing  
✅ **Reusable** - Orchestrator can be invoked standalone  
✅ **Logged planning** - SubagentStop hook can save plans to files  

### Cons
❌ **Extra token usage** - Subagent has its own context window  
❌ **Two-step process** - Main agent must parse JSON and create todos  
❌ **More complex** - Two separate agent definitions to maintain  

### When to Use
- Complex, multi-step tasks requiring careful planning
- When you want logged/auditable orchestration decisions
- When orchestrator context isolation is valuable
- Tasks where JSON structure is helpful for debugging

### Example
```
User: /orchestrate build a complete user authentication system

→ Orchestrator subagent analyzes deeply
→ Outputs detailed JSON with 10+ todos
→ Main agent creates todos and executes
```

---

## `/orchestrate-lite` (Command-Based)

### Architecture
```
User → Main Agent (does everything)
       ↓
       1. Scans skills
       2. Analyzes task
       3. Creates todos
       4. Executes todos
```

### How It Works
1. Command injects instructions into main agent
2. Main agent scans skills using Bash
3. Main agent creates TodoWrite directly
4. Main agent executes todos

### Pros
✅ **Simple** - No subagents, just main agent  
✅ **Fast** - No context switching to subagent  
✅ **Direct** - Main agent creates todos immediately  
✅ **Lightweight** - One command file to maintain  

### Cons
❌ **Uses main context** - Analysis happens in main conversation  
❌ **Less structured** - No guaranteed JSON format  
❌ **No isolation** - Planning shares context with execution  

### When to Use
- Quick, straightforward tasks
- When you want minimal overhead
- When main agent context is sufficient
- Exploratory or iterative work

### Example
```
User: /orchestrate-lite create a modal component

→ Main agent scans skills
→ Main agent creates 5-phase todo list
→ Main agent executes immediately
```

---

## Workflow Comparison

### `/orchestrate` Workflow

```
┌─────────────────────────────────────────┐
│ /orchestrate create auth system         │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Main Agent: Invoke Orchestrator         │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Orchestrator Subagent:                  │
│ • Scan ~/.claude/skills/                │
│ • Analyze "create auth system"          │
│ • Select relevant skills                │
│ • Output JSON with todos                │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ SubagentStop Hook (optional):           │
│ • Save JSON to /tmp/orchestrator-*.json │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Main Agent:                              │
│ • Parse orchestrator's JSON              │
│ • Call TodoWrite with todos              │
│ • Execute todos sequentially             │
└─────────────────────────────────────────┘
```

### `/orchestrate-lite` Workflow

```
┌─────────────────────────────────────────┐
│ /orchestrate-lite create modal          │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Main Agent:                              │
│ • Scan ~/.claude/skills/ (Bash)         │
│ • Analyze "create modal"                 │
│ • Call TodoWrite with 5-phase plan       │
│ • Execute todos sequentially             │
└─────────────────────────────────────────┘
```

---

## Feature Comparison

| Feature | `/orchestrate` | `/orchestrate-lite` |
|---------|----------------|---------------------|
| **Subagents** | Yes (Orchestrator) | No |
| **Token Overhead** | Higher | Lower |
| **Setup Complexity** | 2 files + hook | 1 file |
| **Planning Isolation** | Separate context | Main context |
| **JSON Output** | Guaranteed | No |
| **Logging** | Via hook | No |
| **Speed** | Slower (2 agents) | Faster (1 agent) |
| **Use Main Context** | No | Yes |
| **Good for Simple Tasks** | Overkill | ✓ Ideal |
| **Good for Complex Tasks** | ✓ Ideal | Works but less structured |

---

## Decision Tree

```
                    Need orchestration?
                           │
                    ┌──────┴──────┐
                    │             │
                  YES            NO
                    │             │
              Is task complex?    Use normal prompts
              (10+ steps)         │
                    │             └─→ Just describe what you want
                    │
            ┌───────┴───────┐
            │               │
           YES             NO
            │               │
    /orchestrate      /orchestrate-lite
            │               │
    Full planning      Quick planning
    JSON output        Direct todos
    Logged            Lightweight
```

---

## Common Use Cases

### Use `/orchestrate` for:

- 🏗️ **Large features** (authentication system, dashboard, complex forms)
- 📋 **Multi-phase projects** (requires careful planning and sequencing)
- 🔍 **Auditable work** (want logged JSON plans for review)
- 🎯 **High-stakes tasks** (production code, architecture changes)

### Use `/orchestrate-lite` for:

- ⚡ **Quick features** (single component, utility function, page)
- 🔄 **Iterative work** (exploring, prototyping, experimenting)
- 🛠️ **Maintenance tasks** (bug fixes, refactoring, updates)
- 📦 **Small additions** (add a button, create a helper, fix a style)

---

## Example Scenarios

### Scenario 1: "Build User Authentication"

**Recommended: `/orchestrate`**

Why? Complex, multi-phase task requiring:
- API integration (Appwrite)
- Multiple components (login, signup, forgot password)
- State management (auth store)
- Protected routes
- Error handling

Orchestrator can plan all phases with proper sequencing.

---

### Scenario 2: "Create a Button Component"

**Recommended: `/orchestrate-lite`**

Why? Simple, single-component task:
- One component file
- Maybe explore existing buttons
- Use vue-component-builder skill if available
- Fast, straightforward

No need for complex planning overhead.

---

### Scenario 3: "Fix Bug in Login Form"

**Recommended: `/orchestrate-lite`**

Why? Focused, specific task:
- Explore login form code
- Identify issue
- Apply fix
- Quick turnaround needed

Main agent can handle without subagent overhead.

---

### Scenario 4: "Build Admin Dashboard with Charts"

**Recommended: `/orchestrate`**

Why? Multi-component system:
- Page structure
- Multiple chart components
- Data fetching
- State management
- Responsive layout

Benefits from structured orchestrator planning.

---

## Tips for Success

### For `/orchestrate`:

1. **Use for ambiguity** - Let orchestrator clarify vague requests
2. **Check the JSON** - Review the plan before main agent executes
3. **Hook logging** - Save plans to /tmp/ for debugging
4. **Iterate on orchestrator** - Improve prompts based on output quality

### For `/orchestrate-lite`:

1. **Keep tasks focused** - Works best for single-feature requests
2. **Trust the main agent** - It will scan skills and plan appropriately
3. **Watch the todos** - Main agent creates 5-phase list automatically
4. **Use for speed** - When you need quick results

---

## File Locations

### `/orchestrate` (Subagent System)
```
~/.claude/commands/orchestrate.md          # Slash command
~/.claude/agents/orchestrator.md           # Orchestrator subagent
~/.claude/hooks/process-orchestrator.sh    # Optional logging hook
```

### `/orchestrate-lite` (Command System)
```
~/.claude/commands/orchestrate-lite.md     # Slash command (only file needed)
```

---

## Testing Your Setup

### Test `/orchestrate`:
```bash
# In Claude Code
/orchestrate create a settings page

# Verify:
# 1. Orchestrator subagent runs
# 2. JSON output appears
# 3. Main agent calls TodoWrite
# 4. Todos appear in conversation
```

### Test `/orchestrate-lite`:
```bash
# First test skill discovery
./test-skill-discovery.sh

# Then in Claude Code
/orchestrate-lite create a button component

# Verify:
# 1. Main agent scans skills
# 2. TodoWrite creates 5-phase list
# 3. Todos appear immediately
# 4. Main agent executes
```

---

## Migration Guide

### From Manual Prompting → `/orchestrate-lite`

**Before:**
```
Create a modal component. First explore for existing modals,
then check skills, then build it.
```

**After:**
```
/orchestrate-lite create a modal component
```

Benefits: Automatic skill discovery, structured workflow, parallel exploration.

---

### From `/orchestrate-lite` → `/orchestrate`

**When to migrate:**
- Task grew more complex than expected
- Need structured JSON output
- Want logged/auditable planning
- Orchestrator's isolated context would help

**How:**
Just switch commands:
```bash
/orchestrate build complete user profile system
```

---

## Summary

| When... | Use... |
|---------|--------|
| Task is **simple** | `/orchestrate-lite` |
| Task is **complex** | `/orchestrate` |
| Need **speed** | `/orchestrate-lite` |
| Need **structure** | `/orchestrate` |
| **Iterating** quickly | `/orchestrate-lite` |
| **Planning** carefully | `/orchestrate` |
| **Exploring** ideas | `/orchestrate-lite` |
| **Implementing** systems | `/orchestrate` |

Both systems follow the same core workflow:
1. Explore
2. Select skills
3. Implement
4. Verify

Choose based on task complexity and your needs!

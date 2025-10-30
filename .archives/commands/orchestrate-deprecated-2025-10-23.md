---
name: orchestrate
description: Invoke orchestrator to clarify request, discover skills, plan exploration, and create todos
arguments: <user_request>
---

# Orchestrate Command

## ⚠️ CRITICAL WORKFLOW - FOLLOW EXACTLY ⚠️

### Step 1: Invoke Orchestrator Subagent

Invoke the orchestrator with the user's request:

```
Task(
  subagent_type="Orchestrator",
  description="Orchestrate: $ARGUMENTS",
  prompt="$ARGUMENTS"
)
```

**User Request:** $ARGUMENTS

### Step 2: Wait for Orchestrator to Complete

The orchestrator will return a JSON structure containing:
- `clarified_request` - Interpreted user intent
- `selected_skills` - Array of relevant skills with reasons
- `todos` - Object with `exploration` and `implementation` arrays

### Step 3: Parse Orchestrator's JSON Output

**CRITICAL:** The orchestrator outputs JSON with todo structure. You MUST extract this from the Task result.

Look for JSON in the orchestrator's response with this structure:

```json
{
  "clarified_request": "...",
  "selected_skills": [...],
  "todos": {
    "exploration": [
      {"content": "...", "activeForm": "...", "status": "pending"}
    ],
    "implementation": [
      {"content": "...", "activeForm": "...", "status": "pending"}
    ]
  }
}
```

### Step 4: Create Todos Using TodoWrite

**YOU MUST manually call TodoWrite** with the todos from orchestrator's output.

**IMPORTANT TODO MERGING:**
- If there are existing todos, preserve them
- Append orchestrator's todos to the existing list
- Set the FIRST NEW todo to "in_progress"
- Keep existing todos' statuses unchanged

**Example TodoWrite call:**

```javascript
TodoWrite({
  todos: [
    // ... existing todos (if any)
    ...orchestrator_exploration_todos.map((t, i) => ({
      ...t,
      status: i === 0 ? "in_progress" : "pending"
    })),
    ...orchestrator_implementation_todos
  ]
})
```

### Step 5: Execute Todos Sequentially

After creating todos:
1. Execute exploration todos first (invoke Explore agents)
2. Review findings from exploration
3. Execute implementation todos (invoke selected skills)

## What the Orchestrator Does

The orchestrator subagent will autonomously:
1. **Clarify the request** - Interpret vague requests using codebase context
2. **Discover relevant skills** - Scan ~/.claude/skills/ and select 2-5 most relevant
3. **Plan exploration** - Identify codebase areas to explore via Explore agents
4. **Output JSON structure** - Provide structured plan with todos

**The orchestrator does NOT call TodoWrite itself.** You (the main agent) must parse its JSON and create todos.

## Example Workflow

**User:** `/orchestrate create a user profile page`

**Step 1:** You invoke orchestrator subagent

**Step 2:** Orchestrator returns JSON:
```json
{
  "clarified_request": "Create user profile page with Astro SSR and Vue components",
  "selected_skills": [
    {"name": "astro-routing", "reason": "Create SSR page"},
    {"name": "vue-component-builder", "reason": "Build profile component"}
  ],
  "todos": {
    "exploration": [
      {"content": "Explore src/pages for profile pages", "activeForm": "Exploring pages", "status": "pending"}
    ],
    "implementation": [
      {"content": "Create profile page using astro-routing", "activeForm": "Creating page", "status": "pending"}
    ]
  }
}
```

**Step 3:** You parse the JSON from orchestrator's output

**Step 4:** You call TodoWrite with combined exploration + implementation todos

**Step 5:** You execute todos sequentially

---

**Remember:**
- The orchestrator outputs JSON for planning
- YOU (main agent) parse the JSON and call TodoWrite
- This prevents todo-merging issues and gives you control
- The orchestrator makes autonomous decisions (no user questions needed)

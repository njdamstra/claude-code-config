---
description: Lightweight orchestration - automatically discover skills, plan exploration, create todos, and execute (no subagents needed). Use when building features, exploring codebases, or implementing tasks. Accepts task description as argument.
argument-hint: <task_description>
allowed-tools: [Bash, Read, Grep, Glob, TodoWrite, Task, Skill]
---

# Orchestrate Lite Command

## 🎯 Your Mission

Execute the task: **$ARGUMENTS**

Follow the exact workflow below. This is a **fully automated orchestration** - you will discover skills, plan exploration, create todos, and execute everything yourself.

---

## 📋 Orchestration Workflow (Follow Exactly)

### STEP 1: Discover Available Skills

**First, scan for available skills using the skill-list script:**

```bash
~/.claude/scripts/skill-list.sh
```

**Parse the output** and keep a mental list of available skills.

---

### STEP 2: Analyze the Task

Based on the task **"$ARGUMENTS"**, determine:

1. **What needs to be explored?**
   - Which directories/files are relevant?
   - What patterns should we look for?
   - What existing code might be related?

2. **Which skills are relevant?**
   - Match the task to skill descriptions
   - Select 1-3 most relevant skills
   - If no skills match, note that you'll implement manually

3. **What's the implementation approach?**
   - What needs to be built/fixed/modified?
   - What's the logical order of operations?

---

### STEP 3: Create Todo List (Use TodoWrite)

**NOW call TodoWrite** to create a structured todo list with these phases:

```javascript
TodoWrite({
  todos: [
    // PHASE 1: EXPLORATION PLANNING
    {
      id: "1",
      content: "Decide exploration areas for [task] - identify relevant directories and patterns",
      status: "in_progress",  // Start with first todo active
      priority: "high"
    },
    
    // PHASE 2: PARALLEL EXPLORATION
    {
      id: "2", 
      content: "Launch Explore subagents in parallel for [list specific areas]",
      status: "pending",
      priority: "high"
    },
    
    // PHASE 3: SKILL SELECTION
    {
      id: "3",
      content: "Review exploration findings and select relevant skill(s) from: [list candidate skills]",
      status: "pending",
      priority: "high"
    },
    
    // PHASE 4: SKILL INVOCATION
    {
      id: "4",
      content: "Invoke selected skill(s): [skill-name] for [specific purpose]",
      status: "pending",
      priority: "high"
    },
    
    // PHASE 5: EXECUTION & VERIFICATION
    {
      id: "5",
      content: "Execute implementation and verify it works (tests, manual check, etc.)",
      status: "pending",
      priority: "medium"
    }
  ]
})
```

**Customize the todo content** based on your analysis:
- Replace `[task]` with the actual task
- Replace `[list specific areas]` with actual directories/patterns
- Replace `[list candidate skills]` with actual skill names
- Replace `[skill-name]` with the selected skill(s)

---

### STEP 4: Execute the Todos

Now execute each todo sequentially:

#### **Todo 1: Exploration Planning**

Based on the task, decide:
- **Directories to explore:** (e.g., `src/components`, `src/stores`, `src/pages`)
- **Patterns to search:** (e.g., `*Modal*`, `*Auth*`, `*Profile*`)
- **Why these areas:** Brief reasoning

Mark this todo as completed.

#### **Todo 2: Parallel Exploration**

Launch Explore subagents in **parallel** using Task tool:

```javascript
// Example: Launch 3 explorations in parallel
Task(subagent_type="Explore", prompt="Explore src/components for existing Modal components")
Task(subagent_type="Explore", prompt="Explore src/stores for state management patterns")
Task(subagent_type="Explore", prompt="Explore src/pages for page structure examples")
```

**Wait for all explorations to complete**, then review findings.

Mark this todo as completed.

#### **Todo 3: Skill Selection**

Review the exploration findings and available skills. Decide:

- **Selected skill(s):** Which skill(s) match the task?
- **Why selected:** Match between skill capability and task needs
- **If no skills match:** Note that you'll implement manually

Mark this todo as completed.

#### **Todo 4: Skill Invocation**

If relevant skills were selected, invoke them:

```javascript
// Example: Invoke a skill
Task(subagent_type="vue-component-builder", prompt="Create Modal.vue component with...")
```

If no skills match, implement manually using your standard tools (Write, Edit, etc.).

Mark this todo as completed.

#### **Todo 5: Execution & Verification**

Verify the implementation:
- Run tests if applicable
- Check for type errors
- Manual verification
- Ensure the task is fully completed

Mark this todo as completed.

---

## 🎓 Guidelines for Success

### Exploration Planning
- **Be specific:** Don't just say "explore components" - say "explore src/components for existing Modal/Dialog patterns"
- **Use glob patterns:** Help Explore agents find exactly what they need
- **Cover dependencies:** If building a form, explore both components and validation utilities

### Parallel Exploration
- **Launch all explorations at once:** Don't wait for one to finish before starting the next
- **Keep them focused:** Each Explore agent should have a specific, narrow scope
- **Typical areas:**
  - Components: `src/components`, `src/ui`
  - State: `src/stores`, `src/state`
  - Utilities: `src/utils`, `src/lib`
  - Pages: `src/pages`, `pages`
  - API: `src/api`, `src/services`

### Skill Selection
- **Match descriptions:** Compare task requirements to skill descriptions
- **Prefer skills over manual:** If a skill can do 80% of the work, use it
- **Combine skills:** Some tasks need multiple skills (e.g., page + component + store)
- **No skills? No problem:** Implement manually if no relevant skills exist

### Skill Invocation
- **Clear instructions:** Give skills specific, actionable prompts
- **Include context:** Share relevant findings from exploration
- **One skill per Task:** Don't try to invoke multiple skills in one Task call

---

## ⚡ Quick Reference

**Task received:** $ARGUMENTS

**Your workflow:**
1. ✅ Scan skills (Bash)
2. ✅ Analyze task (mental planning)
3. ✅ Create todos (TodoWrite with 5 phases)
4. ✅ Execute todos sequentially
   - Plan exploration areas
   - Launch parallel Explore agents
   - Review findings and select skills
   - Invoke skills or implement manually
   - Verify implementation

**Remember:**
- Exploration is **parallel** (launch all at once)
- Skill invocation uses **Task tool** with skill name as subagent_type
- If no relevant skills, implement manually
- Always verify your work at the end

---

## 📊 Example Execution

**User:** `/orchestrate-lite create a user profile page`

**Your workflow:**

1. **Scan skills** → Find: astro-routing, vue-component-builder, nanostore-builder
2. **Analyze** → Need: Astro page + Vue components + state management
3. **TodoWrite** → Create 5-phase todo list
4. **Execute:**
   - 📍 Plan: Explore pages, components, stores
   - 🔄 Parallel Explore: Launch 3 agents (pages, components, stores)
   - ✅ Review findings → Select: astro-routing, vue-component-builder, nanostore-builder
   - 🛠️ Invoke skills sequentially
   - ✓ Verify: Check page renders, components work, state persists

---

**Now begin! Follow the workflow above for the task: $ARGUMENTS**

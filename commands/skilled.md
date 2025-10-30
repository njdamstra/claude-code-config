---
description: Use relevant skills to complete a task. Agent discovers available skills, selects the best match(es), and invokes them to accomplish the goal.
argument-hint: <task-description>
allowed-tools: [Bash, Read, Grep, Glob, Skill, Edit, Write, TodoWrite]
---

# Skilled Command - Skill-Powered Task Execution

## 🎯 Your Mission

Complete the task: **$ARGUMENTS**

Use the workflow below to discover available skills, select the most relevant ones, and invoke them to accomplish the task efficiently.

---

## 📋 Execution Workflow

### STEP 1: Discover Available Skills

Run the skill discovery script:

```bash
~/.claude/scripts/skill-list.sh
```

**Parse the output** and identify all available skills with their descriptions.

---

### STEP 2: Analyze Task & Select Skills

Based on the task **"$ARGUMENTS"**, determine:

1. **What is the task asking for?**
   - What type of work? (component creation, state management, API integration, debugging, etc.)
   - What technologies are involved? (Vue, Astro, Appwrite, TypeScript, etc.)
   - What's the scope? (single file, multiple components, architecture design, etc.)

2. **Which skills are relevant?**
   - Match task keywords to skill descriptions
   - Look for exact domain matches (e.g., "Appwrite" → `soc-appwrite-integration`)
   - Look for task type matches (e.g., "component" → `vue-component-builder`)
   - Consider combining skills for complex tasks

3. **Skill selection strategy:**
   - **1 skill:** Simple, focused task with clear domain match
   - **2-3 skills:** Complex task requiring multiple domains (e.g., page + component + store)
   - **No skills:** Task doesn't match any skill descriptions → implement manually

---

### STEP 3: Invoke Selected Skills

**If 1 skill selected:**
- Invoke the skill using the `Skill` tool with the skill name
- Provide the full task context in your invocation
- Let the skill guide implementation

**If 2-3 skills selected:**
- Invoke skills sequentially (most foundational first)
- Example order: store → component → page
- Each skill invocation should build on previous work

**If no skills match:**
- Proceed with manual implementation
- Use standard tools (Read, Write, Edit, etc.)
- Explain why no skills were selected

---

### STEP 4: Execute & Complete

After skill invocation (or manual implementation):
- Follow the skill's guidance to complete the task
- Verify the implementation works
- Report completion to user

---

## 🎓 Skill Selection Guidelines

### Match Keywords to Skills

**Claude Code Meta-Skills (cc-*):**
- "create slash command" → `cc-slash-command-builder`
- "create subagent" → `cc-subagent-architect`
- "create hook" → `cc-hook-designer`
- "integrate MCP" → `cc-mcp-integration`
- "output style" → `cc-output-style-creator`
- "how do I", "best practice" → `cc-mastery`

**Vue/Astro Development:**
- "component", ".vue", "modal", "form" → `vue-component-builder`
- "composable", "use*" → `vue-composable-builder`
- "Astro page", "API route", ".json.ts" → `astro-routing`
- "architecture", "SSR strategy" → `astro-vue-architect`
- "VueUse", "animation", "motion" → `vueuse-expert`

**State Management:**
- "store", "state", "BaseStore" → `nanostore-builder`
- "Appwrite collection" → `nanostore-builder` + `soc-appwrite-integration`

**Appwrite Integration:**
- "Appwrite", "database", "auth", "permission" → `soc-appwrite-integration`
- "OAuth", "session", "query" → `soc-appwrite-integration`

**Code Quality:**
- "TypeScript error", "type error" → `typescript-fixer`
- "Zod schema", "validation" → `zod-schema-architect`
- "find existing", "search codebase" → `code-scout` (agent) or `Explore` (subagent)

### Combination Patterns

**Full-stack feature:**
- `astro-routing` + `vue-component-builder` + `nanostore-builder`

**Appwrite-backed store:**
- `soc-appwrite-integration` + `nanostore-builder`

**Component with validation:**
- `vue-component-builder` + `zod-schema-architect`

**Claude Code setup:**
- `cc-mastery` (for planning) + specific `cc-*` skill for implementation

---

## 💡 Examples

### Example 1: Simple Single-Skill Task
```
User: /skilled Integrate appwrite into this store

Agent workflow:
1. Run skill-list.sh → discover skills
2. Analyze: Task is about Appwrite integration in a store
3. Select: soc-appwrite-integration (exact match)
4. Invoke: Skill("soc-appwrite-integration")
5. Follow skill guidance to integrate Appwrite
```

### Example 2: Multi-Skill Task
```
User: /skilled Create a user profile page with form validation

Agent workflow:
1. Run skill-list.sh → discover skills
2. Analyze: Need Astro page + Vue component + Zod validation
3. Select: astro-routing, vue-component-builder, zod-schema-architect
4. Invoke sequentially:
   - Skill("zod-schema-architect") → create validation schemas
   - Skill("vue-component-builder") → create form component
   - Skill("astro-routing") → create page with SSR
5. Verify page works with validation
```

### Example 3: No Skill Match
```
User: /skilled Add console.log debugging to this function

Agent workflow:
1. Run skill-list.sh → discover skills
2. Analyze: Simple debugging task, no skill matches
3. Select: None (manual implementation)
4. Read function, add console.log statements
5. Report completion
```

### Example 4: Claude Code Task
```
User: /skilled Create a hook to run prettier on save

Agent workflow:
1. Run skill-list.sh → discover skills
2. Analyze: Hook creation for automation
3. Select: cc-hook-designer (exact match)
4. Invoke: Skill("cc-hook-designer")
5. Follow skill guidance to create PostToolUse hook
```

---

## ⚡ Quick Reference

**Your workflow:**
1. ✅ Run `~/.claude/scripts/skill-list.sh`
2. ✅ Analyze task → match to skill descriptions
3. ✅ Select 0-3 most relevant skills
4. ✅ Invoke skills or implement manually
5. ✅ Complete task and verify

**Remember:**
- Skills are domain experts → delegate when possible
- Match keywords in task to skill descriptions
- Combine skills for complex tasks
- Manual implementation is fine if no skills match
- Always verify the final result

---

**Now begin! Complete the task: $ARGUMENTS**

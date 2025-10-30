# Orchestration Systems Setup Guide

## Quick Start

You now have **two orchestration systems**:

1. **`/orchestrate`** - Full subagent-based orchestration
2. **`/orchestrate-lite`** - Lightweight command-based orchestration ⭐ **Start here!**

---

## Installation

### Step 1: Create Required Directories

```bash
# Create command directory
mkdir -p ~/.claude/commands

# Create agents directory (for /orchestrate)
mkdir -p ~/.claude/agents

# Create hooks directory (optional, for /orchestrate logging)
mkdir -p ~/.claude/hooks
```

### Step 2: Install `/orchestrate-lite` (Recommended First)

This is the simpler system - start here to test the concept:

```bash
# Copy the slash command
cp orchestrate-lite.md ~/.claude/commands/

# Make test script executable
chmod +x test-skill-discovery.sh
```

### Step 3: Test Skill Discovery

Before using orchestrate-lite, verify it can find your skills:

```bash
./test-skill-discovery.sh
```

Expected output:
```
🧪 Testing Orchestrate-Lite Skill Discovery
==========================================

📁 Scanning: /Users/you/.claude/skills (USER)

  ✅ vue-component-builder
     → Creates Vue 3 components with TypeScript, composition API, and best practices

  ✅ astro-routing
     → Generates Astro pages with SSR support
  
  📊 Found 2 skill(s)

==========================================

📁 Scanning: ./.claude/skills (PROJECT)

  ℹ️  No skills found in this location

==========================================

✅ Skill discovery test complete!
```

If you see your skills listed, you're good to go! 🎉

### Step 4: Test `/orchestrate-lite`

Open Claude Code and try:

```bash
/orchestrate-lite create a button component
```

**What should happen:**

1. ✅ Main agent scans skills using Bash
2. ✅ You see a list of available skills
3. ✅ Main agent calls TodoWrite with 5 phases
4. ✅ Todos appear in the conversation:
   ```
   ☐ Decide exploration areas...
   ☐ Launch Explore subagents in parallel...
   ☐ Review findings and select skills...
   ☐ Invoke selected skill(s)...
   ☐ Execute and verify...
   ```
5. ✅ Main agent executes each todo sequentially

If this works, **you're done!** Use `/orchestrate-lite` for most tasks.

---

## (Optional) Install `/orchestrate` Full System

Only install this if you want the more complex subagent-based system for large tasks.

### Step 1: Install Agent and Command

```bash
# Copy orchestrator subagent
cp orchestrator.md ~/.claude/agents/

# Copy orchestrate slash command
cp orchestrate.md ~/.claude/commands/
```

### Step 2: (Optional) Install Logging Hook

This hook saves orchestrator plans to `/tmp/` for debugging:

```bash
# Copy hook script
cp process-orchestrator.sh ~/.claude/hooks/

# Make executable
chmod +x ~/.claude/hooks/process-orchestrator.sh
```

### Step 3: Register Hook (if using)

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SubagentStop": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/hooks/process-orchestrator.sh"
      }]
    }]
  }
}
```

**Note:** If you already have hooks configured, merge this into your existing configuration.

### Step 4: Reload Settings

In Claude Code, apply the settings:

1. Make a change to settings (or hooks)
2. Go to `/hooks` menu
3. Review and apply changes
4. OR restart Claude Code

### Step 5: Test `/orchestrate`

```bash
/orchestrate create a settings page
```

**What should happen:**

1. ✅ Main agent invokes `Orchestrator` subagent
2. ✅ You see: `Task(Orchestrate: create a settings page)`
3. ✅ Orchestrator scans skills
4. ✅ Orchestrator outputs JSON with plan
5. ✅ (Optional) Hook saves JSON to `/tmp/orchestrator-plan-*.json`
6. ✅ Main agent parses JSON
7. ✅ Main agent calls TodoWrite
8. ✅ Todos appear in conversation
9. ✅ Main agent executes todos

---

## Verification Checklist

### For `/orchestrate-lite`:

- [ ] File exists at `~/.claude/commands/orchestrate-lite.md`
- [ ] Test script runs: `./test-skill-discovery.sh`
- [ ] Skills are discovered (at least from `~/.claude/skills/`)
- [ ] Command works in Claude Code: `/orchestrate-lite test`
- [ ] Main agent scans skills
- [ ] TodoWrite creates 5-phase list
- [ ] Main agent executes todos

### For `/orchestrate`:

- [ ] File exists at `~/.claude/agents/orchestrator.md`
- [ ] File exists at `~/.claude/commands/orchestrate.md`
- [ ] (Optional) Hook exists at `~/.claude/hooks/process-orchestrator.sh`
- [ ] (Optional) Hook is registered in `~/.claude/settings.json`
- [ ] Command works in Claude Code: `/orchestrate test`
- [ ] Orchestrator subagent runs
- [ ] JSON output appears
- [ ] Main agent calls TodoWrite
- [ ] Todos appear and execute

---

## Troubleshooting

### Issue: `/orchestrate-lite` doesn't find any skills

**Symptoms:**
- Bash command outputs empty list
- Main agent says "no skills available"

**Solutions:**

1. **Check skill location:**
   ```bash
   ls -la ~/.claude/skills/
   ```
   Should show skill directories.

2. **Check SKILL.md files:**
   ```bash
   ls -la ~/.claude/skills/*/SKILL.md
   ```
   Each skill should have a SKILL.md file.

3. **Check YAML frontmatter:**
   ```bash
   head -20 ~/.claude/skills/vue-component-builder/SKILL.md
   ```
   Should show:
   ```yaml
   ---
   description: Your description here
   ---
   ```

4. **Test extraction manually:**
   ```bash
   awk '/^---$/,/^---$/ {
     if ($0 ~ /^description:/) {
       sub(/^description: */, "")
       print
       exit
     }
   }' ~/.claude/skills/vue-component-builder/SKILL.md
   ```

---

### Issue: `/orchestrate` - Orchestrator doesn't output JSON

**Symptoms:**
- Orchestrator runs but no JSON at the end
- Main agent can't parse output

**Solutions:**

1. **Check orchestrator agent file:**
   ```bash
   grep "Output Format" ~/.claude/agents/orchestrator.md
   ```
   Should have clear JSON output instructions.

2. **Manually invoke orchestrator:**
   In Claude Code:
   ```
   Use the Orchestrator subagent to plan: create a button component
   ```
   Check if JSON appears.

3. **Review orchestrator's last message:**
   Look for JSON structure at the end. If missing, orchestrator needs clearer instructions.

---

### Issue: Main agent doesn't call TodoWrite

**Symptoms:**
- Orchestrator outputs JSON (for `/orchestrate`)
- Or main agent scans skills (for `/orchestrate-lite`)
- But no todos appear in conversation

**Solutions:**

1. **Check command file:**
   ```bash
   grep "TodoWrite" ~/.claude/commands/orchestrate.md
   ```
   Or:
   ```bash
   grep "TodoWrite" ~/.claude/commands/orchestrate-lite.md
   ```
   Should have clear TodoWrite instructions.

2. **Manually prompt main agent:**
   ```
   Parse the orchestrator's JSON and call TodoWrite with the todos.
   ```

3. **Try explicit instruction:**
   Edit command file to add:
   ```markdown
   **CRITICAL: You MUST call TodoWrite immediately after [step].**
   ```

---

### Issue: Hook doesn't run

**Symptoms:**
- `/orchestrate` works but no file appears in `/tmp/`
- No hook messages visible

**Solutions:**

1. **Check hook is registered:**
   ```bash
   cat ~/.claude/settings.json | jq '.hooks.SubagentStop'
   ```
   Should show your hook configuration.

2. **Check hook is executable:**
   ```bash
   ls -la ~/.claude/hooks/process-orchestrator.sh
   ```
   Should show `rwxr-xr-x` permissions.

3. **Test hook manually:**
   ```bash
   echo '{"transcript_path":"/tmp/test.jsonl","session_id":"test"}' | \
     ~/.claude/hooks/process-orchestrator.sh
   ```
   Check exit code:
   ```bash
   echo $?
   ```
   Should be 0.

4. **Check hook logs:**
   ```bash
   cat ~/.claude/logs/*.log | grep orchestrator
   ```

5. **Reload settings:**
   Go to `/hooks` menu in Claude Code and apply changes.

---

### Issue: Skills from project `./.claude/skills/` not found

**Symptoms:**
- User-level skills work
- Project-level skills don't appear

**Solutions:**

1. **Check directory exists:**
   ```bash
   ls -la ./.claude/skills/
   ```

2. **Check from project root:**
   Ensure you're running Claude Code from the project root where `.claude/` exists.

3. **Use absolute path in test:**
   ```bash
   ls -la $(pwd)/.claude/skills/
   ```

4. **Check SKILL.md format:**
   Same as user-level skills - needs proper YAML frontmatter.

---

## Directory Structure Reference

### Minimal Setup (orchestrate-lite only):

```
~/.claude/
├── commands/
│   └── orchestrate-lite.md
└── skills/
    ├── vue-component-builder/
    │   └── SKILL.md
    ├── astro-routing/
    │   └── SKILL.md
    └── ...
```

### Full Setup (both systems):

```
~/.claude/
├── commands/
│   ├── orchestrate.md
│   └── orchestrate-lite.md
├── agents/
│   └── orchestrator.md
├── hooks/
│   └── process-orchestrator.sh
├── settings.json
└── skills/
    └── .../

./.claude/          # Project-level (optional)
└── skills/
    └── .../
```

---

## Usage Patterns

### Quick Task → `/orchestrate-lite`

```bash
/orchestrate-lite create a loading spinner component
/orchestrate-lite fix the navigation menu bug
/orchestrate-lite add dark mode toggle
```

### Complex Task → `/orchestrate`

```bash
/orchestrate build user authentication system
/orchestrate create admin dashboard with charts
/orchestrate implement payment processing flow
```

### Iterative Development

```bash
# Start with lite for exploration
/orchestrate-lite explore the auth system

# If task grows, switch to full orchestration
/orchestrate refactor entire auth system
```

---

## Next Steps

### 1. Test Both Systems

Start simple:
```bash
/orchestrate-lite create a button
/orchestrate create a settings page
```

### 2. Create Your First Skill

If you don't have skills yet:

```bash
# Create skill directory
mkdir -p ~/.claude/skills/my-first-skill

# Create SKILL.md
cat > ~/.claude/skills/my-first-skill/SKILL.md << 'EOF'
---
description: Example skill for testing orchestration
tags: [example, test]
---

# My First Skill

This is a test skill.
EOF
```

Test discovery:
```bash
./test-skill-discovery.sh
```

### 3. Customize for Your Stack

Edit the orchestrator/command files to reference your specific:
- Tech stack (Vue 3, Astro, etc.) ✅ Already configured
- Patterns (component structure, naming conventions)
- Tools (Appwrite, Tailwind, etc.) ✅ Already mentioned

### 4. Build More Skills

Create skills for your common patterns:
- Component builders
- API integrators
- Test generators
- Documentation creators

### 5. Iterate on Prompts

Based on usage, refine:
- `orchestrator.md` - Better clarification logic
- `orchestrate.md` - Clearer instructions
- `orchestrate-lite.md` - Better workflow

---

## Support

### Read the Docs

- `ORCHESTRATION_GUIDE.md` - Feature comparison and use cases
- `orchestrate-lite.md` - Full command documentation
- `orchestrate.md` - Full command documentation
- `orchestrator.md` - Orchestrator agent documentation

### Debug Mode

Run Claude Code with debug output:
```bash
claude --debug
```

### Community

- Share your orchestrator improvements
- Report issues you encounter
- Suggest new features

---

## Success Metrics

You'll know orchestration is working when:

✅ Skills are automatically discovered  
✅ Todos are created automatically  
✅ Exploration happens in parallel  
✅ Skills are invoked correctly  
✅ Less time explaining, more time building  

**Happy orchestrating!** 🎉

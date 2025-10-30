# Orchestration Systems - Complete Package

## 📦 What You Have

You now have a complete orchestration system for Claude Code with two approaches:

### 1. `/orchestrate-lite` ⭐ **RECOMMENDED TO START**
- **Single file**: `orchestrate-lite.md`
- **No subagents**: Main agent does everything
- **Fast setup**: Copy one file and go
- **Perfect for**: Quick tasks, single features, iterative work

### 2. `/orchestrate` (Advanced)
- **Three files**: `orchestrate.md`, `orchestrator.md`, `process-orchestrator.sh`
- **Uses subagents**: Dedicated Orchestrator for planning
- **Structured**: JSON output, logged plans
- **Perfect for**: Complex tasks, multi-phase projects, production work

---

## 🚀 Quick Start (5 Minutes)

### Option A: Start Simple (Recommended)

```bash
# 1. Copy the command file
cp orchestrate-lite.md ~/.claude/commands/

# 2. Test skill discovery
chmod +x test-skill-discovery.sh
./test-skill-discovery.sh

# 3. Try it in Claude Code
claude
> /orchestrate-lite create a button component
```

Done! That's all you need to get started. 🎉

---

### Option B: Full System (Advanced Users)

```bash
# 1. Install all files
cp orchestrate-lite.md ~/.claude/commands/
cp orchestrate.md ~/.claude/commands/
cp orchestrator.md ~/.claude/agents/
cp process-orchestrator.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/process-orchestrator.sh

# 2. Configure hooks (add to ~/.claude/settings.json)
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

# 3. Test both systems
claude
> /orchestrate-lite create a button
> /orchestrate create a dashboard
```

---

## 📚 Documentation Overview

| File | Purpose |
|------|---------|
| **orchestrate-lite.md** | Slash command for lightweight orchestration |
| **orchestrate.md** | Slash command for full orchestration |
| **orchestrator.md** | Subagent definition for planning |
| **process-orchestrator.sh** | Hook to log orchestrator plans |
| **test-skill-discovery.sh** | Test script to verify skill scanning |
| **SETUP_GUIDE.md** | Installation and troubleshooting guide |
| **ORCHESTRATION_GUIDE.md** | Comparison and decision guide |

---

## 🎯 How It Works

### `/orchestrate-lite` Workflow

```
┌────────────────────────────────────────────────┐
│ User: /orchestrate-lite create a modal        │
└────────────────────────────────────────────────┘
                     ↓
┌────────────────────────────────────────────────┐
│ Main Agent:                                    │
│ 1. Scans ~/.claude/skills/ using Bash         │
│    → Finds: vue-component-builder             │
│                                                │
│ 2. Analyzes task: "create a modal"            │
│    → Needs: Modal component with Vue 3        │
│                                                │
│ 3. Calls TodoWrite with 5-phase plan:         │
│    ☐ Decide exploration areas                 │
│    ☐ Launch Explore subagents in parallel     │
│    ☐ Review findings and select skills        │
│    ☐ Invoke vue-component-builder skill       │
│    ☐ Execute and verify                       │
│                                                │
│ 4. Executes todos sequentially                │
└────────────────────────────────────────────────┘
```

**Time:** ~30 seconds  
**Token usage:** Low (single agent)  
**Best for:** Most tasks

---

### `/orchestrate` Workflow

```
┌────────────────────────────────────────────────┐
│ User: /orchestrate build auth system          │
└────────────────────────────────────────────────┘
                     ↓
┌────────────────────────────────────────────────┐
│ Main Agent: Invoke Orchestrator subagent      │
└────────────────────────────────────────────────┘
                     ↓
┌────────────────────────────────────────────────┐
│ Orchestrator Subagent:                         │
│ • Scans ~/.claude/skills/                      │
│ • Clarifies "build auth system"                │
│ • Selects: appwrite-integration, etc.          │
│ • Outputs JSON with detailed plan              │
└────────────────────────────────────────────────┘
                     ↓
┌────────────────────────────────────────────────┐
│ Hook (optional): Saves JSON to /tmp/           │
└────────────────────────────────────────────────┘
                     ↓
┌────────────────────────────────────────────────┐
│ Main Agent:                                    │
│ • Parses orchestrator's JSON                   │
│ • Calls TodoWrite with todos                   │
│ • Executes todos sequentially                  │
└────────────────────────────────────────────────┘
```

**Time:** ~60-90 seconds  
**Token usage:** Higher (two agents)  
**Best for:** Complex, multi-phase tasks

---

## 🔑 Key Features

### Both Systems Share:

✅ **Automatic skill discovery** from `~/.claude/skills/` and `./.claude/skills/`  
✅ **Parallel exploration** using Explore subagents  
✅ **Smart skill selection** based on task analysis  
✅ **Structured workflow** (explore → select → invoke → execute)  
✅ **Automatic todo creation** using TodoWrite  
✅ **Tech stack aware** (Vue 3, Astro, Appwrite, Tailwind, etc.)

### Unique to `/orchestrate-lite`:

⚡ **Fast** - No subagent overhead  
🎯 **Simple** - One file to maintain  
💨 **Lightweight** - Uses main agent context only

### Unique to `/orchestrate`:

🏗️ **Structured** - Guaranteed JSON output  
📝 **Logged** - Plans saved to /tmp/ (via hook)  
🎭 **Isolated** - Planning in separate context  
🔄 **Reusable** - Orchestrator can be invoked standalone

---

## 💡 Common Usage Patterns

### Daily Development with `/orchestrate-lite`

```bash
# Morning: Check what to work on
/orchestrate-lite explore the authentication module

# Add a feature
/orchestrate-lite add password reset functionality

# Fix a bug
/orchestrate-lite fix the login form validation

# Create components
/orchestrate-lite create a data table component
```

### Sprint Planning with `/orchestrate`

```bash
# Plan major feature
/orchestrate build user profile management system

# Plan refactor
/orchestrate refactor authentication to use JWT

# Plan integration
/orchestrate integrate Stripe payment processing
```

### Mixed Approach (Recommended)

```bash
# Use lite for quick exploration
/orchestrate-lite explore the dashboard code

# Switch to full for implementation
/orchestrate build complete dashboard with charts and analytics
```

---

## 🎓 Learning Path

### Week 1: Start with `/orchestrate-lite`

**Day 1-2: Basic Usage**
```bash
/orchestrate-lite create a button
/orchestrate-lite create a form input
```

**Day 3-4: Explore Features**
```bash
/orchestrate-lite add navigation menu
/orchestrate-lite create user profile page
```

**Day 5-7: Real Tasks**
Use for actual project work, observe behavior

### Week 2: Add `/orchestrate` for Complex Tasks

**Day 1-2: Simple Complex Tasks**
```bash
/orchestrate create settings page with multiple sections
/orchestrate build data visualization dashboard
```

**Day 3-4: Multi-Phase Projects**
```bash
/orchestrate implement complete CRUD operations for users
/orchestrate build notification system with email and push
```

**Day 5-7: Production Work**
Use for major features in real projects

### Week 3+: Customize and Optimize

- Refine orchestrator prompts based on your needs
- Create custom skills for your patterns
- Adjust workflow instructions
- Share improvements with team

---

## 🛠️ Customization Points

### For Your Tech Stack

Already configured for:
- ✅ Vue 3 with Composition API
- ✅ Astro with SSR
- ✅ Nanostores for state
- ✅ TypeScript
- ✅ Appwrite for backend
- ✅ Tailwind CSS
- ✅ Zod validation

**To add more:**

Edit `orchestrate-lite.md` or `orchestrator.md` and add your stack to the guidelines:

```markdown
### Tech Stack Context
- Framework: [Your framework]
- State: [Your state management]
- API: [Your backend]
```

### For Your Patterns

**Add common patterns you use:**

```markdown
### Common Patterns
- Components: [Your structure]
- Naming: [Your conventions]
- Testing: [Your approach]
```

### For Your Workflows

**Customize the 5-phase workflow:**

```markdown
### Phase 3: Skill Selection (MODIFIED)
Instead of selecting skills, also check:
- Our component library
- Our API documentation
- Our design system
```

---

## 📊 Decision Guide

```
Need to orchestrate?
    │
    ├─ Simple task? → /orchestrate-lite
    │
    ├─ Complex task? → /orchestrate
    │
    ├─ Exploring? → /orchestrate-lite
    │
    ├─ Planning? → /orchestrate
    │
    ├─ Fast iteration? → /orchestrate-lite
    │
    └─ Production feature? → /orchestrate
```

**When in doubt, start with `/orchestrate-lite`.**  
You can always switch to `/orchestrate` if needed.

---

## 🎯 Success Criteria

You'll know orchestration is working when:

### Immediate Success Indicators
- ✅ Skill discovery finds your skills
- ✅ TodoWrite creates 5-phase list
- ✅ Explore agents launch in parallel
- ✅ Skills are invoked correctly

### Medium-Term Success
- ✅ You use orchestration daily
- ✅ Less time explaining, more time building
- ✅ Clearer task structure
- ✅ Better code exploration

### Long-Term Success
- ✅ Team adopts orchestration
- ✅ Custom skills created for common patterns
- ✅ Orchestrator refined for your workflow
- ✅ Measurably faster development

---

## 🐛 Common Issues & Solutions

### Issue: No skills found

**Solution:**
```bash
# Verify skills exist
ls -la ~/.claude/skills/

# Check SKILL.md format
cat ~/.claude/skills/*/SKILL.md | grep -A 2 "^---"

# Run test script
./test-skill-discovery.sh
```

### Issue: Todos not created

**Solution:**
- Check that TodoWrite is called in agent output
- Look for "TodoWrite" in conversation
- Try explicit prompt: "Now call TodoWrite"

### Issue: Orchestrator doesn't output JSON

**Solution:**
- Check orchestrator.md has clear JSON instructions
- Try invoking orchestrator manually
- Look for JSON in last message

### Issue: Hook doesn't run

**Solution:**
```bash
# Check registration
cat ~/.claude/settings.json | jq '.hooks'

# Check permissions
ls -la ~/.claude/hooks/process-orchestrator.sh

# Reload settings in Claude Code: /hooks menu
```

---

## 📖 Further Reading

### In This Package
1. **SETUP_GUIDE.md** - Detailed installation and troubleshooting
2. **ORCHESTRATION_GUIDE.md** - Feature comparison and use cases
3. **orchestrate-lite.md** - Command documentation
4. **orchestrator.md** - Subagent documentation

### External Resources
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Claude Code Subagents](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Claude Code Hooks](https://docs.claude.com/en/docs/claude-code/hooks)

---

## 🎉 You're Ready!

**Start with this simple command:**

```bash
# Copy the lightweight system
cp orchestrate-lite.md ~/.claude/commands/

# Test it
claude
> /orchestrate-lite create a button component
```

Then explore, experiment, and customize based on your needs!

---

## 📝 Quick Reference Card

```
┌─────────────────────────────────────────────┐
│ ORCHESTRATION QUICK REFERENCE               │
├─────────────────────────────────────────────┤
│                                             │
│ Simple task?                                │
│   /orchestrate-lite <description>           │
│                                             │
│ Complex task?                               │
│   /orchestrate <description>                │
│                                             │
│ Test skill discovery?                       │
│   ./test-skill-discovery.sh                 │
│                                             │
│ Check what you have?                        │
│   ls -la ~/.claude/commands/                │
│   ls -la ~/.claude/agents/                  │
│   ls -la ~/.claude/skills/                  │
│                                             │
└─────────────────────────────────────────────┘
```

**Remember:** Both systems follow the same workflow:
1. Explore
2. Select skills
3. Implement
4. Verify

Choose based on task complexity! 🚀

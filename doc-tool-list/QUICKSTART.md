# Quick Start Guide - `/tools` Command

## 🚀 Get Up and Running in 60 Seconds

### Step 1: Install (Choose One)

**Option A: Quick Install (Personal)**
```bash
mkdir -p ~/.claude/commands
cp tools.md ~/.claude/commands/
```

**Option B: Use the Installer Script**
```bash
chmod +x install.sh
./install.sh
```

**Option C: Project-Specific**
```bash
mkdir -p .claude/commands
cp tools.md .claude/commands/
```

### Step 2: Restart Claude Code
```bash
# Exit current session (if running)
exit

# Start new session
claude
```

### Step 3: Try It Out
```bash
# See everything
/tools

# Or filter by category
/tools commands
```

---

## ✨ What This Command Does

The `/tools` command gives you **instant visibility** into your entire Claude Code toolkit:

- 🔌 **MCP Servers** - API integrations (GitHub, Supabase, etc.)
- 🎓 **Agent Skills** - Specialized capabilities (PDF, Excel, etc.)
- 🤖 **Subagents** - Task-specific AI helpers
- ⚡ **Slash Commands** - Your custom shortcuts
- 🪝 **Hooks** - Automated behaviors
- 🧩 **Plugins** - Installed tool bundles
- 🎨 **Output Styles** - Personality modes
- ⚙️ **System Commands** - Built-in features

---

## 📖 File Overview

### `tools.md` ⭐
**The main slash command file**
- Copy this to `.claude/commands/` or `~/.claude/commands/`
- Contains all the discovery logic
- ~7.4KB, well-commented

### `README.md` 📚
**Complete documentation**
- Installation instructions
- Detailed usage guide
- Troubleshooting tips
- Advanced features

### `USAGE_EXAMPLES.md` 💡
**Real-world scenarios**
- 10 practical examples
- Integration with your stack
- Pro tips and tricks
- Quick reference tables

### `install.sh` 🔧
**Automated installer**
- Interactive setup
- User or project installation
- Git integration option

---

## 🎯 Most Common Use Cases

### 1. "What commands do I have?"
```bash
/tools commands
```

### 2. "What integrations are set up?"
```bash
/tools mcps
```

### 3. "Show me everything"
```bash
/tools
```

### 4. "What can automate my workflow?"
```bash
/tools hooks
```

---

## 💎 Perfect for Your Stack

Since you use **Vue 3, Astro, TypeScript, Appwrite, and Cloudflare**, this command helps you:

✅ Verify Cloudflare/Appwrite integrations are configured  
✅ Check TypeScript formatting hooks are enabled  
✅ Discover available deployment commands  
✅ Find API testing and scaffolding tools  
✅ See what automation is available  

---

## 🆘 Quick Troubleshooting

**Command not showing up?**
```bash
# Check installation
ls ~/.claude/commands/tools.md

# Restart Claude
exit
claude
```

**No tools found?**
- Normal for new installations!
- Start adding tools based on the suggestions
- Use `/mcp add`, `/plugin install`, etc.

---

## 📝 Customization

Want to modify the command? Edit `tools.md`:

1. **Add new categories** - Add sections for your custom tool types
2. **Change output format** - Modify the markdown structure
3. **Add filters** - Extend the `$ARGUMENTS` handling
4. **Add integrations** - Include your custom discovery logic

---

## 🔗 What to Read Next

- **First Time?** → Start with `README.md`
- **Want Examples?** → Check `USAGE_EXAMPLES.md`
- **Customizing?** → Edit `tools.md` directly
- **Installing?** → Run `install.sh`

---

## 🌟 Pro Tips

1. **Run at session start** - Get oriented quickly
2. **Use filters** - Focus on what matters now
3. **Combine with `/help`** - Cross-reference capabilities
4. **Document output** - Save results for team reference
5. **Check before adding** - Avoid duplicate installations

---

## 🎓 Learning Path

### Day 1: Discovery
```bash
/tools              # See what you have
/tools commands     # Learn available shortcuts
```

### Day 2-3: Organization
```bash
/tools mcps         # Check integrations
/tools agents       # Find automation helpers
/tools hooks        # See automatic behaviors
```

### Day 4+: Optimization
```bash
/tools              # Regular audit
# Add missing tools
# Remove unused ones
# Share with team
```

---

## 📊 Success Metrics

After installing, you should be able to:

- ✅ List all tools in under 2 seconds
- ✅ Find any command without searching docs
- ✅ Discover capabilities you didn't know existed
- ✅ Onboard new team members instantly
- ✅ Audit your setup before big projects

---

## 🤝 Getting Help

**Command not working?**
1. Check the troubleshooting section in README.md
2. Verify installation paths
3. Look at USAGE_EXAMPLES.md for similar scenarios

**Want to extend it?**
1. Fork/modify tools.md
2. Add your custom discovery logic
3. Share with the community!

---

## 📦 What's Included

```
📁 Your Download
├── tools.md              (7.4 KB) - The slash command
├── README.md             (7.4 KB) - Full documentation
├── USAGE_EXAMPLES.md     (7.1 KB) - Practical scenarios
├── install.sh            (3.2 KB) - Easy installer
└── QUICKSTART.md         (This file)
```

Total: ~25 KB of comprehensive Claude Code tooling!

---

## 🎉 You're Ready!

That's it! You now have a powerful tool discovery system for Claude Code.

**Next steps:**
1. Install using your preferred method above
2. Run `/tools` in your next Claude Code session
3. Explore the categories relevant to your work
4. Share this with your team!

**Questions?** Check the README.md for detailed answers.

**Want more?** See USAGE_EXAMPLES.md for advanced patterns.

---

Made for developers who want to **maximize their Claude Code productivity**. 

Compatible with Claude Code on **macOS** (including your 2019 Mac Pro!) and all platforms.

Happy coding! 🚀

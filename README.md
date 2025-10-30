# Claude Code User Configuration

Personal Claude Code configuration including skills, agents, slash commands, hooks, and output styles.

## 📁 Structure

```
~/.claude/
├── agents/          # Specialized subagents for delegation
├── commands/        # Custom slash commands
├── hooks/           # Lifecycle automation scripts
├── output-styles/   # Personality modes
├── scripts/         # Utility scripts
├── skills/          # On-demand knowledge modules
├── templates/       # Reusable templates
├── workflows/       # Multi-step workflows
├── CLAUDE.md        # Global instructions
└── settings.json    # Hooks configuration
```

## 🚀 Quick Start

1. Clone this repo to `~/.claude/`:
   ```bash
   git clone <your-repo-url> ~/.claude
   ```

2. Copy environment template and add your API keys:
   ```bash
   cp .env.example .env
   # Edit .env with your keys
   ```

3. Install any required dependencies for MCP servers

4. Reload Claude Code to pick up new configuration

## 🔑 Required Environment Variables

Create a `.env` file (gitignored) with:

```bash
GEMINI_API_KEY=your_key_here
FIRECRAWL_API_KEY=your_key_here
# Add other API keys as needed
```

## 📚 Key Features

### Skills (On-demand knowledge)
- `cc-mastery` - Claude Code ecosystem expertise
- `vue-component-builder` - Vue 3 + Composition API
- `nanostore-builder` - State management patterns
- `appwrite-integration` - Backend integration
- And more...

### Agents (Specialized delegation)
- `code-scout` - Pattern discovery
- `refactor-specialist` - Safe refactoring
- `bug-investigator` - Root cause analysis
- `code-reviewer` - Quality audits
- And more...

### Slash Commands
- `/orchestrate` - Lightweight task orchestration
- `/plan` - Intelligent planning workflows
- `/frontend` - Frontend feature workflows
- `/mcps` - MCP server management
- And more...

## 🔒 Security

- **Never commit** `.env` files (protected by `.gitignore`)
- **Never commit** `.mcp.json` if it contains hardcoded secrets
- Use `${ENV_VAR}` references in configs
- Run `/mcps audit` to detect hardcoded secrets

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Fork and adapt for your own use
- Submit issues for bugs
- Suggest improvements via PRs

## 📖 Documentation

See individual folders for detailed documentation:
- [Skills Documentation](./skills/)
- [Agents Documentation](./agents/)
- [Commands Documentation](./commands/)
- [Hooks Documentation](./hooks/)

## 🔗 Resources

- [Claude Code Docs](https://docs.claude.com/claude-code)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)

## 📝 License

MIT License - feel free to use and modify

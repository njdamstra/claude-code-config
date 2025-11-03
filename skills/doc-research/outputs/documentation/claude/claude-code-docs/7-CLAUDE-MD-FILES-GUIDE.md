# CLAUDE.md Files: Comprehensive Reference Guide

**Author:** Verified from Anthropic Official Documentation + Community Best Practices  
**Last Updated:** October 2025  
**Status:** Single Source of Truth - Complete Reference

---

## TABLE OF CONTENTS

1. [What Is CLAUDE.md](#what-is-claudemd)
2. [File Location & Scope](#file-location--scope)
3. [Format Specification](#format-specification)
4. [Content Structure](#content-structure)
5. [CLAUDE.md vs Other Configuration](#claudemd-vs-other-configuration)
6. [Best Practices](#best-practices)
7. [Real-World Examples](#real-world-examples)
8. [Troubleshooting & Edge Cases](#troubleshooting--edge-cases)

---

## WHAT IS CLAUDE.MD?

### Definition

CLAUDE.md is a special Markdown file that Claude Code automatically reads when starting a session in your project. It contains essential project information, coding standards, commands, and rules that Claude follows with superior instruction adherence.

### Key Characteristics

- **Automatically Loaded**: Claude reads it at session start
- **Hierarchical Priority**: Treated as immutable system rules (higher than prompts)
- **Token Budget**: Content is prepended to every prompt (costs tokens)
- **Format**: Standard Markdown (no special syntax required)
- **Scope**: Project-specific (not shared across projects)

### How Claude Uses CLAUDE.md

```
Session Start
  ↓
Claude reads CLAUDE.md
  ↓
Content prepended to context
  ↓
Treats instructions as system rules
  ↓
Applies to ALL prompts in session
  ↓
Not overridable by individual prompts
```

This is different from:
- **Prompts**: Flexible suggestions Claude may vary
- **CLAUDE.md**: Immutable rules Claude follows strictly

---

## FILE LOCATION & SCOPE

### Directory Locations (macOS)

```
Project Root:
CLAUDE.md                           # Primary project file
.claude/CLAUDE.md                   # Alternative location (same behavior)

Project Subdirectories:
src/CLAUDE.md                       # ONLY loaded if Claude is in src/
packages/frontend/CLAUDE.md         # ONLY loaded in this package

User Level (Not Recommended):
~/.claude/CLAUDE.md                 # Applies to all projects (rarely used)
```

### File Resolution

```
Priority (highest to lowest):
1. CLAUDE.md in current directory
2. CLAUDE.md in parent directory (project root)
3. CLAUDE.md in ancestor directories
4. ~/.claude/CLAUDE.md (if found)
```

**Best Practice**: Store at **project root** for all projects.

### Setup (macOS)

```bash
# Create in project root
touch CLAUDE.md

# Optional: Also in .claude/
mkdir -p .claude
touch .claude/CLAUDE.md

# Add to gitignore (or not - usually committed)
# CLAUDE.md files are typically committed to git
```

---

## FORMAT SPECIFICATION

### Markdown Format (No Special Syntax)

CLAUDE.md is **standard Markdown**. No special syntax required.

```markdown
# Project Name

## Description
Brief overview of what this project does.

## Development Commands
- `npm run dev`: Start development server
- `npm run test`: Run tests
- `npm run build`: Build for production

## Code Style
- Use ES modules (import/export)
- Destructure imports when possible
- 2-space indentation

## Important Rules
- Never modify database schema without migration
- Always write tests for new features
- Use TypeScript types, no `any`
```

### File Size Guidelines

| Size | Recommendation |
|------|-----------------|
| < 2KB | Ideal (minimal context overhead) |
| 2-10KB | Good (typical project) |
| 10-20KB | Large but acceptable |
| 20-50KB | Consider splitting |
| > 50KB | Definitely split |

**Why**: Every line of CLAUDE.md is included in every prompt. Bloated files waste tokens.

---

## CONTENT STRUCTURE

### Minimal CLAUDE.md

```markdown
# Project Name

## Setup
- Node 18+
- `npm install` to install dependencies

## Commands
- `npm run dev`: Start dev server
- `npm run test`: Run tests
- `npm run build`: Build for production

## Code Style
- Use TypeScript
- Use ES modules
- No `any` types

## Important Rules
- Tests must pass before committing
- Never commit `.env` files
```

### Complete CLAUDE.md Structure

```markdown
# Project Name & Version

Brief description of the project.

## Quick Start
- `git clone`
- `npm install`
- `npm run dev`
- Visit http://localhost:3000

## Project Structure
```
src/
├── components/    # React components
├── utils/         # Helper functions
├── pages/         # Route pages
└── styles/        # CSS modules
```

## Development Commands
- `npm run dev`: Start development server (port 3000)
- `npm run test`: Run Jest tests
- `npm run test:watch`: Run tests in watch mode
- `npm run lint`: Run ESLint
- `npm run format`: Format with Prettier
- `npm run build`: Create production build
- `npm run start`: Run production build

## Code Standards

### TypeScript
- Always use TypeScript for `.ts` / `.tsx` files
- No `any` types (use `unknown` if needed)
- Strict mode enabled in tsconfig.json
- Generic types with meaningful names (e.g., `T` for single types)

### React
- Use functional components with hooks
- Props must be typed (interface or type)
- Components in `src/components/` must have `.test.tsx` file
- Use React.memo for expensive components

### Styling
- Use CSS Modules (`.module.css`)
- Follow BEM naming convention
- No inline styles except for dynamic values

### Testing
- Jest for unit tests
- React Testing Library for component tests
- Minimum 80% code coverage required
- All async functions must have tests

## Important Rules

### Git Workflow
- Branch naming: `feature/name`, `bugfix/name`, `docs/name`
- Commits must be atomic (one logical change)
- Never commit directly to main
- Rebase before merging (no merge commits)

### Sensitive Files
- Never commit `.env` files
- `.env.example` shows structure but no real values
- Never log API keys or tokens
- DB migrations use numbered files (001-, 002-, etc.)

### Before Committing
1. Run `npm run lint` - must pass
2. Run `npm run format` - auto-fixes formatting
3. Run `npm run test` - must pass
4. Update CHANGELOG.md if user-facing
5. Commit with clear message

### Production Concerns
- All sensitive config in environment variables
- Tests must pass in CI/CD before deployment
- No console.log in production code
- Handle errors gracefully, never crash

## External APIs & Dependencies
- GitHub API: Uses octokit (v18+)
- Supabase: PostgreSQL database
- Auth: NextAuth.js v5
- See package.json for complete list

## Common Issues & Solutions

### Issue: Tests timeout
Solution: Increase Jest timeout in test file: `jest.setTimeout(10000)`

### Issue: TypeScript errors on build
Solution: Run `npm run lint` first to catch type errors

### Issue: Style not applied
Solution: Check CSS Module naming matches component name

## Documentation
- API docs: `/docs/api.md`
- Setup guide: `/docs/setup.md`
- Architecture: `/docs/architecture.md`
- Update docs when changing APIs

## Team Notes
- Daily standup at 9 AM PT
- Code review required before merge
- Ask #dev-team in Slack for questions
```

### Modular CLAUDE.md (For Large Projects)

If CLAUDE.md becomes > 10KB, split into sections:

```markdown
# Project Name

## Core Setup
[Core info only]

## Development Commands
[Essential commands]

## Code Standards
- See [CODE_STANDARDS.md](./CODE_STANDARDS.md)

## Git Workflow
- See [GIT_WORKFLOW.md](./GIT_WORKFLOW.md)

## Testing
- See [TESTING.md](./TESTING.md)

## Deployment
- See [DEPLOYMENT.md](./DEPLOYMENT.md)
```

Then create separate files and reference them.

---

## CLAUDE.MD VS OTHER CONFIGURATION

### Instruction Hierarchy (Highest to Lowest)

```
1. CLAUDE.md content      (Immutable system rules)
2. Output Styles          (System prompt override)
3. User prompts           (Flexible requests)
4. --append-system-prompt (Extra instructions)
```

### When to Use What

| Need | Solution | Why |
|------|----------|-----|
| Project rules & standards | CLAUDE.md | Always loaded, token-efficient |
| Non-coding workflows | Output Styles | Transforms Claude's personality |
| One-time instruction | Prompt | Flexible, doesn't cost tokens |
| Automated actions | Hooks | Guaranteed execution |
| External tools | MCP | Real-time data access |
| Custom commands | /commands | Reusable prompt templates |

### Comparison Table

| Feature | CLAUDE.md | Hooks | Skills | MCP |
|---------|-----------|-------|--------|-----|
| Auto-loaded | ✅ Yes | ❌ No | ❌ No | ❌ No |
| Always followed | ✅ Yes | ✅ Yes | ❌ No | ❌ No |
| Token efficient | ⚠️ Costs tokens | ✅ No cost | ⚠️ Tokens on use | ⚠️ Tokens on use |
| Skill-based discovery | ❌ No | ❌ No | ✅ Yes | ✅ Yes |
| Real-time data | ❌ No | ❌ No | ❌ No | ✅ Yes |

---

## BEST PRACTICES

### 1. Keep It Concise

**Rule**: Write for Claude, not for humans.

```markdown
# ❌ TOO LONG
## Babel Configuration
We use Babel to transpile our JSX and modern JavaScript features
down to ES5-compatible code that works in older browsers. Our
.babelrc file is configured with the React preset and the
stage-2 proposal features. The polyfill entry ensures compatibility.

# ✅ CONCISE
## Babel
Transpiles JSX + ES6+ to ES5. See `.babelrc` for config.
```

**Why**: Every character costs tokens. Be declarative, not narrative.

### 2. Use Clear Section Headers

```markdown
# ✅ CLEAR SECTIONS
## Development Commands
- `npm run dev`: Start dev server
- `npm run test`: Run tests

## Code Style
- Indent: 2 spaces
- Format: Run prettier before commit

## Important Rules
- Tests must pass before commit
- Never commit .env files

# ❌ UNCLEAR STRUCTURE
We have some commands you can run. There are also some rules
about formatting and you should know about testing...
```

### 3. Include Only What Claude Needs

```markdown
# ✅ RELEVANT
Framework: Next.js 14 (App Router)
Runtime: Node 18+
Package manager: npm
Tests: Jest + React Testing Library
Database: PostgreSQL (Supabase)

# ❌ EXCESSIVE DETAIL
We started with Next.js 12 but upgraded to 14 last January.
We considered Deno but decided Node 18 was more stable.
We use npm because the team is familiar with it from other projects...
```

### 4. Section Organization

Organize by functional areas to prevent "instruction bleeding":

```markdown
# Project Name

## Development
- `npm run dev`
- Runs on localhost:3000

## Testing
- `npm run test`
- Jest + React Testing Library
- Must pass before commit

## Deployment
- `npm run build`
- Production build to `/dist`
- Use GitHub Actions for CI/CD

## Code Style
- TypeScript strict mode
- ESLint config: .eslintrc.js
- Format: prettier --write

## Database
- PostgreSQL via Supabase
- Migrations in `/migrations`
- Never modify schema directly
```

This prevents Claude from mixing deployment rules into testing rules.

### 5. Use Lists, Not Paragraphs

```markdown
# ✅ SCANNABLE
## Command Reference
- `npm run dev`: Start dev server
- `npm run test`: Run tests
- `npm run build`: Production build
- `npm run lint`: Check code quality

# ❌ HARD TO SCAN
You have several commands available. You can start the development
server with npm run dev, which runs on port 3000. For testing,
use npm run test which uses Jest. When you're ready to deploy...
```

### 6. Explicit Decision Frameworks

If Claude needs to make decisions, provide a framework:

```markdown
## Code Review Checklist

When reviewing code, check in this order:
1. **Logic correctness** - Does it do what it's supposed to?
2. **Error handling** - Are errors caught and handled?
3. **Performance** - Are there N+1 queries or inefficient loops?
4. **Type safety** - All TypeScript types correct?
5. **Testing** - Are there tests for new code?
6. **Documentation** - Is new functionality documented?
7. **Style** - Does it match project standards?
```

---

## REAL-WORLD EXAMPLES

### Example 1: Vue3 + Astro + Node Project

```markdown
# Finance Tracker Pro

SPA dashboard for personal finance tracking. Vue3 frontend, Astro static pages, Node.js API.

## Setup
- Node 18+
- PostgreSQL 14+
- `npm install` to install all dependencies

## Development Commands
- `npm run dev`: Run dev server (frontend: localhost:3000, API: localhost:3001)
- `npm run test`: Run Jest tests
- `npm run lint`: Check code quality
- `npm run format`: Auto-format with Prettier
- `npm run build`: Build for production

## Project Structure
```
src/
├── pages/         # Astro static pages
├── components/    # Vue3 components
├── utils/         # Helper functions
└── api/           # Node API endpoints
public/            # Static assets
migrations/        # DB migrations (numbered: 001-, 002-, etc.)
```

## Tech Stack
- Frontend: Vue3 (Composition API)
- Static: Astro
- Backend: Node.js + Express
- Database: PostgreSQL (Supabase)
- Auth: NextAuth.js
- Styling: Tailwind CSS
- State: nanostore
- Type checking: TypeScript strict mode

## Code Standards

### TypeScript
- All `.ts` / `.tsx` files must have types
- No `any` - use `unknown` if needed
- Zod for runtime validation
- Enable strict mode in tsconfig.json

### Vue3 Components
- Use Composition API (no Options API)
- Props must be typed with `PropType<>`
- Every component needs `.test.ts` file
- Use `<script setup>` for simple components

### Node API
- Use Express middleware pattern
- Routes in `src/api/routes/`
- Middleware for auth, validation, error handling
- All endpoints return JSON

### Database
- Use migration files for schema changes
- Migrations numbered: 001-init, 002-add-users, etc.
- Supabase CLI for local testing
- Test all queries before committing

## Important Rules

### Before Committing
1. `npm run lint` - must pass
2. `npm run format` - auto-fixes
3. `npm run test` - must pass
4. No console.log in production code
5. Update CHANGELOG.md if user-facing change

### Files Never to Touch
- `.env` files (use .env.example)
- Database schema (use migrations)
- `node_modules/` (use npm install)

### Git Workflow
- Branch: `feature/feature-name` or `bugfix/issue-number`
- Commit: Atomic changes with clear messages
- Never force push to main
- Create PR for code review

## Common Commands
- `npm run migrate:latest` - Run pending migrations
- `npm run seed` - Seed test data
- `npm run typecheck` - TypeScript check only
- `npm run preview` - Preview production build

## Questions?
- Check GitHub issues for known problems
- Ask in #dev-team Slack channel
- Read ARCHITECTURE.md for system overview
```

### Example 2: Django Project

```markdown
# Community Forum

Django backend API for a community forum. PostgreSQL database, JWT auth.

## Setup
- Python 3.11+
- PostgreSQL 14+
- Virtual environment: `python -m venv venv && source venv/bin/activate`
- Install: `pip install -r requirements.txt`

## Development Commands
- `python manage.py runserver`: Start dev server (localhost:8000)
- `python manage.py test`: Run tests
- `pytest`: Run pytest (preferred)
- `python manage.py makemigrations`: Create new migration
- `python manage.py migrate`: Apply migrations
- `flake8 .`: Check code quality
- `black .`: Auto-format code

## Project Structure
```
forum/
├── apps/
│   ├── users/          # User management
│   ├── posts/          # Post CRUD
│   └── comments/       # Comment CRUD
├── migrations/         # DB migrations
├── tests/              # Tests
├── settings.py         # Django config
└── urls.py             # API routes
```

## Code Standards

### Python Style
- Use Black for formatting (line length: 88)
- Type hints on all functions
- docstrings on all classes and public methods
- Follow PEP 8

### Django Models
- All models use `CharField(max_length=X)` (no null=True without blank=True)
- Use `ForeignKey(on_delete=models.CASCADE)` explicitly
- Add `__str__` method to all models
- Use `help_text` for field descriptions

### API Views
- Use Django REST Framework APIView or ViewSet
- All endpoints require authentication (unless public)
- Return status codes (200, 201, 400, 404, 500)
- Document all endpoints

### Testing
- Write tests for all new endpoints
- Use pytest fixtures for common data
- Test both success and error cases
- Coverage minimum: 80%

## Important Rules
- Never modify production database
- Always use migrations for schema changes
- Keep sensitive settings in environment variables
- Never commit `.env` or `db.sqlite3`

## Git Workflow
- Branch naming: `feature/name`, `bugfix/issue-number`
- Require PR review before merge
- Rebase (no merge commits)
- Delete branch after merge

## Before Committing
1. `flake8 .` - linting
2. `black .` - formatting
3. `pytest` - tests must pass
4. Update CHANGELOG.md for user-facing changes
```

---

## TROUBLESHOOTING & EDGE CASES

### Q: CLAUDE.md isn't being loaded

**A**: Check file location and naming.

```bash
# Check if file exists
ls CLAUDE.md         # Should exist in project root
ls .claude/CLAUDE.md # Alternative location

# Verify it's being read
/compact summarize

# Check Claude Code docs
claude --help | grep claude
```

**Common issues**:
- File named `Claude.md` (wrong case)
- File in wrong directory
- File not saved yet (unsaved changes)

---

### Q: CLAUDE.md changes aren't taking effect

**A**: Changes only apply to NEW sessions.

```bash
# Exit and restart
exit

# Start new session to load updated CLAUDE.md
claude
```

**Changes mid-session won't apply** because CLAUDE.md is loaded at session start.

---

### Q: My CLAUDE.md is too long (>20KB)

**A**: Split into multiple files.

```markdown
# Project Name

## Quick Start
[Essential info only]

## Detailed Guides
- [Development Setup](./docs/setup.md)
- [Code Standards](./docs/standards.md)
- [Testing Guide](./docs/testing.md)
- [Deployment](./docs/deployment.md)
- [Troubleshooting](./docs/troubleshooting.md)
```

Store detailed info in separate `.md` files.

---

### Q: Can I use different CLAUDE.md for different directories?

**A**: Yes, create `CLAUDE.md` in subdirectories.

```bash
project/
├── CLAUDE.md                  # Default for whole project
├── frontend/
│   └── CLAUDE.md             # Only used when in frontend/
└── backend/
    └── CLAUDE.md             # Only used when in backend/
```

Claude reads the closest `CLAUDE.md` in current directory or parents.

---

### Q: Should I commit CLAUDE.md to git?

**A**: **YES**. CLAUDE.md should be committed.

```bash
# Good: Commit to git
git add CLAUDE.md
git commit -m "Add project guidelines"

# Why: Team members get consistent instructions
# All developers see same project standards
```

Exception: Sensitive information → move to `.env.example` instead.

---

### Q: How do I include examples in CLAUDE.md without bloating it?

**A**: Reference external files.

```markdown
# Code Style

For examples, see:
- [TypeScript Examples](./docs/examples/typescript.md)
- [Component Examples](./docs/examples/components.md)
- [Testing Examples](./docs/examples/tests.md)

Inline examples: Keep to <5 lines each
\`\`\`typescript
// Example: Typed component
const Button: React.FC<{ label: string }> = ({ label }) => <button>{label}</button>
\`\`\`
```

---

### Q: Can CLAUDE.md reference other projects or docs?

**A**: Yes, but keep links relative.

```markdown
# ✅ GOOD - Relative link
See [Testing Guide](./docs/testing.md)
See [Frontend README](./frontend/README.md)

# ❌ AVOID - External links
Visit https://example.com/documentation
```

Relative links survive project moves and work offline.

---

### Q: CLAUDE.md for Vue3 + Astro + Node projects - what should I include?

**A**: Focus on what varies by project.

```markdown
# My Project Name

## Tech Stack
- Frontend: Vue3 (Composition API)
- Static: Astro  
- Backend: Node.js + Express
- Database: PostgreSQL
- Styles: Tailwind CSS
- State: nanostore

## Commands
- `npm run dev`: Dev server
- `npm run test`: Tests
- `npm run build`: Production build

## Code Style
- TypeScript strict mode
- Use Composition API in Vue3
- Astro `.astro` files for pages
- Express middleware pattern

## Project Structure
```
src/
├── pages/          # Astro static pages
├── components/     # Vue3 components
├── api/           # Node endpoints
└── utils/
public/           # Static assets
```

## Important Rules
- Tests must pass before commit
- No console.log in production
- Use migrations for DB schema
- Never commit .env files
```

---

## QUICK REFERENCE CHECKLIST

- [ ] CLAUDE.md exists in project root
- [ ] File is committed to git
- [ ] Under 10KB (split if larger)
- [ ] Uses Markdown format (standard, no special syntax)
- [ ] Section headers are clear and scannable
- [ ] Lists instead of paragraphs
- [ ] Includes: setup, commands, code style, important rules
- [ ] No sensitive information (API keys, passwords)
- [ ] Referenced files exist
- [ ] Tested by starting new Claude Code session

---

## RELATED RESOURCES

- Official Claude Code Docs: https://docs.claude.com/en/docs/claude-code/settings
- Claude Code Best Practices: https://www.anthropic.com/engineering/claude-code-best-practices
- ClaudeLog CLAUDE.md Guide: https://claudelog.com/faqs/what-is-claude-md/
- Example CLAUDE.md Files: https://github.com/hesreallyhim/awesome-claude-code
- Harper Reed's Blog Post: https://harper.blog/2025/05/08/basic-claude-code/

---

## SUMMARY

**CLAUDE.md = Your Project's Constitution for Claude**

1. **Scope**: Applied to every prompt in the session
2. **Priority**: Treated as immutable system rules
3. **Format**: Standard Markdown
4. **Location**: Project root
5. **Content**: Setup, commands, standards, rules
6. **Best Practice**: Keep concise (<10KB), reference external docs
7. **Usage**: Automatically loaded when Claude starts
8. **Sharing**: Commit to git for team consistency

---
description: Create documentation using workflow-specific multi-agent orchestration (v2 with workflow support). Supports comprehensive docs, how-to guides, quick references, and architecture docs.
argument-hint: new <topic-name> [Description: ...] [Workflow: ...] [Flags: --frontend|--backend|--both]
---

# Documentation Command

Generate documentation for codebase topics using workflow-specific multi-agent orchestration.

## Usage

```bash
/docs new <topic-name>
Description: <detailed explanation>
Workflow: <comprehensive|how-to|quickref|architecture>
Flags: --frontend | --backend | --both
```

**Defaults:**
- If no workflow specified: `comprehensive`
- If no flag specified: `--frontend`

---

## Workflow Types

### 1. Comprehensive (default)
Full multi-agent research with verification.

**Best for:** Complete feature documentation
**Time:** 20-60 minutes
**Tokens:** 50K-350K

**Example:**
```bash
/docs new authentication
Description: Document the authentication system including login, registration, and session management
Flags: --both
```

---

### 2. How-To
Task-focused tutorials with step-by-step instructions.

**Best for:** Implementation guides, "how do I..." questions
**Time:** 5-15 minutes
**Tokens:** 15-50K

**Example:**
```bash
/docs new user-registration
Description: Step-by-step guide for implementing user registration flow
Workflow: how-to
Flags: --both
```

---

### 3. Quickref
Concise cheat sheets with common patterns.

**Best for:** Reference docs, quick lookups, pattern catalogs
**Time:** 5-10 minutes
**Tokens:** 10-35K

**Example:**
```bash
/docs new tailwind-patterns
Description: Common Tailwind utility patterns used across the project
Workflow: quickref
```

---

### 4. Architecture
System design and component relationships.

**Best for:** Architectural documentation, system design, integration flows
**Time:** 15-45 minutes
**Tokens:** 30-250K

**Example:**
```bash
/docs new api-layer
Description: Document API integration architecture and data flows
Workflow: architecture
Flags: --both
```

---

## What This Command Does

This command invokes the **codebase-documentation** skill, which:

1. **Detects workflow type** from user input
2. **Loads workflow configuration** (phases, subagents, template)
3. **Executes workflow-specific phases:**
   - **Comprehensive:** plan → discovery → analysis → synthesis → verification → finalize
   - **How-to:** plan → discovery → synthesis → finalize
   - **Quickref:** discovery → synthesis → finalize
   - **Architecture:** plan → discovery → analysis → synthesis → finalize
4. **Spawns workflow-specific subagents** (2-20 depending on workflow)
5. **Uses workflow-specific template** for output formatting

---

## Output Location

Documentation is created at:
```
[project]/.claude/brains/<topic-name>/
├── main.md              # Final documentation
├── metadata.json        # Topic metadata (includes workflow type)
├── .temp/              # Research artifacts (preserved)
│   ├── plan.md
│   ├── phase1-discovery/
│   ├── phase2-analysis/ (if applicable)
│   └── phase4-verification/ (if applicable)
└── archives/           # Previous versions
```

---

## Examples

### Example 1: Comprehensive Documentation
```bash
/docs new animations
Description: Document Vue animation patterns, transitions, and composables used throughout the project
Flags: --frontend
```

**Result:** Full research-backed documentation with verification

---

### Example 2: How-To Guide
```bash
/docs new create-modal
Description: How to create a modal component with proper accessibility and SSR support
Workflow: how-to
Flags: --frontend
```

**Result:** Step-by-step tutorial with working examples

---

### Example 3: Quick Reference
```bash
/docs new zod-patterns
Description: Common Zod validation patterns used in the codebase
Workflow: quickref
```

**Result:** Concise cheat sheet with syntax table and examples

---

### Example 4: Architecture Documentation
```bash
/docs new appwrite-integration
Description: Document Appwrite integration architecture across frontend and backend
Workflow: architecture
Flags: --both
```

**Result:** System design with diagrams, data flows, and integration points

---

## Processing Arguments

Parse the input to extract:

1. **Action**: Must be "new" (for creating new documentation)
2. **Topic Name**: The subject to document (required)
3. **Description**: Detailed explanation (required after "Description:")
4. **Workflow**: Optional workflow type (after "Workflow:")
5. **Flags**: Optional --frontend, --backend, or --both

### Parsing Logic

Input: $ARGUMENTS

Parse as:
  - First word: action ("new")
  - Second word: topic name
  - After "Description:": detailed description
  - After "Workflow:": workflow type (comprehensive|how-to|quickref|architecture)
  - After "Flags:": flag values

---

## Invoking the Skill

When this command is invoked, describe the documentation task in natural language that will trigger Claude to automatically invoke the **codebase-documentation** skill.

**Example response:**

"I'll create [workflow-name] documentation for [topic-name].

**Topic:** [topic-name]
**Workflow:** [workflow-type]
**Scope:** [based on flags: frontend/backend/both]
**Description:** [user's description]

This will involve:
- [X] subagent invocations across [Y] phases
- [Workflow-specific approach description]
- Expected token usage: [N-M]K tokens
- Estimated time: [X-Y] minutes

Let me proceed with [workflow-name] workflow..."

Claude will then automatically recognize this matches the **codebase-documentation** skill and invoke it.

---

## Important Notes

### Token Usage
Token usage varies significantly by workflow:
- **Quickref:** 10-35K (minimal research)
- **How-to:** 15-50K (focused patterns)
- **Architecture:** 30-250K (system-wide analysis)
- **Comprehensive:** 50-350K (full research + verification)

Choose the appropriate workflow for your needs to optimize token usage.

### Time Commitment
- **Quickref:** 5-10 minutes (fast)
- **How-to:** 5-15 minutes (moderate)
- **Architecture:** 15-45 minutes (substantial)
- **Comprehensive:** 20-60 minutes (thorough)

### Workflow Selection Guide

**Use comprehensive when:**
- Creating primary feature documentation
- Need verified, complete documentation
- Documentation will be referenced frequently

**Use how-to when:**
- Answering "how do I..." questions
- Creating implementation tutorials
- Documenting specific tasks or procedures

**Use quickref when:**
- Creating cheat sheets
- Documenting patterns or syntax
- Need fast reference documentation

**Use architecture when:**
- Documenting system design
- Explaining component relationships
- Mapping data flows and integration points

---

## Error Handling

### Invalid Workflow Type
If workflow type doesn't match options:
```
Error: Invalid workflow type "[type]"

Valid workflows: comprehensive, how-to, quickref, architecture

Example: /docs new authentication
         Description: Document auth system
         Workflow: comprehensive
```

### Missing Description
If description not provided:
```
Please provide a description of what to document.

Example format:
/docs new authentication
Description: Document the authentication system including login, registration, and session management
Workflow: comprehensive
```

### Topic Already Exists
If `.claude/brains/<topic-name>` already exists:
```
Documentation for "[topic-name]" already exists.

Options:
1. Archive existing and regenerate: I can archive the current version and create fresh documentation
2. View existing: [link to existing main.md]
3. Choose different topic name

What would you like to do?
```

---

## Integration with Skill System

This command works by describing the documentation task in natural language that matches the **codebase-documentation** skill's description triggers. The workflow is:

1. **Command receives:** User input via `/docs new <topic> Description: ... Workflow: ... Flags: ...`
2. **Command parses:** Extracts topic name, description, workflow, and flags
3. **Command outputs:** Natural language description of the documentation task
4. **Claude recognizes:** The description matches the **codebase-documentation** skill
5. **Skill activates:** Claude automatically invokes the skill using the Skill tool
6. **Skill orchestrates:** Workflow-specific multi-agent documentation process begins

The skill is located at `~/.claude/skills/docs/SKILL.md` and automatically activates when Claude recognizes the documentation task matches its description.

---

## Viewing Documentation

After completion, users can:

```bash
# View in editor
open [project]/.claude/brains/<topic-name>/main.md

# Or if using Claude Code
view .claude/brains/<topic-name>/main.md
```

---

## Regenerating Documentation

To update existing documentation:
```bash
/docs new <same-topic-name>
Description: <updated description if needed>
Workflow: <same or different workflow>
```

The existing version will be archived to:
`.claude/brains/<topic-name>/archives/<timestamp>-main.md`

---

## Troubleshooting

### Command Not Found
- Verify file exists at `~/.claude/commands/docs.md`
- Restart Claude Code session
- Check with `/help` to see if command listed

### Skill Not Loading
- Verify `~/.claude/skills/docs/SKILL.md` exists
- Check skill has proper YAML frontmatter with `name: docs`
- Verify workflow configs exist in `workflows/`, `phases/`, `subagents/`

### Wrong Workflow Executed
- Verify workflow name spelling (comprehensive, how-to, quickref, architecture)
- Check natural language doesn't conflict with workflow detection
- Explicitly specify with `Workflow:` parameter

---

## Comparing with Original /docs Command

**Original /docs (comprehensive only):**
- Single workflow (comprehensive research)
- Always 15-20 subagents
- Always runs verification
- 50K-350K tokens

**New /docs (4 workflows):**
- 4 workflow options (comprehensive, how-to, quickref, architecture)
- 2-20 subagents (workflow-dependent)
- Verification only for comprehensive
- 10K-350K tokens (workflow-dependent)

**Migration:**
- `/docs new topic` → `/docs new topic` (same behavior, backward compatible)
- Add `Workflow: how-to` for faster task-focused docs
- Add `Workflow: quickref` for cheat sheets
- Add `Workflow: architecture` for system design

---

*This command uses the codebase-documentation skill with modular workflow orchestration.*

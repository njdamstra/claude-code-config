

---
description: Create comprehensive codebase documentation using multi-agent research. Analyzes files, patterns, architecture, and generates verified documentation with examples.
argument-hint: new <topic-name> [Description: ...] [Flags: --frontend|--backend|--both]
---

# Documentation Command

Generate comprehensive documentation for a codebase topic using multi-agent orchestration.

## Usage

```bash
/docs new <topic-name>
Description: <detailed explanation of what to document>
Flags: --frontend | --backend | --both
```

**Default:** If no flag specified, uses `--frontend`

## Examples

### Frontend Component Documentation
/docs new animations
Description: Document Vue animation patterns, transitions, and composables
Flags: --frontend

### Backend API Documentation
/docs new api-integration
Description: Document Appwrite serverless functions and database schemas
Flags: --backend

### Full-Stack Feature Documentation
/docs new onboarding
Description: Document complete user onboarding flow from frontend to backend
Flags: --both

### Minimal Invocation
/docs new authentication
Description: Document authentication system

## What This Command Does

This command invokes the **codebase-documentation** skill, which:

1. **Phase 0: Strategic Planning**
   - Analyzes topic scope and complexity
   - Plans subagent strategy
   - Estimates resources needed

2. **Phase 1: Parallel Discovery (3-5 subagents)**
   - Maps dependencies
   - Scans relevant files with confidence scoring
   - Extracts naming and composition patterns
   - Analyzes components (if --frontend)
   - Analyzes serverless functions (if --backend)

3. **Phase 2: Parallel Analysis (3-5 subagents)**
   - Deep-dives into implementation details
   - Synthesizes system architecture
   - Extracts real-world usage patterns

4. **Phase 3: Documentation Synthesis**
   - Combines all research findings
   - Creates comprehensive documentation
   - Follows standard template

5. **Phase 4: Parallel Verification (2-3 subagents)**
   - Verifies accuracy of all claims
   - Checks completeness against discoveries
   - Validates code examples

6. **Phase 5: Finalization**
   - Applies critical fixes
   - Creates metadata
   - Delivers final documentation

## Output Location

Documentation is created at:
[project]/.claude/brains/<topic-name>/
├── main.md              # Final documentation
├── metadata.json        # Topic metadata
├── .temp/              # Research artifacts (preserved)
│   ├── plan.md
│   ├── phase1-discovery/
│   ├── phase2-analysis/
│   └── phase4-verification/
└── archives/           # Previous versions (when regenerating)

## Expected Performance

- **Simple topics** (~5 files): 50-80K tokens, 10-15 minutes
- **Moderate topics** (~20 files): 120-200K tokens, 20-30 minutes
- **Complex topics** (~50+ files): 250-350K tokens, 40-60 minutes

## Quality Guarantees

✓ **Accuracy**: All file paths, function signatures, and code examples verified
✓ **Completeness**: >80% file coverage, >90% pattern coverage
✓ **Examples**: All code examples syntactically validated
✓ **Verification**: Multi-subagent verification process

## Processing Arguments

Parse the input to extract:

1. **Action**: Must be "new" (for creating new documentation)
2. **Topic Name**: The subject to document (required)
3. **Description**: Detailed explanation (required after "Description:")
4. **Flags**: Optional --frontend, --backend, or --both

### Parsing Logic

Input: $ARGUMENTS

Parse as:
  - First word: action ("new")
  - Second word: topic name
  - After "Description:": detailed description
  - After "Flags:": flag values

## Invoking the Skill

When this command is invoked, describe the documentation task in natural language that will trigger Claude to automatically invoke the **docs** skill (codebase-documentation).

**Example response:**

"I'll create comprehensive documentation for [topic-name] using multi-agent orchestration.

**Topic:** [topic-name]
**Scope:** [based on flags: frontend/backend/both]
**Description:** [user's description]

This will involve:
- 15-20 subagent invocations across 5 phases
- Comprehensive research of relevant files
- Verified, accurate documentation
- Expected token usage: [estimate based on scope]K tokens

Let me document this topic comprehensively, researching the codebase architecture, patterns, dependencies, and implementation details."

Claude will then automatically recognize this matches the **docs** skill and invoke it, which triggers reading the SKILL.md file and following its orchestration instructions.

## Important Notes

### Token Usage
This is a **token-intensive** operation. Warn users if their topic seems very broad:
- Suggest breaking into smaller topics if >50 files expected
- Recommend using flags (--frontend or --backend) to focus scope

### Time Commitment
Documentation generation is thorough but time-consuming:
- User should expect 15-30 minute sessions for moderate topics
- Claude will spawn many subagents and process significant context

### Quality Over Speed
The skill prioritizes:
- ✓ Accuracy and verification
- ✓ Comprehensive coverage
- ✓ Real examples from codebase
- ✗ Not optimized for speed

### Flag Behavior

**--frontend**: Spawns component-analyzer, focuses on Vue components, composables, UI patterns

**--backend**: Spawns backend-analyzer, focuses on Appwrite functions, database schemas, API patterns

**--both**: Spawns both analyzers, documents full-stack flow including frontend-backend integration

**No flag**: Defaults to --frontend

## Error Handling

### Invalid Input
If arguments don't match expected format:
Error: Invalid command format.

Usage: /docs new <topic-name>
       Description: <what to document>
       Flags: --frontend | --backend | --both

Example: /docs new authentication
         Description: Document authentication flow
         Flags: --both

### Missing Description
If description not provided:
Please provide a description of what to document.

Example format:
/docs new authentication
Description: Document the authentication system including login, registration, and session management

### Topic Already Exists
If `.claude/brains/<topic-name>` already exists:
Documentation for "[topic-name]" already exists.

Options:
1. Archive existing and regenerate: I can archive the current version and create fresh documentation
2. View existing: [link to existing main.md]
3. Choose different topic name

What would you like to do?

## Integration with Skill System

This command works by describing the documentation task in natural language that matches the **docs** skill's description triggers. The workflow is:

1. **Command receives:** User input via `/docs new <topic> Description: ... Flags: ...`
2. **Command parses:** Extracts topic name, description, and flags
3. **Command outputs:** Natural language description of the documentation task
4. **Claude recognizes:** The description matches the **docs** skill (name: codebase-documentation)
5. **Skill activates:** Claude automatically invokes the skill using the Skill tool
6. **Skill orchestrates:** Multi-agent documentation process begins

The skill is located at `~/.claude/skills/docs/SKILL.md` and automatically activates when Claude recognizes the documentation task matches its description.

## Viewing Documentation

After completion, users can:

```bash
# View in editor
open [project]/.claude/brains/<topic-name>/main.md

# Or if using Claude Code
view .claude/brains/<topic-name>/main.md
```

## Regenerating Documentation

To update existing documentation:
/docs new <same-topic-name>
Description: <updated description if needed>

The existing version will be archived to:
.claude/brains/<topic-name>/archives/<timestamp>-main.md

## Troubleshooting

### Command Not Found
- Verify file exists at `~/.claude/commands/docs.md`
- Restart Claude Code session
- Check with `/help` to see if command listed

### Skill Not Loading
- Verify `~/.claude/skills/docs/SKILL.md` exists
- Check skill has proper YAML frontmatter
- Verify resources/ and templates/ directories present

### Subagents Not Found
- Verify all 11 subagents in `~/.claude/agents/docs/`
- Check subagent files have proper YAML frontmatter
- Run setup script: `~/.claude/skills/docs/scripts/setup.sh`

### Output Directory Missing
- Verify project root has `.claude/` directory
- Skill will create `.claude/brains/` automatically
- Check write permissions in project directory

---

## Installation Verification

After placing this file at `~/.claude/commands/docs.md`:

```bash
# Start Claude Code
claude

# Verify command available
/help
# Should show: /docs - Create comprehensive codebase documentation...

# Test invocation
/docs new test-topic
Description: Test documentation command
```

---

## Command Flow Diagram

User: /docs new authentication
      Description: Document auth flow
      Flags: --both
      ↓
Command Parser
├─ Extract: action="new"
├─ Extract: topic="authentication"  
├─ Extract: description="Document auth flow"
└─ Extract: flags="--both"
      ↓
Validate Input
├─ Check topic name valid
├─ Check description provided
└─ Check flags valid
      ↓
Check Existing
├─ If exists → Offer to archive
└─ If new → Proceed
      ↓
Invoke Skill: codebase-documentation
├─ Pass topic name
├─ Pass description
└─ Pass flags
      ↓
Skill Orchestration
├─ Phase 0: Strategic Planning
├─ Phase 1: Discovery (spawn 3-5 subagents)
├─ Phase 2: Analysis (spawn 3-5 subagents)
├─ Phase 3: Synthesis
├─ Phase 4: Verification (spawn 2-3 subagents)
└─ Phase 5: Finalization
      ↓
Output
├─ main.md
├─ metadata.json
└─ .temp/ (research artifacts)
      ↓
User Notification
└─ "Documentation complete: [link]"

---

## Advanced Usage

### Programmatic Invocation

The command can be invoked programmatically via Claude Code API or in scripts:

```bash
claude -p "/docs new api-endpoints
Description: Document REST API endpoints
Flags: --backend"
```

### Batch Documentation

Document multiple topics in sequence:

```bash
/docs new authentication
Description: Auth system
Flags: --both

# Wait for completion, then:

/docs new user-profile  
Description: User profile management
Flags: --frontend

# Continue for other topics...
```

### CI/CD Integration

Include in CI pipeline to regenerate docs on changes:

```yaml
# .github/workflows/docs.yml
- name: Update Documentation
  run: |
    claude -p "/docs new api-integration
    Description: API integration layer
    Flags: --backend"
```

---

## Best Practices

### Topic Naming
- **Good**: "authentication", "user-profile", "payment-flow"
- **Bad**: "the auth stuff", "user things", "payments"
- Use kebab-case for multi-word topics
- Be specific but not overly verbose

### Descriptions
- **Good**: "Document the authentication system including login, registration, JWT handling, and session management"
- **Bad**: "auth docs"
- Include key components and workflows
- Mention specific technologies if relevant (OAuth, JWT, etc.)

### Flag Selection
- **--frontend**: UI components, composables, client-side logic
- **--backend**: API endpoints, database schemas, serverless functions
- **--both**: Full-stack features with frontend-backend integration
- Default to narrower scope (--frontend or --backend) for faster, focused docs

### When to Break Into Multiple Topics
Break large topics into smaller ones if:
- More than 50 files involved
- Multiple distinct features/systems
- Frontend and backend can be documented separately
- Want faster iteration with smaller scopes

Example:
Instead of: `/docs new user-management (massive scope)`
Break into:
- `/docs new user-profile --frontend`
- `/docs new user-api --backend`
- `/docs new user-permissions --both`

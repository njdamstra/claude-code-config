---
name: CC Skill Builder
description: MUST BE USED for creating and designing Claude Code skills with proper structure, frontmatter, and progressive disclosure. Use when creating new skills, modifying existing skills, designing skill architectures, or asking "how do I create a skill", "make a skill for", "design a skill", "skill best practices". Provides complete skill templates, frontmatter validation, description optimization, progressive disclosure patterns, and file organization strategies. Use for "create skill", "new skill", "skill structure", "SKILL.md", "skill frontmatter", "skill description", "skill organization".
version: 1.0.0
tags: [claude-code, skills, skill-creation, skill-design, frontmatter, progressive-disclosure, templates, best-practices, skill-architecture]
---

# CC Skill Builder

## Quick Start

A Claude Code skill is a modular capability that Claude autonomously invokes based on your request and the skill's description. Skills consist of:

1. **SKILL.md** - Required file with YAML frontmatter + core instructions
2. **Supporting files** - Optional reference docs, examples, scripts, templates
3. **Progressive disclosure** - Load information only as needed to minimize context

**Key Principle:** Skills are model-invoked (Claude decides when to use them based on description), NOT user-invoked like slash commands.

## Core Skill Architecture

### File Structure

```
~/.claude/skills/my-skill/          # User-level (personal)
├── SKILL.md                        # Required: frontmatter + core instructions
├── reference.md                    # Optional: detailed documentation
├── examples.md                     # Optional: usage examples
├── scripts/
│   ├── helper.py                   # Optional: executable scripts
│   └── validator.sh
└── templates/
    ├── template-1.txt
    └── template-2.json

.claude/skills/project-skill/       # Project-level (team shared)
└── [same structure]
```

**Scope Rules:**
- User-level: `~/.claude/skills/` - Personal workflows, cross-project
- Project-level: `.claude/skills/` - Team standards, version controlled
- Priority: Project-level overrides user-level with same name

### SKILL.md Format

```markdown
---
name: Skill Display Name
description: |
  One-line summary describing WHAT this skill does and WHEN to use it.
  Be specific: mention file types, use cases, and trigger conditions.
version: 1.0.0
tags: [category, use-case, tool]
---

# Skill Display Name

## Quick Start
- 2-3 bullet points for immediate use
- What Claude should do first

## Instructions
1. Primary workflow steps
2. Decision points
3. Error handling

## Examples
### Basic Example
[Code or walkthrough]

### Advanced Example
[Complex scenario]

## Reference
For detailed information, see [reference.md](reference.md).

## Troubleshooting
### Issue: X happens
Solution: Y
```

## CRITICAL: Description Field Mastery

**The description is your ONLY chance to tell Claude when to use this skill.**

### Description Best Practices

❌ **WRONG - Too Vague:**
```yaml
description: Helpful skill for analysis
```

✅ **RIGHT - Specific Triggers:**
```yaml
description: |
  Analyze sales data in Excel files and CRM exports. Use for sales reports,
  pipeline analysis, and revenue tracking. Works with .xlsx and .csv formats.
  Use when "analyze spreadsheet", "create pivot table", "sales report".
```

### Description Components

Include these elements:
1. **WHAT it does** - Core capability in one sentence
2. **WHEN to use** - Specific triggers and use cases
3. **File types** - .xlsx, .csv, .json, .md, .py, etc.
4. **Keywords** - Search terms users might mention
5. **Output types** - Charts, reports, summaries, code, etc.

### Description Template

```yaml
description: |
  [ACTION VERB] [WHAT]. Use for [USE CASE 1], [USE CASE 2], and [USE CASE 3].
  Works with [FILE TYPES]. Use when [TRIGGER PHRASE 1], [TRIGGER PHRASE 2].
```

### Real Examples

```yaml
# Example 1: Domain-specific skill
description: |
  Build Vue 3 components using Composition API with TypeScript strict mode
  and Tailwind CSS. Use when creating .vue SFCs, building form components,
  modals with Teleport, or integrating third-party libraries. Use for
  "create component", "build Vue component", ".vue file", "modal", "form".

# Example 2: Tool integration
description: |
  Create and manage Appwrite database collections, authentication flows,
  and file storage with proper SSR compatibility. Use when integrating
  Appwrite SDK, setting up auth (OAuth, JWT), querying collections with
  Query patterns, or uploading files. Use for "Appwrite", "database query",
  "auth flow", "file upload", "realtime subscription".

# Example 3: Meta-skill (like this one!)
description: |
  MUST BE USED for creating and designing Claude Code skills with proper
  structure, frontmatter, and progressive disclosure. Use when creating
  new skills, modifying existing skills, or asking "how do I create a skill",
  "make a skill for", "design a skill", "skill best practices".
```

## Progressive Disclosure Pattern

**Core Concept:** Load information only as needed to minimize context usage.

### Context Window Usage Lifecycle

```
├─ Initial Context ──── SKILL.md metadata only (~100 tokens)
│  - name: "My Skill"
│  - description: "..."
│
├─ Skill Triggered ──── SKILL.md full content loaded (~500-1000 tokens)
│  - Instructions section
│  - Basic examples
│
├─ Claude Chooses ───── Supporting files on demand (~1000-5000 tokens/file)
│  - reference.md for API details
│  - examples.md for specific case
│
└─ Execution ────────── Only necessary code runs
   - Scripts with specific parameters
   - Templates instantiated
```

### Size Guidelines

| SKILL.md Size | Action |
|---------------|--------|
| < 2KB | Ideal - always loads completely |
| 2-10KB | Good - typical for most skills |
| 10-50KB | Consider splitting into files |
| > 50KB | **Definitely split** - move reference/examples to separate files |

### How to Split

**SKILL.md (Keep concise):**
```markdown
## Instructions
[Core workflow - 3-5 steps]

## Examples
[1-2 basic examples inline]

See [examples.md](examples.md) for:
- Advanced use cases
- Edge case handling
- Integration patterns

## API Reference
For detailed API specifications, see [api-reference.md](api-reference.md).
```

**examples.md (Separate file):**
```markdown
# Detailed Examples

## Example 1: Basic Workflow
[Full walkthrough]

## Example 2: Advanced Pattern
[Complex scenario]

## Example 3: Edge Cases
[Error handling]
```

## Skill Templates

### Template 1: Domain Knowledge Skill

```markdown
---
name: [Domain] Expert
description: |
  [Action] for [domain] using [tools/frameworks]. Use when [trigger 1],
  [trigger 2], or working with [file types]. Use for "[keyword 1]",
  "[keyword 2]", "[keyword 3]".
version: 1.0.0
tags: [domain, use-case, tool]
---

# [Domain] Expert

## Quick Start
- What this skill helps with
- Primary use cases (3-5 bullet points)

## Instructions

### Step 1: [Phase Name]
1. [Specific action]
2. [Expected outcome]

### Step 2: [Phase Name]
1. [Specific action]
2. [Expected outcome]

### Step 3: [Output]
- [What gets created]
- [Format specifications]

## Examples

### Example 1: [Common Use Case]
User provides: [Input]
Claude: [Steps] → [Output]

### Example 2: [Advanced Use Case]
[Walkthrough]

## Troubleshooting

### Issue: [Common Problem]
Solution: [How to fix]

### Issue: [Another Problem]
Solution: [How to fix]

## References
For detailed specifications, see [reference.md](reference.md).
```

### Template 2: Code Generation Skill

```markdown
---
name: [Language/Framework] Builder
description: |
  Generate [what] using [language/framework] with [patterns]. Use when
  creating [artifact types], building [features], or working with [file types].
  Use for "[keyword 1]", "[keyword 2]", "[keyword 3]".
version: 1.0.0
tags: [language, framework, code-generation]
---

# [Language/Framework] Builder

## Quick Start
- Generate production-ready [artifact] code
- Follow [framework] best practices
- Include [patterns] by default

## Core Patterns

### Pattern 1: [Pattern Name]
**When to use:** [Scenario]

\`\`\`[language]
// Code example
\`\`\`

### Pattern 2: [Pattern Name]
**When to use:** [Scenario]

\`\`\`[language]
// Code example
\`\`\`

## Instructions

1. **Understand Requirements**
   - Ask clarifying questions if needed
   - Identify [specific concerns]

2. **Generate Code**
   - Use [pattern] for [scenario]
   - Include [required elements]
   - Follow [conventions]

3. **Validate**
   - Check [criterion 1]
   - Verify [criterion 2]
   - Test [criterion 3]

## Examples
See [examples.md](examples.md) for complete implementations.

## Troubleshooting
Common issues documented in [troubleshooting.md](troubleshooting.md).
```

### Template 3: Analysis/Review Skill

```markdown
---
name: [Domain] Analyzer
description: |
  Analyze [what] for [concerns]. Use when reviewing [artifacts],
  checking [quality aspects], or validating [requirements].
  Use for "[keyword 1]", "[keyword 2]", "[keyword 3]".
version: 1.0.0
tags: [analysis, review, quality]
---

# [Domain] Analyzer

## Quick Start
Systematic analysis of [artifacts] across [dimensions]:
1. [Dimension 1]
2. [Dimension 2]
3. [Dimension 3]

## Analysis Framework

### Phase 1: [Analysis Type]
**Focus:** [What to look for]

Checklist:
- [ ] [Check 1]
- [ ] [Check 2]
- [ ] [Check 3]

### Phase 2: [Analysis Type]
**Focus:** [What to look for]

Checklist:
- [ ] [Check 1]
- [ ] [Check 2]
- [ ] [Check 3]

### Phase 3: Reporting
Output structured review:
- Summary (1-2 sentences)
- Issues by priority (Critical/High/Medium/Low)
- Code snippets with suggestions
- Risk assessment

## Examples

### Example 1: [Scenario]
[Input] → [Analysis] → [Output]

### Example 2: [Scenario]
[Input] → [Analysis] → [Output]

## Severity Definitions

**Critical:** [Definition + examples]
**High:** [Definition + examples]
**Medium:** [Definition + examples]
**Low:** [Definition + examples]
```

### Template 4: Integration Skill

```markdown
---
name: [Service] Integration
description: |
  Integrate [service/API] with proper [concerns]. Use when connecting
  to [service], setting up [features], or working with [endpoints].
  Use for "[keyword 1]", "[keyword 2]", "[keyword 3]".
version: 1.0.0
tags: [integration, api, service]
---

# [Service] Integration

## Quick Start
- Connect to [service] API
- Handle [authentication method]
- Implement [core features]

## Setup Instructions

### 1. Authentication
- Method: [OAuth/API Key/JWT]
- Environment variables: [List]
- Setup steps: [1-3 steps]

### 2. Core Operations

#### Operation 1: [Name]
Purpose: [What it does]

\`\`\`[language]
// Code example
\`\`\`

#### Operation 2: [Name]
Purpose: [What it does]

\`\`\`[language]
// Code example
\`\`\`

### 3. Error Handling
- Error code [X]: [Meaning + solution]
- Error code [Y]: [Meaning + solution]

## Best Practices
1. [Practice 1]
2. [Practice 2]
3. [Practice 3]

## Examples
See [examples.md](examples.md) for complete integration patterns.

## Security Checklist
- [ ] Never hardcode API keys
- [ ] Use environment variables
- [ ] Validate all inputs
- [ ] Handle rate limiting
- [ ] Log errors appropriately
```

## Advanced Patterns

### Pattern 1: Multi-File Skills with Scripts

**Structure:**
```
my-skill/
├── SKILL.md                 # Core instructions
├── scripts/
│   ├── preprocess.py       # Data preparation
│   └── validate.sh         # Validation logic
└── templates/
    └── config.json         # Configuration template
```

**SKILL.md references:**
```markdown
## Processing Pipeline

1. **Preprocess Data**
   Run: `python scripts/preprocess.py --input data.csv`

2. **Validate**
   Run: `bash scripts/validate.sh output/`

3. **Apply Template**
   Use: [templates/config.json](templates/config.json)
```

**Available Tools for Script Execution:**

When skills need to execute scripts or interact with the filesystem, Claude has access to these built-in tools:

- **Bash** - Execute scripts (`python scripts/preprocess.py`, `bash scripts/validate.sh`)
- **Read** - Read script files, templates, config files
- **Write** - Generate files from templates
- **Edit** - Modify existing files
- **Glob** - Find files matching patterns (`scripts/**/*.py`)
- **Grep** - Search within files for content

For comprehensive tool list, see the cc-subagent-architect skill.

### Pattern 2: Skill Dependencies

**Reference other skills:**
```markdown
---
name: Advanced ML Pipeline
description: |
  Build ML pipelines. Requires "Data Preprocessor" skill.
  Use after data is cleaned and validated.
---

# Advanced ML Pipeline

## Prerequisites
Complete these skills first:
1. [Data Preprocessor](../data-preprocessor/SKILL.md)
2. [Model Validator](../model-validator/SKILL.md)

## Instructions
[Assumes prerequisite skills completed]
```

### Pattern 3: Version Evolution

**Document version changes:**
```markdown
---
name: My Skill
version: 2.0.0
---

# My Skill

## Version History
- **v2.0.0** (2025-10-29): Breaking changes to API
  - Removed: `old_method()`
  - Added: `new_method()` with validation
  - Migration: See [migration-v2.md](migration-v2.md)
- **v1.1.0** (2025-09-15): Added feature X
- **v1.0.0** (2025-09-01): Initial release

## Migration Guides
- [v1.x → v2.x Migration](migration-v2.md)
```

### Pattern 4: Output Organization

**Timestamped Output Directories:**

When skills generate outputs, use consistent timestamp format:

```markdown
## Output Organization

1. **Create timestamped directory:**
   ```bash
   TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
   mkdir -p "outputs/${TIMESTAMP}/category"
   ```

2. **Save outputs with clear naming:**
   - outputs/2025-10-29_19-30-45/analysis/results.md
   - outputs/2025-10-29_19-30-45/reports/summary.md

3. **Benefits:**
   - Automatic versioning - never overwrite
   - Audit trail - track evolution
   - Easy comparison - diff between runs
```

**Standard Timestamp Format:**
```bash
YYYY-MM-DD_HH-MM-SS  # Example: 2025-10-29_19-30-45
```

## Skill Creation Workflow

### Step 1: Define Purpose
- **What:** Single, clear capability
- **When:** Specific triggers and use cases
- **Who:** Target users or projects

### Step 2: Design Description
Use the description template:
```yaml
description: |
  [ACTION] [WHAT]. Use for [USE CASE 1], [USE CASE 2], [USE CASE 3].
  Works with [FILE TYPES]. Use when "[TRIGGER 1]", "[TRIGGER 2]".
```

### Step 3: Structure Content
- **SKILL.md:** Core instructions only (< 10KB)
- **Supporting files:** Reference docs, examples, scripts
- **Progressive disclosure:** Link to supporting files

### Step 4: Write Instructions
- Clear, sequential steps
- Decision points documented
- Error handling included
- Examples provided

### Step 5: Test Discovery
1. Create a task that should trigger the skill
2. Verify Claude invokes it automatically
3. If not triggered: Improve description specificity

### Step 6: Iterate
- Add examples as you encounter new use cases
- Document edge cases in troubleshooting
- Update version and history

## Testing Your Skill

### Test 1: Discovery
**Verify Claude finds your skill:**
- Describe a task matching the skill's description
- Claude should invoke the skill automatically
- If not: Make description more specific with keywords

### Test 2: Instructions Clarity
**Verify Claude follows the workflow:**
- Skill should guide Claude through steps
- Decision points should be clear
- Error handling should work

### Test 3: Progressive Disclosure
**Verify supporting files load on demand:**
- SKILL.md should reference additional files
- Claude should load them only when needed
- Context usage should be minimal initially

### Test 4: Edge Cases
**Verify troubleshooting section works:**
- Try scenarios documented in troubleshooting
- Verify solutions are accurate
- Add new edge cases as discovered

## Common Pitfalls & Solutions

### Pitfall 1: Vague Description
**Problem:** Claude doesn't invoke skill when expected

**Solution:** Add specific keywords and trigger phrases
```yaml
# Before
description: Helps with data analysis

# After
description: Analyze CSV/Excel sales data for quarterly reports, forecasting, and pipeline tracking. Use when "analyze spreadsheet", "sales report", "pivot table", working with .xlsx/.csv files.
```

### Pitfall 2: SKILL.md Too Large
**Problem:** Context window fills up quickly

**Solution:** Split into multiple files
```markdown
# SKILL.md (concise)
## API Reference
For detailed specifications, see [api-reference.md](api-reference.md).

## Examples
Basic examples below. See [examples.md](examples.md) for more.
```

### Pitfall 3: Missing File Type Keywords
**Problem:** Skill not triggered for specific file types

**Solution:** Explicitly mention file extensions
```yaml
description: Process data files. Use with .csv, .xlsx, .json, .parquet files.
```

### Pitfall 4: No Clear Workflow
**Problem:** Claude doesn't know what to do

**Solution:** Provide numbered steps
```markdown
## Instructions
1. Read the input file
2. Validate data structure
3. Transform using [pattern]
4. Output to [format]
```

### Pitfall 5: No Examples
**Problem:** Abstract instructions are hard to follow

**Solution:** Always include at least one example
```markdown
## Examples
### Basic Usage
User provides: `data.csv`
Claude: Reads file → Validates → Transforms → Outputs `report.xlsx`
```

## Quick Reference Checklist

Before creating a skill, verify:

- [ ] **Purpose is clear:** Single, focused capability
- [ ] **Description is specific:** Includes WHAT + WHEN + file types + keywords
- [ ] **YAML frontmatter valid:** name, description required; version, tags optional
- [ ] **SKILL.md concise:** < 10KB, core instructions only
- [ ] **Supporting files separate:** examples.md, reference.md, scripts/
- [ ] **Progressive disclosure:** Reference supporting files from SKILL.md
- [ ] **Instructions are sequential:** Numbered steps with decision points
- [ ] **Examples provided:** At least 1-2 basic examples inline
- [ ] **Troubleshooting included:** Common issues documented
- [ ] **Scripts are idempotent:** Safe to run multiple times
- [ ] **Relative links used:** `[link](path/to/file.md)`
- [ ] **Version tracked:** Document changes in version history
- [ ] **Scope correct:** `.claude/skills/` (project) vs `~/.claude/skills/` (user)
- [ ] **Tested:** Verify Claude invokes skill automatically

## Related Skills

- **cc-mastery** - When to use skills vs. subagents vs. commands
- **cc-subagent-architect** - Creating specialized AI agents
- **cc-slash-command-builder** - Creating user-invoked commands

## References

Official Documentation:
- [Agent Skills Guide](https://docs.claude.com/en/docs/claude-code/skills)
- [Agent Skills Architecture](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)

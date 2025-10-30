# Claude Code Agent Skills: Comprehensive Reference Guide

**Author:** Verified from Anthropic Official Documentation + Community Best Practices  
**Last Updated:** October 2025  
**Status:** Single Source of Truth - Q&A Format

---

## TABLE OF CONTENTS

1. [What Are Agent Skills](#what-are-agent-skills)
2. [File Structure & Locations](#file-structure--locations)
3. [SKILL.md Format Specification](#skillmd-format-specification)
4. [Best Practices](#best-practices)
5. [Progressive Disclosure Architecture](#progressive-disclosure-architecture)
6. [Implementation Examples](#implementation-examples)
7. [Capabilities & Limitations](#capabilities--limitations)
8. [Troubleshooting & Edge Cases](#troubleshooting--edge-cases)

---

## WHAT ARE AGENT SKILLS?

### Definition
Agent Skills are modular capabilities that extend Claude's functionality through organized folders containing instructions, scripts, and resources. They are model-invoked—Claude autonomously decides when to use them based on your request and the Skill's description, which is different from slash commands that are user-invoked.

### Key Characteristics
- **Model-Controlled**: Claude decides when to invoke them based on context
- **Discoverable**: Skills are discovered via YAML metadata (name + description)
- **Composable**: Multiple skills can work together in a single task
- **Scalable**: Progressive disclosure means unbounded context potential
- **Shareable**: Can be packaged as plugins for team distribution

### When to Use Skills

Create a skill when:
- Task requires specialized knowledge or procedures
- Same workflow repeats across multiple projects
- Team needs standardized approach to domain-specific work
- Procedural steps exceed what LLM naturally remembers
- Integration with external tools or APIs is needed

---

## FILE STRUCTURE & LOCATIONS

### Directory Hierarchy

```
~/.claude/skills/                          # User-level (personal)
├── my-skill/
│   ├── SKILL.md                           # Required: metadata + instructions
│   ├── reference.md                       # Optional: detailed documentation
│   ├── examples.md                        # Optional: usage examples
│   ├── scripts/
│   │   ├── helper.py                      # Optional: executable scripts
│   │   ├── validator.sh
│   │   └── formatter.ts
│   └── templates/
│       ├── template-1.txt
│       └── template-2.json
│
.claude/skills/                             # Project-level (version controlled)
├── project-skill/
│   └── [same structure as above]
```

### Installation Locations

| Location | Scope | Use Case | Version Control |
|----------|-------|----------|-----------------|
| `~/.claude/skills/` | Global/User | Personal workflows, cross-project tools | No (in .gitignore) |
| `.claude/skills/` | Project | Team standards, project-specific domain expertise | Yes (committed to repo) |
| Plugins | Installation | Pre-packaged collection of skills | Plugin marketplace |

**Priority Resolution**: Project-level skills (`.claude/skills/`) override user-level skills (`~/.claude/skills/`) with the same name.

---

## SKILL.MD FORMAT SPECIFICATION

### Complete YAML Frontmatter Structure

```yaml
---
name: Skill Display Name
description: |
  One-line summary describing WHAT this skill does and WHEN to use it.
  Be specific: mention file types, use cases, and trigger conditions.
version: 1.0.0
tags: [category, use-case, tool]
---
```

### YAML Fields Reference

| Field | Type | Required | Rules | Example |
|-------|------|----------|-------|---------|
| `name` | String | Yes | Display name (20-50 chars recommended) | "Excel Data Analysis" |
| `description` | String | Yes | 1-3 sentences, include WHEN and WHAT | "Analyze Excel files and create pivot tables. Use when working with spreadsheets..." |
| `version` | String | No | Semantic versioning | "2.1.0" |
| `tags` | Array | No | 2-5 tags for categorization | ["excel", "data-analysis"] |

### Description Field Best Practices

**Vague (❌ Don't)**:
```yaml
description: Helpful skill for working with data
```

**Specific (✅ Do)**:
```yaml
description: Analyze Excel spreadsheets, create pivot tables, and generate charts. Use when working with .xlsx files for sales reports, pipeline analysis, or revenue tracking.
```

**Why**: Claude's discovery is keyword-based. Specific descriptions with:
- File types (.xlsx, .csv, .json)
- Use cases (reports, analysis, pipeline)
- Output types (charts, tables, summaries)

---

### Markdown Content Structure

#### Minimum Structure
```markdown
---
name: Example Skill
description: Short description
---

# Example Skill

## Instructions
1. Step-by-step guidance
2. Clear procedures
3. Expected outcomes

## Examples
### Example 1: Use case A
### Example 2: Use case B
```

#### Full Structure with Progressive Disclosure
```markdown
---
name: Full Example
description: Complete demonstration
---

# Full Example Skill

## Quick Start
- 2-3 bullet points for immediate use
- What Claude should do first

## Instructions
1. Primary workflow steps
2. Decision points
3. Error handling

## Examples
### Basic Example
Code or walkthrough

### Advanced Example
Complex scenario

## Reference
### Concepts
- Key terminology

### API Details
- Endpoint specifications
- Parameter constraints

## Troubleshooting
### Issue: X happens
Solution: Y

## Related Skills
- Link to complementary skills
```

---

## BEST PRACTICES

### 1. Description Mastery

**CRITICAL**: The description is your only chance to tell Claude when to use this skill.

```yaml
# ❌ WRONG - Too vague
description: Useful skill for analysis

# ✅ RIGHT - Specific triggers, file types, use cases
description: |
  Analyze sales data in Excel files and CRM exports. Use for sales reports,
  pipeline analysis, and revenue tracking. Works with .xlsx and .csv formats.
```

### 2. File Organization

```
my-skill/
├── SKILL.md                    # Frontmatter + core instructions only
├── detailed-guide.md           # Separate long documentation
├── examples.md                 # Practical examples (separate file)
├── api-reference.md            # Technical details (separate file)
├── scripts/
│   ├── preprocess.py          # Utility scripts
│   └── validate.sh
└── templates/
    └── boilerplate.json       # Reusable templates
```

**Why**: Progressive disclosure. SKILL.md stays concise so Claude loads it quickly. Supporting files are referenced on-demand.

### 3. Script Integration

Scripts can be:
- **Readable as documentation** (Claude reads inline)
- **Executable tools** (Claude runs with specific parameters)

```markdown
## Processing Steps

Our pipeline uses this Python script (stored in `scripts/preprocess.py`):

\`\`\`python
# scripts/preprocess.py - Can be read as reference OR executed
def validate_data(input_path):
    """Validates CSV structure"""
    # Implementation
\`\`\`

Run with: `python scripts/preprocess.py --input data.csv`
```

### 4. Reference These Files from SKILL.md

```markdown
---
name: Complete Example
description: Skill with multiple supporting files
---

# Complete Example

For detailed API documentation, see [api-reference.md](api-reference.md).

## Examples

More examples available in [examples.md](examples.md).

### Quick Example
Lorem ipsum
```

### 5. Version Tracking

Document Skill versions in your SKILL.md content to track changes over time. Add a version history section:

```markdown
---
name: My Skill
version: 2.0.0
---

## Version History
- v2.0.0 (2025-10-01): Breaking changes to API
- v1.1.0 (2025-09-15): Added new features
- v1.0.0 (2025-09-01): Initial release

## Migration Guide (v1.x → v2.x)
Old syntax: `process_data(file_path)`
New syntax: `process_data(file_path, validate=True)`
```

---

## PROGRESSIVE DISCLOSURE ARCHITECTURE

### Core Concept

Progressive disclosure is the core design principle that makes Agent Skills flexible and scalable. Like a well-organized manual that starts with a table of contents, then specific chapters, and finally a detailed appendix, skills let Claude load information only as needed.

### How It Works

```
Context Window Usage Over Skill Lifecycle
│
├─ Initial Context ────── SKILL.md metadata only
│  - name: "My Skill"
│  - description: "..."
│  - Load time: ~100 tokens
│
├─ Skill Triggered ────── SKILL.md full content loaded
│  - Instructions section
│  - Basic examples
│  - Load time: ~500-1000 tokens
│
├─ Clause Chooses ─────── Supporting files on demand
│  - Claude reads reference.md for API details
│  - Claude reads examples.md for specific case
│  - Load time: ~1000-5000 tokens per file
│
└─ Execution ──────────── Only necessary code runs
   - Scripts called with specific parameters
   - Templates instantiated for use case
```

### Implementation Strategy

```markdown
---
name: Sales Analysis
description: Analyze sales data. Use for reports, forecasting.
---

# Sales Analysis

## Quick Start
1. Upload Excel file
2. Claude automatically extracts data
3. Generates analysis

## How It Works
[3-5 paragraph explanation]

## Core Instructions
1. Read the file with...
2. Transform data using...
3. Output results as...

## Examples
See [examples.md](examples.md) for:
- Basic sales report
- Multi-quarter comparison
- Anomaly detection

## Advanced Topics
- Custom metrics (see [api-reference.md](api-reference.md))
- Performance optimization ([optimization.md](optimization.md))
- Integration patterns ([integrations.md](integrations.md))
```

---

## IMPLEMENTATION EXAMPLES

### Example 1: Excel Analysis Skill

**File**: `.claude/skills/excel-analyzer/SKILL.md`

```markdown
---
name: Excel Data Analysis
description: |
  Analyze Excel spreadsheets, create pivot tables, and generate charts.
  Use when working with .xlsx files for sales reports, pipeline analysis,
  and revenue tracking.
version: 1.2.0
tags: [excel, data-analysis, reporting]
---

# Excel Data Analysis Skill

## Instructions

1. **Read the File**
   - Accept .xlsx files from user
   - Use `openpyxl` or `pandas` to read sheets
   - Identify data structure (headers, types)

2. **Transform Data**
   - Clean data (remove nulls, standardize formats)
   - Create pivot tables for aggregation
   - Calculate KPIs (sum, average, percentage change)

3. **Visualize**
   - Generate charts (bar, line, pie)
   - Include trend analysis
   - Highlight anomalies (>10% variance)

4. **Output**
   - Create new workbook with results
   - Include methodology as sheet notes
   - Save with timestamp: `analysis_YYYY-MM-DD.xlsx`

## Examples

### Sales Pipeline Analysis
User provides: `sales_data_q4.xlsx`
Claude: Reads sheet → Groups by stage → Creates pivot → Charts → Saves results

### Revenue Forecast
User provides: `historical_revenue.xlsx`
Claude: Calculates trend → Projects next 12 months → Highlights risks

## Troubleshooting

### Issue: "Pivot table format not recognized"
Solution: Ensure headers are in row 1, no merged cells above data

### Issue: "Chart generation fails"
Solution: Verify numeric columns contain only numbers, no text
```

---

### Example 2: Code Review Skill

**File**: `.claude/skills/code-reviewer/SKILL.md`

```markdown
---
name: Code Reviewer
description: |
  Review code for best practices, security, and performance issues.
  Use when reviewing pull requests, analyzing code quality, or checking
  for vulnerabilities in TypeScript/JavaScript codebases.
version: 1.0.0
tags: [code-review, security, typescript]
---

# Code Reviewer Skill

## Instructions

### Phase 1: Analysis
1. Read all changed files in context
2. Map dependencies and data flow
3. Identify business logic correctness

### Phase 2: Review Priorities (in order)
1. **Logic errors** that could cause failures
2. **Security vulnerabilities** (SQL injection, XSS, auth)
3. **Performance problems** (N+1 queries, inefficient loops)
4. **Maintainability** (code clarity, DRY principle)
5. **Style** (linting, naming conventions)

### Phase 3: Reporting
Output structured review:
- Summary (1-2 sentences)
- Issues by priority
- Code snippets with suggestions
- Risk level (critical/high/medium/low)

## Examples

See [examples.md](examples.md) for review patterns:
- React component review
- API endpoint review
- Database migration review

## Security Checklist

Always verify:
- [ ] No hardcoded secrets
- [ ] SQL queries use parameterized statements
- [ ] API endpoints have auth checks
- [ ] Input validation on all endpoints
- [ ] CORS properly configured
```

---

### Example 3: Documentation Generator Skill

**File**: `.claude/skills/doc-generator/SKILL.md`

```markdown
---
name: Documentation Generator
description: |
  Generate comprehensive API documentation, README files, and guides.
  Use when documenting new features, creating developer guides, or
  standardizing project documentation.
version: 1.1.0
tags: [documentation, api-docs, guides]
---

# Documentation Generator

## Instructions

1. **Understand Context**
   - Read source code
   - Identify exports, types, functions
   - Extract comments and docstrings

2. **Generate Structure**
   - Table of contents
   - Quick start section
   - API reference (grouped by category)
   - Examples section
   - Troubleshooting

3. **Fill Content**
   - Parameter descriptions (type + constraint + default)
   - Return values with examples
   - Usage examples (basic → advanced)
   - Common errors and solutions

## Templates

Use templates from `templates/` directory:
- `api-endpoint.md` - REST endpoints
- `function-reference.md` - Function documentation
- `getting-started.md` - Onboarding guides

Reference with: `[See template](templates/api-endpoint.md)`

## Output Format

All documentation uses:
- Markdown syntax
- Code blocks with language tags
- Consistent heading hierarchy (h1 → h6)
- Inline code for variables/function names
```

---

## CAPABILITIES & LIMITATIONS

### ✅ WHAT SKILLS CAN DO

1. **Package Expertise**
   - Domain knowledge (procedures, best practices)
   - Integration patterns (step-by-step workflows)
   - Organizational context (standards, conventions)

2. **Execute Code**
   - Scripts (.py, .sh, .js) can be run by Claude
   - Generate code based on templates
   - Parse and transform data

3. **Progressive Context Loading**
   - Main instructions stay concise
   - Supporting files loaded on-demand
   - Theoretically unbounded capability size

4. **Team Standardization**
   - Share via `.claude/skills/` in version control
   - Consistent approach across developers
   - Update once, all projects inherit changes

### ❌ WHAT SKILLS CANNOT DO

1. **Make System-Wide Decisions**
   - Skills don't override core Claude Code behavior
   - Can't modify hooks, commands, or settings system-wide
   - CLAUDE.md is separate (not part of skills)

2. **Trigger Automatically (No Way Currently)**
   - Skills are model-invoked—Claude autonomously decides when to use them based on your request and the Skill's description.
   - Cannot force Claude to use a skill
   - Must mention or imply need in prompt

3. **Maintain State Across Sessions**
   - Each session is independent
   - No persistent session memory
   - Use version control for tracking changes

4. **Access External APIs Directly**
   - Must use MCP servers for external services
   - Can execute local scripts that call APIs
   - Cannot make outbound network requests natively

---

## TROUBLESHOOTING & EDGE CASES

### Q: Claude isn't using my skill even though it's relevant

**A**: Check description specificity.

```yaml
# ❌ WRONG
description: Helpful skill for data

# ✅ RIGHT
description: Process CSV sales data with > 10k rows. Use for quarterly analysis, territory mapping, forecasting.
```

Check: Is the description specific enough? Vague descriptions make discovery difficult.

---

### Q: Can I have multiple skills with similar names?

**A**: Yes, but provide specific descriptions to avoid confusion.

```
.claude/skills/
├── data-analyzer/          # Generic data analysis
├── excel-analyzer/         # Specific: Excel files only
└── csv-processor/          # Specific: CSV processing
```

Each has different description to trigger appropriately.

---

### Q: How large can SKILL.md be?

**A**: No hard limit, but practical recommendations:

| SKILL.md Size | Action |
|---------------|--------|
| < 2KB | Ideal. Always loads completely |
| 2-10KB | Good. Typical for most skills |
| 10-50KB | Consider splitting into files |
| > 50KB | **Definitely split** reference/examples/api docs into separate files |

**Progressive Disclosure Rule**: If content isn't immediately needed, move to separate file and reference it.

---

### Q: Can I use the same skill across Vue3 + Astro + Node projects?

**A**: Yes, store in `~/.claude/skills/` for user-level access.

```
~/.claude/skills/vue-patterns/         # Available to all projects
~/.claude/skills/typescript-testing/   # Available to all projects

# Inside project:
.claude/skills/project-specific/       # Only for this project
```

Project-level `.claude/skills/` overrides user-level with same name.

---

### Q: How do I handle different versions of a tool/framework?

**A**: Include version checks in skill or create separate skills.

```markdown
---
name: Vue Components (Vue 3)
description: |
  Build Vue 3 components with Composition API.
  Use for Vue 3+ projects. (Vue 2 version: see vue-2-components skill)
---
```

Or with version detection:

```markdown
## Compatibility

This skill requires:
- Vue 3.0+ (Composition API)
- TypeScript 4.7+
- Node 16+

For Vue 2, use the [vue-2-components](../vue-2-components/SKILL.md) skill.
```

---

### Q: Can I have Claude execute a Python script inside a skill?

**A**: Yes. Store in `scripts/` and call from instructions.

```markdown
## Data Processing

Run the preprocessing script:
\`\`\`bash
python scripts/preprocess.py --input data.csv --output cleaned.csv
\`\`\`

Script location: [scripts/preprocess.py](scripts/preprocess.py)
```

Claude will execute when appropriate. Make scripts idempotent (safe to run multiple times).

---

### Q: Should I version-control `.claude/skills/`?

**A**: **YES** for `.claude/skills/`, **NO** for `~/.claude/skills/`

```bash
# Project
.claude/skills/                    # ✅ Commit to git
  my-skill/
  └── SKILL.md

# User
~/.claude/skills/                  # ❌ Don't commit
  my-personal-skill/
  └── SKILL.md
```

This ensures team consistency.

---

### Q: How do I handle skill dependencies (skill A requires skill B)?

**A**: Reference in description and use cross-links:

```markdown
---
name: Advanced ML Pipeline
description: |
  Build ML pipelines. Requires "Data Preprocessor" skill.
  Use after data is cleaned and validated.
---

# Advanced ML Pipeline

## Prerequisites
- Complete "Data Preprocessor" skill first
  (See [../data-preprocessor/SKILL.md](../data-preprocessor/SKILL.md))

## Instructions
```

Claude will infer the dependency chain.

---

### Q: Edge Case: Skill throws error but I need to continue

**A**: Add error handling to your scripts:

```python
# scripts/processor.py
try:
    result = process_data(input_file)
    print(json.dumps({"success": True, "result": result}))
except Exception as e:
    print(json.dumps({"success": False, "error": str(e), "fallback": "manual_processing"}))
    sys.exit(0)  # Exit 0 so Claude can handle gracefully
```

In skill, document fallback:

```markdown
## Error Handling

If automated processing fails:
1. Claude will notify you with error details
2. Manual processing steps provided below
3. Can retry or skip to next phase
```

---

## QUICK REFERENCE CHECKLIST

- [ ] SKILL.md has specific description (includes WHAT + WHEN + file types)
- [ ] YAML frontmatter is valid (name, description required)
- [ ] Supporting files are separate (.md files in root, scripts/ folder)
- [ ] Each supporting file is referenced from SKILL.md
- [ ] File paths use relative linking (`[link](path/to/file.md)`)
- [ ] SKILL.md stays under 10KB (move long content to separate files)
- [ ] Scripts are idempotent (safe to run multiple times)
- [ ] Version tracking documented in SKILL.md
- [ ] `.claude/skills/` is committed to git (not `~/.claude/skills/`)
- [ ] Tested with Claude Code to verify discovery

---

## RELATED RESOURCES

- Official Agent Skills Documentation: https://docs.claude.com/en/docs/claude-code/skills
- Agent Skills Architecture Deep Dive: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- Awesome Claude Code Repository: https://github.com/hesreallyhim/awesome-claude-code

# Claude Code Output Styles: Comprehensive Reference Guide

**Author:** Verified from Anthropic Official Documentation + Community Best Practices  
**Last Updated:** October 2025  
**Status:** Single Source of Truth - Complete Reference with Examples

---

## TABLE OF CONTENTS

1. [What Are Output Styles](#what-are-output-styles)
2. [File Locations & Scope](#file-locations--scope)
3. [YAML Frontmatter Specification](#yaml-frontmatter-specification)
4. [Markdown Content Structure](#markdown-content-structure)
5. [Built-In Output Styles](#built-in-output-styles)
6. [Creating Custom Styles](#creating-custom-styles)
7. [Style Examples by Domain](#style-examples-by-domain)
8. [Best Practices](#best-practices)
9. [Troubleshooting & Edge Cases](#troubleshooting--edge-cases)

---

## WHAT ARE OUTPUT STYLES?

### Definition

Output Styles are markdown files with YAML frontmatter that completely replace Claude Code's system prompt. They allow you to transform Claude into any type of agent while preserving its core capabilities (file operations, script execution, command running).

### Key Characteristics

- **System Prompt Override**: Replaces the default software engineering prompt
- **Capability Preservation**: Keeps all Claude Code tools (Bash, Edit, Write, Notebook)
- **Domain Transformation**: Adapt Claude for any domain beyond coding
- **Easy Switching**: Use `/output-style` to switch between styles
- **Composable**: Use with hooks, commands, skills, MCP servers

### What Stays (✅) / What Changes (❌)

| Component | Stays | Notes |
|-----------|-------|-------|
| File system operations | ✅ | Can read, write, edit files |
| Bash command execution | ✅ | Full shell access |
| Script execution | ✅ | Can run Python, Node, etc. |
| CLAUDE.md context | ✅ | Project guidelines still loaded |
| Slash commands | ✅ | /compact, /help, etc. still work |
| Subagents | ✅ | Can delegate to agents |
| MCP servers | ✅ | External integrations work |
| **System personality** | ❌ | Completely replaced |
| **Domain assumptions** | ❌ | No longer assumes coding |
| **Task priorities** | ❌ | Different reasoning patterns |
| **Response format** | ❌ | Customizable per style |

---

## FILE LOCATIONS & SCOPE

### Directory Hierarchy

```
Global User-Level:
~/.claude/output-styles/
├── explanatory.md                # Built-in (always available)
├── learning.md                   # Built-in (always available)
├── my-research-style.md          # Custom global style
└── brand-voice.md                # Custom global style

Project-Level (Committed to Git):
.claude/output-styles/
├── internal-audit.md             # Project-specific
└── client-facing-style.md        # Project-specific
```

### File Resolution Priority

```
Priority (highest to lowest):
1. .claude/output-styles/custom-style.md    (Project override)
2. ~/.claude/output-styles/custom-style.md  (User global)
3. Built-in styles (default, explanatory, learning)
```

If same style name exists at both levels, project-level wins.

### Setup (macOS 2019 Mac Pro)

```bash
# Create global style directory
mkdir -p ~/.claude/output-styles

# Create project style directory
mkdir -p .claude/output-styles

# Add to .gitignore (don't commit global settings)
echo "~/.claude/" >> ~/.gitignore

# Add to .gitignore (commit project styles)
# .claude/output-styles/ should NOT be in .gitignore
```

---

## YAML FRONTMATTER SPECIFICATION

### Minimal Structure

```yaml
---
name: Style Display Name
description: Brief description shown in /output-style menu
---
```

### Complete Structure

```yaml
---
name: Detailed Audit Style
description: >-
  Analyze systems with focus on risk, compliance, and operational impact.
  Provides detailed findings in structured format.
version: 1.0.0
tags: [audit, analysis, compliance]
keywords: [risk, governance, controls]
---
```

### YAML Fields Reference

| Field | Type | Required | Rules | Example |
|-------|------|----------|-------|---------|
| `name` | String | Yes | Display name shown in menu (20-50 chars) | "Content Researcher" |
| `description` | String | Yes | 1-3 sentences, explain personality | "Research and analyze topics systematically" |
| `version` | String | No | Semantic versioning for tracking | "2.1.0" |
| `tags` | Array | No | 2-5 category tags | ["research", "analysis"] |
| `keywords` | Array | No | Search keywords | ["investigation", "deep-dive"] |

### Best Practices for Fields

**Name** (20-50 chars):
```yaml
# ❌ Too vague
name: Style

# ❌ Too long
name: A Very Comprehensive Style For Analyzing Things Deeply

# ✅ Just right
name: Performance Analyst
```

**Description** (1-3 sentences, explain HOW Claude should behave):
```yaml
# ❌ Too vague
description: A helpful style

# ✅ Specific behavior description
description: >-
  Analyze code for performance bottlenecks. Estimate complexity,
  identify N+1 queries, suggest data structure improvements.
  Provide metrics and prioritized recommendations.
```

---

## MARKDOWN CONTENT STRUCTURE

### Minimal Style

```markdown
---
name: My Style
description: Custom personality
---

# My Style Instructions

You are a specialized assistant focused on:
- Primary goal 1
- Primary goal 2

## Communication Style
- Tone: [specify tone]
- Verbosity: [concise/detailed]

## Key Behaviors
1. Behavior 1
2. Behavior 2
```

### Complete Style with All Sections

```markdown
---
name: Content Strategist
description: >-
  Help users develop content strategy, analyze audience,
  optimize messaging. Maintain brand voice consistency.
---

# Content Strategist

## Core Purpose
You are a content strategy expert who helps teams...

## Personality & Tone
- Professional but approachable
- Data-driven recommendations
- Brand-aligned in all communications

## Key Responsibilities

### 1. Content Planning
- Analyze target audience
- Define content pillars
- Create editorial calendar

### 2. Audience Analysis
- Segment user demographics
- Identify pain points
- Map content needs

### 3. Optimization
- Review engagement metrics
- Suggest improvements
- Test messaging variations

## Communication Protocol

### When responding:
1. Start with executive summary (1-2 sentences)
2. Provide structured analysis
3. Include data-driven insights
4. Suggest 2-3 actionable next steps
5. Ask clarifying questions if needed

### Tools You Have:
- Can create and edit files (README, strategy docs)
- Can run scripts to analyze data
- Can organize information into templates
- Cannot publish content (user must review first)

## Decision-Making Framework

When making recommendations, consider:
- **Impact**: How much will this improve engagement?
- **Effort**: How much work is required?
- **Brand fit**: Does this align with brand values?
- **Audience**: Does this resonate with target users?

## Constraints & Guidelines

- Never compromise brand voice for engagement
- Always prioritize quality over quantity
- Include data sources for all recommendations
- Suggest testing before full rollout

## Example Workflow

User provides: "We need more traffic to our blog"

Your process:
1. Ask about current metrics
2. Analyze content gaps
3. Recommend 3 strategic topics
4. Provide outline templates
5. Set success metrics
```

### Advanced: Interactive Elements

```markdown
---
name: Interactive Tutor
description: Educational interactive style for learning
---

# Interactive Tutor

## How You Help

You guide learning through:
- Questions before explanations
- Scaffolded complexity
- Interactive exercises
- Immediate feedback

## Teaching Protocol

### Phase 1: Assessment
Ask questions to understand current knowledge level:
- "What do you already know about [topic]?"
- "Have you encountered [concept] before?"

### Phase 2: Explanation
Provide explanation matched to knowledge level:
- Beginners: Analogies, simple examples
- Intermediate: Technical details, common patterns
- Advanced: Edge cases, optimization techniques

### Phase 3: Practice
Provide hands-on exercise:
\`\`\`
Here's a challenge:
[Small implementation task]

Try it, and I'll review your solution.
\`\`\`

### Phase 4: Feedback
Specific, actionable feedback:
- What you did well
- One area to improve
- How to improve it
- Next challenge or topic
```

---

## BUILT-IN OUTPUT STYLES

### 1. Default

**Location**: Built-in (always available)  
**Purpose**: Production-focused software engineering  
**Characteristics**:
- Concise, efficient responses
- Assumes coding knowledge
- Focuses on implementation speed
- Minimal explanation

**When to use**: You want Claude to move fast and generate code efficiently.

---

### 2. Explanatory

**Location**: Built-in (always available)  
**Purpose**: Educational, teaching-focused  
**Characteristics**:
- Provides "Insights" blocks explaining reasoning
- Shows design choices and trade-offs
- Explains why certain patterns were chosen
- References codebase conventions

**When to use**: Onboarding to new codebase, learning architecture, generating documentation.

**Example output**:
```
[Code generation...]

★ Insight ───────────────────────────────────
Using Composition API here because the component
has complex reactive state. This is more readable
than Options API for this use case.
───────────────────────────────────────────────
```

---

### 3. Learning

**Location**: Built-in (always available)  
**Purpose**: Pair-programming with human participation  
**Characteristics**:
- Scaffolds code with `TODO(human)` markers
- Asks you to implement specific pieces
- Explains expected implementation
- Guides without doing everything

**When to use**: Onboarding junior developers, learning new language/framework, collaborative development.

**Example output**:
```
// Create the authentication hook
export function useAuth() {
  const [user, setUser] = useState(null);
  
  // TODO(human): Implement fetchUser function
  // Should:
  // 1. Call /api/user endpoint
  // 2. Handle loading state
  // 3. Return user data or null
  const fetchUser = async () => {
    // Your implementation here
  };
  
  useEffect(() => {
    fetchUser();
  }, []);
  
  return { user, loading: !user };
}
```

---

## CREATING CUSTOM STYLES

### Method 1: Interactive Creation

```bash
# Inside Claude Code terminal
/output-style:new

# Then describe what you want:
# "I want an output style that analyzes code for security vulnerabilities..."
```

Claude will:
1. Ask clarifying questions
2. Generate `.claude/output-styles/[name].md`
3. Save to `~/.claude/output-styles/` (user level)
4. Available immediately in `/output-style` menu

---

### Method 2: Manual File Creation

**Step 1**: Create file at `~/.claude/output-styles/my-style.md`

```bash
touch ~/.claude/output-styles/my-style.md
```

**Step 2**: Add YAML frontmatter + content

```markdown
---
name: My Custom Style
description: What this style does
---

# My Custom Style

## Your custom instructions here...
```

**Step 3**: Use it

```bash
# In Claude Code
/output-style my-style
# Or use /output-style menu to select
```

---

### Method 3: Project-Level (Team Standard)

**Step 1**: Create in `.claude/output-styles/`

```bash
mkdir -p .claude/output-styles
touch .claude/output-styles/audit-style.md
```

**Step 2**: Commit to git

```bash
git add .claude/output-styles/
git commit -m "Add audit output style for team"
```

**Step 3**: Team members use it

```bash
/output-style audit-style
```

---

## STYLE EXAMPLES BY DOMAIN

### Example 1: Security Auditor

**File**: `~/.claude/output-styles/security-auditor.md`

```markdown
---
name: Security Auditor
description: >-
  Analyze systems for security vulnerabilities, misconfigurations,
  and compliance gaps. Provide risk ratings and remediation steps.
version: 1.0.0
tags: [security, audit, compliance]
---

# Security Auditor

## Your Role

You are a security expert who identifies vulnerabilities and risks
in code, configurations, and systems. Your goal is to find issues
before they reach production.

## Analysis Methodology

### 1. Reconnaissance
- Read all configuration files
- Identify dependencies and versions
- Map data flow
- List authentication mechanisms

### 2. Threat Modeling
- Identify potential attack vectors
- Consider OWASP Top 10
- Think like an attacker

### 3. Vulnerability Assessment
- Scan for common patterns
- Check for hardcoded secrets
- Verify input validation
- Review authentication/authorization

### 4. Risk Rating
For each finding, provide:
- **Severity**: Critical | High | Medium | Low
- **Type**: (e.g., SQL Injection, XSS, Weak Auth)
- **CVSS Score**: If applicable
- **Impact**: What could attacker do?
- **Remediation**: How to fix

## Output Format

Always structure findings as:

\`\`\`
# Security Audit Report

## Summary
- Total issues: X
- Critical: X | High: X | Medium: X | Low: X

## Findings

### Finding 1: [Type]
- **Severity**: [CRITICAL|HIGH|MEDIUM|LOW]
- **Location**: [file:line]
- **Description**: [what's wrong]
- **Remediation**: [how to fix]
- **References**: [OWASP/CWE links]

...

## Recommendations
1. Priority action items
2. Long-term security improvements
3. Tools to add to pipeline
\`\`\`

## Key Behaviors

- Always err on side of caution
- Explain technical details clearly
- Provide code examples for fixes
- Consider both present & future risks
- Prioritize Critical/High issues first
```

---

### Example 2: Content Strategist

**File**: `~/.claude/output-styles/content-strategist.md`

```markdown
---
name: Content Strategist
description: >-
  Develop content strategy, analyze audience, optimize messaging,
  and maintain brand voice. Provide data-driven recommendations.
---

# Content Strategist

## Your Expertise

You help teams develop effective content strategies that:
- Resonate with target audience
- Align with brand voice
- Drive business outcomes
- Adapt to platform constraints

## Strategic Framework

### Audience Analysis
- Demographics and psychographics
- Pain points and needs
- Preferred content formats
- Consumption patterns

### Content Pillars
- 3-5 core themes
- How they align with business goals
- How they serve audience

### Editorial Calendar
- Publishing schedule
- Content mix (formats, topics)
- Cross-channel distribution

## Communication Style

- Data-driven (include metrics)
- Strategic (connect to business goals)
- Actionable (specific next steps)
- Empathetic (understand audience)

## Output Format

When creating strategy docs:

1. **Executive Summary** (2-3 sentences)
2. **Audience Insights** (demographics, needs, preferences)
3. **Content Pillars** (3-5 core themes with rationale)
4. **Topics & Ideas** (10-15 specific content ideas)
5. **Calendar** (3-month editorial calendar)
6. **Distribution Strategy** (where to publish, promotion)
7. **Metrics & KPIs** (how to measure success)
8. **Next Steps** (immediate actions)

## Guidelines

- Always include competitor analysis
- Suggest 2-3 content formats per pillar
- Propose testing approach for new ideas
- Track performance metrics
- Recommend optimization based on data
```

---

### Example 3: Data Analyst

**File**: `~/.claude/output-styles/data-analyst.md`

```markdown
---
name: Data Analyst
description: >-
  Analyze datasets, identify trends, create visualizations,
  and provide statistical insights with business implications.
---

# Data Analyst

## Your Role

You analyze data to:
- Identify trends and patterns
- Quantify business impact
- Provide statistical confidence
- Recommend data-driven actions

## Analysis Process

### 1. Data Exploration
- Load and inspect data
- Summarize key statistics
- Identify missing values
- Check data types and distributions

### 2. Exploratory Analysis
- Calculate summary metrics
- Create initial visualizations
- Identify outliers
- Find correlations

### 3. Statistical Analysis
- Run hypothesis tests when appropriate
- Calculate confidence intervals
- Provide p-values and effect sizes
- Explain statistical significance

### 4. Business Translation
- Connect findings to business impact
- Quantify financial implications
- Prioritize insights by impact
- Recommend actions

## Output Format

### Report Structure

\`\`\`
# Data Analysis Report

## Executive Summary
- Key finding 1 (with number)
- Key finding 2 (with number)
- Recommended action

## Data Overview
- Dataset size: X rows, Y columns
- Time period: [dates]
- Key metrics: [list with ranges]

## Detailed Findings

### Finding 1: [Title]
- Metric: [value ± confidence interval]
- Significance: [statistical test results]
- Business Impact: [$X or X% change]
- Supporting visualization: [chart description]

...

## Visualizations
- [Chart descriptions with interpretations]

## Recommendations
1. Action with highest impact
2. Action with highest confidence
3. Suggested next analysis

## Methodology
- Data cleaning steps taken
- Statistical tests used
- Assumptions made
\`\`\`

## Data Tools Available

- Python for analysis
- Can create visualizations
- Can export to CSV, JSON
- Can create pivot tables
- Can write SQL queries

## Communication Guidelines

- Always include confidence intervals
- Explain statistical terms in business language
- Highlight most important findings
- Question outliers and anomalies
- Consider alternative explanations
```

---

### Example 4: Research Analyst

**File**: `~/.claude/output-styles/research-analyst.md`

```markdown
---
name: Research Analyst
description: >-
  Conduct comprehensive research on topics, synthesize information
  from multiple sources, identify patterns, provide evidence-based
  conclusions and recommendations.
---

# Research Analyst

## Your Approach

You conduct rigorous research by:
- Systematically exploring topics
- Consulting multiple sources
- Synthesizing information
- Acknowledging limitations
- Drawing evidence-based conclusions

## Research Methodology

### Phase 1: Question Clarification
- Understand research goal
- Identify key dimensions
- Define scope boundaries

### Phase 2: Information Gathering
- Research multiple sources
- Look for primary vs secondary sources
- Check publication dates and credibility
- Note contradictions

### Phase 3: Analysis & Synthesis
- Identify patterns across sources
- Categorize findings
- Evaluate strength of evidence
- Note areas of disagreement

### Phase 4: Conclusion & Recommendations
- Summarize key findings
- Rate confidence level for each conclusion
- Suggest areas for deeper research
- Provide actionable recommendations

## Output Format

\`\`\`markdown
# Research Report: [Topic]

## Executive Summary
- Core finding 1
- Core finding 2
- Recommended next step

## Research Question
[What we investigated]

## Methodology
- Sources consulted (types and count)
- Scope and limitations
- Time period covered

## Key Findings

### Category 1: [Finding Title]
- Main points with evidence
- Sources: [citations]
- Confidence level: [High|Medium|Low]

### Category 2: [Finding Title]
[Same structure]

## Contradictions & Debates
[Where sources disagree, explain different perspectives]

## Gaps & Limitations
- What we don't know
- Where evidence is weak
- Recommended future research

## Conclusions
[Evidence-based conclusions, rated by confidence]

## Recommendations
1. Most impactful action with rationale
2. Secondary action
3. Areas for further investigation

## Sources
[Full citation list]
\`\`\`

## Research Standards

- Cite sources explicitly
- Distinguish fact from opinion
- Acknowledge uncertainty
- Separate findings from interpretation
- Consider multiple perspectives
- Note publication dates
- Evaluate source credibility
```

---

## BEST PRACTICES

### 1. System Prompt Design

**DO**:
```markdown
---
name: Good Style
description: Analyze code for performance bottlenecks
---

# Performance Analyzer

## Your Goal
Identify performance issues in code...

## How You Work
1. Measure complexity
2. Identify patterns
3. Suggest improvements
```

**DON'T**:
```markdown
---
name: Bad Style
description: helpful style
---

You help with things...
```

### 2. Maintain Core Capabilities

Good style keeps Claude capable of:
```markdown
## Tools You Have
- Read/write files in project
- Run bash commands
- Execute Python/Node scripts
- Use npm/pip packages
- Access project files

## Limitations
- Can't access external APIs (unless via script)
- Can't see outside project directory
- Can't access system files outside project
```

### 3. Clear Communication Protocols

```markdown
## When You Respond

### Always Include
1. Summary of what you did
2. Key findings or results
3. Recommended next steps

### Formatting
- Use markdown for readability
- Code blocks for commands/output
- Bullet lists for multiple items
- Clear headings for organization
```

### 4. Explicit Decision-Making

```markdown
## Decision Framework

When deciding between options, consider:
1. Impact (how much benefit?)
2. Effort (how much work?)
3. Risk (what could go wrong?)
4. Timeline (how urgent?)

Rate each 1-5, multiply by importance weight.
```

---

## TROUBLESHOOTING & EDGE CASES

### Q: Style isn't showing in /output-style menu

**A**: Check file location and format.

```bash
# Verify file exists and location
ls ~/.claude/output-styles/your-style.md
ls .claude/output-styles/your-style.md

# Verify YAML is valid
head -10 ~/.claude/output-styles/your-style.md
# Should show:
# ---
# name: Your Name
# description: Description
# ---
```

**Common issues**:
- File in wrong directory
- YAML missing or malformed
- File not saved (if editing in IDE)
- Name/description missing

---

### Q: Style switches but Claude behavior doesn't change

**A**: Restart Claude Code session.

```bash
# Exit Claude Code
exit

# Start new session
claude

# Select style with /output-style
```

**Why**: System prompt is loaded at session start.

---

### Q: Does CLAUDE.md still work with output styles?

**A**: **YES**. CLAUDE.md is always loaded as a user message, separate from system prompt.

```
With output styles:
├─ System Prompt: Custom style (from .md file)
├─ Context: CLAUDE.md (project guidelines)
└─ Conversation: Your prompts
```

This means:
- Output style defines personality
- CLAUDE.md provides project context
- Both work together

---

### Q: Can I combine output styles with hooks?

**A**: **YES**. They're independent systems.

```
Output Styles: How Claude thinks and communicates
Hooks: What Claude MUST do at certain points
```

Example:
```
- Output Style: "Security Auditor" (personality)
- Hook: Block .env edits (enforcement)
- Together: Security auditor who can't edit secrets
```

---

### Q: How large can an output style file be?

**A**: Practical recommendations:

| File Size | Recommendation |
|-----------|-----------------|
| < 5KB | Ideal (loads quickly) |
| 5-20KB | Good (typical range) |
| 20-50KB | Consider splitting |
| > 50KB | Definitely split |

If style is very long:
1. Create main `.md` with core personality
2. Reference external `.md` files for details:
   ```markdown
   ## Detailed Methodology
   See [methodology.md](methodology.md)
   ```

---

### Q: Edge case - Style persists after switching back to Default

**A**: File saved to `.claude/settings.local.json`.

```bash
# View current setting
cat .claude/settings.local.json

# Reset to default
/output-style default

# Or manually edit file:
echo '{}' > .claude/settings.local.json
```

---

### Q: Can I use output styles across Vue3/Astro/Node projects?

**A**: **YES**. Store in `~/.claude/output-styles/` for global access.

```
Global:
~/.claude/output-styles/security-auditor.md    # Available everywhere

Project-level:
.claude/output-styles/vue-specific.md          # Only for Vue project
.claude/output-styles/node-specific.md         # Only for Node project
```

---

### Q: How do I share output styles with team?

**A**: Commit to `.claude/output-styles/` in git.

```bash
# Add to repo
mkdir -p .claude/output-styles
cp ~/.claude/output-styles/team-standard.md .claude/output-styles/

# Commit
git add .claude/output-styles/
git commit -m "Add team output style: security auditor"

# Team member pulls and uses
git pull
/output-style team-standard
```

**Note**: Project-level styles override user-level, so team standard takes priority.

---

### Q: Edge case - Style causes Claude to avoid using tools

**A**: System prompt might be discouraging tool use.

```markdown
# ❌ BAD - Discourages tools
# Don't modify files unless absolutely necessary
# Prefer to just give recommendations

# ✅ GOOD - Encourages tools
## Tools You Have
- Read/write files freely
- Run analysis scripts
- Execute commands

## When to Use Them
- Always read before modifying
- Create analysis reports as files
- Run scripts to validate recommendations
```

---

### Q: Can I have multiple versions of a style?

**A**: Yes, create separate files.

```bash
~/.claude/output-styles/
├── security-auditor-v1.md
├── security-auditor-v2-strict.md    # Stricter version
└── security-auditor-v2-relaxed.md   # More permissive

# Use:
/output-style security-auditor-v2-strict
```

Or use version in file:

```yaml
---
name: Security Auditor v2 (Strict)
description: More aggressive security scanning
version: 2.0.0-strict
---
```

---

## QUICK CONFIGURATION CHECKLIST

- [ ] YAML frontmatter has `name` and `description`
- [ ] YAML syntax is valid (test with `head -10 file.md`)
- [ ] File saved in correct location (`~/.claude/output-styles/` or `.claude/output-styles/`)
- [ ] Filename uses lowercase with hyphens (`my-style.md`)
- [ ] System prompt is clear and specific
- [ ] Style preserves Claude Code capabilities (file, bash, script access)
- [ ] Communication protocol is documented (how Claude should respond)
- [ ] Tested by switching with `/output-style [name]`
- [ ] Decision-making framework is explicit if needed
- [ ] Project-level styles are committed to git

---

## STYLE SWITCHING REFERENCE

```bash
# See available styles (includes built-in + custom)
/output-style

# Switch directly
/output-style explanatory
/output-style learning
/output-style default

# Switch to custom
/output-style my-style
/output-style security-auditor

# Switch to project style
/output-style team-standard

# Switch back to default
/output-style default
```

---

## RELATED RESOURCES

- Official Output Styles Documentation: https://docs.claude.com/en/docs/claude-code/output-styles
- Awesome Claude Code Repository: https://github.com/hesreallyhim/awesome-claude-code
- ccoutputstyles CLI tool: https://github.com/viveknair/ccoutputstyles
- ClaudeLog Output Styles Guide: https://claudelog.com/mechanics/output-styles/

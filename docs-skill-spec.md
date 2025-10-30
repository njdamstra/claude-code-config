# Docs Skill Specification

## Skill Structure

```
docs/
├── SKILL.md                    # Main skill definition (this document becomes that)
├── resources/
│   ├── orchestration.md        # Detailed multi-agent patterns
│   ├── doc-template.md         # Standard documentation template
│   └── subagent-prompts.md     # Reusable subagent instruction templates
├── templates/
│   ├── topic-metadata.json     # Metadata structure for each topic
│   └── verification-report.md  # Verification output template
└── scripts/
    ├── file_discovery.sh       # Helper for finding relevant files
    └── dependency_mapper.py    # Dependency graph generation
```

## SKILL.md Content

---
name: codebase-documentation
description: Research and document codebase topics comprehensively. Use when user requests documenting features, components, workflows, or systems. Triggers include "document", "create docs for", "/docs new", "research and document". Suitable for Vue3, Astro, TypeScript, Appwrite, nanostore projects.
---

# Codebase Documentation Skill

## Overview

This skill enables comprehensive, accurate documentation of codebase topics through systematic multi-agent research. It orchestrates parallel discovery, deep analysis, synthesis, and verification to create thorough documentation that captures architecture, patterns, dependencies, and implementation details.

**Target Stack:** Vue3, Astro, TypeScript, nanostore, Appwrite, Tailwind CSS v4, headless-ui/vue, floating-ui/vue, shadcn-ui/vue

**Output Location:** `.claude/brains/<topic-name>/`

## When to Use This Skill

Invoke this skill when:
- User says "document [topic]" or "create docs for [feature]"
- User requests "/docs new [topic]"
- User asks to "research and document" a codebase area
- User wants comprehensive documentation of a workflow, component, or system

## Core Actions

### Primary: `new` - Create New Documentation

**Input Requirements:**
- `topic-name`: Identifier for the documentation topic (e.g., "animations", "onboarding", "api-integration")
- `description`: Detailed explanation of what to document
- `flags`: `--frontend`, `--backend`, or `--both` (defaults to `--frontend`)

**Quality Commitment:**
This action prioritizes **accuracy and thoroughness over speed**. It will consume significant tokens and time to ensure complete, verified documentation. Expect 15-20 subagent invocations for complex topics.

**Output:**
- Comprehensive markdown documentation in `.claude/brains/<topic-name>/main.md`
- Metadata file with analysis details
- Empty `archives/` directory for future updates

---

## Multi-Agent Orchestration: The `new` Action

### Orchestration Philosophy

Based on Anthropic's multi-agent research system:
1. **Lead Agent** (main conversation) coordinates everything
2. **Extended Thinking** for planning before action
3. **Parallel Subagents** (3-5 at a time) for independent research
4. **Interleaved Thinking** by subagents after each tool result
5. **No subagent spawning other subagents** - all coordination through lead agent

### Phase 0: Strategic Planning (Lead Agent)

**Use extended thinking ("think hard") to:**
```
- Analyze topic and description
- Determine scope boundaries (what's in/out)
- Assess complexity (simple/moderate/complex)
- Identify required subagent types (3-5)
- Plan verification checkpoints
- Define success criteria
- Estimate file count and relationships
```

**Outputs from thinking:**
- Scope definition
- List of 3-5 subagents to spawn
- Clear objectives for each subagent
- Expected deliverables

---

### Phase 1: Parallel Discovery (3-5 Subagents)

**Spawn these subagents simultaneously:**

#### Subagent A: Dependency Mapper
**Objective:** Build complete dependency graph for topic
**Tools:** bash (ripgrep), view
**Output Format:**
```json
{
  "imports": {"file": ["module1", "module2"]},
  "exports": {"file": ["export1"]},
  "relationships": [{"from": "fileA", "uses": "funcX", "in": "fileB"}],
  "external_deps": ["library1", "library2"]
}
```
**Boundaries:** Topic-related files + first-level indirect dependencies

#### Subagent B: File Scanner
**Objective:** Identify all relevant files with confidence scores
**Tools:** bash (find, ripgrep), view
**Output Format:**
```json
{
  "files": [
    {"path": "...", "relevance": 0.95, "reason": "..."},
    {"path": "...", "relevance": 0.80, "reason": "..."}
  ],
  "total_files": 42,
  "high_confidence": 28
}
```
**Boundaries:** Relevance score > 0.5

#### Subagent C: Pattern Analyzer
**Objective:** Identify architectural and coding patterns
**Tools:** bash, view
**Output Format:**
```json
{
  "patterns": {
    "naming": ["composable pattern", "provider pattern"],
    "architecture": ["component composition", "store pattern"],
    "config": ["nanostore atoms", "appwrite configs"]
  },
  "conventions": ["...", "..."]
}
```

#### Subagent D: Component Analyzer (Frontend)
**Objective:** Map component structure and relationships
**Conditional:** Only if `--frontend` or `--both`
**Output:** Component hierarchy, props, events, state patterns

#### Subagent E: Backend Analyzer (Backend)
**Objective:** Map API routes, server functions, database
**Conditional:** Only if `--backend` or `--both`
**Output:** Route definitions, function signatures, data models

**Lead Agent Action After Phase 1:**
- Use extended thinking to review all discovery results
- Identify gaps (e.g., "only 3 files found, but pattern suggests more")
- Decide: proceed or spawn additional focused discovery subagents
- Log discovery metrics

---

### Phase 2: Parallel Deep Analysis (3-5 Subagents)

**Based on Phase 1, spawn analysis subagents:**

#### Subagent F: Code Deep-Dive
**Objective:** Read and analyze high-relevance files
**Method:**
1. Read each file from Phase 1 (relevance > 0.7)
2. Use interleaved thinking after each file
3. Extract: logic, algorithms, edge cases, gotchas
**Output:** Detailed code analysis with examples

#### Subagent G: Architecture Analyzer
**Objective:** Understand system integration
**Input:** Discovery results + dependency graph
**Output:** How components/modules interact, data flow, integration points

#### Subagent H: Usage Pattern Extractor
**Objective:** Find real-world usage examples
**Method:** Search codebase for invocations/imports of topic
**Output:** Common patterns, edge cases, usage examples

#### Subagent I: External Context Researcher (Conditional)
**Trigger:** If external dependencies found in Phase 1
**Objective:** Research third-party library documentation
**Output:** Library patterns, best practices, integration notes

#### Subagent J: Historical Context (Conditional)
**Trigger:** If topic has >50 commits OR user requests
**Objective:** Use git blame/log to understand evolution
**Output:** "Why" behind decisions, deprecated approaches

**Lead Agent Action After Phase 2:**
- Use extended thinking to synthesize all findings
- Build mental model of the topic
- Identify remaining knowledge gaps
- If gaps: spawn 1-2 targeted "gap-filler" subagents
- Otherwise: proceed to synthesis

---

### Phase 3: Synthesis (Lead Agent Only)

**No subagents - main agent writes documentation**

**Process:**
1. Review ALL subagent outputs (Phases 1 & 2)
2. Use extended thinking to:
   - Integrate findings into coherent narrative
   - Resolve contradictions
   - Identify missing links
   - Structure documentation outline
3. Write documentation following template:

```markdown
# [Topic Name]

## Overview
[1-2 paragraph TL;DR]

## Architecture
[High-level structure, file locations, key components]

## Key Patterns
[Conventions, repeated patterns, architectural decisions]

## Dependencies
[Internal: files/modules, External: libraries with purpose]

## Implementation Details
[How it works, algorithms, important logic]

## Code Examples
[Self-contained, runnable examples with explanations]

## Edge Cases & Gotchas
[Known issues, special handling, limitations]

## Related Topics
[Links to other brain docs: `[topic-name](../topic-name/main.md)`]

## Usage Patterns
[How this is used in the codebase, common patterns]

---
**Documentation Metadata:**
- Created: [date]
- Files Analyzed: [count]
- Complexity: [simple/moderate/complex]
- Last Verified: [date]
```

4. Save to `.claude/brains/<topic-name>/main.md`
5. Create metadata file

---

### Phase 4: Parallel Verification (2-3 Subagents)

**Spawn verification subagents:**

#### Subagent K: Accuracy Verifier
**Objective:** Verify all claims are correct
**Method:**
- Check file paths exist
- Verify function signatures
- Validate code examples
- Confirm dependency relationships
**Output:** Issues found with severity (critical/warning/info)

#### Subagent L: Completeness Checker
**Objective:** Ensure nothing was missed
**Method:**
- Compare Phase 1 file list to documented files
- Check all patterns mentioned
- Verify architectural elements covered
**Output:** Missing elements report

#### Subagent M: Example Validator (Conditional)
**Trigger:** If code examples in documentation
**Objective:** Validate examples are correct
**Method:** Extract examples, check syntax, verify against actual code
**Output:** Example validation results

**Lead Agent Action After Phase 4:**
- Review verification reports
- Use extended thinking to assess quality
- Make corrections if critical issues found
- Update metadata with verification status
- Finalize documentation

---

### Phase 5: Finalization (Lead Agent)

**Actions:**
1. Save final documentation
2. Create `.claude/brains/<topic-name>/metadata.json`:
```json
{
  "topic": "topic-name",
  "created": "2025-10-29",
  "files_analyzed": 42,
  "complexity": "moderate",
  "last_verified": "2025-10-29",
  "subagents_used": 14,
  "verification_status": "verified",
  "related_topics": ["other-topic"]
}
```
3. Create empty `archives/` directory
4. Report to user: summary of what was documented

---

## Orchestration Best Practices

### Extended Thinking Triggers
- **"think hard":** Before Phase 0, after Phase 1, after Phase 2, before finalization
- **"think":** After verification, for quick assessments

### Subagent Instructions (Template)

```markdown
You are the [Subagent Name] subagent.

OBJECTIVE: [Clear, focused goal]

TOOLS TO USE: [Specific tools]

SCOPE BOUNDARIES:
- [What to include]
- [What to exclude]
- [Depth of analysis]

OUTPUT FORMAT:
[JSON or structured format specification]

SUCCESS CRITERIA:
- [Criterion 1]
- [Criterion 2]

Use interleaved thinking after each tool result to:
1. Evaluate result quality
2. Identify gaps
3. Decide next action
```

### Gap Prevention Checklist

After each phase, lead agent checks:
- [ ] File count makes sense (not too few/many)
- [ ] All patterns have examples
- [ ] Dependencies are bidirectional (if A imports B, B should be in results)
- [ ] No orphaned files (in filesystem but not in analysis)
- [ ] External dependencies documented
- [ ] At least one usage example per major component

### Token Usage Expectations

- **Simple topic:** ~50K tokens, 8-12 subagents
- **Moderate topic:** ~150K tokens, 12-16 subagents  
- **Complex topic:** ~300K+ tokens, 16-20 subagents

**Quality over efficiency** - this is expected and acceptable.

---

## Resources

- See `resources/orchestration.md` for detailed multi-agent patterns
- See `resources/subagent-prompts.md` for complete subagent templates
- See `templates/doc-template.md` for full documentation template
- See `scripts/file_discovery.sh` for helper scripts

---

## Future Actions (Not Yet Implemented)

- `verify`: Re-verify existing documentation
- `update`: Update documentation based on code changes
- `archive`: Move outdated docs to archives/

---

## Notes

- All documentation stored in `.claude/brains/<topic>/`
- Each topic is isolated (no cross-topic dependencies in research)
- Verification is mandatory - never skip Phase 4
- Lead agent must coordinate all subagents - no peer-to-peer subagent communication
- Subagents use interleaved thinking after each tool result for self-correction

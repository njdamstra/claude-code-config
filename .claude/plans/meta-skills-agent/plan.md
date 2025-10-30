# meta-skills-agent - Quick Plan

**Type:** Feature
**Estimated Effort:** 2-3 hours
**Created:** 2025-10-29

## Task Description

Create a specialized agent that generates complete Claude Code skill files (SKILL.md) with proper frontmatter, progressive disclosure, and skill architecture patterns. Similar to meta-agent but focused on skill creation rather than subagent creation.

### Objective
Build an agent that can generate production-ready SKILL.md files following established patterns when given a skill description, eliminating manual boilerplate and ensuring consistency with existing skills.

### Context
- Existing `meta-agent` handles subagent creation
- `cc-skill-builder` skill provides skill architecture guidance
- Need automated skill file generation to speed up Claude Code ecosystem development
- Skills are auto-invoked via description matching (critical to get right)

## Files to Create

- `~/.claude/agents/meta/meta-skills-agent.md` - Main agent file with system prompt and skill generation logic

## Implementation Steps

1. [ ] **Create meta-skills-agent.md file**
   - Action: Create new agent file at ~/.claude/agents/meta/meta-skills-agent.md
   - Location: ~/.claude/agents/meta/ (alongside meta-agent.md)
   - Validation: File exists with proper frontmatter

2. [ ] **Write agent frontmatter**
   - Action: Add YAML frontmatter with name, description, tools, model
   - Content:
     ```yaml
     name: meta-skills-agent
     description: Generate complete Claude Code skill files with proper frontmatter, progressive disclosure, and architecture patterns. Use when creating new skills or automating skill generation. Handles SKILL.md structure, description optimization, and template organization.
     tools: [Write, Read, Grep, Glob]
     model: sonnet
     ```
   - Validation: Frontmatter parses correctly

3. [ ] **Create system prompt referencing cc-skill-builder**
   - Action: Write comprehensive system prompt that:
     - References cc-skill-builder for best practices
     - Includes skill structure template
     - Defines frontmatter requirements (name, description required; tools, model, version, tags optional)
     - Explains progressive disclosure (keep SKILL.md < 10KB)
     - Provides description formula for auto-invocation
   - Location: Agent system prompt section
   - Validation: Covers all skill creation requirements

4. [ ] **Add skill structure template**
   - Action: Include complete SKILL.md template with:
     - YAML frontmatter block
     - Quick Start section
     - Core Patterns/Instructions
     - Examples (basic inline + links to advanced)
     - Best Practices
     - Progressive disclosure guidance
   - Location: Within system prompt as reference
   - Validation: Template follows patterns from existing skills

5. [ ] **Include description optimization guidance**
   - Action: Add section explaining how to write effective skill descriptions:
     - Formula: [ACTION] [WHAT]. Use for [USE CASES]. Use when [TRIGGERS].
     - Must include keywords for discovery
     - Examples from successful skills
   - Location: System prompt
   - Validation: Clear actionable guidance

6. [ ] **Add output file path logic**
   - Action: Specify output location: ~/.claude/skills/[skill-name]/SKILL.md
   - Location: Instructions section
   - Validation: Correct directory structure documented

## Testing Notes

### Manual Testing
- [ ] Invoke agent with: "create a skill for [description]"
- [ ] Verify generated SKILL.md has valid YAML frontmatter
- [ ] Check description follows formula and includes keywords
- [ ] Confirm file structure matches template
- [ ] Validate file size < 10KB
- [ ] Test that Claude can auto-invoke the generated skill via description matching

### Validation Commands
```bash
# Verify agent file exists
ls -la ~/.claude/agents/meta/meta-skills-agent.md

# Test generation (invoke via Task tool, NOT as skill)
# Use: Task tool with subagent_type="meta-skills-agent"

# Validate generated skill
cat ~/.claude/skills/[generated-skill]/SKILL.md | head -20

# Check frontmatter parsing
grep -A 10 "^---$" ~/.claude/skills/[generated-skill]/SKILL.md
```

## Key Patterns to Follow

### From meta-agent.md
- Systematic approach: analyze → template → generate → validate
- Include complete templates in system prompt
- Reference authoritative sources (cc-skill-builder)
- Provide clear examples

### From cc-skill-builder
- Description is critical for auto-invocation
- Progressive disclosure keeps SKILL.md lean
- Use visual patterns (✅/❌/⚠️)
- Support files for deep references

### Skill vs Agent Differences
| Aspect | Skills | Agents |
|--------|--------|--------|
| Invocation | Auto via description | Task tool delegation |
| Frontmatter | name/description/version/tags | name/description/tools/model |
| Structure | SKILL.md + supporting files | Single .md |
| Purpose | Knowledge/patterns | Execution/delegation |

## Dependencies

- Depends on: cc-skill-builder skill (for reference patterns)
- Blocks: None
- Related to: meta-agent (parallel pattern for subagent generation)

## Notes

**Critical Success Factors:**
1. **Description formula** - Must be specific enough for Claude to auto-invoke
2. **Progressive disclosure** - Keep main SKILL.md under 10KB
3. **Template completeness** - Include all standard sections
4. **Frontmatter validation** - Ensure YAML is syntactically correct

**Edge Cases:**
- Skill names with hyphens vs underscores (use hyphens)
- Optional frontmatter fields (tools, model) - include guidance on when to use
- Multiple example types (inline basic + linked advanced)

**Constraints:**
- Output location: ~/.claude/skills/[skill-name]/SKILL.md (not ~/.claude/agents/)
- File size: < 10KB for main SKILL.md
- Frontmatter: Must be valid YAML between --- markers

**Reference Files:**
- ~/.claude/agents/meta/meta-agent.md - Pattern template (same directory)
- ~/.claude/skills/cc-skill-builder/SKILL.md - Skill architecture reference (read in main agent, not subagent)
- ~/.claude/skills/vue-component-builder/SKILL.md - Good example structure
- ~/.claude/skills/cc-subagent-architect/SKILL.md - Meta-skill pattern

**Important Notes:**
- **Agent location:** Must be in ~/.claude/agents/meta/ directory (not root agents/)
- **Invocation:** Agents are invoked via Task tool delegation, NOT auto-invoked like skills
- **No skill invocation in subagents:** The meta-skills-agent cannot invoke cc-skill-builder skill when running as subagent (subagents cannot invoke skills)
- **Read files directly:** Agent must read skill files directly using Read tool, not invoke skills

---

**Generated:** 2025-10-29
**Workflow:** quick
**Complexity:** Simple

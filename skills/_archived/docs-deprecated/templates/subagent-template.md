

---
name: [subagent-name]
description: [When to use this subagent - be specific and action-oriented. Use "PROACTIVELY" or "MUST BE USED" for auto-delegation]
tools: [Bash, Read, Write, Grep] # Specify needed tools or omit to inherit all
model: sonnet
---

# Role: [Subagent Role Name]

## Objective

[One clear sentence describing what this subagent accomplishes]

## Tools Strategy

- **Bash**: [How bash is used - e.g., ripgrep for searching]
- **Read**: [How read is used - e.g., viewing file contents]
- **Write**: [How write is used - e.g., creating output files]
- **Grep**: [How grep is used - e.g., pattern matching]

## Workflow

1. **Step 1: [Action Name]**
   ```bash
   # Bash command example
   rg "pattern" --type ts
   ```
   
   [Explanation of what this step does]

2. **Step 2: [Action Name]**
   ```bash
   # Another example
   view path/to/file.ts
   ```
   
   [Explanation]

3. **Step 3: [Action Name]**
   
   [Description of processing or analysis]

4. **Step 4: [Write Output]**
   ```bash
   # Write results
   cat > .temp/phase1-discovery/output-name.json << 'EOF'
   {
     "key": "value"
   }
   EOF
   ```

## Output Format

Write to `.claude/brains/[topic]/.temp/[phase]-[category]/[subagent-name].[ext]`:

**For JSON output:**
```json
{
  "field1": "description",
  "field2": [
    "item1",
    "item2"
  ],
  "summary": "Human-readable summary"
}
```

**For Markdown output:**

# [Section Name]

## Subsection

Content organized clearly with:
- Bullet points
- Code blocks
- Clear headings

## Interleaved Thinking Triggers

After each tool call, think:
- Did I find all expected [items]?
- Are there patterns suggesting [additional work]?
- Any unexpected [findings] indicating [concern]?

## Boundaries

- **Include:** [What to include in scope]
- **Exclude:** [What to exclude from scope]
- **Depth:** [How deep to analyze]

## Error Handling

**If [expected condition not met]:**
1. [Recovery action 1]
2. [Recovery action 2]
3. [Fallback strategy]

**If [error condition]:**
- [How to handle it]
- [What to report]

## Success Criteria

Output is complete when:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Examples

### Example 1: [Scenario]

**Input Context:**
- Topic: "authentication"
- Flags: --frontend

**Actions Taken:**
```bash
# Commands run
rg "auth" --type vue
view src/components/Login.vue
```

**Output Produced:**
```json
{
  "files": ["Login.vue", "AuthGuard.vue"],
  "patterns": ["Composition API", "Props validation"]
}
```

### Example 2: [Scenario]

[Another example showing different conditions]

---


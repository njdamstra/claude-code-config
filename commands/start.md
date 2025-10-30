---
argument-hint: [feature-name] [--recall <topic>] [--template <type>]
description: Begin new feature work by creating organized workspace and loading relevant context
---

# /start - Begin New Feature Work

**Usage:** `/start [feature-name]`

Begin new feature work by creating an organized workspace and loading relevant context.

## Examples

```bash
# Start new feature
/start user-authentication

# Start with existing knowledge loaded
/start "oauth integration" --recall auth

# Start with custom template
/start payment-flow --template feature
```

## What This Command Does

1. **Creates** active workspace: `active/[feature]-[date]/`
2. **Generates** template files: `plan.md`, `research.md`, `scratch.md`
3. **Loads** relevant knowledge if `--recall` specified
4. **Reports** workspace location and next steps

## Workspace Structure

```
active/[feature]-2025-01-06/
├── plan.md           # Feature planning and tasks
├── research.md       # Research notes and references
├── scratch.md        # Temporary notes and ideas
└── decisions.md      # Technical decisions made (optional)
```

## Implementation

Please execute the following steps when this command is run:

### Step 1: Parse Arguments
```typescript
const args = parseArgs(input);
const featureName = args.feature || await promptUser("Feature name?");
const shouldRecall = args.recall;
const template = args.template || 'default';
```

### Step 2: Create Workspace
```typescript
const date = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
const slug = slugify(featureName);
const workspacePath = `claude-docs/active/${slug}-${date}`;

// Check if workspace already exists
if (await exists(workspacePath)) {
  console.log(`
⚠️  Workspace already exists: ${workspacePath}

**Options:**
1. Continue with existing workspace
2. Create new dated version: ${slug}-${Date.now()}
3. Cancel

Your choice (1/2/3):
  `);

  const choice = await promptUser();
  if (choice === '2') {
    workspacePath = `claude-docs/active/${slug}-${Date.now()}`;
  } else if (choice === '3') {
    return;
  }
}

// Create directory
await mkdir(workspacePath);
console.log(`📁 Created workspace: ${workspacePath}`);
```

### Step 3: Generate Template Files
```typescript
// plan.md - Main planning document
await writeFile(
  `${workspacePath}/plan.md`,
  `# ${featureName} - Feature Plan

**Created:** ${new Date().toISOString()}
**Status:** 🚧 In Progress

## Overview

[Brief description of the feature and its purpose]

## Goals

- [ ] Goal 1
- [ ] Goal 2
- [ ] Goal 3

## Technical Approach

[High-level approach and architecture]

## Tasks

### Phase 1: Setup & Planning
- [ ] Research existing solutions
- [ ] Define requirements
- [ ] Create technical design

### Phase 2: Implementation
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

### Phase 3: Testing & Polish
- [ ] Write tests
- [ ] Test edge cases
- [ ] Code review
- [ ] Documentation

## Dependencies

- What existing code does this depend on?
- What packages/libraries needed?
- What other features must be complete first?

## Open Questions

- [ ] Question 1
- [ ] Question 2

## Resources

- Relevant docs
- Related issues/PRs
- Example implementations

---

## Progress Log

### ${date}
- Started feature planning
- Created workspace
`
);

// research.md - Research notes
await writeFile(
  `${workspacePath}/research.md`,
  `# ${featureName} - Research Notes

**Last Updated:** ${new Date().toISOString()}

## Research Areas

### Existing Solutions

[How do other apps/libraries handle this?]

### Best Practices

[What are the recommended approaches?]

### Potential Issues

[What problems might we encounter?]

## References

- [Link 1](url)
- [Link 2](url)

## Insights from Research

Use \`/capture\` to save insights while researching.

---

## Web Research

Use \`/learn "${featureName}" --from-web\` to scrape and extract insights.
`
);

// scratch.md - Temporary notes
await writeFile(
  `${workspacePath}/scratch.md`,
  `# ${featureName} - Scratch Pad

**Quick notes, temporary ideas, code snippets**

---

## Ideas

-

## Code Snippets

\`\`\`typescript
// Scratch code here
\`\`\`

## Questions

-

---

_This is your thinking space. Nothing here is permanent._
`
);

console.log(`📄 Created template files: plan.md, research.md, scratch.md`);
```

### Step 4: Load Relevant Knowledge (if requested)
```typescript
if (shouldRecall) {
  // Extract topic from feature name
  const topic = extractTopicFromFeatureName(featureName);

  console.log(`📚 Loading knowledge about: ${topic}`);

  // Run /recall command
  await runCommand(`/recall ${topic} --depth shallow`);
}
```

### Step 5: Check for Existing Knowledge
```typescript
// Search for related topics
const potentialTopics = extractKeywords(featureName);
const existingTopics = [];

for (const topic of potentialTopics) {
  const topicPath = `claude-docs/knowledge/${topic}`;
  if (await exists(topicPath)) {
    existingTopics.push(topic);
  }
}

if (existingTopics.length > 0) {
  console.log(`
💡 Found related knowledge:
${existingTopics.map(t => `  - ${t}`).join('\n')}

**Load into context?**
\`/recall ${existingTopics.join(' ')}\`
  `);
}
```

### Step 6: Git Integration (Optional)
```typescript
// Optionally create git branch
const shouldCreateBranch = await confirm(
  'Create git branch for this feature? (y/n)'
);

if (shouldCreateBranch) {
  const branchName = `feature/${slug}`;

  await exec(`git checkout -b ${branchName}`);

  console.log(`
🌿 Created git branch: ${branchName}

**Workspace and branch are now synced**
  `);
}
```

### Step 7: Report Results
```typescript
console.log(`
✅ Feature workspace ready!

**Workspace:** ${workspacePath}

**Files Created:**
- 📋 plan.md        - Main planning document
- 🔍 research.md    - Research notes
- 📝 scratch.md     - Temporary ideas

**Next Steps:**

1. **Plan the feature**
   \`Edit ${workspacePath}/plan.md\`

2. **Research if needed**
   \`/learn "${featureName}" --from-web\`
   \`Edit ${workspacePath}/research.md\`

3. **Load relevant knowledge**
   \`/recall [topic]\`

4. **Start implementing**
   - Use \`/capture\` for quick insights
   - Update plan.md with progress
   - Use scratch.md for experiments

5. **At checkpoints**
   \`/checkpoint\`  - Save and extract insights

6. **When done**
   \`/complete ${featureName}\`  - Archive and promote learnings

**Happy coding!** 🚀
`);
```

## Feature Name Best Practices

Good feature names:
- ✅ `user-authentication`
- ✅ `oauth-integration`
- ✅ `payment-flow`
- ✅ `dark-mode-toggle`

Bad feature names:
- ❌ `feature1` (too generic)
- ❌ `fix` (not descriptive)
- ❌ `stuff` (meaningless)
- ❌ `user auth & payment` (use hyphens, not spaces/symbols)

## Template Types

### Default Template
- plan.md, research.md, scratch.md
- Use for most features

### Minimal Template (`--template minimal`)
- Just plan.md
- Use for small tasks

### Research Template (`--template research`)
- research.md, references.md, insights.md
- Use for exploration/learning

### Refactor Template (`--template refactor`)
- analysis.md, plan.md, migration.md
- Use for refactoring work

## Error Handling

```typescript
// Invalid feature name
if (!isValidFeatureName(featureName)) {
  console.log(`
❌ Invalid feature name: "${featureName}"

**Requirements:**
- Lowercase with hyphens
- Descriptive (>3 characters)
- No special characters

**Examples:** user-auth, payment-flow, dark-mode
  `);
  return;
}

// Too many active workspaces
const activeCount = (await readdir('claude-docs/active')).length;

if (activeCount > 10) {
  console.log(`
⚠️  You have ${activeCount} active workspaces

**Consider cleaning up:**
\`\`\`bash
# Review active work
ls -la claude-docs/active/

# Complete finished features
/complete [feature-name]

# Or manually archive
mv claude-docs/active/[old-feature] claude-docs/archive/
\`\`\`
  `);
}
```

## Integration with Other Commands

### Complete Workflow

```bash
# 1. Start
/start user-authentication --recall auth

# 2. Work
# ... coding, capturing insights ...
/capture "jwt storage pattern"

# 3. Checkpoint
/checkpoint  # Extract insights, suggest organization

# 4. Complete
/complete user-authentication  # Archive, promote to knowledge/
```

### With Git Worktrees

```bash
# If using git worktrees
/worktree-feature user-authentication

# Then start documentation
/start user-authentication
```

## Pro Tips

1. **Use Descriptive Names** - Future you will thank you
2. **Load Context Early** - Use `--recall` to get started quickly
3. **Capture Often** - Use `/capture` throughout development
4. **Review at Checkpoints** - Use `/checkpoint` to organize
5. **Complete When Done** - Use `/complete` to promote learnings

## Implementation Location

This command should be implemented as a bash script that:
1. Parses feature name and options
2. Creates active/ workspace with template files
3. Optionally loads relevant knowledge
4. Optionally creates git branch
5. Reports next steps

The script will be triggered when user types `/start [feature]` in Claude Code.

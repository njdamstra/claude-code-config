---
argument-hint: [feature-name] [--no-archive]
description: Finish feature work, extract final insights, promote to knowledge/, and archive planning docs
---

# /complete - Finish Feature and Archive Learnings

**Usage:** `/complete [feature-name]`

Finish feature work, extract final insights, promote to knowledge/, and archive planning docs.

## Examples

```bash
# Complete current feature
/complete

# Complete specific feature
/complete user-authentication

# Complete and skip archive
/complete payment-flow --no-archive
```

## What This Command Does

1. **Extracts final insights** from all workspace files
2. **Promotes valuable insights** to knowledge/[topic]/
3. **Updates architecture/** if needed (major decisions)
4. **Archives planning docs** to archive/[year]/[month]/
5. **Cleans up** active/ workspace
6. **Optionally merges/closes** git branch
7. **Runs `/reindex`** to update search database

## Completion Checklist

Before running `/complete`, ensure:
- [ ] All tasks in plan.md are checked off
- [ ] Code is tested and working
- [ ] PR is merged (if applicable)
- [ ] Documentation is updated
- [ ] No blocking issues remain

## Implementation

Please execute the following steps when this command is run:

### Step 1: Parse Arguments and Find Workspace
```typescript
const args = parseArgs(input);
const featureName = args.feature || detectCurrentFeature();

// Find workspace
const workspaces = await glob(`claude-docs/active/*${featureName}*/`);

if (workspaces.length === 0) {
  console.log(`
⚠️  No workspace found for: ${featureName}

**Active workspaces:**
${(await glob('claude-docs/active/*/')).join('\n')}

**Try:** \`/complete [exact-feature-name]\`
  `);
  return;
}

if (workspaces.length > 1) {
  console.log(`
⚠️  Multiple workspaces match "${featureName}":
${workspaces.map((w, i) => `${i + 1}. ${w}`).join('\n')}

Which one? (number):
  `);

  const choice = parseInt(await promptUser());
  workspace = workspaces[choice - 1];
} else {
  workspace = workspaces[0];
}

console.log(`📁 Completing: ${workspace}\n`);
```

### Step 2: Pre-completion Checks
```typescript
// Read plan.md
const planPath = `${workspace}/plan.md`;
const plan = await readFile(planPath);

// Check for uncompleted tasks
const totalTasks = (plan.match(/- \[.\]/g) || []).length;
const completedTasks = (plan.match(/- \[x\]/gi) || []).length;
const incompleteTasks = totalTasks - completedTasks;

if (incompleteTasks > 0) {
  console.log(`
⚠️  Warning: ${incompleteTasks}/${totalTasks} tasks incomplete

**Uncompleted tasks:**
${extractIncompleteTasks(plan).join('\n')}

**Continue anyway?** (y/n):
  `);

  if (!await confirm()) {
    console.log('Cancelled. Complete tasks first.');
    return;
  }
}

// Check for TODO/FIXME comments (optional)
const codeFiles = await glob('src/**/*.{ts,tsx,vue,astro}');
const todos = await findTODOs(codeFiles, featureName);

if (todos.length > 0) {
  console.log(`
💡 Found ${todos.length} TODO comments related to this feature:
${todos.map(t => `  - ${t.file}:${t.line} - ${t.comment}`).join('\n')}

**Address before completing?** (recommended) (y/n):
  `);

  if (await confirm()) {
    console.log('Please address TODOs and run /complete again.');
    return;
  }
}
```

### Step 3: Extract Final Insights
```typescript
console.log('🔍 Extracting final insights...\n');

// Read all workspace files
const workspaceFiles = await glob(`${workspace}/*.md`);
const contents = await Promise.all(workspaceFiles.map(f => readFile(f)));
const context = contents.join('\n\n---\n\n');

// Also include conversation context
const recentMessages = getRecentMessages(20); // More context for final extraction
const conversationContext = recentMessages.join('\n\n');

const fullContext = `${context}\n\n---\n\n## Recent Conversation\n\n${conversationContext}`;

// Spawn insight-extractor agent
const insights = await spawnAgent('insight-extractor', {
  context: fullContext,
  topic: featureName,
  source: 'completion',
  mode: 'comprehensive' // More thorough than checkpoint
});

console.log(`✅ Extracted ${insights.length} final insights\n`);
```

### Step 4: Organize Insights by Topic
```typescript
// Group insights by suggested topic
const insightsByTopic = new Map();

for (const insight of insights) {
  const suggestedTopic = suggestTopicFromTags(insight.tags) || featureName;

  if (!insightsByTopic.has(suggestedTopic)) {
    insightsByTopic.set(suggestedTopic, []);
  }

  insightsByTopic.get(suggestedTopic).push(insight);
}

console.log(`📊 Organized into ${insightsByTopic.size} topics:\n`);

for (const [topic, topicInsights] of insightsByTopic) {
  console.log(`  ${topic}: ${topicInsights.length} insights`);
}

console.log('');
```

### Step 5: Promote to Knowledge
```typescript
console.log('📚 Promoting insights to knowledge/...\n');

for (const [topic, topicInsights] of insightsByTopic) {
  const topicPath = `claude-docs/knowledge/${slugify(topic)}`;

  // Create topic if doesn't exist
  if (!await exists(topicPath)) {
    await mkdir(topicPath);
    await createTemplateFiles(topicPath);

    console.log(`  📁 Created new topic: ${topic}`);
  }

  // Organize by type
  const organized = {
    insights: topicInsights.filter(i => i.type === 'pattern' || i.type === 'discovery'),
    gotchas: topicInsights.filter(i => i.type === 'gotcha'),
    procedures: topicInsights.filter(i => i.type === 'decision' || i.hasSteps)
  };

  // Append to appropriate files
  if (organized.insights.length > 0) {
    await appendFile(
      `${topicPath}/insights.md`,
      `\n\n---\n\n${organized.insights.map(formatInsight).join('\n\n---\n\n')}`
    );
    console.log(`  ✓ Added ${organized.insights.length} insights to ${topic}/insights.md`);
  }

  if (organized.gotchas.length > 0) {
    await appendFile(
      `${topicPath}/gotchas.md`,
      `\n\n---\n\n${organized.gotchas.map(formatInsight).join('\n\n---\n\n')}`
    );
    console.log(`  ✓ Added ${organized.gotchas.length} gotchas to ${topic}/gotchas.md`);
  }

  if (organized.procedures.length > 0) {
    await appendFile(
      `${topicPath}/procedures.md`,
      `\n\n---\n\n${organized.procedures.map(formatInsight).join('\n\n---\n\n')}`
    );
    console.log(`  ✓ Added ${organized.procedures.length} procedures to ${topic}/procedures.md`);
  }

  // Update INDEX.md
  await updateTopicIndex(topic, topicInsights);
}

console.log('');
```

### Step 6: Update Architecture (if needed)
```typescript
// Check if any major architectural decisions were made
const architecturalInsights = insights.filter(i =>
  i.type === 'decision' &&
  i.tags.some(t => ['architecture', 'design', 'pattern'].includes(t))
);

if (architecturalInsights.length > 0) {
  console.log(`🏗️  Found ${architecturalInsights.length} architectural decisions\n`);

  console.log('Add to architecture/decisions.md? (y/n):');

  if (await confirm()) {
    const decisionsPath = 'claude-docs/architecture/decisions.md';
    const decisions = architecturalInsights.map(formatADR).join('\n\n---\n\n');

    await appendFile(decisionsPath, `\n\n---\n\n${decisions}`);

    console.log(`✅ Updated architecture/decisions.md\n`);
  }
}
```

### Step 7: Archive Workspace
```typescript
if (!args.noArchive) {
  console.log('📦 Archiving workspace...\n');

  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');

  const archivePath = `claude-docs/archive/${year}/${month}`;
  await mkdir(archivePath, { recursive: true });

  // Move workspace to archive
  const workspaceName = basename(workspace);
  const archiveDestination = `${archivePath}/${workspaceName}`;

  await mv(workspace, archiveDestination);

  console.log(`✅ Archived to: ${archiveDestination}\n`);
}
```

### Step 8: Git Integration
```typescript
const isGitRepo = await exists('.git');

if (isGitRepo) {
  // Commit knowledge updates
  await exec('git add claude-docs/knowledge/ claude-docs/architecture/');

  const commitMsg = `docs: complete ${featureName} - promote insights to knowledge`;

  try {
    await exec(`git commit -m "${commitMsg}"`);
    console.log(`✅ Git commit: ${commitMsg}\n`);
  } catch (err) {
    // Ignore if no changes
  }

  // Optionally delete feature branch
  const currentBranch = (await exec('git branch --show-current')).trim();

  if (currentBranch.includes(featureName)) {
    console.log(`🌿 You're on branch: ${currentBranch}\n`);
    console.log('Delete this branch after merging to main? (y/n):');

    if (await confirm()) {
      // Switch to main first
      await exec('git checkout main');

      // Delete branch
      await exec(`git branch -d ${currentBranch}`);

      console.log(`✅ Deleted branch: ${currentBranch}\n`);
    }
  }
}
```

### Step 9: Reindex
```typescript
console.log('🔄 Updating search index...\n');

await runCommand('/reindex');
```

### Step 10: Generate Completion Report
```typescript
console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Feature Complete: ${featureName}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Insights Extracted:** ${insights.length}
**Topics Updated:** ${insightsByTopic.size}
**Architecture Updated:** ${architecturalInsights.length > 0 ? 'Yes' : 'No'}
**Workspace Archived:** ${!args.noArchive ? 'Yes' : 'No'}
**Search Index:** Updated

**Knowledge Promoted To:**
${Array.from(insightsByTopic.keys()).map(t => `  - knowledge/${slugify(t)}/`).join('\n')}

${!args.noArchive ? `**Archived To:**
  claude-docs/archive/${year}/${month}/${workspaceName}
` : ''}

**What Was Learned:**
${insights.slice(0, 5).map((i, idx) => `${idx + 1}. ${i.title} (${i.type})`).join('\n')}
${insights.length > 5 ? `... and ${insights.length - 5} more` : ''}

**Next Steps:**

1. **Verify knowledge**
   \`/recall ${Array.from(insightsByTopic.keys())[0]}\`

2. **Start new feature**
   \`/start [next-feature]\`

3. **Review learnings**
   \`Read claude-docs/knowledge/[topic]/insights.md\`

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 Great work! Knowledge captured and ready for reuse.
`);
```

## Completion Workflow

```bash
# 1. Check readiness
/checkpoint  # Extract latest insights

# 2. Review tasks
Edit active/[feature]/plan.md  # Ensure all tasks done

# 3. Complete
/complete [feature]

# 4. Verify
/recall [topic]  # Check insights were promoted correctly
```

## Error Handling

```typescript
// Workspace not found
if (!workspace) {
  console.log(`
❌ Workspace not found: ${featureName}

**Active workspaces:**
${(await glob('claude-docs/active/*/')).map(w => `  - ${basename(w)}`).join('\n')}

**Usage:** \`/complete [exact-workspace-name]\`
  `);
  return;
}

// No insights extracted (warning, not error)
if (insights.length === 0) {
  console.log(`
⚠️  No insights extracted from ${featureName}

This might be okay if:
- Feature was simple/straightforward
- Knowledge already exists
- Work was experimental

**Continue anyway?** (y/n):
  `);

  if (!await confirm()) {
    return;
  }
}

// Archive path already exists
if (await exists(archiveDestination)) {
  console.log(`
⚠️  Archive destination already exists: ${archiveDestination}

**Options:**
1. Merge with existing
2. Rename new archive with timestamp
3. Skip archiving

Your choice (1/2/3):
  `);

  const choice = await promptUser();

  if (choice === '2') {
    archiveDestination = `${archiveDestination}-${Date.now()}`;
  } else if (choice === '3') {
    args.noArchive = true;
  }
}
```

## Post-Completion Checklist

After `/complete` finishes:
- [ ] Verify insights in knowledge/
- [ ] Check architecture/decisions.md if updated
- [ ] Confirm workspace archived (or kept if --no-archive)
- [ ] Test `/recall [topic]` works
- [ ] Review and merge any git branches
- [ ] Delete any temporary branches
- [ ] Close related issues/PRs

## Integration with Other Commands

### Complete Lifecycle

```bash
# Start
/start user-authentication

# Work + checkpoint
# ... coding ...
/capture "insight 1"
/checkpoint

# ... more coding ...
/capture "insight 2"
/checkpoint

# Finish
/complete user-authentication
```

## Pro Tips

1. **Review Before Completing** - Use `/checkpoint` first to see what will be extracted
2. **Clean Commits** - Commit all code changes before `/complete`
3. **Descriptive Insights** - More context = better knowledge for future
4. **Archive Liberally** - Storage is cheap, knowledge is valuable
5. **Test Recall** - After completing, test `/recall [topic]` to verify

## Implementation Location

This command should be implemented as a bash script that:
1. Finds and validates workspace
2. Checks completion readiness
3. Extracts comprehensive final insights
4. Promotes insights to knowledge/
5. Updates architecture if needed
6. Archives workspace
7. Commits changes to git
8. Reindexes search database
9. Generates completion report

The script will be triggered when user types `/complete [feature]` in Claude Code.

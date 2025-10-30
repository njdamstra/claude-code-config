---
argument-hint: [--no-extract]
description: Save work state, extract insights from progress, and suggest organization
---

# /checkpoint - Save Work and Extract Insights

**Usage:** `/checkpoint [--no-extract]`

Save current work state, extract insights from recent progress, and suggest organization.

## Examples

```bash
# Standard checkpoint
/checkpoint

# Skip insight extraction
/checkpoint --no-extract

# Checkpoint with specific feature
/checkpoint user-authentication
```

## What This Command Does

1. **Commits** current active/ files (if git enabled)
2. **Extracts insights** from plan.md and work done
3. **Suggests** items to move to knowledge/
4. **Updates** progress log in plan.md
5. **Prompts** for cleanup (old captures, completed tasks)

## When to Use

- **End of coding session** - Save progress before stopping
- **After solving problem** - Capture solution while fresh
- **Before switching context** - Save state before changing tasks
- **Daily standup** - Review what was accomplished
- **Weekly cleanup** - Organize accumulated captures

## Implementation

Please execute the following steps when this command is run:

### Step 1: Parse Arguments
```typescript
const args = parseArgs(input);
const shouldExtract = !args.noExtract;
const featureName = args.feature || detectCurrentFeature();
```

### Step 2: Detect Active Work
```typescript
// Find current workspace(s)
const activeWorkspaces = await glob('claude-docs/active/*/plan.md');

if (activeWorkspaces.length === 0) {
  console.log(`
⚠️  No active work found in claude-docs/active/

**To start work:** \`/start [feature-name]\`
  `);
  return;
}

// If multiple, let user choose
let workspace;
if (activeWorkspaces.length > 1) {
  console.log(`
📁 Multiple active workspaces found:
${activeWorkspaces.map((w, i) => `${i + 1}. ${w}`).join('\n')}

Which one to checkpoint? (number or 'all'):
  `);

  const choice = await promptUser();
  if (choice === 'all') {
    workspace = activeWorkspaces;
  } else {
    workspace = [activeWorkspaces[parseInt(choice) - 1]];
  }
} else {
  workspace = activeWorkspaces;
}
```

### Step 3: Git Commit (if enabled)
```typescript
// Check if git is initialized
const isGitRepo = await exists('.git');

if (isGitRepo) {
  // Stage all active/ changes
  await exec('git add claude-docs/active/');

  // Create checkpoint commit
  const timestamp = new Date().toISOString();
  const commitMsg = `checkpoint: ${featureName || 'active work'} - ${timestamp}`;

  try {
    await exec(`git commit -m "${commitMsg}"`);
    console.log(`✅ Git commit created: ${commitMsg}`);
  } catch (err) {
    // No changes to commit is okay
    if (!err.message.includes('nothing to commit')) {
      console.log(`⚠️  Git commit failed: ${err.message}`);
    }
  }
}
```

### Step 4: Extract Insights (if enabled)
```typescript
if (shouldExtract) {
  console.log('🔍 Extracting insights from recent work...\n');

  for (const ws of workspace) {
    const workspacePath = dirname(ws);
    const featureName = basename(workspacePath);

    // Read all files in workspace
    const files = await glob(`${workspacePath}/*.md`);
    const contents = await Promise.all(files.map(f => readFile(f)));
    const context = contents.join('\n\n---\n\n');

    // Spawn insight-extractor agent
    const insights = await spawnAgent('insight-extractor', {
      context,
      topic: featureName,
      source: 'checkpoint'
    });

    if (insights.length > 0) {
      console.log(`
📝 Extracted ${insights.length} insights from ${featureName}:
${insights.map((ins, i) => `${i + 1}. ${ins.title} (${ins.type})`).join('\n')}
      `);

      // Save insights to capture file for review
      const capturePath = `${workspacePath}/checkpoint-insights-${Date.now()}.md`;
      await writeFile(
        capturePath,
        insights.map(i => formatInsight(i)).join('\n\n---\n\n')
      );

      console.log(`\n💾 Saved to: ${capturePath}`);
    } else {
      console.log(`⏭️  No new insights extracted from ${featureName}`);
    }
  }
}
```

### Step 5: Suggest Organization
```typescript
console.log('\n🗂️  Reviewing captures for organization...\n');

// Find all capture files
const captures = await glob('claude-docs/active/*/capture*.md');

if (captures.length > 0) {
  console.log(`Found ${captures.length} captures to review:\n`);

  for (const capture of captures) {
    const content = await readFile(capture);
    const title = extractTitle(content);
    const tags = extractTags(content);

    console.log(`
📄 ${basename(capture)}
   Title: ${title}
   Tags: ${tags.join(', ')}

   **Actions:**
   1. Promote to knowledge: \`/learn [topic] --from-file ${capture}\`
   2. Keep for later
   3. Delete (not valuable)

   Your choice (1/2/3):
    `);

    const choice = await promptUser();

    if (choice === '1') {
      const topic = await promptUser(
        'Which topic?',
        suggestTopicFromTags(tags)
      );

      await runCommand(`/learn ${topic} --from-file ${capture}`);
      await rm(capture); // Remove after promoting
    } else if (choice === '3') {
      await rm(capture);
      console.log('🗑️  Deleted capture');
    }
  }
} else {
  console.log('✨ No captures to review');
}
```

### Step 6: Update Progress Log
```typescript
console.log('\n📊 Updating progress log...\n');

for (const ws of workspace) {
  const planPath = ws;
  let plan = await readFile(planPath);

  // Add progress entry
  const today = new Date().toISOString().split('T')[0];
  const progressEntry = `
### ${today}
- Checkpoint completed
- ${insights.length} insights extracted
- ${captures.length} captures reviewed
`;

  // Find or create Progress Log section
  if (plan.includes('## Progress Log')) {
    plan = plan.replace(
      /## Progress Log/,
      `## Progress Log\n${progressEntry}`
    );
  } else {
    plan += `\n\n---\n\n## Progress Log\n${progressEntry}`;
  }

  await writeFile(planPath, plan);
}

console.log('✅ Progress logs updated');
```

### Step 7: Cleanup Suggestions
```typescript
console.log('\n🧹 Cleanup suggestions:\n');

// Check for old captures (>7 days)
const oldCaptures = captures.filter(c => {
  const mtime = getLastModified(c);
  const daysSince = (Date.now() - mtime) / (1000 * 60 * 60 * 24);
  return daysSince > 7;
});

if (oldCaptures.length > 0) {
  console.log(`
⏰ Found ${oldCaptures.length} old captures (>7 days)

**Review and cleanup:**
${oldCaptures.map(c => `  - ${c}`).join('\n')}

Delete all old captures? (y/n):
  `);

  if (await confirm()) {
    await Promise.all(oldCaptures.map(c => rm(c)));
    console.log(`✅ Deleted ${oldCaptures.length} old captures`);
  }
}

// Check for completed tasks
const completedWorkspaces = workspace.filter(async ws => {
  const plan = await readFile(ws);
  const totalTasks = (plan.match(/- \[.\]/g) || []).length;
  const completedTasks = (plan.match(/- \[x\]/gi) || []).length;

  return completedTasks === totalTasks && totalTasks > 0;
});

if (completedWorkspaces.length > 0) {
  console.log(`
🎉 Found ${completedWorkspaces.length} completed feature(s)!

**Complete and archive:**
${completedWorkspaces.map(w => basename(dirname(w))).join('\n')}

Run \`/complete [feature]\` to finalize.
  `);
}
```

### Step 8: Report Summary
```typescript
console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Checkpoint Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Workspaces Checked:** ${workspace.length}
**Insights Extracted:** ${totalInsights}
**Captures Reviewed:** ${captures.length}
**Progress Logs Updated:** ${workspace.length}

**What was saved:**
${isGitRepo ? '✓ Git commit created' : '○ No git commit (not in repo)'}
${shouldExtract ? '✓ Insights extracted' : '○ Skipped insight extraction'}
✓ Progress logs updated
✓ Cleanup suggestions provided

**Next Steps:**

1. **Continue working**
   - Keep coding, use \`/capture\` for new insights

2. **Take a break**
   - Your work is saved and committed

3. **Complete feature**
   - Run \`/complete [feature]\` when done

4. **Review knowledge**
   - Run \`/recall [topic]\` to load related insights

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`);
```

## Checkpoint Frequency

**Recommended:**
- **Hourly** during active coding
- **Before breaks** (lunch, end of day)
- **After solving problems** (while solution is fresh)
- **Before context switches** (changing features)

**Not recommended:**
- Every 5 minutes (too frequent)
- Once a week (too infrequent, risk losing insights)

## What Gets Checkpointed

### Saved:
- ✅ All files in active/ workspace
- ✅ Git commit (if repo)
- ✅ Progress log entries
- ✅ Extracted insights

### Not Saved:
- ❌ Conversation history
- ❌ Claude's context (use bundles for that)
- ❌ Uncommitted code outside active/

## Integration with Git

If in a git repository:
```bash
git log --oneline --grep="checkpoint"
# Shows all checkpoint commits

git show HEAD
# Shows last checkpoint changes
```

Checkpoint commits are prefixed with `checkpoint:` for easy filtering.

## Error Handling

```typescript
// No active work
if (activeWorkspaces.length === 0) {
  console.log(`
⚠️  No active work to checkpoint

**Start work first:** \`/start [feature-name]\`
  `);
  return;
}

// Git errors (non-fatal)
try {
  await exec('git commit ...');
} catch (err) {
  console.log(`
⚠️  Git commit failed (non-fatal)

**Error:** ${err.message}

**Continuing checkpoint without git commit...**
  `);
  // Continue with rest of checkpoint
}

// Insight extraction timeout
const EXTRACT_TIMEOUT = 30000; // 30 seconds

try {
  const insights = await Promise.race([
    spawnAgent('insight-extractor', { context }),
    sleep(EXTRACT_TIMEOUT).then(() => { throw new Error('Timeout'); })
  ]);
} catch (err) {
  if (err.message === 'Timeout') {
    console.log(`
⏱️  Insight extraction timed out

**Skipping extraction, continuing checkpoint...**

**Try manually:** \`/learn [topic] --from-file [workspace]/plan.md\`
    `);
  }
}
```

## Pro Tips

1. **Checkpoint Often** - It's cheap and valuable
2. **Review Captures** - Don't let them pile up
3. **Update Plan** - Keep progress log current
4. **Use Git** - Checkpoint commits are great breadcrumbs
5. **Trust the Process** - Extracted insights improve over time

## Implementation Location

This command should be implemented as a bash script that:
1. Finds active workspaces
2. Creates git commit if applicable
3. Spawns insight-extractor agent
4. Reviews captures and suggests organization
5. Updates progress logs
6. Provides cleanup suggestions

The script will be triggered when user types `/checkpoint` in Claude Code.

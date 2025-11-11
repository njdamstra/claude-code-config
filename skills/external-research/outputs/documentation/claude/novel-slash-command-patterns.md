# Novel Slash Command Patterns

**Source:** claude-code-hooks-mastery repository
**Date Discovered:** 2025-10-29
**Context:** Patterns worth stealing for improving slash command design

---

## Pattern 1: Timestamped Output Directories

### What It Is
Organize agent/command outputs in timestamped directory structures for automatic archival and audit trails.

### Example from Source
```bash
# From crypto_research.md
date +"%Y-%m-%d_%H-%M-%S"  # e.g., 2025-01-08_14-30-45
outputs/<timestamp>/<category>/<agent-name>.md
```

### Directory Structure
```
outputs/
└── 2025-01-08_14-30-45/
    ├── crypto_market/
    │   ├── crypto-market-agent-haiku.md
    │   ├── crypto-market-agent-sonnet.md
    │   └── crypto-market-agent-opus.md
    ├── crypto_analysis/
    │   └── ...
    └── crypto_macro/
        └── ...
```

### Benefits
- **Automatic versioning** - Never overwrite previous research
- **Audit trail** - Track research evolution over time
- **Easy comparison** - Diff between research sessions
- **Organization** - Category-based subdirectories

### Where to Apply in Our Setup
- `/checkpoint` → `checkpoints/YYYY-MM-DD_HH-MM-SS/`
- `/plan` → `planning/YYYY-MM-DD_HH-MM-SS/`
- `/ui-screenshot` → `screenshots/YYYY-MM-DD_HH-MM-SS/`
- `/capture` → `captures/YYYY-MM-DD_HH-MM-SS/`
- `/orchestrate` → `orchestrations/YYYY-MM-DD_HH-MM-SS/`

### Implementation Template
```bash
# In any slash command
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BASE_DIR="outputs/${TIMESTAMP}"
mkdir -p "${BASE_DIR}/category1" "${BASE_DIR}/category2"
```

---

## Pattern 2: Agent Output Preservation

### What It Is
Explicit instructions to preserve complete agent responses without modification, summarization, or truncation.

### Example from Source
```markdown
## Output Format

IMPORTANT: Write each agent's complete response directly to its
respective file with NO modifications, NO summarization, and NO
changes to the output whatsoever. The exact response from each
agent must be preserved.
```

### Benefits
- **Full context retention** - Nothing lost in translation
- **Reproducibility** - Exact agent outputs for review
- **Audit compliance** - Complete record of agent reasoning
- **Debugging** - Can trace back exact agent behavior

### Why This Matters
When orchestrating multiple agents, main agent often summarizes results. This pattern ensures raw outputs are preserved for later analysis.

### Where to Apply in Our Setup
- `/orchestrate` - Preserve all sub-agent outputs
- `/ultratask` - Keep raw agent responses
- `/plan` - Save full planning agent output
- `/ui-new` - Preserve all variant generations

### Implementation Template
```markdown
## Agent Execution

1. Call agents in parallel
2. **CRITICAL**: Write each agent's COMPLETE, UNMODIFIED response to:
   - `outputs/<timestamp>/<agent-name>.md`
3. DO NOT summarize, truncate, or modify agent outputs
4. Preserve exact formatting, code blocks, and structure
```

---

## Pattern 3: Tool Restrictions in Frontmatter

### What It Is
Use frontmatter `allowed-tools` to restrict commands to specific tool patterns for safety and clarity.

### Example from Source
```yaml
---
allowed-tools: Bash(git:*)
description: Understand the current state of the git repository
---
```

```yaml
---
allowed-tools: Bash(date:*), Bash(mkdir:*), Task, Write
argument-hint: [crypto_ticker_symbol]
---
```

### Benefits
- **Safety** - Prevent unintended file modifications
- **Clarity** - Command scope is explicit
- **Trust** - Users know what command can/can't do
- **Read-only modes** - Perfect for analysis commands

### Tool Restriction Patterns
```yaml
# Read-only analysis
allowed-tools: Bash(git ls-files:*), Read

# Git operations only
allowed-tools: Bash(git:*)

# Research agents only
allowed-tools: Bash(date:*), Bash(mkdir:*), Task, Write

# File exploration only
allowed-tools: Glob, Grep, Read, LS

# Code review only (no modifications)
allowed-tools: Read, Grep, Glob, Bash(git:*)
```

### Where to Apply in Our Setup
- `/question` - Read-only mode (Bash(git ls-files:*), Read)
- `/recall` - Read-only (Read, Grep, Glob)
- `/ui-review` - Review mode (Read, Grep, Glob, Bash(git:*))
- `/checkpoint` - Archive mode (Read, Write, Bash(git:*))

### Implementation Example
```yaml
---
allowed-tools: Read, Grep, Glob
description: Answer questions about the project without modifying files
---

# Question Command

IMPORTANT: This is a question-answering task only
DO NOT write, edit, or create any files
```

---

## Pattern 4: Argument Hints in Frontmatter

### What It Is
Provide user-facing hints for what arguments the command expects.

### Example from Source
```yaml
---
argument-hint: [crypto_ticker_symbol]
description: Execute comprehensive cryptocurrency research
---
```

### Benefits
- **Better UX** - Users know what to pass
- **Self-documenting** - No need to read full command
- **IDE integration** - Could power autocomplete
- **Clear intent** - Reduces user errors

### Argument Hint Patterns
```yaml
# Single required argument
argument-hint: [feature-name]

# Optional argument
argument-hint: [component-path]

# Multiple arguments
argument-hint: [action] [target] [options]

# Typed hints
argument-hint: [ticker:BTC|ETH|SOL]

# With defaults
argument-hint: [depth:shallow|deep] (default: shallow)
```

### Where to Apply in Our Setup
```yaml
# /frontend
argument-hint: [action:new|add|fix|improve] [feature-name] [--flags]

# /recall
argument-hint: [topic] [--depth shallow|deep]

# /ui-new
argument-hint: [component description]

# /wt
argument-hint: [action:new|switch|list|clean] [branch] [options]

# /plan
argument-hint: [task-description] [--workflow=name]
```

---

## Pattern 5: Agent @ Syntax for Parallel Invocation

### What It Is
Use `@agent-name` syntax to trigger parallel agent invocation within command descriptions.

### Example from Source
```markdown
## Agents

### All Haiku Agents
- @agent-crypto-market-agent-haiku
- @agent-crypto-coin-analyzer-haiku (analyze TICKER)
- @agent-macro-crypto-correlation-scanner-haiku
- @agent-crypto-investment-plays-haiku

## Execution Instructions

1. Call all 4 haiku agents listed above in parallel
```

### Benefits
- **Clear delegation** - Explicit which agents to use
- **Parallel execution** - All agents run simultaneously
- **Parameterization** - Pass variables to agents
- **Composability** - Mix and match agents

### Our Equivalent Pattern
We use this in CLAUDE.md already:
```markdown
**Pattern Recognition:**
- Detect patterns like `@code-scout`, `@documentation-researcher`
- Each `@agent-name` triggers automatic Task tool invocation
```

### Where to Improve in Our Setup
Currently implicit. Make it explicit in slash commands:

```markdown
# /ui-research command (new)

## Agents to Invoke (Parallel)
- @ui-analyzer (analyze design system compliance)
- @ui-validator (run a11y and token checks)
- @code-scout (find existing similar components)

## Execution
1. Invoke all 3 agents in parallel
2. Write outputs to `research/<timestamp>/<agent>.md`
3. Consolidate findings in `research/<timestamp>/summary.md`
```

---

## Pattern 6: Execution Report Template

### What It Is
Standard report format for command completion with success metrics.

### Example from Source
```markdown
## Report

When all agents are complete: give the path to the
outputs/<timestamp>/ directory with the number of
successful/total agents based on the existence of
their respective files.
```

### Benefits
- **Consistent UX** - Users know what to expect
- **Success validation** - Explicit pass/fail criteria
- **Output location** - Always know where to find results
- **Debugging** - Can identify partial failures

### Report Template
```markdown
## Completion Report

✅ Command: /command-name
📁 Output: path/to/outputs/YYYY-MM-DD_HH-MM-SS/
📊 Success: X/Y agents completed
⏱️  Duration: Xm Ys

### Outputs Generated
- ✅ category1/agent1.md (1234 tokens)
- ✅ category2/agent2.md (5678 tokens)
- ❌ category3/agent3.md (failed: timeout)

### Next Steps
- Review outputs at: [path]
- Run /consolidate to merge findings
- Run /checkpoint to save session state
```

### Where to Apply in Our Setup
- All `/orchestrate` variants
- `/ultratask` completions
- `/plan` outputs
- `/checkpoint` saves
- Multi-agent workflows

---

## Pattern 7: Variable Declaration Section

### What It Is
Explicit `## Variables` section documenting all template variables used in the command.

### Example from Source
```markdown
## Variables

- **TICKER**: $ARGUMENTS
  - The cryptocurrency ticker symbol to analyze (e.g., BTC, ETH, SOL)
  - Used by: crypto-coin-analyzer agent
```

### Benefits
- **Self-documenting** - Clear what variables exist
- **Usage tracking** - Shows where variables are consumed
- **Validation** - Can check if variables are set
- **Defaults** - Document fallback values

### Implementation Pattern
```markdown
## Variables

- **FEATURE_NAME**: $ARGUMENTS[0] or "unnamed-feature"
  - The name of the feature to create
  - Used by: directory creation, git branch, planning docs
  - Pattern: kebab-case, no spaces

- **DEPTH**: $ARGUMENTS[1] or "shallow"
  - How deep to search for context
  - Values: shallow | deep
  - Used by: recall agent, documentation loading

- **TIMESTAMP**: $(date +"%Y-%m-%d_%H-%M-%S")
  - Current timestamp for output organization
  - Used by: all output file paths
```

### Where to Apply
Every command that uses `$ARGUMENTS` should document them:
- `/frontend` - action, feature-name, description, flags
- `/wt` - action, branch, options
- `/recall` - topic, depth
- `/ui-new` - component description
- `/checkpoint` - optional title

---

## Pattern 8: Inline Command Execution (!` syntax)

### What It Is
Use `!` prefix for inline bash command execution within markdown docs.

### Example from Source
```markdown
## Commands

- Current Status: !`git status`
- Current diff: !`git diff HEAD origin/main`
- Current branch: !`git branch --show-current`

## Files
@README.md
```

### Benefits
- **Concise** - No separate Bash tool invocations
- **Readable** - Commands are inline with context
- **DRY** - Reuse command outputs in multiple sections

### Our Current Approach
We don't use this syntax. We use explicit Bash tool calls.

### Evaluation
**Not recommended for adoption** - Our explicit tool usage is clearer and more debuggable. The `!` syntax is less discoverable and harder to trace in execution logs.

---

## Summary: Patterns to Adopt

### High Priority (Adopt Now)
1. ✅ **Timestamped output directories** - Apply to `/checkpoint`, `/plan`, `/capture`
2. ✅ **Tool restrictions in frontmatter** - Add to `/question`, `/recall`, `/ui-review`
3. ✅ **Argument hints in frontmatter** - Add to all commands with `$ARGUMENTS`

### Medium Priority (Consider)
4. ⚠️ **Agent output preservation** - Add to multi-agent orchestration commands
5. ⚠️ **Execution report template** - Standardize completion reports
6. ⚠️ **Variable declaration section** - Document all `$ARGUMENTS` usage

### Low Priority (Review Later)
7. ❌ **Inline command execution** - Our explicit tool usage is better
8. ⚠️ **@ agent syntax** - Already implicit in our setup, could make explicit

---

## Action Items

- [ ] Update `/checkpoint` with timestamped outputs
- [ ] Update `/plan` with timestamped outputs
- [ ] Add `allowed-tools` to `/question`, `/recall`, `/ui-review`
- [ ] Add `argument-hint` to all commands using `$ARGUMENTS`
- [ ] Create standardized completion report template
- [ ] Document variables section in multi-arg commands

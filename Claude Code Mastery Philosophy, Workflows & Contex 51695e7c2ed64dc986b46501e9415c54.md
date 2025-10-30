# Claude Code Mastery: Philosophy, Workflows & Context Engineering

Status: Final
Tags: Important, Process, Reference
Description: Comprehensive guide to using Claude Code effectively for coding, planning, designing, debugging, refactoring, and all development tasks

A comprehensive synthesis of Claude Code philosophy, concepts, workflows, and context engineering techniques for maximizing effectiveness across all development tasks.

## Core Philosophy: From Prompt Engineering to Flow Engineering

The fundamental shift in working with Claude Code is moving from **prompt engineering** (crafting clever one-off prompts) to **flow engineering** (building structured workflows that deliver consistent, high-quality results). Claude Code is intentionally low-level and unopinionated, providing close to raw model access without forcing specific workflows—making it a flexible, customizable, scriptable power tool.[[1]](https://www.anthropic.com/engineering/claude-code-best-practices)

As one practitioner notes: "Effective prompting with Claude Code is more about clear communication than clever tricks."[[2]](https://claudelog.com/faqs/how-to-write-better-prompts-for-claude-code) The key is being specific about what you want to achieve while leveraging persistent context and structured workflows.

## The Orchestration Framework: Context + Tools + Validation

Claude Code's effectiveness comes from three pillars:

**Context** — Documentation, coding standards, architectural patterns, examples of good/bad outcomes. Store in [`CLAUDE.md`](http://CLAUDE.md) files that inject memory into every session.

**Tools** — MCP servers, CLI utilities, Git integration, testing frameworks, linters, and automation scripts that extend Claude's capabilities.

**Validation** — Test suites, acceptance criteria, style guides, automated checks (linting, type checking, security scans) that allow autonomous self-correction.

This orchestration layer transforms Claude Code from a basic assistant into a sophisticated development partner.[[3]](https://www.notion.so/Turn-Claude-Code-into-Your-Own-INCREDIBLE-UI-Designer-using-Playwright-MCP-Subagents-2d60eefc3f5a4e419293e76095e4de44?pvs=21)

## Fundamental Concepts

### 1. Agentic vs. Assistive Coding

Claude Code operates **agentically**—it doesn't just suggest code snippets, it can read your entire codebase, edit files, run commands, execute tests, and manage Git workflows through natural language.[[1]](https://www.anthropic.com/engineering/claude-code-best-practices) This autonomy requires different mental models than traditional autocomplete tools.

### 2. The Iterative Agentic Loop

Productivity gains come from iteration loops where Claude:

1. Makes changes
2. Validates against specs/tests
3. Identifies issues
4. Refines the approach
5. Repeats until reaching target quality

These loops can run for 30 minutes to hours, producing professional results through autonomous refinement rather than single-shot generation.[[3]](https://www.notion.so/Turn-Claude-Code-into-Your-Own-INCREDIBLE-UI-Designer-using-Playwright-MCP-Subagents-2d60eefc3f5a4e419293e76095e4de44?pvs=21)

### 3. Session State Management

Claude Code maintains conversation history, file context, and tool state across a session. Understanding how to manage this state—what to keep, what to compact, when to start fresh—is critical for complex tasks.[[4]](https://zenn.dev/saan/articles/6b4cf8bd87a0f9)

## Permission Modes: Balancing Speed, Control, and Safety

Claude Code offers multiple permission modes that you can switch between mid-session:[[5]](https://www.sidetool.co/post/unlocking-efficiency-claude-code-workflow-best-practices-explained/)

**Default Mode** — Claude requests permission for each file edit and command execution. Best for:

- Unfamiliar codebases
- Production environments
- High-risk operations
- Learning phase with new projects

**AcceptEdits Mode** — Automatically approve file edits, but still require permission for command execution. Best for:

- Active development on familiar code
- Refactoring sessions
- Feature implementation where you trust the scope

**Plan Mode** (Shift+Tab twice) — Read-only environment where Claude explores, analyzes, and formulates comprehensive strategies without touching files.[[6]](https://lord.technology/2025/07/03/understanding-claude-code-plan-mode-and-the-architecture-of-intent.html) Best for:

- Complex architectural decisions
- Sensitive production bugs
- Understanding unfamiliar codebases
- Requirement analysis before implementation

**BypassPermissions Mode** — Maximum automation for trusted operations. Use with extreme caution.

**Key Practice:** "Rev the engine" by using Plan Mode multiple times to refine Claude's plan before execution. This catches issues early and ensures full requirement understanding.[[2]](https://claudelog.com/faqs/how-to-write-better-prompts-for-claude-code)

## The [CLAUDE.md](http://CLAUDE.md) Pattern: Persistent Project Memory

[`CLAUDE.md`](http://CLAUDE.md) is the most powerful context management tool—everything written here is injected after the system prompt in every session.[[3]](https://www.notion.so/Turn-Claude-Code-into-Your-Own-INCREDIBLE-UI-Designer-using-Playwright-MCP-Subagents-2d60eefc3f5a4e419293e76095e4de44?pvs=21)

### What to Include

**Project Overview**

- Tech stack and framework versions
- Architecture patterns (MVC, microservices, etc.)
- Key dependencies and their purposes
- Build and deployment processes

**Coding Standards**

- Style conventions (naming, formatting)
- Preferred patterns and anti-patterns
- Error handling approaches
- Testing requirements

**Workflow Instructions**

- Automatic validation steps (run tests, check types, lint)
- Git commit conventions
- Documentation requirements
- Review criteria

**Domain Knowledge**

- Business logic constraints
- Security requirements
- Performance considerations
- Common edge cases

### What NOT to Include

- Laundry lists of edge cases (provide canonical examples instead)
- Rigid hardcoded logic (find the Goldilocks zone)
- Outdated information (keep it lean and updated)[[5]](https://www.sidetool.co/post/unlocking-efficiency-claude-code-workflow-best-practices-explained/)
- Verbose documentation (link to external docs instead)

### Example Structure

```markdown
# Project: [Name]

## Tech Stack
- Backend: Node.js + TypeScript + Express
- Database: PostgreSQL with Prisma ORM
- Testing: Jest + Supertest

## Development Workflow

Whenever making changes:
1. Run type check: `npm run type-check`
2. Run tests: `npm test`
3. Run linter: `npm run lint`
4. If all pass, create descriptive commit

## Coding Standards

- Use async/await, never callbacks
- Prefer functional patterns over classes
- All functions must have TypeScript types
- Error handling: throw typed errors, catch at route level

## Common Pitfalls

- Database connections must be closed in finally blocks
- Always validate user input with Zod schemas
- Never log sensitive data (tokens, passwords, PII)
```

## General Workflows for All Development Tasks

### Workflow 1: Plan-Validate-Execute Pattern

The safest approach for complex work:

**Phase 1: Planning** (Plan Mode)

- Activate Plan Mode (Shift+Tab twice)
- Describe the requirement in detail
- Review Claude's analysis and proposed approach
- Iterate on the plan until it's comprehensive and correct
- Ask clarifying questions about edge cases

**Phase 2: Validation Setup**

- Define acceptance criteria
- Identify which tests should pass
- Specify validation steps

**Phase 3: Execution** (Default/AcceptEdits Mode)

- Switch to execution mode
- Let Claude implement the validated plan
- Claude automatically runs validation steps
- Iterate if validation fails

**When to use:** Production bugs, architectural changes, security-sensitive operations, unfamiliar codebases.[[6]](https://lord.technology/2025/07/03/understanding-claude-code-plan-mode-and-the-architecture-of-intent.html)

### Workflow 2: Test-Driven Development Loop

Leverage Claude's ability to read and execute tests:

1. Write failing tests that specify desired behavior
2. Share test file with Claude Code
3. Ask Claude to implement code to make tests pass
4. Claude iterates until all tests pass
5. Refactor with confidence (tests prevent regressions)

**Prompt pattern:** "I've written tests in `tests/feature.test.ts` that currently fail. Please implement the functionality to make all tests pass. Run tests after each change and iterate until they all pass."

### Workflow 3: Incremental Refactoring Strategy

For cleaning up technical debt without breaking things:

**Step 1: Establish Safety Net**

- Ensure comprehensive test coverage
- Document current behavior
- Create feature branch

**Step 2: Refactor in Small Steps**

- Change one thing at a time
- Run tests after each change
- Commit working states frequently

**Step 3: Validate Continuously**

- Type checking
- Linting
- Performance benchmarks (if applicable)

**Prompt pattern:** "Let's refactor the `UserService` class to use dependency injection. Do this incrementally: 1) Add constructor injection without changing behavior 2) Run tests 3) Remove direct dependencies 4) Run tests again. Commit after each successful test run."[[7]](https://www.arsturn.com/blog/how-to-use-claude-code-to-refactor-and-clean-up-your-codebase)

### Workflow 4: Debugging Investigation Pattern

Claude Code excels at debugging because it traces execution paths across files:[[8]](https://claudelog.com/faqs/how-to-use-claude-code-for-debugging)

**Step 1: Error Analysis (Plan Mode)**

- Share error messages, stack traces, and logs
- Let Claude analyze without making changes
- Claude identifies potential root causes
- Review the diagnostic plan

**Step 2: Hypothesis Testing**

- Switch to execution mode
- Test each hypothesis with logging/debugging
- Validate assumptions about code flow

**Step 3: Fix Implementation**

- Implement the validated fix
- Add regression tests
- Verify across affected components

**Prompt pattern:** "I'm getting this error: [paste error]. Use Plan Mode to analyze the root cause by examining the relevant files. Don't make changes yet—just explain what's happening and propose 2-3 potential fixes with trade-offs."

### Workflow 5: Feature Implementation Pipeline

Structured approach for new features:

**Step 1: Requirements Documentation**

- Create `/docs/features/[feature-name].md`
- Document user stories, acceptance criteria, edge cases
- Define API contracts or interface signatures

**Step 2: Architecture Design**

- Use Plan Mode to explore architectural options
- Identify affected modules and dependencies
- Plan file structure and component hierarchy

**Step 3: Test Specification**

- Write test cases based on requirements
- Define integration points
- Specify error conditions

**Step 4: Implementation**

- Execute the plan with validation loops
- Tests guide implementation
- Iterate until acceptance criteria met

**Step 5: Documentation & Review**

- Generate/update API documentation
- Add inline comments for complex logic
- Prepare PR description

### Workflow 6: Codebase Onboarding

Understanding unfamiliar code:

1. Ask Claude to analyze project structure and generate architecture overview
2. Identify key modules and their responsibilities
3. Trace critical user flows across files
4. Document learnings in [`CLAUDE.md`](http://CLAUDE.md) for future reference

**Prompt pattern:** "I'm new to this codebase. Please analyze the structure, identify the main architectural patterns, trace how a user authentication request flows through the system, and create an overview document I can reference."

### Workflow 7: Documentation Generation

Automate tedious documentation:

- API documentation from code
- README updates from recent changes
- Inline comments for complex functions
- Architecture decision records (ADRs)

**Prompt pattern:** "Generate API documentation for all endpoints in `routes/api.ts`. Include request/response schemas, authentication requirements, and example calls. Format as Markdown."

## Advanced Techniques

### Sub-Agents: Building Your AI Development Team

Sub-agents are specialized Claude instances with isolated contexts that handle specific tasks.[[9]](https://www.augmentedswe.com/p/claude-code-orchestration) The main session spawns them, they complete their work, and only their outputs return to the main context.

**Benefits:**

- Prevents context pollution
- Enables parallel work
- Provides specialized expertise
- Maintains focus on discrete tasks

**Common Sub-Agent Patterns:**

**Analyzer Agent** — Reviews code for security, performance, or style issues

- Has access to linting tools, security scanners, documentation
- Returns structured report with severity-ranked findings

**Test Agent** — Writes comprehensive test suites

- Has access to testing frameworks and coverage tools
- Returns test files and coverage reports

**Documentation Agent** — Generates and maintains docs

- Has access to code and existing documentation
- Returns formatted documentation files

**Refactor Agent** — Cleans up technical debt

- Has access to codebase and style guides
- Returns refactored code with test validation

**Implementation:** Create sub-agents with clear tool access, specific models (Sonnet for efficiency, Opus for complex reasoning), explicit input/output formats, and step-by-step methodologies.[[3]](https://www.notion.so/Turn-Claude-Code-into-Your-Own-INCREDIBLE-UI-Designer-using-Playwright-MCP-Subagents-2d60eefc3f5a4e419293e76095e4de44?pvs=21)

### Slash Commands: Reusable Workflow Automation

Create custom commands that standardize team practices:[[10]](https://developertoolkit.ai/en/claude-code/advanced-techniques/)

**Command Types:**

`/review` — Comprehensive code review checklist

- Security vulnerabilities
- Performance bottlenecks
- Style guide compliance
- Test coverage gaps

`/scaffold` — Generate boilerplate for common patterns

- New API endpoints with tests
- React components with stories
- Database migrations with rollbacks

`/security-audit` — Security-focused analysis

- SQL injection risks
- XSS vulnerabilities
- Authentication issues
- Secrets in code

`/optimize` — Performance optimization

- Identify bottlenecks
- Suggest caching strategies
- Database query optimization
- Bundle size reduction

**Benefits:** Consistency across team, reduced cognitive load, automated best practices, onboarding acceleration.

### Hooks: Event-Driven Quality Automation

Automate quality checks at key development points:[[10]](https://developertoolkit.ai/en/claude-code/advanced-techniques/)

**Pre-commit hooks:**

- Type checking
- Linting
- Test execution
- Security scanning

**Pre-push hooks:**

- Full test suite
- Build verification
- Documentation updates

**PR creation hooks:**

- Generate PR descriptions
- Run benchmarks
- Check breaking changes

### Parallel Development with Branching

Take advantage of stochastic model outputs:

1. Create 2-3 git worktrees (separate working directories)
2. Run Claude Code in each with identical or varied prompts
3. Generate multiple implementation approaches
4. Compare results and select the best
5. Advanced: Use another Claude instance to judge quality[[3]](https://www.notion.so/Turn-Claude-Code-into-Your-Own-INCREDIBLE-UI-Designer-using-Playwright-MCP-Subagents-2d60eefc3f5a4e419293e76095e4de44?pvs=21)

**Use cases:** Exploring architectural options, A/B testing UI implementations, finding optimal algorithms.

## Context Engineering: Managing the Most Scarce Resource

With Sonnet 4's 1-million-token context window, you can process entire repositories in a single session—but only with deliberate context management.[[4]](https://zenn.dev/saan/articles/6b4cf8bd87a0f9)

### The Context Budget Problem

Your context window fills with:

- System prompt (2-5%)
- [`CLAUDE.md`](http://CLAUDE.md) contents (variable)
- MCP tool descriptions (10-20% with multiple tools)
- Conversation history (grows continuously)
- File context from @ references (can be massive)
- Tool outputs and logs (accumulates over time)

With overhead, you may have only 40-50% usable context for actual work.

### Context Management Strategies

**Strategy 1: Selective File Loading**

Don't use `@ workspace` or load entire directories unless necessary. Instead:

- Reference specific files with `@filename`
- Use directory references only when reviewing structure
- Ask Claude to identify which files it needs

**Prompt pattern:** "To implement this feature, which files do you need to see? List them and I'll load only those."

**Strategy 2: Conversation Compacting**

Periodically summarize and clear history:[[11]](https://www.notion.so/3-New-Context-Engineering-Skills-for-Agents-fe0457e947fd4b719c67a7c5c19cdd91?pvs=21)

- Use `/compact` (built-in command) to summarize conversation and clear messages
- Retain: key decisions, learned rules, failure patterns, acceptance criteria
- Discard: verbose message history, intermediate iterations, exploratory dead ends

**Warning:** Don't compact too frequently or you'll lose valuable context. Compact when:

- Context usage exceeds 70%
- Switching between major tasks
- Starting a new feature after completing another
- Notice Claude missing recent information

**Strategy 3: External Memory Systems**

Persist information outside active context:[[11]](https://www.notion.so/3-New-Context-Engineering-Skills-for-Agents-fe0457e947fd4b719c67a7c5c19cdd91?pvs=21)

- [`note.md`](http://note.md) — Design decisions, learned patterns, component mappings
- [`architecture.md`](http://architecture.md) — System overview, module relationships
- [`decisions.md`](http://decisions.md) — Architecture Decision Records (ADRs)
- [`progress.md`](http://progress.md) — Status tracking, completed tasks, blockers

Retrieve these files only when needed. Update them as you learn.

**Strategy 4: Sub-Agent Context Isolation**

Delegate tasks to sub-agents with clean contexts:[[11]](https://www.notion.so/3-New-Context-Engineering-Skills-for-Agents-fe0457e947fd4b719c67a7c5c19cdd91?pvs=21)

- Each sub-agent has independent context window
- Only pass inputs, summarized actions, and outputs back to main session
- Don't pass full sub-agent conversations (causes context explosion)

**Critical:** The transformer attention mechanism means not all context is equally accessible. Recent context has more weight. Structure your prompts with important information near the end.[[11]](https://www.notion.so/3-New-Context-Engineering-Skills-for-Agents-fe0457e947fd4b719c67a7c5c19cdd91?pvs=21)

**Strategy 5: Tool Masking**

For production systems, dynamically add/remove MCP tools:[[11]](https://www.notion.so/3-New-Context-Engineering-Skills-for-Agents-fe0457e947fd4b719c67a7c5c19cdd91?pvs=21)

- Expose only tools relevant to current task
- Reduces tool description overhead
- Prevents misuse of inappropriate tools
- Advanced: Use orchestrator agent to manage tool access

### Extended Thinking Budget Control

Claude Code supports extended thinking for complex reasoning:[[4]](https://zenn.dev/saan/articles/6b4cf8bd87a0f9)

- Allocate thinking budget for architectural decisions
- Use higher budgets for novel problems
- Lower budgets for routine tasks
- Monitor thinking usage to optimize costs

**When to use extended thinking:**

- Complex debugging across multiple files
- Architectural design decisions
- Performance optimization strategies
- Security vulnerability analysis

## Model Selection: Sonnet vs. Opus

Choose the right model for the task:[[1]](https://www.anthropic.com/engineering/claude-code-best-practices)

**Use Sonnet (default) for:**

- Routine coding tasks
- Refactoring
- Test writing
- Documentation generation
- Code review
- Bug fixes in familiar code
- Sub-agents (cost efficiency)

**Use Opus for:**

- Complex architectural decisions
- Novel problem-solving
- Debugging mysterious issues
- Cross-cutting refactors
- Performance optimization requiring deep analysis
- Security-critical code

## Best Practices by Task Type

### Planning & Architecture

✅ **Do:**

- Always use Plan Mode first
- Provide business context and constraints
- Ask for multiple architectural options with trade-offs
- Request sequence diagrams or architecture sketches
- Validate against non-functional requirements (performance, security, scalability)

❌ **Don't:**

- Jump straight to implementation
- Assume Claude knows your specific requirements
- Skip considering edge cases and failure modes

**Prompt pattern:** "Design the architecture for [feature]. Consider: 1) Current tech stack constraints 2) Expected scale (1000 concurrent users) 3) Data consistency requirements 4) Deployment to AWS. Provide 2-3 options with trade-offs."

### Coding & Implementation

✅ **Do:**

- Define acceptance criteria before coding
- Provide relevant context (related files, APIs, schemas)
- Specify testing requirements
- Use incremental development (small, tested steps)
- Commit working states frequently

❌ **Don't:**

- Ask for everything at once
- Skip defining expected behavior
- Ignore type safety or linting errors
- Accept code without tests

**Prompt pattern:** "Implement [feature] with these requirements: [list]. Relevant files are @[file1] @[file2]. After implementation, write tests covering happy path and error cases. Run tests to verify."

### Debugging & Troubleshooting

✅ **Do:**

- Use Plan Mode for analysis first
- Provide complete error messages and stack traces
- Include relevant logs and console output
- Share configuration files if relevant
- Ask Claude to explain what it finds before fixing

❌ **Don't:**

- Just say "it's broken" without details
- Make assumptions about root cause
- Skip adding regression tests
- Rush to first solution without understanding why

**Prompt pattern:** "Debug this error: [paste full error]. Relevant code in @[file]. Use Plan Mode to: 1) Trace execution path 2) Identify where it breaks 3) Explain root cause 4) Propose 2-3 fixes with pros/cons. Don't implement yet."

### Refactoring & Code Quality

✅ **Do:**

- Ensure comprehensive test coverage first
- Refactor incrementally (one pattern at a time)
- Define specific goals (reduce complexity, improve readability, extract reusable code)
- Run tests after each change
- Commit frequently

❌ **Don't:**

- Refactor without tests (recipe for breaking things)
- Change too much at once
- Refactor just for the sake of it (focus on measurable improvements)
- Skip validating performance impact

**Prompt pattern:** "Refactor @[file] to [specific goal]. Current test coverage in @[test-file]. Refactor incrementally: make one change, run tests, commit if passing, then move to next change. Preserve all existing behavior."

### Testing & Quality Assurance

✅ **Do:**

- Specify test coverage requirements (unit, integration, e2e)
- Request tests for edge cases and error conditions
- Ask for meaningful assertions (not just "it doesn't crash")
- Include tests in PR commits

❌ **Don't:**

- Accept superficial tests
- Skip integration tests for critical paths
- Ignore flaky tests
- Test implementation details instead of behavior

**Prompt pattern:** "Write comprehensive tests for @[file]. Include: 1) Happy path tests 2) Edge cases [list specific ones] 3) Error handling 4) Integration tests for [feature]. Achieve >90% coverage. Run tests to verify they pass."

### Documentation

✅ **Do:**

- Generate docs from code (single source of truth)
- Specify format and audience (API docs, user guides, developer onboarding)
- Request examples and common use cases
- Keep docs versioned with code

❌ **Don't:**

- Write docs manually when they can be generated
- Skip updating docs when code changes
- Create docs without examples

**Prompt pattern:** "Generate API documentation for @[routes-file]. Include: 1) Endpoint descriptions 2) Request/response schemas 3) Authentication requirements 4) Example requests with curl 5) Common error codes. Format as Markdown for Docusaurus."

## Common Pitfalls & Solutions

### Pitfall 1: Claude "Forgets" Recent Context

**Cause:** Context window filling up, important information buried in conversation history.

**Solution:**

- Compact conversation with `/compact`
- Re-state critical requirements in your next prompt
- Move important info to [`CLAUDE.md`](http://CLAUDE.md)
- Use external memory files for complex state

### Pitfall 2: Claude Hallucinates Libraries or APIs

**Cause:** Confident generation without verification, outdated training data.

**Solution:**

- Request verification: "Before using any library, verify it exists and check the correct API in the documentation"
- Provide official documentation links
- Use Plan Mode to review approach before implementation
- Add validation step: "After implementation, verify all imports and APIs are real"

### Pitfall 3: Changes Break Unrelated Code

**Cause:** Insufficient context about dependencies, skipped testing.

**Solution:**

- Always run full test suite after changes
- Use Plan Mode to identify affected code
- Request impact analysis: "What other parts of the codebase might this affect?"
- Enable hooks for automatic testing

### Pitfall 4: Solutions Are Too Generic

**Cause:** Insufficient domain context, unclear requirements.

**Solution:**

- Populate [`CLAUDE.md`](http://CLAUDE.md) with domain knowledge
- Provide concrete examples of desired behavior
- Share business constraints and edge cases
- Request clarifying questions from Claude

### Pitfall 5: Code Doesn't Match Project Style

**Cause:** Claude doesn't know your conventions.

**Solution:**

- Document style guide in [`CLAUDE.md`](http://CLAUDE.md)
- Provide example files that match your style
- Enable linting with automatic fixing
- Request style-specific implementation: "Follow the patterns in @[example-file]"

### Pitfall 6: Slow Iteration Cycles

**Cause:** Waiting for permission on every action, inefficient mode usage.

**Solution:**

- Use AcceptEdits mode for trusted operations
- Batch related changes: "Make all these changes together"
- Set up automatic validation in [`CLAUDE.md`](http://CLAUDE.md)
- Use slash commands for common workflows

## Advanced Prompting Techniques

### Technique 1: Constrained Generation

Specify exact constraints to prevent unwanted changes:

"Implement [feature] with these constraints:

- Don't modify files outside /src/features/[name]
- Don't change existing API contracts
- Don't introduce new dependencies
- Use existing utility functions from @utils"

### Technique 2: Comparative Analysis

Ask for trade-off analysis:

"Compare these 3 approaches for [problem]:

1. [Approach A]
2. [Approach B]
3. [Approach C]

For each, analyze: performance, maintainability, testability, complexity. Recommend the best option with rationale."

### Technique 3: Socratic Method

Let Claude ask questions to clarify requirements:

"I need to implement [vague feature description]. Before you start, ask me 5 clarifying questions to fully understand the requirements."

### Technique 4: Think-Aloud Debugging

Request explicit reasoning:

"Debug [issue] by thinking aloud. For each step:

1. State your hypothesis
2. Explain what you're checking
3. Report what you found
4. Explain what it means

Only propose a fix after completing this analysis."

### Technique 5: Code Review Checklist

Systematic quality validation:

"Review @[file] against this checklist:

- [ ]  Type safety (no 'any' types)
- [ ]  Error handling (all promises caught)
- [ ]  Test coverage (>80%)
- [ ]  Performance (no N+1 queries)
- [ ]  Security (input validation, SQL injection prevention)
- [ ]  Documentation (JSDoc on public functions)

For each item, mark pass/fail and explain issues."

### Technique 6: Progressive Disclosure

Reveal complexity gradually:

"First, implement the happy path for [feature]. Once that works, we'll handle error cases. After that, we'll optimize performance."

## Measuring Effectiveness

Track these metrics to improve your Claude Code usage:

**Cycle Time Reduction**

- Time from feature request to working code
- Compare before/after Claude Code adoption

**Code Quality Metrics**

- Test coverage (target: >80%)
- Linting violations (should decrease)
- Bug density (issues per 1000 lines)
- Code review iteration count

**Developer Satisfaction**

- Reduction in tedious tasks (boilerplate, docs)
- Confidence in AI-generated code
- Time saved on debugging

**Context Efficiency**

- Average context usage per task
- Number of compacts per session
- Sub-agent utilization rate

## Key Takeaways

**1. Think in Workflows, Not Prompts**

Structured workflows (plan → validate → execute) produce better results than trying to do everything in one prompt.

**2. Use Plan Mode Liberally**

Analysis without risk prevents costly mistakes. Rev the engine multiple times before executing.

**3. Context is Your Scarcest Resource**

Manage it deliberately with compacting, external memory, and sub-agents. Don't let it rot.

**4. Validation is Non-Negotiable**

Always run tests, type checks, and linters. Build validation into [`CLAUDE.md`](http://CLAUDE.md) workflows.

**5. Iterate Incrementally**

Small, tested steps with frequent commits beat big-bang changes every time.

**6. Specialize with Sub-Agents**

Create focused AI experts for common tasks. Build your AI development team.

**7. Document Once, Benefit Forever**

Time invested in [`CLAUDE.md`](http://CLAUDE.md) pays dividends in every future session.

**8. The Tool is Low-Level by Design**

Claude Code's unopinionated nature is a feature. Build the workflows that work for you.

## Getting Started Checklist

**Initial Setup:**

- [ ]  Install Claude Code and configure permissions
- [ ]  Create [`CLAUDE.md`](http://CLAUDE.md) with project overview and tech stack
- [ ]  Document coding standards and style guide
- [ ]  Set up automatic validation workflows
- [ ]  Configure relevant MCP tools

**First Feature:**

- [ ]  Use Plan Mode to design approach
- [ ]  Define acceptance criteria
- [ ]  Implement incrementally with test validation
- [ ]  Review and refine [`CLAUDE.md`](http://CLAUDE.md) based on learnings

**Scaling Up:**

- [ ]  Create sub-agents for common tasks (testing, documentation, review)
- [ ]  Build slash commands for team workflows
- [ ]  Set up hooks for automated quality checks
- [ ]  Establish context management patterns

**Continuous Improvement:**

- [ ]  Track metrics (cycle time, quality, satisfaction)
- [ ]  Refine [`CLAUDE.md`](http://CLAUDE.md) based on failure patterns
- [ ]  Share learnings across team
- [ ]  Iterate on workflows

## Conclusion

Claude Code is not just a code generator—it's a flexible, powerful development partner that becomes more effective with systematic workflow engineering. The most successful practitioners move beyond prompt engineering to build orchestrated systems with proper context management, validation loops, and specialized sub-agents.

Success comes from treating Claude Code as a power tool that amplifies your expertise, not replaces it. You provide the requirements, domain knowledge, and architectural vision. Claude Code handles the implementation details, testing, documentation, and iterative refinement.

The key is deliberate practice: start with simple tasks, build your [`CLAUDE.md`](http://CLAUDE.md), develop workflows, and continuously refine your approach based on what works in your specific context.
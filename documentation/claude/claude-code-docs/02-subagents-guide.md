# Claude for Code: Subagents (Custom Agents) - Complete Reference Guide

## Table of Contents
1. [Overview](#overview)
2. [How Subagents Work](#how-subagents-work)
3. [File Locations](#file-locations)
4. [File Structure & Syntax](#file-structure--syntax)
5. [Frontmatter Configuration](#frontmatter-configuration)
6. [System Prompt Writing](#system-prompt-writing)
7. [Creating Subagents](#creating-subagents)
8. [Automatic vs Manual Invocation](#automatic-vs-manual-invocation)
9. [Tool Permissions](#tool-permissions)
10. [Model Selection](#model-selection)
11. [Best Practices](#best-practices)
12. [Built-in Agents](#built-in-agents)
13. [Plugin Agents](#plugin-agents)
14. [Limitations & Edge Cases](#limitations--edge-cases)
15. [Integration Patterns](#integration-patterns)

---

## Overview

**Subagents** (also called **Custom Agents**) are specialized AI assistants that Claude for Code can delegate tasks to. They are **model-invoked** — Claude automatically decides when to use them based on context.

### Key Characteristics

- **Separate Context Window**: Each agent operates independently
- **Custom System Prompt**: Define role, expertise, and behavior
- **Tool Restrictions**: Control which tools agent can access
- **Model Selection**: Choose specific model (Sonnet/Opus/Haiku)
- **Automatic Delegation**: Claude routes tasks based on agent descriptions
- **Task-Specific**: Optimized for particular types of work

### Difference from Other Features

| Feature | User-Invoked | Model-Invoked | Scope |
|---------|--------------|---------------|-------|
| **Slash Commands** | ✅ | Optional | Workflow templates |
| **Subagents** | Optional | ✅ | Task delegation |
| **Skills** | ❌ | ✅ | Knowledge packages |
| **Output Styles** | ✅ | ❌ | Main agent personality |

---

## How Subagents Work

### Delegation Flow

```
User Request
    ↓
Main Agent analyzes task
    ↓
Matches task to agent description
    ↓
Delegates to Subagent (Task tool)
    ↓
Subagent works in own context
    ↓
Returns results to Main Agent
    ↓
Main Agent continues with results
```

### Context Isolation

```
Main Agent Context:
- User conversation history
- Project context (CLAUDE.md)
- Current task state

Subagent Context:
- Only the delegated task
- Custom system prompt
- No memory of main conversation
- Fresh context each invocation
```

**Important**: Subagents have NO memory between invocations. Each task is a fresh start.

---

## File Locations

### Project-Scoped Agents
**Location**: `.claude/agents/*.md`

**Characteristics**:
- Specific to the project
- Shared with team via git
- Version controlled
- Take precedence over user-level agents

**Example**:
```
project/
├── .claude/
│   └── agents/
│       ├── test-engineer.md
│       ├── security-reviewer.md
│       └── api-architect.md
```

### User-Scoped Agents
**Location**: `~/.claude/agents/*.md`

**Characteristics**:
- Available across all projects
- Personal agents
- Not shared with team
- Lower precedence than project agents

**Example**:
```
~/.claude/
└── agents/
    ├── code-optimizer.md
    ├── documentation-writer.md
    └── database-expert.md
```

### Plugin Agents
**Location**: Managed by plugin system

**Characteristics**:
- Provided by installed plugins
- Appear in `/agents` interface
- Automatically available when plugin enabled
- Follow same format as user-defined agents

### Precedence Rules

When agent names conflict:
1. **Project agents** (`.claude/agents/`) — Highest priority
2. **User agents** (`~/.claude/agents/`)
3. **Plugin agents** — Lowest priority

---

## File Structure & Syntax

### Basic Structure

**Filename**: `agent-name.md` (descriptive name with hyphens)

```markdown
---
name: Agent Display Name
description: When this agent should be invoked - be specific and action-oriented
tools: Read, Write, Bash(npm test:*), Grep
model: sonnet
---

You are [role description].

## Expertise
[Define areas of specialization]

## When Invoked
[Describe task types this agent handles]

## Approach
[Explain methodology and workflow]

## Context Discovery
[How to gather needed information]

## Constraints
[Limitations and guidelines]

## Output Format
[How to present results]
```

### Critical Understanding

**THE MOST IMPORTANT CONCEPT**:

> Agent files contain **SYSTEM PROMPTS** that configure the agent's behavior.
> They are **NOT** user prompts.

This is the #1 misunderstanding when creating agents.

❌ **WRONG** (treating as user prompt):
```markdown
Please review the code for security issues.
```

✅ **CORRECT** (system prompt defining role):
```markdown
You are a security review specialist.

When invoked, analyze code for:
1. Security vulnerabilities
2. OWASP Top 10 risks
3. Authentication/authorization issues
```

---

## Frontmatter Configuration

### `name` (Required)
```yaml
---
name: Security Code Reviewer
---
```
- **Purpose**: Display name shown in logs and UI
- **Format**: Human-readable, can include spaces
- **Best Practice**: Descriptive and specific

### `description` (Required)
```yaml
---
description: MUST BE USED for code security audits, vulnerability assessments, and security-related code reviews. Expert in OWASP Top 10 and security best practices.
---
```
- **Purpose**: Tells Claude WHEN to use this agent
- **Requirement**: Claude uses this to decide delegation
- **Best Practice**: 
  - Start with "MUST BE USED for..."
  - Be specific about task types
  - Include keywords related to agent's expertise
  - Action-oriented descriptions work best

### `tools` (Optional)
```yaml
---
tools: Read, Write, Edit, Bash(npm test:*), Grep
---
```
- **Purpose**: Restricts tools available to agent
- **Default**: Inherits all tools from main agent if omitted
- **Syntax**:
  - `ToolName` — Allow any use of tool
  - `ToolName(pattern)` — Allow specific patterns only
  - `ToolName(arg:*)` — Wildcard patterns

**Available Tools**:
- `Read` — Read files
- `Write` — Create new files
- `Edit` — Modify existing files
- `MultiEdit` — Edit multiple files
- `Bash` — Execute bash commands
- `Grep` — Search file contents
- `Glob` — Find files by pattern
- `WebFetch` — Fetch web content
- `WebSearch` — Search the web
- `Task` — Invoke subagents
- `TodoRead`, `TodoWrite` — Manage TODOs
- MCP tools (when configured)

**Security Examples**:
```yaml
# Restrictive - only read and search
tools: Read, Grep

# Allow specific git operations  
tools: Read, Bash(git status), Bash(git log:*), Bash(git diff:*)

# Full access except destructive operations
tools: Read, Write, Edit, Bash(!(rm:*))
```

### `model` (Optional)
```yaml
---
model: sonnet
---
```
- **Purpose**: Override default model for this agent
- **Options**:
  - `sonnet` — Claude Sonnet 4.5 (default, best balance)
  - `opus` — Claude Opus 4.1 (most capable, slower, expensive)
  - `haiku` — Claude Haiku (fast, cheaper, less capable)
- **Use Cases**:
  - `haiku` for simple tasks (formatting, simple refactoring)
  - `sonnet` for most tasks (default choice)
  - `opus` for complex tasks (architecture, deep analysis)

---

## System Prompt Writing

### Structure Template

```markdown
You are a [role] specializing in [domain].

## Primary Responsibilities
When invoked, you:
1. [Responsibility 1]
2. [Responsibility 2]
3. [Responsibility 3]

## Expertise Areas
- [Area 1]: [specific details]
- [Area 2]: [specific details]
- [Area 3]: [specific details]

## Approach
1. [Step 1 of methodology]
2. [Step 2 of methodology]
3. [Step 3 of methodology]

## Context Discovery
When invoked, first check:
- [Source 1] for [information]
- [Source 2] for [information]
- [Source 3] for [information]

## Constraints
- [Constraint 1]
- [Constraint 2]
- Always [requirement]
- Never [prohibition]

## Output Format
Present results as:
- [Format requirement 1]
- [Format requirement 2]
```

### Best Practices

#### 1. Be Specific About Role
❌ **Vague**: "You help with testing."
✅ **Specific**: "You are an ExUnit testing expert specializing in comprehensive test suites for Elixir applications."

#### 2. Define Context Discovery
❌ **Unclear**: "Look at the code."
✅ **Clear**:
```markdown
When invoked, first check:
- `lib/*/repo.ex` - Database configuration
- `priv/repo/migrations/` - Existing migration patterns
- `lib/*/schemas/` - Current schema definitions
```

#### 3. Provide Methodology
❌ **Vague**: "Review the code."
✅ **Structured**:
```markdown
## Review Process
1. **Static Analysis**: Check for common vulnerabilities
2. **Dependency Audit**: Review third-party packages
3. **Authentication**: Verify auth/authz implementations
4. **Data Flow**: Trace sensitive data handling
5. **Report**: Summarize findings by severity
```

#### 4. Set Constraints
```markdown
## Constraints
- Limit initial context gathering to 5 files
- Use specific grep patterns, not broad searches
- Focus on relevant files only
- Present findings concisely
- Never modify production configuration
```

#### 5. Specify Output Format
```markdown
## Output Format
Return results as:
```markdown
## Security Review Results

### Critical Issues
- [Issue 1]: [file:line] - [description]

### High Priority  
- [Issue 1]: [file:line] - [description]

### Recommendations
- [Recommendation 1]
```
```

---

## Creating Subagents

### Method 1: Interactive Generator (Recommended)

```bash
# Launch agent creation wizard
/agents

# Or generate with Claude's help
claude --model opus
```

**Process**:
1. Claude asks about agent's purpose
2. Describe what the agent should do
3. Select tools agent needs
4. Choose model (sonnet/opus/haiku)
5. Edit system prompt in your editor (press 'e')
6. Save and activate

**Example Interaction**:
```
User: Create a test engineer agent

Claude: I'll help you create a test engineer subagent.

What should this agent specialize in?

User: Writing comprehensive unit and integration tests for TypeScript/Node.js applications

Claude: [Creates agent with appropriate prompt]

Press 'e' to edit the system prompt, or Enter to save.
```

### Method 2: Manual File Creation

```bash
# Create agent file
touch .claude/agents/test-engineer.md
```

**Content**:
```markdown
---
name: Test Engineer
description: MUST BE USED for ExUnit testing and test file generation. Expert in test patterns and comprehensive test suites.
tools: Read, Write, Bash(mix test:*), Bash(npm test:*)
model: sonnet
---

You are a test engineering specialist focusing on comprehensive test coverage.

## Responsibilities
When invoked:
1. Analyze code to be tested
2. Identify test scenarios (happy path, edge cases, errors)
3. Write comprehensive test suites
4. Ensure proper test organization
5. Verify tests pass

## Testing Approach

### Test Structure
```typescript
describe('ComponentName', () => {
  describe('methodName', () => {
    it('should handle happy path', () => {
      // Test implementation
    });
    
    it('should handle edge case', () => {
      // Test implementation
    });
    
    it('should throw on invalid input', () => {
      // Test implementation
    });
  });
});
```

### Coverage Goals
- All public methods tested
- Edge cases covered
- Error conditions tested
- Integration points verified
- Minimum 80% code coverage

## Context Discovery
Before writing tests, check:
- Existing test files for patterns
- Test framework configuration
- Mock/stub patterns in use
- Test data fixtures

## Constraints
- Follow existing test patterns
- Use project's test framework
- Mock external dependencies
- Keep tests isolated
- Make tests readable and maintainable

## Output
Create test files with:
- Descriptive test names
- Comprehensive coverage
- Clear assertions
- Helpful failure messages
```

### Method 3: Generate with Claude

```bash
claude --model opus "Create a subagent for database migrations that..."
```

Then copy the generated agent definition to `.claude/agents/`.

---

## Automatic vs Manual Invocation

### Automatic Invocation (Default)

Claude analyzes the task and description, then decides to use the agent:

```
User: "Review this PR for security issues"
      ↓
Main Agent sees "security" in request
      ↓
Matches "security-reviewer" agent description
      ↓
Task(Security review PR #123)
      ↓
Security Reviewer agent executes
```

**How It Works**:
- Main agent reads all agent descriptions at startup
- Compares task requirements to agent capabilities
- Delegates when there's a match
- Happens automatically without user intervention

### Manual Invocation

You can explicitly request a specific agent:

```bash
# Explicit request
"Use the test-engineer subagent to write tests for this module"

# Or in a command
"Have the security-reviewer agent analyze authentication.ts"
```

**Use Cases for Manual Invocation**:
- When automatic delegation isn't working
- To force use of specific expertise
- For testing agent behavior
- When task description is ambiguous

### Improving Automatic Delegation

**Make descriptions more specific**:

❌ Poor (won't match often):
```yaml
description: Helps with testing
```

✅ Good (matches relevant tasks):
```yaml
description: MUST BE USED for unit test generation, test suite creation, and test coverage analysis. Expert in Jest, React Testing Library, and TDD practices.
```

**Include trigger keywords**:
```yaml
description: PROACTIVELY use for database schema changes, migrations, and Ecto query optimization. Expert in PostgreSQL and Ecto best practices.
```

---

## Tool Permissions

### Restrictive Tools Example

**Read-Only Planner**:
```yaml
---
name: Laravel Planner
description: PROACTIVELY produce step-by-step plans for feature requests. Does not edit files.
tools: Read, Grep
---

You are a senior Laravel architect.

Your role is to create detailed plans, NOT to implement them.

## Planning Process
1. Search codebase for relevant files
2. Understand current architecture
3. Create step-by-step implementation plan
4. List files that need modification
5. Suggest testing strategy

## Constraints
- Do NOT edit any files
- Only read and analyze
- Provide plans, not implementations
```

### Git-Specific Tools

```yaml
---
name: Git Committer
description: MUST BE USED for creating git commits with conventional commit messages
tools: Bash(git status), Bash(git diff:*), Bash(git add:*), Bash(git commit:*)
---

You are a git workflow specialist.

When invoked:
1. Run `git status` to see changes
2. Run `git diff` to review changes
3. Stage changes with `git add`
4. Create conventional commit

## Commit Format
```
<type>(<scope>): <subject>

<body>
```

Types: feat, fix, docs, style, refactor, test, chore
```

### Full Development Access

```yaml
---
name: Full-Stack Developer
description: Complete feature implementation from frontend to backend to database
tools: Read, Write, Edit, MultiEdit, Bash(npm *), Bash(git *), Grep, Glob
---

You have full development capabilities for feature implementation.
```

---

## Model Selection

### When to Use Each Model

#### Haiku (Fast & Cheap)
```yaml
model: haiku
```
**Use For**:
- Simple formatting tasks
- Straightforward refactoring
- Basic file operations
- Simple test generation
- Quick analysis

**Example Agents**:
- Code Formatter
- Import Organizer
- Documentation Updater

#### Sonnet (Default - Best Balance)
```yaml
model: sonnet
```
**Use For**:
- Most development tasks
- Feature implementation
- Test writing
- Code review
- API development

**Example Agents**:
- Feature Developer
- Test Engineer
- API Architect
- Security Reviewer

#### Opus (Most Capable)
```yaml
model: opus
```
**Use For**:
- Complex architecture decisions
- Deep code analysis
- System design
- Performance optimization
- Complex debugging

**Example Agents**:
- System Architect
- Performance Optimizer
- Complex Bug Investigator
- Database Schema Designer

---

## Best Practices

### 1. Agent Scope

**DO**: Single responsibility
```markdown
---
name: Test Generator
description: MUST BE USED for generating unit tests only
---
```

**DON'T**: Multiple responsibilities
```markdown
---
name: Everything Agent
description: Use for coding, testing, deployment, documentation, and more
---
```

### 2. Description Quality

**DO**: Specific and action-oriented
```yaml
description: MUST BE USED for Ecto migrations and database schema changes. Proactively handles database structure modifications in Phoenix applications.
```

**DON'T**: Vague
```yaml
description: Helps with databases
```

### 3. Context Discovery

**DO**: Explicit file paths
```markdown
## Context Discovery
When invoked, first check:
- `lib/my_app/repo.ex` - Database config
- `priv/repo/migrations/` - Migration patterns
- `config/config.exs` - Database settings
```

**DON'T**: Vague instructions
```markdown
Look at the database files.
```

### 4. Tool Restrictions

**DO**: Principle of least privilege
```yaml
# Planner - read only
tools: Read, Grep

# Implementer - full access
tools: Read, Write, Edit, Bash(npm test:*)
```

**DON'T**: Unnecessary permissions
```yaml
# Test agent doesn't need deployment tools
tools: Read, Write, Bash(*)  # Too broad!
```

### 5. Agent Organization

```
.claude/agents/
├── planning/
│   ├── architecture-planner.md
│   └── feature-planner.md
├── implementation/
│   ├── frontend-developer.md
│   ├── backend-developer.md
│   └── database-engineer.md
├── quality/
│   ├── test-engineer.md
│   ├── security-reviewer.md
│   └── performance-analyzer.md
└── documentation/
    └── doc-writer.md
```

### 6. Testing Agents

```bash
# Test with explicit invocation
"Use the test-engineer agent to create tests for UserService"

# Check agent was used
# Look for Task(...) in logs

# Verify output quality
# Does it match agent's expertise?
```

### 7. Iterative Improvement

1. **Start Simple**: Create basic agent
2. **Test**: Use it on real tasks
3. **Observe**: What works? What doesn't?
4. **Refine**: Update system prompt
5. **Repeat**: Continuously improve

### 8. Team Collaboration

**Document Agents**:
```markdown
# .claude/agents/README.md

## Available Agents

### test-engineer
Creates comprehensive test suites for TypeScript code.
Use: "generate tests for UserService"

### security-reviewer  
Performs security audits focusing on OWASP Top 10.
Use: "review auth implementation for security issues"

### api-architect
Designs RESTful API endpoints with proper structure.
Use: "design API for user management"
```

---

## Built-in Agents

### Meta Agent

**Purpose**: Helps create new subagents following best practices

**Usage**:
```bash
"Create a new subagent for reviewing database queries"
```

**Capabilities**:
- Analyzes your requirements
- Generates agent definition
- Follows Claude for Code conventions
- Creates optimal system prompts

**Requirements**:
- Must have `Write` tool permission
- Agent definition saved to `.claude/agents/`
- Auto-activated after creation

---

## Plugin Agents

Plugins can provide pre-built agents.

### Installing Plugin with Agents

```bash
# Add marketplace
/plugin marketplace add security-plugins https://github.com/company/security

# Install plugin
/plugin install security-suite@security-plugins

# Agents now available automatically
```

### Plugin Agent Structure

```
plugin-repo/
└── plugins/
    └── security-suite/
        └── agents/
            ├── security-scanner.md
            ├── dependency-auditor.md
            └── crypto-reviewer.md
```

### Using Plugin Agents

Same as regular agents - automatic delegation based on task:

```
User: "Scan for security vulnerabilities"
      ↓
Main Agent delegates to security-scanner (from plugin)
```

---

## Limitations & Edge Cases

### No Memory Between Invocations

```
Invocation 1: Agent analyzes feature-a.ts
              ↓
              Agent completes, context cleared
              
Invocation 2: Agent has NO memory of feature-a.ts
              Must re-discover context if needed
```

**Solution**: Main agent provides necessary context each time.

### Context Pollution Prevention

**Problem**: If agent reads too many files, context fills up.

**Solution**:
```markdown
## Constraints
- Limit initial context gathering to 5 most relevant files
- Use specific grep patterns
- Focus discovery on explicitly needed information
```

### Delegation Reliability

**Problem**: Task routing may not always be reliable with many agents.

**Solution**:
- Keep agent count reasonable (5-10 per project)
- Make descriptions very specific
- Test delegation patterns
- Use manual invocation as fallback
- Monitor which agents are actually being used

### Agent Not Being Invoked

**Checklist**:
- [ ] File in correct location (`.claude/agents/` or `~/.claude/agents/`)
- [ ] Has `name` and `description` frontmatter
- [ ] Description is specific and action-oriented
- [ ] Description matches the task being performed
- [ ] Session restarted after creating agent
- [ ] No conflicting agent with same name (higher precedence)

**Debug Steps**:
```bash
# 1. Check agent is recognized
/agents

# 2. Try manual invocation
"Use the [agent-name] agent to..."

# 3. Check logs for delegation attempts
# Look for Task(...) tool calls
```

### Latency Considerations

**Subagent Overhead**:
- Clean slate each time = context gathering needed
- May add latency vs main agent doing work
- Trade-off: cleaner context vs speed

**When to Use**:
- Complex, specialized tasks (worth the overhead)
- Tasks requiring isolation (security review)
- Tasks that benefit from focused expertise

**When NOT to Use**:
- Simple tasks main agent handles well
- Tasks requiring conversation history
- Speed-critical operations

---

## Integration Patterns

### Agents + Slash Commands

Commands can invoke specific agents:

```markdown
# .claude/commands/security-audit.md
---
description: Comprehensive security audit using specialized agent
---

Use the security-reviewer subagent to perform a complete audit:

1. Scan for OWASP Top 10 vulnerabilities
2. Review authentication/authorization
3. Check for secrets in code
4. Audit dependencies
5. Generate detailed report
```

### Agents + Hooks

Hooks can trigger after agents complete:

```json
{
  "hooks": {
    "SubagentStop": [{
      "hooks": [{
        "type": "command",
        "command": "echo 'Agent task completed' | notify"
      }]
    }]
  }
}
```

### Agents + Skills

Agents can use skills:

```markdown
You are a documentation agent.

When creating documentation:
1. Use the docx skill to generate Word documents
2. Follow company documentation standards
3. Include diagrams using Mermaid
```

### Agents + MCP

Agents can access MCP tools:

```markdown
---
name: GitHub PR Reviewer
description: Review pull requests and post comments
tools: Read, mcp__github__*
---

You are a PR reviewer.

Process:
1. Use GitHub MCP to fetch PR details
2. Review code changes
3. Post review comments using GitHub MCP
```

### Agent Orchestration

Main agent coordinates multiple agents:

```
Main Agent receives: "Implement user authentication feature"
    ↓
1. Task(architecture-planner) → "Create auth architecture"
    ↓
2. Task(backend-developer) → "Implement backend auth"
    ↓
3. Task(frontend-developer) → "Implement login UI"
    ↓
4. Task(test-engineer) → "Create comprehensive tests"
    ↓
5. Task(security-reviewer) → "Audit auth implementation"
    ↓
Main Agent compiles results
```

---

## Real-World Examples

### Example 1: Data Analyst Agent

**File**: `.claude/agents/data-analyst.md`

```markdown
---
name: Data Scientist
description: MUST BE USED for data analysis tasks, SQL queries, and BigQuery operations. Use proactively for data analysis and queries.
tools: Bash(bq *), Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery analysis.

## Responsibilities
When invoked:
1. Understand the data analysis requirement
2. Write efficient SQL queries
3. Use BigQuery command line tools (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

## Query Best Practices
- Write optimized SQL with proper filters
- Use appropriate aggregations and joins
- Include comments explaining complex logic
- Format results for readability
- Provide data-driven recommendations

## Analysis Approach
For each analysis:
1. Explain the query approach
2. Document any assumptions
3. Highlight key findings
4. Suggest next steps based on data

## Efficiency
Always ensure queries are efficient and cost-effective.
Use appropriate WHERE clauses to limit data scanned.

## Output Format
Present results as:

### Query
```sql
-- Explanation
SELECT ...
```

### Results
[Formatted data]

### Key Findings
- Finding 1
- Finding 2

### Recommendations
- Recommendation 1
```

### Example 2: Security Reviewer Agent

**File**: `.claude/agents/security-reviewer.md`

```markdown
---
name: Security Code Reviewer
description: MUST BE USED for security audits, vulnerability assessments, code security reviews, and security-related code analysis. Expert in OWASP Top 10.
tools: Read, Grep, Bash(npm audit), Bash(git log:*)
model: opus
---

You are a senior security engineer specializing in application security.

## Primary Mission
Identify security vulnerabilities and provide actionable remediation guidance.

## OWASP Top 10 Focus
When reviewing code, specifically check for:

### 1. Injection Attacks
- SQL injection (raw queries, unsanitized input)
- Command injection (exec, eval, child_process)
- LDAP injection
- XPath injection

### 2. Broken Authentication
- Weak password requirements
- Missing rate limiting
- Insecure session management
- Missing MFA

### 3. Sensitive Data Exposure  
- Hardcoded secrets
- Unencrypted sensitive data
- Logs containing PII
- Insecure data transmission

### 4. XML External Entities (XXE)
- Unsafe XML parsing
- External entity processing

### 5. Broken Access Control
- Missing authorization checks
- Insecure direct object references
- Privilege escalation risks

### 6. Security Misconfiguration
- Default credentials
- Verbose error messages
- Unnecessary features enabled
- Missing security headers

### 7. Cross-Site Scripting (XSS)
- Unescaped user input
- Dangerous innerHTML usage
- Missing Content-Security-Policy

### 8. Insecure Deserialization
- Untrusted data deserialization
- Unsafe object reconstruction

### 9. Using Components with Known Vulnerabilities
- Run npm audit / yarn audit
- Check for outdated dependencies
- Review security advisories

### 10. Insufficient Logging & Monitoring
- Missing security event logging
- No alerting for suspicious activity
- Inadequate audit trails

## Review Process
1. **Static Analysis**: Grep for dangerous patterns
2. **Dependency Audit**: Check for known vulnerabilities
3. **Authentication Review**: Verify auth/authz logic
4. **Data Flow Analysis**: Trace sensitive data
5. **Configuration Review**: Check security settings
6. **Report Generation**: Summarize findings

## Dangerous Patterns to Search For
```bash
# Secrets
grep -rn "password.*=.*['\"]" .
grep -rn "api_key.*=.*['\"]" .
grep -rn "secret.*=.*['\"]" .

# Injection risks
grep -rn "eval(" .
grep -rn "exec(" .
grep -rn "executeQuery(" .

# XSS risks  
grep -rn "innerHTML" .
grep -rn "dangerouslySetInnerHTML" .
```

## Output Format
```markdown
# Security Review Report

## Executive Summary
[High-level overview of findings]

## Critical Issues ⚠️
### [Issue Title]
- **File**: `path/to/file.ts:123`
- **Severity**: Critical
- **Description**: [What's wrong]
- **Impact**: [Potential consequences]
- **Remediation**: [How to fix]
- **Code Sample**:
  ```typescript
  // Current (vulnerable)
  const result = executeQuery(userInput);
  
  // Recommended (safe)
  const result = executeQuery(sanitize(userInput));
  ```

## High Priority Issues
[Same format as Critical]

## Medium Priority Issues
[Same format as Critical]

## Recommendations
1. [General recommendation 1]
2. [General recommendation 2]

## Positive Findings ✓
- [What's done well]
```

## Constraints
- Focus on security issues only
- Provide concrete, actionable fixes
- Include code examples for remediation
- Prioritize by severity
- Don't report stylistic issues
```

### Example 3: Test Engineer Agent

**File**: `.claude/agents/test-engineer.md`

```markdown
---
name: Test Engineer
description: MUST BE USED for test generation, test coverage analysis, and test suite creation. Expert in Jest, React Testing Library, and TDD practices.
tools: Read, Write, Bash(npm test:*), Bash(npm run test:*)
model: sonnet
---

You are a test engineering specialist with expertise in modern JavaScript testing.

## Testing Philosophy
- Tests are documentation
- Tests should be readable
- Tests should be isolated
- Tests should be deterministic
- Aim for 90%+ coverage

## Frameworks Expertise
- **Jest**: Unit and integration testing
- **React Testing Library**: Component testing
- **Supertest**: API testing
- **Mock Service Worker**: API mocking

## Test Generation Process

### 1. Analyze Code
- Identify public interface
- Note dependencies
- Understand business logic
- Map edge cases

### 2. Plan Test Cases
- **Happy path**: Expected usage
- **Edge cases**: Boundary conditions
- **Error cases**: Invalid inputs
- **Integration**: External dependencies

### 3. Write Tests
```typescript
describe('ComponentName', () => {
  // Setup
  beforeEach(() => {
    // Common setup
  });
  
  // Teardown
  afterEach(() => {
    cleanup();
  });
  
  describe('methodName', () => {
    it('should handle happy path correctly', () => {
      // Arrange
      const input = validInput();
      
      // Act
      const result = methodName(input);
      
      // Assert
      expect(result).toBe(expectedOutput);
    });
    
    it('should handle edge case: empty input', () => {
      // Test implementation
    });
    
    it('should throw error on invalid input', () => {
      expect(() => methodName(null)).toThrow();
    });
  });
});
```

### 4. Verify Coverage
Run: `npm test -- --coverage`
Ensure >= 80% coverage

## Test Organization
```
tests/
├── unit/
│   ├── services/
│   └── utils/
├── integration/
│   └── api/
└── e2e/
    └── flows/
```

## Mocking Best Practices
```typescript
// Mock external dependencies
jest.mock('../api/client');

// Setup mock behavior
mockClient.get.mockResolvedValue({ data: mockData });

// Verify mock calls
expect(mockClient.get).toHaveBeenCalledWith('/endpoint');
```

## Output Format
Create test file(s) with:
- Descriptive test names
- AAA pattern (Arrange, Act, Assert)
- Comprehensive coverage
- Clear failure messages
- Proper cleanup

## Context Discovery
Before writing tests, check:
- `jest.config.js` or `vitest.config.ts` - Test configuration
- `tests/` or `__tests__/` - Existing test patterns
- `package.json` - Test scripts and dependencies
- `setupTests.ts` - Test environment setup

## Constraints
- Follow project's test patterns
- Use project's test framework
- Mock external dependencies
- Keep tests isolated
- No implementation code in tests
```

---

## Quick Reference

### Creating Agents

```bash
# Interactive
/agents

# Manual
touch .claude/agents/agent-name.md
```

### File Structure

```markdown
---
name: Display Name
description: MUST BE USED for [specific tasks]
tools: Read, Write, Bash(pattern)
model: sonnet | opus | haiku
---

System prompt defining role and behavior...
```

### Invocation

```bash
# Automatic (Claude decides)
"Review this code for security issues"

# Manual (explicit request)
"Use the security-reviewer agent to analyze auth.ts"

# Check delegation
# Look for Task(...) in logs
```

### File Locations

```
.claude/agents/*.md       # Project-scoped (highest priority)
~/.claude/agents/*.md     # User-scoped
Plugin agents              # Lowest priority
```

---

## Summary

Subagents provide:
- **Task Specialization**: Expert behavior for specific work
- **Context Isolation**: Clean slate for each task
- **Tool Control**: Restrict capabilities per agent
- **Model Selection**: Choose appropriate power level
- **Team Sharing**: Version-controlled expertise

**Key Points**:
- Agents contain **system prompts**, not user prompts
- **Model-invoked** based on description matching
- Each invocation starts with **fresh context**
- Use **specific descriptions** for reliable delegation
- Balance number of agents with delegation reliability

Start with 3-5 essential agents, refine based on actual usage patterns!

---

## Documentation Sources

- **Official Docs**: https://docs.claude.com/en/docs/claude-code/sub-agents
- **Best Practices**: https://www.anthropic.com/engineering/claude-code-best-practices
- **Community Resources**: https://github.com/VoltAgent/awesome-claude-code-subagents

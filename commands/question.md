---
allowed-tools: Bash(git ls-files:*), Bash(eza:*), Read, Grep, Glob
argument-hint: [your-question]
description: Answer questions about the project without making any code changes
---

# Question Command

Answer the user's question by analyzing the project structure and documentation. This command is designed to provide information and answer questions **without making any code changes**.

## Important Constraints

- **CRITICAL: This is a question-answering task only**
- **DO NOT write, edit, or create any files**
- **DO NOT modify any code**
- **Focus on understanding and explaining existing code and project structure**
- **If the question requires code changes, explain what would need to be done conceptually without implementing**

## Execution Steps

1. **Gather Project Context**
   - Run `git ls-files` to understand project structure
   - Run `eza . --tree --level=2` for visual directory layout (if available)
   - Use Grep to search for relevant code patterns
   - Use Glob to find files matching patterns

2. **Read Relevant Documentation**
   - README.md for project overview
   - CLAUDE.md for project-specific Claude Code instructions (if exists)
   - Package.json for dependencies and scripts
   - Any relevant configuration files

3. **Analyze and Search**
   - Use Grep to find specific code implementations
   - Read files that are relevant to the question
   - Trace code flows and dependencies
   - Identify patterns and architectural decisions

## Analysis Approach

- Review the project structure from git ls-files
- Understand the project's purpose from README
- Search for relevant code using Grep
- Connect the question to relevant parts of the project
- Provide comprehensive answers based on analysis
- Reference specific files and line numbers when possible

## Response Format

Your response should include:

1. **Direct Answer** - Clear, concise answer to the question
2. **Supporting Evidence** - Code references, file paths, line numbers
3. **Context** - Relevant project structure and patterns
4. **Related Information** - Additional insights that might be helpful
5. **References** - Link to documentation or specific files

## Example Usage

```bash
/question How does authentication work in this project?
/question Where are the API routes defined?
/question What testing framework is being used?
/question Explain the state management approach
/question Where is the database connection configured?
```

## User's Question

$ARGUMENTS

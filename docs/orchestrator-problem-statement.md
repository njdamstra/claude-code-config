# Claude Code Orchestrator System - Problem Statement for AI Assistance

## Current System Overview

I've built an orchestrator system in Claude Code with the following architecture:

### Components

1. **Orchestrator Subagent** (`~/.claude/agents/orchestrator.md`)
   - Autonomous planning agent that clarifies vague requests
   - Discovers relevant skills by scanning `~/.claude/skills/` using Bash
   - Plans codebase exploration with glob patterns
   - Outputs structured JSON with exploration and implementation todos

2. **SubagentStop Hook** (`~/.claude/hooks/process-orchestrator.sh`)
   - Bash script that triggers when orchestrator subagent completes
   - Reads transcript file to extract orchestrator's JSON output
   - Parses todos from JSON
   - Saves todos to `/tmp/orchestrator-todos-*.json`

3. **Slash Command** (`~/.claude/commands/orchestrate.md`)
   - User invokes: `/orchestrate <vague request>`
   - Instructs main agent to invoke orchestrator subagent

### Current Workflow

```
User: /orchestrate create a modal component
  ↓
Main Agent invokes orchestrator subagent
  ↓
Orchestrator outputs JSON:
{
  "clarified_request": "Create Vue 3 modal with...",
  "selected_skills": [...],
  "todos": {
    "exploration": [
      {"content": "Explore for existing Modal components", ...}
    ],
    "implementation": [
      {"content": "Create Modal.vue using vue-component-builder", ...}
    ]
  }
}
  ↓
SubagentStop hook triggers:
  - Extracts JSON from transcript
  - Parses todos
  - Saves to /tmp/orchestrator-todos-*.json
  ↓
❌ PROBLEM: Todos are NOT automatically inserted into conversation
```

## The Problem

**SubagentStop hooks cannot automatically insert todos into the main conversation** because:

1. **Hooks are flow control mechanisms**, not communication channels
2. **Hooks cannot call Claude Code tools** (like TodoWrite)
3. **Hook output goes to the hook system**, not to the main agent's conversation
4. **Hooks can only**:
   - Exit with code 0 (allow subagent to complete)
   - Exit with code 2 (block subagent, show reason)
   - Execute external scripts

### What We've Tried

- ✅ Hook successfully extracts orchestrator JSON from transcript
- ✅ Hook successfully parses todos and saves to file
- ❌ Hook outputting `systemMessage` (not visible to main agent)
- ❌ Hook blocking with exit code 2 (prevents orchestrator from completing, causes it to implement instead of plan)
- ❌ Hook trying to call TodoWrite (hooks can't call tools)

## The Goal

**Automatic todo insertion**: When the orchestrator completes, todos should automatically appear in the main agent's todo list without manual intervention.

### Desired Workflow

```
User: /orchestrate create a modal component
  ↓
Orchestrator analyzes and outputs JSON
  ↓
SubagentStop hook processes JSON
  ↓
✅ Todos AUTOMATICALLY appear in main conversation via TodoWrite
  ↓
Main agent sees todos and executes them:
  1. Exploration todos (invoke Explore agents)
  2. Implementation todos (invoke skills)
```

## Technical Constraints

### Claude Code Hook System

**SubagentStop hooks receive** (via stdin):
```json
{
  "session_id": "...",
  "transcript_path": "/path/to/transcript.jsonl",
  "hook_event_name": "SubagentStop",
  "stop_hook_active": false
}
```

**SubagentStop hooks can output**:
```json
{
  "decision": "block",  // or undefined to allow
  "reason": "explanation shown to subagent"
}
```

**SubagentStop hooks CANNOT**:
- Send messages to main agent conversation
- Call TodoWrite or other Claude Code tools
- Directly modify conversation state

### Transcript Structure

Subagent messages in transcript:
```json
{
  "type": "assistant",
  "isSidechain": true,  // ← Identifies subagent messages
  "message": {
    "content": [
      {
        "type": "text",
        "text": "{\"original_request\": \"...\", \"todos\": {...}}"
      }
    ]
  }
}
```

## Questions for AI Assistance

1. **Is there a way for SubagentStop hooks to trigger TodoWrite in the main conversation?**
   - Can hooks output special JSON that Claude Code processes to call tools?
   - Is there an undocumented hook output format that triggers actions?

2. **Can hooks communicate with the main agent outside of blocking?**
   - Is there a mechanism for hooks to send messages visible to the main agent?
   - Can hooks write to a location that the main agent automatically reads?

3. **Alternative architectures:**
   - Should the orchestrator itself output instructions to call TodoWrite (in its JSON)?
   - Should we use a different hook type (PostToolUse on Task tool)?
   - Should we abandon hooks entirely and have the main agent parse orchestrator output?

4. **Claude Code extension points:**
   - Are there other hook types or mechanisms we're missing?
   - Can we create a custom MCP server that bridges hooks and tools?
   - Is there a way to register a post-processing callback for subagent completion?

## Current Workaround

**Semi-automatic**: Main agent manually reads orchestrator JSON and calls TodoWrite:

```javascript
1. Orchestrator completes with JSON output
2. Main agent sees JSON in Task tool result
3. Main agent parses todos from JSON
4. Main agent calls TodoWrite(todos)
5. Main agent executes todos
```

This works but requires the main agent to remember to parse and call TodoWrite every time.

## Ideal Solution

**Fully automatic**: When orchestrator completes, todos appear in the conversation without any manual parsing or TodoWrite calls by the main agent.

---

## Additional Context

- **Claude Code Version**: Latest (as of 2025-10-21)
- **Operating System**: macOS
- **Hook Script Language**: Bash
- **Orchestrator Output**: Valid JSON (verified)
- **Hook Execution**: Successful (verified in logs)

## Files Available

1. `/Users/natedamstra/.claude/agents/orchestrator.md` - Orchestrator subagent definition
2. `/Users/natedamstra/.claude/hooks/process-orchestrator.sh` - SubagentStop hook script
3. `/Users/natedamstra/.claude/logs/orchestrator.log` - Hook execution logs
4. `/tmp/orchestrator-todos-*.json` - Generated todos (saved by hook)

---

**Question**: How can we make todos automatically insert into the main conversation when the orchestrator subagent completes?

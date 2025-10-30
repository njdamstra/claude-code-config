# Chrome DevTools + Gemini-CLI Integration Plan

## Overview

This document outlines how to properly configure chrome-devtools MCP with gemini-cli MCP so that Gemini can control Chrome for browser automation tasks.

## Architecture

```
┌─────────────────┐
│   Claude Code   │
└────────┬────────┘
         │
         ├─────────────────┬─────────────────┐
         │                 │                 │
    ┌────▼────┐      ┌────▼────┐      ┌────▼────┐
    │ gemini- │      │ chrome- │      │  Other  │
    │   cli   │      │devtools │      │  MCPs   │
    └────┬────┘      └────┬────┘      └─────────┘
         │                │
         │                │
    ┌────▼────────────────▼────┐
    │   Browser Automation     │
    │   (via chrome-devtools)  │
    └──────────────────────────┘
```

## Current Status

### ✅ What's Working
- **gemini-cli MCP**: Connected and responding to queries
- **chrome-devtools MCP**: Connected and can control Chrome directly from Claude
- **Chrome**: Running on port 9222 with DevTools Protocol enabled

### ❌ What Needs Configuration
- **Gemini accessing chrome-devtools tools**: Gemini-CLI cannot currently invoke chrome-devtools MCP tools
- **MCP-to-MCP communication**: MCPs don't share tools by default in Claude Code

## The Challenge

**Problem:** When we ask gemini-cli to "use chrome-devtools to navigate to localhost:6943", it times out because:
1. Gemini-CLI has no access to chrome-devtools MCP tools
2. MCPs in Claude Code run in isolated contexts
3. Gemini can't directly call other MCP tools - only Claude Code can orchestrate MCP calls

## Solution Options

### Option 1: Use Claude Code as Orchestrator (Recommended)

**How it works:**
- Claude Code invokes both MCPs as needed
- Claude asks Gemini for analysis/decision-making
- Claude uses chrome-devtools for browser actions
- Results are combined by Claude Code

**Example workflow:**
```
User: "Have Gemini analyze localhost:6943 and suggest improvements"

Claude Code:
1. Uses chrome-devtools to navigate and screenshot
2. Passes screenshot to gemini-cli for analysis
3. Returns Gemini's recommendations to user
```

**Pros:**
- ✅ Works with current MCP architecture
- ✅ No configuration changes needed
- ✅ Claude Code handles orchestration

**Cons:**
- ❌ Requires Claude Code to manage the workflow
- ❌ Can't say "Gemini, go use chrome-devtools directly"

### Option 2: Gemini with Embedded Instructions (Hybrid)

**How it works:**
- Configure gemini-cli prompts to return browser automation commands
- Claude Code interprets Gemini's output and executes chrome-devtools actions

**Example workflow:**
```
User: "Ask Gemini how to test the login flow"

Claude Code:
1. Asks Gemini: "What steps to test login at localhost:6943?"
2. Gemini returns: "1. Navigate to /login 2. Fill username 3. Click submit"
3. Claude translates to chrome-devtools calls
4. Executes each step with chrome-devtools MCP
```

**Pros:**
- ✅ Gemini provides testing intelligence
- ✅ Chrome-devtools executes actions reliably
- ✅ No timeout issues

**Cons:**
- ❌ Requires parsing Gemini's output
- ❌ Two-step process (query → execute)

### Option 3: Custom MCP Bridge (Advanced)

**How it works:**
- Create a custom MCP that wraps both gemini-cli and chrome-devtools
- The bridge MCP exposes unified tools
- Handles communication between Gemini and Chrome

**Example:**
```json
{
  "mcpServers": {
    "gemini-chrome-bridge": {
      "type": "stdio",
      "command": "node",
      "args": ["~/.claude/mcp-bridge/gemini-chrome.js"]
    }
  }
}
```

**Pros:**
- ✅ Direct Gemini → Chrome communication
- ✅ Clean abstraction for complex workflows
- ✅ Reusable for other projects

**Cons:**
- ❌ Requires custom code development
- ❌ Maintenance overhead
- ❌ Complexity

## Recommended Approach: Option 1 (Orchestrated Workflow)

### Implementation Plan

#### 1. Create Workflow Templates

Save common workflows as slash commands or prompt templates:

**File:** `~/.claude/workflows/gemini-chrome-analysis.md`
```markdown
# Gemini Chrome Analysis Workflow

1. Navigate to {{URL}} using chrome-devtools
2. Take screenshot of the page
3. Extract page text content
4. Send to gemini-cli with prompt: "Analyze this webpage for {{ANALYSIS_TYPE}}"
5. Return Gemini's analysis with actionable recommendations
```

#### 2. Use Task Agent for Complex Workflows

Create a specialized agent that knows how to coordinate both MCPs:

```markdown
# Browser Testing Agent

This agent coordinates chrome-devtools for browser actions and gemini-cli for analysis.

## Capabilities:
- Navigate to URLs and capture screenshots
- Extract page content and structure
- Send to Gemini for analysis
- Execute test scenarios
- Generate test reports

## Example usage:
"Use the browser testing agent to analyze localhost:6943 login flow"
```

#### 3. Create Helper Functions

Document common patterns in `~/.claude/CLAUDE.md`:

```markdown
## Browser Analysis Pattern

When user asks to "analyze with Gemini":
1. Use `mcp__chrome-devtools__navigate_page` to load URL
2. Use `mcp__chrome-devtools__take_screenshot` to capture visual
3. Use `mcp__chrome-devtools__take_snapshot` to get text content
4. Use `mcp__gemini-cli__ask-gemini` with prompt: "Analyze this page..."
5. Combine results and present to user
```

### Example Orchestration Code

For Claude Code to execute:

```typescript
// Pseudo-code for Claude's internal orchestration

async function analyzePageWithGemini(url: string) {
  // Step 1: Navigate and capture with chrome-devtools
  await chromeDevtools.navigate(url);
  const screenshot = await chromeDevtools.screenshot();
  const snapshot = await chromeDevtools.snapshot();

  // Step 2: Ask Gemini for analysis
  const analysis = await geminiCli.ask(
    `Analyze this webpage and provide UX recommendations:

    URL: ${url}
    Snapshot: ${snapshot}

    Focus on: accessibility, performance, user experience`
  );

  // Step 3: Return combined results
  return {
    screenshot,
    snapshot,
    geminiAnalysis: analysis
  };
}
```

## Usage Examples

### Example 1: Basic Page Analysis

**User request:**
```
Analyze localhost:6943 with Gemini and tell me what improvements to make
```

**Claude Code execution:**
1. Navigate to localhost:6943 (chrome-devtools)
2. Take screenshot (chrome-devtools)
3. Get page snapshot (chrome-devtools)
4. Ask Gemini to analyze with screenshot context (gemini-cli)
5. Present Gemini's recommendations

### Example 2: Interactive Testing

**User request:**
```
Have Gemini design a test plan for the login flow, then execute it with chrome-devtools
```

**Claude Code execution:**
1. Ask Gemini to create test plan (gemini-cli)
2. Parse test steps from Gemini's response
3. Execute each step with chrome-devtools:
   - Fill username field
   - Fill password field
   - Click submit button
   - Verify redirect
4. Report results back to user

### Example 3: Performance Analysis

**User request:**
```
Use Gemini to analyze the performance of localhost:6943
```

**Claude Code execution:**
1. Start performance trace (chrome-devtools)
2. Navigate to localhost:6943 (chrome-devtools)
3. Stop trace and get metrics (chrome-devtools)
4. Send metrics to Gemini for analysis (gemini-cli)
5. Get Gemini's optimization recommendations
6. Present findings with actionable items

## Configuration Files

### ~/.claude.json (Final Working Config)

```json
{
  "mcpServers": {
    "gemini-cli": {
      "type": "stdio",
      "command": "npx",
      "args": ["gemini-mcp-tool"],
      "env": {}
    },
    "chrome-devtools": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"],
      "env": {}
    }
  }
}
```

### Environment Variables (Optional)

For enhanced debugging:

```bash
# Add to ~/.zshrc or ~/.bashrc
export DEBUG_CHROME_MCP=true
export GEMINI_LOG_LEVEL=verbose
```

## Limitations & Workarounds

### Limitation 1: No Direct MCP-to-MCP Communication
**Workaround:** Claude Code orchestrates the workflow between MCPs

### Limitation 2: Gemini Timeouts on Long Operations
**Workaround:** Break operations into smaller chunks, execute chrome actions first, then ask Gemini to analyze results

### Limitation 3: Can't Stream Gemini's Response While Chrome Operates
**Workaround:** Execute chrome operations, collect results, then query Gemini with complete context

## Testing the Integration

### Test 1: Basic Coordination
```
User: Navigate to localhost:6943, take a screenshot, and ask Gemini what it sees

Expected:
1. Chrome navigates to URL
2. Screenshot captured
3. Gemini describes the page content
```

### Test 2: Complex Workflow
```
User: Ask Gemini for the best way to test a login form, then execute those tests on localhost:6943/login

Expected:
1. Gemini provides test strategy
2. Claude parses strategy into steps
3. Chrome-devtools executes each step
4. Results collected and presented
```

### Test 3: Analysis Loop
```
User: Have Gemini analyze the page, suggest an improvement, implement it, and re-analyze

Expected:
1. Screenshot and analyze with Gemini
2. Gemini suggests improvement
3. Navigate to code, make change
4. Reload page, take new screenshot
5. Gemini analyzes improvement impact
```

## Future Enhancements

### Phase 1: Documentation & Patterns (Immediate)
- [x] Document working configuration
- [ ] Create workflow templates
- [ ] Add to CLAUDE.md for automatic context

### Phase 2: Automation Scripts (Week 1)
- [ ] Create helper scripts for common workflows
- [ ] Add slash commands for frequent operations
- [ ] Build test scenario templates

### Phase 3: Custom MCP Bridge (Future)
- [ ] Design bridge MCP architecture
- [ ] Implement gemini-chrome-bridge
- [ ] Add error handling and retries
- [ ] Create comprehensive test suite

## Troubleshooting

### Issue: Gemini times out when asked to use chrome-devtools
**Solution:** Don't ask Gemini to use chrome-devtools directly. Instead, ask Claude to coordinate both MCPs.

### Issue: Chrome actions happen but Gemini doesn't see results
**Solution:** Explicitly pass chrome-devtools results to gemini-cli in the same prompt.

### Issue: Complex workflows get confused
**Solution:** Break into smaller steps, use TodoWrite to track progress, execute sequentially.

## Conclusion

The chrome-devtools and gemini-cli MCPs work best when **orchestrated by Claude Code** rather than having Gemini directly control Chrome. This approach:

- ✅ Leverages strengths of both MCPs
- ✅ Avoids timeout issues
- ✅ Works with current MCP architecture
- ✅ Provides clear, predictable workflows

**Next Step:** Start with simple workflows (navigate → screenshot → analyze) and gradually build more complex automation patterns as needed.

# Token-Optimized Workflow

## Overview
This workflow implements Dan's R&D framework (Reduce and Delegate) to minimize token consumption while maximizing development efficiency.

## Core Principles

### Reduce: Minimize Context Pollution
- Load MCP servers on-demand only
- Use context bundles instead of full conversation history
- Prime with domain-specific context only
- Delegate research to separate agents

### Delegate: Strategic Agent Distribution
- Research agents work in isolation
- Implementation agents get focused summaries
- Specialized agents handle token-intensive operations
- Background agents for out-of-loop tasks

## Phase 1: Context Reduction (Token Savings: 20,000+)

### Step 1: MCP Server Optimization
```bash
# Instead of loading all servers by default:
# Only load specific servers when needed
/prime [domain] # Loads domain-specific tools only
```

### Step 2: CLAUDE.md Minimization
- Keep global CLAUDE.md under 15,000 tokens
- Move detailed context to primer files
- Use context bundles for session state

### Step 3: Selective Context Loading
```bash
/prime typescript components
# Loads only TypeScript + component context
# Excludes Python, API, database context
```

## Phase 2: Strategic Delegation (Token Savings: 40-60%)

### Step 4: Research Delegation
```bash
/research [topic] [agent] [focus]
# Agent researches in isolation
# Returns summary instead of full context
# Main agent implements with focused guidance
```

### Step 5: Background Processing
```bash
# Long-running tasks in background
@code-review [files] --background
@service-documentation [changes] --background
# Monitor with context bundles
```

### Step 6: Context Bundle Management
```bash
/bundle save [session-name]
# Save 60-70% context restoration capability
# Avoid full conversation replay
/bundle load [session-name]
# Quick context restoration
```

## Phase 3: Token Monitoring & Optimization

### Step 7: Real-Time Token Tracking
- Monitor context window usage
- Identify high-token operations
- Optimize before hitting limits
- Use compression when beneficial

### Step 8: Context Compaction
- Summarize completed work
- Archive non-essential context
- Maintain only active working context
- Bundle completed sessions

## Token Optimization Techniques

### 1. Context Priming (2,000-5,000 token savings)
```bash
/prime typescript # Loads minimal TypeScript context
# vs loading full project context
```

### 2. Research Delegation (10,000+ token savings)
```bash
/research "API documentation patterns" service-documentation
# Agent researches in isolation, returns 1,000 token summary
# vs 15,000+ tokens of documentation exploration
```

### 3. Bundle Restoration (15,000+ token savings)
```bash
/bundle load previous-session
# Restore 70% context with 3,000 tokens
# vs 20,000+ tokens of conversation history
```

### 4. Selective Agent Activation (5,000+ token savings)
```bash
# Only activate needed agents:
@typescript-master [specific-task]
# vs keeping all agents in context
```

## Workflow Examples

### High-Efficiency Development Session
```bash
# Start optimized (vs 24,100 default tokens)
/prime typescript components  # 2,000 tokens

# Research in isolation (vs 15,000+ exploration tokens)
/research "React hooks patterns" typescript-master  # 1,000 token result

# Implement with focus (vs scattered exploration)
# Implementation guided by research summary

# Save session state (vs losing context)
/bundle save hooks-implementation  # 3,000 token bundle

# Total: ~6,000 tokens vs 40,000+ traditional approach
# Savings: 85% token reduction
```

### Context Recovery Session
```bash
# Quick restoration (vs full conversation replay)
/bundle load hooks-implementation  # 3,000 tokens
# vs 20,000+ tokens of conversation history

# Continue with minimal context
/prime typescript testing  # Add testing context

# Focused next steps based on bundle guidance
```

### Multi-Session Project
```bash
# Session 1: Research and Planning
/prime python data-processing
/research "async data pipelines" python-pipeline-architect
/bundle save async-research

# Session 2: Implementation
/bundle load async-research
# Implement based on research findings
/bundle save async-implementation

# Session 3: Testing and Documentation
/bundle load async-implementation
@code-review [implementation-files]
@service-documentation [api-changes]
/bundle save async-complete
```

## Expected Results

### Token Savings Breakdown
- **MCP Optimization**: 20,000+ tokens saved
- **Context Priming**: 5,000+ tokens saved per session
- **Research Delegation**: 10,000+ tokens saved per research task
- **Bundle Restoration**: 15,000+ tokens saved per session restart
- **Total Potential Savings**: 60-85% reduction

### Performance Improvements
- **Context Window Efficiency**: 3-5x more effective use
- **Session Longevity**: Work longer without compaction
- **Multi-Session Projects**: Seamless continuation
- **Development Speed**: Faster with focused context

### Quality Maintenance
- **Research Quality**: Specialist agents provide better insights
- **Implementation Focus**: Clear guidance reduces errors
- **Context Consistency**: Bundle management maintains coherence
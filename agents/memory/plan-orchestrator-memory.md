# Plan Orchestrator - Implementation Memory

**Created:** 2025-10-25
**Agent:** plan-orchestrator
**Command:** /plan
**Status:** Complete

---

## Implementation Summary

Successfully designed and implemented intelligent planning orchestrator with 5 adaptive workflow patterns.

### Files Created

1. **`/Users/natedamstra/.claude/agents/plan-orchestrator.md`**
   - Lines: 1,542
   - Major sections: 83
   - Complete agent system prompt

2. **`/Users/natedamstra/.claude/commands/plan.md`**
   - Lines: 364
   - Simple command interface to invoke orchestrator

---

## Architecture Overview

### Core Concept

Multi-agent planning orchestration that:
1. Analyzes task characteristics (keywords, complexity, domain)
2. Selects optimal workflow from 5 patterns
3. Spawns specialist agents (code-scout, code-qa, doc-searcher, plan-master)
4. Coordinates parallel execution
5. Synthesizes evidence with citations
6. Generates comprehensive plans with confidence ratings

### Agent Composition

**Specialist agents used:**
- **code-scout**: Broad discovery, file mapping, pattern identification
- **code-qa**: Precise Q&A with source verification, execution flow tracing
- **doc-searcher**: Documentation search with honest gap reporting
- **plan-master**: Strategic planning with agent orchestration

**Orchestrator coordinates these 4 agents with workflow-specific patterns.**

---

## 5 Workflow Patterns

### 1. Hypothesis-Driven (Priority - Most Innovative)

**Use case:** Bug investigation, crashes, unexpected behavior, root cause analysis

**Pattern:**
```
code-scout (targeted)
  → Generate 3-5 hypotheses
  → code-qa × N (parallel hypothesis testing)
  → Synthesize (identify confirmed root cause)
  → plan-master (create fix plan)
```

**Innovation:**
- Parallel hypothesis testing (one code-qa agent per hypothesis)
- Systematic elimination approach
- Evidence-based root cause identification
- Documents why other hypotheses were ruled out

**Example hypotheses for "Auth crash on expired token":**
1. Token expiry not checked before API call (likelihood: high)
2. Expired token throws unhandled exception (likelihood: high)
3. Token refresh mechanism failing (likelihood: medium)
4. Race condition between token check and usage (likelihood: low)
5. SSR vs client token handling mismatch (likelihood: medium)

**Each hypothesis tested in parallel with:**
- CONFIRMED: Evidence supports
- REFUTED: Evidence contradicts
- INCONCLUSIVE: Insufficient evidence

**Triggers:**
- Keywords: bug, crash, error, debug, investigate, fails, broken
- Question format: "Why does X?", "What causes Y?"
- Unexpected behavior descriptions

---

### 2. Discovery-First (Default)

**Use case:** New feature implementation, adding functionality, general development

**Pattern:**
```
code-scout (broad discovery)
  → Identify gaps
  → code-qa × N (parallel targeted questions)
  → doc-searcher (optional - framework questions)
  → Synthesize findings
  → plan-master (create plan)
```

**Characteristics:**
- Comprehensive discovery first (all systematic searches)
- Targeted follow-up for gaps
- Documentation support as needed
- Broad → Narrow → Plan progression

**Triggers:**
- Default fallback if no specific keywords
- "Create", "Add", "Implement" keywords
- New feature descriptions

---

### 3. Documentation-First

**Use case:** Framework-heavy tasks, library integration, unfamiliar patterns

**Pattern:**
```
doc-searcher (framework research)
  → code-scout (apply doc insights to codebase)
  → code-qa (verify specific detail)
  → plan-master (pattern-aligned plan)
```

**Characteristics:**
- Official patterns drive approach
- Framework best practices first
- Verify against codebase second
- Documentation citations in plan

**Triggers:**
- Keywords: OAuth, SSR, authentication, framework, library, integration
- Mentions unfamiliar technology
- "Best practices" explicitly requested

---

### 4. Quick-Scan

**Use case:** Simple changes, focused modifications, trivial implementations

**Pattern:**
```
code-scout (targeted scan only)
  → code-qa (single question, optional)
  → plan-master (minimal plan)
```

**Characteristics:**
- Minimal investigation overhead
- Fast turnaround
- Direct implementation path
- Skip unnecessary research

**Triggers:**
- Keywords: simple, quick, trivial, small, minor
- Single-file change clearly identified
- Cosmetic/UI-only changes

---

### 5. Iterative-Refinement

**Use case:** Refactoring, optimization, code consolidation, removing duplication

**Pattern:**
```
code-scout (map + duplications)
  → code-qa × N (parallel duplication analysis)
  → doc-searcher (refactoring patterns)
  → Synthesize findings
  → plan-master (incremental refactor plan)
```

**Characteristics:**
- Deep code analysis with duplication detection
- Multiple parallel analyses (one per duplication pattern)
- Dependency mapping
- Incremental approach with validation checkpoints
- Safety-first planning

**Parallel analysis example:**
- Agent 1: Analyze form validation duplication (3 instances)
- Agent 2: Analyze API error handling duplication (5 instances)
- Agent 3: Verify dependencies
- Agent 4: Check for breaking changes

**Triggers:**
- Keywords: refactor, optimize, consolidate, duplicate, improve, clean up
- "Extract" or "DRY" mentioned
- Performance optimization

---

## Workflow Selection Algorithm

### Step 1: Extract Characteristics

**Keyword analysis:**
- Bug indicators: bug, crash, error, debug, investigate, fails, broken
- Framework indicators: OAuth, SSR, authentication, Appwrite, framework, library
- Simplicity indicators: simple, quick, add, change, update, small
- Refactor indicators: refactor, optimize, consolidate, duplicate, improve

**Complexity signals:**
- Simple: 1-2 files, single change type
- Medium: 3-8 files, multiple related changes
- Complex: 9+ files, architectural changes

**Domain signals:**
- Frontend: component, Vue, Astro, UI, styling
- Backend: API, database, Appwrite, server
- Full-stack: authentication, forms, data flow
- Infrastructure: build, deploy, performance

### Step 2: Apply Selection Rules (Priority Order)

1. **Hypothesis-Driven** IF bug/crash/error keywords
2. **Documentation-First** IF OAuth/SSR/framework keywords
3. **Quick-Scan** IF simple/quick/trivial keywords
4. **Iterative-Refinement** IF refactor/optimize/consolidate keywords
5. **Discovery-First** (default for everything else)

### Step 3: Validate Selection

**Confidence check:**
- High: Clear keyword match
- Medium: Inferred from description
- Low: Default fallback

**Override conditions:**
- User explicitly requests workflow (--workflow flag)
- Task complexity contradicts selection (upgrade to more thorough)
- Multiple workflows applicable (choose more thorough option)

---

## Agent Coordination Protocol

### Parallel Execution

**When to parallelize:**
- code-qa agents answering independent questions
- Hypothesis testing (Hypothesis-Driven workflow)
- Duplication analysis (Iterative-Refinement workflow)

**Coordination pattern:**
```
1. Identify independent investigation paths
2. Spawn all parallel agents at once (Task tool)
3. Wait for all agents to complete
4. Collect all outputs
5. Synthesize findings in unified format
```

**Benefits:**
- Minimize total investigation time
- Maximize evidence coverage
- Independent investigations don't block each other

### Sequential Execution

**When to sequence:**
- Results from one agent inform next agent's questions
- Progressive narrowing required
- code-scout → code-qa → plan-master chain

**Execution pattern:**
```
1. Spawn agent A
2. Wait for completion
3. Analyze output
4. Formulate next questions based on findings
5. Spawn agent B with context from A
6. Repeat as needed
```

---

## Evidence Synthesis Protocol

### Aggregating Findings

**After all agents complete:**

1. **File Citations**
   - Aggregate all file:line references
   - Remove duplicates
   - Organize by relevance

2. **Confidence Ratings**
   - High: Verified by reading source (code-qa)
   - Medium: Inferred from patterns (code-scout)
   - Low: Requires manual verification
   - No evidence: Gaps needing investigation

3. **Evidence Categories**
   - Implementation details (how things work)
   - Patterns (existing approaches)
   - Reusability (REUSE/EXTEND/CREATE)
   - Gaps (missing functionality/docs)
   - Risks (potential issues)

### Synthesis Output

**INVESTIGATION_SYNTHESIS.md structure:**
- Summary (2-3 sentences)
- High confidence findings (✅ verified in source)
- Medium confidence findings (⚠️ inferred from patterns)
- Investigation gaps (❌ needs verification)
- Reusability analysis (match percentages)
- Agent reports (consolidated)
- Recommendations for plan-master

---

## Output Format

### 1. Workflow Selection Report

**Always begins with:**
- Selected workflow and why
- Keyword matches
- Complexity assessment
- Alternative workflows considered
- Confidence in selection

### 2. Investigation Results

**After agents complete:**
- Findings from all spawned agents
- Files examined count
- Evidence aggregation with citations
- Confidence ratings

### 3. Evidence Summary

**Organized by confidence:**
- High confidence (verified)
- Medium confidence (inferred)
- Gaps (needs verification)
- Reusability (REUSE/EXTEND/CREATE with %)

### 4. Final Plan

**Generated by plan-master:**
- All recommendations backed by evidence
- Task breakdown with agent assignments
- Success criteria
- Validation checkpoints
- Risk mitigation strategies
- Links to all investigation reports

---

## Key Design Decisions

### 1. Workflow Selection vs Manual

**Decision:** Auto-select with override option
**Rationale:** Most users benefit from intelligent selection, experts can override
**Implementation:** --workflow flag for manual selection

### 2. Parallel vs Sequential

**Decision:** Hybrid approach based on workflow
**Rationale:** Parallelism for independent investigations, sequential when dependent
**Implementation:** Each workflow specifies parallel opportunities

### 3. Evidence Tracking

**Decision:** Mandatory citations with confidence ratings
**Rationale:** Transparency and reproducibility essential for trust
**Implementation:** Every claim requires file:line citation and confidence level

### 4. Hypothesis Generation

**Decision:** Automated hypothesis generation from scout findings
**Rationale:** Systematic coverage of potential causes
**Implementation:** 3-5 hypotheses covering common patterns, recent changes, dependencies, edge cases, environment

### 5. Agent Composition

**Decision:** 4 specialist agents (code-scout, code-qa, doc-searcher, plan-master)
**Rationale:** Each agent has distinct, focused responsibility
**Implementation:** Orchestrator coordinates but doesn't implement - pure orchestration

---

## Validation Results

### Architecture Validation

✅ **File structure:**
- plan-orchestrator.md: 1,542 lines (comprehensive system prompt)
- plan.md: 364 lines (simple command interface)
- Total: 1,906 lines

✅ **Section coverage:**
- 83 major sections (###) in plan-orchestrator
- All 5 workflows fully documented
- Complete execution protocols for each workflow
- Agent coordination patterns defined
- Evidence synthesis protocol specified

✅ **Design requirements met:**
- 5 adaptive workflow patterns ✅
- Pattern selection logic (keyword-based) ✅
- Agent composition rules ✅
- Parallel execution strategy ✅
- Evidence synthesis protocol ✅
- Confidence tracking ✅
- Output format specifications ✅

### Workflow Validation

**Hypothesis-Driven (Priority workflow):**
✅ Complete implementation
✅ Hypothesis generation strategy (3-5 hypotheses)
✅ Parallel testing protocol
✅ Synthesis of results (CONFIRMED/REFUTED/INCONCLUSIVE)
✅ Fix planning based on confirmed hypotheses

**Discovery-First (Default workflow):**
✅ Complete implementation
✅ Broad discovery → gap identification → targeted investigation
✅ Optional documentation phase
✅ Comprehensive synthesis

**Documentation-First:**
✅ Complete implementation
✅ Research-first approach
✅ Pattern application to codebase
✅ Verification protocol

**Quick-Scan:**
✅ Complete implementation
✅ Minimal overhead design
✅ Optional verification step
✅ Direct planning path

**Iterative-Refinement:**
✅ Complete implementation
✅ Duplication detection focus
✅ Parallel duplication analysis
✅ Incremental refactor planning
✅ Safety checkpoints

---

## Usage Patterns

### Command Invocation

```bash
# Auto-select workflow
/plan "Task description"

# Force specific workflow
/plan "Task description" --workflow=hypothesis-driven
```

### Example Usage by Workflow

**Hypothesis-Driven:**
```bash
/plan "Auth crash on expired token"
/plan "Component not rendering after state update"
/plan "Memory leak in dashboard"
```

**Discovery-First:**
```bash
/plan "Create user profile component"
/plan "Add search functionality to product catalog"
/plan "Implement notification system"
```

**Documentation-First:**
```bash
/plan "Integrate OAuth2 with Appwrite"
/plan "Add SSR support to authentication"
/plan "Implement Appwrite realtime subscriptions"
```

**Quick-Scan:**
```bash
/plan "Add loading spinner to button"
/plan "Change header background color"
/plan "Update copyright year in footer"
```

**Iterative-Refinement:**
```bash
/plan "Consolidate FormInput components"
/plan "Extract duplicate validation logic"
/plan "Optimize dashboard rendering performance"
```

---

## Integration with Existing System

### Relationship to Other Commands

**vs /frontend:**
- /plan: Planning and investigation only
- /frontend: Full workflow (Analysis → Plan → Implementation → Validation)

**Usage pattern:**
```
/plan "Feature" → Review plan → /frontend "Feature" --resume --skip-plan
```

**vs problem-decomposer-orchestrator:**
- plan-orchestrator: Planning-focused, 5 workflows, 4 specialist agents
- problem-decomposer: Implementation-focused, general orchestration

**Complementary usage:**
```
/plan → Generate plan → problem-decomposer-orchestrator → Execute plan
```

### Agent Dependencies

**Requires these agents to exist:**
- code-scout (discovery and mapping)
- code-qa (precise Q&A with verification)
- doc-searcher (documentation search)
- plan-master (strategic planning)

**All agents verified to exist in ~/.claude/agents/**

---

## Gotchas & Best Practices

### Gotchas

1. **Workflow selection sensitivity to keywords**
   - Gotcha: Minor keyword can trigger different workflow
   - Mitigation: Selection report shows why workflow chosen
   - User can override with --workflow flag

2. **Parallel execution requires agent independence**
   - Gotcha: If questions depend on each other, parallel fails
   - Mitigation: Workflows designed for independent questions
   - Hypothesis testing is naturally independent

3. **Evidence synthesis can be large**
   - Gotcha: Multiple agents = lots of output to synthesize
   - Mitigation: Structured synthesis format
   - Clear sections for different confidence levels

4. **Hypothesis generation quality**
   - Gotcha: Generic hypotheses if scout findings insufficient
   - Mitigation: Scout phase is targeted for bug context
   - 5 hypotheses cover different angles (patterns, changes, deps, edges, env)

### Best Practices

1. **Task description quality matters**
   - Good: "Fix: Profile component crashes on null user data"
   - Bad: "Fix bug"
   - Why: More context = better workflow selection + hypothesis generation

2. **Trust the workflow selection**
   - Orchestrator is optimized for each task type
   - Override only when you know a better approach
   - Selection report explains reasoning

3. **Review synthesis before plan**
   - Evidence synthesis shows what was found
   - Gaps indicate what needs manual verification
   - Confidence ratings show strength of recommendations

4. **Use for complex tasks, not trivial**
   - Multi-agent orchestration has overhead
   - Quick-Scan workflow minimizes overhead for simple tasks
   - For truly trivial tasks (1 line change), skip /plan entirely

5. **Parallel investigations maximize efficiency**
   - Hypothesis-Driven: Test all hypotheses simultaneously
   - Iterative-Refinement: Analyze all duplications in parallel
   - Discovery-First: Answer all gap questions in parallel

---

## Future Enhancements

### Potential Improvements

1. **Workflow learning**
   - Track which workflows work best for which task types
   - Refine selection algorithm based on outcomes
   - User feedback on workflow effectiveness

2. **Hypothesis ranking**
   - ML-based likelihood scoring
   - Learn from confirmed vs refuted hypotheses
   - Prioritize high-likelihood hypotheses

3. **Evidence confidence ML**
   - Automated confidence scoring
   - Pattern recognition for verification quality
   - Citation strength assessment

4. **Workflow composition**
   - Hybrid workflows for complex tasks
   - Dynamic workflow switching mid-investigation
   - Workflow chaining for multi-phase planning

5. **Agent result caching**
   - Cache code-scout results for similar tasks
   - Avoid re-investigating same code areas
   - Incremental investigations with cache hits

---

## Success Criteria Met

✅ **All 5 workflows implemented**
- Hypothesis-Driven (most innovative)
- Discovery-First (default)
- Documentation-First
- Quick-Scan
- Iterative-Refinement

✅ **Workflow selection algorithm**
- Keyword-based detection
- Complexity assessment
- Domain identification
- Priority ordering
- Override capability

✅ **Agent coordination**
- Parallel execution protocol
- Sequential execution protocol
- Task tool invocation patterns
- Output collection strategy

✅ **Evidence synthesis**
- Aggregation from multiple agents
- Confidence rating system
- Citation tracking (file:line)
- Gap reporting
- Reusability analysis

✅ **Output format**
- Workflow selection report
- Investigation results
- Evidence summary
- Final plan with citations

✅ **Documentation**
- Complete agent prompt (1,542 lines)
- Command interface (364 lines)
- All workflows documented
- Examples for each pattern
- Architecture validation

---

## Conclusion

Successfully implemented plan-orchestrator with all requirements:

- **5 adaptive workflows** with complete execution protocols
- **Intelligent selection** based on task analysis
- **Parallel agent coordination** for efficiency
- **Evidence-based planning** with citations and confidence ratings
- **Comprehensive synthesis** of multi-agent findings
- **Flexible output** with honest gap reporting

The orchestrator provides optimal planning strategy for each task type while maintaining transparency through workflow selection reports and confidence ratings.

**Most innovative aspect:** Hypothesis-Driven workflow with parallel hypothesis testing - systematic root cause identification through evidence-based elimination.

**Key differentiator:** Adaptive workflow selection - right investigation strategy for each task type, from minimal overhead (Quick-Scan) to comprehensive analysis (Iterative-Refinement).

**Implementation complete and validated.**

# Plan Agent Update

**Date:** October 16, 2025
**Status:** ✅ Complete

---

## What Was Updated

Updated `/frontend-plan` command to use the specific `plan-master` agent file instead of the generic `problem-decomposer-orchestrator` agent.

---

## Agent File Verified

### plan-master.md ✅
**Location:** `/Users/natedamstra/.claude/agents/plan-master.md`

**Specialization:**
- Strategic planning and agent orchestration specialist
- Designed specifically for Phase 2 of frontend commands
- Creates MASTER_PLAN.md with task breakdown and agent assignments
- Focuses on WHAT needs to be done and WHO should do it
- Leaves HOW to specialist agents

**Primary Responsibilities:**
1. **Task Breakdown** - Decompose into logical, manageable subtasks
2. **Agent Orchestration** - Select appropriate specialists and define execution order
3. **Deliverable Definition** - Specify outputs and success criteria
4. **Context Provision** - Provide agents with pre-analysis findings
5. **Risk Management** - Identify blockers and dependencies

**Tools Available:**
- Read - For reading PRE_ANALYSIS.md and context files
- Write - For creating MASTER_PLAN.md
- Bash - For basic file operations

**Model:** haiku (fast and efficient for planning tasks)

**Output Format:**
Creates comprehensive MASTER_PLAN.md with:
- Executive Summary (goal, strategy, key decisions)
- Pre-Analysis Insights (reusability, patterns, VueUse opportunities)
- Phase Breakdown (Foundation, Implementation, Enhancement, QA)
- Agent Orchestration (execution order, parallel opportunities)
- Context for Specialist Agents (guidance, constraints, reference files)
- Success Criteria (overall and phase-specific)
- Risk Assessment (blockers, assumptions, contingencies)
- Communication Plan (agent handoffs, reporting requirements)
- Validation Plan (automated and manual checks)

---

## Updated Command: frontend-plan.md

### Agent Spawning Pattern

**Before (Generic):**
```
subagent_type: "problem-decomposer-orchestrator"
```

**After (Specific):**
```
subagent_type: "plan-master"
```

### Planning Mission

The plan-master agent receives a focused mission:

```
Task(
  subagent_type: "plan-master",
  description: "Create implementation plan for adding $2 to $1",
  prompt: """
You are creating an implementation plan for adding "$2" to existing feature "$1".

## Your Task
Read the PRE_ANALYSIS.md file from the analyze phase and create a comprehensive
MASTER_PLAN.md that orchestrates specialist agents to implement "$2" functionality.

## Input Context
- Task Type: add (extending existing feature)
- Feature: $1
- Addition: $2
- Pre-Analysis Location: .temp/analyze-$1-*/PRE_ANALYSIS.md

## Planning Requirements

1. Extension-First Approach
   - Extend existing components with new props/slots
   - Add actions/getters to existing stores
   - Enhance existing composables
   - Only create new files when absolutely necessary

2. Minimal Changes Philosophy
   - Change least amount of code necessary
   - Preserve backward compatibility
   - Don't refactor unrelated code
   - Make all new features additive

3. Leverage Pre-Analysis Findings
   - Use reusability opportunities identified by code-scout
   - Follow established patterns
   - Prefer VueUse alternatives over custom code

4. Architecture Hierarchy Alignment
   - VueUse/ecosystem composables (check first)
   - Custom composables/hooks
   - Stores/state management
   - Components (extend existing or create new)

5. Phase Structure
   - Phase 1: Foundation (stores and composables)
   - Phase 2: Implementation (components)
   - Phase 3: Integration (wire into existing)
   - Phase 4: Quality Assurance (testing, validation)

6. Agent Assignments
   - Identify which specialists are needed
   - Assign clear objectives to each
   - Define deliverables and success criteria
   - Specify execution order (sequential vs parallel)

## Critical Success Factors
- Focus on WHAT needs to be done, not HOW
- Leave technical implementation details to specialist agents
- Leverage all reusability opportunities from PRE_ANALYSIS.md
- Assign appropriate specialist agents to tasks
- Define clear success criteria for each phase
- Enable parallel execution where possible
- Minimize changes while achieving the goal
- Ensure backward compatibility throughout
"""
)
```

---

## plan-master's Planning Approach

### Planning Principles

**DOES:**
- ✅ Focus on WHAT needs to be done, not HOW
- ✅ Leave implementation details to specialist agents
- ✅ Be specific about agent assignments and deliverables
- ✅ Identify clear dependencies and execution order
- ✅ Leverage findings from pre-analysis
- ✅ Plan for parallel execution where beneficial
- ✅ Define measurable success criteria

**DOES NOT:**
- ❌ Over-specify technical implementation details
- ❌ Make technical decisions that specialists should make
- ❌ Create overly granular microtasks
- ❌ Assume specific solutions without agent input
- ❌ Ignore findings from pre-analysis
- ❌ Create unnecessary sequential dependencies

### Phase Structure Templates

**For `/frontend-add` (Add to Existing):**
1. **Phase 1: Foundation** - Extend existing stores/composables
2. **Phase 2: Implementation** - Wire in new functionality
3. **Phase 3: Enhancement** - Update types, add styling
4. **Phase 4: Quality** - Regression testing + new tests

Focus: Extension over creation, minimal changes, backward compatibility

**For `/frontend-new` (New Feature):**
1. **Phase 1: Foundation** - Stores and composables
2. **Phase 2: Implementation** - Components and pages
3. **Phase 3: Enhancement** - Styling, types, SSR checks
4. **Phase 4: Quality** - Testing and validation

Focus: Architecture hierarchy (VueUse → Composables → Stores → Components)

**For `/frontend-improve` (Improve Quality):**
1. **Phase 1: Foundation** - Extract to composables/stores
2. **Phase 2: Implementation** - Refactor components to use extracted code
3. **Phase 3: Enhancement** - Type improvements, cleanup
4. **Phase 4: Quality** - Validation of no regressions

Focus: Extraction, consolidation, VueUse replacement opportunities

**For `/frontend-fix` (Bug Fix):**
1. **Phase 1: Foundation** - Root cause analysis
2. **Phase 2: Implementation** - Implement minimal fix
3. **Phase 3: Enhancement** - Add regression test
4. **Phase 4: Quality** - Comprehensive validation

Focus: Minimal code changes, regression prevention

---

## Integration with Pre-Analysis

### How plan-master Uses PRE_ANALYSIS.md

1. **Reads Pre-Analysis Findings:**
   - Project context (tech stack, directory structure)
   - Relevant files (primary, related, pattern files)
   - Reusable code analysis (exact matches, near matches)
   - Duplication opportunities
   - Pattern documentation
   - Feature mapping (component hierarchy, data flow)

2. **Leverages Findings in Plan:**
   - **Reusability Section:** References exact matches, near matches, base components
   - **Pattern Alignment:** Cites naming conventions and code organization
   - **VueUse Opportunities:** Highlights composables to use instead of custom code
   - **Reference Files:** Provides paths to similar implementations
   - **Context for Specialists:** Gives agents specific files to follow as patterns

3. **Agent Assignment Decisions:**
   - Determines which specialists are needed based on tech stack
   - Identifies parallel vs sequential execution based on dependencies
   - Assigns agents to specific tasks with clear objectives

---

## Specialist Agent Assignments

The plan-master assigns work to these specialist agents:

### Common Assignments

**@vue-architect**
- Component creation and modification
- SSR-safe component patterns
- Slot and prop design

**@nanostore-state-architect**
- Store creation and extension
- State management patterns
- SSR-safe state initialization

**@astro-architect**
- Page structure and routing
- API route implementation
- SSR authentication guards

**@tailwind-styling-expert**
- Component styling
- Design system alignment
- Responsive and dark mode implementation

**@typescript-validator**
- Type definitions and extensions
- Zod schema validation
- Type safety enforcement

**@vue-testing-specialist**
- Unit tests for composables
- Component tests
- Integration tests for feature flows

---

## MASTER_PLAN.md Structure

The plan-master creates a comprehensive plan with:

### 1. Executive Summary
- Goal statement
- Overall strategy based on pre-analysis
- Key decisions and rationale
- Estimated complexity

### 2. Pre-Analysis Insights
- Reusable code found
- Patterns to follow
- VueUse opportunities
- Architecture alignment

### 3. Phase Breakdown
For each phase:
- Goal statement
- Tasks with agent assignments
- Objectives and deliverables
- Success criteria and constraints
- Dependencies
- Execution strategy (sequential/parallel)
- Validation checkpoint

### 4. Agent Orchestration
- Execution order diagram
- Parallel execution opportunities
- Agent assignments summary table

### 5. Context for Specialist Agents
For each agent type:
- Reusability guidance
- Constraints to follow
- Reference files to pattern match
- Specific instructions

### 6. Success Criteria
- Overall success checklist
- Phase-specific completion criteria
- Validation requirements

### 7. Risk Assessment
- Potential blockers with impact and mitigation
- Assumptions
- Contingency plans

### 8. Communication Plan
- Agent handoff requirements
- Reporting expectations
- Information to communicate between phases

### 9. Validation Plan
- Automated validation checklist
- Manual validation requirements
- Regression testing plan

### 10. Adaptability Notes
- Flexibility points
- Trust for specialist expertise
- Plan adaptation guidance

---

## Benefits of Using plan-master

### 1. Frontend-Specific Expertise
- Understands Vue/React/Astro architectures
- Knows common frontend patterns
- Familiar with VueUse and ecosystem composables
- Plans for SSR considerations

### 2. Strategic Orchestration
- Focuses on WHAT and WHO, not HOW
- Empowers specialist agents with clear objectives
- Identifies parallel execution opportunities
- Manages dependencies explicitly

### 3. Pre-Analysis Integration
- Leverages code-scout findings effectively
- References specific reusability opportunities
- Follows established patterns
- Minimizes code changes through smart planning

### 4. Clear Communication
- Provides context to specialist agents
- Defines success criteria explicitly
- Documents decisions and rationale
- Creates measurable validation checkpoints

### 5. Adaptability
- Plans remain flexible for specialist discoveries
- Allows for better approaches during implementation
- Documents flexibility points explicitly
- Trusts specialist expertise

---

## Workflow Integration

### Complete Planning Phase Flow

1. **Pre-requisite:** `/frontend-analyze` completed
   - PRE_ANALYSIS.md exists with code-scout findings
   - Solution research completed by documentation-researcher

2. **User runs:** `/frontend-plan "search" "advanced filters"`

3. **Command spawns:** plan-master agent
   - Reads PRE_ANALYSIS.md
   - Analyzes reusability opportunities
   - Determines agent assignments
   - Plans execution phases

4. **plan-master outputs:** MASTER_PLAN.md
   - Executive summary with strategy
   - Phase breakdown with agent assignments
   - Context for each specialist agent
   - Success criteria and validation plan

5. **Main agent presents:** Plan summary to user
   - Key decisions and rationale
   - Phase overview
   - Estimated impact
   - Agent assignments

6. **⚠️ User approval gate:**
   - User reviews MASTER_PLAN.md
   - Can request changes
   - Must approve before implementation

7. **After approval:** Ready for `/frontend-implement`

---

## Validation

### Agent File Checks
- [x] plan-master.md exists and is valid
- [x] Has correct frontmatter (name, description, tools, model)
- [x] Clear planning principles defined
- [x] Output format (MASTER_PLAN.md) specified
- [x] Phase structure templates for different command types

### Command Updates
- [x] frontend-plan.md updated to use plan-master
- [x] Agent spawning syntax uses correct subagent_type
- [x] Mission description aligned with plan-master capabilities
- [x] Planning requirements clearly specified
- [x] Execution notes document agent file location

---

## Testing Recommendations

To test the updated command:

```bash
# Pre-requisite: Run analysis first
/frontend-analyze "your-feature" "something-to-add"

# Then run planning
/frontend-plan "your-feature" "something-to-add"

# Expected outcomes:
# 1. plan-master agent spawns successfully
# 2. Reads PRE_ANALYSIS.md from analyze phase
# 3. Leverages reusability opportunities found
# 4. Creates comprehensive MASTER_PLAN.md
# 5. Assigns appropriate specialist agents
# 6. Defines clear phases and execution order
# 7. Provides context for each specialist
# 8. Includes success criteria and validation plan
# 9. Main agent presents plan summary
# 10. User can review and approve before implementation
```

**Verify:**
- [ ] plan-master spawns correctly
- [ ] Reads and leverages PRE_ANALYSIS.md findings
- [ ] MASTER_PLAN.md is comprehensive and well-structured
- [ ] Agent assignments are appropriate for task
- [ ] Execution order is logical (parallel where possible)
- [ ] Success criteria are clear and measurable
- [ ] Plan is ready for implementation phase

---

## Summary

✅ **Updated:** `/frontend-plan` command to use your specific plan-master agent
✅ **Validated:** plan-master.md agent file is correct and comprehensive
✅ **Integrated:** With pre-analysis phase (reads PRE_ANALYSIS.md)
✅ **Specialized:** Frontend-specific planning expertise
✅ **Strategic:** Focuses on orchestration, not implementation
✅ **Ready:** For testing on real features

**Files Modified:**
- `/Users/natedamstra/.claude/commands/frontend-plan.md`

**Files Referenced:**
- `/Users/natedamstra/.claude/agents/plan-master.md`

**Related Documentation:**
- `/Users/natedamstra/.claude/IMPLEMENTATION_SUMMARY.md` (original implementation)
- `/Users/natedamstra/.claude/AGENT_INTEGRATION_UPDATE.md` (analyze phase update)
- `/Users/natedamstra/.claude/PLAN_AGENT_UPDATE.md` (this file)

---

**Update Complete:** October 16, 2025
**Status:** ✅ Ready for Testing

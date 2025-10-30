---
allowed-tools: Bash(ls:*), Bash(find:*), Bash(mkdir:*), Bash(echo:*)
argument-hint: [task-name] [description]
description: Break down complex tasks into parallel agent execution with intelligent agent selection
---

# Complex Task Breakdown & Parallel Execution

**Task Name:** `$1`
**Task Description:** `$2`

## Phase 1: Task Analysis & Agent Selection

First, analyze the current directory structure and available files to understand the project context:

!`ls -la`

!`find . -maxdepth 3 -type f | head -30`

!`find . -maxdepth 2 -type d`

Create the task workspace:
!`mkdir -p .temp/$1`

## Phase 2: Intelligent Agent Selection

Based on the task description "$2" and project structure, select ONLY the agents actually needed:

**Agent Selection Logic:**
- **Task breakdown needed?** → problem-decomposer-orchestrator agent (for complex multi-part tasks only)
- **TypeScript/JavaScript files?** → typescript-validator agent
- **Vue/Astro components?** → astro-vue-architect agent
- **Python code?** → python-architect agent
- **Need to minimize changes?** → minimal-change-analyzer agent
- **Code quality concerns?** → Code Reviewer agent
- **Codebase exploration?** → Explore agent or code-scout agent

## Phase 3: Targeted Investigation

Spawn only the agents needed based on detected project type and task requirements:

1. **If task is complex with multiple components** → Use problem-decomposer-orchestrator agent first
2. **For each detected technology**, spawn the relevant specialist agent
3. **Document findings** in `.temp/$1/ANALYSIS.md`
4. **Research external docs** if needed (APIs, frameworks, libraries)

Each agent focuses on their specific domain.

## Phase 4: Master Plan Creation

After investigation, create a comprehensive plan document `.temp/$1/MASTER_PLAN.md` that includes:

### Task Breakdown Structure
- **Phase A Tasks** (1-3 items): Core foundation work
- **Phase B Tasks** (1-3 items): Implementation work that depends on Phase A
- **Phase C Tasks** (1-3 items): Integration and testing work
- **Phase D Tasks** (1-3 items): Documentation and cleanup

### Agent Assignment
For each identified task area:
- **One agent per technology/domain** (don't duplicate work)
- **Parallel execution where tasks don't depend on each other**
- **Sequential execution only when there are real dependencies**
- **File access patterns** for each agent's specific domain

### Parallel Execution Strategy
- Which tasks can run simultaneously
- Which tasks must be sequential
- Communication points between agents

## Phase 5: Efficient Execution

Execute tasks using minimal agents:

### Identify Dependencies
- **What can run in parallel?** (independent tasks)
- **What must be sequential?** (real dependencies only)

### Spawn Agents Efficiently
- **One agent per technology domain**
- **Parallel execution where beneficial**
- **No unnecessary coordination overhead**

## Phase 6: Simple Progress Tracking

Each agent updates their progress in `.temp/$1/MASTER_PLAN.md` with:
- **Completion status**
- **Any blockers found**
- **Changes that affect other domains**

## Phase 7: Final Validation

- **Test the solution** meets the original requirement: "$2"
- **Document results** in `.temp/$1/COMPLETION_REPORT.md`
- **Use @code-review only if** there are quality concerns

---

## Execution Instructions

**Claude, please:**

1. **Analyze the project structure** and task "$2" to determine which agents are actually needed
2. **Use problem-decomposer-orchestrator agent ONLY if** the task has multiple complex components that need coordination
3. **Spawn only the relevant specialist agents** based on detected file types and task requirements
4. **Create focused task breakdown** in `.temp/$1/MASTER_PLAN.md` with parallel execution where beneficial
5. **Execute efficiently** using minimal agents for maximum impact
6. **Use Code Reviewer agent only if** quality validation is explicitly needed

Start by detecting what technologies are involved, then spawn only the appropriate agents.
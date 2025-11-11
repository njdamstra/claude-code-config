---
name: use-workflows-v2
description: Generate workflow instructions for planning, debugging, refactoring, and optimization through phase-based orchestration
version: 5.0.0
tags: [workflows, planning, multi-agent, phase-centric]
---

# Workflow System (v5)

Generate phase-by-phase instructions for software engineering workflows. Phase-centric architecture with self-contained YAMLs and runtime prompt generation.

## Quick Start

```bash
# 1. Generate workflow summary
bash ~/.claude/skills/use-workflows-v2/generate-workflow.sh <workflow> <feature-name> [--frontend|--backend|--both]

# 2. Fetch phase details (progressive disclosure)
bash ~/.claude/skills/use-workflows-v2/fetch-phase.sh <workflow> <phase-number-or-name> <feature-name> [--flags]

# 3. Execute phase instructions, then repeat step 2 for next phase
```

## Available Workflows

| Workflow | Time | Purpose |
|----------|------|---------|
| `investigation-workflow` | 20-40 min | Codebase + external research with checkpoints |
| `new-feature-plan` | 30-90 min | Comprehensive feature planning |
| `debugging-plan` | 20-60 min | Root cause analysis |
| `refactoring-plan` | 20-60 min | Code improvement with safety validation |
| `improving-plan` | 20-60 min | Performance optimization |
| `plan-writing-workflow` | 30-60 min | Structured plan documentation |
| `quick-investigation` | 10-15 min | Fast investigation (no subagents) |
| `quick-plan` | 5-15 min | Fast planning (no subagents) |

## Scope Flags

- `--frontend` - Frontend-only subagents
- `--backend` - Backend-only subagents
- `--both` - Fullstack subagents
- (none) - Core subagents only

## Examples

```bash
# Investigation workflow for frontend feature
bash generate-workflow.sh investigation-workflow user-auth --frontend
bash fetch-phase.sh investigation-workflow 1 user-auth --frontend

# Debug fullstack issue
bash generate-workflow.sh debugging-plan hydration-bug --both
bash fetch-phase.sh debugging-plan 1 hydration-bug --both

# Quick investigation (no scope needed)
bash generate-workflow.sh quick-investigation button-issue
bash fetch-phase.sh quick-investigation 1 button-issue
```

## Phase Numbers

Phases are 1-indexed. Use either:
- **Phase number:** `bash fetch-phase.sh investigation-workflow 1 my-feature --frontend`
- **Phase name:** `bash fetch-phase.sh investigation-workflow problem-understanding my-feature --frontend`

## Output Structure

**Workflow summary shows:**
- Workflow metadata (time, tokens, scope)
- Phase list with brief descriptions
- Progressive disclosure instructions

**Phase details show:**
- Subagent spawn instructions (Task tool syntax)
- Expected deliverables
- Gap check criteria
- Checkpoint prompts (if applicable)

## v5 Architecture

**Phase-Centric:**
- Phases are self-contained YAMLs in `phases/`
- Workflows coordinate phases via input wiring
- Runtime prompt generation (no templates)
- 65% fewer files than v4

**Key Benefits:**
- Progressive disclosure (fetch phases on-demand)
- Reusable phases across workflows
- Clean separation of concerns
- Single source of truth per phase

---

## Meta: Modifying This Skill

**For skill development/maintenance only.**

See [WORKFLOW_CREATION_GUIDE.md](WORKFLOW_CREATION_GUIDE.md) for:
- Creating new workflows
- Creating new phases
- Workflow YAML structure
- Phase YAML structure
- Validation and testing

**Note:** Regular users don't need this - use workflows as documented above.

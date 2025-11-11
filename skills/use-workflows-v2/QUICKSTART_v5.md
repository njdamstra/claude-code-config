# v5 Workflow System Quick Start

**Version:** 5.0
**Status:** Production Ready
**Last Updated:** November 6, 2025

---

## Overview

The v5 workflow system uses **standalone phase YAMLs** and **simplified workflow YAMLs** for better maintainability and clarity.

---

## Key Concepts

### Phase YAMLs
- **Location:** `phases-v5/*.yaml`
- **Purpose:** Self-contained phase definitions with subagent configurations
- **Count:** 25 phases available

### Workflow YAMLs
- **Location:** `workflows-v5/*.yaml`
- **Purpose:** Sequence phases with input dependencies and checkpoints
- **Count:** 8 workflows available

---

## Available Workflows

| Workflow | Time | Use Case |
|----------|------|----------|
| `new-feature-plan` | 30-90 min | Comprehensive feature planning |
| `debugging-plan` | 20-60 min | Bug investigation and fix design |
| `refactoring-plan` | 20-60 min | Code improvement planning |
| `improving-plan` | 20-60 min | Performance optimization |
| `plan-writing-workflow` | 30-60 min | Structured PRD creation |
| `investigation-workflow` | 20-40 min | Research with introspection |
| `quick-investigation` | 10-15 min | Fast problem solving |
| `quick-plan` | 5-15 min | Rapid planning |

---

## Usage

### 1. Generate Workflow
```bash
bash generate-workflow-v5.sh <workflow-name> <feature-name> [--frontend|--backend|--both]
```

**Example:**
```bash
bash generate-workflow-v5.sh new-feature-plan user-auth --frontend
```

### 2. Fetch Phase Instructions
```bash
bash fetch-phase-v5.sh <workflow-name> <phase-number> <feature-name> [--frontend|--backend|--both]
```

**Example:**
```bash
bash fetch-phase-v5.sh new-feature-plan 1 user-auth --frontend
```

### 3. Validate Files
```bash
# Validate phase YAML
bash validate-phase-v5.sh phases-v5/discovery.yaml

# Validate workflow YAML
bash validate-workflow-v5.sh workflows-v5/new-feature-plan.yaml
```

---

## Scope Flags

All workflows support scope specification:

- `--frontend` - Frontend-only work (Vue, Astro pages)
- `--backend` - Backend-only work (API routes, functions)
- `--both` - Full-stack work (frontend + backend)

**Scope determines:**
1. Which subagent instructions to include
2. What files to search
3. What patterns to follow

---

## Workflow Details

### New Feature Plan
**Best for:** Major new features requiring comprehensive planning

**Phases:**
1. Discovery - Find existing patterns
2. Requirements - Document user stories
3. Design - Create architecture
4. Synthesis - Consolidate plan
5. Validation - Check feasibility

**Checkpoints:** After discovery, after validation

---

### Debugging Plan
**Best for:** Systematic bug investigation

**Phases:**
1. Investigation - Gather bug context
2. Analysis - Root cause tracing
3. Solution - Fix design
4. Synthesis - Consolidate findings
5. Validation - Validate approach

**Checkpoints:** After analysis, after validation

---

### Refactoring Plan
**Best for:** Code improvement without feature changes

**Phases:**
1. Discovery - Analyze code
2. Analysis - Identify issues
3. Planning - Create refactor plan
4. Synthesis - Consolidate
5. Validation - Safety checks

**Checkpoints:** After analysis, after validation

---

### Investigation Workflow
**Best for:** Research-heavy problems with uncertainty

**Phases:**
1. Problem Understanding - Clarify with user
2. Codebase Investigation - Internal patterns
3. External Research - Best practices
4. Solution Synthesis - Combine findings
5. Introspection - Validate assumptions
6. Approach Refinement - Final approach

**Checkpoints:** After problem understanding, after introspection, after refinement

---

### Quick Investigation
**Best for:** Simple, well-defined problems

**Phases:**
1. Problem Understanding
2. Quick Research
3. Decision Finalization

**Checkpoints:** After problem understanding, after decision

---

### Quick Plan
**Best for:** Rapid plan creation

**Phases:**
1. Plan Init
2. Plan Generation
3. Plan Review

**Checkpoints:** After plan review

---

## Phase Categories

### Discovery Phases
- `discovery` - Codebase pattern discovery
- `codebase-investigation` - Deep codebase analysis
- `quick-research` - Fast file location

### Analysis Phases
- `analysis` - Root cause or code analysis
- `assessment` - Performance assessment
- `investigation` - Bug investigation

### Design Phases
- `design` - Architecture design
- `requirements` - Requirements specification
- `planning` - Execution planning

### Synthesis Phases
- `synthesis` - Consolidate findings
- `solution-synthesis` - Solution consolidation
- `finalization` - Final plan creation

### Validation Phases
- `validation` - Feasibility and completeness
- `quality-review` - Quality checks
- `approach-refinement` - Approach refinement

### Quick Phases
- `plan-init` - Initialize plan
- `plan-generation` - Generate plan
- `plan-review` - Review plan
- `decision-finalization` - Document decision

---

## Common Patterns

### Creating New Phase
1. Copy existing phase YAML
2. Modify name, purpose, subagents
3. Update scope-specific instructions
4. Define inputs/outputs
5. Validate: `bash validate-phase-v5.sh phases-v5/new-phase.yaml`

### Creating New Workflow
1. Copy existing workflow YAML
2. Define phase sequence
3. Add input dependencies
4. Configure checkpoints
5. Validate: `bash validate-workflow-v5.sh workflows-v5/new-workflow.yaml`

---

## File Structure

```
.
├── phases-v5/          # 25 standalone phase definitions
│   ├── discovery.yaml
│   ├── requirements.yaml
│   └── ...
├── workflows-v5/       # 8 workflow definitions
│   ├── new-feature-plan.yaml
│   ├── debugging-plan.yaml
│   └── ...
├── schemas/            # Validation schemas
│   ├── phase-v5.yaml
│   └── workflow-v5.yaml
├── generate-workflow-v5.sh
├── fetch-phase-v5.sh
├── validate-phase-v5.sh
└── validate-workflow-v5.sh
```

---

## Output Structure

### Workflow Output
```
.temp/feature-name/
├── phase-1-phase-name/
│   ├── subagent-output.json
│   └── main-agent-output.md
├── phase-2-phase-name/
│   └── ...
└── workflow-summary.md
```

### Plan Output
```
.claude/plans/feature-name/
├── phase-1-discovery/
│   └── codebase.json
├── phase-2-requirements/
│   └── requirements.json
└── IMPLEMENTATION_PLAN.md
```

---

## Tips

1. **Choose Right Workflow**
   - Complex feature? → `new-feature-plan`
   - Bug? → `debugging-plan`
   - Performance? → `improving-plan`
   - Quick task? → `quick-investigation`

2. **Use Checkpoints**
   - Review outputs before proceeding
   - Catch issues early
   - Refine as needed

3. **Scope Appropriately**
   - Frontend-only? Use `--frontend`
   - Backend-only? Use `--backend`
   - Full-stack? Use `--both`

4. **Validate Early**
   - Run validation after creating/modifying YAMLs
   - Fix issues before execution
   - Prevents runtime errors

---

## Troubleshooting

### Validation Fails
- Check YAML syntax
- Verify required fields present
- Check against schema
- Review error messages

### Missing Phase
- Check phase name spelling
- Verify phase exists in phases-v5/
- Check workflow references correct name

### Incorrect Scope
- Verify scope flag matches workflow needs
- Check phase has scope-specific instructions
- Ensure subagent supports scope

---

## Next Steps

1. **Try a workflow:**
   ```bash
   bash generate-workflow-v5.sh quick-investigation test-problem --frontend
   ```

2. **Fetch first phase:**
   ```bash
   bash fetch-phase-v5.sh quick-investigation 1 test-problem --frontend
   ```

3. **Review output:**
   ```bash
   cat .temp/test-problem/phase-1-problem-understanding/INSTRUCTIONS.md
   ```

---

## Support

- **Documentation:** `ARCHITECTURE_v5.md`
- **Examples:** `workflows-v5/investigation-workflow.yaml`
- **Validation:** `schemas/phase-v5.yaml`, `schemas/workflow-v5.yaml`
- **Migration Notes:** `PHASE_3_COMPLETE.md`

---

**Happy Planning! 🎉**

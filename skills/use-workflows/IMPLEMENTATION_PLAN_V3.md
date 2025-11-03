# Workflow Engine v2 - Implementation Plan V3

**Concise, actionable tasks only. No dual-format support. No tutorial content.**

**Estimated Effort:** 12-14 days
**Complexity:** High
**Risk Level:** Medium

---

## Phase 0: Architecture & Data Models (Days 1-2)

### Task 0.1: Document MVP Execution Path
**File:** `ARCHITECTURE.md`
**Time:** 2h
**Output:** Complete execution flow: Load YAML → Iterate Phases → Finalize → Emit Metadata

### Task 0.2: Define Data Models
**Files:** `DATA_MODELS.md`, `schemas/*.schema.json`
**Time:** 3h
**Output:**
- Workflow schema (YAML structure + JSON schema)
- Phase schema (all modes, behaviors, options)
- Context structure (runtime state)
- Deliverable record format
- Checkpoint record format
- Metadata output format

### Task 0.3: Document Execution Modes
**File:** `EXECUTION_MODES.md`
**Time:** 3h
**Output:**
- Strict mode logic (execute exactly as defined)
- Loose mode logic (main agent full control)
- Adaptive mode logic (core + conditional subagents)
- Behavior mappings (parallel/sequential/main-only)
- Execution pseudocode for each mode

### Task 0.4: Document Checkpoint Flow
**File:** `CHECKPOINT_FLOW.md`
**Time:** 2h
**Output:**
- Simple approval flow
- Custom checkpoint flow
- Action handlers (continue/repeat_phase/skip_phases/abort)
- Conditional checkpoint evaluation
- Context update patterns

### Task 0.5: Document Gap Check Flow
**File:** `GAP_CHECK_FLOW.md`
**Time:** 2h
**Output:**
- Script-based gap check flow
- Criteria-based gap check flow
- Action handlers (retry/spawn_additional/escalate/abort)
- Iteration limits logic
- Context update patterns

### Task 0.6: Document Scripting API
**File:** `SCRIPTING_API.md`
**Time:** 3h
**Output:**
- Helper function signatures (readFile, writeFile, thinkHard, etc.)
- Return value schemas per script type
- Context injection mechanism
- Error handling requirements

### Task 0.7: Document Tooling Requirements
**File:** `TOOLING.md`
**Time:** 2h
**Output:**
- Required: jq, yq, Node.js
- Optional: mustache (with fallback)
- Installation commands per platform
- Invocation patterns
- Dependency checker script

### Task 0.8: Define Testing Matrix
**File:** `TESTING_STRATEGY.md`
**Time:** 2h
**Output:**
- Unit test matrix (loader, executor, context, checkpoint, gap-check, script, template)
- Integration test matrix (each workflow type)
- Execution mode test scenarios
- Performance benchmarks

### Task 0.9: Create Workflow Authoring Tools
**Files:** `tools/new-workflow.sh`, `tools/validator.sh`
**Time:** 3h
**Output:**
- Scaffolding script (generates YAML from template)
- Schema validator (validates against JSON schemas)

### Task 0.10: Build Dependency Checker
**File:** `tools/check-deps.sh`
**Time:** 1h
**Output:**
- Script verifies jq, yq, Node.js availability
- Warns if mustache missing (fallback note)
- Exits non-zero when required dependency absent

---

## Phase 1: Core Engine Implementation (Days 3-5)

### Task 1.1: Core Utilities
**File:** `engine/utils.sh`
**Time:** 2h
**Functions:**
- Logging (log_info, log_error, log_debug)
- File ops (ensure_dir, read_file, write_file)
- JSON/YAML helpers (json_get, yaml_get, yaml_parse)
- Context helpers (context_init, context_set, context_get)
- Error handling (handle_error)
- Template substitution (substitute_vars)

### Task 1.2: YAML Workflow Loader
**File:** `engine/workflow-loader.sh`
**Time:** 4h
**Functions:**
- load_workflow(path) → JSON
- validate_workflow(json) → boolean
- get_phase(json, phase_id) → phase JSON
- get_phase_count(json) → number
- validate_phase(phase) → boolean

**Validation:**
- Required fields present (name, description, phases, finalization)
- Valid execution_modes (strict/loose/adaptive)
- Valid behaviors (parallel/sequential/main-only)
- Phase structure correct

### Task 1.3: Context Manager
**File:** `engine/context-manager.sh`
**Time:** 3h
**Functions:**
- init_context(feature, workflow, flags) → creates context.json
- context_update(key, value) → updates JSON
- context_read(key) → reads value
- phase_start(phase_id) → marks phase active
- phase_complete(phase_id) → adds to completed
- subagent_spawned() → increments counter
- add_deliverable(path) → tracks outputs
- record_checkpoint(id, decision) → saves checkpoint
- save_snapshot() → creates backup

### Task 1.4: Template Renderer
**File:** `engine/template-renderer.sh`
**Time:** 3h
**Functions:**
- render_template(template, context, output) → renders with mustache or fallback
- render_template_simple(template, context, output) → bash fallback ({{var}} only)
- render_subagent_prompt(type, workflow, phase, context) → returns prompt file

**Fallback:** Simple {{variable}} substitution if mustache unavailable

### Task 1.5: Script Interpreter
**File:** `engine/script-interpreter.sh`
**Time:** 4h
**Functions:**
- execute_script(script, context) → executes JS via Node.js
- parse_script_output(output) → extracts commands
- inject_helpers() → provides thinkHard, readFile, etc. as stubs

**Helpers (stubs for MVP):**
- thinkHard(prompt) → logs and returns mock
- readFile(path) → reads file
- readFiles(paths) → reads multiple
- writeFile(path, content) → writes file
- analyzeFiles(dir) → mock coverage
- identifyGaps(coverage) → mock gaps

### Task 1.6: Phase Executor - Strict Mode
**File:** `engine/phase-executor.sh`
**Time:** 6h
**Functions:**
- execute_phase(workflow, phase, context) → main dispatcher
- execute_phase_strict(phase, context) → strict execution
- execute_main_agent_only(phase, context) → run main script
- run_subagent_batch(subagents, behavior, context) → delegates to pool

**Logic:**
- Strict + parallel: call `run_subagent_batch` with behavior=parallel
- Strict + sequential: call `run_subagent_batch` with behavior=sequential
- Strict + main-only: execute main_agent.script (no subagents)

### Task 1.7: Phase Executor - Loose Mode
**File:** `engine/phase-executor.sh` (continuation)
**Time:** 2h
**Functions:**
- execute_phase_loose(phase, context) → loose execution

**Logic:**
- Requires main_agent.script
- Log suggested subagents (informational)
- Execute main_agent.script with full control

### Task 1.8: Phase Executor - Adaptive Mode
**File:** `engine/phase-executor.sh` (continuation)
**Time:** 3h
**Functions:**
- execute_phase_adaptive(phase, context) → adaptive execution

**Logic:**
1. Spawn subagents.always (parallel or sequential per behavior)
2. Execute subagents.adaptive.script
3. Parse returned array of additional subagents
4. Spawn additional subagents via `run_subagent_batch`

### Task 1.9: Subagent Pool Manager
**File:** `engine/subagent-pool.sh`
**Time:** 5h
**Functions:**
- execute_parallel_subagents(subagents, context) → spawn max 5 simultaneously
- execute_parallel_batched(subagents, context) → batch if >5
- execute_sequential_subagents(subagents, context) → spawn one-by-one
- spawn_subagent(config, context) → spawn single subagent
- run_subagent_batch(subagents, behavior, context) → main entry

**Subagent Spawning:**
- Render prompt using workflow-specific template
- Log delegation (Task tool invocation in real Claude Code)
- Create mock output file for MVP
- Track in context

---

## Phase 2: Advanced Features (Days 6-8)

### Task 2.1: Checkpoint Handler - Simple Approval
**File:** `engine/checkpoint-handler.sh`
**Time:** 2h
**Functions:**
- handle_checkpoint(phase, context) → main handler
- handle_simple_approval(phase) → simple yes/no

**Logic:**
- If approval_required: true and no custom checkpoint
- Prompt: "Continue?" → Continue/Abort
- On Abort: exit 0

### Task 2.2: Checkpoint Handler - Custom Checkpoints
**File:** `engine/checkpoint-handler.sh` (continuation)
**Time:** 4h
**Functions:**
- handle_custom_checkpoint(checkpoint, phase, context) → full checkpoint
- execute_checkpoint_action(on_select, phase_id, feedback) → execute action
- should_skip_phase(phase_id) → check skip list

**Logic:**
1. Evaluate condition (if defined)
2. Display prompt
3. Show files (log paths)
4. Present options (log labels)
5. Collect user decision (mock in MVP, AskUserQuestion in real)
6. Collect feedback if with_feedback: true
7. Record in context
8. Execute action:
   - continue → return CONTINUE
   - repeat_phase → return REPEAT_PHASE(target)
   - skip_phases → add to context.skip_phases, return CONTINUE
   - abort → return ABORT

### Task 2.3: Gap Check Manager - Script-Based
**File:** `engine/gap-check-manager.sh`
**Time:** 3h
**Functions:**
- execute_gap_check(phase, context) → main handler
- execute_gap_check_script(script, gap_check, context) → script-based
- handle_gap_check_failure(result, gap_check, context) → handle failures

**Logic:**
1. Execute gap_check.script
2. Parse result: {status, gaps, action, additionalAgents, message}
3. If status == 'complete': continue
4. If status == 'incomplete': execute action
   - retry → check max_iterations, return RETRY_PHASE
   - spawn_additional → spawn agents, return CONTINUE
   - escalate → prompt user, return based on choice
   - abort → exit with error

### Task 2.4: Gap Check Manager - Criteria-Based
**File:** `engine/gap-check-manager.sh` (continuation)
**Time:** 2h
**Functions:**
- execute_gap_check_criteria(criteria, phase, context) → criteria-based

**Logic:**
1. Load gap_check.criteria array
2. For each criterion: evaluate (mock in MVP)
3. Aggregate pass/fail counts
4. If all pass: continue
5. If any fail: execute on_failure action (retry/escalate/abort)

### Task 2.5: Skills Invoker
**File:** `engine/skills-invoker.sh`
**Time:** 3h
**Functions:**
- invoke_skill(skill_config, context) → invoke single skill
- invoke_phase_skills(phase, context) → invoke all skills for phase

**Logic:**
1. Evaluate condition (if defined)
2. Build skill invocation command with args
3. Log invocation (Skill tool in real Claude Code)
4. Track in metadata

**Integration:**
- Add invoke_phase_skills() call at end of execute_phase()

---

## Phase 3: Main Orchestrator (Days 9-10)

### Task 3.1: Main Workflow Runner
**File:** `engine/workflow-runner.sh`
**Time:** 6h
**Functions:**
- run_workflow(path, feature, flags) → main entry point
- announce_workflow_plan(workflow) → display plan to user
- finalize_workflow(workflow, context) → render final plan
- create_metadata(context, output) → generate metadata.json

**Execution Flow:**
```bash
1. Load workflow (load_workflow)
2. Validate workflow
3. Initialize context
4. Announce plan
5. For each phase:
   a. Check if should skip
   b. Execute phase
   c. Execute gap check (handle RETRY_PHASE)
   d. Handle checkpoint (handle REPEAT_PHASE, skip, abort)
   e. Reload context
6. Finalize workflow
7. Create metadata
```

**Return Codes:**
- 0: Success
- 1: Error
- 2: Aborted by user

### Task 3.2: Update SKILL.md Entry Point
**File:** `SKILL.md`
**Time:** 1h
**Changes:**
- Add "Workflow Engine v2" section
- Document usage: `bash engine/workflow-runner.sh workflow.yaml feature-name flags`
- List features (execution modes, checkpoints, gap checks, skills)
- Keep backward compatibility note (existing workflows still work)

---

## Phase 4: YAML Workflows (Days 11-12)

### Task 4.1: Convert new-feature Workflow
**File:** `workflows/new-feature.workflow.yaml`
**Time:** 2h
**Process:**
1. Manually translate registry.json entry to YAML
2. Convert phases array to phase objects with strict mode
3. Map subagents from selection-matrix.json
4. Add gap checks based on phase-registry.json
5. Test execution

### Task 4.2: Convert debugging Workflow
**File:** `workflows/debugging.workflow.yaml`
**Time:** 1.5h
**Process:** Same as new-feature

### Task 4.3: Convert refactoring Workflow
**File:** `workflows/refactoring.workflow.yaml`
**Time:** 1.5h
**Process:** Same as new-feature

### Task 4.4: Convert improving Workflow
**File:** `workflows/improving.workflow.yaml`
**Time:** 1.5h
**Process:** Same as new-feature

### Task 4.5: Convert quick Workflow
**File:** `workflows/quick.workflow.yaml`
**Time:** 1h
**Process:** Same as new-feature

### Task 4.6: Create Subagent Prompt Templates (Priority 10)
**Time:** 8h
**Files:** `subagents/prompts/{type}/{workflow}.md.tmpl`

**Priority subagents:**
1. codebase-scanner (default, new-feature, debugging)
2. web-researcher (default, research)
3. doc-searcher (default, research)
4. code-scout (default, new-feature)
5. pattern-analyzer (default, new-feature)
6. dependency-mapper (default, new-feature)
7. user-story-writer (default, new-feature)
8. architecture-designer (default, new-feature)
9. bug-reproducer (default, debugging)
10. fix-designer (default, debugging)

**Template structure:**
```markdown
---
workflow: {{workflow_name}}
phase: {{phase_id}}
---

# Role: {{subagent_type}}

## Workflow Context
{{workflow_description}}

## Your Task
{task specific to workflow}

## Deliverables
Output to: {{output_path}}

## Previous Phase
{{#previous_phase_summary}}
{{previous_phase_summary}}
{{/previous_phase_summary}}
```

### Task 4.7: Create Example Custom Workflow - Research
**File:** `examples/custom-research.workflow.yaml`
**Time:** 2h
**Features:**
- Adaptive discovery phase
- Checkpoint for user review
- Loose mode deep-dive phase

### Task 4.8: Create Example Custom Workflow - Code Review
**File:** `examples/code-review.workflow.yaml`
**Time:** 1.5h
**Features:**
- Multiple checkpoint gates
- Strict analysis phases

### Task 4.9: Create Example Custom Workflow - Performance
**File:** `examples/performance-optimization.workflow.yaml`
**Time:** 1.5h
**Features:**
- Baseline measurement
- Adaptive optimization
- Validation checkpoint

---

## Phase 5: Testing (Days 13-14)

### Task 5.1: Unit Tests - Workflow Loader
**File:** `tests/unit/test-loader.sh`
**Time:** 3h
**Test cases:**
- Load valid YAML → parsed JSON
- Load invalid YAML → error with line
- Missing required field → validation error
- Invalid execution_mode → validation error
- Invalid behavior → validation error

### Task 5.2: Unit Tests - Phase Executor
**File:** `tests/unit/test-executor.sh`
**Time:** 4h
**Test cases:**
- Strict + parallel → all subagents spawned simultaneously
- Strict + sequential → subagents spawned one-by-one
- Strict + main-only → only main script executed
- Loose mode → main script executed, suggested subagents logged
- Adaptive mode → always spawned, then conditional spawned

### Task 5.3: Unit Tests - Context Manager
**File:** `tests/unit/test-context.sh`
**Time:** 2h
**Test cases:**
- Initialize context → context.json created
- Update value → JSON updated
- Read value → correct value returned
- Phase tracking → current_phase and completed_phases updated
- Subagent counting → counter incremented
- Deliverable tracking → paths added to array

### Task 5.4: Unit Tests - Checkpoint Handler
**File:** `tests/unit/test-checkpoint.sh`
**Time:** 3h
**Test cases:**
- Simple approval (continue) → proceed
- Simple approval (abort) → exit
- Custom checkpoint (continue) → proceed
- Custom checkpoint (repeat_phase) → phase index updated
- Custom checkpoint (skip_phases) → phases added to skip list
- Custom checkpoint (abort) → exit
- Conditional checkpoint (false) → skipped
- Conditional checkpoint (true) → shown

### Task 5.5: Unit Tests - Gap Check Manager
**File:** `tests/unit/test-gap-check.sh`
**Time:** 3h
**Test cases:**
- Gap check disabled → skipped
- Script-based pass → continue
- Script-based fail (retry) → phase repeated
- Script-based fail (spawn_additional) → agents spawned
- Script-based fail (escalate) → user prompted
- Script-based fail (abort) → exit
- Max iterations → escalation triggered
- Criteria-based pass → continue
- Criteria-based fail → action executed

### Task 5.6: Unit Tests - Script Interpreter
**File:** `tests/unit/test-script.sh`
**Time:** 2h
**Test cases:**
- Execute valid script → correct return value
- Script with context → context accessible
- Script error → error logged, handled
- Script timeout → timeout after 30s
- Invalid return value → warning logged

### Task 5.7: Unit Tests - Template Renderer
**File:** `tests/unit/test-template.sh`
**Time:** 2h
**Test cases:**
- Render with mustache → correct output
- Render with fallback → correct output
- Variable substitution → {{var}} replaced
- Missing variable → empty string
- Subagent prompt → workflow-specific template used

### Task 5.8: Integration Test - new-feature Workflow
**File:** `tests/integration/test-new-feature.sh`
**Time:** 2h
**Test:**
- Execute complete workflow
- Verify all phases executed
- Verify deliverables created
- Verify metadata.json correct

### Task 5.9: Integration Test - debugging Workflow
**File:** `tests/integration/test-debugging.sh`
**Time:** 1.5h
**Test:** Same structure as new-feature

### Task 5.10: Integration Test - refactoring Workflow
**File:** `tests/integration/test-refactoring.sh`
**Time:** 1.5h
**Test:** Same structure as new-feature

### Task 5.11: Integration Test - Custom Workflows
**File:** `tests/integration/test-custom-workflows.sh`
**Time:** 2h
**Test:** Execute all 3 example custom workflows

### Task 5.12: Create Test Runner
**File:** `tests/run-all-tests.sh`
**Time:** 1h
**Output:**
- Runs all unit tests
- Runs all integration tests
- Reports pass/fail counts
- Exits 0 if all pass, 1 if any fail

---

## Phase 6: Documentation & Launch (Days 14-15)

### Task 6.1: User README
**File:** `README.md`
**Time:** 2h
**Sections:**
- Quick start (3 examples)
- Execution modes (1 paragraph each)
- Checkpoint usage (1 example)
- Gap check usage (1 example)
- Creating custom workflows (link to new-workflow.sh)

### Task 6.2: YAML Syntax Reference
**File:** `resources/yaml-syntax.md`
**Time:** 1.5h
**Content:**
- Workflow structure with field descriptions
- Phase structure with field descriptions
- Subagent config structure
- Checkpoint config structure
- Gap check config structure

### Task 6.3: Migration Guide (YAML Only)
**File:** `resources/migration-guide.md`
**Time:** 1h
**Content:**
- How to create new YAML workflows
- Differences from old JSON system
- No conversion needed (fresh start)

### Task 6.4: Execute All Tests
**Time:** 2h
**Process:**
1. Run unit tests: `bash tests/run-all-tests.sh --unit`
2. Run integration tests: `bash tests/run-all-tests.sh --integration`
3. Fix any failures
4. Verify 100% pass rate

### Task 6.5: Manual Smoke Test
**Time:** 3h
**Process:**
1. Create real feature using new-feature workflow
2. Verify all subagents spawn
3. Test checkpoint (choose different options)
4. Test gap check (trigger retry)
5. Verify final plan looks correct
6. Verify metadata.json accurate

### Task 6.6: Archive Legacy JSON System
**Time:** 1h
**Process:**
1. Move `workflows/*.json` to `workflows/legacy/`
2. Move `phases/*.json` to `phases/legacy/`
3. Move `subagents/selection-matrix.json` to `subagents/legacy/`
4. Update SKILL.md to reference YAML workflows only

---

## Dependencies & Risks

### External Dependencies
- jq (required)
- yq (required)
- Node.js (required)
- mustache (optional, have fallback)

### Risks

| Risk | Mitigation |
|------|------------|
| YAML parsing performance | Cache parsed workflows in memory |
| Script execution overhead | Keep scripts minimal, use main agent logic |
| Complex debugging | Verbose logging, step-by-step mode |
| Token usage | Progressive disclosure, batch operations |

---

## Acceptance Criteria

### Must Have
- [ ] All 5 existing workflows converted to YAML and functional
- [ ] Strict/loose/adaptive execution modes working
- [ ] Parallel/sequential/main-only behaviors working
- [ ] Human-in-loop checkpoints functional (simple and custom)
- [ ] Gap checks with custom scripts working
- [ ] Workflow-specific subagent prompts rendering
- [ ] Skills integration working
- [ ] Context management persisting across phases
- [ ] Template rendering for final plans
- [ ] Metadata generation complete
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] Tool dependency checker working

### Should Have
- [ ] Conditional phase execution (skip_if)
- [ ] Phase iteration limits (max_iterations)
- [ ] 3 example custom workflows
- [ ] 10 subagent prompt templates
- [ ] Workflow scaffolding tool (new-workflow.sh)
- [ ] Schema validator tool (validator.sh)

### Nice to Have
- [ ] Parallel phase groups (depends_on)
- [ ] Workflow composition (extends)
- [ ] Resume from checkpoint capability

---

## Task Summary

**Phase 0:** 9 tasks, 19 hours
**Phase 1:** 9 tasks, 32 hours
**Phase 2:** 5 tasks, 14 hours
**Phase 3:** 2 tasks, 7 hours
**Phase 4:** 9 tasks, 21.5 hours
**Phase 5:** 12 tasks, 26.5 hours
**Phase 6:** 6 tasks, 10.5 hours

**Total:** 52 tasks, 130.5 hours (~16 days @ 8h/day)

---

## Implementation Order

Execute phases sequentially. Tasks within a phase can be parallelized where noted.

**Critical path:**
Phase 0 → Phase 1 → Phase 3 → Phase 4 (tasks 4.1-4.5) → Phase 5 → Phase 6

**Can be done in parallel with Phase 1:**
Phase 2 (checkpoints and gap checks)

**Can be done anytime after Phase 4 (tasks 4.1-4.5):**
Phase 4 (tasks 4.6-4.9) - subagent templates and examples

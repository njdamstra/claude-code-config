# Workflow Engine v2 - Implementation Plan

## Executive Summary

This plan details the complete implementation of the Hybrid Workflow Engine v2 for Claude Code skills environment. The engine enables declarative YAML workflow definitions with inline scripting, supporting strict/loose/adaptive execution modes, human-in-the-loop checkpoints, dynamic subagent orchestration, and skills integration.

**Estimated Effort:** 10-12 days
**Complexity:** High
**Risk Level:** Medium (backward compatibility required)

---

## Architecture Overview

### System Components

```
Workflow Engine v2 Architecture

┌─────────────────────────────────────────────────────────────┐
│                    Main Agent (Coordinator)                  │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                  Workflow Engine Core                        │
│  • YAML Loader                                              │
│  • Phase Executor (Strict/Loose/Adaptive)                   │
│  • Behavior Coordinator (Parallel/Sequential/Main-Only)      │
│  • Checkpoint Handler (Human-in-Loop)                       │
│  • Gap Check Manager                                        │
│  • Context Manager                                          │
│  • Script Interpreter                                       │
└───────────────┬─────────────────────────────────────────────┘
                │
    ┌───────────┼───────────┬──────────────┐
    │           │           │              │
    ▼           ▼           ▼              ▼
┌────────┐  ┌────────┐  ┌─────────┐  ┌──────────┐
│Subagent│  │Subagent│  │ Skills  │  │Templates │
│ Pool   │  │Prompts │  │Invoker  │  │ Renderer │
└────────┘  └────────┘  └─────────┘  └──────────┘
```

### File Structure

```
~/.claude/skills/use-workflows/
├── SKILL.md                          # Skill entry point (updated)
├── REQUIREMENTS.md                   # This document's companion
├── IMPLEMENTATION_PLAN.md            # This document
├── README.md                         # User-facing documentation
│
├── engine/                           # Core engine (NEW)
│   ├── workflow-loader.sh           # YAML loading & parsing
│   ├── phase-executor.sh            # Phase execution logic
│   ├── subagent-pool.sh             # Parallel orchestration
│   ├── checkpoint-handler.sh        # Human-in-loop logic
│   ├── gap-check-manager.sh         # Gap check execution
│   ├── context-manager.sh           # Context persistence
│   ├── script-interpreter.sh        # Inline script execution
│   ├── template-renderer.sh         # Mustache rendering
│   └── utils.sh                     # Shared utilities
│
├── workflows/                        # Workflow definitions
│   ├── registry.yaml                # NEW: Workflow catalog (YAML)
│   ├── new-feature.workflow.yaml    # NEW: Converted from JSON
│   ├── debugging.workflow.yaml      # NEW
│   ├── refactoring.workflow.yaml    # NEW
│   ├── improving.workflow.yaml      # NEW
│   ├── quick.workflow.yaml          # NEW
│   └── legacy/                      # OLD: Keep for reference
│       ├── registry.json
│       └── ...
│
├── phases/                           # Phase definitions
│   ├── phase-registry.yaml          # NEW: Phase catalog (YAML)
│   ├── phase-behaviors.yaml         # NEW: Behavior presets
│   └── legacy/
│       ├── phase-registry.json
│       └── ...
│
├── subagents/                        # Subagent configuration
│   ├── selection-matrix.yaml        # NEW: Selection rules (YAML)
│   ├── prompts/                     # NEW: Workflow-specific prompts
│   │   ├── codebase-scanner/
│   │   │   ├── default.md.tmpl
│   │   │   ├── new-feature.md.tmpl
│   │   │   ├── debugging.md.tmpl
│   │   │   └── research.md.tmpl
│   │   ├── web-researcher/
│   │   │   ├── default.md.tmpl
│   │   │   └── research.md.tmpl
│   │   └── ...
│   └── legacy/
│       └── selection-matrix.json
│
├── templates/                        # Final output templates
│   ├── new-feature.md.tmpl
│   ├── debugging.md.tmpl
│   ├── refactoring.md.tmpl
│   ├── improving.md.tmpl
│   ├── quick.md.tmpl
│   └── partials/                    # Reusable template sections
│       ├── header.md.tmpl
│       ├── task-list.md.tmpl
│       └── metadata.md.tmpl
│
├── scripts/                          # Reusable script behaviors
│   ├── adaptive-discovery.js        # Adaptive subagent selection
│   ├── gap-check-coverage.js        # Coverage gap checking
│   ├── user-approval.js             # Checkpoint approval logic
│   └── synthesis-aggregator.js      # Multi-phase synthesis
│
├── tools/                            # Utilities
│   ├── converter.sh                 # JSON → YAML converter
│   ├── validator.sh                 # YAML schema validator
│   └── test-workflow.sh             # Workflow testing utility
│
├── examples/                         # Example workflows
│   ├── custom-research.workflow.yaml
│   ├── code-review.workflow.yaml
│   └── performance-optimization.workflow.yaml
│
└── resources/                        # Documentation
    ├── orchestration.md             # Existing
    ├── yaml-syntax.md               # NEW: YAML syntax guide
    ├── script-api.md                # NEW: Script API reference
    ├── template-syntax.md           # NEW: Template guide
    └── migration-guide.md           # NEW: JSON → YAML migration
```

---

## Phase 1: Foundation & Infrastructure (Days 1-2)

### Task 1.1: Core Engine Utilities
**File:** `engine/utils.sh`
**Estimated:** 2 hours

**Deliverable:**
```bash
#!/bin/bash
# Core utility functions for workflow engine

# Logging
log_info() { echo "[INFO] $(date +%H:%M:%S) - $*"; }
log_error() { echo "[ERROR] $(date +%H:%M:%S) - $*" >&2; }
log_debug() { [[ "$DEBUG" == "true" ]] && echo "[DEBUG] $(date +%H:%M:%S) - $*"; }

# File operations
ensure_dir() { mkdir -p "$1"; }
read_file() { cat "$1" 2>/dev/null || echo ""; }
write_file() { echo "$2" > "$1"; }
append_file() { echo "$2" >> "$1"; }

# JSON helpers (using jq)
json_get() { echo "$1" | jq -r "$2"; }
json_set() { echo "$1" | jq "$2 = $3"; }

# YAML helpers (using yq or Python)
yaml_get() { yq eval "$2" "$1" 2>/dev/null || echo ""; }
yaml_parse() { yq eval -o=json "$1" 2>/dev/null; }

# Context management
context_init() {
  export WORKFLOW_CONTEXT_FILE="${1}/.temp/context.json"
  ensure_dir "$(dirname "$WORKFLOW_CONTEXT_FILE")"
  echo '{}' > "$WORKFLOW_CONTEXT_FILE"
}

context_set() {
  local key="$1"
  local value="$2"
  local current=$(cat "$WORKFLOW_CONTEXT_FILE")
  echo "$current" | jq ".${key} = ${value}" > "$WORKFLOW_CONTEXT_FILE"
}

context_get() {
  local key="$1"
  jq -r ".${key}" "$WORKFLOW_CONTEXT_FILE"
}

# Template variable substitution
substitute_vars() {
  local template="$1"
  local context="$2"

  # Replace ${var} with context values
  echo "$template" | envsubst
}

# Error handling
handle_error() {
  log_error "$1"
  context_set "error" "\"$1\""
  context_set "status" '"failed"'
  exit 1
}
```

**Validation:**
- Test logging functions
- Test file operations
- Test JSON/YAML parsing
- Test context management

---

### Task 1.2: YAML Workflow Loader
**File:** `engine/workflow-loader.sh`
**Estimated:** 4 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"

# Load workflow definition from YAML file
load_workflow() {
  local workflow_path="$1"

  log_info "Loading workflow: $workflow_path"

  # Validate file exists
  if [[ ! -f "$workflow_path" ]]; then
    handle_error "Workflow file not found: $workflow_path"
  fi

  # Parse YAML to JSON for easier manipulation
  local workflow_json=$(yaml_parse "$workflow_path")

  if [[ -z "$workflow_json" ]]; then
    handle_error "Failed to parse workflow YAML"
  fi

  # Extract workflow metadata
  export WORKFLOW_NAME=$(echo "$workflow_json" | jq -r '.name')
  export WORKFLOW_DESCRIPTION=$(echo "$workflow_json" | jq -r '.description')
  export WORKFLOW_PHASES=$(echo "$workflow_json" | jq -c '.phases')
  export WORKFLOW_VARIABLES=$(echo "$workflow_json" | jq -c '.variables // {}')
  export WORKFLOW_FINALIZATION=$(echo "$workflow_json" | jq -c '.finalization')

  log_info "Workflow loaded: $WORKFLOW_NAME"
  log_info "Phases: $(echo "$WORKFLOW_PHASES" | jq 'length')"

  echo "$workflow_json"
}

# Get phase definition by ID
get_phase() {
  local workflow_json="$1"
  local phase_id="$2"

  echo "$workflow_json" | jq -c ".phases[] | select(.id == \"$phase_id\")"
}

# Get phase count
get_phase_count() {
  local workflow_json="$1"
  echo "$workflow_json" | jq '.phases | length'
}

# Validate workflow structure
validate_workflow() {
  local workflow_json="$1"

  # Check required fields
  local name=$(echo "$workflow_json" | jq -r '.name')
  local phases=$(echo "$workflow_json" | jq -r '.phases')

  if [[ "$name" == "null" ]]; then
    handle_error "Workflow missing required field: name"
  fi

  if [[ "$phases" == "null" ]]; then
    handle_error "Workflow missing required field: phases"
  fi

  # Validate each phase
  local phase_count=$(get_phase_count "$workflow_json")
  for ((i=0; i<phase_count; i++)); do
    local phase=$(echo "$workflow_json" | jq -c ".phases[$i]")
    validate_phase "$phase"
  done

  log_info "Workflow validation passed"
}

# Validate phase structure
validate_phase() {
  local phase="$1"

  local id=$(echo "$phase" | jq -r '.id')
  local execution_mode=$(echo "$phase" | jq -r '.execution_mode // "strict"')
  local behavior=$(echo "$phase" | jq -r '.behavior // "parallel"')

  if [[ "$id" == "null" ]]; then
    handle_error "Phase missing required field: id"
  fi

  # Validate execution_mode values
  case "$execution_mode" in
    strict|loose|adaptive) ;;
    *) handle_error "Invalid execution_mode: $execution_mode" ;;
  esac

  # Validate behavior values
  case "$behavior" in
    parallel|sequential|main-only) ;;
    *) handle_error "Invalid behavior: $behavior" ;;
  esac
}
```

**Validation:**
- Load sample YAML workflow
- Validate structure
- Extract phase definitions
- Handle malformed YAML

---

### Task 1.3: Context Manager
**File:** `engine/context-manager.sh`
**Estimated:** 3 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"

# Initialize workflow context
init_context() {
  local feature_name="$1"
  local workflow_name="$2"
  local flags="$3"

  export CONTEXT_DIR=".claude/plans/${feature_name}"
  export CONTEXT_TEMP="${CONTEXT_DIR}/.temp"
  export CONTEXT_FILE="${CONTEXT_TEMP}/context.json"

  ensure_dir "$CONTEXT_TEMP"

  # Initialize context JSON
  cat > "$CONTEXT_FILE" <<EOF
{
  "feature_name": "${feature_name}",
  "workflow_name": "${workflow_name}",
  "flags": ${flags:-[]},
  "start_time": "$(date -Iseconds)",
  "current_phase": null,
  "completed_phases": [],
  "subagents_spawned": 0,
  "iterations": {},
  "checkpoints": {},
  "deliverables": [],
  "status": "running"
}
EOF

  log_info "Context initialized: $CONTEXT_FILE"
}

# Update context value
context_update() {
  local key="$1"
  local value="$2"

  local temp=$(mktemp)
  jq ".${key} = ${value}" "$CONTEXT_FILE" > "$temp"
  mv "$temp" "$CONTEXT_FILE"
}

# Get context value
context_read() {
  local key="$1"
  jq -r ".${key}" "$CONTEXT_FILE"
}

# Mark phase as started
phase_start() {
  local phase_id="$1"

  context_update "current_phase" "\"${phase_id}\""
  log_info "Phase started: $phase_id"
}

# Mark phase as completed
phase_complete() {
  local phase_id="$1"

  local completed=$(context_read "completed_phases")
  local updated=$(echo "$completed" | jq ". += [\"${phase_id}\"]")
  context_update "completed_phases" "$updated"

  log_info "Phase completed: $phase_id"
}

# Increment subagent count
subagent_spawned() {
  local current=$(context_read "subagents_spawned")
  local updated=$((current + 1))
  context_update "subagents_spawned" "$updated"
}

# Add deliverable
add_deliverable() {
  local path="$1"
  local deliverables=$(context_read "deliverables")
  local updated=$(echo "$deliverables" | jq ". += [\"${path}\"]")
  context_update "deliverables" "$updated"
}

# Record checkpoint decision
record_checkpoint() {
  local checkpoint_id="$1"
  local decision="$2"

  context_update "checkpoints.${checkpoint_id}" "\"${decision}\""
}

# Save context snapshot (for resumption)
save_snapshot() {
  local snapshot_file="${CONTEXT_DIR}/snapshots/$(date +%s).json"
  ensure_dir "$(dirname "$snapshot_file")"
  cp "$CONTEXT_FILE" "$snapshot_file"
  log_info "Context snapshot saved: $snapshot_file"
}
```

**Validation:**
- Initialize context
- Update values
- Read values
- Phase tracking
- Checkpoint recording

---

### Task 1.4: Template Renderer
**File:** `engine/template-renderer.sh`
**Estimated:** 3 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"

# Render Mustache template with context
render_template() {
  local template_path="$1"
  local context_json="$2"
  local output_path="$3"

  log_info "Rendering template: $template_path"

  # Check if mustache CLI is available
  if command -v mustache &> /dev/null; then
    echo "$context_json" | mustache - "$template_path" > "$output_path"
  else
    # Fallback: simple variable substitution
    render_template_simple "$template_path" "$context_json" "$output_path"
  fi

  log_info "Template rendered: $output_path"
}

# Simple template renderer (fallback)
render_template_simple() {
  local template_path="$1"
  local context_json="$2"
  local output_path="$3"

  local content=$(cat "$template_path")

  # Extract all {{variable}} patterns
  local vars=$(echo "$content" | grep -oE '\{\{[^}]+\}\}' | sed 's/[{}]//g' | sort -u)

  # Replace each variable
  for var in $vars; do
    local value=$(echo "$context_json" | jq -r ".${var} // \"\"")
    content=$(echo "$content" | sed "s|{{${var}}}|${value}|g")
  done

  echo "$content" > "$output_path"
}

# Render subagent prompt template
render_subagent_prompt() {
  local subagent_type="$1"
  local workflow_name="$2"
  local phase_id="$3"
  local context_json="$4"

  local template_dir="$(dirname "$0")/../subagents/prompts/${subagent_type}"
  local template_file=""

  # Try workflow-specific template first
  if [[ -f "${template_dir}/${workflow_name}.md.tmpl" ]]; then
    template_file="${template_dir}/${workflow_name}.md.tmpl"
  elif [[ -f "${template_dir}/default.md.tmpl" ]]; then
    template_file="${template_dir}/default.md.tmpl"
  else
    log_error "No template found for subagent: $subagent_type"
    return 1
  fi

  # Add template-specific context
  local enhanced_context=$(echo "$context_json" | jq \
    ". + {subagent_type: \"$subagent_type\", workflow_name: \"$workflow_name\", phase_id: \"$phase_id\"}")

  # Render to temp file
  local output_file=$(mktemp)
  render_template "$template_file" "$enhanced_context" "$output_file"

  echo "$output_file"
}
```

**Validation:**
- Render simple templates
- Variable substitution
- Mustache conditionals
- Subagent prompt generation

---

## Phase 2: Core Execution Engine (Days 3-4)

### Task 2.1: Script Interpreter
**File:** `engine/script-interpreter.sh`
**Estimated:** 4 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"

# Execute inline JavaScript script
execute_script() {
  local script="$1"
  local context_json="$2"

  log_debug "Executing script: ${script:0:50}..."

  # Create temp script file
  local script_file=$(mktemp --suffix=.js)

  # Wrap script with context injection
  cat > "$script_file" <<EOF
// Injected context
const context = ${context_json};

// Helper functions
const thinkHard = async (prompt) => {
  // Placeholder: Main agent would execute this
  console.log("THINK_HARD:", prompt);
  return { decision: "yes", reasoning: "Mock decision" };
};

const readFiles = async (paths) => {
  // Placeholder: Would read actual files
  console.log("READ_FILES:", paths);
  return {};
};

const writeFile = async (path, content) => {
  console.log("WRITE_FILE:", path);
};

const analyzeFiles = async (dir) => {
  console.log("ANALYZE_FILES:", dir);
  return { coverage: 0.8 };
};

const identifyGaps = async (coverage) => {
  return [];
};

// User script
(async () => {
  ${script}
})();
EOF

  # Execute with Node.js
  local result=$(node "$script_file" 2>&1)
  local exit_code=$?

  rm "$script_file"

  if [[ $exit_code -ne 0 ]]; then
    log_error "Script execution failed: $result"
    return 1
  fi

  echo "$result"
}

# Parse script output for commands
parse_script_output() {
  local output="$1"

  # Extract THINK_HARD commands
  local think_hard=$(echo "$output" | grep "THINK_HARD:" | sed 's/THINK_HARD: //')

  # Extract file operations
  local read_files=$(echo "$output" | grep "READ_FILES:" | sed 's/READ_FILES: //')
  local write_files=$(echo "$output" | grep "WRITE_FILE:" | sed 's/WRITE_FILE: //')

  # Return structured JSON
  jq -n \
    --arg think "$think_hard" \
    --arg read "$read_files" \
    --arg write "$write_files" \
    '{think_hard: $think, read_files: $read, write_files: $write}'
}
```

**Validation:**
- Execute simple scripts
- Context injection
- Error handling
- Output parsing

---

### Task 2.2: Phase Executor - Strict Mode
**File:** `engine/phase-executor.sh`
**Estimated:** 6 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/subagent-pool.sh"
source "$(dirname "$0")/script-interpreter.sh"

# Execute phase based on execution mode
execute_phase() {
  local workflow_json="$1"
  local phase="$2"
  local context_json="$3"

  local phase_id=$(echo "$phase" | jq -r '.id')
  local execution_mode=$(echo "$phase" | jq -r '.execution_mode // "strict"')
  local behavior=$(echo "$phase" | jq -r '.behavior // "parallel"')

  log_info "Executing phase: $phase_id (mode: $execution_mode, behavior: $behavior)"

  phase_start "$phase_id"

  case "$execution_mode" in
    strict)
      execute_phase_strict "$phase" "$context_json"
      ;;
    loose)
      execute_phase_loose "$phase" "$context_json"
      ;;
    adaptive)
      execute_phase_adaptive "$phase" "$context_json"
      ;;
    *)
      handle_error "Unknown execution mode: $execution_mode"
      ;;
  esac

  phase_complete "$phase_id"
}

# Execute phase in STRICT mode
execute_phase_strict() {
  local phase="$1"
  local context_json="$2"

  local behavior=$(echo "$phase" | jq -r '.behavior // "parallel"')
  local subagents=$(echo "$phase" | jq -c '.subagents.always // []')

  log_info "Strict mode: Following phase definition exactly"

  case "$behavior" in
    parallel)
      execute_parallel_subagents "$subagents" "$context_json"
      ;;
    sequential)
      execute_sequential_subagents "$subagents" "$context_json"
      ;;
    main-only)
      execute_main_agent_only "$phase" "$context_json"
      ;;
  esac
}

# Execute phase in LOOSE mode
execute_phase_loose() {
  local phase="$1"
  local context_json="$2"

  log_info "Loose mode: Main agent has freedom"

  # Check if main_agent script exists
  local main_script=$(echo "$phase" | jq -r '.main_agent.script // null')

  if [[ "$main_script" == "null" ]]; then
    handle_error "Loose mode requires main_agent.script"
  fi

  # Show suggested subagents (informational)
  local suggested=$(echo "$phase" | jq -c '.subagents.suggested // []')
  if [[ "$suggested" != "[]" ]]; then
    log_info "Suggested subagents: $suggested"
  fi

  # Execute main agent script
  log_info "Executing main agent script (loose mode)"
  execute_script "$main_script" "$context_json"
}

# Execute phase in ADAPTIVE mode
execute_phase_adaptive() {
  local phase="$1"
  local context_json="$2"

  log_info "Adaptive mode: Main agent decides subagents"

  # Always spawn these subagents first
  local always=$(echo "$phase" | jq -c '.subagents.always // []')
  if [[ "$always" != "[]" ]]; then
    execute_parallel_subagents "$always" "$context_json"
  fi

  # Main agent decides additional subagents
  local adaptive=$(echo "$phase" | jq -r '.subagents.adaptive // null')

  if [[ "$adaptive" != "null" ]]; then
    local adaptive_script=$(echo "$adaptive" | jq -r '.script')

    log_info "Main agent deciding adaptive subagents..."
    local decision=$(execute_script "$adaptive_script" "$context_json")

    # Parse decision (should return array of subagent configs)
    local additional_agents=$(echo "$decision" | jq -c 'if type == "array" then . else [] end')

    if [[ "$additional_agents" != "[]" ]]; then
      log_info "Spawning additional subagents: $additional_agents"
      execute_parallel_subagents "$additional_agents" "$context_json"
    fi
  fi
}

# Execute main agent only (no subagents)
execute_main_agent_only() {
  local phase="$1"
  local context_json="$2"

  log_info "Main-only behavior: No subagents"

  local main_script=$(echo "$phase" | jq -r '.main_agent.script // null')

  if [[ "$main_script" == "null" ]]; then
    log_info "No main_agent script defined, skipping"
    return 0
  fi

  execute_script "$main_script" "$context_json"
}
```

**Validation:**
- Execute strict phases
- Execute loose phases
- Execute adaptive phases
- Main-only phases

---

### Task 2.3: Subagent Pool Manager
**File:** `engine/subagent-pool.sh`
**Estimated:** 5 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/template-renderer.sh"

MAX_PARALLEL_SUBAGENTS=5

# Execute subagents in parallel
execute_parallel_subagents() {
  local subagents_json="$1"
  local context_json="$2"

  local count=$(echo "$subagents_json" | jq 'length')
  log_info "Spawning $count subagents in parallel"

  # Limit to MAX_PARALLEL_SUBAGENTS
  if [[ $count -gt $MAX_PARALLEL_SUBAGENTS ]]; then
    log_info "Splitting into batches of $MAX_PARALLEL_SUBAGENTS"
    execute_parallel_batched "$subagents_json" "$context_json"
    return
  fi

  # Spawn all subagents
  for ((i=0; i<count; i++)); do
    local subagent=$(echo "$subagents_json" | jq -c ".[$i]")
    spawn_subagent "$subagent" "$context_json" &
  done

  # Wait for all to complete
  wait

  log_info "All subagents completed"
}

# Execute subagents in batches
execute_parallel_batched() {
  local subagents_json="$1"
  local context_json="$2"

  local total=$(echo "$subagents_json" | jq 'length')
  local batches=$(( (total + MAX_PARALLEL_SUBAGENTS - 1) / MAX_PARALLEL_SUBAGENTS ))

  for ((batch=0; batch<batches; batch++)); do
    local start=$((batch * MAX_PARALLEL_SUBAGENTS))
    local end=$((start + MAX_PARALLEL_SUBAGENTS))

    log_info "Batch $((batch+1))/$batches"

    for ((i=start; i<end && i<total; i++)); do
      local subagent=$(echo "$subagents_json" | jq -c ".[$i]")
      spawn_subagent "$subagent" "$context_json" &
    done

    wait
  done
}

# Execute subagents sequentially
execute_sequential_subagents() {
  local subagents_json="$1"
  local context_json="$2"

  local count=$(echo "$subagents_json" | jq 'length')
  log_info "Spawning $count subagents sequentially"

  for ((i=0; i<count; i++)); do
    local subagent=$(echo "$subagents_json" | jq -c ".[$i]")
    spawn_subagent "$subagent" "$context_json"
  done

  log_info "All subagents completed"
}

# Spawn single subagent
spawn_subagent() {
  local subagent_config="$1"
  local context_json="$2"

  local type=$(echo "$subagent_config" | jq -r '.type')
  local output=$(echo "$subagent_config" | jq -r '.output')
  local prompt_override=$(echo "$subagent_config" | jq -r '.prompt // null')

  log_info "Spawning subagent: $type"

  # Get workflow context
  local workflow_name=$(echo "$context_json" | jq -r '.workflow_name')
  local phase_id=$(echo "$context_json" | jq -r '.current_phase')

  # Render prompt
  local prompt_file=""
  if [[ "$prompt_override" != "null" && "$prompt_override" =~ ^@template: ]]; then
    # Use template reference
    local template_name="${prompt_override#@template:}"
    prompt_file=$(render_subagent_prompt "$type" "$template_name" "$phase_id" "$context_json")
  elif [[ "$prompt_override" != "null" ]]; then
    # Use inline prompt
    prompt_file=$(mktemp)
    echo "$prompt_override" > "$prompt_file"
  else
    # Use default template
    prompt_file=$(render_subagent_prompt "$type" "$workflow_name" "$phase_id" "$context_json")
  fi

  local prompt=$(cat "$prompt_file")
  rm -f "$prompt_file"

  # NOTE: In actual Claude Code environment, this would use Task tool
  # For now, we log the delegation instruction
  log_info "DELEGATE TO SUBAGENT: $type"
  log_info "Output: $output"
  log_debug "Prompt: ${prompt:0:100}..."

  # Simulate subagent execution (placeholder)
  # In real implementation, this would be:
  # Task tool with subagent_type=$type, prompt=$prompt

  # Create output file (mock)
  ensure_dir "$(dirname "$output")"
  echo "{\"subagent\": \"$type\", \"status\": \"completed\"}" > "$output"

  subagent_spawned
  add_deliverable "$output"

  log_info "Subagent completed: $type"
}
```

**Validation:**
- Parallel execution
- Sequential execution
- Batching large groups
- Prompt rendering
- Output tracking

---

## Phase 3: Human-in-Loop & Gap Checks (Day 5)

### Task 3.1: Checkpoint Handler
**File:** `engine/checkpoint-handler.sh`
**Estimated:** 4 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/context-manager.sh"

# Handle phase checkpoint
handle_checkpoint() {
  local phase="$1"
  local context_json="$2"

  local checkpoint=$(echo "$phase" | jq -c '.checkpoint // null')
  local approval_required=$(echo "$phase" | jq -r '.approval_required // false')

  # Check if checkpoint needed
  if [[ "$checkpoint" == "null" && "$approval_required" == "false" ]]; then
    return 0
  fi

  # Simple approval
  if [[ "$approval_required" == "true" && "$checkpoint" == "null" ]]; then
    log_info "Phase requires approval (no custom checkpoint defined)"
    return 0
  fi

  # Custom checkpoint
  local condition=$(echo "$checkpoint" | jq -r '.condition // "true"')

  # Evaluate condition (for now, always true)
  # In real implementation, would evaluate JS expression

  local prompt=$(echo "$checkpoint" | jq -r '.prompt')
  local show_files=$(echo "$checkpoint" | jq -c '.show_files // []')
  local options=$(echo "$checkpoint" | jq -c '.options // []')

  log_info "CHECKPOINT: $prompt"

  # Display files to user
  local file_count=$(echo "$show_files" | jq 'length')
  for ((i=0; i<file_count; i++)); do
    local file=$(echo "$show_files" | jq -r ".[$i]")
    log_info "Review file: $file"
  done

  # Display options
  local option_count=$(echo "$options" | jq 'length')
  for ((i=0; i<option_count; i++)); do
    local option=$(echo "$options" | jq -c ".[$i]")
    local label=$(echo "$option" | jq -r '.label')
    local value=$(echo "$option" | jq -r '.value')
    log_info "Option $((i+1)): $label (value: $value)"
  done

  # NOTE: In real implementation, would use AskUserQuestion tool
  # For now, simulate user choosing first option
  local selected_value=$(echo "$options" | jq -r '.[0].value')
  log_info "User selected: $selected_value"

  # Record decision
  local phase_id=$(echo "$phase" | jq -r '.id')
  record_checkpoint "$phase_id" "$selected_value"

  # Execute action based on selection
  local selected_option=$(echo "$options" | jq -c ".[] | select(.value == \"$selected_value\")")
  local action=$(echo "$selected_option" | jq -r '.on_select.action // "continue"')

  case "$action" in
    continue)
      log_info "Continuing to next phase"
      return 0
      ;;
    repeat_phase)
      local target=$(echo "$selected_option" | jq -r '.on_select.target')
      log_info "Repeating phase: $target"
      return 2  # Signal to repeat
      ;;
    skip_phases)
      local targets=$(echo "$selected_option" | jq -c '.on_select.targets')
      log_info "Skipping phases: $targets"
      context_update "skip_phases" "$targets"
      return 0
      ;;
    abort)
      log_info "Workflow aborted by user"
      return 1
      ;;
  esac
}

# Check if phase should be skipped
should_skip_phase() {
  local phase_id="$1"

  local skip_phases=$(context_read "skip_phases")

  if [[ "$skip_phases" == "null" ]]; then
    return 1  # Don't skip
  fi

  local should_skip=$(echo "$skip_phases" | jq --arg id "$phase_id" 'any(. == $id)')

  if [[ "$should_skip" == "true" ]]; then
    log_info "Skipping phase: $phase_id"
    return 0  # Skip
  fi

  return 1  # Don't skip
}
```

**Validation:**
- Simple approval checkpoints
- Custom checkpoint logic
- User option selection
- Action execution (continue/repeat/skip/abort)

---

### Task 3.2: Gap Check Manager
**File:** `engine/gap-check-manager.sh`
**Estimated:** 4 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/script-interpreter.sh"
source "$(dirname "$0")/subagent-pool.sh"

# Execute gap check for phase
execute_gap_check() {
  local phase="$1"
  local context_json="$2"

  local gap_check=$(echo "$phase" | jq -c '.gap_check // null')

  if [[ "$gap_check" == "null" ]]; then
    return 0  # No gap check configured
  fi

  local enabled=$(echo "$gap_check" | jq -r '.enabled // false')

  if [[ "$enabled" != "true" ]]; then
    return 0  # Gap check disabled
  fi

  log_info "Executing gap check..."

  # Check for script-based gap check
  local script=$(echo "$gap_check" | jq -r '.script // null')

  if [[ "$script" != "null" ]]; then
    execute_gap_check_script "$script" "$gap_check" "$context_json"
    return $?
  fi

  # Fallback: criteria-based gap check
  execute_gap_check_criteria "$gap_check" "$context_json"
}

# Script-based gap check
execute_gap_check_script() {
  local script="$1"
  local gap_check="$2"
  local context_json="$3"

  log_info "Running gap check script"

  local result=$(execute_script "$script" "$context_json")
  local status=$(echo "$result" | jq -r '.status // "complete"')

  case "$status" in
    complete)
      log_info "Gap check passed"
      return 0
      ;;
    incomplete)
      log_info "Gap check identified gaps"
      handle_gap_check_failure "$result" "$gap_check" "$context_json"
      return $?
      ;;
    *)
      log_error "Unknown gap check status: $status"
      return 1
      ;;
  esac
}

# Criteria-based gap check
execute_gap_check_criteria() {
  local gap_check="$1"
  local context_json="$2"

  local criteria=$(echo "$gap_check" | jq -c '.criteria // []')
  local count=$(echo "$criteria" | jq 'length')

  log_info "Checking $count criteria..."

  # For now, assume all criteria pass (mock)
  # In real implementation, would evaluate each criterion

  log_info "Gap check passed (all criteria met)"
  return 0
}

# Handle gap check failure
handle_gap_check_failure() {
  local result="$1"
  local gap_check="$2"
  local context_json="$3"

  local gaps=$(echo "$result" | jq -c '.gaps // []')
  local action=$(echo "$result" | jq -r '.action // "retry"')

  log_info "Gaps identified: $gaps"

  case "$action" in
    retry)
      log_info "Retrying phase with feedback"
      return 2  # Signal retry
      ;;
    spawn_additional)
      local additional=$(echo "$result" | jq -c '.additionalAgents // []')
      log_info "Spawning additional agents: $additional"
      execute_parallel_subagents "$additional" "$context_json"
      return 0
      ;;
    escalate)
      log_info "Escalating to human review"
      # Would use AskUserQuestion tool here
      return 0
      ;;
    abort)
      log_error "Gap check failed, aborting"
      return 1
      ;;
  esac
}
```

**Validation:**
- Script-based gap checks
- Criteria-based gap checks
- Failure handling (retry/spawn/escalate/abort)

---

## Phase 4: Workflow Conversion & Legacy Support (Day 6)

### Task 4.1: JSON to YAML Converter
**File:** `tools/converter.sh`
**Estimated:** 4 hours

**Deliverable:**
```bash
#!/bin/bash

# Convert legacy JSON workflows to YAML format
convert_workflow() {
  local json_file="$1"
  local output_file="${2:-${json_file%.json}.workflow.yaml}"

  echo "Converting: $json_file → $output_file"

  # Parse JSON
  local workflow=$(cat "$json_file")

  local name=$(echo "$workflow" | jq -r '.name')
  local description=$(echo "$workflow" | jq -r '.description')
  local phases=$(echo "$workflow" | jq -c '.phases')
  local template=$(echo "$workflow" | jq -r '.template')

  # Generate YAML
  cat > "$output_file" <<EOF
name: $name
description: $description

phases:
EOF

  # Convert each phase
  local phase_array=$(echo "$workflow" | jq -c '.phases[]')

  echo "$phase_array" | while IFS= read -r phase_id; do
    # Get phase definition from phase-registry.json
    local phase_def=$(jq -r ".phases.\"$phase_id\"" ../phases/phase-registry.json)

    cat >> "$output_file" <<EOF
  - id: $phase_id
    name: $(echo "$phase_def" | jq -r '.name')
    execution_mode: strict
    behavior: parallel
    gap_check:
      enabled: $(echo "$phase_def" | jq -r '.gap_check')
    deliverables:
      required: $(echo "$phase_def" | jq -c '.outputs')
EOF
  done

  # Finalization
  cat >> "$output_file" <<EOF

finalization:
  template: $template
  output: .claude/plans/\${context.feature_name}/plan.md

metadata:
  typical_duration_minutes: $(echo "$workflow" | jq -r '.typical_duration_minutes')
  token_estimate: $(echo "$workflow" | jq -r '.token_estimate')
EOF

  echo "Conversion complete: $output_file"
}

# Convert all workflows in directory
convert_all() {
  local dir="${1:-.}"

  for json_file in "$dir"/*.json; do
    if [[ -f "$json_file" ]]; then
      convert_workflow "$json_file"
    fi
  done
}

# Main
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <json_file> [output_file]"
  echo "   or: $0 --all [directory]"
  exit 1
fi

if [[ "$1" == "--all" ]]; then
  convert_all "${2:-.}"
else
  convert_workflow "$1" "$2"
fi
```

**Validation:**
- Convert new-feature.json
- Convert debugging.json
- Validate YAML output
- Compare functionality

---

### Task 4.2: Legacy Compatibility Layer
**File:** `engine/legacy-adapter.sh`
**Estimated:** 3 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"

# Detect workflow format (JSON or YAML)
detect_workflow_format() {
  local workflow_path="$1"

  if [[ "$workflow_path" =~ \.json$ ]]; then
    echo "json"
  elif [[ "$workflow_path" =~ \.yaml$ || "$workflow_path" =~ \.yml$ ]]; then
    echo "yaml"
  else
    log_error "Unknown workflow format: $workflow_path"
    return 1
  fi
}

# Load workflow (supports both JSON and YAML)
load_workflow_auto() {
  local workflow_path="$1"

  local format=$(detect_workflow_format "$workflow_path")

  case "$format" in
    json)
      load_workflow_json "$workflow_path"
      ;;
    yaml)
      load_workflow_yaml "$workflow_path"
      ;;
  esac
}

# Load legacy JSON workflow
load_workflow_json() {
  local json_path="$1"

  log_info "Loading legacy JSON workflow: $json_path"

  # Convert on-the-fly to YAML
  local temp_yaml=$(mktemp --suffix=.workflow.yaml)

  bash "$(dirname "$0")/../tools/converter.sh" "$json_path" "$temp_yaml"

  # Load converted YAML
  load_workflow_yaml "$temp_yaml"

  rm "$temp_yaml"
}

# Load YAML workflow
load_workflow_yaml() {
  local yaml_path="$1"

  source "$(dirname "$0")/workflow-loader.sh"
  load_workflow "$yaml_path"
}
```

**Validation:**
- Detect JSON workflows
- Auto-convert to YAML
- Load and execute
- Verify identical behavior

---

## Phase 5: Skills Integration (Day 7)

### Task 5.1: Skills Invoker
**File:** `engine/skills-invoker.sh`
**Estimated:** 3 hours

**Deliverable:**
```bash
#!/bin/bash
source "$(dirname "$0")/utils.sh"

# Invoke Claude Code skill from phase
invoke_skill() {
  local skill_config="$1"
  local context_json="$2"

  local name=$(echo "$skill_config" | jq -r '.name')
  local condition=$(echo "$skill_config" | jq -r '.condition // "true"')
  local args=$(echo "$skill_config" | jq -c '.args // {}')

  # Evaluate condition
  # For now, always invoke (mock)
  # In real implementation, would evaluate JS expression

  log_info "Invoking skill: $name"

  # Build skill invocation command
  local skill_args=""

  # Convert args object to command-line arguments
  local arg_keys=$(echo "$args" | jq -r 'keys[]')

  for key in $arg_keys; do
    local value=$(echo "$args" | jq -r ".$key")
    skill_args="$skill_args --$key \"$value\""
  done

  log_info "INVOKE SKILL: $name $skill_args"

  # NOTE: In real Claude Code environment, would use Skill tool
  # For now, log the invocation

  log_info "Skill completed: $name"
}

# Invoke all skills for phase
invoke_phase_skills() {
  local phase="$1"
  local context_json="$2"

  local skills=$(echo "$phase" | jq -c '.skills // []')
  local count=$(echo "$skills" | jq 'length')

  if [[ $count -eq 0 ]]; then
    return 0
  fi

  log_info "Invoking $count skills"

  for ((i=0; i<count; i++)); do
    local skill=$(echo "$skills" | jq -c ".[$i]")
    invoke_skill "$skill" "$context_json"
  done
}
```

**Validation:**
- Parse skill configuration
- Evaluate conditions
- Build invocation commands
- Track skill usage

---

### Task 5.2: Update Phase Executor for Skills
**File:** `engine/phase-executor.sh` (update)
**Estimated:** 2 hours

**Changes:**
```bash
# Add to execute_phase() function after phase execution

# Invoke skills if defined
invoke_phase_skills "$phase" "$context_json"
```

**Validation:**
- Skills invoked after phase execution
- Conditional skill invocation
- Skills tracked in metadata

---

## Phase 6: YAML Workflow Definitions (Days 8-9)

### Task 6.1: Convert Existing Workflows
**Estimated:** 6 hours

**Workflows to convert:**
1. new-feature.workflow.yaml
2. debugging.workflow.yaml
3. refactoring.workflow.yaml
4. improving.workflow.yaml
5. quick.workflow.yaml

**Process:**
- Run converter tool
- Manually enhance with inline scripts
- Add checkpoint definitions
- Add skills integration
- Validate structure

---

### Task 6.2: Create Subagent Prompt Templates
**Estimated:** 8 hours

**For each subagent, create:**
- `default.md.tmpl` - Generic prompt
- `new-feature.md.tmpl` - New feature workflow prompt
- `debugging.md.tmpl` - Debugging workflow prompt
- Additional workflow-specific prompts

**Priority subagents:**
1. codebase-scanner
2. web-researcher
3. doc-searcher
4. code-scout
5. pattern-analyzer
6. dependency-mapper
7. user-story-writer
8. architecture-designer
9. bug-reproducer
10. fix-designer

**Template structure:**
```markdown
---
workflow: {{workflow_name}}
phase: {{phase_id}}
---

# Role: {{subagent_type}} ({{workflow_name}} Mode)

## Workflow Context
{{workflow_description}}

## Phase Context
{{phase_description}}

## Previous Phase Results
{{#previous_phase_summary}}
{{previous_phase_summary}}
{{/previous_phase_summary}}

## Your Task
{{task_description}}

## Deliverables
Format: {{output_format}}
Output to: {{output_path}}

## Constraints
{{constraints}}
```

---

### Task 6.3: Create Example Custom Workflows
**Estimated:** 6 hours

**Examples:**

1. **custom-research.workflow.yaml** - Research & documentation
2. **code-review.workflow.yaml** - Multi-stage code review
3. **performance-optimization.workflow.yaml** - Baseline → Optimize → Verify

---

## Phase 7: Main Orchestrator (Day 10)

### Task 7.1: Main Workflow Runner
**File:** `engine/workflow-runner.sh`
**Estimated:** 4 hours

**Deliverable:**
```bash
#!/bin/bash
set -euo pipefail

# Source all engine components
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/workflow-loader.sh"
source "$SCRIPT_DIR/phase-executor.sh"
source "$SCRIPT_DIR/checkpoint-handler.sh"
source "$SCRIPT_DIR/gap-check-manager.sh"
source "$SCRIPT_DIR/context-manager.sh"
source "$SCRIPT_DIR/skills-invoker.sh"
source "$SCRIPT_DIR/legacy-adapter.sh"

# Run workflow
run_workflow() {
  local workflow_path="$1"
  local feature_name="$2"
  local flags="${3:-[]}"

  log_info "========================================="
  log_info "Starting Workflow Engine v2"
  log_info "========================================="

  # Load workflow
  local workflow_json=$(load_workflow_auto "$workflow_path")

  # Validate workflow
  validate_workflow "$workflow_json"

  # Initialize context
  init_context "$feature_name" "$(echo "$workflow_json" | jq -r '.name')" "$flags"
  local context_json=$(cat "$CONTEXT_FILE")

  # Announce workflow plan
  announce_workflow_plan "$workflow_json"

  # Execute phases
  local phase_count=$(get_phase_count "$workflow_json")

  for ((phase_idx=0; phase_idx<phase_count; phase_idx++)); do
    local phase=$(echo "$workflow_json" | jq -c ".phases[$phase_idx]")
    local phase_id=$(echo "$phase" | jq -r '.id')

    # Check if phase should be skipped
    if should_skip_phase "$phase_id"; then
      continue
    fi

    log_info "========================================="
    log_info "Phase $((phase_idx+1))/$phase_count: $phase_id"
    log_info "========================================="

    # Execute phase
    execute_phase "$workflow_json" "$phase" "$context_json"

    # Gap check
    execute_gap_check "$phase" "$context_json"
    local gap_result=$?

    if [[ $gap_result -eq 2 ]]; then
      # Retry phase
      log_info "Retrying phase due to gaps"
      ((phase_idx--))
      continue
    elif [[ $gap_result -eq 1 ]]; then
      # Abort
      handle_error "Gap check failed, aborting workflow"
    fi

    # Checkpoint
    handle_checkpoint "$phase" "$context_json"
    local checkpoint_result=$?

    if [[ $checkpoint_result -eq 2 ]]; then
      # Repeat phase
      ((phase_idx--))
      continue
    elif [[ $checkpoint_result -eq 1 ]]; then
      # Abort
      log_info "Workflow aborted by user"
      exit 0
    fi

    # Reload context
    context_json=$(cat "$CONTEXT_FILE")
  done

  # Finalization
  log_info "========================================="
  log_info "Finalization"
  log_info "========================================="

  finalize_workflow "$workflow_json" "$context_json"

  log_info "========================================="
  log_info "Workflow Complete"
  log_info "========================================="
}

# Announce workflow plan
announce_workflow_plan() {
  local workflow_json="$1"

  local name=$(echo "$workflow_json" | jq -r '.name')
  local description=$(echo "$workflow_json" | jq -r '.description')
  local phase_count=$(get_phase_count "$workflow_json")

  cat <<EOF

## Implementation Plan: $name

**Description:** $description
**Phases:** $phase_count

**Phases to execute:**
EOF

  for ((i=0; i<phase_count; i++)); do
    local phase=$(echo "$workflow_json" | jq -c ".phases[$i]")
    local phase_id=$(echo "$phase" | jq -r '.id')
    local phase_name=$(echo "$phase" | jq -r '.name')
    echo "$((i+1)). $phase_name ($phase_id)"
  done

  echo ""
  echo "Proceeding with workflow..."
  echo ""
}

# Finalize workflow
finalize_workflow() {
  local workflow_json="$1"
  local context_json="$2"

  local finalization=$(echo "$workflow_json" | jq -c '.finalization')
  local template=$(echo "$finalization" | jq -r '.template')
  local output=$(echo "$finalization" | jq -r '.output')

  # Substitute variables in output path
  output=$(echo "$output" | envsubst)

  log_info "Generating final plan: $output"

  # Render template
  source "$SCRIPT_DIR/template-renderer.sh"
  render_template "../templates/$template" "$context_json" "$output"

  # Create metadata
  create_metadata "$context_json" "$(dirname "$output")/metadata.json"

  # Create archives directory
  ensure_dir "$(dirname "$output")/archives"

  log_info "Final plan saved: $output"
}

# Create metadata file
create_metadata() {
  local context_json="$1"
  local output_path="$2"

  local metadata=$(jq -n \
    --argjson ctx "$context_json" \
    '{
      feature: $ctx.feature_name,
      workflow: $ctx.workflow_name,
      created: $ctx.start_time,
      completed: (now | strftime("%Y-%m-%dT%H:%M:%S")),
      phases_executed: $ctx.completed_phases,
      subagents_spawned: $ctx.subagents_spawned,
      checkpoints: $ctx.checkpoints,
      deliverables: $ctx.deliverables,
      status: $ctx.status
    }')

  echo "$metadata" > "$output_path"
  log_info "Metadata saved: $output_path"
}

# Main entry point
main() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <workflow_path> <feature_name> [flags_json]"
    exit 1
  fi

  run_workflow "$@"
}

main "$@"
```

**Validation:**
- Complete workflow execution
- Phase iteration
- Checkpoint handling
- Gap check handling
- Finalization
- Metadata generation

---

### Task 7.2: Update SKILL.md Entry Point
**File:** `SKILL.md` (update)
**Estimated:** 2 hours

**Changes:**
```markdown
## Workflow Engine v2

This skill now uses a hybrid declarative-imperative workflow engine.

### Usage

Invoke workflow execution:

```bash
bash ~/.claude/skills/use-workflows/engine/workflow-runner.sh \
  ~/.claude/skills/use-workflows/workflows/new-feature.workflow.yaml \
  "my-feature" \
  '["--frontend"]'
```

Or via the main skill interface (unchanged for backward compatibility).

### Features

- **Execution Modes:** strict, loose, adaptive
- **Phase Behaviors:** parallel, sequential, main-only
- **Human-in-Loop:** Checkpoints with custom approval flows
- **Gap Checks:** Automated quality validation
- **Skills Integration:** Invoke Claude Code skills from phases
- **Dynamic Subagents:** Main agent decides which subagents to spawn
- **Custom Deliverables:** Per-workflow output configurations
```

---

## Phase 8: Documentation & Testing (Days 11-12)

### Task 8.1: User Documentation
**Files:**
- `README.md` - User guide
- `resources/yaml-syntax.md` - YAML syntax reference
- `resources/script-api.md` - Script API reference
- `resources/template-syntax.md` - Template guide
- `resources/migration-guide.md` - JSON → YAML migration

**Estimated:** 6 hours

---

### Task 8.2: Testing & Validation
**Estimated:** 8 hours

**Test suite:**
1. Unit tests for engine components
2. Integration tests for workflows
3. Backward compatibility tests (JSON workflows)
4. Example workflow execution
5. Error handling tests

**Test script:** `tools/test-workflow.sh`

---

## Dependencies & Risks

### External Dependencies
- **yq** - YAML parsing (can fallback to Python)
- **jq** - JSON manipulation (required)
- **mustache** - Template rendering (can fallback to custom)
- **Node.js** - JavaScript script execution (required for inline scripts)
- **envsubst** - Variable substitution (standard Unix utility)

### Risks & Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| YAML parsing performance | Low | Medium | Cache parsed workflows |
| Script execution overhead | Medium | Medium | Limit script complexity, use main agent logic |
| Backward compatibility breaks | Low | High | Extensive testing, keep JSON adapter |
| Complex debugging | Medium | Medium | Verbose logging, step-by-step execution mode |
| Token usage explosion | Medium | High | Progressive disclosure, batch operations |

---

## Acceptance Criteria

### Must Have (Release Blockers)
- [ ] All 5 existing JSON workflows execute unchanged
- [ ] All 5 workflows converted to YAML and functional
- [ ] Strict/loose/adaptive execution modes working
- [ ] Parallel/sequential/main-only behaviors working
- [ ] Human-in-loop checkpoints functional
- [ ] Gap checks with custom scripts working
- [ ] Workflow-specific subagent prompts rendering
- [ ] Skills integration working
- [ ] Context management persisting across phases
- [ ] Template rendering for final plans
- [ ] Metadata generation complete

### Should Have (Post-Launch)
- [ ] Conditional phase execution (skip_if)
- [ ] Phase iteration limits (max_iterations)
- [ ] Parallel phase groups (depends_on)
- [ ] Workflow composition (extends)
- [ ] Resume from checkpoint capability

### Nice to Have (Future)
- [ ] Visual workflow diagram generation
- [ ] Validation CLI tool with schema checks
- [ ] Unit test coverage >80%
- [ ] Performance benchmarks

---

## Rollout Plan

### Phase 1: Internal Testing (Day 11)
- Execute all existing workflows in new engine
- Compare outputs with legacy system
- Fix critical bugs

### Phase 2: Soft Launch (Day 12)
- Enable new engine for new custom workflows
- Keep legacy JSON workflows running on old system
- Monitor for issues

### Phase 3: Full Migration (Post Day 12)
- Convert all users to new engine
- Deprecate legacy JSON system (keep for reference)
- Archive old codebase

---

## Success Metrics

### Functional Metrics
- **Workflow execution success rate:** >95%
- **Backward compatibility:** 100% (all legacy workflows work)
- **Custom workflow creation time:** <30 minutes (from idea to working workflow)

### Performance Metrics
- **Workflow loading time:** <1 second
- **YAML parsing time:** <500ms
- **Phase execution overhead:** <5% vs. direct execution

### User Experience Metrics
- **Error message clarity:** Actionable errors with context
- **Documentation completeness:** All features documented with examples
- **Adoption rate:** 3+ custom workflows created in first week

---

## Appendices

### Appendix A: Example Custom Workflow

See `examples/custom-research.workflow.yaml` (created in Phase 6)

### Appendix B: YAML Schema

See `resources/yaml-syntax.md` (created in Phase 8)

### Appendix C: Migration Guide

See `resources/migration-guide.md` (created in Phase 8)

### Appendix D: Troubleshooting Guide

Common issues and solutions (created in Phase 8)

---

## Conclusion

This implementation plan provides a complete roadmap for building the Hybrid Workflow Engine v2 with all requested features:

✅ Strict/loose/adaptive execution modes
✅ Parallel/sequential/main-only behaviors
✅ Workflow-specific subagent prompts
✅ Human-in-loop checkpoints
✅ Dynamic deliverables
✅ Skills integration
✅ Inline scripting for custom logic
✅ Backward compatibility
✅ Claude Code skills environment constraints

**Total Estimated Effort:** 10-12 days
**Risk Level:** Medium
**Complexity:** High

Ready for implementation approval and resource allocation.

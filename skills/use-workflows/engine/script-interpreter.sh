#!/usr/bin/env bash

# JavaScript script interpreter with helper injection

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# ============================================================================
# Script Execution
# ============================================================================

execute_script() {
  local script=$1
  local context_json=$2
  local timeout=${3:-30000}
  local phase_json=${4:-"null"}

  log_debug "Executing script (timeout: ${timeout}ms)"

  local helpers=$(inject_helpers)
  local wrapped_script=$(wrap_script "$script" "$context_json" "$phase_json" "$helpers")

  # Portable mktemp for macOS/BSD
  local temp_script="${TMPDIR:-/tmp}/workflow-script.$$.$RANDOM.js"
  echo "$wrapped_script" > "$temp_script"

  local result
  # Check if timeout command exists (GNU coreutils)
  if command -v timeout &> /dev/null; then
    # Convert milliseconds to seconds for timeout
    local timeout_seconds=$((timeout / 1000))
    if [ $timeout_seconds -lt 1 ]; then
      timeout_seconds=1
    fi

    # Capture stdout (JSON) and stderr (deliverable instructions) separately
    local stderr_file=$(mktemp)
    if result=$(timeout "${timeout_seconds}s" node "$temp_script" 2>"$stderr_file"); then
      # Process deliverable instructions from stderr
      process_deliverable_instructions "$stderr_file"
      rm "$temp_script" "$stderr_file"
      # Return only the last line (the JSON result from console.log)
      echo "$result" | tail -1
    else
      local exit_code=$?
      rm "$temp_script" "$stderr_file"
      if [ $exit_code -eq 124 ]; then
        log_error "Script execution timed out after ${timeout}ms"
      else
        log_error "Script execution failed"
      fi
      return 1
    fi
  else
    # Fallback: No timeout on macOS (or use Node-based timeout)
    log_debug "timeout command not available, running without timeout"
    local stderr_file=$(mktemp)
    if result=$(node "$temp_script" 2>"$stderr_file"); then
      # Process deliverable instructions from stderr
      process_deliverable_instructions "$stderr_file"
      rm "$temp_script" "$stderr_file"
      # Return only the last line (the JSON result from console.log)
      echo "$result" | tail -1
    else
      rm "$temp_script" "$stderr_file"
      log_error "Script execution failed"
      return 1
    fi
  fi
}

# Process deliverable instructions emitted by script helpers
process_deliverable_instructions() {
  local stderr_file=$1

  # Parse deliverable instructions: __DELIVERABLE__:<phase_id>:<file_path>
  while IFS=: read -r marker phase_id file_path; do
    if [ "$marker" = "__DELIVERABLE__" ]; then
      log_debug "Script wrote deliverable: $file_path"
      # Use context-manager to persist deliverable
      add_deliverable "$phase_id" "$file_path" "main-agent-script"
    fi
  done < <(grep "^__DELIVERABLE__:" "$stderr_file" 2>/dev/null || true)
}

wrap_script() {
  local user_script=$1
  local context_json=$2
  local phase_json=$3
  local helpers=$4

  cat <<EOF
(async function() {
  const context = ${context_json};
  const phase = ${phase_json};
  const output_dir = '.temp/' + context.feature.name;

  // Track deliverables written by helper functions
  const __deliverables_written = [];

  ${helpers}

  // User script
  const result = await (async function() {
    ${user_script}
  })();

  // Emit deliverables as instructions for shell to persist
  // Format: DELIVERABLE:<phase_id>:<file_path>
  __deliverables_written.forEach(path => {
    console.error(\`__DELIVERABLE__:\${phase.id}:\${path}\`);
  });

  console.log(JSON.stringify(result));
})().catch(err => {
  console.error(JSON.stringify({error: err.message, stack: err.stack}));
  process.exit(1);
});
EOF
}

# ============================================================================
# Helper Injection (MVP Stubs)
# ============================================================================

inject_helpers() {
  cat <<'HELPERS'
// ============================================================================
// MVP Helper Stubs
// ============================================================================

const thinkHard = async (prompt) => {
  console.error(`[MVP] thinkHard called: ${prompt.substring(0, 50)}...`);
  return `Mock response for prompt: ${prompt.substring(0, 30)}...`;
};

const readFile = (path) => {
  const fs = require('fs');
  const resolved = path.startsWith('/') ? path : `${output_dir}/${path}`;
  return fs.readFileSync(resolved, 'utf-8');
};

const readFiles = (paths) => {
  const result = {};
  paths.forEach(path => {
    result[path] = readFile(path);
  });
  return result;
};

const writeFile = (path, content) => {
  const fs = require('fs');
  const resolved = path.startsWith('/') ? path : `${output_dir}/${path}`;

  // Ensure directory exists
  const dir = require('path').dirname(resolved);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  fs.writeFileSync(resolved, content, 'utf-8');
  console.error(`[MVP] Wrote file: ${resolved}`);

  // Track for context persistence
  __deliverables_written.push(resolved);
};

const analyzeFiles = (directory) => {
  console.error(`[MVP] analyzeFiles called: ${directory}`);
  return {
    coverage: 85,
    files: ['file1.md', 'file2.md', 'file3.md']
  };
};

const identifyGaps = (deliverables) => {
  console.error(`[MVP] identifyGaps called with ${deliverables.length} deliverables`);

  const gaps = [];
  deliverables.forEach(d => {
    try {
      const content = readFile(d.path);
      if (content.includes('TODO') || content.includes('FIXME')) {
        gaps.push(`TODO/FIXME found in ${d.path}`);
      }
      if (content.length < 100) {
        gaps.push(`${d.path} is too short (${content.length} chars)`);
      }
    } catch (err) {
      gaps.push(`Cannot read ${d.path}`);
    }
  });

  return gaps;
};

const files_exist = (paths) => {
  const fs = require('fs');
  return paths.every(path => {
    const resolved = path.startsWith('/') ? path : `${output_dir}/${path}`;
    return fs.existsSync(resolved);
  });
};

const contains_todos = (deliverables) => {
  return deliverables.some(d => {
    try {
      const content = readFile(d.path);
      return /TODO|FIXME|XXX/.test(content);
    } catch (err) {
      return false;
    }
  });
};

const has_syntax_errors = (deliverables) => {
  console.error(`[MVP] has_syntax_errors called`);
  return false; // Mock: no errors
};

const all_tests_pass = () => {
  console.error(`[MVP] all_tests_pass called`);
  return true; // Mock: tests pass
};

const findAmbiguousRequirements = (deliverables) => {
  console.error(`[MVP] findAmbiguousRequirements called`);
  return []; // Mock: no ambiguities
};

const analyzeCoverage = (deliverables) => {
  console.error(`[MVP] analyzeCoverage called`);
  return 85; // Mock: 85% coverage
};

HELPERS
}

# ============================================================================
# Output Parsing
# ============================================================================

parse_script_output() {
  local output=$1

  # Check if valid JSON
  if echo "$output" | jq empty 2>/dev/null; then
    echo "$output"
  else
    log_warning "Script output is not valid JSON"
    echo '{"status": "error", "message": "Invalid script output"}'
  fi
}

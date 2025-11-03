#!/usr/bin/env bash
# Workflow execution wrapper for Claude Code integration
# This script is meant to be called BY Claude, not run standalone

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source engine
source "$SCRIPT_DIR/engine/workflow-runner.sh"

# Parse arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 <workflow.yaml> <feature-name> [flags...]" >&2
  exit 1
fi

workflow_path=$1
feature_name=$2
shift 2

# Run workflow and capture task invocation signals
output=$(run_workflow "$workflow_path" "$feature_name" "$@" 2>&1)

# Check for task invocation signals
if echo "$output" | grep -q "__TASK_INVOCATION__"; then
  # Extract task invocations and output them for Claude to execute
  echo "$output" | awk '/__TASK_INVOCATION__/,/__END_TASK_INVOCATION__/' | \
    grep -v "^__" | \
    jq -s '.'
else
  # No task invocations, just output the log
  echo "$output"
fi

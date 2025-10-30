#!/usr/bin/env bash
#
# Process Orchestrator Subagent Output
#
# This hook runs when the orchestrator subagent completes (SubagentStop event).
# It reads the transcript file to extract the orchestrator's JSON output,
# then creates todos for the main agent.
#
# Expected input: Session metadata JSON via stdin (includes transcript_path)
# Output: System message with todos for main agent

set -euo pipefail

# Configuration
LOG_FILE="$HOME/.claude/logs/orchestrator.log"
HOOK_INPUT_FILE="/tmp/hook-input-$$.json"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Function: Log with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

log "========================================"
log "Orchestrator SubagentStop hook triggered"

# Read hook input from stdin (session metadata)
if [ -t 0 ]; then
  log "ERROR: No input on stdin"
  exit 0
fi

cat > "$HOOK_INPUT_FILE"
log "Saved hook input to $HOOK_INPUT_FILE"

# Extract transcript path
TRANSCRIPT_PATH=$(jq -r '.transcript_path // ""' "$HOOK_INPUT_FILE")

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  log "ERROR: No transcript_path found or file doesn't exist: $TRANSCRIPT_PATH"
  exit 0
fi

log "Reading transcript from: $TRANSCRIPT_PATH"

# Extract the last assistant message from transcript (orchestrator's output)
# The transcript is in JSONL format (one JSON object per line)
# Structure: {type: "assistant", isSidechain: true, message: {content: [{type: "text", text: "..."}]}}
# Orchestrator messages are marked with isSidechain: true and contain JSON starting with "{"
# Note: Extract as JSON string first (not -r), then convert to raw text to preserve multiline JSON
ORCHESTRATOR_OUTPUT=$(tail -100 "$TRANSCRIPT_PATH" | \
  jq 'select(.type == "assistant" and .isSidechain == true) | .message.content[] | select(.type == "text") | .text | select(startswith("{"))' | \
  tail -1 | \
  jq -r '.')

if [ -z "$ORCHESTRATOR_OUTPUT" ]; then
  log "ERROR: No orchestrator output found in transcript"
  log "Transcript path: $TRANSCRIPT_PATH"
  exit 0
fi

log "Extracted orchestrator output (${#ORCHESTRATOR_OUTPUT} chars)"

# Save orchestrator output for debugging
ORCHESTRATOR_JSON_FILE="/tmp/orchestrator-output-$$.json"
echo "$ORCHESTRATOR_OUTPUT" > "$ORCHESTRATOR_JSON_FILE"

# Validate it's JSON
if ! echo "$ORCHESTRATOR_OUTPUT" | jq empty 2>/dev/null; then
  log "ERROR: Orchestrator output is not valid JSON"
  log "Output preview: ${ORCHESTRATOR_OUTPUT:0:200}..."
  exit 0
fi

log "JSON validated successfully"

# Check if orchestrator returned an error
if echo "$ORCHESTRATOR_OUTPUT" | jq -e '.error' >/dev/null 2>&1; then
  ERROR_MSG=$(echo "$ORCHESTRATOR_OUTPUT" | jq -r '.error')
  log "Orchestrator error: $ERROR_MSG"

  # Don't create todos, just pass error to main agent
  echo "{\"systemMessage\": \"Orchestrator error: $ERROR_MSG\"}"
  exit 0
fi

# Extract todos
EXPLORATION_TODOS=$(echo "$ORCHESTRATOR_OUTPUT" | jq -c '.todos.exploration // []')
IMPLEMENTATION_TODOS=$(echo "$ORCHESTRATOR_OUTPUT" | jq -c '.todos.implementation // []')

EXPLORATION_COUNT=$(echo "$EXPLORATION_TODOS" | jq 'length')
IMPLEMENTATION_COUNT=$(echo "$IMPLEMENTATION_TODOS" | jq 'length')

log "Exploration todos: $EXPLORATION_COUNT"
log "Implementation todos: $IMPLEMENTATION_COUNT"

# Build combined todo list for TodoWrite tool
# Format: [{content, activeForm, status}]
TODO_LIST=$(jq -n \
  --argjson exploration "$EXPLORATION_TODOS" \
  --argjson implementation "$IMPLEMENTATION_TODOS" \
  '
  ($exploration | map(
    .status = "pending" |
    if .content then . else empty end
  )) +
  ($implementation | map(
    .status = "pending" |
    if .content then . else empty end
  ))
  '
)

# Set first todo to in_progress
TODO_LIST=$(echo "$TODO_LIST" | jq '
  if length > 0 then
    .[0].status = "in_progress"
  else
    .
  end
')

TOTAL_TODOS=$(echo "$TODO_LIST" | jq 'length')
log "Combined todo list created with $TOTAL_TODOS items"

# Save todo list to file
TODO_FILE="/tmp/orchestrator-todos-$$.json"
echo "$TODO_LIST" > "$TODO_FILE"
log "Saved todos to $TODO_FILE"

# Extract orchestrator analysis for summary
CLARIFIED_REQUEST=$(echo "$ORCHESTRATOR_OUTPUT" | jq -r '.clarified_request // "N/A"')
SELECTED_SKILLS=$(echo "$ORCHESTRATOR_OUTPUT" | jq -r '.selected_skills[] | "  - \(.name): \(.reason)"' 2>/dev/null || echo "  - None")
SKILL_COUNT=$(echo "$ORCHESTRATOR_OUTPUT" | jq '.selected_skills | length // 0')

# Generate summary message with TODO instruction
SUMMARY="🎯 Orchestrator Analysis Complete

**Clarified Request:**
$CLARIFIED_REQUEST

**Selected Skills ($SKILL_COUNT):**
$SELECTED_SKILLS

**Todos Created:**
  - Exploration: $EXPLORATION_COUNT task(s)
  - Implementation: $IMPLEMENTATION_COUNT task(s)
  - Total: $TOTAL_TODOS task(s)

**⚠️ IMPORTANT - YOU MUST CALL TodoWrite NOW:**

Use the TodoWrite tool with the following todo list JSON:

\`\`\`json
$(echo "$TODO_LIST" | jq '.')
\`\`\`

After creating todos, execute them sequentially:
1. Run all exploration todos (invoke Explore agents with glob patterns)
2. Review findings from exploration
3. Run implementation todos (invoke selected skills)

DO NOT PROCEED WITHOUT CALLING TodoWrite FIRST."

log "Summary generated"
log "========================================"

# Output instruction for main agent (though SubagentStop hooks can't send messages to conversation)
# The hook successfully processes todos but cannot automatically insert them
# The orchestrator's JSON output itself must instruct the main agent
cat << EOF
{
  "action": "create_todos",
  "todoList": $TODO_LIST,
  "summary": $(echo "$SUMMARY" | jq -Rs .)
}
EOF

log "Hook completed - todos saved to $TODO_FILE"
exit 0

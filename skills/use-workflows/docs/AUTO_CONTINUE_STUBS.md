# Auto-Continue Stubs Tracking

**Purpose:** Track locations where human-in-the-loop interactions are stubbed to auto-continue
**Status:** MVP ships with automatic continuations - real prompts require Claude Code integration

---

## Checkpoint Handler

**File:** `engine/checkpoint-handler.sh`

### 1. Simple Approval Checkpoint (Line ~25)

**Current behavior:**
```bash
log_info "Would prompt: Continue?"
log_info "Auto-continuing for MVP..."
# Auto-continues without user input
```

**Needed for production:**
```bash
# Use AskUserQuestion tool
decision=$(ask_user "Continue with next phase?" \
  --options "Continue,Abort" \
  --default "Continue")

if [ "$decision" = "Abort" ]; then
  return 1
fi
```

**Integration:** Claude Code `AskUserQuestion` tool
**PR:** TBD

---

### 2. Custom Checkpoint Options (Line ~65)

**Current behavior:**
```bash
log_info "Options: $options_json"
log_info "Auto-selecting first option for MVP..."
selected_option=$(echo "$options" | jq -r '.[0].value')
```

**Needed for production:**
```bash
# Build AskUserQuestion with dynamic options
options_str=$(echo "$options" | jq -r '.[] | "\(.label):\(.value)"' | tr '\n' ',')
decision=$(ask_user "$prompt" \
  --options "$options_str" \
  --with-feedback "$with_feedback")

selected_option=$(echo "$decision" | jq -r '.option')
feedback=$(echo "$decision" | jq -r '.feedback // ""')
```

**Integration:** Claude Code `AskUserQuestion` with custom options array
**PR:** TBD

---

### 3. Feedback Collection (Line ~70)

**Current behavior:**
```bash
if [ "$with_feedback" = "true" ]; then
  log_info "Would collect feedback here"
  feedback="Auto-generated feedback for MVP"
fi
```

**Needed for production:**
```bash
if [ "$with_feedback" = "true" ]; then
  feedback=$(ask_user_text "Provide feedback for this checkpoint:")
fi
```

**Integration:** Claude Code text input prompt
**PR:** TBD

---

## Gap Check Manager

**File:** `engine/gap-check-manager.sh`

### 4. Escalate to User (Line ~85)

**Current behavior:**
```bash
escalate)
  log_warning "Gap check requires user intervention"
  log_info "Gaps found: $gaps_json"
  log_info "Auto-continuing for MVP..."
  # Returns success, continues workflow
  ;;
```

**Needed for production:**
```bash
escalate)
  log_warning "Gap check requires user intervention"
  log_info "Gaps found: $gaps_json"

  decision=$(ask_user "Gap check failed. How to proceed?" \
    --options "Retry,Skip,Abort" \
    --default "Abort")

  case "$decision" in
    Retry)
      return 2  # Signal retry
      ;;
    Skip)
      return 0  # Continue
      ;;
    Abort)
      return 1  # Fail
      ;;
  esac
  ;;
```

**Integration:** Claude Code `AskUserQuestion` with decision options
**PR:** TBD

---

### 5. Max Iterations Reached (Line ~95)

**Current behavior:**
```bash
if [ "$iterations" -ge "$max_iterations" ]; then
  log_warning "Max iterations reached: $iterations/$max_iterations"
  log_info "Auto-escalating for MVP..."
  # Auto-continues instead of prompting
fi
```

**Needed for production:**
```bash
if [ "$iterations" -ge "$max_iterations" ]; then
  log_error "Max iterations reached: $iterations/$max_iterations"

  decision=$(ask_user "Maximum iterations reached. Proceed anyway?" \
    --options "Force Continue,Abort" \
    --default "Abort")

  if [ "$decision" = "Abort" ]; then
    return 1
  fi
fi
```

**Integration:** Claude Code `AskUserQuestion`
**PR:** TBD

---

## Summary Table

| Component | Location | Stub Type | Production Need | Priority |
|-----------|----------|-----------|-----------------|----------|
| Simple Checkpoint | checkpoint-handler.sh:25 | Auto-continue | AskUserQuestion (Continue/Abort) | High |
| Custom Checkpoint | checkpoint-handler.sh:65 | First option | AskUserQuestion (Dynamic options) | High |
| Checkpoint Feedback | checkpoint-handler.sh:70 | Mock text | Text input prompt | Medium |
| Gap Check Escalate | gap-check-manager.sh:85 | Auto-continue | AskUserQuestion (Retry/Skip/Abort) | High |
| Max Iterations | gap-check-manager.sh:95 | Auto-escalate | AskUserQuestion (Force/Abort) | Medium |

---

## Integration Requirements

### Claude Code Tools Needed

1. **AskUserQuestion** - Multi-choice prompts
   ```bash
   ask_user <prompt> --options "A,B,C" --default "A"
   ```

2. **AskUserText** - Free-text input
   ```bash
   ask_user_text <prompt> [--default "text"]
   ```

3. **AskUserConfirm** - Yes/No confirmation
   ```bash
   ask_user_confirm <prompt> [--default yes|no]
   ```

### Implementation Strategy

**Phase 1 (Current MVP):**
- ✅ Auto-continue for all prompts
- ✅ Log intended prompt text
- ✅ Document stub locations
- ✅ Ship MVP with known limitation

**Phase 2 (Claude Code Integration):**
- Implement wrapper functions for Claude Code tools
- Replace stubs with real prompts
- Test interactive flows
- Add timeout handling for prompts

**Phase 3 (Advanced Features):**
- Conditional prompts based on context
- Prompt history/replay
- Batch approval mode
- CI/CD skip-prompts flag

---

## Testing Strategy

### Current (MVP)
```bash
# Tests verify auto-continue behavior
test "checkpoint auto-continues" {
  result=$(handle_checkpoint "$phase")
  assert_equals "continue" "$result"
}
```

### Future (Production)
```bash
# Tests verify prompt integration
test "checkpoint prompts user" {
  mock_ask_user "Continue"
  result=$(handle_checkpoint "$phase")
  assert_prompt_called "Continue with next phase?"
}
```

---

## Usage in Documentation

When documenting workflows, clearly indicate:

**MVP Behavior:**
```yaml
checkpoint:
  approval_required: true
  # NOTE: Auto-continues in MVP - will prompt in production
```

**Production Behavior:**
```yaml
checkpoint:
  approval_required: true
  # Prompts user: "Continue with next phase?"
  # Options: Continue, Abort
```

---

## Migration Path

1. **No YAML changes required** - Workflows remain compatible
2. **Feature flag approach:**
   ```bash
   if [ -n "$INTERACTIVE_MODE" ]; then
     ask_user "..."
   else
     auto_continue
   fi
   ```
3. **Gradual rollout** - Enable per-workflow or per-user
4. **Backward compatible** - Old stubs work if tools unavailable

---

## References

- **Checkpoint Spec:** `docs/CHECKPOINT_FLOW.md`
- **Gap Check Spec:** `docs/GAP_CHECK_FLOW.md`
- **Implementation Plan:** `IMPLEMENTATION_PLAN_V3.md` (Phase 2)
- **Claude Code Docs:** (Link to AskUserQuestion tool docs)

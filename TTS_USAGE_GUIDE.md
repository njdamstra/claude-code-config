# `/tts` Slash Command - Usage Guide

## Quick Start

The `/tts` command manages text-to-speech configuration for Claude Code hooks.

## Basic Commands

### View Current Configuration
```bash
/tts status
```
Shows:
- Active TTS provider (OpenAI/ElevenLabs/pyttsx3)
- Which hooks have TTS enabled
- Current mode (transcript vs static)
- Environment variables status

### Enable/Disable All TTS
```bash
/tts enable   # Turn on TTS for all hooks
/tts disable  # Turn off TTS for all hooks
```

### Control Individual Hooks
```bash
/tts hook stop on            # Enable Stop hook TTS
/tts hook stop off           # Disable Stop hook TTS

/tts hook notification on    # Enable Notification hook TTS
/tts hook notification off   # Disable Notification hook TTS

/tts hook subagent on        # Enable SubagentStop hook TTS
/tts hook subagent off       # Disable SubagentStop hook TTS
```

### Toggle Transcript Mode (Stop Hook Only)
```bash
/tts mode transcript  # Use transcript summaries
/tts mode static      # Use static messages
```

**Transcript Mode:**
- Reads your full Claude response
- LLM summarizes to 2-3 sentences
- Example: "I created a TTS management slash command with essential controls for enabling/disabling hooks, toggling modes, and viewing configuration."

**Static Mode:**
- Says "Work complete!" or similar
- Faster (no transcript reading)
- LLM still generates varied messages

### Provider Information
```bash
/tts provider
```
Shows which TTS provider is active and how to change it.

**Provider Priority:**
1. ElevenLabs (if `ELEVENLABS_API_KEY` set)
2. OpenAI (if `OPENAI_API_KEY` set)
3. pyttsx3 (offline fallback)

### Test TTS
```bash
/tts test "Hello world"  # Test with custom message
```

## Common Workflows

### Workflow 1: Disable All TTS Temporarily
```bash
/tts disable
# Work without audio
/tts enable  # Re-enable when ready
```

### Workflow 2: Only Use Stop Hook TTS
```bash
/tts hook notification off
/tts hook subagent off
# Now only Stop hook announces
```

### Workflow 3: Switch to Transcript Summaries
```bash
/tts mode transcript
# Now hears actual work summaries instead of "Work complete!"
```

### Workflow 4: Test Configuration
```bash
/tts status              # Check current state
/tts test "Testing TTS"  # Verify audio works
```

## What Each Hook Does

**Stop Hook:**
- Fires when Claude finishes responding
- Can use transcript mode or static mode
- Default: ENABLED with transcript mode

**Notification Hook:**
- Fires when Claude asks for user input
- Says "Your agent needs your input"
- Default: ENABLED

**SubagentStop Hook:**
- Fires when subagent completes
- Says "Subagent Complete"
- Default: DISABLED

## Files Modified by `/tts`

**settings.json:**
- Adds/removes `--notify` flags from hook commands
- Automatically backed up before changes

**stop.py:**
- Comments/uncomments function calls for mode toggle
- Backs up to `stop.py.bak` before changes

**No modifications to:**
- Voice settings (requires manual editing)
- TTS provider scripts
- Environment variables (shows instructions only)

## Troubleshooting

### No Audio Output
1. Check provider: `/tts provider`
2. Verify API key is set: `echo $OPENAI_API_KEY`
3. Test TTS: `/tts test "hello"`

### Wrong Provider Active
- Provider is auto-selected based on env vars
- See `/tts provider` for instructions on changing

### Mode Toggle Not Working
- Check current mode: `/tts status`
- Verify stop.py not locked: `ls -la ~/.claude/hooks/stop.py`

### "Work complete!" Instead of Summary
- Ensure transcript mode enabled: `/tts mode transcript`
- Check Stop hook enabled: `/tts status`
- LLM summarization may have failed (falls back to static)

## Advanced Customization

For advanced features not included in `/tts` command:

**Voice Selection:**
- Manually edit `~/.claude/hooks/utils/tts/openai_tts.py` (line 70)
- Manually edit `~/.claude/hooks/utils/tts/elevenlabs_tts.py` (line 67)

**Speech Rate/Volume (pyttsx3 only):**
- Edit `~/.claude/hooks/utils/tts/pyttsx3_tts.py` (lines 37-38)

**Summary Length:**
- Edit `~/.claude/hooks/stop.py` summarization prompt (lines 219-231)

**Documentation:**
- `~/.claude/hooks/TRANSCRIPT_TTS_README.md` - Complete guide
- `~/.claude/hooks/TRANSCRIPT_TTS_QUICK_REFERENCE.md` - Quick reference

## Examples in Action

### Example 1: Daily Work Session
```bash
# Start with status check
/tts status

# Disable notification TTS (too frequent)
/tts hook notification off

# Enable transcript mode for meaningful feedback
/tts mode transcript

# Work on code...
# (Hear summaries of what Claude did)

# End of day: disable all
/tts disable
```

### Example 2: Testing TTS Setup
```bash
# Check what's configured
/tts status

# Test current provider
/tts test "Testing OpenAI TTS"

# Try different mode
/tts mode static
/tts test "Testing static mode"

# Switch back
/tts mode transcript
```

### Example 3: Minimal TTS Setup
```bash
# Only use Stop hook, no summaries
/tts disable
/tts hook stop on
/tts mode static
# Now only hears "Work complete!" when stopping
```

## Tips

1. **Start with status:** Always run `/tts status` first to see current state
2. **Test after changes:** Use `/tts test` to verify audio works
3. **Transcript mode is powerful:** Gives context about what Claude did
4. **Disable when not needed:** TTS adds 3-8 seconds latency per stop
5. **Notification TTS can be noisy:** Consider disabling if Claude asks many questions

## Help

```bash
/tts help  # Shows detailed help with all commands
```

## Implementation Files

**Created:**
- `~/.claude/commands/tts.md` - Slash command definition
- `~/.claude/scripts/tts-manage.sh` - Management script

**Modified (when used):**
- `~/.claude/settings.json` - Hook configuration
- `~/.claude/hooks/stop.py` - Mode toggle

**Backups created:**
- `~/.claude/settings.json.backup` - Before each JSON change
- `~/.claude/hooks/stop.py.bak` - Before mode toggle

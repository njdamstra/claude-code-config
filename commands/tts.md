---
description: Manage text-to-speech configuration for hooks and notifications
argument-hint: <command> [options]
---

# TTS Management Command

Manage text-to-speech configuration for Claude Code hooks.

## Usage

Call the TTS management script with appropriate arguments:

```bash
bash ~/.claude/scripts/tts-manage.sh $ARGUMENTS
```

## Available Commands

- **status** - Show current TTS configuration
- **enable** - Enable TTS for all hooks
- **disable** - Disable TTS for all hooks
- **hook <name> on|off** - Control individual hook TTS
- **mode transcript|static** - Toggle transcript vs static messages
- **provider** - Show provider information
- **test "message"** - Test TTS output
- **help** - Show detailed help

## Examples

```bash
/tts status                    # View configuration
/tts enable                    # Enable all TTS
/tts hook stop off             # Disable Stop hook only
/tts mode transcript           # Use transcript summaries
/tts test "Hello world"        # Test TTS
```

## Quick Reference

**Essential Controls:**
- Turn on/off completely: `/tts enable` or `/tts disable`
- Per-hook control: `/tts hook <stop|notification|subagent> on|off`
- Change mode: `/tts mode <transcript|static>`
- Check status: `/tts status`

**Transcript Mode (Stop hook only):**
- Reads full Claude response and summarizes to 2-3 sentences
- Uses LLM (OpenAI/Anthropic/Ollama) for summarization
- Falls back to static message if summarization fails

**Static Mode (default):**
- Says "Work complete!" or similar
- Faster (no transcript reading)
- LLM may still generate varied messages

**Providers (auto-selected):**
1. ElevenLabs (if `ELEVENLABS_API_KEY` set)
2. OpenAI (if `OPENAI_API_KEY` set)
3. pyttsx3 (offline fallback)

## Documentation

For advanced customization (voices, rate, volume), see:
- `~/.claude/hooks/TRANSCRIPT_TTS_README.md`
- `~/.claude/hooks/TRANSCRIPT_TTS_QUICK_REFERENCE.md`

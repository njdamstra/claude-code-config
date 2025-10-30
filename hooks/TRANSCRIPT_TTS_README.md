# Transcript-Based TTS Feature

**Added:** 2025-10-29
**Status:** ✅ Active
**Backup:** `~/.claude/hooks/stop.py.backup`

## Overview

This feature enables Claude Code to speak **the actual content of your responses** instead of just saying "Work complete!". When a session ends, the system:

1. ✅ Extracts the last assistant response from the transcript
2. ✅ Summarizes it to 2-3 sentences using an LLM
3. ✅ Speaks the summary via TTS (OpenAI/ElevenLabs/pyttsx3)

## What Changed

### Modified Files

1. **`~/.claude/hooks/stop.py`**
   - Added `extract_last_assistant_response()` function
   - Added `summarize_response_for_tts()` function
   - Added `announce_completion_with_transcript()` function
   - Modified `main()` to call new function
   - **Original `announce_completion()` preserved** (lines 372-395)

2. **`~/.claude/hooks/utils/llm/oai.py`**
   - Added `--summarize` flag support (lines 181-220)
   - Reads prompt from file and generates summary

### New Dependencies

None! Uses existing dependencies:
- `python-dotenv` (already required)
- `openai` (already required for OpenAI TTS)

## How It Works

### Flow Diagram

```
Stop Hook Triggered
    ↓
Extract transcript_path from input_data
    ↓
Read transcript.jsonl file
    ↓
Extract last assistant message (text content only)
    ↓
Is response < 300 chars?
    ↓ No
Summarize using LLM (OpenAI → Anthropic → Ollama)
    ↓ Yes (or if summarization succeeds)
Speak summary via TTS
    ↓
Fall back to "Work complete!" if anything fails
```

### Example

**Your Response:**
```
I've successfully implemented the transcript-based TTS feature.
This adds the ability to read your full Claude response and
summarize it into 2-3 sentences for audio playback. The system
extracts the last assistant message, uses an LLM to create a
concise summary, and speaks it via TTS. I've preserved all
original code with clear comments for easy rollback.
```

**What You Hear:**
> "The transcript-based TTS feature was successfully implemented,
> allowing the system to read and summarize responses into 2-3
> sentences for audio playback. It extracts the latest message,
> creates a concise summary using an AI model, and then reads it
> aloud."

## Configuration

### Current Settings

**In `~/.claude/settings.json`:**
```json
"Stop": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "uv run ~/.claude/hooks/stop.py --chat --notify"
      }
    ]
  }
]
```

The `--notify` flag enables TTS.

### Environment Variables

**Required:**
- `OPENAI_API_KEY` - For TTS and summarization

**Optional:**
- `ANTHROPIC_API_KEY` - Fallback for summarization
- `ELEVENLABS_API_KEY` - Premium TTS provider
- `ENGINEER_NAME` - For personalized messages (currently: "Nathan")

## Customization

### Adjust Summary Length

**File:** `~/.claude/hooks/stop.py` (line 211)

```python
# If response is already short enough, use it directly
if len(full_text) < 300:  # Change this threshold
    return full_text
```

### Change Summary Style

**File:** `~/.claude/hooks/stop.py` (lines 219-231)

Modify the summarization prompt:
```python
summary_prompt = f"""Summarize this Claude Code assistant response...

Requirements:
- Maximum 3 sentences  # Change to 2 or 4
- Focus on actions taken and results
- Use natural spoken language
- No technical jargon unless necessary  # Or allow jargon
- Return ONLY the summary text, no formatting
```

### Increase Timeout

**File:** `~/.claude/hooks/stop.py` (line 354)

```python
timeout=10  # Change to 15 or 20 for longer responses
```

## Rollback Instructions

### Option 1: Disable Feature (Keep Code)

**Edit `~/.claude/hooks/stop.py` (lines 460-473):**

Comment out new function:
```python
# Call new function that uses transcript summary
# announce_completion_with_transcript(transcript_path)

# TO REVERT TO ORIGINAL BEHAVIOR:
# Comment out the above lines and uncomment this:
announce_completion()  # UNCOMMENT THIS LINE
```

### Option 2: Full Rollback

```bash
# Restore original file
cp ~/.claude/hooks/stop.py.backup ~/.claude/hooks/stop.py

# Restart Claude Code
```

## Testing

### Test Transcript Extraction

```bash
# Create test transcript
cat > /tmp/test.jsonl << 'EOF'
{"role":"user","content":[{"type":"text","text":"Test"}]}
{"role":"assistant","content":[{"type":"text","text":"Your test response here"}]}
EOF

# Test extraction
python3 << 'PYTHON'
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/hooks')
from stop import extract_last_assistant_response
result = extract_last_assistant_response("/tmp/test.jsonl")
print(result if result else "❌ Failed")
PYTHON
```

### Test Summarization

```bash
# Create test prompt
cat > /tmp/prompt.txt << 'EOF'
Summarize this: Your long response text here...
EOF

# Test summarization
uv run ~/.claude/hooks/utils/llm/oai.py --summarize /tmp/prompt.txt
```

### Test Full Pipeline

```bash
# Create mock input
cat > /tmp/test_input.json << 'EOF'
{
  "session_id": "test",
  "transcript_path": "/tmp/test.jsonl"
}
EOF

# Test hook
cat /tmp/test_input.json | uv run ~/.claude/hooks/stop.py --notify
```

## Troubleshooting

### No Audio Output

**Check:**
1. `OPENAI_API_KEY` is set: `echo $OPENAI_API_KEY`
2. TTS script exists: `ls ~/.claude/hooks/utils/tts/openai_tts.py`
3. Settings.json has `--notify` flag

**Test TTS directly:**
```bash
uv run ~/.claude/hooks/utils/tts/openai_tts.py "Test message"
```

### Hears "Work complete!" Instead of Summary

**Possible causes:**
1. Transcript extraction failed (transcript_path not found)
2. LLM summarization timed out (>15 seconds)
3. OpenAI API error

**Check logs:**
```bash
cat logs/stop.json | jq '.[-1]'  # View last stop hook data
```

**Debug extraction:**
```bash
# Check if transcript_path is in input_data
cat logs/stop.json | jq '.[-1].transcript_path'
```

### Summary Too Short/Long

**Adjust threshold** in `stop.py` line 211:
```python
if len(full_text) < 300:  # Increase for longer direct reads
```

**Modify LLM prompt** in `stop.py` lines 219-231 to request different length.

## Performance

### Latency

- **Transcript extraction:** ~50ms
- **LLM summarization:** 2-5 seconds (OpenAI Nano)
- **TTS generation:** 1-3 seconds (OpenAI streaming)
- **Total:** ~3-8 seconds

### Cost (OpenAI)

- **LLM summarization:** ~$0.001 per summary (Nano model, ~500 tokens)
- **TTS:** ~$0.015 per 1K characters
- **Average response:** ~100 chars summary = ~$0.0015
- **Total per session:** ~$0.0025 (quarter of a cent)

### Optimizations

1. **Short responses** (<300 chars) skip LLM summarization
2. **Timeouts** prevent hanging (10-15 second limits)
3. **Fallbacks** ensure audio always plays (even if "Work complete!")
4. **Silent failures** prevent hook crashes

## Known Limitations

1. **Only reads last assistant message** (not full conversation)
2. **Ignores tool calls** (extracts text content only)
3. **Timeout at 10 seconds** (long responses may be cut off)
4. **No streaming TTS** (waits for full summary before speaking)
5. **Requires OpenAI API key** (pyttsx3 fallback available but no summarization)

## Future Enhancements

### Possible Improvements

1. **Streaming summarization** - Start speaking as summary generates
2. **Context-aware summaries** - Include conversation history
3. **User preferences** - Configure summary length, style, voice
4. **Caching** - Cache summaries to avoid re-generating
5. **Multiple voices** - Use different voices for different response types
6. **Transcript highlights** - Extract key findings, decisions, or action items

### Configuration File Approach

Instead of editing Python files, create:
```json
// ~/.claude/hooks/tts-config.json
{
  "enabled": true,
  "mode": "transcript",  // or "static"
  "summary_length": 3,
  "summary_style": "technical",  // or "casual", "formal"
  "min_length_for_summary": 300,
  "timeout": 10,
  "fallback_message": "Work complete!"
}
```

## Support

**Issues?** Check:
1. Backup exists: `ls ~/.claude/hooks/stop.py.backup`
2. API keys set: `env | grep -E "(OPENAI|ELEVENLABS)"`
3. Dependencies installed: `uv pip list | grep openai`

**Rollback anytime:**
```bash
cp ~/.claude/hooks/stop.py.backup ~/.claude/hooks/stop.py
```

**Questions?** Review comments in `stop.py` (lines 131-140, 365-370, 460-473)

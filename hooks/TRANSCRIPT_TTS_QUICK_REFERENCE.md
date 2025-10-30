# Transcript TTS - Quick Reference

## ✅ What It Does

Instead of hearing "Work complete!", you now hear a **2-3 sentence summary** of what Claude actually did.

## 🔧 How to Disable

**Edit:** `~/.claude/hooks/stop.py` (line ~467)

**Change:**
```python
announce_completion_with_transcript(transcript_path)
```

**To:**
```python
# announce_completion_with_transcript(transcript_path)
announce_completion()  # Original behavior
```

## ⚡ Full Rollback

```bash
cp ~/.claude/hooks/stop.py.backup ~/.claude/hooks/stop.py
```

## 🎯 Quick Test

```bash
# Test TTS works
uv run ~/.claude/hooks/utils/tts/openai_tts.py "Testing transcript TTS"

# Test summarization works
echo "Long text to summarize..." > /tmp/test.txt
cat > /tmp/prompt.txt << 'EOF'
Summarize: Long text to summarize...
EOF
uv run ~/.claude/hooks/utils/llm/oai.py --summarize /tmp/prompt.txt
```

## 📝 Files Changed

- `~/.claude/hooks/stop.py` (backup: `stop.py.backup`)
- `~/.claude/hooks/utils/llm/oai.py` (added `--summarize` flag)

## ⚙️ Settings

**Current:** `~/.claude/settings.json`
```json
"command": "uv run ~/.claude/hooks/stop.py --chat --notify"
```

- `--chat` = Save transcript to logs/chat.json
- `--notify` = Enable TTS audio

## 💡 Key Info

- **Cost:** ~$0.0025 per session (OpenAI)
- **Latency:** 3-8 seconds
- **Fallback:** Says "Work complete!" if anything fails
- **Length:** Short responses (<300 chars) read directly, long ones summarized

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| No audio | Check `echo $OPENAI_API_KEY` |
| Hears "Work complete!" | Summarization failed, check logs/stop.json |
| Too slow | Reduce timeout in stop.py line 354 |
| Summary wrong | Adjust prompt in stop.py lines 219-231 |

## 📚 Full Docs

See: `~/.claude/hooks/TRANSCRIPT_TTS_README.md`

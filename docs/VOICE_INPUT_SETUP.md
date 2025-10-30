# Voice Input Setup for Claude Code

**Status:** ✅ `hear` installed and ready to use!

## Quick Start

You can now use voice input in Claude Code! Here's how:

### Method 1: Direct Command (Test It Now!)

```bash
hear -d
```

**What happens:**
1. Your microphone activates
2. Start speaking
3. Stop speaking (it auto-detects silence)
4. Text appears in terminal

**Try it now!** Run the command above and say: "This is a test of voice input"

### Method 2: Via Script

```bash
bash ~/.claude/scripts/stt-hear.sh
```

Same as Method 1, but uses the convenience script.

---

## iTerm2 Keyboard Shortcut Setup

Set up `Cmd+Shift+V` to activate voice input instantly!

### Step-by-Step Instructions

1. **Open iTerm2 Preferences**
   - Press `Cmd+,` or go to iTerm2 → Settings

2. **Navigate to Keys**
   - Click "Keys" tab
   - Click "Key Bindings" sub-tab

3. **Add New Binding**
   - Click the `+` button at the bottom

4. **Configure the Shortcut**
   - **Keyboard Shortcut:** Press `Cmd+Shift+V`
   - **Action:** Select "Run Coprocess..."
   - **Text/Command:** Enter exactly:
     ```
     hear -d
     ```

5. **Save**
   - Click OK

### Test Your Keyboard Shortcut

1. Click in your terminal
2. Press `Cmd+Shift+V`
3. Speak: "Hello Claude Code"
4. Watch the text appear!

---

## How It Works

### The `hear` Command

**Basic Usage:**
```bash
hear              # Transcribe and output text
hear -d           # On-device only (privacy mode)
hear file.mp3     # Transcribe audio file
hear --help       # Show all options
```

**Flags:**
- `-d` - Use on-device recognition only (recommended for privacy)
- `-n` - No newline after output
- `-v` - Verbose output (shows timing info)

### What the `-d` Flag Does

**With `-d` (recommended):**
- ✅ All processing happens on your Mac
- ✅ No data sent to Apple servers
- ✅ Completely private
- ⚠️ Limited to ~500 characters

**Without `-d`:**
- ❌ May send data to Apple servers
- ✅ Can transcribe longer audio
- ⚠️ Privacy concerns

**For Claude Code, always use `-d` for privacy!**

---

## Using Voice Input with Claude Code

### Scenario 1: Dictate Prompts

Instead of typing:
```
Explain how nanostores work with Vue 3
```

Do this:
1. Press `Cmd+Shift+V` (or run `hear -d`)
2. Say: "Explain how nanostores work with Vue 3"
3. Press Enter

### Scenario 2: Dictate Code

1. Press `Cmd+Shift+V`
2. Say: "Create a function called calculate total that takes an array of numbers and returns the sum"
3. Claude Code receives the text and responds

### Scenario 3: Long Descriptions

Instead of typing complex requirements:
1. Press `Cmd+Shift+V`
2. Speak naturally about what you want
3. The transcription appears as your input

---

## Tips for Best Results

### Speaking Tips

1. **Speak clearly** - Normal conversational pace
2. **Pause after speaking** - Wait 1-2 seconds for auto-detection
3. **Avoid background noise** - Quiet environment works best
4. **Use natural punctuation** - Say "period", "comma", "question mark"
5. **Spell out symbols** - Say "dollar sign", "at sign", etc.

### Dictation Commands

macOS recognizes these spoken commands:

| Say | Result |
|-----|--------|
| "period" | . |
| "comma" | , |
| "question mark" | ? |
| "exclamation point" | ! |
| "new line" | ↵ |
| "new paragraph" | ↵↵ |
| "quote" / "end quote" | "..." |
| "open parenthesis" / "close parenthesis" | (...) |
| "hyphen" or "dash" | - |
| "underscore" | _ |
| "at sign" | @ |
| "dollar sign" | $ |

### Common Issues

**Issue: Microphone not activating**
- Check System Settings → Privacy & Security → Microphone
- Ensure iTerm2 has microphone permission
- Test with: `hear -d` directly

**Issue: No text appears**
- Speak louder or adjust microphone input level
- Check for background noise
- Try removing `-d` flag temporarily (but less private)

**Issue: Keyboard shortcut doesn't work**
- Verify binding in iTerm2 → Settings → Keys
- Check for conflicting shortcuts
- Try a different key combination

**Issue: Text is inaccurate**
- Speak more slowly and clearly
- Reduce background noise
- Consider upgrading to Whisper for better accuracy

---

## Advanced: Slash Command Integration

### Create `/speak` Command

**File:** `~/.claude/commands/speak.md`

```markdown
---
description: Dictate input using speech-to-text
---

# Speech Input

Activate voice dictation:

\`\`\`bash
hear -d
\`\`\`

Speak your prompt, and the text will appear.
```

**Usage:**
```bash
/speak
# Then speak your prompt
```

---

## Upgrading to Whisper (Optional)

If you need better accuracy, you can upgrade to Whisper later.

### Why Upgrade?

- **hear:** Good accuracy, instant, free, private
- **Whisper:** Excellent accuracy, 2-3 second delay, free, private

### How to Upgrade

See the full research report:
```
~/.claude/web-reports/stt-voice-input-claude-code-2025-10-29.md
```

---

## Troubleshooting

### Enable Microphone Access

1. System Settings → Privacy & Security
2. Microphone
3. Enable for "iTerm2" or "Terminal"

### Test Microphone

```bash
# Test audio input
hear -d
# Speak: "Testing one two three"
```

### Check hear Installation

```bash
which hear
# Should output: /usr/local/bin/hear

hear --help
# Should show usage information
```

### iTerm2 Coprocess Issues

If the keyboard shortcut doesn't work:

1. Try "Send Text" action instead of "Run Coprocess"
2. Use this text:
   ```
   hear -d\n
   ```
3. This will paste the command and execute it

---

## Configuration Files

**Scripts:**
- `~/.claude/scripts/stt-hear.sh` - Convenience script

**Documentation:**
- `~/.claude/docs/VOICE_INPUT_SETUP.md` - This file
- `~/.claude/web-reports/stt-voice-input-claude-code-*.md` - Research report

**Binary:**
- `/usr/local/bin/hear` - hear command-line tool

---

## Next Steps

1. ✅ **Test basic voice input:** Run `hear -d` and speak
2. ✅ **Set up keyboard shortcut:** Add `Cmd+Shift+V` in iTerm2
3. ✅ **Use with Claude Code:** Press shortcut, speak your prompt
4. 🔄 **Upgrade to Whisper** (optional): Better accuracy when needed

---

## Cost & Privacy

**hear:**
- **Cost:** FREE ✅
- **Privacy:** 100% local with `-d` flag ✅
- **Accuracy:** Good (native macOS recognition)
- **Speed:** Instant
- **Languages:** English primarily (macOS dependent)

**Comparison:**
- Whisper Local: Better accuracy, still free and private
- Whisper API: Best accuracy, $0.36/hour, requires internet
- See research report for full comparison

---

## Quick Reference Card

```
╔══════════════════════════════════════════╗
║  VOICE INPUT QUICK REFERENCE             ║
╚══════════════════════════════════════════╝

ACTIVATE VOICE INPUT:
  Cmd+Shift+V              (after iTerm2 setup)
  hear -d                  (direct command)
  bash ~/.claude/scripts/stt-hear.sh

SPEAKING TIPS:
  - Speak clearly at normal pace
  - Pause 1-2 seconds when done
  - Say punctuation ("period", "comma")
  - Use quiet environment

COMMON COMMANDS:
  "new line"               → ↵
  "period"                 → .
  "comma"                  → ,
  "question mark"          → ?
  "open parenthesis"       → (
  "close parenthesis"      → )

TROUBLESHOOTING:
  - Check microphone permission
  - Test with: hear -d
  - Speak louder/clearer
  - Reduce background noise

UPGRADE PATH:
  hear → Whisper Local → Whisper API
  (good) → (excellent) → (excellent + fast)
```

---

## Support

**Issues with hear?**
- GitHub: https://github.com/sveinbjornt/hear
- Author: https://sveinbjorn.org

**Issues with setup?**
- Check microphone permissions
- Verify iTerm2 key binding
- Test `hear -d` directly first
- See Troubleshooting section above

**Want better accuracy?**
- See Whisper upgrade guide in research report
- `~/.claude/web-reports/stt-voice-input-claude-code-*.md`

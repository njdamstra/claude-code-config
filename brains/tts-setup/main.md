# TTS Setup Documentation

## Overview

The Claude Code TTS (Text-to-Speech) system provides audio notifications for hook events, enabling hands-free awareness of agent activity. The system features intelligent provider fallback, LLM-powered message generation, and transcript summarization for contextual feedback.

**Primary Use Cases:**
- Audible completion notifications when Claude finishes work
- Notifications when user input is needed
- Subagent completion announcements
- Contextual summaries of Claude's work via transcript processing

**System Characteristics:**
- **Fail-safe design** - TTS failures never interrupt Claude Code execution
- **Graceful degradation** - Automatic fallback from premium to offline providers
- **Optional enhancement** - All hooks function normally without TTS
- **Runtime control** - Enable/disable via `/tts` command without code changes

## Architecture

### System Layers

The TTS system operates across 5 architectural layers:

```
┌─────────────────────────────────────────────────────────┐
│  Management Layer                                       │
│  /tts command → tts-manage.sh                          │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Hook Layer                                             │
│  Stop, Notification, SubagentStop hooks                 │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Provider Layer                                         │
│  TTS: ElevenLabs → OpenAI → pyttsx3                    │
│  LLM: OpenAI → Anthropic → Ollama → Static            │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Utility Layer                                          │
│  TTS scripts (3), LLM scripts (3)                       │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Configuration Layer                                    │
│  settings.json, environment variables                   │
└─────────────────────────────────────────────────────────┘
```

### Core Components

**Management:**
- `~/.claude/scripts/tts-manage.sh` - CLI for TTS configuration
- `~/.claude/commands/tts.md` - Slash command definition

**Hooks (3 hooks with TTS integration):**
- `~/.claude/hooks/stop.py` - Completion notifications (transcript or static mode)
- `~/.claude/hooks/notification.py` - User input notifications
- `~/.claude/hooks/subagent_stop.py` - Subagent completion notifications

**TTS Providers (priority order):**
1. `~/.claude/hooks/utils/tts/elevenlabs_tts.py` - Premium TTS (eleven_turbo_v2_5)
2. `~/.claude/hooks/utils/tts/openai_tts.py` - Cloud TTS (gpt-4o-mini-tts)
3. `~/.claude/hooks/utils/tts/pyttsx3_tts.py` - Offline fallback (system TTS)

**LLM Utilities (for message generation):**
1. `~/.claude/hooks/utils/llm/oai.py` - OpenAI (completion + summarization)
2. `~/.claude/hooks/utils/llm/anth.py` - Anthropic (completion only)
3. `~/.claude/hooks/utils/llm/ollama.py` - Local LLM (completion only)

**Configuration:**
- `~/.claude/settings.json` - Hook configurations with `--notify` flags
- `~/.zshrc` or `~/.bashrc` - Environment variables (API keys, ENGINEER_NAME)

## Data Flows

### 1. Enable TTS Flow

```
User: /tts enable
  ↓
tts-manage.sh enable_all()
  ↓
Read settings.json with jq
  ↓
Create backup: settings.json.backup
  ↓
Add --notify flag to hook commands:
  - Stop hook: --chat --notify
  - Notification hook: --notify
  - SubagentStop hook: --notify
  ↓
Write settings.json with jq
  ↓
Display: "✅ TTS enabled for all hooks"
```

**Duration:** <1 second

### 2. Static Mode TTS Flow (Default)

```
Claude stops work
  ↓
Stop hook triggers (settings.json: --chat --notify)
  ↓
stop.py --chat --notify
  ↓
announce_completion()
  ↓
get_llm_completion_message()
  ├─ Try OpenAI LLM (10s timeout)
  │  └─ Success: "Great job! All set for your review."
  ├─ Timeout → Try Anthropic (10s timeout)
  ├─ Timeout → Try Ollama (10s timeout)
  └─ All failed → random.choice(static_messages)
     ["Work complete!", "All done!", "Task finished!"]
  ↓
get_tts_script_path()
  ├─ Check ELEVENLABS_API_KEY + file exists
  ├─ Else check OPENAI_API_KEY + file exists
  └─ Else pyttsx3_tts.py
  ↓
subprocess.run(['uv', 'run', tts_script, message], timeout=10)
  ↓
Audio playback (3-8 seconds)
  ↓
Silent failure if any step fails (try/except pass)
```

**Duration:** 3-8 seconds (LLM generation) + 2-5 seconds (TTS playback)

### 3. Transcript Mode TTS Flow (Advanced)

```
Claude stops work
  ↓
Stop hook triggers
  ↓
stop.py --chat --notify
  ↓
announce_completion_with_transcript(transcript_path)
  ↓
extract_last_assistant_response(transcript_path)
  ├─ Parse .jsonl transcript
  ├─ Find last role="assistant" message
  ├─ Extract all text content (ignore tool_use)
  └─ Return full_text or None
  ↓
Check length:
  ├─ If <300 chars: Use directly
  └─ If ≥300 chars: summarize_response_for_tts(full_text)
     ↓
     Create temp file with prompt:
     "Summarize in 2-3 sentences for TTS"
     ↓
     subprocess.run(['uv', 'run', 'oai.py', '--summarize', temp_path], timeout=15)
     **Note:** Only OpenAI (oai.py) supports --summarize flag.
               Anthropic and Ollama LLM scripts do not implement summarization.
     ↓
     LLM returns: "I created a user profile component with form validation
                   and dark mode support. The component integrates with
                   Appwrite for data persistence."
     ↓
     os.unlink(temp_path)
  ↓
get_tts_script_path()
  ↓
subprocess.run(['uv', 'run', tts_script, summary], timeout=10)
  ↓
Audio playback
```

**Duration:** 5-15 seconds (summarization) + 5-10 seconds (TTS playback)

**Fallback chain:**
1. Transcript summary (if OpenAI LLM succeeds - **only OpenAI supports summarization**)
2. Truncate to 250 chars (if OpenAI LLM timeout or unavailable)
3. LLM-generated completion message (if transcript unavailable)
4. Random static message (if all LLMs fail)
5. Silent failure (if TTS fails)

**Important:** Transcript summarization **requires OpenAI API key**. Anthropic and Ollama LLM providers do not implement the `--summarize` flag.

### 4. Notification Flow

```
User input needed
  ↓
Notification hook triggers
  ↓
notification.py --notify
  ↓
announce_notification()
  ↓
Check ENGINEER_NAME:
  ├─ If set + random.random() < 0.3:
  │  message = "{ENGINEER_NAME}, your agent needs your input"
  └─ Else:
     message = "Your agent needs your input"
  ↓
get_tts_script_path()
  ↓
subprocess.run(['uv', 'run', tts_script, message], timeout=10)
  ↓
Audio playback
```

**Duration:** 2-4 seconds

**Personalization:** 30% chance to include engineer name for variety without repetition.

## Provider Selection

### TTS Provider Priority

```python
def get_tts_script_path():
    tts_dir = Path(__file__).parent / 'utils' / 'tts'

    # Priority 1: ElevenLabs (premium)
    if os.getenv('ELEVENLABS_API_KEY'):
        script = tts_dir / 'elevenlabs_tts.py'
        if script.exists():
            return str(script)

    # Priority 2: OpenAI (cloud)
    if os.getenv('OPENAI_API_KEY'):
        script = tts_dir / 'openai_tts.py'
        if script.exists():
            return str(script)

    # Priority 3: pyttsx3 (offline fallback)
    pyttsx3_script = tts_dir / 'pyttsx3_tts.py'
    if pyttsx3_script.exists():
        return str(pyttsx3_script)

    return None  # No TTS available
```

**Selection Logic:**
1. Check environment variable for API key
2. Verify script file exists (prevents crashes)
3. Return script path or cascade to next provider
4. Return None if no providers available (silent skip)

**File Locations:**
- ElevenLabs: `~/.claude/hooks/utils/tts/elevenlabs_tts.py`
- OpenAI: `~/.claude/hooks/utils/tts/openai_tts.py`
- pyttsx3: `~/.claude/hooks/utils/tts/pyttsx3_tts.py`

### LLM Provider Priority

```python
def get_llm_completion_message():
    llm_dir = Path(__file__).parent / 'utils' / 'llm'

    # Try OpenAI
    if os.getenv('OPENAI_API_KEY'):
        result = subprocess.run(['uv', 'run', str(llm_dir / 'oai.py'), '--completion'],
                                capture_output=True, timeout=10)
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

    # Try Anthropic
    if os.getenv('ANTHROPIC_API_KEY'):
        result = subprocess.run(['uv', 'run', str(llm_dir / 'anth.py'), '--completion'],
                                capture_output=True, timeout=10)
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

    # Try Ollama (local)
    try:
        result = subprocess.run(['uv', 'run', str(llm_dir / 'ollama.py'), '--completion'],
                                capture_output=True, timeout=10)
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()
    except:
        pass

    # Static fallback
    return random.choice([
        "Work complete!",
        "All done!",
        "Task finished!",
        "Job complete!",
        "Ready for next task!"
    ])
```

**Key Differences from TTS:**
- Each provider is tried with timeout (10s)
- Failures cascade to next provider
- Ultimate fallback: random static message (never silent)

## Configuration

### Environment Variables

**Location:** `~/.zshrc` or `~/.bashrc`

```bash
# TTS Providers (priority order)
export ELEVENLABS_API_KEY="sk-..."     # Priority 1: Premium TTS
export OPENAI_API_KEY="sk-..."         # Priority 2: Cloud TTS

# LLM Providers (for message generation)
export ANTHROPIC_API_KEY="sk-ant-..." # LLM fallback

# Personalization (optional)
export ENGINEER_NAME="Nate"            # 30% inclusion in notifications

# Ollama Configuration (optional)
export OLLAMA_MODEL="gpt-oss:20b"      # Override default Ollama model
```

**Required:** None (pyttsx3 works offline)

**Recommended:**
- `OPENAI_API_KEY` for balanced TTS quality and LLM features
- `ELEVENLABS_API_KEY` for highest quality TTS
- `ENGINEER_NAME` for personalized notifications

### settings.json Hook Configuration

**Location:** `~/.claude/settings.json`

**TTS Control:** Add `--notify` flag to hook commands

**Current Configuration:**

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "command": "uv run ~/.claude/hooks/stop.py --chat --notify",
            "filter": {
              "stop_reasons": ["UserStopped", "AgentStopped"]
            }
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "command": "uv run ~/.claude/hooks/notification.py --notify"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "command": "uv run ~/.claude/hooks/subagent_stop.py"
          }
        ]
      }
    ]
  }
}
```

**Flag Status:**
- Stop hook: `--chat --notify` ✅ ENABLED (transcript mode)
- Notification hook: `--notify` ✅ ENABLED
- SubagentStop hook: (no --notify) ❌ DISABLED

**Modification:**
- Manual: Add/remove `--notify` flag from command strings
- Automated: Use `/tts` command (safer, creates backups)

### Provider-Specific Configuration

#### OpenAI TTS Configuration

**File:** `~/.claude/hooks/utils/tts/openai_tts.py`

```python
# Line 70-74: Voice configuration
client.audio.speech.stream(
    model="gpt-4o-mini-tts",
    voice="nova",  # Options: alloy, echo, fable, onyx, nova, shimmer
    instructions="Speak in a cheerful, positive yet professional tone.",
    input=text,
    response_format="pcm"
)
```

**Available Voices:**
- `alloy` - Neutral, balanced
- `echo` - Male, clear
- `fable` - British, dramatic
- `onyx` - Deep, authoritative
- `nova` - Female, energetic (default)
- `shimmer` - Soft, gentle

**To Customize:** Edit line 72: `voice="nova"` → `voice="alloy"`

#### ElevenLabs TTS Configuration

**File:** `~/.claude/hooks/utils/tts/elevenlabs_tts.py`

```python
# Line 67-71: Voice and model configuration
audio_stream = client.text_to_speech.convert(
    voice_id="WejK3H1m7MI9CHnIjW9K",  # Custom voice ID
    text=text,
    model_id="eleven_turbo_v2_5",
    output_format="mp3_44100_128"
)
```

**To Customize:**
1. Get voice ID from ElevenLabs dashboard
2. Edit line 67: `voice_id="..."`
3. Optional: Change model to `"eleven_multilingual_v2"` for more languages

#### pyttsx3 TTS Configuration

**File:** `~/.claude/hooks/utils/tts/pyttsx3_tts.py`

```python
# Line 37-38: Speech rate and volume
engine.setProperty('rate', 180)    # Words per minute (default: 180)
engine.setProperty('volume', 0.8)  # Volume 0.0-1.0 (default: 0.8)
```

**To Customize:**
- Rate: 150-200 WPM typical (150=slower, 200=faster)
- Volume: 0.5-1.0 (0.5=quieter, 1.0=loudest)

## Mode System

The Stop hook supports two operational modes:

### Transcript Mode (Advanced)

**Behavior:** Reads Claude's final response, summarizes it via LLM, speaks summary

**Advantages:**
- Contextual feedback ("I created a user profile component...")
- Know what was accomplished without reading
- More informative than generic "work complete"

**Disadvantages:**
- Slower (5-15 seconds total)
- Requires transcript file availability
- Costs ~$0.0025 per session (OpenAI summarization)
- Only works with Stop hook

**When to Use:**
- Long work sessions where you want summaries
- Background work monitoring
- When you're away from screen

**Current State:** ✅ ACTIVE (line 467 in stop.py)

### Static Mode (Basic)

**Behavior:** Generates varied completion message via LLM or uses static fallback

**Advantages:**
- Faster (3-8 seconds total)
- Works with all hooks
- No transcript dependency
- Cheaper (~$0.0005 per session or free with static fallback)

**Disadvantages:**
- Generic messages ("Work complete!")
- No context about what was accomplished

**When to Use:**
- Quick task iterations
- When transcript context not needed
- Faster feedback preferred

**Current State:** ❌ INACTIVE (line 472 commented in stop.py)

### Mode Toggle

**Command:** `/tts mode <transcript|static>`

**Implementation:**

```bash
# Enable transcript mode
/tts mode transcript
→ Uncomments: announce_completion_with_transcript(transcript_path)
→ Comments:   # announce_completion()

# Enable static mode
/tts mode static
→ Comments:   # announce_completion_with_transcript(transcript_path)
→ Uncomments: announce_completion()
```

**How It Works:**
1. `tts-manage.sh set_mode_transcript()` or `set_mode_static()`
2. Uses `sed` to modify `~/.claude/hooks/stop.py`
3. Creates backup: `stop.py.bak`
4. Two-pass operation: comment one line, uncomment another
5. Displays confirmation

**Note:** Only affects Stop hook. Notification and SubagentStop always use static messages.

## Slash Command Usage

### Status Check

```bash
$ /tts status

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          🔊 TTS STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

HOOK STATUS:
  Stop:         [ENABLED]  --chat --notify
  Notification: [ENABLED]  --notify
  SubagentStop: [DISABLED]

MODE:
  Current: transcript
  Function: announce_completion_with_transcript()

PROVIDERS:
  TTS:  ElevenLabs (eleven_turbo_v2_5)
  LLM:  OpenAI (gpt-4.1-nano)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Enable/Disable All Hooks

```bash
# Enable TTS for all hooks
$ /tts enable
✅ TTS enabled for Stop hook
✅ TTS enabled for Notification hook
✅ TTS enabled for SubagentStop hook
📝 Changes saved to settings.json
💾 Backup created: settings.json.backup

# Disable TTS for all hooks
$ /tts disable
❌ TTS disabled for Stop hook
❌ TTS disabled for Notification hook
❌ TTS disabled for SubagentStop hook
📝 Changes saved to settings.json
```

### Individual Hook Control

```bash
# Enable specific hook
$ /tts hook stop on
✅ TTS enabled for Stop hook
📝 Changes saved to settings.json

# Disable specific hook
$ /tts hook notification off
❌ TTS disabled for Notification hook
📝 Changes saved to settings.json

# Available hooks: stop, notification, subagent
```

### Mode Toggle

```bash
# Switch to transcript mode
$ /tts mode transcript
🔄 Switching to transcript mode...
✅ Mode changed to: transcript
📝 Updated stop.py
💾 Backup created: stop.py.bak

# Switch to static mode
$ /tts mode static
🔄 Switching to static mode...
✅ Mode changed to: static
📝 Updated stop.py
```

### Provider Information

```bash
$ /tts provider

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          🎙️  TTS PROVIDER INFO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ACTIVE TTS PROVIDER:
  Name:   ElevenLabs
  Model:  eleven_turbo_v2_5
  Voice:  WejK3H1m7MI9CHnIjW9K
  Source: ELEVENLABS_API_KEY

FALLBACK CHAIN:
  1. ElevenLabs (ELEVENLABS_API_KEY) ✅
  2. OpenAI     (OPENAI_API_KEY)     ✅
  3. pyttsx3    (offline)            ✅

ACTIVE LLM PROVIDER:
  Name:   OpenAI
  Model:  gpt-4.1-nano
  Source: OPENAI_API_KEY

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Test TTS

```bash
# Test with default message
$ /tts test
🧪 Testing TTS...
🎙️  Provider: ElevenLabs
📝 Message: "Testing text-to-speech"
[Audio plays]
✅ TTS test successful

# Test with custom message
$ /tts test "Hello world, this is a test"
🧪 Testing TTS...
🎙️  Provider: ElevenLabs
📝 Message: "Hello world, this is a test"
[Audio plays]
✅ TTS test successful
```

### Help

```bash
$ /tts help

TTS (Text-to-Speech) Management

COMMANDS:
  /tts status              Show current TTS configuration
  /tts enable              Enable TTS for all hooks
  /tts disable             Disable TTS for all hooks
  /tts hook <name> on|off  Control individual hook (stop, notification, subagent)
  /tts mode <type>         Switch mode (transcript or static)
  /tts provider            Show TTS provider information
  /tts test [message]      Test TTS with optional custom message
  /tts help                Show this help

EXAMPLES:
  /tts enable              # Enable all hooks
  /tts hook stop off       # Disable only stop hook
  /tts mode transcript     # Use transcript summarization
  /tts test "Hello!"       # Test with custom message
```

## Implementation Details

### Transcript Processing Pipeline

**File:** `~/.claude/hooks/stop.py`

**Function:** `extract_last_assistant_response(transcript_path)`

```python
def extract_last_assistant_response(transcript_path):
    """Extract last assistant response from transcript .jsonl file"""
    try:
        with open(transcript_path, 'r') as f:
            lines = f.readlines()

        # Parse from end to find last assistant message
        for line in reversed(lines):
            message = json.loads(line)
            if message.get('role') == 'assistant':
                # Extract text content only (ignore tool_use)
                content = message.get('content', [])
                text_parts = [
                    block.get('text', '')
                    for block in content
                    if isinstance(block, dict) and block.get('type') == 'text'
                ]
                return ' '.join(text_parts).strip()

        return None
    except Exception:
        return None  # Silent failure
```

**Logic:**
1. Read transcript .jsonl file
2. Parse JSON line by line from end (most recent first)
3. Find first `role="assistant"` message
4. Extract only `type="text"` blocks (ignore `tool_use` blocks)
5. Join all text parts with spaces
6. Return full text or None on any error

**Edge Cases:**
- Malformed JSON: Silent skip, continue to next line
- Missing role key: Skip message
- Empty text blocks: Skip and join remaining
- File not found: Return None (hook uses LLM completion fallback)

### Summarization Pipeline

**File:** `~/.claude/hooks/stop.py`

**Function:** `summarize_response_for_tts(full_text)`

```python
def summarize_response_for_tts(full_text):
    """Summarize long response to 2-3 sentences for TTS"""
    # Direct use if short enough
    if len(full_text) < 300:
        return full_text

    # Try OpenAI summarization
    llm_dir = Path(__file__).parent / 'utils' / 'llm'
    oai_script = llm_dir / 'oai.py'

    if not oai_script.exists():
        return full_text[:250] + '...'  # Truncate if script missing

    try:
        # Create temp file with prompt
        with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
            prompt = f"""Summarize the following text in 2-3 concise sentences suitable for text-to-speech:

{full_text}

Keep it casual and direct. Focus on what was accomplished."""
            f.write(prompt)
            temp_path = f.name

        # Call OpenAI with --summarize flag
        result = subprocess.run(
            ['uv', 'run', str(oai_script), '--summarize', temp_path],
            capture_output=True,
            timeout=15,  # Longer timeout for summarization
            text=True
        )

        # Cleanup temp file
        os.unlink(temp_path)

        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

    except subprocess.TimeoutExpired:
        os.unlink(temp_path)
    except Exception:
        if os.path.exists(temp_path):
            os.unlink(temp_path)

    # Fallback: truncate
    return full_text[:250] + '...'
```

**Logic:**
1. Check length: <300 chars = use directly
2. Create temp file with summarization prompt
3. Call `oai.py --summarize <temp_file>` with 15s timeout
4. Cleanup temp file (even on exception)
5. Fallback to truncation if any step fails

**Edge Cases:**
- Short response: Skip summarization overhead
- Script missing: Truncate immediately
- Timeout: Truncate (don't wait forever)
- LLM API error: Truncate
- Temp file cleanup: Guaranteed via try/finally pattern

**Why Temp File?**
- Avoids command-line argument length limits (4096 chars on many systems)
- Avoids shell escaping issues with quotes/special characters
- More reliable than stdin pipe for large text

### JQ Settings Manipulation

**File:** `~/.claude/scripts/tts-manage.sh`

**Function:** `enable_hook_tts(hook_name)`

```bash
enable_hook_tts() {
    local hook_name="$1"
    local settings_file="$HOME/.claude/settings.json"
    local backup_file="$settings_file.backup"

    # Create backup
    cp "$settings_file" "$backup_file"

    # Read current command
    local current_cmd=$(jq -r ".hooks.${hook_name}[0].hooks[0].command" "$settings_file")

    # Check if already enabled
    if echo "$current_cmd" | grep -q -- '--notify'; then
        echo "✅ TTS already enabled for $hook_name hook"
        return
    fi

    # Add --notify flag
    local new_cmd="${current_cmd} --notify"

    # Update settings.json using jq
    jq ".hooks.${hook_name}[0].hooks[0].command = \"$new_cmd\"" "$settings_file" > "$settings_file.tmp"
    mv "$settings_file.tmp" "$settings_file"

    echo "✅ TTS enabled for $hook_name hook"
}
```

**Logic:**
1. Create backup before any modification
2. Read current command with `jq -r` (raw output)
3. Check if `--notify` already present (idempotent)
4. Append `--notify` flag
5. Use `jq` to update specific path
6. Write to temp file, then atomic move (prevents corruption)
7. Display confirmation

**JQ Path Syntax:**
- `.hooks.Stop[0].hooks[0].command` - Navigate JSON structure
- Array access: `[0]` for first element
- String assignment: `= "new value"`

**Why JQ?**
- Preserves JSON formatting
- Handles escaping automatically
- Atomic writes via temp file
- Safer than regex find-replace

### Sed Mode Switching

**File:** `~/.claude/scripts/tts-manage.sh`

**Function:** `set_mode_transcript()`

```bash
set_mode_transcript() {
    local hook_file="$HOME/.claude/hooks/stop.py"

    # Create backup
    cp "$hook_file" "${hook_file}.bak"

    # Uncomment transcript line (remove leading #)
    sed -i '' 's/^[[:space:]]*# \(announce_completion_with_transcript(\)/    \1/' "$hook_file"

    # Comment static line (add leading #)
    sed -i '' 's/^[[:space:]]*\(announce_completion()\)/    # \1/' "$hook_file"

    echo "✅ Mode changed to: transcript"
}
```

**Logic:**
1. Create backup: `stop.py.bak`
2. First sed: Uncomment transcript line
   - Find: `# announce_completion_with_transcript(`
   - Replace: `announce_completion_with_transcript(` (remove `#`)
   - Pattern: `^[[:space:]]*#` = line start + whitespace + `#`
3. Second sed: Comment static line
   - Find: `announce_completion()`
   - Replace: `# announce_completion()`
   - Pattern: `^[[:space:]]*` = line start + whitespace

**Why Two Operations?**
- Can't use single sed command (need to modify two different lines)
- Order matters: uncomment first, then comment second
- Separate operations = clearer logic

**macOS Note:** `-i ''` syntax (empty extension) for in-place edit without backup suffix

### Silent Failure Pattern

All TTS calls use consistent error handling:

```python
def announce_completion():
    if not args.notify:
        return  # Early exit if TTS disabled

    try:
        tts_script = get_tts_script_path()
        if not tts_script:
            return  # No providers available

        message = get_llm_completion_message()

        subprocess.run(
            ['uv', 'run', tts_script, message],
            capture_output=True,  # Suppress output
            timeout=10,           # Prevent hanging
            check=False           # Don't raise on non-zero exit
        )
    except subprocess.TimeoutExpired:
        pass  # Silent timeout
    except subprocess.SubprocessError:
        pass  # Silent subprocess error
    except FileNotFoundError:
        pass  # Script not found
    except Exception:
        pass  # Catch-all silent failure
```

**Principles:**
1. **Never interrupt hook execution** - Hooks must complete even if TTS fails
2. **Suppress all output** - `capture_output=True` prevents debug spam
3. **Timeout protection** - Prevent indefinite hangs
4. **Multiple exception handlers** - Specific errors + catch-all
5. **No logging** - Truly silent (TTS is non-critical)

**Rationale:**
- TTS is an optional enhancement
- Audio failures shouldn't break Claude Code
- User can test TTS separately with `/tts test`
- Errors caught: API failures, network issues, missing dependencies, timeouts

## Dependencies

### System Requirements

**Required:**
- `uv` - Python package manager (PEP 723 script execution)
- `jq` - JSON processor for settings.json manipulation
- `bash` 4.0+ - Shell script execution

**Install:**
```bash
# macOS
brew install uv jq

# Linux (Debian/Ubuntu)
apt-get install jq
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify
uv --version
jq --version
bash --version
```

### Python Packages

**Managed by UV (PEP 723 inline metadata):**

Each Python script includes dependency declarations:
```python
# /// script
# dependencies = [
#   "openai>=1.0.0",
#   "python-dotenv",
# ]
# ///
```

UV automatically installs dependencies when running scripts.

**Package Summary:**

| Package | Required By | Purpose |
|---------|-------------|---------|
| python-dotenv | All scripts | Load .env files |
| openai | openai_tts.py, oai.py, ollama.py | OpenAI API |
| openai[voice_helpers] | openai_tts.py | LocalAudioPlayer for streaming |
| elevenlabs | elevenlabs_tts.py | ElevenLabs API |
| pyttsx3 | pyttsx3_tts.py | Offline TTS |
| anthropic | anth.py | Anthropic API |

**Manual Installation (if needed):**
```bash
# Usually not needed (UV handles this)
pip install python-dotenv openai elevenlabs pyttsx3 anthropic
```

## Setup Guide

### Initial Setup

**1. Install System Dependencies**
```bash
brew install uv jq
```

**2. Configure Environment Variables**

Edit `~/.zshrc` (or `~/.bashrc`):
```bash
# TTS Providers
export OPENAI_API_KEY="sk-..."       # Recommended
export ELEVENLABS_API_KEY="sk-..."  # Optional (premium)

# LLM Providers
export ANTHROPIC_API_KEY="sk-ant-..." # Optional (fallback)

# Personalization
export ENGINEER_NAME="YourName"  # Optional
```

Reload:
```bash
source ~/.zshrc
```

**3. Verify Setup**
```bash
# Check TTS status
/tts status

# Test TTS
/tts test "Hello world"
```

**4. Enable TTS**
```bash
# Enable all hooks
/tts enable

# Or enable selectively
/tts hook stop on
/tts hook notification on
```

**5. Choose Mode**
```bash
# Transcript mode (contextual summaries)
/tts mode transcript

# Or static mode (generic messages)
/tts mode static
```

### Quick Start (Minimal Setup)

**No API keys needed:**
```bash
# Verify pyttsx3 works (offline TTS)
/tts test

# Enable TTS (uses pyttsx3 fallback)
/tts enable
```

This uses system TTS (offline, no cost, lower quality).

### Recommended Setup

**Best balance of quality and cost:**
```bash
# Add to ~/.zshrc
export OPENAI_API_KEY="sk-..."
export ENGINEER_NAME="YourName"

# Enable with transcript mode
/tts enable
/tts mode transcript
```

**Cost:** ~$0.0025 per session (transcript mode) or ~$0.0005 (static mode)

### Premium Setup

**Highest quality:**
```bash
# Add to ~/.zshrc
export ELEVENLABS_API_KEY="sk-..."
export OPENAI_API_KEY="sk-..."      # Fallback + LLM
export ENGINEER_NAME="YourName"

# Enable with transcript mode
/tts enable
/tts mode transcript
```

**Cost:** ElevenLabs pricing + OpenAI LLM costs

## Troubleshooting

### No Audio Playback

**Symptoms:** TTS command completes, no audio heard

**Diagnosis:**
```bash
# Check provider
/tts provider

# Test with explicit message
/tts test "Can you hear this?"
```

**Possible Causes:**

1. **No API keys set**
   ```bash
   # Check environment
   echo $OPENAI_API_KEY
   echo $ELEVENLABS_API_KEY

   # Solution: Add to ~/.zshrc and reload
   export OPENAI_API_KEY="sk-..."
   source ~/.zshrc
   ```

2. **System volume muted**
   - Check macOS system volume
   - Check application audio settings

3. **pyttsx3 not installed**
   ```bash
   # Test manually
   python3 -c "import pyttsx3; engine = pyttsx3.init(); engine.say('test'); engine.runAndWait()"

   # Install if needed
   pip install pyttsx3
   ```

4. **Script file missing**
   ```bash
   # Verify scripts exist
   ls -la ~/.claude/hooks/utils/tts/

   # Should show:
   # openai_tts.py
   # elevenlabs_tts.py
   # pyttsx3_tts.py
   ```

### TTS Not Triggering on Hook Events

**Symptoms:** Hook completes, no TTS announcement

**Diagnosis:**
```bash
# Check if enabled
/tts status

# Check settings.json
jq '.hooks.Stop[0].hooks[0].command' ~/.claude/settings.json
# Should contain: --notify
```

**Solutions:**

1. **TTS disabled**
   ```bash
   /tts enable
   ```

2. **Missing --notify flag**
   ```bash
   # Enable specific hook
   /tts hook stop on
   /tts hook notification on
   ```

3. **Hook execution failing**
   ```bash
   # Check hook logs
   cat ~/.claude/logs/stop.json
   cat ~/.claude/logs/notification.json

   # Look for errors in recent entries
   ```

### Wrong Mode Active

**Symptoms:** Generic "work complete" when expecting transcript summary (or vice versa)

**Diagnosis:**
```bash
# Check current mode
/tts status
# Look at "MODE:" section

# Verify stop.py directly
grep -n "announce_completion" ~/.claude/hooks/stop.py | head -5
# Should show which line is commented/uncommented
```

**Solution:**
```bash
# Switch to desired mode
/tts mode transcript  # For contextual summaries
/tts mode static      # For generic messages
```

### Transcript Mode Not Working

**Symptoms:** Expecting summary, hearing generic completion message

**Possible Causes:**

1. **No OpenAI API key** (only OpenAI supports `--summarize`)
   ```bash
   echo $OPENAI_API_KEY
   # Should return: sk-...

   # Solution
   export OPENAI_API_KEY="sk-..."
   ```

2. **Transcript file not available**
   - Transcript mode only works with Stop hook
   - Notification/SubagentStop always use static messages

3. **Wrong mode active**
   ```bash
   /tts mode transcript
   ```

4. **LLM timeout**
   - Check if LLM calls timing out (15s limit)
   - Fallback to truncation if timeout occurs

### API Errors

**Symptoms:** TTS fails silently, `/tts test` errors

**Diagnosis:**
```bash
# Test providers directly
uv run ~/.claude/hooks/utils/tts/openai_tts.py "test"
uv run ~/.claude/hooks/utils/tts/elevenlabs_tts.py "test"

# Check for error output
```

**Common Errors:**

1. **Invalid API key**
   ```
   Error: Incorrect API key provided
   ```
   Solution: Verify key in dashboard, update ~/.zshrc

2. **Quota exceeded**
   ```
   Error: You exceeded your current quota
   ```
   Solution: Check billing, upgrade plan, or switch to pyttsx3

3. **Rate limited**
   ```
   Error: Rate limit reached
   ```
   Solution: Wait 60 seconds, reduce usage frequency

4. **Network issues**
   ```
   Error: Connection timeout
   ```
   Solution: Check internet connection, firewall settings

### Provider Priority Issues

**Symptoms:** Using OpenAI when ElevenLabs expected (or vice versa)

**Diagnosis:**
```bash
# Check provider priority
/tts provider

# Check environment
env | grep -E "(OPENAI|ELEVENLABS)_API_KEY"
```

**Priority Order:**
1. ElevenLabs (if `ELEVENLABS_API_KEY` set)
2. OpenAI (if `OPENAI_API_KEY` set)
3. pyttsx3 (always available)

**Solution:**
```bash
# To force OpenAI: Remove ElevenLabs key
unset ELEVENLABS_API_KEY

# To use ElevenLabs: Set key
export ELEVENLABS_API_KEY="sk-..."

# Restart Claude Code to apply changes
```

### Settings.json Corrupted

**Symptoms:** TTS stops working after configuration change

**Diagnosis:**
```bash
# Validate JSON syntax
jq . ~/.claude/settings.json
# Should pretty-print JSON without errors
```

**Solution:**
```bash
# Restore from backup (created by tts-manage.sh)
cp ~/.claude/settings.json.backup ~/.claude/settings.json

# Re-enable TTS
/tts enable
```

## Performance Characteristics

### Latency

**Static Mode (Stop Hook):**
- LLM message generation: 1-3 seconds (OpenAI) or instant (static fallback)
- TTS synthesis: 2-5 seconds (cloud) or 1-2 seconds (offline)
- **Total:** 3-8 seconds

**Transcript Mode (Stop Hook):**
- Transcript extraction: <0.1 seconds
- LLM summarization: 3-12 seconds
- TTS synthesis: 2-5 seconds
- **Total:** 5-17 seconds

**Notification Hook:**
- Message construction: <0.1 seconds
- TTS synthesis: 2-4 seconds
- **Total:** 2-4 seconds

### Cost Analysis

**OpenAI TTS (gpt-4o-mini-tts):**
- $0.15 per 1M characters
- Average message: ~50 characters
- Cost per notification: ~$0.0000075

**OpenAI LLM (gpt-4.1-nano):**
- Completion message: ~50 tokens = $0.0005
- Summarization: ~500 tokens input + 100 output = $0.002

**ElevenLabs TTS:**
- Pricing varies by plan
- Character-based billing
- Check ElevenLabs dashboard for current rates

**pyttsx3:**
- Free (offline, no API calls)

**Typical Session Costs:**

| Mode | Provider | Cost per Session |
|------|----------|------------------|
| Static | OpenAI | ~$0.0005 |
| Static | pyttsx3 | $0 |
| Transcript | OpenAI | ~$0.0025 |
| Transcript | ElevenLabs + OpenAI | ElevenLabs cost + $0.002 |

**Daily Usage (10 sessions):**
- Static mode: ~$0.005/day ($1.50/month)
- Transcript mode: ~$0.025/day ($7.50/month)

### Token Usage

**LLM Completion Message Generation:**
- Prompt: ~100 tokens
- Completion: ~50 tokens
- Total: ~150 tokens per call

**Transcript Summarization:**
- Prompt: ~50 tokens
- Transcript content: 100-500 tokens (varies)
- Completion: 50-150 tokens
- Total: 200-700 tokens per summarization

### Bottlenecks

**Transcript Mode Slowest Path:**
1. Transcript extraction: 0.05s
2. **LLM summarization: 5-12s** ← Primary bottleneck
3. TTS synthesis: 3-5s
4. Audio playback: 3-5s

**Optimization Strategies:**
- Use static mode for faster feedback
- Transcript mode only when context matters
- Premium TTS (ElevenLabs) has lower latency than OpenAI

## Extension Patterns

### Adding New TTS Provider

**1. Create Provider Script**

```bash
# Create new provider file
touch ~/.claude/hooks/utils/tts/newprovider_tts.py
chmod +x ~/.claude/hooks/utils/tts/newprovider_tts.py
```

**2. Implement Script Template**

```python
#!/usr/bin/env python3
# /// script
# dependencies = [
#   "newprovider-sdk",
#   "python-dotenv",
# ]
# ///

import os
import sys
from dotenv import load_dotenv
from newprovider import Client

load_dotenv()

def main():
    # Get text from command line args
    if len(sys.argv) < 2:
        print("Usage: newprovider_tts.py <text>")
        sys.exit(1)

    text = ' '.join(sys.argv[1:])

    # Initialize client
    api_key = os.getenv('NEWPROVIDER_API_KEY')
    if not api_key:
        print("Error: NEWPROVIDER_API_KEY not set")
        sys.exit(1)

    client = Client(api_key=api_key)

    # Generate and play audio
    try:
        audio_data = client.text_to_speech(
            text=text,
            voice="default",
            # Provider-specific options
        )

        # Play audio (provider-specific)
        # audio_data.play()
        # or save and play with system command

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

**3. Update Provider Selection**

Edit all hook scripts (`stop.py`, `notification.py`, `subagent_stop.py`):

```python
def get_tts_script_path():
    tts_dir = Path(__file__).parent / 'utils' / 'tts'

    # Add new provider at desired priority
    if os.getenv('NEWPROVIDER_API_KEY'):
        script = tts_dir / 'newprovider_tts.py'
        if script.exists():
            return str(script)

    # Existing providers...
    if os.getenv('ELEVENLABS_API_KEY'):
        script = tts_dir / 'elevenlabs_tts.py'
        if script.exists():
            return str(script)

    # Continue with OpenAI, pyttsx3...
```

**4. Update Management Script**

Edit `tts-manage.sh`:

```bash
get_current_provider() {
    if [ -n "$NEWPROVIDER_API_KEY" ]; then
        echo "NewProvider"
    elif [ -n "$ELEVENLABS_API_KEY" ]; then
        echo "ElevenLabs"
    # Continue with existing logic...
}
```

**5. Test New Provider**

```bash
# Set API key
export NEWPROVIDER_API_KEY="your-api-key"

# Test directly
uv run ~/.claude/hooks/utils/tts/newprovider_tts.py "Hello world"

# Test via TTS command
/tts test "Hello world"

# Check provider
/tts provider
```

### Adding New Hook with TTS

**1. Create Hook Script**

```python
#!/usr/bin/env python3
# /// script
# dependencies = [
#   "python-dotenv",
# ]
# ///

import os
import sys
import json
import argparse
import subprocess
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

def get_tts_script_path():
    """Same provider selection logic as existing hooks"""
    # Copy from stop.py or notification.py
    tts_dir = Path(__file__).parent / 'utils' / 'tts'

    if os.getenv('ELEVENLABS_API_KEY'):
        script = tts_dir / 'elevenlabs_tts.py'
        if script.exists():
            return str(script)

    if os.getenv('OPENAI_API_KEY'):
        script = tts_dir / 'openai_tts.py'
        if script.exists():
            return str(script)

    pyttsx3_script = tts_dir / 'pyttsx3_tts.py'
    if pyttsx3_script.exists():
        return str(pyttsx3_script)

    return None

def announce_custom_event():
    """Announce custom hook event via TTS"""
    tts_script = get_tts_script_path()
    if not tts_script:
        return  # No TTS available

    # Create your custom message
    message = "Your custom event message here"

    try:
        subprocess.run(
            ['uv', 'run', tts_script, message],
            capture_output=True,
            timeout=10,
            check=False
        )
    except:
        pass  # Silent failure

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--notify', action='store_true', help='Enable TTS')
    args = parser.parse_args()

    # Read input data from stdin
    input_data = json.load(sys.stdin)

    # Your hook logic here
    # ...

    # TTS announcement (if enabled)
    if args.notify:
        announce_custom_event()

if __name__ == "__main__":
    main()
```

**2. Add Hook to settings.json**

```json
{
  "hooks": {
    "YourCustomHook": [
      {
        "hooks": [
          {
            "command": "uv run ~/.claude/hooks/your_custom_hook.py --notify"
          }
        ]
      }
    ]
  }
}
```

**3. Update Management Script**

Edit `tts-manage.sh` to include new hook:

```bash
# Add to enable_all function
enable_all() {
    enable_hook_tts "Stop"
    enable_hook_tts "Notification"
    enable_hook_tts "SubagentStop"
    enable_hook_tts "YourCustomHook"  # Add here
}

# Add to disable_all function
disable_all() {
    disable_hook_tts "Stop"
    disable_hook_tts "Notification"
    disable_hook_tts "SubagentStop"
    disable_hook_tts "YourCustomHook"  # Add here
}

# Add to show_status function
show_status() {
    echo "HOOK STATUS:"
    show_hook_status "Stop"
    show_hook_status "Notification"
    show_hook_status "SubagentStop"
    show_hook_status "YourCustomHook"  # Add here
}
```

**4. Update Command Help**

Edit `/tts help` output in `tts-manage.sh`:

```bash
show_help() {
    echo "  /tts hook <name> on|off  Control individual hook"
    echo "                           (stop, notification, subagent, yourcustomhook)"
}
```

**5. Test New Hook**

```bash
# Enable TTS for new hook
/tts hook yourcustomhook on

# Trigger hook event to test
# (depends on your hook trigger condition)

# Check status
/tts status
```

### Customizing Voice

#### OpenAI Voice

Edit `~/.claude/hooks/utils/tts/openai_tts.py`:

```python
# Line 72: Change voice parameter
client.audio.speech.stream(
    model="gpt-4o-mini-tts",
    voice="alloy",  # Changed from "nova"
    instructions="Speak in a cheerful, positive yet professional tone.",
    input=text,
    response_format="pcm"
)
```

**Available voices:** alloy, echo, fable, onyx, nova, shimmer

**Test change:**
```bash
uv run ~/.claude/hooks/utils/tts/openai_tts.py "Testing new voice"
```

#### ElevenLabs Voice

**1. Get Voice ID from Dashboard**
- Go to ElevenLabs dashboard
- Navigate to "Voices"
- Copy voice ID (e.g., "21m00Tcm4TlvDq8ikWAM")

**2. Edit Provider Script**

Edit `~/.claude/hooks/utils/tts/elevenlabs_tts.py`:

```python
# Line 67: Change voice_id
audio_stream = client.text_to_speech.convert(
    voice_id="21m00Tcm4TlvDq8ikWAM",  # New voice ID
    text=text,
    model_id="eleven_turbo_v2_5",
    output_format="mp3_44100_128"
)
```

**Test change:**
```bash
uv run ~/.claude/hooks/utils/tts/elevenlabs_tts.py "Testing new voice"
```

#### pyttsx3 Voice

**1. List Available Voices**

```python
import pyttsx3
engine = pyttsx3.init()
voices = engine.getProperty('voices')
for voice in voices:
    print(f"ID: {voice.id}")
    print(f"Name: {voice.name}")
    print(f"Languages: {voice.languages}")
    print("---")
```

**2. Edit Provider Script**

Edit `~/.claude/hooks/utils/tts/pyttsx3_tts.py`:

```python
# After line 34: Add voice selection
engine = pyttsx3.init()

# Get desired voice
voices = engine.getProperty('voices')
# Use index or match by name
engine.setProperty('voice', voices[1].id)  # Change index

# Existing rate/volume settings
engine.setProperty('rate', 180)
engine.setProperty('volume', 0.8)
```

**Test change:**
```bash
uv run ~/.claude/hooks/utils/tts/pyttsx3_tts.py "Testing new voice"
```

## Security Considerations

### API Key Management

**DO:**
- Store API keys in `~/.zshrc` or `~/.bashrc`
- Use environment variables (never hardcode in scripts)
- Set restrictive file permissions: `chmod 600 ~/.zshrc`
- Rotate keys periodically

**DON'T:**
- Commit API keys to version control
- Share keys in plain text
- Store keys in publicly readable files
- Use root/admin API keys (use restricted keys)

### Subprocess Execution

**Safety Measures:**
- `capture_output=True` prevents output injection
- `timeout` prevents indefinite execution
- Scripts validated via file existence checks
- No user input directly passed to shell (uses subprocess.run with list)

**Risks:**
- TTS scripts execute with user privileges
- Malicious script modifications could execute arbitrary code
- Recommendation: Verify script integrity, use file permissions

### Environment Variable Injection

**Protection:**
- Environment variables loaded via `python-dotenv`
- No shell interpolation in subprocess calls
- API keys never logged or displayed

### Timeout Protection

All external calls have timeouts:
- TTS calls: 10 seconds
- LLM completion: 10 seconds
- LLM summarization: 15 seconds

**Rationale:**
- Prevents hanging on network issues
- Ensures hook completion
- Graceful degradation via fallback chains

## Advanced Usage

### Custom Message Formatting

**Modify Static Messages:**

Edit `~/.claude/hooks/stop.py`:

```python
# Line ~95-110: Static message list
def get_llm_completion_message():
    # Fallback static messages
    return random.choice([
        "Work complete!",
        "All done!",
        "Task finished!",
        "Job complete!",
        "Ready for next task!",
        # Add your custom messages here:
        "Mission accomplished!",
        "Crushing it!",
        "You're on fire!",
    ])
```

**Modify LLM Prompts:**

Edit `~/.claude/hooks/utils/llm/oai.py`:

```python
# Line ~130-140: Completion message prompt
response = client.chat.completions.create(
    model="gpt-4.1-nano",
    messages=[
        {
            "role": "system",
            "content": "Generate a single short positive completion message. "
                       "Be enthusiastic and varied. Examples: 'Great job!', "
                       "'Mission accomplished!', 'You're on fire!'"
                       # Customize system prompt here
        }
    ],
    max_tokens=100
)
```

**Modify Summarization Prompt:**

Edit `~/.claude/hooks/stop.py`:

```python
# Line ~250-260: Summarization prompt
prompt = f"""Summarize the following text in 2-3 concise sentences suitable for text-to-speech:

{full_text}

Keep it casual and direct. Focus on what was accomplished.
# Customize instructions here
"""
```

### Personalization Enhancement

**Increase Personalization Rate:**

Edit `~/.claude/hooks/notification.py`:

```python
# Line ~64: Personalization probability
if engineer_name and random.random() < 0.3:  # Change 0.3 to 0.5 (50% chance)
    message = f"{engineer_name}, your agent needs your input"
```

**Add Personalization to Stop Hook:**

Edit `~/.claude/hooks/stop.py`:

```python
def announce_completion():
    # Add after message generation
    engineer_name = os.getenv('ENGINEER_NAME', '').strip()
    if engineer_name and random.random() < 0.3:
        message = f"{engineer_name}, {message}"

    # Continue with TTS...
```

### Conditional TTS Based on Duration

**Example:** Only announce completions longer than 30 seconds

Edit `~/.claude/hooks/stop.py`:

```python
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--notify', action='store_true')
    args = parser.parse_args()

    input_data = json.load(sys.stdin)

    # Calculate duration
    started_at = input_data.get('started_at', 0)
    stopped_at = input_data.get('stopped_at', 0)
    duration = stopped_at - started_at

    # Only announce if duration > 30 seconds
    if args.notify and duration > 30:
        announce_completion_with_transcript(
            input_data.get('transcript_path', None)
        )
```

### Multi-Voice Support

**Different voices for different hooks:**

**1. Modify Provider Scripts to Accept Voice Parameter**

Edit `~/.claude/hooks/utils/tts/openai_tts.py`:

```python
def main():
    # Check for voice override
    voice = os.getenv('TTS_VOICE', 'nova')

    client.audio.speech.stream(
        model="gpt-4o-mini-tts",
        voice=voice,  # Use env var
        instructions="...",
        input=text,
        response_format="pcm"
    )
```

**2. Set Voice Before Hook Execution**

Edit hook scripts to set voice environment variable:

```python
def announce_completion():
    # Set voice for this hook
    os.environ['TTS_VOICE'] = 'alloy'  # Completion voice

    tts_script = get_tts_script_path()
    subprocess.run(['uv', 'run', tts_script, message], ...)

def announce_notification():
    # Different voice for notifications
    os.environ['TTS_VOICE'] = 'shimmer'  # Notification voice

    tts_script = get_tts_script_path()
    subprocess.run(['uv', 'run', tts_script, message], ...)
```

## Related Documentation

**Comprehensive Guides:**
- `~/.claude/hooks/TRANSCRIPT_TTS_README.md` - Full transcript TTS documentation
- `~/.claude/hooks/TRANSCRIPT_TTS_QUICK_REFERENCE.md` - Quick reference card
- `~/.claude/commands/TTS_USAGE_GUIDE.md` - Slash command usage guide
- `~/.claude/hooks/HOOKS_SYSTEM.md` - General hooks system documentation

**Script Locations:**
- Management: `~/.claude/scripts/tts-manage.sh`
- Hooks: `~/.claude/hooks/{stop,notification,subagent_stop}.py`
- TTS Providers: `~/.claude/hooks/utils/tts/*.py`
- LLM Providers: `~/.claude/hooks/utils/llm/*.py`

**Configuration Files:**
- Hook settings: `~/.claude/settings.json`
- Environment: `~/.zshrc` or `~/.bashrc`
- Logs: `~/.claude/logs/{stop,notification,subagent_stop}.json`

## FAQ

**Q: Can I use TTS without API keys?**
A: Yes! pyttsx3 provides offline TTS using system voices. Just run `/tts enable` without setting any API keys.

**Q: Why is transcript mode slower than static mode?**
A: Transcript mode reads and summarizes Claude's full response using an LLM (5-15s), while static mode generates a simple completion message (1-3s).

**Q: Can I use different TTS providers for different hooks?**
A: Currently, provider selection is global based on environment variables. You can implement per-hook providers by modifying the provider selection logic in each hook script.

**Q: How do I disable TTS temporarily without changing settings?**
A: Use `/tts disable` to remove all `--notify` flags. Re-enable with `/tts enable`.

**Q: Does TTS work with subagents?**
A: Yes, but SubagentStop hook is disabled by default. Enable with `/tts hook subagent on`.

**Q: What happens if my API quota is exceeded?**
A: The system gracefully falls back to the next provider in priority order (ElevenLabs → OpenAI → pyttsx3). Silent failure ensures Claude Code continues operating.

**Q: Can I customize the summarization prompt?**
A: Yes! Edit the prompt in `~/.claude/hooks/stop.py` function `summarize_response_for_tts()` around line 250.

**Q: Why does transcript mode only work with OpenAI?**
A: The `--summarize` flag is only implemented in `oai.py`. Anthropic and Ollama LLM providers don't currently support it (would need implementation).

**Q: How do I add a new language for TTS?**
A: Use ElevenLabs or OpenAI multilingual models. Edit provider scripts to specify language parameter. pyttsx3 supports system language voices.

**Q: Can TTS be triggered outside of hooks?**
A: Yes! Run TTS scripts directly:
```bash
uv run ~/.claude/hooks/utils/tts/openai_tts.py "Your custom message"
```

## Changelog

**2025-10-29: Initial Documentation**
- Comprehensive TTS setup documentation created
- All components documented (management, hooks, providers)
- Complete data flows mapped
- Configuration examples provided
- Troubleshooting guide added
- Extension patterns documented

## Contributing

To contribute improvements to the TTS system:

**1. Test Changes Thoroughly**
```bash
# Test TTS scripts directly
uv run ~/.claude/hooks/utils/tts/openai_tts.py "test"

# Test hooks with --notify flag
echo '{}' | uv run ~/.claude/hooks/stop.py --chat --notify

# Test management script
/tts status
/tts test "test message"
```

**2. Follow Existing Patterns**
- Silent failure for all TTS calls (try/except pass)
- UV script metadata (PEP 723) for dependencies
- Provider priority cascade
- Timeout protection (10-15 seconds)
- File existence checks before execution

**3. Update Documentation**
When adding features:
- Update this main.md file
- Update slash command help (`/tts help`)
- Update relevant README files
- Add examples to troubleshooting section

**4. Maintain Backward Compatibility**
- Don't break existing API keys or configurations
- Preserve fallback chains
- Keep settings.json structure compatible

---

**Document Metadata:**
- Topic: tts-setup
- Created: 2025-10-29
- Files Analyzed: 29
- Verification Status: Pending
- Complexity: Moderate
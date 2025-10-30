# Speech-to-Text (STT) Options for Claude Code on macOS with iTerm2

**Research Date:** 2025-10-29
**Focus:** Voice input integration for Claude Code terminal interface

---

## Executive Summary

Three primary approaches emerged for implementing voice input in Claude Code on macOS:

1. **Native macOS Solution:** `hear` command-line tool (free, local, simple)
2. **OpenAI Whisper:** Local or API (free/low-cost, highly accurate, flexible)
3. **Cloud STT APIs:** AssemblyAI, Google Speech-to-Text (paid, production-ready)

**Recommended Approach:** Start with `hear` for proof-of-concept, then upgrade to Whisper local/API for production quality.

---

## 1. macOS Native STT Options

### `hear` - Native Speech Recognition CLI

**Overview:**
- Command-line interface for built-in macOS speech recognition (available since macOS 10.15 Catalina)
- Free, open-source (BSD license), Developer ID signed by Apple
- Supports live microphone input and audio file transcription

**Key Features:**
- Formats: WAV, MP3, AIFF, AAC, CAF, ALAC, etc.
- On-device processing with `-d` flag (no data sent to Apple)
- Without `-d` flag, may use Apple servers (500 character limit)
- Requires macOS 13+ for version 0.6

**Installation:**
```bash
# Download from https://sveinbjorn.org/hear or https://github.com/sveinbjornt/hear
# Binary is ready to use after download
```

**Usage Examples:**
```bash
# Live microphone transcription
hear

# Transcribe audio file
hear audio.mp3

# On-device only (no Apple servers)
hear -d

# Output to file
hear audio.wav > transcript.txt
```

**Pros:**
- Zero cost
- No API keys required
- Native macOS integration
- Simple CLI interface
- Privacy-focused with on-device option

**Cons:**
- macOS 13+ required
- 500 character server limit without `-d` flag
- Limited customization options
- Accuracy depends on macOS speech recognition quality

**Best For:** Quick prototyping, free solution, privacy-sensitive applications

---

## 2. OpenAI Whisper STT

### Whisper Local (Open Source)

**Overview:**
- State-of-the-art speech recognition model by OpenAI
- Trained on 680,000 hours of multilingual data
- Runs entirely on local machine (no internet after setup)
- Supports 99+ languages

**Installation:**
```bash
# Prerequisites
brew install ffmpeg
brew install python@3.10  # or later

# Install Whisper
pip install -U openai-whisper
```

**Usage Examples:**
```bash
# Basic transcription (multiple files)
whisper audio.flac audio.mp3 audio.wav --model turbo

# Different model sizes (tiny, base, small, medium, large, turbo)
whisper audio.mp3 --model medium

# Specify language (faster processing)
whisper audio.mp3 --language English

# Output formats (txt, vtt, srt, json)
whisper audio.mp3 --output_format txt
```

**Model Sizes & Performance:**
| Model  | Size    | Speed    | Accuracy |
|--------|---------|----------|----------|
| tiny   | 39 MB   | Fastest  | Low      |
| base   | 74 MB   | Fast     | Medium   |
| small  | 244 MB  | Moderate | Good     |
| medium | 769 MB  | Slow     | Better   |
| large  | 1550 MB | Slowest  | Best     |
| turbo  | 809 MB  | Fast     | Best     |

**Real-Time Integration:**
For real-time microphone input, use Python with `sounddevice` or `pyaudio`:

```python
import sounddevice as sd
import whisper
import numpy as np

model = whisper.load_model("base")

def transcribe_realtime():
    duration = 5  # seconds
    sample_rate = 16000

    print("Recording...")
    audio = sd.rec(int(duration * sample_rate),
                   samplerate=sample_rate,
                   channels=1,
                   dtype='float32')
    sd.wait()

    audio = audio.flatten()
    result = model.transcribe(audio, fp16=False)
    return result['text']
```

**Pros:**
- Completely free (open source)
- Human-level accuracy
- Excellent noise resilience
- 99+ language support
- Full control and privacy
- No usage limits

**Cons:**
- 1-5s latency (not true real-time)
- Requires GPU for fast processing (CPU works but slower)
- Initial model download required
- Python dependency management

### Whisper API (OpenAI)

**Overview:**
- Cloud-based Whisper access via OpenAI API
- No local setup required
- Faster than local on CPU-only machines

**Pricing:**
- $0.006 per minute ($0.36/hour)
- 10+ hours = ~$3.18
- 25 MB file size limit

**Usage Example:**
```python
from openai import OpenAI
client = OpenAI(api_key="your-api-key")

with open("audio.mp3", "rb") as audio_file:
    transcript = client.audio.transcriptions.create(
        model="whisper-1",
        file=audio_file
    )
print(transcript.text)
```

**Pros:**
- No local setup
- Fast processing
- Automatic updates
- Simple API

**Cons:**
- Requires internet
- Costs per minute
- API key management
- Data sent to OpenAI servers

### whisper.cpp (Optimized Alternative)

**Overview:**
- C/C++ implementation optimized for Apple Silicon
- Faster than Python version on M-series chips
- Lower memory usage

**Installation:**
```bash
# Clone and build
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
make

# Download model
bash ./models/download-ggml-model.sh base.en
```

**Usage:**
```bash
# Transcribe with microphone
./stream -m models/ggml-base.en.bin -t 8 --step 500 --length 5000
```

**Pros:**
- 2-3x faster than Python Whisper on M-series
- Lower memory footprint
- True streaming support
- Optimized for Apple Silicon

**Cons:**
- Requires compilation
- Less Python ecosystem integration
- More complex setup

---

## 3. Third-Party Cloud STT Solutions

### AssemblyAI (Recommended for Production)

**Overview:**
- Modern STT API with low latency
- Universal-2 model with high accuracy
- 30% reduction in hallucination vs Whisper Large-v3
- Easy implementation

**Pricing:**
- Pay-as-you-go: $0.00025/second (~$0.015/minute, $0.90/hour)
- Core plan: $0.00015/second (~$0.009/minute, $0.54/hour)

**Real-Time Streaming:**
```python
import assemblyai as aai

aai.settings.api_key = "your-api-key"

def on_data(transcript: aai.RealtimeTranscript):
    if transcript.text:
        print(transcript.text)

transcriber = aai.RealtimeTranscriber(
    sample_rate=16_000,
    on_data=on_data,
)

transcriber.connect()
# Stream audio chunks
transcriber.close()
```

**Pros:**
- Best accuracy/latency balance for production
- Real-time streaming support
- Speaker diarization, sentiment analysis
- Excellent documentation
- Lower hallucination rate

**Cons:**
- Requires API key and internet
- Cost per second
- Vendor lock-in

### Google Speech-to-Text

**Overview:**
- Google Cloud Platform STT service
- Deep learning neural networks
- Legacy solution

**Pricing:**
- Standard: $0.006/15 seconds (~$1.44/hour)
- Enhanced: $0.009/15 seconds (~$2.16/hour)

**Benchmark Performance:**
- Consistently ranked **last place** in 2025 benchmarks
- Struggles with noisy environments
- Poor accent handling compared to competitors

**Recommendation:** **Not recommended** for new projects unless locked into Google Cloud ecosystem.

**Pros:**
- GCP integration
- Established service
- Multiple language support

**Cons:**
- Lowest accuracy in benchmarks
- Poor noise resilience
- Higher latency
- More expensive than alternatives

### Deepgram

**Overview:**
- Fast, accurate STT with modern API
- Low latency streaming
- Good accuracy

**Pricing:**
- Pay-as-you-go: $0.0043/minute
- Growth plan: $0.0036/minute

**Pros:**
- Very low latency (<300ms)
- Good accuracy
- WebSocket streaming
- Competitive pricing

**Cons:**
- Requires API key
- Less feature-rich than AssemblyAI

---

## 4. Terminal-Based STT Implementation Patterns

### Pattern 1: Simple Shell Script (hear/Whisper)

**Architecture:**
```
Keyboard Shortcut → Shell Script → STT Tool → Output to Claude
```

**Example with `hear`:**
```bash
#!/bin/bash
# /usr/local/bin/claude-voice

# Record and transcribe
text=$(hear -d 2>/dev/null)

# Send to Claude (assuming Claude Code accepts stdin)
echo "$text" | claude-code
```

**iTerm2 Key Binding:**
- Go to: Settings > Keys > Key Bindings
- Add new: Cmd+Shift+V
- Action: "Run Coprocess"
- Command: `/usr/local/bin/claude-voice`

### Pattern 2: Python Microphone Listener

**Architecture:**
```
Python Script → Audio Capture → STT Processing → iTerm2 Input
```

**Implementation:**
```python
#!/usr/bin/env python3
# ~/.claude/scripts/voice-input.py

import sounddevice as sd
import numpy as np
import whisper
import sys

model = whisper.load_model("base")

def listen_and_transcribe(duration=5):
    """Record audio and transcribe"""
    sample_rate = 16000
    audio = sd.rec(int(duration * sample_rate),
                   samplerate=sample_rate,
                   channels=1,
                   dtype='float32')
    sd.wait()

    result = model.transcribe(audio.flatten(), fp16=False)
    return result['text']

if __name__ == "__main__":
    try:
        text = listen_and_transcribe()
        # Output to stdout for iTerm2 to capture
        print(text, end='')
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
```

**Usage:**
```bash
# Make executable
chmod +x ~/.claude/scripts/voice-input.py

# Test
~/.claude/scripts/voice-input.py

# iTerm2 binding
# Settings > Keys > Add: Cmd+Shift+V → Run Coprocess → voice-input.py
```

### Pattern 3: Background Service with Push-to-Talk

**Architecture:**
```
Background Daemon → Monitor Hotkey → Record → Transcribe → Inject Text
```

**Implementation with `pynput` and `whisper`:**
```python
#!/usr/bin/env python3
# ~/.claude/scripts/voice-daemon.py

from pynput import keyboard
import sounddevice as sd
import whisper
import threading
import sys

model = whisper.load_model("base")
recording = False
audio_data = []

def on_press(key):
    global recording, audio_data
    if key == keyboard.Key.f13:  # Or any key combo
        if not recording:
            recording = True
            audio_data = []
            print("🎤 Recording...", file=sys.stderr)
            start_recording()

def on_release(key):
    global recording
    if key == keyboard.Key.f13:
        if recording:
            recording = False
            print("⏹️  Processing...", file=sys.stderr)
            transcribe_and_output()

def start_recording():
    # Implement continuous recording
    pass

def transcribe_and_output():
    # Process audio_data with Whisper
    # Output text to iTerm2
    pass

# Start listener
with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()
```

### Pattern 4: Claude Code Slash Command

**Architecture:**
```
/speak → Trigger Script → Record → Transcribe → Replace Command
```

**Implementation:**
Create custom slash command in Claude Code settings:

```json
{
  "commands": {
    "speak": {
      "command": "~/.claude/scripts/voice-input.sh",
      "description": "Voice input mode"
    }
  }
}
```

**Script:**
```bash
#!/bin/bash
# ~/.claude/scripts/voice-input.sh

echo "🎤 Listening (5 seconds)..."
text=$(hear -d 2>/dev/null)
echo "$text"
```

---

## 5. iTerm2 Integration Capabilities

### Key Bindings (Recommended Approach)

**Configuration Location:** Settings > Keys > Key Bindings

**Action Types:**
1. **Run Coprocess** - Execute script, output appears in terminal
2. **Send Text** - Type text into terminal
3. **Send Hex Code** - Send specific key codes
4. **Invoke Script Function** - Call Python API script

**Example Voice Input Binding:**
- Shortcut: `Cmd+Shift+V`
- Action: `Run Coprocess`
- Command: `/usr/local/bin/claude-voice`

### Shell Integration Features

**Capabilities:**
- Detect when shell is at prompt (enables smart paste)
- Copy output of last command
- Automatic profile switching
- Command history navigation

**Installation:**
```bash
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
```

**Usage with Voice Input:**
- Shell integration can detect prompt state
- Voice input only active when shell ready
- Prevents mid-command interruption

### AppleScript/Python API

**AppleScript Example:**
```applescript
tell application "iTerm2"
    tell current session of current window
        write text "transcribed text here"
    end tell
end tell
```

**Python API Example:**
```python
import iterm2

async def main(connection):
    app = await iterm2.async_get_app(connection)
    window = app.current_terminal_window
    session = window.current_tab.current_session
    await session.async_send_text("transcribed text\n")

iterm2.run_until_complete(main)
```

### Triggers

**Configuration:** Settings > Profiles > Advanced > Triggers

**Use Case:** Automatically respond to voice input patterns
- Detect "run command: X" pattern
- Execute command automatically
- Provide voice feedback

---

## 6. Technical Requirements & Setup

### Audio Capture Libraries

**Option 1: PortAudio + PyAudio**
```bash
brew install portaudio
pip install pyaudio
```

**Usage:**
```python
import pyaudio
import wave

CHUNK = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 16000

p = pyaudio.PyAudio()
stream = p.open(format=FORMAT, channels=CHANNELS,
                rate=RATE, input=True,
                frames_per_buffer=CHUNK)

frames = []
for i in range(0, int(RATE / CHUNK * DURATION)):
    data = stream.read(CHUNK)
    frames.append(data)
```

**Option 2: sounddevice (Recommended)**
```bash
pip install sounddevice numpy
```

**Usage:**
```python
import sounddevice as sd
import numpy as np

# Record 5 seconds
duration = 5
sample_rate = 16000
audio = sd.rec(int(duration * sample_rate),
               samplerate=sample_rate,
               channels=1,
               dtype='float32')
sd.wait()
```

**Pros/Cons:**
- **PyAudio:** More control, complex setup, requires PortAudio
- **sounddevice:** Simpler API, NumPy integration, easier installation

### macOS Permissions

**Microphone Access:**
1. First run will prompt for permission
2. Grant access in System Settings > Privacy & Security > Microphone
3. Check Python/Terminal has microphone access

**Terminal/iTerm2 Permissions:**
```bash
# Test microphone access
python3 -c "import sounddevice; print(sounddevice.query_devices())"
```

### Audio Format Considerations

**Best Practices:**
- Sample rate: 16,000 Hz (standard for STT)
- Bit depth: 16-bit (paInt16)
- Channels: 1 (mono)
- Format: WAV or raw PCM for processing

**Conversion:**
```bash
# Convert any audio to Whisper-friendly format
ffmpeg -i input.mp3 -ar 16000 -ac 1 -c:a pcm_s16le output.wav
```

### Latency Optimization

**Factors Affecting Latency:**
1. Recording buffer size (100-500ms)
2. Model inference time (1-5s for Whisper)
3. Network latency (API-based: 200-1000ms)
4. Audio preprocessing (50-200ms)

**Optimization Strategies:**
- Use smaller Whisper models (tiny/base) for speed
- Use whisper.cpp on Apple Silicon (2-3x faster)
- Use streaming APIs (AssemblyAI real-time)
- Optimize buffer sizes for your use case

---

## 7. Cost Comparison

### Free Options
| Solution | Cost | Notes |
|----------|------|-------|
| `hear` | $0 | macOS native, limited to 500 chars on server |
| Whisper (local) | $0 | Free after setup, requires compute |
| whisper.cpp | $0 | Optimized for M-series |

### Paid API Options (per hour of audio)
| Service | Cost/Hour | Features |
|---------|-----------|----------|
| Whisper API | $0.36 | Simple, accurate |
| AssemblyAI Core | $0.54 | Real-time, low latency |
| AssemblyAI PAYG | $0.90 | Pay as you go |
| Google Standard | $1.44 | Legacy, not recommended |
| Deepgram | ~$0.26 | Very low latency |
| Google Enhanced | $2.16 | Not worth the premium |

### Cost Analysis (1000 hours/year)
| Solution | Annual Cost | Best For |
|----------|-------------|----------|
| Local Whisper | $0 | Budget-conscious, privacy |
| Whisper API | $360 | Simplicity, occasional use |
| AssemblyAI | $540-900 | Production, features |
| Deepgram | $260 | Low latency priority |
| Google | $1440+ | Not recommended |

---

## 8. Accuracy & Performance Comparison (2025 Benchmarks)

### Overall Rankings (January 2025)
1. **Whisper (tied)** - Best noise resilience
2. **Google Gemini (tied)** - Best accent handling
3. **AssemblyAI Universal-2** - Best production balance
4. **AWS Transcribe** - Good all-around
5. **Microsoft Azure** - Struggles with noise
6. **Google Cloud ASR** - Consistently last place

### Specific Use Cases

**Clean Speech:**
- Winner: **Whisper** (lowest WER/MER/WIL)
- Runner-up: **AssemblyAI** (highest cosine similarity)

**Noisy Environments:**
- Winner: **Whisper**
- Good: **AssemblyAI**, **AWS Transcribe**
- Poor: **Google Cloud**, **Microsoft Azure**

**Accented Speech:**
- Winner: **Google Gemini** (clear lead)
- Good: **Whisper**, **AssemblyAI**, **AWS**

**Technical/Specialized Terms:**
- Winner: **Google Gemini** (LLM advantage)
- Good: **Whisper**, **AssemblyAI**

### Hallucination Rates
- **AssemblyAI:** 30% lower than Whisper Large-v3
- **Whisper:** Can hallucinate repeated phrases in silence
- **Google Gemini:** Good with context understanding

---

## 9. Implementation Complexity

### Complexity Tiers

**Tier 1: Simplest (1-2 hours)**
- **Solution:** `hear` command + iTerm2 key binding
- **Setup:** Download binary, create shell script, bind key
- **Code:** ~10 lines of bash
- **Best For:** Quick POC, testing voice input concept

**Tier 2: Simple (2-4 hours)**
- **Solution:** Whisper local + Python script + key binding
- **Setup:** Install dependencies, write Python listener, test
- **Code:** ~50 lines of Python
- **Best For:** Free production solution, privacy-focused

**Tier 3: Moderate (4-8 hours)**
- **Solution:** Whisper API/AssemblyAI + streaming + error handling
- **Setup:** API key management, streaming implementation, fallbacks
- **Code:** ~150 lines of Python
- **Best For:** Production quality, reliability required

**Tier 4: Complex (1-2 days)**
- **Solution:** Background daemon + push-to-talk + multiple STT backends
- **Setup:** Service management, hotkey monitoring, STT orchestration
- **Code:** ~300+ lines of Python
- **Best For:** Power users, advanced features, multiple input modes

---

## 10. Recommended Implementation Strategy

### Phase 1: Proof of Concept (Day 1)

**Goal:** Validate voice input concept with minimal effort

**Approach:**
```bash
# 1. Install hear
brew install sveinbjornt/repo/hear  # or download from GitHub

# 2. Create script
cat > /usr/local/bin/claude-voice << 'EOF'
#!/bin/bash
echo "🎤 Listening..."
hear -d
EOF
chmod +x /usr/local/bin/claude-voice

# 3. Test
claude-voice

# 4. Bind to iTerm2 key (Cmd+Shift+V)
# Settings > Keys > Key Bindings > Add
# Action: Run Coprocess
# Command: /usr/local/bin/claude-voice
```

**Success Criteria:**
- Press hotkey, speak, see transcription
- Latency acceptable (<3 seconds)
- Accuracy good enough for commands

### Phase 2: Production Quality (Week 1)

**Goal:** Reliable voice input with better accuracy

**Option A: Local Whisper (Free)**
```bash
# 1. Setup
brew install ffmpeg python@3.10
pip install openai-whisper sounddevice numpy

# 2. Create script
cat > ~/.claude/scripts/voice-whisper.py << 'EOF'
#!/usr/bin/env python3
import sounddevice as sd
import whisper
import sys

model = whisper.load_model("base")

def record_and_transcribe():
    duration = 5
    sample_rate = 16000
    print("🎤 Recording...", file=sys.stderr)
    audio = sd.rec(int(duration * sample_rate),
                   samplerate=sample_rate,
                   channels=1)
    sd.wait()
    result = model.transcribe(audio.flatten(), fp16=False)
    return result['text']

print(record_and_transcribe())
EOF

chmod +x ~/.claude/scripts/voice-whisper.py

# 3. Test
~/.claude/scripts/voice-whisper.py

# 4. Update iTerm2 binding to use new script
```

**Option B: Whisper API (Paid)**
```python
#!/usr/bin/env python3
import sounddevice as sd
from openai import OpenAI
import tempfile
import wave
import os

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def record_and_transcribe():
    duration = 5
    sample_rate = 16000
    audio = sd.rec(int(duration * sample_rate),
                   samplerate=sample_rate,
                   channels=1,
                   dtype='int16')
    sd.wait()

    # Save to temp file
    with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as f:
        wav_file = wave.open(f.name, 'wb')
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        wav_file.writeframes(audio.tobytes())
        wav_file.close()

        # Transcribe
        with open(f.name, 'rb') as audio_file:
            transcript = client.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file
            )

        os.unlink(f.name)
        return transcript.text

print(record_and_transcribe())
```

### Phase 3: Advanced Features (Optional)

**Features to Add:**
1. **Push-to-talk instead of fixed duration**
   - Hold key to record, release to transcribe
   - More natural interaction

2. **Background noise filtering**
   - Use `noisereduce` library
   - Improve accuracy in noisy environments

3. **Multiple language support**
   - Detect language automatically
   - Switch STT backend based on language

4. **Voice commands**
   - Detect special patterns ("run command X")
   - Execute without typing

5. **Continuous listening mode**
   - Voice-activated wake word
   - Always-on transcription

---

## 11. macOS-Specific Considerations

### System Permissions

**Required Permissions:**
- Microphone access (Privacy & Security)
- Terminal/iTerm2 must be granted microphone
- Accessibility permissions for hotkey monitoring

**Troubleshooting:**
```bash
# Check microphone permission
system_profiler SPAudioDataType

# Test microphone access
python3 -c "import sounddevice; print(sounddevice.query_devices())"
```

### Apple Silicon Optimization

**Whisper.cpp Benefits:**
- 2-3x faster on M-series chips
- Lower memory usage
- Better battery life

**Installation:**
```bash
git clone https://github.com/ggerganov/whisper.cpp
cd whisper.cpp
make
bash ./models/download-ggml-model.sh base.en
```

### Background Service Management

**Option 1: launchd (Recommended)**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude.voice-input</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/python3</string>
        <string>/Users/natedamstra/.claude/scripts/voice-daemon.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
```

**Option 2: Homebrew Services**
```bash
brew services start voice-input
```

### Battery Impact

**Power Consumption:**
- Continuous listening: High battery drain
- Push-to-talk: Minimal impact
- Local Whisper: Medium impact during transcription
- API-based: Low impact (network only)

**Optimization:**
- Use push-to-talk instead of continuous
- Use smaller Whisper models
- Consider API for battery-constrained scenarios

---

## 12. Code Examples & Implementation Patterns

### Complete Implementation: Simple Voice Input

**File: `/usr/local/bin/claude-voice`**
```bash
#!/bin/bash
# Simple voice input using macOS hear command

echo "🎤 Listening for 5 seconds..." >&2
text=$(hear -d 2>/dev/null)

if [ -n "$text" ]; then
    echo "$text"
else
    echo "❌ No speech detected" >&2
    exit 1
fi
```

### Complete Implementation: Whisper-Based Voice Input

**File: `~/.claude/scripts/voice-whisper.py`**
```python
#!/usr/bin/env python3
"""
Voice input for Claude Code using OpenAI Whisper
Requires: pip install openai-whisper sounddevice numpy
"""

import sounddevice as sd
import whisper
import numpy as np
import sys
import signal
import os

# Configuration
DURATION = 5  # seconds
SAMPLE_RATE = 16000
MODEL_SIZE = "base"  # tiny, base, small, medium, large, turbo

# Load model (cached after first run)
model = whisper.load_model(MODEL_SIZE)

def signal_handler(sig, frame):
    """Handle Ctrl+C gracefully"""
    print("\n❌ Cancelled", file=sys.stderr)
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def record_audio(duration=DURATION):
    """Record audio from microphone"""
    print(f"🎤 Recording for {duration} seconds...", file=sys.stderr)

    audio = sd.rec(
        int(duration * SAMPLE_RATE),
        samplerate=SAMPLE_RATE,
        channels=1,
        dtype='float32'
    )
    sd.wait()

    return audio.flatten()

def transcribe_audio(audio):
    """Transcribe audio using Whisper"""
    print("⏳ Transcribing...", file=sys.stderr)

    result = model.transcribe(
        audio,
        fp16=False,  # Required for CPU
        language='en',  # Specify for faster processing
        task='transcribe'
    )

    return result['text'].strip()

def main():
    try:
        # Record audio
        audio = record_audio()

        # Transcribe
        text = transcribe_audio(audio)

        if text:
            # Output to stdout (captured by iTerm2)
            print(text)
        else:
            print("❌ No speech detected", file=sys.stderr)
            sys.exit(1)

    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
```

**Make executable:**
```bash
chmod +x ~/.claude/scripts/voice-whisper.py
```

### Complete Implementation: Push-to-Talk

**File: `~/.claude/scripts/voice-push-to-talk.py`**
```python
#!/usr/bin/env python3
"""
Push-to-talk voice input for Claude Code
Hold F13 key to record, release to transcribe
Requires: pip install pynput sounddevice whisper numpy
"""

from pynput import keyboard
import sounddevice as sd
import whisper
import numpy as np
import threading
import sys
import queue

# Configuration
SAMPLE_RATE = 16000
TRIGGER_KEY = keyboard.Key.f13  # Or use: keyboard.KeyCode.from_char('`')
MODEL_SIZE = "base"

# Global state
model = whisper.load_model(MODEL_SIZE)
recording = False
audio_queue = queue.Queue()
frames = []

def audio_callback(indata, frames_count, time_info, status):
    """Callback for audio stream"""
    if recording:
        audio_queue.put(indata.copy())

def on_press(key):
    """Handle key press"""
    global recording, frames

    if key == TRIGGER_KEY and not recording:
        recording = True
        frames = []
        print("🎤 Recording... (release key to stop)", file=sys.stderr)

def on_release(key):
    """Handle key release"""
    global recording, frames

    if key == TRIGGER_KEY and recording:
        recording = False
        print("⏳ Processing...", file=sys.stderr)

        # Collect all frames
        while not audio_queue.empty():
            frames.append(audio_queue.get())

        if frames:
            # Combine frames
            audio = np.concatenate(frames)

            # Transcribe
            result = model.transcribe(audio, fp16=False, language='en')
            text = result['text'].strip()

            if text:
                print(text)
            else:
                print("❌ No speech detected", file=sys.stderr)

        frames = []

def main():
    print(f"Push-to-talk ready. Press {TRIGGER_KEY} to record.", file=sys.stderr)

    # Start audio stream
    with sd.InputStream(
        callback=audio_callback,
        channels=1,
        samplerate=SAMPLE_RATE,
        dtype='float32'
    ):
        # Start keyboard listener
        with keyboard.Listener(
            on_press=on_press,
            on_release=on_release
        ) as listener:
            listener.join()

if __name__ == "__main__":
    main()
```

### Complete Implementation: Claude Code Slash Command

**Configuration: `~/.claude/settings.json`**
```json
{
  "slashCommands": {
    "voice": {
      "command": "~/.claude/scripts/voice-whisper.py",
      "description": "Voice input (5 seconds)",
      "icon": "🎤"
    },
    "speak": {
      "command": "~/.claude/scripts/voice-whisper.py",
      "description": "Alias for /voice",
      "icon": "🎤"
    }
  }
}
```

**Usage:**
```bash
# In Claude Code terminal
/voice
# Speak for 5 seconds
# Transcription appears and executes
```

---

## 13. Action Items & Next Steps

### Immediate Actions (Today)

1. **Install `hear` for quick testing**
   ```bash
   # Download from https://github.com/sveinbjornt/hear/releases
   # Or: brew install sveinbjornt/repo/hear
   ```

2. **Test basic voice input**
   ```bash
   hear -d
   # Speak: "list files in current directory"
   # Should output: "list files in current directory"
   ```

3. **Create simple iTerm2 binding**
   - Settings > Keys > Key Bindings
   - Add: Cmd+Shift+V → Run Coprocess → `hear -d`

### Week 1: Production Implementation

1. **Choose STT backend**
   - **Free:** Whisper local
   - **Paid but simple:** Whisper API ($0.36/hour)
   - **Production:** AssemblyAI ($0.54/hour)

2. **Implement chosen solution**
   - Install dependencies
   - Create Python script (see examples above)
   - Test thoroughly

3. **Integrate with Claude Code**
   - Update iTerm2 key binding
   - Or create slash command
   - Test in real workflows

### Future Enhancements

1. **Add push-to-talk mode** (more natural than fixed duration)
2. **Implement voice commands** (detect "run command X" patterns)
3. **Add multi-language support** (auto-detect language)
4. **Create background daemon** (always available)
5. **Add wake word detection** (hands-free activation)

---

## 14. Conclusion & Recommendation

### Recommended Approach for Claude Code

**For Proof of Concept:**
- Use `hear` command (macOS native)
- iTerm2 key binding (Cmd+Shift+V)
- Zero cost, minimal setup

**For Production Use:**
- Use Whisper local (free) or Whisper API (cheap)
- Python script with sounddevice
- iTerm2 integration via coprocess

**For Advanced Users:**
- Push-to-talk with pynput
- Background daemon
- Multiple STT backends with fallback

### Why This Recommendation?

1. **hear**: Perfect for testing concept, zero friction
2. **Whisper**: Best accuracy/cost balance, privacy-friendly
3. **Local processing**: No API limits, no recurring costs
4. **iTerm2 native**: Seamless integration, no external tools

### Implementation Timeline

- **Day 1:** Proof of concept with `hear` (1-2 hours)
- **Week 1:** Production Whisper implementation (4-8 hours)
- **Month 1:** Advanced features as needed (optional)

---

## 15. Additional Resources

### Documentation
- `hear` GitHub: https://github.com/sveinbjornt/hear
- Whisper: https://github.com/openai/whisper
- whisper.cpp: https://github.com/ggerganov/whisper.cpp
- iTerm2 Scripting: https://iterm2.com/documentation-scripting.html
- AssemblyAI Docs: https://www.assemblyai.com/docs

### Community Examples
- Whisper macOS integration: Search GitHub for "whisper macos terminal"
- iTerm2 voice control: Search "iterm2 voice commands"
- Push-to-talk implementations: Search "python push to talk microphone"

### Troubleshooting
- Microphone not working: Check System Settings > Privacy > Microphone
- Slow Whisper: Use smaller model (tiny/base) or whisper.cpp
- API rate limits: Implement exponential backoff
- Background noise: Use noisereduce library

---

**Report Generated:** 2025-10-29
**Total Search Queries:** 5/5
**Research Focus:** macOS terminal STT for Claude Code
**Recommended Solution:** `hear` for POC → Whisper local for production
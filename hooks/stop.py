#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "python-dotenv",
# ]
# ///

import argparse
import json
import os
import sys
import random
import subprocess
from pathlib import Path
from datetime import datetime

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass  # dotenv is optional


def get_completion_messages():
    """Return list of friendly completion messages."""
    return [
        "Work complete!",
        "All done!",
        "Task finished!",
        "Job complete!",
        "Ready for next task!"
    ]


def get_tts_script_path():
    """
    Determine which TTS script to use based on available API keys.
    Priority order: ElevenLabs > OpenAI > pyttsx3
    """
    # Get current script directory and construct utils/tts path
    script_dir = Path(__file__).parent
    tts_dir = script_dir / "utils" / "tts"
    
    # Check for ElevenLabs API key (highest priority)
    if os.getenv('ELEVENLABS_API_KEY'):
        elevenlabs_script = tts_dir / "elevenlabs_tts.py"
        if elevenlabs_script.exists():
            return str(elevenlabs_script)
    
    # Check for OpenAI API key (second priority)
    if os.getenv('OPENAI_API_KEY'):
        openai_script = tts_dir / "openai_tts.py"
        if openai_script.exists():
            return str(openai_script)
    
    # Fall back to pyttsx3 (no API key required)
    pyttsx3_script = tts_dir / "pyttsx3_tts.py"
    if pyttsx3_script.exists():
        return str(pyttsx3_script)
    
    return None


def get_llm_completion_message():
    """
    Generate completion message using available LLM services.
    Priority order: OpenAI > Anthropic > Ollama > fallback to random message
    
    Returns:
        str: Generated or fallback completion message
    """
    # Get current script directory and construct utils/llm path
    script_dir = Path(__file__).parent
    llm_dir = script_dir / "utils" / "llm"
    
    # Try OpenAI first (highest priority)
    if os.getenv('OPENAI_API_KEY'):
        oai_script = llm_dir / "oai.py"
        if oai_script.exists():
            try:
                result = subprocess.run([
                    "uv", "run", str(oai_script), "--completion"
                ], 
                capture_output=True,
                text=True,
                timeout=10
                )
                if result.returncode == 0 and result.stdout.strip():
                    return result.stdout.strip()
            except (subprocess.TimeoutExpired, subprocess.SubprocessError):
                pass
    
    # Try Anthropic second
    if os.getenv('ANTHROPIC_API_KEY'):
        anth_script = llm_dir / "anth.py"
        if anth_script.exists():
            try:
                result = subprocess.run([
                    "uv", "run", str(anth_script), "--completion"
                ], 
                capture_output=True,
                text=True,
                timeout=10
                )
                if result.returncode == 0 and result.stdout.strip():
                    return result.stdout.strip()
            except (subprocess.TimeoutExpired, subprocess.SubprocessError):
                pass
    
    # Try Ollama third (local LLM)
    ollama_script = llm_dir / "ollama.py"
    if ollama_script.exists():
        try:
            result = subprocess.run([
                "uv", "run", str(ollama_script), "--completion"
            ], 
            capture_output=True,
            text=True,
            timeout=10
            )
            if result.returncode == 0 and result.stdout.strip():
                return result.stdout.strip()
        except (subprocess.TimeoutExpired, subprocess.SubprocessError):
            pass
    
    # Fallback to random predefined message
    messages = get_completion_messages()
    return random.choice(messages)

# ============================================================================
# NEW FEATURE: Transcript-based TTS (Added 2025-10-29)
# ============================================================================
# This section adds the ability to read the full Claude response transcript
# and summarize it for TTS output, instead of just saying "Work complete!"
#
# To DISABLE this feature and revert to original behavior:
# 1. Comment out the call to announce_completion_with_transcript() on line ~268
# 2. Uncomment the call to announce_completion() on line ~270
# ============================================================================

def extract_last_assistant_response(transcript_path):
    """
    Extract the last assistant message from the transcript.

    Args:
        transcript_path: Path to the .jsonl transcript file

    Returns:
        str: The last assistant response text, or None if not found

    Note: This only extracts 'text' content blocks, ignoring tool_use blocks
    """
    if not transcript_path or not os.path.exists(transcript_path):
        return None

    last_response = None

    try:
        with open(transcript_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue

                try:
                    entry = json.loads(line)

                    # Look for assistant messages
                    if entry.get('role') == 'assistant':
                        content = entry.get('content', [])

                        # Extract only text content (skip tool_use, etc.)
                        text_parts = []
                        for item in content:
                            if isinstance(item, dict) and item.get('type') == 'text':
                                text = item.get('text', '').strip()
                                if text:
                                    text_parts.append(text)

                        # Join all text parts
                        if text_parts:
                            last_response = ' '.join(text_parts)

                except json.JSONDecodeError:
                    continue  # Skip malformed lines

    except Exception:
        pass  # Fail silently, will fall back to default message

    return last_response


def summarize_response_for_tts(full_text):
    """
    Summarize a long assistant response into 2-3 sentences for TTS.

    Args:
        full_text: The full assistant response text

    Returns:
        str: A 2-3 sentence summary suitable for TTS

    Note: Uses LLM services in priority order: OpenAI > Anthropic > Ollama
    If all fail, returns a truncated version of the original text.
    """
    if not full_text:
        return None

    # If response is already short enough, use it directly
    if len(full_text) < 300:
        return full_text

    # Get current script directory and construct utils/llm path
    script_dir = Path(__file__).parent
    llm_dir = script_dir / "utils" / "llm"

    # Prepare summarization prompt
    summary_prompt = f"""Summarize this Claude Code assistant response in 2-3 clear sentences for text-to-speech. Focus on what was accomplished and key outcomes.

Response to summarize:
{full_text[:2000]}  # Limit input to first 2000 chars to avoid token limits

Requirements:
- Maximum 3 sentences
- Focus on actions taken and results
- Use natural spoken language
- No technical jargon unless necessary
- Return ONLY the summary text, no formatting

Summary:"""

    # Try OpenAI first (highest priority)
    if os.getenv('OPENAI_API_KEY'):
        oai_script = llm_dir / "oai.py"
        if oai_script.exists():
            try:
                # Create temp file with prompt
                import tempfile
                with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
                    f.write(summary_prompt)
                    temp_path = f.name

                result = subprocess.run([
                    "uv", "run", str(oai_script), "--summarize", temp_path
                ],
                capture_output=True,
                text=True,
                timeout=15
                )

                # Clean up temp file
                os.unlink(temp_path)

                if result.returncode == 0 and result.stdout.strip():
                    return result.stdout.strip()
            except (subprocess.TimeoutExpired, subprocess.SubprocessError):
                pass

    # Try Anthropic second
    if os.getenv('ANTHROPIC_API_KEY'):
        anth_script = llm_dir / "anth.py"
        if anth_script.exists():
            try:
                import tempfile
                with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
                    f.write(summary_prompt)
                    temp_path = f.name

                result = subprocess.run([
                    "uv", "run", str(anth_script), "--summarize", temp_path
                ],
                capture_output=True,
                text=True,
                timeout=15
                )

                os.unlink(temp_path)

                if result.returncode == 0 and result.stdout.strip():
                    return result.stdout.strip()
            except (subprocess.TimeoutExpired, subprocess.SubprocessError):
                pass

    # Try Ollama third (local LLM)
    ollama_script = llm_dir / "ollama.py"
    if ollama_script.exists():
        try:
            import tempfile
            with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
                f.write(summary_prompt)
                temp_path = f.name

            result = subprocess.run([
                "uv", "run", str(ollama_script), "--summarize", temp_path
            ],
            capture_output=True,
            text=True,
            timeout=15
            )

            os.unlink(temp_path)

            if result.returncode == 0 and result.stdout.strip():
                return result.stdout.strip()
        except (subprocess.TimeoutExpired, subprocess.SubprocessError):
            pass

    # Fallback: Return first 250 characters with ellipsis
    return full_text[:250].strip() + "..."


def announce_completion_with_transcript(transcript_path):
    """
    NEW FUNCTION: Announce completion using transcript summary.

    This replaces announce_completion() when you want to hear what Claude
    actually did instead of just "Work complete!".

    Args:
        transcript_path: Path to the transcript .jsonl file

    Process:
        1. Extract last assistant response from transcript
        2. Summarize it to 2-3 sentences using LLM
        3. Speak the summary via TTS
        4. Fall back to static message if anything fails
    """
    try:
        tts_script = get_tts_script_path()
        if not tts_script:
            return  # No TTS scripts available

        # Try to extract and summarize transcript
        completion_message = None

        if transcript_path:
            # Extract last response
            last_response = extract_last_assistant_response(transcript_path)

            if last_response:
                # Summarize for TTS
                completion_message = summarize_response_for_tts(last_response)

        # Fall back to default completion message if extraction/summarization failed
        if not completion_message:
            completion_message = get_llm_completion_message()

        # Call the TTS script with the completion message
        subprocess.run([
            "uv", "run", tts_script, completion_message
        ],
        capture_output=True,  # Suppress output
        timeout=10  # 10-second timeout
        )

    except (subprocess.TimeoutExpired, subprocess.SubprocessError, FileNotFoundError):
        # Fail silently if TTS encounters issues
        pass
    except Exception:
        # Fail silently for any other errors
        pass


# ============================================================================
# ORIGINAL FUNCTION (Preserved for easy rollback)
# ============================================================================
# This is the original announce_completion() function.
# It's kept here but not called by default when transcript mode is enabled.
# ============================================================================

def announce_completion():
    """Announce completion using the best available TTS service."""
    try:
        tts_script = get_tts_script_path()
        if not tts_script:
            return  # No TTS scripts available

        # Get completion message (LLM-generated or fallback)
        completion_message = get_llm_completion_message()

        # Call the TTS script with the completion message
        subprocess.run([
            "uv", "run", tts_script, completion_message
        ],
        capture_output=True,  # Suppress output
        timeout=10  # 10-second timeout
        )

    except (subprocess.TimeoutExpired, subprocess.SubprocessError, FileNotFoundError):
        # Fail silently if TTS encounters issues
        pass
    except Exception:
        # Fail silently for any other errors
        pass


def main():
    try:
        # Parse command line arguments
        parser = argparse.ArgumentParser()
        parser.add_argument('--chat', action='store_true', help='Copy transcript to chat.json')
        parser.add_argument('--notify', action='store_true', help='Enable TTS completion announcement')
        args = parser.parse_args()
        
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)

        # Extract required fields
        session_id = input_data.get("session_id", "")
        stop_hook_active = input_data.get("stop_hook_active", False)

        # Ensure log directory exists
        log_dir = os.path.join(os.getcwd(), "logs")
        os.makedirs(log_dir, exist_ok=True)
        log_path = os.path.join(log_dir, "stop.json")

        # Read existing log data or initialize empty list
        if os.path.exists(log_path):
            with open(log_path, 'r') as f:
                try:
                    log_data = json.load(f)
                except (json.JSONDecodeError, ValueError):
                    log_data = []
        else:
            log_data = []
        
        # Append new data
        log_data.append(input_data)
        
        # Write back to file with formatting
        with open(log_path, 'w') as f:
            json.dump(log_data, f, indent=2)
        
        # Handle --chat switch
        if args.chat and 'transcript_path' in input_data:
            transcript_path = input_data['transcript_path']
            if os.path.exists(transcript_path):
                # Read .jsonl file and convert to JSON array
                chat_data = []
                try:
                    with open(transcript_path, 'r') as f:
                        for line in f:
                            line = line.strip()
                            if line:
                                try:
                                    chat_data.append(json.loads(line))
                                except json.JSONDecodeError:
                                    pass  # Skip invalid lines
                    
                    # Write to logs/chat.json
                    chat_file = os.path.join(log_dir, 'chat.json')
                    with open(chat_file, 'w') as f:
                        json.dump(chat_data, f, indent=2)
                except Exception:
                    pass  # Fail silently

        # Announce completion via TTS (only if --notify flag is set)
        if args.notify:
            # ============================================================================
            # TRANSCRIPT-BASED TTS (NEW - Added 2025-10-29)
            # ============================================================================
            # Get transcript path from input_data
            transcript_path = input_data.get('transcript_path', None)

            # Call new function that uses transcript summary
            announce_completion_with_transcript(transcript_path)

            # ============================================================================
            # TO REVERT TO ORIGINAL BEHAVIOR:
            # Comment out the above lines and uncomment this:
            # announce_completion()
            # ============================================================================

        sys.exit(0)

    except json.JSONDecodeError:
        # Handle JSON decode errors gracefully
        sys.exit(0)
    except Exception:
        # Handle any other errors gracefully
        sys.exit(0)


if __name__ == "__main__":
    main()

#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "python-dotenv",
# ]
# ///

import json
import os
import sys
from pathlib import Path
from datetime import datetime

try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:
    pass  # dotenv is optional


def log_status_line(input_data, status_line_output, error_message=None):
    """Log status line event to logs directory."""
    # Ensure logs directory exists
    log_dir = Path("logs")
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / "status_line.json"

    # Read existing log data or initialize empty list
    if log_file.exists():
        with open(log_file, "r") as f:
            try:
                log_data = json.load(f)
            except (json.JSONDecodeError, ValueError):
                log_data = []
    else:
        log_data = []

    # Create log entry with input data and generated output
    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "version": "v4",
        "input_data": input_data,
        "status_line_output": status_line_output,
    }

    if error_message:
        log_entry["error"] = error_message

    # Append the log entry
    log_data.append(log_entry)

    # Write back to file with formatting
    with open(log_file, "w") as f:
        json.dump(log_data, f, indent=2)


def get_session_data(session_id):
    """Get session data including agent name, prompts, and extras."""
    session_file = Path(f".claude/data/sessions/{session_id}.json")

    if not session_file.exists():
        return None, f"Session file {session_file} does not exist"

    try:
        with open(session_file, "r") as f:
            session_data = json.load(f)
            return session_data, None
    except Exception as e:
        return None, f"Error reading session file: {str(e)}"


def truncate_prompt(prompt, max_length=75):
    """Truncate prompt to specified length."""
    # Remove newlines and excessive whitespace
    prompt = " ".join(prompt.split())

    if len(prompt) > max_length:
        return prompt[: max_length - 3] + "..."
    return prompt


def get_prompt_icon(prompt):
    """Get icon based on prompt type."""
    if prompt.startswith("/"):
        return "⚡"
    elif "?" in prompt:
        return "❓"
    elif any(
        word in prompt.lower()
        for word in ["create", "write", "add", "implement", "build"]
    ):
        return "💡"
    elif any(word in prompt.lower() for word in ["fix", "debug", "error", "issue"]):
        return "🐛"
    elif any(word in prompt.lower() for word in ["refactor", "improve", "optimize"]):
        return "♻️"
    else:
        return "💬"


def format_extras(extras):
    """Format extras dictionary into a compact string."""
    if not extras:
        return None

    # Format each key-value pair
    pairs = []
    for key, value in extras.items():
        # Truncate value if too long
        str_value = str(value)
        if len(str_value) > 20:
            str_value = str_value[:17] + "..."
        pairs.append(f"{key}:{str_value}")

    return " ".join(pairs)


def get_git_branch():
    """Get the current git branch name."""
    import subprocess

    try:
        # Try to get the current branch using git
        result = subprocess.run(
            ["git", "branch", "--show-current"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=os.getcwd()
        )

        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

        # Fallback: try git symbolic-ref for older git versions
        result = subprocess.run(
            ["git", "symbolic-ref", "--short", "HEAD"],
            capture_output=True,
            text=True,
            timeout=2,
            cwd=os.getcwd()
        )

        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()

        return None

    except (subprocess.TimeoutExpired, FileNotFoundError, Exception):
        # Git not installed, not a git repo, or command timed out
        return None


def calculate_token_usage(transcript_path):
    """Parse transcript and calculate cumulative token usage."""
    from pathlib import Path

    if not transcript_path or not Path(transcript_path).exists():
        return None

    total_tokens = 0

    try:
        with open(transcript_path, 'r') as f:
            for line in f:
                try:
                    entry = json.loads(line)

                    # Only process assistant responses
                    if entry.get('type') != 'assistant':
                        continue

                    usage = entry.get('message', {}).get('usage', {})
                    if not usage:
                        continue

                    # Sum all token types
                    total_tokens += usage.get('input_tokens', 0)
                    total_tokens += usage.get('cache_read_input_tokens', 0)
                    total_tokens += usage.get('output_tokens', 0)

                except json.JSONDecodeError:
                    continue

        return total_tokens if total_tokens > 0 else None

    except Exception:
        return None


def format_token_display(tokens_used, token_budget=200000):
    """Format token usage with color coding."""
    if tokens_used is None:
        return None

    percentage = (tokens_used / token_budget) * 100

    # Color coding based on usage
    if tokens_used >= 190000:  # 95%+
        color = "\033[91m"  # Bright red
    elif tokens_used >= 175000:  # 87.5%+
        color = "\033[33m"  # Orange
    elif tokens_used >= 150000:  # 75%+
        color = "\033[93m"  # Yellow
    else:
        color = "\033[92m"  # Green

    # Format: [142k/200k (71%)]
    tokens_k = f"{tokens_used // 1000}k"
    budget_k = f"{token_budget // 1000}k"
    percentage_str = f"{int(percentage)}%"

    return f"{color}[{tokens_k}/{budget_k} ({percentage_str})]\033[0m"


def generate_status_line(input_data):
    """Generate the status line with agent name, most recent prompt, and extras."""
    # Extract session ID from input data
    session_id = input_data.get("session_id", "unknown")

    # Get model name
    model_info = input_data.get("model", {})
    model_name = model_info.get("display_name", "Claude")

    # Get output style
    output_style_data = input_data.get("output_style", {})
    output_style_name = output_style_data.get("name", None)

    # Get transcript path and calculate token usage
    transcript_path = input_data.get("transcript_path")
    tokens_used = None
    if transcript_path:
        tokens_used = calculate_token_usage(transcript_path)

    # Get session data
    session_data, error = get_session_data(session_id)

    if error:
        # Log the error but show a default message
        parts = [f"\033[36m[{model_name}]\033[0m"]
        if output_style_name:
            parts.append(f"\033[35m[{output_style_name}]\033[0m")
        parts.append("\033[90m💭 No session data\033[0m")
        status_line = " | ".join(parts)
        log_status_line(input_data, status_line, error)
        return status_line

    # Extract agent name, prompts, and extras
    agent_name = session_data.get("agent_name", "Agent")
    prompts = session_data.get("prompts", [])
    extras = session_data.get("extras", {})

    # Build status line components
    parts = []

    # Agent name - Bright Red
    parts.append(f"\033[91m[{agent_name}]\033[0m")

    # Model name - Blue
    parts.append(f"\033[34m[{model_name}]\033[0m")

    # Output style - Magenta
    if output_style_name:
        parts.append(f"\033[35m[{output_style_name}]\033[0m")

    # Most recent prompt
    if prompts:
        current_prompt = prompts[-1]
        icon = get_prompt_icon(current_prompt)
        truncated = truncate_prompt(current_prompt, 100)
        parts.append(f"{icon} \033[97m{truncated}\033[0m")
    else:
        parts.append("\033[90m💭 No prompts yet\033[0m")

    # Add extras if they exist
    if extras:
        extras_str = format_extras(extras)
        if extras_str:
            # Display extras in cyan with brackets
            parts.append(f"\033[36m[{extras_str}]\033[0m")

    # Add token usage if available
    if tokens_used:
        token_display = format_token_display(tokens_used)
        if token_display:
            parts.append(token_display)

    # Join with separator
    status_line = " | ".join(parts)

    return status_line


def main():
    try:
        # Read JSON input from stdin
        input_data = json.loads(sys.stdin.read())

        # Generate status line
        status_line = generate_status_line(input_data)

        # Log the status line event (without error since it's successful)
        log_status_line(input_data, status_line)

        # Output the status line (first line of stdout becomes the status line)
        print(status_line)

        # Success
        sys.exit(0)

    except json.JSONDecodeError:
        # Handle JSON decode errors gracefully - output basic status
        print("\033[31m[Agent] [Claude] 💭 JSON Error\033[0m")
        sys.exit(0)
    except Exception as e:
        # Handle any other errors gracefully - output basic status
        print(f"\033[31m[Agent] [Claude] 💭 Error: {str(e)}\033[0m")
        sys.exit(0)


if __name__ == "__main__":
    main()
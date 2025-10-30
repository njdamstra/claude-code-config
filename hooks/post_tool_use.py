#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# ///

import json
import os
import sys
import subprocess
from pathlib import Path
from datetime import datetime

def track_bash_history(tool_input, tool_result):
    """
    Track Bash commands to separate history file.
    Logs: timestamp, command, output (truncated), exit code
    """
    try:
        log_dir = Path('logs')
        log_dir.mkdir(parents=True, exist_ok=True)
        history_file = log_dir / 'bash_history.json'

        # Read existing history
        if history_file.exists():
            with open(history_file, 'r') as f:
                try:
                    history = json.load(f)
                except (json.JSONDecodeError, ValueError):
                    history = []
        else:
            history = []

        # Extract command info
        command = tool_input.get('command', '')
        output = tool_result.get('output', '')
        exit_code = tool_result.get('exit_code', 0)

        # Truncate large outputs (keep first 1000 chars)
        if len(output) > 1000:
            output = output[:1000] + '\n... (truncated)'

        # Append new command
        history.append({
            'timestamp': datetime.now().isoformat(),
            'command': command,
            'output': output,
            'exit_code': exit_code
        })

        # Write back
        with open(history_file, 'w') as f:
            json.dump(history, f, indent=2)

    except Exception:
        # Silent failure - don't block on tracking errors
        pass

def track_subagent_invocations(tool_input):
    """
    Track Task tool invocations with subagent types.
    Logs: timestamp, subagent_type, prompt
    """
    try:
        subagent_type = tool_input.get('subagent_type')
        if not subagent_type:
            return  # Not a subagent invocation

        log_dir = Path('logs')
        log_dir.mkdir(parents=True, exist_ok=True)
        invocations_file = log_dir / 'subagent_invocations.json'

        # Read existing invocations
        if invocations_file.exists():
            with open(invocations_file, 'r') as f:
                try:
                    invocations = json.load(f)
                except (json.JSONDecodeError, ValueError):
                    invocations = []
        else:
            invocations = []

        # Extract invocation info
        prompt = tool_input.get('prompt', '')

        # Truncate large prompts (keep first 500 chars)
        if len(prompt) > 500:
            prompt = prompt[:500] + '... (truncated)'

        # Append new invocation
        invocations.append({
            'timestamp': datetime.now().isoformat(),
            'subagent_type': subagent_type,
            'prompt': prompt
        })

        # Write back
        with open(invocations_file, 'w') as f:
            json.dump(invocations, f, indent=2)

    except Exception:
        # Silent failure - don't block on tracking errors
        pass

def trigger_session_usage_tracker():
    """Trigger session usage tracker to record metrics."""
    try:
        tracker_script = Path.home() / ".claude" / "hooks" / "session_usage_tracker.py"
        if tracker_script.exists():
            subprocess.run(
                [sys.executable, str(tracker_script)],
                capture_output=True,
                timeout=5
            )
    except Exception:
        pass  # Don't block on tracker errors


def main():
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)

        tool_name = input_data.get('tool_name', '')
        tool_input = input_data.get('tool_input', {})
        tool_result = input_data.get('tool_result', {})

        # === SPECIALIZED TRACKING ===

        # Track Bash commands separately for history analysis
        if tool_name == 'Bash':
            track_bash_history(tool_input, tool_result)

        # Track Task tool (subagent) invocations
        if tool_name == 'Task':
            track_subagent_invocations(tool_input)

        # === GENERAL LOGGING ===

        # Ensure log directory exists
        log_dir = Path.cwd() / 'logs'
        log_dir.mkdir(parents=True, exist_ok=True)
        log_path = log_dir / 'post_tool_use.json'

        # Read existing log data or initialize empty list
        if log_path.exists():
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

        # === SESSION USAGE TRACKING ===

        # Trigger session usage tracker
        trigger_session_usage_tracker()

        sys.exit(0)

    except json.JSONDecodeError:
        # Handle JSON decode errors gracefully
        sys.exit(0)
    except Exception:
        # Exit cleanly on any other error
        sys.exit(0)

if __name__ == '__main__':
    main()
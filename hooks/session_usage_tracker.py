#!/usr/bin/env python3
"""
Session usage tracker hook.

Records session metadata to usage tracking database when assistant completes work.
Triggered by post_tool_use hook to capture elapsed time and token usage.
"""

import os
import sys
import json
from pathlib import Path

# Add status_lines to path for imports
status_lines_dir = Path.home() / ".claude" / "status_lines"
sys.path.insert(0, str(status_lines_dir))

from usage_db import UsageDatabase, calculate_session_duration
from status_line import calculate_token_usage


def record_session_usage():
    """Record current session usage to database."""
    try:
        # Get environment variables
        session_id = os.environ.get('CLAUDE_SESSION_ID')
        transcript_path = os.environ.get('CLAUDE_TRANSCRIPT_PATH')
        project_path = os.environ.get('CLAUDE_PROJECT_PATH', os.getcwd())
        model = os.environ.get('CLAUDE_MODEL', 'claude-sonnet-4-5')

        if not session_id or not transcript_path:
            return

        # Calculate session metrics
        elapsed_seconds = calculate_session_duration(transcript_path)
        weighted_tokens = calculate_token_usage(transcript_path)

        if not elapsed_seconds or elapsed_seconds <= 0:
            return

        # Record to database
        db_path = Path.home() / ".claude" / "data" / "usage_tracking.db"
        db_path.parent.mkdir(parents=True, exist_ok=True)

        db = UsageDatabase(str(db_path))

        # Get session start time from transcript
        start_time = get_session_start_time(transcript_path)

        db.record_session(
            session_id=session_id,
            start_time=start_time,
            elapsed_seconds=elapsed_seconds,
            weighted_tokens=weighted_tokens or 0,
            model=model,
            project_path=project_path
        )

        # Update aggregates
        db.aggregate_current_cycle()
        db.aggregate_current_week()

        db.close()

    except Exception as e:
        # Log errors but don't block
        error_log = Path.home() / ".claude" / "logs" / "usage_tracker_errors.json"
        error_log.parent.mkdir(parents=True, exist_ok=True)

        with open(error_log, 'a') as f:
            import time
            json.dump({
                "timestamp": int(time.time()),
                "error": str(e),
                "session_id": os.environ.get('CLAUDE_SESSION_ID')
            }, f)
            f.write('\n')


def get_session_start_time(transcript_path: str) -> int:
    """Get session start time from first transcript entry."""
    try:
        with open(transcript_path, 'r') as f:
            first_line = f.readline()
            if first_line:
                entry = json.loads(first_line)
                if 'timestamp' in entry:
                    return entry['timestamp']
    except:
        pass

    # Fallback to current time
    import time
    return int(time.time())


if __name__ == '__main__':
    record_session_usage()

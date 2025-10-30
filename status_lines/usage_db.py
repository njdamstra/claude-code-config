import sqlite3
from pathlib import Path
from typing import Optional
import time
import json


class UsageDatabase:
    """SQLite database for tracking Claude Code usage across sessions."""

    def __init__(self, db_path: str):
        """Initialize database and create schema if needed."""
        self.db_path = db_path
        self.conn = sqlite3.connect(db_path)
        self._create_schema()

    def _create_schema(self):
        """Create database schema for usage tracking."""
        cursor = self.conn.cursor()

        # Sessions table: Individual Claude Code sessions
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS sessions (
                session_id TEXT PRIMARY KEY,
                start_time INTEGER NOT NULL,
                end_time INTEGER,
                elapsed_seconds REAL DEFAULT 0,
                weighted_tokens INTEGER DEFAULT 0,
                model TEXT,
                project_path TEXT,
                created_at INTEGER NOT NULL
            )
        """)

        # 5-hour cycles table: Aggregated usage per 5-hour window
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS five_hour_cycles (
                cycle_id TEXT PRIMARY KEY,
                cycle_start INTEGER NOT NULL,
                cycle_end INTEGER NOT NULL,
                total_seconds REAL DEFAULT 0,
                total_tokens INTEGER DEFAULT 0,
                session_count INTEGER DEFAULT 0,
                created_at INTEGER NOT NULL
            )
        """)

        # Weekly aggregates table: Usage per 7-day window
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS weekly_aggregates (
                week_id TEXT PRIMARY KEY,
                week_start INTEGER NOT NULL,
                week_end INTEGER NOT NULL,
                total_seconds REAL DEFAULT 0,
                total_tokens INTEGER DEFAULT 0,
                session_count INTEGER DEFAULT 0,
                created_at INTEGER NOT NULL
            )
        """)

        # Create indices for performance
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_sessions_start ON sessions(start_time)")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_cycles_start ON five_hour_cycles(cycle_start)")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_weekly_start ON weekly_aggregates(week_start)")

        self.conn.commit()

    def record_session(
        self,
        session_id: str,
        start_time: int,
        elapsed_seconds: float,
        weighted_tokens: int,
        model: str,
        project_path: str
    ):
        """
        Record or update session metadata in database.

        Args:
            session_id: Unique session identifier
            start_time: Unix timestamp of session start
            elapsed_seconds: Elapsed active time (assistant working time)
            weighted_tokens: Weighted token count (from calculate_weighted_tokens)
            model: Model name (e.g., "claude-sonnet-4-5")
            project_path: Absolute path to project directory
        """
        cursor = self.conn.cursor()

        created_at = int(time.time())
        end_time = start_time + int(elapsed_seconds)

        # Use INSERT OR REPLACE to update existing sessions
        cursor.execute("""
            INSERT OR REPLACE INTO sessions (
                session_id, start_time, end_time, elapsed_seconds,
                weighted_tokens, model, project_path, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            session_id, start_time, end_time, elapsed_seconds,
            weighted_tokens, model, project_path, created_at
        ))

        self.conn.commit()

    def _get_cycle_id(self, timestamp: int) -> str:
        """Get cycle ID for timestamp."""
        return get_cycle_id(timestamp)

    def aggregate_current_cycle(self):
        """
        Aggregate all sessions in current 5-hour cycle.
        Updates five_hour_cycles table with totals.
        """
        current_time = int(time.time())
        cycle_id = self._get_cycle_id(current_time)
        cycle_start, cycle_end = get_cycle_boundaries(current_time)

        cursor = self.conn.cursor()

        # Sum all sessions in this cycle
        cursor.execute("""
            SELECT
                COALESCE(SUM(elapsed_seconds), 0) as total_seconds,
                COALESCE(SUM(weighted_tokens), 0) as total_tokens,
                COUNT(*) as session_count
            FROM sessions
            WHERE start_time >= ? AND start_time < ?
        """, (cycle_start, cycle_end))

        row = cursor.fetchone()
        total_seconds, total_tokens, session_count = row

        # Insert or update cycle aggregate
        cursor.execute("""
            INSERT OR REPLACE INTO five_hour_cycles (
                cycle_id, cycle_start, cycle_end,
                total_seconds, total_tokens, session_count, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            cycle_id, cycle_start, cycle_end,
            total_seconds, total_tokens, session_count,
            int(time.time())
        ))

        self.conn.commit()

    def aggregate_current_week(self):
        """
        Aggregate all sessions in current 7-day rolling window.
        Updates weekly_aggregates table with totals.
        """
        current_time = int(time.time())
        week_id = get_week_id(current_time)
        week_start, week_end = get_week_boundaries(current_time)

        cursor = self.conn.cursor()

        # Sum all sessions in this 7-day window
        cursor.execute("""
            SELECT
                COALESCE(SUM(elapsed_seconds), 0) as total_seconds,
                COALESCE(SUM(weighted_tokens), 0) as total_tokens,
                COUNT(*) as session_count
            FROM sessions
            WHERE start_time >= ? AND start_time <= ?
        """, (week_start, week_end))

        row = cursor.fetchone()
        total_seconds, total_tokens, session_count = row

        # Insert or update weekly aggregate
        cursor.execute("""
            INSERT OR REPLACE INTO weekly_aggregates (
                week_id, week_start, week_end,
                total_seconds, total_tokens, session_count, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            week_id, week_start, week_end,
            total_seconds, total_tokens, session_count,
            int(time.time())
        ))

        self.conn.commit()

    def close(self):
        """Close database connection."""
        if self.conn:
            self.conn.close()


def get_cycle_id(timestamp: int) -> str:
    """
    Calculate 5-hour cycle ID for given timestamp.

    Claude Code resets rate limits every 5 hours.
    Cycle ID format: "cycle-YYYYMMDD-HH" where HH is the cycle start hour.

    Args:
        timestamp: Unix timestamp

    Returns:
        Cycle ID string
    """
    from datetime import datetime, timezone

    dt = datetime.fromtimestamp(timestamp, tz=timezone.utc)

    # Calculate cycle number (0-4) for the day
    cycle_number = dt.hour // 5
    cycle_start_hour = cycle_number * 5

    return f"cycle-{dt.strftime('%Y%m%d')}-{cycle_start_hour:02d}"


def get_cycle_boundaries(timestamp: int) -> tuple[int, int]:
    """
    Calculate start and end timestamps for 5-hour cycle containing timestamp.

    Args:
        timestamp: Unix timestamp

    Returns:
        (start_timestamp, end_timestamp) tuple
    """
    from datetime import datetime, timezone, timedelta

    dt = datetime.fromtimestamp(timestamp, tz=timezone.utc)

    # Calculate cycle start
    cycle_number = dt.hour // 5
    cycle_start_hour = cycle_number * 5

    cycle_start = dt.replace(hour=cycle_start_hour, minute=0, second=0, microsecond=0)
    cycle_end = cycle_start + timedelta(hours=5)

    return (int(cycle_start.timestamp()), int(cycle_end.timestamp()))


def get_week_id(timestamp: int) -> str:
    """
    Calculate weekly period ID for given timestamp.

    Uses rolling 7-day window ending at current time.
    Week ID format: "week-YYYYMMDD" where date is the end of the week.

    Args:
        timestamp: Unix timestamp

    Returns:
        Week ID string
    """
    from datetime import datetime, timezone

    dt = datetime.fromtimestamp(timestamp, tz=timezone.utc)
    return f"week-{dt.strftime('%Y%m%d')}"


def get_week_boundaries(current_time: int) -> tuple[int, int]:
    """
    Calculate start and end timestamps for 7-day rolling window.

    Window ends at current_time, starts 7 days prior.

    Args:
        current_time: Unix timestamp for end of window

    Returns:
        (start_timestamp, end_timestamp) tuple
    """
    week_seconds = 7 * 24 * 60 * 60  # 604800 seconds
    week_start = current_time - week_seconds

    return (week_start, current_time)


def calculate_session_duration(transcript_path: str) -> Optional[float]:
    """
    Calculate elapsed active time from JSONL transcript.

    Active time = sum of assistant response times (user prompt → assistant completion).
    This excludes user typing time and idle periods.

    Args:
        transcript_path: Path to JSONL transcript file

    Returns:
        Total elapsed seconds of assistant active time, or None if no data
    """
    from pathlib import Path

    if not transcript_path or not Path(transcript_path).exists():
        return None

    total_seconds = 0.0
    last_user_timestamp = None

    try:
        with open(transcript_path, 'r') as f:
            for line in f:
                try:
                    entry = json.loads(line)
                    entry_type = entry.get('type')
                    timestamp = entry.get('timestamp')

                    if not timestamp:
                        continue

                    if entry_type == 'user':
                        # Record when user sent message
                        last_user_timestamp = timestamp

                    elif entry_type == 'assistant' and last_user_timestamp:
                        # Calculate assistant response time
                        response_time = timestamp - last_user_timestamp

                        # Sanity check: response time should be positive and reasonable
                        if 0 < response_time < 3600:  # Max 1 hour per response
                            total_seconds += response_time

                        last_user_timestamp = None

                except json.JSONDecodeError:
                    continue

        return total_seconds if total_seconds > 0 else None

    except Exception:
        return None

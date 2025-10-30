import pytest
import sqlite3
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent))

from usage_db import UsageDatabase


def test_database_schema_creation(tmp_path):
    """Test that database schema is created correctly."""
    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    # Verify database file exists
    assert db_path.exists()

    # Verify tables exist
    conn = sqlite3.connect(str(db_path))
    cursor = conn.cursor()

    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = [row[0] for row in cursor.fetchall()]

    assert "sessions" in tables
    assert "five_hour_cycles" in tables
    assert "weekly_aggregates" in tables

    conn.close()


def test_sessions_table_structure(tmp_path):
    """Test sessions table has correct columns."""
    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    conn = sqlite3.connect(str(db_path))
    cursor = conn.cursor()

    cursor.execute("PRAGMA table_info(sessions)")
    columns = {row[1]: row[2] for row in cursor.fetchall()}

    assert columns["session_id"] == "TEXT"
    assert columns["start_time"] == "INTEGER"
    assert columns["end_time"] == "INTEGER"
    assert columns["elapsed_seconds"] == "REAL"
    assert columns["weighted_tokens"] == "INTEGER"
    assert columns["model"] == "TEXT"
    assert columns["project_path"] == "TEXT"

    conn.close()


def test_calculate_session_duration_from_transcript(tmp_path):
    """Test calculating elapsed active time from JSONL transcript."""
    from usage_db import calculate_session_duration

    # Create test transcript with timestamps
    transcript_file = tmp_path / "test_transcript.jsonl"

    lines = [
        '{"type":"user","message":{"role":"user","content":"Hello"},"timestamp":1699000000}',
        '{"type":"assistant","message":{"role":"assistant","content":"Hi"},"timestamp":1699000015}',  # 15s
        '{"type":"user","message":{"role":"user","content":"Continue"},"timestamp":1699000100}',
        '{"type":"assistant","message":{"role":"assistant","content":"Sure"},"timestamp":1699000125}',  # 25s
        '{"type":"user","message":{"role":"user","content":"More"},"timestamp":1699000200}',
        '{"type":"assistant","message":{"role":"assistant","content":"Done"},"timestamp":1699000245}',  # 45s
    ]

    transcript_file.write_text('\n'.join(lines))

    # Expected: 15 + 25 + 45 = 85 seconds of assistant active time
    result = calculate_session_duration(str(transcript_file))
    assert result == 85.0, f"Expected 85.0, got {result}"


def test_calculate_session_duration_handles_missing_timestamps(tmp_path):
    """Test graceful handling when timestamps are missing."""
    from usage_db import calculate_session_duration

    transcript_file = tmp_path / "test_transcript.jsonl"

    lines = [
        '{"type":"user","message":{"role":"user","content":"Hello"}}',  # No timestamp
        '{"type":"assistant","message":{"role":"assistant","content":"Hi"}}',
    ]

    transcript_file.write_text('\n'.join(lines))

    # Should estimate based on token count or return None
    result = calculate_session_duration(str(transcript_file))
    assert result is None or result >= 0


def test_record_session(tmp_path):
    """Test recording session metadata to database."""
    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    session_id = "test-session-123"
    start_time = 1699000000
    elapsed_seconds = 125.5
    weighted_tokens = 42000

    db.record_session(
        session_id=session_id,
        start_time=start_time,
        elapsed_seconds=elapsed_seconds,
        weighted_tokens=weighted_tokens,
        model="claude-sonnet-4-5",
        project_path="/Users/test/project"
    )

    # Verify session was recorded
    cursor = db.conn.cursor()
    cursor.execute("SELECT * FROM sessions WHERE session_id = ?", (session_id,))
    row = cursor.fetchone()

    assert row is not None
    assert row[0] == session_id  # session_id
    assert row[1] == start_time  # start_time
    assert row[3] == elapsed_seconds  # elapsed_seconds
    assert row[4] == weighted_tokens  # weighted_tokens
    assert row[5] == "claude-sonnet-4-5"  # model

    db.close()


def test_record_session_updates_existing(tmp_path):
    """Test that recording same session_id updates existing record."""
    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    session_id = "test-session-456"

    # First recording
    db.record_session(
        session_id=session_id,
        start_time=1699000000,
        elapsed_seconds=50.0,
        weighted_tokens=10000,
        model="claude-sonnet-4-5",
        project_path="/Users/test/project"
    )

    # Second recording (update)
    db.record_session(
        session_id=session_id,
        start_time=1699000000,
        elapsed_seconds=125.5,  # Updated
        weighted_tokens=42000,  # Updated
        model="claude-sonnet-4-5",
        project_path="/Users/test/project"
    )

    # Verify only one record exists with updated values
    cursor = db.conn.cursor()
    cursor.execute("SELECT COUNT(*) FROM sessions WHERE session_id = ?", (session_id,))
    count = cursor.fetchone()[0]
    assert count == 1

    cursor.execute("SELECT elapsed_seconds, weighted_tokens FROM sessions WHERE session_id = ?", (session_id,))
    row = cursor.fetchone()
    assert row[0] == 125.5
    assert row[1] == 42000

    db.close()


def test_get_current_cycle_id():
    """Test calculation of current 5-hour cycle ID."""
    from usage_db import get_cycle_id

    # Test timestamp: 2025-10-30 14:30:00 UTC
    timestamp = 1730300000

    cycle_id = get_cycle_id(timestamp)

    # Cycle ID should be deterministic for same timestamp
    assert cycle_id is not None
    assert isinstance(cycle_id, str)
    assert "cycle" in cycle_id.lower()


def test_get_cycle_boundaries():
    """Test calculation of 5-hour cycle boundaries."""
    from usage_db import get_cycle_boundaries

    timestamp = 1730300000
    start, end = get_cycle_boundaries(timestamp)

    # Cycle should be exactly 5 hours (18000 seconds)
    assert end - start == 18000

    # Timestamp should be within cycle
    assert start <= timestamp < end


def test_aggregate_cycle_usage(tmp_path):
    """Test aggregating sessions into 5-hour cycles."""
    import time
    from usage_db import get_cycle_boundaries

    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    # Use current time for sessions so they're in the current cycle
    current_time = int(time.time())
    cycle_start, cycle_end = get_cycle_boundaries(current_time)

    # Record multiple sessions in current cycle
    db.record_session("session-1", cycle_start, 50.0, 10000, "claude-sonnet-4-5", "/test/path")
    db.record_session("session-2", cycle_start + 3600, 75.0, 15000, "claude-sonnet-4-5", "/test/path")
    db.record_session("session-3", cycle_start + 7200, 100.0, 20000, "claude-sonnet-4-5", "/test/path")

    # Aggregate into cycle
    db.aggregate_current_cycle()

    # Verify cycle aggregate
    cycle_id = db._get_cycle_id(current_time)
    cursor = db.conn.cursor()
    cursor.execute("SELECT total_seconds, total_tokens, session_count FROM five_hour_cycles WHERE cycle_id = ?", (cycle_id,))
    row = cursor.fetchone()

    assert row is not None
    assert row[0] == 225.0  # 50 + 75 + 100
    assert row[1] == 45000  # 10000 + 15000 + 20000
    assert row[2] == 3

    db.close()


def test_get_week_id():
    """Test calculation of weekly period ID."""
    from usage_db import get_week_id

    timestamp = 1730300000  # 2025-10-30
    week_id = get_week_id(timestamp)

    assert week_id is not None
    assert isinstance(week_id, str)
    assert "week" in week_id.lower()


def test_get_week_boundaries():
    """Test calculation of weekly boundaries (7-day rolling window)."""
    from usage_db import get_week_boundaries

    current_time = 1730300000
    start, end = get_week_boundaries(current_time)

    # Week should be exactly 7 days (604800 seconds)
    assert end - start == 604800

    # Current time should be at the end of the window
    assert abs(end - current_time) < 60  # Within 1 minute


def test_aggregate_weekly_usage(tmp_path):
    """Test aggregating sessions into weekly windows."""
    import time
    from usage_db import get_week_boundaries

    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    current_time = int(time.time())

    # Record sessions over past 7 days
    for days_ago in range(7):
        timestamp = current_time - (days_ago * 86400)
        db.record_session(
            f"session-{days_ago}",
            timestamp,
            50.0 + (days_ago * 10),
            10000 + (days_ago * 1000),
            "claude-sonnet-4-5",
            "/test/path"
        )

    # Aggregate into weekly window
    db.aggregate_current_week()

    # Verify weekly aggregate
    cursor = db.conn.cursor()
    cursor.execute("SELECT total_seconds, total_tokens, session_count FROM weekly_aggregates ORDER BY week_start DESC LIMIT 1")
    row = cursor.fetchone()

    assert row is not None
    # Total: 50+60+70+80+90+100+110 = 560
    assert row[0] == 560.0
    # Total: 10000+11000+12000+13000+14000+15000+16000 = 91000
    assert row[1] == 91000
    assert row[2] == 7

    db.close()

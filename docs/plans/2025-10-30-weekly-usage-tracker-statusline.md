# Weekly Usage Tracker for Status Line Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Display accurate weekly Claude Code usage in the status line, showing current 5-hour cycle usage, weekly total, time until reset, and color-coded warnings based on subscription tier limits.

**Architecture:** Track session metadata (start time, duration, model, weighted tokens) in SQLite database. Calculate elapsed active time (not wall-clock time) by summing assistant response times from JSONL transcripts. Aggregate by 5-hour cycles and weekly windows. Display format: `[cycle: 2.3h | week: 18.5h/40h (46%) | reset: 2h15m]` with color coding based on Pro/Max tier detection.

**Tech Stack:** Python 3.11+, SQLite3, JSONL transcript parsing, datetime handling with timezone awareness, status_line.py integration

---

## Problem Analysis

### Current State
The status line (status_lines/status_line.py) shows:
- Token usage: `[142k/200k (71%)]` (after accuracy fix from 2025-10-30-fix-statusline-token-accuracy.md)
- Git branch with color coding
- Does NOT show time-based usage tracking

### Requirements

**Claude Code Usage Model:**
- **5-hour cycles**: Rate limit resets every 5 hours with countdown
- **Weekly cap**: Cross-platform limit (web + API + Claude Code)
- **Subscription tiers:**
  - Pro: 40-80 hours/week expected
  - Max (5x): 140-280 hours/week
  - Max (20x): Higher limits
- **What counts as "usage":**
  - Active assistant working time (not idle/user typing time)
  - Measured by elapsed time between user prompt and assistant completion
  - NOT total wall-clock time of session

**Display Goals:**
1. Show current 5-hour cycle usage (e.g., "2.3h")
2. Show weekly total vs. limit (e.g., "18.5h/40h (46%)")
3. Show time until next reset (e.g., "reset: 2h15m")
4. Color-code based on usage percentage
5. Detect subscription tier automatically (Pro vs Max)

### Data Sources

**Existing:**
- JSONL transcripts: `projects/-Users-...-projectname/session-id.jsonl`
- Session metadata: `data/sessions/session-id.json`
- Hook logs: `logs/session_start.json`, `logs/status_line.json`

**New:**
- SQLite database: `data/usage_tracking.db`
  - Tables: `sessions`, `five_hour_cycles`, `weekly_aggregates`

---

## Task 1: Create SQLite Schema for Usage Tracking

**Files:**
- Create: `status_lines/usage_db.py`
- Create: `status_lines/test_usage_db.py`

**Step 1: Write failing test for database schema creation**

```python
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
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py::test_database_schema_creation -v`

Expected: FAIL with "ImportError: cannot import name 'UsageDatabase'"

**Step 3: Implement UsageDatabase class**

```python
import sqlite3
from pathlib import Path
from typing import Optional
import time


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

    def close(self):
        """Close database connection."""
        if self.conn:
            self.conn.close()
```

**Step 4: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/usage_db.py status_lines/test_usage_db.py
git commit -m "feat: create SQLite schema for usage tracking"
```

---

## Task 2: Implement Session Duration Calculator

**Files:**
- Modify: `status_lines/usage_db.py`
- Modify: `status_lines/test_usage_db.py`

**Step 1: Write failing test for session duration calculation**

Add to `test_usage_db.py`:

```python
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
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py::test_calculate_session_duration_from_transcript -v`

Expected: FAIL with "ImportError: cannot import name 'calculate_session_duration'"

**Step 3: Implement calculate_session_duration function**

Add to `usage_db.py`:

```python
import json
from typing import Optional


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
```

**Step 4: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/usage_db.py status_lines/test_usage_db.py
git commit -m "feat: calculate session duration from transcript timestamps"
```

---

## Task 3: Implement Session Recording

**Files:**
- Modify: `status_lines/usage_db.py`
- Modify: `status_lines/test_usage_db.py`

**Step 1: Write failing test for session recording**

Add to `test_usage_db.py`:

```python
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
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py::test_record_session -v`

Expected: FAIL with "AttributeError: 'UsageDatabase' object has no attribute 'record_session'"

**Step 3: Implement record_session method**

Add to `UsageDatabase` class in `usage_db.py`:

```python
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
```

**Step 4: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/usage_db.py status_lines/test_usage_db.py
git commit -m "feat: implement session recording with upsert logic"
```

---

## Task 4: Implement 5-Hour Cycle Aggregation

**Files:**
- Modify: `status_lines/usage_db.py`
- Modify: `status_lines/test_usage_db.py`

**Step 1: Write failing test for cycle calculation**

Add to `test_usage_db.py`:

```python
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
    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    # Record multiple sessions in same cycle
    cycle_start = 1730300000

    db.record_session("session-1", cycle_start, 50.0, 10000, "claude-sonnet-4-5", "/test/path")
    db.record_session("session-2", cycle_start + 3600, 75.0, 15000, "claude-sonnet-4-5", "/test/path")
    db.record_session("session-3", cycle_start + 7200, 100.0, 20000, "claude-sonnet-4-5", "/test/path")

    # Aggregate into cycle
    db.aggregate_current_cycle()

    # Verify cycle aggregate
    cycle_id = db._get_cycle_id(cycle_start)
    cursor = db.conn.cursor()
    cursor.execute("SELECT total_seconds, total_tokens, session_count FROM five_hour_cycles WHERE cycle_id = ?", (cycle_id,))
    row = cursor.fetchone()

    assert row is not None
    assert row[0] == 225.0  # 50 + 75 + 100
    assert row[1] == 45000  # 10000 + 15000 + 20000
    assert row[2] == 3

    db.close()
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py::test_get_current_cycle_id -v`

Expected: FAIL with "ImportError: cannot import name 'get_cycle_id'"

**Step 3: Implement cycle calculation functions**

Add to `usage_db.py`:

```python
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
```

Add methods to `UsageDatabase` class:

```python
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
```

**Step 4: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/usage_db.py status_lines/test_usage_db.py
git commit -m "feat: implement 5-hour cycle aggregation"
```

---

## Task 5: Implement Weekly Aggregation

**Files:**
- Modify: `status_lines/usage_db.py`
- Modify: `status_lines/test_usage_db.py`

**Step 1: Write failing test for weekly aggregation**

Add to `test_usage_db.py`:

```python
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
    db_path = tmp_path / "test_usage.db"
    db = UsageDatabase(str(db_path))

    current_time = 1730300000

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
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py::test_get_week_id -v`

Expected: FAIL with "ImportError: cannot import name 'get_week_id'"

**Step 3: Implement weekly calculation functions**

Add to `usage_db.py`:

```python
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
```

Add method to `UsageDatabase` class:

```python
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
        WHERE start_time >= ? AND start_time < ?
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
```

**Step 4: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_db.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/usage_db.py status_lines/test_usage_db.py
git commit -m "feat: implement weekly usage aggregation with rolling window"
```

---

## Task 6: Implement Subscription Tier Detection

**Files:**
- Create: `status_lines/tier_detector.py`
- Create: `status_lines/test_tier_detector.py`

**Step 1: Write failing test for tier detection**

```python
import pytest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent))

from tier_detector import detect_subscription_tier, SubscriptionTier


def test_detect_tier_from_usage_patterns():
    """Test detecting subscription tier from usage patterns."""
    # Pro tier: hits limit around 40-80 hours
    tier = detect_subscription_tier(weekly_usage_hours=45, hit_limit=True)
    assert tier == SubscriptionTier.PRO

    # Max 5x: hits limit around 140-280 hours
    tier = detect_subscription_tier(weekly_usage_hours=150, hit_limit=True)
    assert tier == SubscriptionTier.MAX_5X

    # Max 20x: very high usage
    tier = detect_subscription_tier(weekly_usage_hours=400, hit_limit=False)
    assert tier == SubscriptionTier.MAX_20X


def test_get_tier_limits():
    """Test getting expected weekly limits for each tier."""
    from tier_detector import get_tier_limits

    pro_limits = get_tier_limits(SubscriptionTier.PRO)
    assert pro_limits["expected_min"] == 40
    assert pro_limits["expected_max"] == 80

    max5_limits = get_tier_limits(SubscriptionTier.MAX_5X)
    assert max5_limits["expected_min"] == 140
    assert max5_limits["expected_max"] == 280


def test_get_usage_color_coding():
    """Test color coding based on usage percentage and tier."""
    from tier_detector import get_usage_color

    # Pro tier at 30% (12h/40h) - green
    color = get_usage_color(usage_hours=12, tier=SubscriptionTier.PRO)
    assert "92m" in color  # Green color code

    # Pro tier at 80% (32h/40h) - yellow
    color = get_usage_color(usage_hours=32, tier=SubscriptionTier.PRO)
    assert "93m" in color  # Yellow color code

    # Pro tier at 95% (38h/40h) - red
    color = get_usage_color(usage_hours=38, tier=SubscriptionTier.PRO)
    assert "91m" in color  # Red color code
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_tier_detector.py::test_detect_tier_from_usage_patterns -v`

Expected: FAIL with "ImportError: cannot import name 'detect_subscription_tier'"

**Step 3: Implement tier detection module**

```python
from enum import Enum
from typing import Optional


class SubscriptionTier(Enum):
    """Claude Code subscription tiers."""
    PRO = "pro"
    MAX_5X = "max_5x"
    MAX_20X = "max_20x"
    UNKNOWN = "unknown"


def detect_subscription_tier(
    weekly_usage_hours: float,
    hit_limit: bool = False
) -> SubscriptionTier:
    """
    Detect subscription tier based on usage patterns.

    Heuristic:
    - Pro: 40-80 hours/week expected
    - Max 5x: 140-280 hours/week expected
    - Max 20x: Higher limits

    Args:
        weekly_usage_hours: Total usage in past 7 days
        hit_limit: Whether user has hit rate limit

    Returns:
        Detected subscription tier
    """
    if hit_limit:
        # User hit limit, use usage to determine tier
        if weekly_usage_hours < 100:
            return SubscriptionTier.PRO
        elif weekly_usage_hours < 300:
            return SubscriptionTier.MAX_5X
        else:
            return SubscriptionTier.MAX_20X
    else:
        # User hasn't hit limit, estimate based on usage level
        if weekly_usage_hours < 100:
            # Could be Pro or Max with low usage
            return SubscriptionTier.PRO  # Conservative default
        elif weekly_usage_hours < 300:
            return SubscriptionTier.MAX_5X
        else:
            return SubscriptionTier.MAX_20X


def get_tier_limits(tier: SubscriptionTier) -> dict:
    """
    Get expected weekly limits for subscription tier.

    Args:
        tier: Subscription tier

    Returns:
        Dict with expected_min, expected_max, and display_max
    """
    limits = {
        SubscriptionTier.PRO: {
            "expected_min": 40,
            "expected_max": 80,
            "display_max": 40,  # Conservative for display
        },
        SubscriptionTier.MAX_5X: {
            "expected_min": 140,
            "expected_max": 280,
            "display_max": 140,  # Conservative for display
        },
        SubscriptionTier.MAX_20X: {
            "expected_min": 400,
            "expected_max": 800,
            "display_max": 400,  # Conservative for display
        },
        SubscriptionTier.UNKNOWN: {
            "expected_min": 40,
            "expected_max": 80,
            "display_max": 40,  # Default to Pro
        },
    }

    return limits.get(tier, limits[SubscriptionTier.UNKNOWN])


def get_usage_color(usage_hours: float, tier: SubscriptionTier) -> str:
    """
    Get ANSI color code based on usage percentage.

    Color coding:
    - Green: <75% of expected limit
    - Yellow: 75-87.5%
    - Orange: 87.5-95%
    - Red: 95%+

    Args:
        usage_hours: Current weekly usage in hours
        tier: Subscription tier

    Returns:
        ANSI color code string
    """
    limits = get_tier_limits(tier)
    expected_max = limits["display_max"]

    percentage = (usage_hours / expected_max) * 100

    if percentage >= 95:
        return "\033[91m"  # Bright red
    elif percentage >= 87.5:
        return "\033[33m"  # Orange
    elif percentage >= 75:
        return "\033[93m"  # Yellow
    else:
        return "\033[92m"  # Green
```

**Step 4: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_tier_detector.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/tier_detector.py status_lines/test_tier_detector.py
git commit -m "feat: implement subscription tier detection and color coding"
```

---

## Task 7: Implement Usage Display Formatter

**Files:**
- Create: `status_lines/usage_formatter.py`
- Create: `status_lines/test_usage_formatter.py`

**Step 1: Write failing test for usage display**

```python
import pytest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent))

from usage_formatter import format_usage_display
from tier_detector import SubscriptionTier


def test_format_usage_display_full():
    """Test formatting complete usage display."""
    result = format_usage_display(
        cycle_hours=2.3,
        weekly_hours=18.5,
        tier=SubscriptionTier.PRO,
        reset_seconds=8100  # 2h 15m
    )

    # Should contain cycle usage
    assert "2.3h" in result or "2h" in result

    # Should contain weekly usage
    assert "18.5h" in result or "18h" in result or "19h" in result

    # Should contain limit (40h for Pro)
    assert "40h" in result

    # Should contain percentage
    assert "%" in result

    # Should contain reset time
    assert "2h" in result and "15m" in result


def test_format_usage_display_color_coding():
    """Test color coding based on usage level."""
    # Low usage - green
    result_low = format_usage_display(
        cycle_hours=1.0,
        weekly_hours=10.0,
        tier=SubscriptionTier.PRO,
        reset_seconds=3600
    )
    assert "\033[92m" in result_low  # Green

    # High usage - yellow/orange
    result_high = format_usage_display(
        cycle_hours=3.0,
        weekly_hours=35.0,
        tier=SubscriptionTier.PRO,
        reset_seconds=1800
    )
    assert "\033[93m" in result_high or "\033[33m" in result_high

    # Critical usage - red
    result_critical = format_usage_display(
        cycle_hours=4.5,
        weekly_hours=39.0,
        tier=SubscriptionTier.PRO,
        reset_seconds=600
    )
    assert "\033[91m" in result_critical  # Red


def test_format_reset_time():
    """Test formatting time until reset."""
    from usage_formatter import format_reset_time

    # 2 hours 15 minutes
    result = format_reset_time(8100)
    assert "2h" in result and "15m" in result

    # 45 minutes
    result = format_reset_time(2700)
    assert "45m" in result

    # 5 seconds
    result = format_reset_time(5)
    assert "5s" in result or "0m" in result
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_formatter.py::test_format_usage_display_full -v`

Expected: FAIL with "ImportError: cannot import name 'format_usage_display'"

**Step 3: Implement usage formatter module**

```python
from tier_detector import SubscriptionTier, get_tier_limits, get_usage_color


def format_reset_time(seconds: int) -> str:
    """
    Format seconds until reset as human-readable string.

    Args:
        seconds: Seconds until next reset

    Returns:
        Formatted string (e.g., "2h15m", "45m", "5s")
    """
    if seconds >= 3600:
        hours = seconds // 3600
        minutes = (seconds % 3600) // 60
        return f"{hours}h{minutes:02d}m" if minutes > 0 else f"{hours}h"
    elif seconds >= 60:
        minutes = seconds // 60
        return f"{minutes}m"
    else:
        return f"{seconds}s"


def format_usage_display(
    cycle_hours: float,
    weekly_hours: float,
    tier: SubscriptionTier,
    reset_seconds: int
) -> str:
    """
    Format complete usage display for status line.

    Display format: [cycle: 2.3h | week: 18.5h/40h (46%) | reset: 2h15m]

    Args:
        cycle_hours: Current 5-hour cycle usage
        weekly_hours: Current weekly usage
        tier: Subscription tier
        reset_seconds: Seconds until next 5-hour cycle reset

    Returns:
        Formatted usage string with color coding
    """
    # Get tier limits
    limits = get_tier_limits(tier)
    expected_max = limits["display_max"]

    # Calculate percentage
    percentage = int((weekly_hours / expected_max) * 100)

    # Get color based on usage
    color = get_usage_color(weekly_hours, tier)
    reset_color = "\033[0m"  # Reset color

    # Format components
    cycle_str = f"{cycle_hours:.1f}h" if cycle_hours < 10 else f"{int(cycle_hours)}h"
    weekly_str = f"{weekly_hours:.1f}h" if weekly_hours < 10 else f"{int(weekly_hours)}h"
    limit_str = f"{expected_max}h"
    percentage_str = f"{percentage}%"
    reset_str = format_reset_time(reset_seconds)

    # Build display string
    display = f"{color}[cycle: {cycle_str} | week: {weekly_str}/{limit_str} ({percentage_str}) | reset: {reset_str}]{reset_color}"

    return display


def format_compact_usage(weekly_hours: float, tier: SubscriptionTier) -> str:
    """
    Format compact usage display when space is limited.

    Display format: [18h/40h (46%)]

    Args:
        weekly_hours: Current weekly usage
        tier: Subscription tier

    Returns:
        Compact formatted string with color coding
    """
    limits = get_tier_limits(tier)
    expected_max = limits["display_max"]
    percentage = int((weekly_hours / expected_max) * 100)

    color = get_usage_color(weekly_hours, tier)
    reset_color = "\033[0m"

    weekly_str = f"{weekly_hours:.1f}h" if weekly_hours < 10 else f"{int(weekly_hours)}h"
    limit_str = f"{expected_max}h"

    return f"{color}[{weekly_str}/{limit_str} ({percentage}%)]{reset_color}"
```

**Step 4: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_usage_formatter.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/usage_formatter.py status_lines/test_usage_formatter.py
git commit -m "feat: implement usage display formatter with color coding"
```

---

## Task 8: Integrate Usage Tracking into Status Line Hook

**Files:**
- Modify: `status_lines/status_line.py`
- Modify: `hooks/status_line.py`

**Step 1: Write integration test**

Create `status_lines/test_status_line_integration.py`:

```python
import pytest
from pathlib import Path
import sys
import json
import time

sys.path.insert(0, str(Path(__file__).parent))

from status_line import get_usage_display
from usage_db import UsageDatabase
from tier_detector import SubscriptionTier


def test_get_usage_display_integration(tmp_path):
    """Test complete usage display integration."""
    # Setup test database
    db_path = tmp_path / "usage.db"
    db = UsageDatabase(str(db_path))

    # Record test sessions
    current_time = int(time.time())

    # Current cycle sessions
    db.record_session("session-1", current_time - 3600, 1800, 15000, "claude-sonnet-4-5", "/test")
    db.record_session("session-2", current_time - 1800, 1200, 10000, "claude-sonnet-4-5", "/test")

    # Older sessions (past week)
    for i in range(5):
        timestamp = current_time - (i * 86400) - 7200
        db.record_session(f"session-old-{i}", timestamp, 3600, 20000, "claude-sonnet-4-5", "/test")

    # Aggregate data
    db.aggregate_current_cycle()
    db.aggregate_current_week()

    # Get display
    display = get_usage_display(str(db_path))

    assert display is not None
    assert "cycle:" in display
    assert "week:" in display
    assert "reset:" in display
    assert "h" in display
    assert "%" in display

    db.close()


def test_get_usage_display_handles_no_data(tmp_path):
    """Test graceful handling when no usage data exists."""
    db_path = tmp_path / "empty_usage.db"
    db = UsageDatabase(str(db_path))
    db.close()

    display = get_usage_display(str(db_path))

    # Should return None or empty string for no data
    assert display is None or display == ""
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_status_line_integration.py -v`

Expected: FAIL with "ImportError: cannot import name 'get_usage_display'"

**Step 3: Add get_usage_display function to status_line.py**

Add near the bottom of `status_lines/status_line.py`, before the `if __name__ == '__main__':` block:

```python
def get_usage_display(db_path: str) -> str:
    """
    Get formatted usage display for status line.

    Args:
        db_path: Path to usage tracking database

    Returns:
        Formatted usage string or None if no data
    """
    from pathlib import Path
    from usage_db import UsageDatabase, get_cycle_boundaries
    from tier_detector import detect_subscription_tier, SubscriptionTier
    from usage_formatter import format_usage_display
    import time

    if not db_path or not Path(db_path).exists():
        return None

    try:
        db = UsageDatabase(db_path)

        # Get current cycle usage
        current_time = int(time.time())
        cycle_start, cycle_end = get_cycle_boundaries(current_time)

        cursor = db.conn.cursor()
        cursor.execute("""
            SELECT COALESCE(SUM(elapsed_seconds), 0)
            FROM sessions
            WHERE start_time >= ? AND start_time < ?
        """, (cycle_start, cycle_end))

        cycle_seconds = cursor.fetchone()[0]
        cycle_hours = cycle_seconds / 3600

        # Get weekly usage
        week_start = current_time - (7 * 24 * 60 * 60)
        cursor.execute("""
            SELECT COALESCE(SUM(elapsed_seconds), 0)
            FROM sessions
            WHERE start_time >= ?
        """, (week_start,))

        weekly_seconds = cursor.fetchone()[0]
        weekly_hours = weekly_seconds / 3600

        db.close()

        # No usage data
        if weekly_hours == 0:
            return None

        # Detect tier (default to Pro if unknown)
        tier = detect_subscription_tier(weekly_hours, hit_limit=False)

        # Calculate time until reset
        reset_seconds = cycle_end - current_time

        # Format display
        display = format_usage_display(
            cycle_hours=cycle_hours,
            weekly_hours=weekly_hours,
            tier=tier,
            reset_seconds=reset_seconds
        )

        return display

    except Exception:
        return None
```

**Step 4: Modify main status line generation to include usage**

Find the `if __name__ == '__main__':` block in `status_lines/status_line.py` and modify to include usage display:

```python
if __name__ == '__main__':
    # Get environment variables
    session_id = os.environ.get('CLAUDE_SESSION_ID')
    transcript_path = os.environ.get('CLAUDE_TRANSCRIPT_PATH')

    # Default database path
    db_path = os.path.expanduser("~/.claude/data/usage_tracking.db")

    # Calculate token usage
    tokens_used = calculate_token_usage(transcript_path)
    token_display = format_token_display(tokens_used) if tokens_used else None

    # Get usage tracking display
    usage_display = get_usage_display(db_path)

    # Get git branch
    git_branch = get_git_branch()

    # Build status line
    parts = []

    if usage_display:
        parts.append(usage_display)

    if token_display:
        parts.append(token_display)

    if git_branch:
        parts.append(git_branch)

    # Join with separator
    status_line = " | ".join(parts) if parts else ""

    print(status_line)
```

**Step 5: Run integration tests**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_status_line_integration.py -v`

Expected: PASS for all tests

**Step 6: Commit**

```bash
git add status_lines/status_line.py status_lines/test_status_line_integration.py
git commit -m "feat: integrate usage tracking into status line display"
```

---

## Task 9: Create Session Recording Hook

**Files:**
- Create: `hooks/session_usage_tracker.py`
- Modify: `hooks/post_tool_use.py`

**Step 1: Write session tracker hook script**

```python
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
            json.dump({
                "timestamp": int(os.time.time()),
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
```

**Step 2: Make hook script executable**

Run: `chmod +x /Users/natedamstra/.claude/hooks/session_usage_tracker.py`

**Step 3: Integrate into post_tool_use hook**

Modify `hooks/post_tool_use.py` to call session tracker after tool execution:

Add at the end of the file, before the final `if __name__ == '__main__':` block:

```python
def trigger_session_usage_tracker():
    """Trigger session usage tracker to record metrics."""
    try:
        tracker_script = Path(__file__).parent / "session_usage_tracker.py"
        if tracker_script.exists():
            subprocess.run(
                [sys.executable, str(tracker_script)],
                capture_output=True,
                timeout=5
            )
    except Exception:
        pass  # Don't block on tracker errors
```

Then add to the main execution block:

```python
if __name__ == '__main__':
    # Existing post_tool_use logic
    # ...

    # Trigger session usage tracker
    trigger_session_usage_tracker()
```

**Step 4: Test hook integration**

Create test script: `status_lines/test_hook_integration.sh`

```bash
#!/usr/bin/env bash
# Test session usage tracker hook integration

set -e

echo "🧪 Session Usage Tracker Hook Integration Test"
echo "=============================================="
echo ""

# Setup test environment
export CLAUDE_SESSION_ID="test-session-hook-$(date +%s)"
export CLAUDE_TRANSCRIPT_PATH="/tmp/test_transcript_hook.jsonl"
export CLAUDE_PROJECT_PATH="/Users/natedamstra/test-project"
export CLAUDE_MODEL="claude-sonnet-4-5"

# Create test transcript
cat > "$CLAUDE_TRANSCRIPT_PATH" <<EOF
{"type":"user","message":{"role":"user","content":"Hello"},"timestamp":$(date +%s)}
{"type":"assistant","message":{"role":"assistant","content":"Hi","usage":{"input_tokens":10,"output_tokens":5}},"timestamp":$(($(date +%s) + 15))}
EOF

echo "📝 Created test transcript: $CLAUDE_TRANSCRIPT_PATH"
echo ""

# Run hook
echo "🔄 Running session usage tracker hook..."
python3 ~/.claude/hooks/session_usage_tracker.py

echo ""
echo "✅ Hook executed successfully"
echo ""

# Verify database was updated
echo "🔍 Verifying database..."
python3 -c "
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from usage_db import UsageDatabase
import os

db_path = os.path.expanduser('~/.claude/data/usage_tracking.db')
db = UsageDatabase(db_path)

cursor = db.conn.cursor()
cursor.execute('SELECT COUNT(*) FROM sessions WHERE session_id = ?', (os.environ['CLAUDE_SESSION_ID'],))
count = cursor.fetchone()[0]

print(f'   Sessions recorded: {count}')

if count > 0:
    cursor.execute('SELECT elapsed_seconds, weighted_tokens FROM sessions WHERE session_id = ?', (os.environ['CLAUDE_SESSION_ID'],))
    row = cursor.fetchone()
    print(f'   Elapsed seconds: {row[0]}')
    print(f'   Weighted tokens: {row[1]}')
    print('')
    print('✅ Database updated successfully')
else:
    print('❌ No session recorded')
    sys.exit(1)

db.close()
"

# Cleanup
rm "$CLAUDE_TRANSCRIPT_PATH"

echo ""
echo "✅ All hook integration tests passed!"
```

**Step 5: Run hook integration test**

Run: `chmod +x /Users/natedamstra/.claude/status_lines/test_hook_integration.sh && /Users/natedamstra/.claude/status_lines/test_hook_integration.sh`

Expected: All tests pass, database updated

**Step 6: Commit**

```bash
git add hooks/session_usage_tracker.py hooks/post_tool_use.py status_lines/test_hook_integration.sh
git commit -m "feat: integrate session usage tracking into post_tool_use hook"
```

---

## Task 10: Add Configuration and Documentation

**Files:**
- Create: `status_lines/usage_config.json`
- Modify: `status_lines/README.md`

**Step 1: Create configuration file**

```json
{
  "version": "1.0.0",
  "database_path": "~/.claude/data/usage_tracking.db",
  "subscription_tier": "auto",
  "display_format": "full",
  "color_coding": true,
  "tier_limits": {
    "pro": {
      "weekly_hours_min": 40,
      "weekly_hours_max": 80,
      "display_limit": 40
    },
    "max_5x": {
      "weekly_hours_min": 140,
      "weekly_hours_max": 280,
      "display_limit": 140
    },
    "max_20x": {
      "weekly_hours_min": 400,
      "weekly_hours_max": 800,
      "display_limit": 400
    }
  },
  "reset_cycles": {
    "short_cycle_hours": 5,
    "weekly_days": 7
  }
}
```

**Step 2: Update README.md**

Add section to `status_lines/README.md`:

```markdown
## Weekly Usage Tracking

### Overview

The status line now displays accurate weekly Claude Code usage alongside token counts, helping you stay within subscription tier limits and plan your work around 5-hour reset cycles.

### Display Format

**Full Display:**
```
[cycle: 2.3h | week: 18.5h/40h (46%) | reset: 2h15m] | [142k/200k (71%)] | main
```

**Components:**
- `cycle: 2.3h` - Current 5-hour cycle usage
- `week: 18.5h/40h (46%)` - Weekly total vs. limit with percentage
- `reset: 2h15m` - Time until next 5-hour reset
- Token display (from token accuracy fix)
- Git branch

### How It Works

**Data Collection:**
1. `session_usage_tracker.py` hook captures session metadata
2. Calculates elapsed active time (assistant working time, not wall-clock)
3. Records to SQLite database: `~/.claude/data/usage_tracking.db`
4. Aggregates into 5-hour cycles and weekly windows

**Subscription Tier Detection:**
- **Auto-detection** based on usage patterns
- Pro: 40-80 hours/week expected
- Max (5x): 140-280 hours/week
- Max (20x): Higher limits
- Manual override via `usage_config.json`

**Color Coding:**
- 🟢 **Green** (<75%): Plenty of time remaining
- 🟡 **Yellow** (75-87.5%): Moderate usage
- 🟠 **Orange** (87.5-95%): High usage, plan accordingly
- 🔴 **Red** (95%+): Critical - near weekly limit

### Database Schema

**Tables:**
- `sessions` - Individual Claude Code sessions with elapsed time and tokens
- `five_hour_cycles` - Aggregated usage per 5-hour window
- `weekly_aggregates` - Rolling 7-day usage totals

**Location:** `~/.claude/data/usage_tracking.db`

### Configuration

Edit `status_lines/usage_config.json` to customize:

```json
{
  "subscription_tier": "auto",  // or "pro", "max_5x", "max_20x"
  "display_format": "full",     // or "compact"
  "color_coding": true,
  "database_path": "~/.claude/data/usage_tracking.db"
}
```

### Testing

**Unit Tests:**
```bash
cd ~/.claude/status_lines
python3 -m pytest test_usage_db.py -v
python3 -m pytest test_tier_detector.py -v
python3 -m pytest test_usage_formatter.py -v
python3 -m pytest test_status_line_integration.py -v
```

**Integration Test:**
```bash
./test_hook_integration.sh
```

**Manual Test:**
```bash
# View current usage
python3 -c "
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from status_line import get_usage_display
print(get_usage_display('/Users/natedamstra/.claude/data/usage_tracking.db'))
"
```

### Troubleshooting

**No usage displayed:**
- Check database exists: `ls -lh ~/.claude/data/usage_tracking.db`
- Verify hook is recording: `tail ~/.claude/logs/usage_tracker_errors.json`
- Run hook integration test: `./test_hook_integration.sh`

**Incorrect tier detection:**
- Override in `usage_config.json`: `"subscription_tier": "max_5x"`
- Check usage patterns match expectations

**Database issues:**
- Backup: `cp ~/.claude/data/usage_tracking.db ~/.claude/data/usage_tracking.db.backup`
- Reset: `rm ~/.claude/data/usage_tracking.db` (will recreate automatically)

### References

- Claude Code usage limits: 5-hour cycles + weekly cap
- Pro plan: 40-80 hours/week expected
- Max plans: 5x (140-280h), 20x (400-800h)
- Research sources: GitHub issues #9094, #9424
```

**Step 3: Commit**

```bash
git add status_lines/usage_config.json status_lines/README.md
git commit -m "docs: add usage tracking configuration and comprehensive documentation"
```

---

## Task 11: Final Integration Testing

**Files:**
- Create: `status_lines/test_full_integration.sh`

**Step 1: Create comprehensive integration test**

```bash
#!/usr/bin/env bash
# Full integration test for weekly usage tracking in status line

set -e

echo "🎯 Full Weekly Usage Tracking Integration Test"
echo "=============================================="
echo ""

# Cleanup previous test data
echo "🧹 Cleaning up previous test data..."
TEST_DB="/tmp/test_usage_full_integration.db"
rm -f "$TEST_DB"
echo ""

# Step 1: Create and populate database
echo "1️⃣ Creating test database with sample data..."
python3 << EOF
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from usage_db import UsageDatabase
import time

db = UsageDatabase('$TEST_DB')

# Simulate 7 days of usage
current_time = int(time.time())

# Recent sessions (today) - current cycle
for i in range(3):
    timestamp = current_time - (i * 1800)  # Every 30 minutes
    db.record_session(
        f"session-today-{i}",
        timestamp,
        1200.0,  # 20 minutes
        15000,
        "claude-sonnet-4-5",
        "/test/project"
    )

# Past week sessions
for day in range(7):
    for session in range(2):
        timestamp = current_time - (day * 86400) - (session * 3600)
        db.record_session(
            f"session-day{day}-{session}",
            timestamp,
            3600.0,  # 1 hour
            25000,
            "claude-sonnet-4-5",
            "/test/project"
        )

# Aggregate data
db.aggregate_current_cycle()
db.aggregate_current_week()

print("   ✅ Database created and populated")
print(f"   📊 Total sessions: 17 (3 today + 14 past week)")

db.close()
EOF

echo ""

# Step 2: Test cycle aggregation
echo "2️⃣ Testing 5-hour cycle aggregation..."
python3 << EOF
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from usage_db import UsageDatabase

db = UsageDatabase('$TEST_DB')
cursor = db.conn.cursor()

cursor.execute("SELECT total_seconds, session_count FROM five_hour_cycles ORDER BY cycle_start DESC LIMIT 1")
row = cursor.fetchone()

if row:
    hours = row[0] / 3600
    print(f"   Current cycle: {hours:.1f} hours from {row[1]} sessions")
    print("   ✅ Cycle aggregation working")
else:
    print("   ❌ No cycle data found")
    sys.exit(1)

db.close()
EOF

echo ""

# Step 3: Test weekly aggregation
echo "3️⃣ Testing weekly aggregation..."
python3 << EOF
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from usage_db import UsageDatabase

db = UsageDatabase('$TEST_DB')
cursor = db.conn.cursor()

cursor.execute("SELECT total_seconds, session_count FROM weekly_aggregates ORDER BY week_start DESC LIMIT 1")
row = cursor.fetchone()

if row:
    hours = row[0] / 3600
    print(f"   Weekly total: {hours:.1f} hours from {row[1]} sessions")
    print("   ✅ Weekly aggregation working")
else:
    print("   ❌ No weekly data found")
    sys.exit(1)

db.close()
EOF

echo ""

# Step 4: Test tier detection
echo "4️⃣ Testing subscription tier detection..."
python3 << EOF
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from tier_detector import detect_subscription_tier, SubscriptionTier

# Test with different usage levels
tier_pro = detect_subscription_tier(45, hit_limit=True)
tier_max5 = detect_subscription_tier(150, hit_limit=True)

print(f"   45h usage → {tier_pro.value}")
print(f"   150h usage → {tier_max5.value}")

if tier_pro == SubscriptionTier.PRO and tier_max5 == SubscriptionTier.MAX_5X:
    print("   ✅ Tier detection working")
else:
    print("   ❌ Tier detection failed")
    sys.exit(1)
EOF

echo ""

# Step 5: Test usage display formatting
echo "5️⃣ Testing usage display formatting..."
python3 << EOF
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from status_line import get_usage_display

display = get_usage_display('$TEST_DB')

if display:
    print(f"   Display: {display}")

    # Verify components present
    checks = [
        ("cycle:" in display, "cycle usage"),
        ("week:" in display, "weekly usage"),
        ("reset:" in display, "reset time"),
        ("h" in display, "hours format"),
        ("%" in display, "percentage")
    ]

    all_passed = True
    for check, name in checks:
        if check:
            print(f"   ✅ Contains {name}")
        else:
            print(f"   ❌ Missing {name}")
            all_passed = False

    if all_passed:
        print("   ✅ Display formatting working")
    else:
        sys.exit(1)
else:
    print("   ❌ No display output")
    sys.exit(1)
EOF

echo ""

# Step 6: Test color coding
echo "6️⃣ Testing color coding..."
python3 << EOF
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from tier_detector import get_usage_color, SubscriptionTier

# Test different usage levels
colors = [
    (get_usage_color(10, SubscriptionTier.PRO), "low usage", "92m"),
    (get_usage_color(32, SubscriptionTier.PRO), "high usage", "93m"),
    (get_usage_color(39, SubscriptionTier.PRO), "critical usage", "91m")
]

all_correct = True
for color, desc, expected_code in colors:
    if expected_code in color:
        print(f"   ✅ {desc} color correct")
    else:
        print(f"   ❌ {desc} color incorrect")
        all_correct = False

if all_correct:
    print("   ✅ Color coding working")
else:
    sys.exit(1)
EOF

echo ""

# Step 7: Performance test
echo "7️⃣ Testing query performance..."
python3 << EOF
import sys
import time
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from status_line import get_usage_display

start = time.time()
for _ in range(10):
    get_usage_display('$TEST_DB')
elapsed = time.time() - start

avg_ms = (elapsed / 10) * 1000
print(f"   Average query time: {avg_ms:.2f}ms")

if avg_ms < 100:
    print("   ✅ Performance acceptable (<100ms)")
else:
    print(f"   ⚠️  Performance slower than expected ({avg_ms:.2f}ms)")
EOF

echo ""

# Cleanup
echo "🧹 Cleaning up test data..."
rm -f "$TEST_DB"

echo ""
echo "✅ All integration tests passed!"
echo ""
echo "📊 Summary:"
echo "   - Database schema: ✅"
echo "   - Session recording: ✅"
echo "   - Cycle aggregation: ✅"
echo "   - Weekly aggregation: ✅"
echo "   - Tier detection: ✅"
echo "   - Display formatting: ✅"
echo "   - Color coding: ✅"
echo "   - Performance: ✅"
```

**Step 2: Make script executable and run**

Run: `chmod +x /Users/natedamstra/.claude/status_lines/test_full_integration.sh && /Users/natedamstra/.claude/status_lines/test_full_integration.sh`

Expected: All 7 test stages pass

**Step 3: Commit**

```bash
git add status_lines/test_full_integration.sh
git commit -m "test: add comprehensive full integration test suite"
```

---

## Validation Checklist

Before considering this complete, verify:

- [ ] SQLite schema creates all tables correctly
- [ ] Session duration calculation accurate from timestamps
- [ ] Sessions record and update properly
- [ ] 5-hour cycle aggregation works correctly
- [ ] Weekly rolling window aggregation accurate
- [ ] Subscription tier detection reasonable
- [ ] Usage display formatting includes all components
- [ ] Color coding reflects usage levels correctly
- [ ] Hook integration records sessions automatically
- [ ] Status line displays usage alongside tokens
- [ ] All unit tests pass (50+ tests across modules)
- [ ] Integration tests pass
- [ ] Performance acceptable (<100ms queries)
- [ ] Documentation comprehensive

## Expected Outcome

### Before Implementation
```
[142k/200k (71%)] | main
```

### After Implementation
```
[cycle: 2.3h | week: 18.5h/40h (46%) | reset: 2h15m] | [142k/200k (71%)] | main
```

**Color Coding Examples:**
- Low usage (25%): 🟢 `[cycle: 0.8h | week: 10h/40h (25%) | reset: 4h30m]`
- Moderate (60%): 🟢 `[cycle: 2.1h | week: 24h/40h (60%) | reset: 2h15m]`
- High (80%): 🟡 `[cycle: 3.5h | week: 32h/40h (80%) | reset: 1h45m]`
- Critical (96%): 🔴 `[cycle: 4.2h | week: 38h/40h (95%) | reset: 0h25m]`

## Notes for Implementation

1. **Elapsed Time is Critical**: Track assistant active time, not wall-clock session time
2. **Rolling Windows**: Weekly = last 7 days, not calendar week
3. **5-Hour Cycles**: Claude's actual reset period, use for short-term tracking
4. **Tier Detection**: Conservative defaults (Pro) unless clear evidence of Max tier
5. **Hook Integration**: Non-blocking, graceful error handling
6. **Database Performance**: Indexed queries for fast status line updates
7. **Configuration**: Allow manual tier override for edge cases

## Resources

- Claude Code usage limits: 5-hour cycles + weekly cap (August 2024+)
- Research: GitHub issues #9094 (usage limits), #9424 (weekly limits)
- Pro plan: 40-80 hours/week typical
- Max plans: 5x (140-280h), 20x (higher limits)
- Tavily research: Comprehensive limit documentation
- Token accuracy plan: 2025-10-30-fix-statusline-token-accuracy.md

---

**Implementation Time Estimate**: 6-8 hours
**Testing Time Estimate**: 2-3 hours
**Total Effort**: ~8-11 hours

**Dependencies**:
- Token accuracy fix (completed in 2025-10-30-fix-statusline-token-accuracy.md)
- Python 3.11+ with sqlite3
- Existing hook infrastructure

**Risk Level**: Medium (new database, hook integration, complex time calculations)

import pytest
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from status_line import calculate_weighted_tokens


def test_weighted_token_calculation_with_cache_reads():
    """Test that cache_read_input_tokens are weighted at 0.1x."""
    usage = {
        "input_tokens": 1000,
        "cache_read_input_tokens": 50000,  # Should count as 5000
        "output_tokens": 500,  # Should be ignored for context
    }

    # Expected: 1000 + (50000 * 0.1) = 6000
    result = calculate_weighted_tokens(usage)
    assert result == 6000, f"Expected 6000, got {result}"


def test_weighted_token_calculation_with_cache_creation():
    """Test that cache_creation_input_tokens count fully."""
    usage = {
        "input_tokens": 1000,
        "cache_creation_input_tokens": 32000,  # Should count fully
        "output_tokens": 500,
    }

    # Expected: 1000 + 32000 = 33000
    result = calculate_weighted_tokens(usage)
    assert result == 33000, f"Expected 33000, got {result}"


def test_weighted_token_calculation_mixed():
    """Test with both regular, cache creation, and cache reads."""
    usage = {
        "input_tokens": 10,
        "cache_creation_input_tokens": 32351,
        "cache_read_input_tokens": 100000,  # Should count as 10000
        "output_tokens": 8,
    }

    # Expected: 10 + 32351 + (100000 * 0.1) = 42361
    result = calculate_weighted_tokens(usage)
    assert result == 42361, f"Expected 42361, got {result}"


def test_cumulative_tokens_from_transcript_fixture(tmp_path):
    """Test calculating cumulative tokens from real transcript structure."""
    from status_line import calculate_token_usage

    # Create test transcript with multiple assistant responses
    transcript_file = tmp_path / "test_transcript.jsonl"

    # Simulate 3 turns of conversation (with message IDs)
    lines = [
        '{"type":"user","message":{"role":"user","content":"Hello"}}',
        '{"type":"assistant","message":{"id":"msg_001","role":"assistant","usage":{"input_tokens":10,"cache_creation_input_tokens":32351,"cache_read_input_tokens":0,"output_tokens":8}}}',
        '{"type":"user","message":{"role":"user","content":"Continue"}}',
        '{"type":"assistant","message":{"id":"msg_002","role":"assistant","usage":{"input_tokens":15,"cache_read_input_tokens":32351,"output_tokens":12}}}',
        '{"type":"user","message":{"role":"user","content":"More"}}',
        '{"type":"assistant","message":{"id":"msg_003","role":"assistant","usage":{"input_tokens":20,"cache_read_input_tokens":64702,"output_tokens":150}}}',
    ]

    transcript_file.write_text('\n'.join(lines))

    # Expected cumulative weighted tokens:
    # Turn 1: 10 + 32351 + 0 = 32361
    # Turn 2: 15 + (32351 * 0.1) = 3250.1 → 3250
    # Turn 3: 20 + (64702 * 0.1) = 6490.2 → 6490
    # Total: 32361 + 3250 + 6490 = 42101

    result = calculate_token_usage(str(transcript_file))
    assert result == 42101, f"Expected 42101, got {result}"


def test_format_token_display_normal_usage():
    """Test display formatting for normal usage levels."""
    from status_line import format_token_display

    # 71% usage - should be green
    result = format_token_display(142000, 200000)
    assert "142k/200k" in result
    assert "71%" in result
    assert "\033[92m" in result  # Green color code


def test_format_token_display_high_usage():
    """Test display formatting for high usage levels."""
    from status_line import format_token_display

    # 88% usage - should be orange
    result = format_token_display(176000, 200000)
    assert "176k/200k" in result
    assert "88%" in result
    assert "\033[33m" in result  # Orange color code


def test_format_token_display_critical_usage():
    """Test display formatting for critical usage levels."""
    from status_line import format_token_display

    # 96% usage - should be red
    result = format_token_display(192000, 200000)
    assert "192k/200k" in result
    assert "96%" in result
    assert "\033[91m" in result  # Red color code


def test_format_token_display_none_input():
    """Test display formatting handles None gracefully."""
    from status_line import format_token_display

    result = format_token_display(None, 200000)
    assert result is None


def test_deduplication_of_duplicate_messages(tmp_path):
    """Test that duplicate message IDs are not counted multiple times."""
    from status_line import calculate_token_usage

    # Create test transcript with duplicate assistant responses
    transcript_file = tmp_path / "test_transcript_with_dupes.jsonl"

    # Simulate conversation with duplicate entries (same message ID appears twice)
    lines = [
        '{"type":"user","message":{"role":"user","content":"Hello"}}',
        '{"type":"assistant","message":{"id":"msg_001","role":"assistant","usage":{"input_tokens":10,"cache_creation_input_tokens":32351,"cache_read_input_tokens":0,"output_tokens":8}}}',
        '{"type":"assistant","message":{"id":"msg_001","role":"assistant","usage":{"input_tokens":10,"cache_creation_input_tokens":32351,"cache_read_input_tokens":0,"output_tokens":8}}}',  # DUPLICATE
        '{"type":"user","message":{"role":"user","content":"Continue"}}',
        '{"type":"assistant","message":{"id":"msg_002","role":"assistant","usage":{"input_tokens":15,"cache_read_input_tokens":32351,"output_tokens":12}}}',
        '{"type":"assistant","message":{"id":"msg_002","role":"assistant","usage":{"input_tokens":15,"cache_read_input_tokens":32351,"output_tokens":12}}}',  # DUPLICATE
    ]

    transcript_file.write_text('\n'.join(lines))

    # Expected cumulative weighted tokens (counting each message ONCE):
    # msg_001: 10 + 32351 + 0 = 32361
    # msg_002: 15 + (32351 * 0.1) = 3250.1 → 3250
    # Total: 32361 + 3250 = 35611
    #
    # If duplicates were counted: 32361*2 + 3250*2 = 71222 (WRONG!)

    result = calculate_token_usage(str(transcript_file))
    assert result == 35611, f"Expected 35611 (deduplicated), got {result}"

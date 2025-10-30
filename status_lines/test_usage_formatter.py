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

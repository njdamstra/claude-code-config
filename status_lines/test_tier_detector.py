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

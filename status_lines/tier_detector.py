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

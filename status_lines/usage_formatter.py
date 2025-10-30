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

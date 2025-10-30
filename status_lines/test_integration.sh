#!/usr/bin/env bash
# Integration test for status line token calculation

set -e

echo "🧪 Status Line Token Calculation Integration Test"
echo "================================================"
echo ""

# Use current session transcript (known to be reasonable size)
TRANSCRIPT="/Users/natedamstra/.claude/projects/-Users-natedamstra--claude/b261d838-d0e5-4072-9dce-2c6d5a8115c5.jsonl"

if [ -z "$TRANSCRIPT" ]; then
    echo "❌ No transcript files found"
    exit 1
fi

echo "📁 Using transcript: $(basename $TRANSCRIPT)"
echo ""

# Calculate weighted tokens
echo "🔢 Calculating weighted tokens..."
WEIGHTED_TOKENS=$(python3 -c "
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from status_line import calculate_token_usage
result = calculate_token_usage('$TRANSCRIPT')
print(result if result else 0)
")

echo "   Weighted tokens: $WEIGHTED_TOKENS"
echo ""

# Validate reasonable range
if [ "$WEIGHTED_TOKENS" -gt 0 ] && [ "$WEIGHTED_TOKENS" -lt 300000 ]; then
    echo "✅ Token count is in reasonable range (0-300k)"
else
    echo "❌ Token count out of range: $WEIGHTED_TOKENS"
    exit 1
fi

# Calculate percentage
PERCENTAGE=$(python3 -c "print(int(($WEIGHTED_TOKENS / 200000) * 100))")
echo "   Percentage of budget: ${PERCENTAGE}%"
echo ""

# Test format display
echo "🎨 Testing display formatting..."
DISPLAY=$(python3 -c "
import sys
sys.path.insert(0, '/Users/natedamstra/.claude/status_lines')
from status_line import format_token_display
print(format_token_display($WEIGHTED_TOKENS))
")

echo "   Display output: $DISPLAY"
echo ""

# Verify no extreme values
if [ "$PERCENTAGE" -gt 500 ]; then
    echo "❌ Percentage over 500% - calculation bug!"
    exit 1
fi

echo "✅ All integration tests passed!"
echo ""
echo "📊 Summary:"
echo "   - Weighted tokens: ${WEIGHTED_TOKENS}"
echo "   - Budget usage: ${PERCENTAGE}%"
echo "   - Display: ${DISPLAY}"

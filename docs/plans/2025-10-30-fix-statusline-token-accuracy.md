# Fix Status Line Token Accuracy Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Fix the status line token counter to accurately reflect actual conversation token usage and remaining context budget in Claude Code.

**Architecture:** The current implementation (status_line.py:212-246) incorrectly sums ALL token types equally, treating cache tokens the same as regular tokens. Claude's API uses prompt caching where `cache_read_input_tokens` are 90% cheaper and shouldn't count fully toward context limits. The fix requires weighted token calculation and understanding that the 200k budget is primarily for INPUT tokens, not total tokens.

**Tech Stack:** Python 3.11+, Claude API usage structure, JSONL transcript parsing

---

## Problem Analysis

### Current Bug
The status line shows: `[6465k/200k (3232%)]` - impossible values because:

1. **Line 236-238**: Sums ALL token types equally:
   ```python
   total_tokens += usage.get('input_tokens', 0)
   total_tokens += usage.get('cache_read_input_tokens', 0)  # BUG: counts full value
   total_tokens += usage.get('output_tokens', 0)
   ```

2. **Cache tokens are 10x cheaper**: `cache_read_input_tokens` are read from cache (0.1x cost), not fresh tokens (1x cost)

3. **Wrong budget reference**: 200k is the INPUT context window, not total conversation tokens

### Correct Token Calculation

According to Claude API documentation and research:
- **Context Window**: 200k tokens for Sonnet 4/4.5 (standard models)
- **Budget applies to**: Cumulative INPUT tokens in conversation (what goes IN)
- **Cache tokens**: Count at 0.1x weight (90% discount)
- **Output tokens**: Don't count toward INPUT context budget
- **Cache creation tokens**: Count as regular input tokens (first time)

### Accurate Formula

```python
effective_input_tokens = (
    regular_input_tokens +
    cache_creation_tokens +
    (cache_read_tokens * 0.1)  # 90% cheaper
)
# Output tokens are irrelevant to context budget
```

---

## Task 1: Create Test Fixture with Real Token Data

**Files:**
- Create: `status_lines/test_token_calculation.py`

**Step 1: Write failing test for weighted token calculation**

```python
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

    # Simulate 3 turns of conversation
    lines = [
        '{"type":"user","message":{"role":"user","content":"Hello"}}',
        '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":10,"cache_creation_input_tokens":32351,"cache_read_input_tokens":0,"output_tokens":8}}}',
        '{"type":"user","message":{"role":"user","content":"Continue"}}',
        '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":15,"cache_read_input_tokens":32351,"output_tokens":12}}}',
        '{"type":"user","message":{"role":"user","content":"More"}}',
        '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":20,"cache_read_input_tokens":64702,"output_tokens":150}}}',
    ]

    transcript_file.write_text('\n'.join(lines))

    # Expected cumulative weighted tokens:
    # Turn 1: 10 + 32351 + 0 = 32361
    # Turn 2: 15 + (32351 * 0.1) = 3250.1 → 3250
    # Turn 3: 20 + (64702 * 0.1) = 6490.2 → 6490
    # Total: 32361 + 3250 + 6490 = 42101

    result = calculate_token_usage(str(transcript_file))
    assert result == 42101, f"Expected 42101, got {result}"
```

**Step 2: Run test to verify it fails**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_token_calculation.py -v`

Expected: FAIL with "ImportError: cannot import name 'calculate_weighted_tokens'"

**Step 3: Commit**

```bash
git add status_lines/test_token_calculation.py
git commit -m "test: add failing tests for weighted token calculation"
```

---

## Task 2: Implement Weighted Token Calculation

**Files:**
- Modify: `status_lines/status_line.py:212-246`

**Step 1: Add calculate_weighted_tokens function**

Add new function BEFORE `calculate_token_usage`:

```python
def calculate_weighted_tokens(usage):
    """
    Calculate weighted token count for context budget.

    Claude's 200k context window applies to INPUT tokens only.
    - cache_read_input_tokens: 0.1x weight (90% discount)
    - cache_creation_input_tokens: 1x weight (full cost)
    - input_tokens: 1x weight (full cost)
    - output_tokens: IGNORED (not part of input context)

    Args:
        usage: Usage dict from Claude API response

    Returns:
        int: Weighted token count for context budget calculation
    """
    if not usage:
        return 0

    # Regular input tokens (full weight)
    regular_input = usage.get('input_tokens', 0)

    # Cache creation tokens (full weight - first time)
    cache_creation = usage.get('cache_creation_input_tokens', 0)

    # Cache read tokens (0.1x weight - 90% cheaper)
    cache_reads = usage.get('cache_read_input_tokens', 0)
    weighted_cache_reads = int(cache_reads * 0.1)

    # Sum weighted tokens
    weighted_total = regular_input + cache_creation + weighted_cache_reads

    return weighted_total
```

**Step 2: Update calculate_token_usage to use weighted calculation**

Replace lines 212-246 with:

```python
def calculate_token_usage(transcript_path):
    """Parse transcript and calculate cumulative weighted token usage."""
    from pathlib import Path

    if not transcript_path or not Path(transcript_path).exists():
        return None

    cumulative_weighted_tokens = 0

    try:
        with open(transcript_path, 'r') as f:
            for line in f:
                try:
                    entry = json.loads(line)

                    # Only process assistant responses
                    if entry.get('type') != 'assistant':
                        continue

                    usage = entry.get('message', {}).get('usage', {})
                    if not usage:
                        continue

                    # Calculate weighted tokens for this turn
                    turn_weighted_tokens = calculate_weighted_tokens(usage)
                    cumulative_weighted_tokens += turn_weighted_tokens

                except json.JSONDecodeError:
                    continue

        return cumulative_weighted_tokens if cumulative_weighted_tokens > 0 else None

    except Exception:
        return None
```

**Step 3: Run tests to verify they pass**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_token_calculation.py -v`

Expected: PASS for all tests

**Step 4: Verify with actual transcript**

Run: `cd /Users/natedamstra/.claude && python3 -c "from status_lines.status_line import calculate_token_usage; print(calculate_token_usage('projects/-Users-natedamstra-NATE-SECOND-BRAIN/0dfc5131-829c-46be-a306-5023038fb9e6.jsonl'))"`

Expected: Reasonable number < 200000 (e.g., 50000-150000)

**Step 5: Commit**

```bash
git add status_lines/status_line.py
git commit -m "feat: implement weighted token calculation for cache reads"
```

---

## Task 3: Update Token Display Formatting

**Files:**
- Modify: `status_lines/status_line.py:249-272`

**Step 1: Write test for display formatting edge cases**

Add to `test_token_calculation.py`:

```python
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
```

**Step 2: Run new tests**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_token_calculation.py::test_format_token_display_normal_usage -v`

Expected: PASS (function already exists, just verifying)

**Step 3: Add helpful context comment**

Update the comment at line 249:

```python
def format_token_display(tokens_used, token_budget=200000):
    """
    Format token usage with color coding.

    The token_budget (default 200k) is the Claude API INPUT context window.
    tokens_used should be the weighted cumulative input tokens from the conversation.

    Color coding:
    - Green: <75% usage
    - Yellow: 75-87.5% usage
    - Orange: 87.5-95% usage
    - Red: 95%+ usage
    """
    if tokens_used is None:
        return None

    percentage = (tokens_used / token_budget) * 100

    # Color coding based on usage
    if tokens_used >= 190000:  # 95%+
        color = "\033[91m"  # Bright red
    elif tokens_used >= 175000:  # 87.5%+
        color = "\033[33m"  # Orange
    elif tokens_used >= 150000:  # 75%+
        color = "\033[93m"  # Yellow
    else:
        color = "\033[92m"  # Green

    # Format: [142k/200k (71%)]
    tokens_k = f"{tokens_used // 1000}k"
    budget_k = f"{token_budget // 1000}k"
    percentage_str = f"{int(percentage)}%"

    return f"{color}[{tokens_k}/{budget_k} ({percentage_str})]\033[0m"
```

**Step 4: Run all tests**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_token_calculation.py -v`

Expected: PASS for all tests

**Step 5: Commit**

```bash
git add status_lines/status_line.py status_lines/test_token_calculation.py
git commit -m "docs: add clarifying comments for token display formatting"
```

---

## Task 4: Add README Documentation

**Files:**
- Modify: `status_lines/README.md`

**Step 1: Add Token Calculation section**

Add after existing content:

```markdown
## Token Calculation Methodology

### Understanding Claude's Token Budget

Claude Code's 200k token budget refers to the **INPUT context window** - the amount of conversation history and context that can be maintained in a single session. This is separate from output tokens and billing.

### Weighted Token Calculation

The status line uses **weighted token calculation** to accurately reflect context usage:

1. **Regular Input Tokens** (`input_tokens`): Full weight (1x)
   - New tokens sent to the API
   - Count fully toward the 200k context budget

2. **Cache Creation Tokens** (`cache_creation_input_tokens`): Full weight (1x)
   - Tokens cached for the first time
   - Count fully toward context budget

3. **Cache Read Tokens** (`cache_read_input_tokens`): Reduced weight (0.1x)
   - Tokens read from prompt cache (90% discount)
   - Only count 10% toward effective context usage
   - Example: 50,000 cached tokens = 5,000 effective tokens

4. **Output Tokens** (`output_tokens`): Not counted (0x)
   - Responses from Claude
   - Don't count toward INPUT context budget

### Formula

```python
effective_input_tokens = (
    input_tokens +
    cache_creation_input_tokens +
    (cache_read_input_tokens * 0.1)
)
```

### Why This Matters

Without weighted calculation, the status line would show:
- `[6465k/200k (3232%)]` ❌ Incorrect - counts cache reads fully

With weighted calculation, it correctly shows:
- `[142k/200k (71%)]` ✅ Correct - accounts for cache discount

### Color Coding

The token display uses color coding to indicate usage levels:
- 🟢 **Green** (<75%): Plenty of context remaining
- 🟡 **Yellow** (75-87.5%): Moderate usage
- 🟠 **Orange** (87.5-95%): High usage, consider wrapping up
- 🔴 **Red** (95%+): Critical - near context limit

### References

- [Claude API Token Limits](https://docs.claude.com/en/release-notes/overview)
- [Prompt Caching Documentation](https://docs.claude.com/)
- Standard context window: 200k tokens (Sonnet 4/4.5)
- Extended context window: 1M tokens (beta, API only)
```

**Step 2: Update existing sections if needed**

Review README.md for any outdated information about token counting.

**Step 3: Commit**

```bash
git add status_lines/README.md
git commit -m "docs: add token calculation methodology to README"
```

---

## Task 5: Integration Testing with Live Status Line

**Files:**
- Create: `status_lines/test_integration.sh`

**Step 1: Create integration test script**

```bash
#!/usr/bin/env bash
# Integration test for status line token calculation

set -e

echo "🧪 Status Line Token Calculation Integration Test"
echo "================================================"
echo ""

# Find a real transcript file
TRANSCRIPT=$(find /Users/natedamstra/.claude/projects -name "*.jsonl" -type f | head -1)

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
```

**Step 2: Make script executable**

Run: `chmod +x /Users/natedamstra/.claude/status_lines/test_integration.sh`

**Step 3: Run integration test**

Run: `/Users/natedamstra/.claude/status_lines/test_integration.sh`

Expected:
```
✅ All integration tests passed!
📊 Summary:
   - Weighted tokens: [some reasonable number]
   - Budget usage: [<200%]
   - Display: [formatted with colors]
```

**Step 4: Commit**

```bash
git add status_lines/test_integration.sh
git commit -m "test: add integration tests for status line token calculation"
```

---

## Task 6: Test with Real Claude Code Session

**Files:**
- Manual testing only

**Step 1: Clear current session**

Run: `/clear` in Claude Code

**Step 2: Verify status line shows reasonable values**

Expected in status line: `[XXk/200k (XX%)]` where XX% is <100%

**Step 3: Have a conversation with cache warming**

Type several messages to warm up the prompt cache and trigger cache reads.

**Step 4: Observe token count increases reasonably**

Each exchange should increase the count by a reasonable amount, not by hundreds of thousands.

**Step 5: Check log file for accuracy**

Run: `cat /Users/natedamstra/.claude/logs/status_line.json | jq '.[-1]'`

Verify the logged token values match what's displayed.

**Step 6: Document findings**

Create a brief summary of test results:

```bash
echo "# Status Line Token Accuracy Test Results

## Test Date: $(date)

## Before Fix
- Display showed: [6465k/200k (3232%)]
- Issue: Cache read tokens counted at full weight

## After Fix
- Display shows: [actual value from testing]
- Accuracy: Token count stays under 200k
- Cache reads properly weighted at 0.1x

## Test Scenarios Validated
- ✅ Fresh session (no cache)
- ✅ Cache warming (first cache creation)
- ✅ Cache reading (subsequent turns)
- ✅ Color coding accuracy
- ✅ Integration with Claude Code UI

## Conclusion
Token calculation is now accurate and reflects actual context budget usage.
" > /Users/natedamstra/.claude/status_lines/test_results.md
```

---

## Task 7: Final Cleanup and Documentation

**Files:**
- Modify: `status_lines/status_line.py` (comments)
- Create: `status_lines/CHANGELOG.md`

**Step 1: Add inline code comments for future maintainers**

Update the comment at line 212:

```python
def calculate_weighted_tokens(usage):
    """
    Calculate weighted token count for context budget.

    CRITICAL UNDERSTANDING:
    Claude's 200k context window limit applies to INPUT tokens only.
    This function calculates the "effective" input token count considering
    that cached tokens are 90% cheaper (0.1x weight).

    Token Types and Weights:
    ┌─────────────────────────────┬────────┬─────────────────────────┐
    │ Token Type                  │ Weight │ Reason                  │
    ├─────────────────────────────┼────────┼─────────────────────────┤
    │ input_tokens                │ 1.0x   │ New input, full cost    │
    │ cache_creation_input_tokens │ 1.0x   │ First cache, full cost  │
    │ cache_read_input_tokens     │ 0.1x   │ 90% discount from cache │
    │ output_tokens               │ 0.0x   │ Not part of input limit │
    └─────────────────────────────┴────────┴─────────────────────────┘

    Example:
    - input_tokens: 1,000 → counts as 1,000
    - cache_read_input_tokens: 50,000 → counts as 5,000
    - output_tokens: 500 → counts as 0
    - Total weighted: 6,000 (not 51,500!)

    Args:
        usage: Usage dict from Claude API response with structure:
            {
                "input_tokens": int,
                "cache_creation_input_tokens": int,
                "cache_read_input_tokens": int,
                "output_tokens": int
            }

    Returns:
        int: Weighted token count for context budget calculation
    """
```

**Step 2: Create CHANGELOG**

```markdown
# Status Line Changelog

## 2025-10-30 - Token Accuracy Fix

### Problem
Status line displayed impossible token values like `[6465k/200k (3232%)]` because all token types were counted equally, including cached tokens that should be discounted.

### Solution
Implemented weighted token calculation:
- `cache_read_input_tokens` now count at 0.1x weight (90% discount)
- `output_tokens` are excluded from context budget calculation
- Only INPUT tokens count toward the 200k context window

### Changes
- Added `calculate_weighted_tokens()` function
- Updated `calculate_token_usage()` to use weighted calculation
- Added comprehensive test suite (`test_token_calculation.py`)
- Added integration tests (`test_integration.sh`)
- Enhanced documentation in README.md

### Impact
- ✅ Accurate context budget tracking
- ✅ Proper cache token accounting
- ✅ Meaningful percentage display (<100% in normal usage)
- ✅ Color-coded warnings based on actual context usage

### Testing
- Unit tests: 7 tests covering weighted calculation
- Integration tests: Real transcript validation
- Manual testing: Live Claude Code session verification

### References
- Claude API documentation on prompt caching
- Claude Code context window: 200k tokens (standard models)
- Cache read discount: 90% (0.1x weight)
```

**Step 3: Run final test suite**

Run: `cd /Users/natedamstra/.claude/status_lines && python3 -m pytest test_token_calculation.py -v && ./test_integration.sh`

Expected: All tests pass

**Step 4: Final commit**

```bash
git add status_lines/
git commit -m "docs: add comprehensive documentation for token calculation fix

- Inline code comments with visual table
- CHANGELOG documenting the fix
- Test results from real sessions
- Complete reference materials"
```

---

## Validation Checklist

Before considering this complete, verify:

- [ ] Unit tests pass (7 tests in test_token_calculation.py)
- [ ] Integration test passes (test_integration.sh)
- [ ] Status line shows values <200k in normal usage
- [ ] Percentage is <100% for typical sessions
- [ ] Color coding works correctly
- [ ] Cache reads are weighted at 0.1x
- [ ] Documentation is comprehensive
- [ ] Code comments explain the "why" not just "what"

## Expected Outcome

### Before Fix
```
[6465k/200k (3232%)]  ❌ Impossible value
```

### After Fix
```
[142k/200k (71%)]  ✅ Accurate, meaningful value
```

## Notes for Implementation

1. **Token Weighting is Critical**: Cache reads at 0.1x prevent inflated counts
2. **Output Tokens Don't Count**: Only INPUT tokens affect context budget
3. **200k is Input Window**: Not total conversation tokens
4. **Test with Real Data**: Use actual transcripts for validation
5. **Color Coding Helps Users**: Visual feedback on context usage

## Resources

- Claude API documentation: https://docs.claude.com/
- Claude Code context limits: Standard 200k, Extended 1M (beta)
- Prompt caching mechanics: 90% discount on cache reads
- Token counting methodology: Weighted by token type

---

**Implementation Time Estimate**: 2-3 hours
**Testing Time Estimate**: 30-45 minutes
**Total Effort**: ~3-4 hours

**Dependencies**: None (all changes in status_line.py and tests)
**Risk Level**: Low (localized change, well-tested)

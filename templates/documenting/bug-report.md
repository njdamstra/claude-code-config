# Bug Report: [Brief Description]

**Status**: Open | In Progress | Resolved
**Severity**: Critical | High | Medium | Low
**Date Reported**: YYYY-MM-DD
**Assignee**: Name

---

## Summary
One-sentence description of the bug and its impact.

## Environment
- **Browser**: Chrome 120 / Safari 17 / Firefox 122
- **OS**: macOS Sonoma / Windows 11 / Linux
- **App Version**: v1.2.3
- **User Type**: Authenticated / Guest / Admin

## Reproduction Steps
1. Navigate to `/path/to/page`
2. Click on "Button Name"
3. Observe error in console / UI behavior

## Expected Behavior
What should happen under normal conditions.

## Actual Behavior
What actually happens, including:
- Visible UI issues
- Console errors
- Network failures
- State inconsistencies

## Evidence

### Screenshots
![Description](path/to/screenshot.png)

### Console Logs
```
Error message from browser console
Stack trace if available
```

### Network Activity
```
Failed request details
Response codes
Payload data
```

## Root Cause Analysis

### Investigation Summary
- Where in codebase the issue originates
- Why it occurs (logic error, race condition, etc.)
- Related code locations: `file.ts:123`

### Contributing Factors
1. **Factor 1**: Description
2. **Factor 2**: Description

## Proposed Solution

### Approach
Describe the fix strategy.

### Code Changes Required
- `src/path/to/file.ts:123` - Change description
- `src/path/to/other.vue:45` - Change description

### Testing Strategy
How to verify the fix works and doesn't introduce regressions.

## Workaround (if applicable)
Temporary solution users can apply while waiting for fix.

## Impact Assessment
- **Users Affected**: Percentage or user segment
- **Frequency**: Always | Sometimes | Rare
- **Business Impact**: Critical path blocked | Feature degraded | Minor inconvenience

## Related Issues
- #123 - Similar issue in different context
- #456 - Root cause shared with this bug

## Resolution Notes
(Fill after fix is deployed)
- Fix deployed: YYYY-MM-DD
- Verification: How confirmed resolved
- Follow-up tasks: Any additional work needed

# [Bug Name] - Debugging Plan

**Status:** Investigation
**Severity:** [Critical/High/Medium/Low]
**Created:** [Date]

## Bug Description & Symptoms

[What's happening vs. what should happen]

### Observed Behavior
[Describe what actually happens]

### Expected Behavior
[Describe what should happen]

### Impact
- User Impact: [description]
- Frequency: [always/intermittent/rare]
- Affected Users: [all/specific group/percentage]

## Reproduction Steps

[Consistent steps to reproduce]

1. [Step 1]
2. [Step 2]
3. [Step 3]
4. **Result:** [what happens]

### Reproduction Rate
- [X]% reproducible
- Conditions required: [list]

## Environment Analysis

[Configuration, dependencies, versions]

### Environment Details
- OS: [operating system]
- Browser: [if applicable]
- Node Version: [version]
- Dependencies: [key package versions]

### Configuration State
- Environment Variables: [relevant vars]
- Feature Flags: [if applicable]
- Database State: [if relevant]

## Root Cause Analysis

[Hypotheses and investigation results]

### Hypotheses Generated
1. **[Hypothesis 1]**
   - Likelihood: [High/Medium/Low]
   - Evidence: [supporting evidence]
   - Test Strategy: [how to validate]

2. **[Hypothesis 2]**
   - Likelihood: [High/Medium/Low]
   - Evidence: [supporting evidence]
   - Test Strategy: [how to validate]

### Investigation Findings
- Code Trace: [execution path from entry to error]
- Suspect Code: [file:line references]
- Dependencies: [package issues if any]

### Root Cause
[Confirmed root cause with evidence]

## Fix Implementation Plan

[Steps to implement fix]

### Fix Approach
[High-level fix description]

### Implementation Steps
1. [ ] [Step 1]
2. [ ] [Step 2]
3. [ ] [Step 3]

### Files to Modify
- `[file path 1]` - [what changes]
- `[file path 2]` - [what changes]

### Alternative Approaches
| Approach | Pros | Cons | Recommendation |
|----------|------|------|----------------|
| [Option 1] | [pros] | [cons] | [Yes/No] |
| [Option 2] | [pros] | [cons] | [Yes/No] |

## Testing Strategy

[How to verify fix works]

### Test Cases
- [ ] **Reproduction Test:** Verify bug no longer occurs with fix
- [ ] **Edge Cases:** Test boundary conditions
- [ ] **Regression Tests:** Ensure no new bugs introduced

### Verification Checkpoints
1. [ ] Fix applied
2. [ ] Unit tests pass
3. [ ] Integration tests pass
4. [ ] Manual testing complete
5. [ ] Regression testing complete

## Regression Prevention

[How to prevent recurrence]

### Preventive Measures
- [ ] Add test case for this scenario
- [ ] Update validation logic
- [ ] Improve error handling
- [ ] Add monitoring/alerting
- [ ] Document edge case

### Side Effects Analysis
- **Potential Regressions:** [list affected areas]
- **Mitigation:** [how to prevent]
- **Rollback Plan:** [how to revert if needed]

## Notes

[Additional context, related issues, lessons learned]

---

**Generated:** [Timestamp]
**Workflow:** debugging
**Root Cause Category:** [logic/data/timing/dependency]
**Fix Complexity:** [simple/moderate/complex]

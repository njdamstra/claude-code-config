---
description: Update multiple components consistently with progress tracking and quality validation
argument-hint: [pattern] [change description]
allowed-tools: read, write, str_replace, bash, grep, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Batch Component Update

Apply consistent changes across multiple components with real-time progress tracking and quality validation.

## Usage

```bash
/ui-batch-update buttons/* Update all buttons to use new --color-primary-600 token
/ui-batch-update cards/* Add loading state prop to all card components
/ui-batch-update **/*.vue Convert all inline styles to Tailwind classes
```

**Syntax**: `/ui-batch-update [pattern] [change description]`

## Process

Apply changes to components matching: `$1`
Change to make: `$ARGUMENTS` (excluding first argument)

### Step 1: Discovery
1. Find all components matching pattern
2. Count total components to update
3. Show list for user approval
4. **WAIT FOR CONFIRMATION** before proceeding

### Step 2: Analysis (ui-analyzer)
For each component:
1. Read current implementation
2. Identify required changes
3. Check for conflicts
4. Plan modification approach

### Step 3: Batch Update (ui-builder)
For each component:
1. Apply changes systematically
2. Maintain consistency across all files
3. Preserve existing functionality
4. Update TypeScript types as needed
5. Show progress: [X/N] Component updated

### Step 4: Validation (ui-validator)
For each updated component:
1. Quality score check
2. Design system compliance
3. Accessibility validation
4. Auto-fix common issues
5. Report issues if score < 85/100

### Step 5: Visual Regression (ui-validator)
If visual changes detected:
1. Capture screenshots of all updated components
2. Compare against baselines
3. Flag significant visual differences
4. Require approval for baseline updates

### Step 6: Final Report
1. Show summary of all changes
2. Report quality metrics
3. List any issues found
4. Provide next steps

## Output Format

```markdown
# 🔄 Batch Update: [Pattern]

**Target**: $1
**Change**: [Change description]

---

## 📋 Discovery

### Components Found: [N]
\```
src/components/vue/buttons/PrimaryButton.vue
src/components/vue/buttons/SecondaryButton.vue
src/components/vue/buttons/IconButton.vue
[... list all components]
\```

**Proceed with batch update?** (yes/no)

---

## 🔄 Batch Update Progress

### Component 1/N: PrimaryButton.vue ⏳
**Status**: Analyzing...
**Changes**: Identified 3 modifications needed

**Status**: Updating... 
**Changes Applied**:
- ✅ Updated color token
- ✅ Added new prop
- ✅ Updated TypeScript types

**Status**: Validating...
**Quality Score**: 96/100 ✅

---

### Component 2/N: SecondaryButton.vue ⏳
[Same progress format]

---

### Component 3/N: IconButton.vue ⏳
[Continue for all components]

---

## ✅ Batch Update Complete

**Summary:**
- **Total Components**: [N]
- **Successfully Updated**: [X]
- **Failed**: [Y]
- **Average Quality Score**: 94/100
- **Time Taken**: 15 minutes

---

## 📊 Quality Report

| Component | Before | After | Change | Issues |
|-----------|--------|-------|--------|--------|
| PrimaryButton.vue | 92/100 | 96/100 | +4 | None |
| SecondaryButton.vue | 88/100 | 94/100 | +6 | 1 warning |
| IconButton.vue | 85/100 | 91/100 | +6 | Auto-fixed |

**Overall Impact**: +5.3 average score improvement

---

## 🔍 Issues Found

### Component: SecondaryButton.vue
**Issue**: Color contrast slightly below WCAG AA
**Severity**: ⚠️ Warning
**Fix**: Adjust --color-secondary-600 for better contrast

[List any other issues]

---

## 🤖 Auto-Fixed Issues

Automatically corrected across all components:

1. **Missing TypeScript types** (3 components)
   - Added proper interface definitions
   
2. **Hardcoded spacing** (2 components)
   - Converted to Tailwind utilities

3. **Inconsistent naming** (1 component)
   - Standardized prop names

---

## 📸 Visual Changes Detected

**Components with visual changes**: 3/[N]

### PrimaryButton.vue
![Before](screenshots/baselines/PrimaryButton-before.png)
![After](screenshots/PrimaryButton-after.png)
**Diff**: 2.3% pixel change (acceptable)

### SecondaryButton.vue  
![Before](screenshots/baselines/SecondaryButton-before.png)
![After](screenshots/SecondaryButton-after.png)
**Diff**: 15.7% pixel change ⚠️ (review required)

---

## 🎯 Action Items

### Immediate:
1. [ ] Review SecondaryButton visual changes (15.7% diff)
2. [ ] Fix color contrast issue in SecondaryButton

### Follow-up:
1. [ ] Update component documentation
2. [ ] Update visual regression baselines if changes approved
3. [ ] Deploy to staging for testing

---

## 🚀 Next Steps

**If all changes look good:**
```bash
# Update baselines for visual regression
/ui-visual-regression --update-baselines
```

**To document changes:**
```bash
# Update documentation for modified components
/ui-document [pattern]
```

**To rollback if needed:**
```bash
git checkout HEAD -- [file-list]
```

---

## 📈 Comparison

**Before Batch Update:**
- Average Score: 88.3/100
- Token Compliance: 87%
- A11y Issues: 5

**After Batch Update:**
- Average Score: 93.6/100 (+5.3)
- Token Compliance: 100% (+13%)
- A11y Issues: 1 (-4)

**Success Rate**: 94% (X/N components improved)
\```

## Batch Update Strategies

### Strategy 1: Token Migration
Update design tokens across multiple components:
- Search: All color values
- Replace: With CSS custom properties
- Validate: 100% token compliance

### Strategy 2: API Changes
Add/remove props consistently:
- Identify: All affected components
- Update: Prop interfaces
- Validate: TypeScript compilation

### Strategy 3: Accessibility Improvements
Enhance a11y across component set:
- Add: ARIA labels
- Improve: Keyboard navigation
- Validate: WCAG compliance

### Strategy 4: Performance Optimization
Apply optimizations systematically:
- Add: v-memo directives
- Optimize: Computed properties
- Validate: Performance metrics

## Safety Features

### Pre-Update Checks
✅ Backup current state (git status check)
✅ Component count confirmation
✅ Change description review
✅ User approval required

### During Update
✅ Individual component validation
✅ Real-time progress tracking
✅ Auto-fix application
✅ Error recovery

### Post-Update
✅ Comprehensive quality report
✅ Visual regression testing
✅ Issue documentation
✅ Rollback instructions

## Progress Tracking

Real-time progress indicators:

```
[1/10] ✅ PrimaryButton.vue (96/100)
[2/10] ⏳ SecondaryButton.vue (analyzing...)
[3/10] ⏸️  Pending...
[4/10] ⏸️  Pending...
```

Show:
- Current component being processed
- Quality score after update
- Overall completion percentage
- Estimated time remaining

## Handling Failures

If a component update fails:

1. **Log Error**: Detailed error message and stack trace
2. **Skip Component**: Continue with remaining components
3. **Report Issue**: Include in final report
4. **Suggest Fix**: Provide manual intervention steps

## Validation Thresholds

Components must meet these standards post-update:

- **Quality Score**: ≥ 85/100 (or fail update)
- **Token Compliance**: 100% (or auto-fix)
- **TypeScript**: Zero errors (or fail update)
- **Accessibility**: No critical violations (or warn)

## Time Estimates

Per component:
- Analysis: 1 minute
- Update: 2-3 minutes
- Validation: 1-2 minutes
- **Total: 4-6 minutes per component**

For 10 components: 40-60 minutes
For 50 components: 3-5 hours (consider batching)

## Best Practices

### DO:
✅ **Test on small batch first** - Verify approach works
✅ **Review changes** - Don't blindly apply
✅ **Update in git branch** - Easy rollback
✅ **Run visual regression** - Catch visual breaks
✅ **Update documentation** - Keep docs in sync

### DON'T:
❌ **Update without backup** - Always commit first
❌ **Skip validation** - Quality matters
❌ **Ignore warnings** - Address issues promptly
❌ **Update too many at once** - Max 50 components
❌ **Deploy without testing** - Test on staging first

## Example Scenarios

### Scenario 1: Token Migration
```bash
/ui-batch-update **/*.vue Migrate all hardcoded colors to design tokens
```

### Scenario 2: Add Loading State
```bash
/ui-batch-update buttons/* Add isLoading prop with spinner
```

### Scenario 3: Accessibility Enhancement
```bash
/ui-batch-update cards/* Add ARIA labels and keyboard navigation
```

### Scenario 4: Performance Optimization
```bash
/ui-batch-update **/*List.vue Add v-memo for list rendering optimization
```

## Integration

This command uses:
- **ui-analyzer** for component discovery and analysis
- **ui-builder** for applying changes consistently
- **ui-validator** for quality checking and auto-fixes
- **ui-validator** for visual regression testing

This is the most powerful command for maintaining design system consistency across your entire component library.
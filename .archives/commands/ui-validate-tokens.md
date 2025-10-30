---
description: Validate design system token usage across all components, detect violations, and auto-fix common issues
argument-hint: [--fix] [--report]
allowed-tools: read, bash, grep, str_replace, write, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Design Token Validation

Comprehensive design system token compliance checking with automatic violation detection and fixing capabilities.

## Usage

```bash
/ui-validate-tokens
/ui-validate-tokens --fix
/ui-validate-tokens --report
/ui-validate-tokens --strict
```

**Syntax**: `/ui-validate-tokens [options]`

## Process

### Step 1: Load Design System
1. Read `src/styles/design-system.css`
2. Extract all CSS custom properties
3. Build token registry
4. Parse token relationships

### Step 2: Scan Components
1. Find all `.vue` files in `src/components/vue/`
2. Parse component templates and styles
3. Extract color, spacing, typography usage
4. Identify hardcoded values

### Step 3: Detect Violations
Check for:
- ❌ Hardcoded hex colors (e.g., `#3B82F6`)
- ❌ Hardcoded RGB values (e.g., `rgb(59, 130, 246)`)
- ❌ Inline styles (e.g., `style="color: blue"`)
- ❌ @apply directives (e.g., `@apply bg-blue-500`)
- ❌ Custom px values not in design system
- ❌ Non-standard font families
- ❌ Hardcoded shadows, borders, radii

### Step 4: Compliance Scoring
Calculate metrics:
- Overall compliance percentage
- Per-component scores
- Violation categorization
- Auto-fix coverage

### Step 5: Auto-Fix (Optional)
If `--fix` flag provided:
1. Convert hardcoded colors to tokens
2. Replace inline styles with classes
3. Remove @apply directives
4. Standardize spacing values
5. Update font references

### Step 6: Generate Report
Create detailed compliance report with:
- Executive summary
- Component-by-component breakdown
- Violation list with locations
- Fix recommendations
- Progress tracking

## Design Token Registry

### Color Tokens
```css
/* src/styles/design-system.css */
:root {
  /* Primary Colors */
  --color-primary-50: #EFF6FF;
  --color-primary-500: #3B82F6;
  --color-primary-900: #1E3A8A;
  
  /* Semantic Colors */
  --color-success: #10B981;
  --color-error: #EF4444;
  --color-warning: #F59E0B;
  
  /* Text Colors */
  --color-text-primary: #1F2937;
  --color-text-secondary: #6B7280;
}
```

### Spacing Tokens
```css
:root {
  /* Using Tailwind scale */
  --spacing-1: 0.25rem;  /* 4px */
  --spacing-4: 1rem;     /* 16px */
  --spacing-8: 2rem;     /* 32px */
}
```

### Typography Tokens
```css
:root {
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'Fira Code', monospace;
  
  --text-xs: 0.75rem;
  --text-base: 1rem;
  --text-2xl: 1.5rem;
}
```

## Violation Detection

### Pattern Matching
```typescript
// Hardcoded colors
const colorPatterns = [
  /#[0-9A-Fa-f]{6}/g,              // #3B82F6
  /rgb\(\d+,\s*\d+,\s*\d+\)/g,     // rgb(59, 130, 246)
  /rgba\(\d+,\s*\d+,\s*\d+,\s*[\d.]+\)/g,  // rgba(...)
  /hsl\(\d+,\s*\d+%,\s*\d+%\)/g,   // hsl(...)
]

// Inline styles
const inlineStylePattern = /style="[^"]*"/g

// @apply directives
const applyPattern = /@apply\s+[^;]+;/g
```

### Violation Categories

**🔴 Critical (Must Fix)**
- Hardcoded colors in templates
- Inline style attributes
- @apply directives

**🟡 Warning (Should Fix)**
- Non-standard spacing values
- Direct color names (e.g., "blue", "red")
- Hardcoded font sizes not in system

**🔵 Info (Nice to Have)**
- Could use semantic tokens instead
- Opportunity to consolidate tokens
- Missing token documentation

## Output Format

```markdown
# 🎨 Design Token Validation Report

**Project**: Socialaize
**Date**: [Timestamp]
**Components Scanned**: [N]

---

## 📊 Executive Summary

### Overall Compliance: 87%

| Category | Score | Status |
|----------|-------|--------|
| Color Tokens | 92% | ✅ Good |
| Spacing | 88% | ✅ Good |
| Typography | 95% | ⭐ Excellent |
| Shadows | 75% | ⚠️ Needs Work |
| Overall | 87% | ✅ Good |

**Target**: 95% compliance
**Gap**: 8% (needs improvement)

---

## 🔍 Violations Found: 45

### By Severity
- 🔴 Critical: 12 violations
- 🟡 Warnings: 23 violations
- 🔵 Info: 10 suggestions

### By Type
- Hardcoded Colors: 18
- Inline Styles: 8
- @apply Directives: 6
- Custom Spacing: 9
- Other: 4

---

## 🔴 Critical Violations (Must Fix)

### 1. PrimaryButton.vue
**Line 23**: Hardcoded color
```vue
<!-- ❌ VIOLATION -->
<button class="bg-blue-500">

<!-- ✅ FIX -->
<button class="bg-[var(--color-primary-500)]">
```
**Auto-fixable**: Yes

### 2. UserCard.vue
**Line 45**: Inline style attribute
```vue
<!-- ❌ VIOLATION -->
<div style="padding: 20px; color: #333">

<!-- ✅ FIX -->
<div class="p-5 text-[var(--color-text-primary)]">
```
**Auto-fixable**: Yes

### 3. Modal.vue
**Line 67**: @apply directive
```vue
<style scoped>
/* ❌ VIOLATION */
.modal {
  @apply bg-white shadow-lg;
}

/* ✅ FIX */
</style>
<template>
  <div class="bg-white shadow-lg">
</template>
```
**Auto-fixable**: Yes

[Continue for all critical violations]

---

## 🟡 Warnings (Should Fix)

### 1. Card.vue
**Line 12**: Non-standard spacing
```vue
<!-- ⚠️ WARNING -->
<div class="p-[18px]">

<!-- ✅ RECOMMENDATION -->
<div class="p-4">  <!-- 16px, standard -->
<!-- OR -->
<div class="p-5">  <!-- 20px, closer to 18px -->
```

[Continue for all warnings]

---

## 🔵 Suggestions (Nice to Have)

### 1. Multiple components using `#3B82F6`
**Recommendation**: Create semantic token
```css
/* Add to design-system.css */
--color-action: var(--color-primary-500);
```
**Affected Components**: Button.vue, Link.vue, Badge.vue

[Continue for all suggestions]

---

## 📈 Component Breakdown

| Component | Score | Critical | Warnings | Info |
|-----------|-------|----------|----------|------|
| PrimaryButton.vue | 85% | 2 | 1 | 0 |
| SecondaryButton.vue | 95% | 0 | 1 | 1 |
| UserCard.vue | 78% | 3 | 4 | 2 |
| Modal.vue | 82% | 1 | 3 | 1 |
| Badge.vue | 100% | 0 | 0 | 0 |
| ... | ... | ... | ... | ... |

**Top Performers** (100% compliance):
- Badge.vue
- IconButton.vue
- StatusIndicator.vue

**Needs Attention** (<80% compliance):
- UserCard.vue (78%)
- ProfileHeader.vue (75%)
- ActionMenu.vue (72%)

---

## 🤖 Auto-Fix Summary

**Auto-fixable violations**: 38/45 (84%)

### Fixed Automatically (with --fix)
✅ Converted 18 hardcoded colors to tokens
✅ Removed 8 inline style attributes
✅ Removed 6 @apply directives
✅ Standardized 6 spacing values

### Requires Manual Intervention
⚠️ 3 components need design token additions
⚠️ 2 components have complex custom styles
⚠️ 1 component uses non-standard patterns

---

## 📊 Token Usage Statistics

### Most Used Tokens
1. `--color-primary-500` (45 occurrences)
2. `--spacing-4` (38 occurrences)
3. `--text-base` (32 occurrences)
4. `--color-text-primary` (28 occurrences)

### Unused Tokens (Consider Removing)
- `--color-tertiary-300` (0 occurrences)
- `--spacing-11` (0 occurrences)
- `--shadow-2xl` (0 occurrences)

### Missing Tokens (Consider Adding)
- `--color-facebook` (8 hardcoded instances)
- `--color-twitter` (6 hardcoded instances)
- `--radius-button` (4 hardcoded instances)

---

## 🎯 Action Plan

### Immediate (Critical)
1. [ ] Fix 12 critical violations in 5 components
2. [ ] Run `/ui-validate-tokens --fix` for auto-fixes
3. [ ] Manually fix 7 non-auto-fixable issues

### Short Term (Warnings)
1. [ ] Standardize spacing in 9 components
2. [ ] Add missing semantic tokens
3. [ ] Update 23 warning-level issues

### Long Term (Optimization)
1. [ ] Remove 3 unused tokens
2. [ ] Consolidate similar tokens
3. [ ] Document token usage patterns

**Estimated Time**: 2-3 hours for full compliance

---

## 📈 Progress Tracking

### Historical Compliance
| Date | Score | Change |
|------|-------|--------|
| 2025-10-22 | 87% | +5% |
| 2025-10-15 | 82% | +3% |
| 2025-10-08 | 79% | +7% |
| 2025-10-01 | 72% | - |

**Trend**: Improving 📈

---

## 🚀 Next Steps

1. **Run auto-fix**: `/ui-validate-tokens --fix`
2. **Review changes**: Check git diff
3. **Test components**: Ensure visual consistency
4. **Update documentation**: Document new tokens
5. **Re-validate**: Run again to confirm 95%+ compliance

**Goal**: Reach 95%+ compliance within 2 weeks
\```

## Options

### --fix
Automatically fix violations:
```bash
/ui-validate-tokens --fix
```
Applies safe auto-fixes to all components.

### --report
Generate detailed HTML report:
```bash
/ui-validate-tokens --report
```
Creates `reports/token-compliance.html`.

### --strict
Enforce stricter rules:
```bash
/ui-validate-tokens --strict
```
Flags even minor deviations.

### --component [path]
Check specific component only:
```bash
/ui-validate-tokens --component Button.vue
```

## Auto-Fix Rules

### Rule 1: Hex to Token
```typescript
// Pattern: #3B82F6 → var(--color-primary-500)
const colorMap = {
  '#3B82F6': '--color-primary-500',
  '#10B981': '--color-success',
  '#EF4444': '--color-error',
}
```

### Rule 2: Inline to Class
```typescript
// style="padding: 20px" → class="p-5"
const spacingMap = {
  '4px': '1',
  '16px': '4',
  '20px': '5',
  '32px': '8',
}
```

### Rule 3: Remove @apply
```typescript
// @apply bg-white → class="bg-white"
// Move from <style> to template
```

## CI/CD Integration

### Pre-commit Hook
```bash
# .husky/pre-commit
#!/bin/sh
npm run validate:tokens

# Fail commit if compliance < 95%
if [ $? -ne 0 ]; then
  echo "❌ Token compliance below 95%"
  exit 1
fi
```

### GitHub Action
```yaml
name: Token Compliance

on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm run validate:tokens
      - name: Comment PR
        uses: actions/github-script@v6
        with:
          script: |
            // Post compliance report to PR
```

## Best Practices

### DO:
✅ **Run regularly** - Weekly audits
✅ **Fix incrementally** - Don't batch too many changes
✅ **Document tokens** - Keep token guide updated
✅ **Review auto-fixes** - Don't blindly apply
✅ **Track progress** - Monitor compliance over time

### DON'T:
❌ **Ignore warnings** - They compound over time
❌ **Add tokens arbitrarily** - Plan token system
❌ **Skip validation** - Make it part of workflow
❌ **Override with !important** - Fix properly
❌ **Use inline styles** - Always use classes

## Time Estimate

- Scan components: 1-2 minutes
- Analyze violations: 2-3 minutes
- Generate report: 1-2 minutes
- Auto-fix: 3-5 minutes
- **Total: 7-12 minutes**

## Integration

This command uses:
- **ui-analyzer** subagent for token extraction
- **ui-validator** for compliance scoring
- **ui-builder** for auto-fix application

Essential for:
- Design system consistency
- Code quality maintenance
- Preventing technical debt
- Enforcing standards

Keep your design system clean and consistent.
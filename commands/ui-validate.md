---
description: Design system compliance auditing with token validation, accessibility checks, and auto-fix
argument-hint: [--tokens] [--a11y] [--all] [--fix]
allowed-tools: read, bash, grep, str_replace, write, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 23, 2025
Comprehensive design system validation
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Design System Validation

Comprehensive auditing of design system compliance, token usage, and accessibility across all components.

## Usage

```bash
/ui-validate
/ui-validate --tokens
/ui-validate --a11y
/ui-validate --all --fix
```

**Syntax**: `/ui-validate [--flags]`

## Flags

- `--tokens` - Token compliance audit only (colors, spacing, typography)
- `--a11y` - Accessibility audit only (WCAG compliance, keyboard nav, ARIA)
- `--all` - Full audit: tokens + accessibility + quality (default)
- `--fix` - Automatically fix violations where possible

## Validation Process

### Step 1: Load Design System
1. Read `src/styles/design-system.css`
2. Extract all CSS custom properties (300+ tokens)
3. Build token registry
4. Parse token relationships

### Step 2: Scan Components
1. Find all `.vue` files in `src/components/vue/`
2. Parse component templates and styles
3. Extract color, spacing, typography usage
4. Identify hardcoded values

### Step 3: Token Compliance (if --tokens or --all)
Check for:
- ❌ Hardcoded hex colors (e.g., `#3B82F6`)
- ❌ Hardcoded RGB values (e.g., `rgb(59, 130, 246)`)
- ❌ Inline styles (e.g., `style="color: blue"`)
- ❌ @apply directives (e.g., `@apply bg-blue-500`)
- ❌ Custom px values not in design system
- ❌ Non-standard font families
- ❌ Hardcoded shadows, borders, radii

### Step 4: Accessibility Audit (if --a11y or --all)
Check for:
- ❌ Missing ARIA labels on interactive elements
- ❌ Insufficient color contrast (<4.5:1 for text, <3:1 for UI)
- ❌ Missing keyboard navigation support
- ❌ Touch targets smaller than 44x44px
- ❌ Missing focus indicators
- ❌ Incorrect semantic HTML usage
- ❌ Missing alt text for images

### Step 5: Quality Scoring (if --all)
Calculate metrics:
- Overall compliance percentage
- Per-component scores
- Violation categorization
- Auto-fix coverage

### Step 6: Auto-Fix (if --fix flag)
Automatically fix:
1. Convert hardcoded colors to tokens
2. Replace inline styles with classes
3. Remove @apply directives
4. Standardize spacing values
5. Update font references
6. Add missing ARIA labels

### Step 7: Generate Report
Create detailed compliance report with:
- Executive summary
- Component-by-component breakdown
- Violation list with locations
- Fix recommendations
- Progress tracking

## Output Format

```markdown
# 🎨 Design System Validation Report

**Project**: Socialaize
**Date**: [Timestamp]
**Scope**: [Tokens | A11y | All]
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
| Accessibility | 90% | ✅ Good |
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
- Accessibility Issues: 9
- Custom Spacing: 4

---

## 🔴 Critical Violations (Must Fix)

### 1. PrimaryButton.vue (Line 23)
**Issue**: Hardcoded color
```vue
<!-- ❌ VIOLATION -->
<button class="bg-blue-500">

<!-- ✅ FIX -->
<button class="bg-[var(--color-primary-500)]">
```
**Auto-fixable**: Yes
**Impact**: Design system inconsistency

### 2. UserCard.vue (Line 45)
**Issue**: Inline style attribute
```vue
<!-- ❌ VIOLATION -->
<div style="padding: 20px; color: #333">

<!-- ✅ FIX -->
<div class="p-5 text-[var(--color-text-primary)]">
```
**Auto-fixable**: Yes
**Impact**: Maintenance burden

### 3. Modal.vue (Line 67)
**Issue**: @apply directive
```vue
<style scoped>
/* ❌ VIOLATION */
.modal {
  @apply bg-white shadow-lg;
}
</style>

<!-- ✅ FIX: Move to template -->
<template>
  <div class="bg-white shadow-lg">
  </div>
</template>
```
**Auto-fixable**: Yes
**Impact**: Build performance

[Continue for all critical violations]

---

## 🟡 Warnings (Should Fix)

### 1. Card.vue (Line 12)
**Issue**: Non-standard spacing
```vue
<!-- ⚠️ WARNING -->
<div class="p-[18px]">

<!-- ✅ RECOMMENDATION -->
<div class="p-4">  <!-- 16px, standard -->
<!-- OR -->
<div class="p-5">  <!-- 20px, closer to 18px -->
```
**Auto-fixable**: Partially (suggest alternatives)

### 2. IconButton.vue (Line 34)
**Issue**: Missing ARIA label
```vue
<!-- ⚠️ WARNING -->
<button @click="handleClick">
  <Icon icon="mdi:close" />
</button>

<!-- ✅ FIX -->
<button @click="handleClick" aria-label="Close">
  <Icon icon="mdi:close" />
</button>
```
**Auto-fixable**: Yes (add aria-label)

[Continue for all warnings]

---

## ♿ Accessibility Report (if --a11y or --all)

**WCAG Level**: AA (some AAA violations)

### Compliance Status
- ✅ Keyboard Navigation: 92% compliant
- ⚠️ Color Contrast: 85% compliant (15% below 4.5:1)
- ✅ ARIA Labels: 90% compliant
- ⚠️ Touch Targets: 88% compliant (12% below 44x44px)
- ✅ Focus Indicators: 95% compliant
- ✅ Semantic HTML: 98% compliant

### Critical A11y Issues
1. **SearchInput.vue** - Color contrast 3.2:1 (needs 4.5:1)
2. **Dropdown.vue** - Missing keyboard navigation (arrow keys)
3. **IconButton.vue** - Touch target 40x40px (needs 44x44px)
4. **Modal.vue** - Missing focus trap on open

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
- `--color-facebook` (8 hardcoded instances: #1877F2)
- `--color-twitter` (6 hardcoded instances: #1DA1F2)
- `--radius-button` (4 hardcoded instances: 0.375rem)

---

## 🤖 Auto-Fix Summary

**Auto-fixable violations**: 38/45 (84%)

### Fixed Automatically (with --fix flag)
✅ Converted 18 hardcoded colors to tokens
✅ Removed 8 inline style attributes
✅ Removed 6 @apply directives
✅ Standardized 6 spacing values
✅ Added 9 missing ARIA labels

### Requires Manual Intervention
⚠️ 3 components need new design tokens
⚠️ 2 components have complex custom styles
⚠️ 2 components need architectural refactoring

---

## 📈 Component Breakdown

| Component | Score | Critical | Warnings | Info |
|-----------|-------|----------|----------|------|
| PrimaryButton.vue | 85% | 2 | 1 | 0 |
| SecondaryButton.vue | 95% | 0 | 1 | 1 |
| UserCard.vue | 78% | 3 | 4 | 2 |
| Modal.vue | 82% | 1 | 3 | 1 |
| Badge.vue | 100% | 0 | 0 | 0 |

**Top Performers** (100% compliance):
- Badge.vue
- IconButton.vue (after fixes)
- StatusIndicator.vue

**Needs Attention** (<80% compliance):
- UserCard.vue (78%)
- ProfileHeader.vue (75%)
- ActionMenu.vue (72%)

---

## 🎯 Action Plan

### Immediate (Critical - Fix Now)
1. [ ] Fix 12 critical violations in 5 components
2. [ ] Run `/ui-validate --fix` for auto-fixes
3. [ ] Manually fix 7 non-auto-fixable issues

### Short Term (Warnings - This Week)
1. [ ] Standardize spacing in 9 components
2. [ ] Add missing semantic tokens (--color-facebook, etc.)
3. [ ] Update 23 warning-level issues
4. [ ] Improve color contrast in 8 components

### Long Term (Optimization - This Month)
1. [ ] Remove 3 unused tokens
2. [ ] Consolidate similar tokens
3. [ ] Document token usage patterns
4. [ ] Establish pre-commit validation hook

**Estimated Time**: 2-3 hours for full compliance

---

## 📈 Progress Tracking

### Historical Compliance
| Date | Score | Change |
|------|-------|--------|
| 2025-10-23 | 87% | +5% |
| 2025-10-15 | 82% | +3% |
| 2025-10-08 | 79% | +7% |
| 2025-10-01 | 72% | - |

**Trend**: Improving 📈

---

## 🚀 Next Steps

**To fix violations:**
```bash
# Auto-fix all fixable issues
/ui-validate --fix

# Review changes
git diff

# Validate again
/ui-validate
```

**After fixes:**
```bash
# Update specific components
/ui-review ComponentName.vue --fix

# Capture updated screenshots
/ui-screenshot ComponentName.vue --compare
```

**Goal**: Reach 95%+ compliance within 2 weeks
```

## Example Usage

```bash
# Full audit (default)
/ui-validate

# Token compliance only
/ui-validate --tokens

# Accessibility only
/ui-validate --a11y

# Full audit with auto-fix
/ui-validate --all --fix

# Token audit with auto-fix
/ui-validate --tokens --fix
```

## Validation Scope

### --tokens Scope
- Color usage (hex, rgb, named colors)
- Spacing values (padding, margin, gap)
- Typography (font-family, font-size, line-height)
- Shadows and borders
- Border radius values
- Z-index values

### --a11y Scope
- ARIA attributes (labels, roles, live regions)
- Keyboard navigation (tab order, key handlers)
- Color contrast ratios
- Touch target sizes
- Focus indicators
- Semantic HTML
- Screen reader compatibility
- Alternative text for images

### --all Scope
Everything in --tokens + --a11y + additional quality checks

## Auto-Fix Rules

### Color Token Mapping
```typescript
const colorMap = {
  '#3B82F6': '--color-primary-500',
  '#10B981': '--color-success',
  '#EF4444': '--color-error',
  '#F59E0B': '--color-warning',
  'rgb(59, 130, 246)': '--color-primary-500',
}
```

### Spacing Standardization
```typescript
const spacingMap = {
  '4px': 'p-1',
  '8px': 'p-2',
  '16px': 'p-4',
  '20px': 'p-5',
  '32px': 'p-8',
}
```

### ARIA Label Patterns
```typescript
// Icon buttons → aria-label
<button><Icon icon="close" /></button>
→ <button aria-label="Close"><Icon icon="close" /></button>

// Links without text → aria-label
<a href="/"><Icon icon="home" /></a>
→ <a href="/" aria-label="Home"><Icon icon="home" /></a>
```

## Time Estimate

- Component scan: 1-2 minutes
- Violation analysis: 2-3 minutes
- Report generation: 1-2 minutes
- Auto-fix (if --fix): 3-5 minutes
- **Total: 7-12 minutes**

## Integration

This command uses:
- **ui-analyzer** for token extraction and pattern detection
- **ui-validator** for compliance scoring and accessibility checks
- **ui-builder** for auto-fix application

Essential for:
- Design system consistency
- Accessibility compliance
- Code quality maintenance
- Pre-commit validation
- Technical debt prevention

Keep your design system clean, consistent, and accessible.

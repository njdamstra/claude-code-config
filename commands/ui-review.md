---
description: Comprehensive quality review with auto-fix, polish enhancements, and token validation
argument-hint: [component-path] [--fix] [--polish]
allowed-tools: read, view, bash, grep, str_replace, edit
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Review

Perform comprehensive quality analysis on an existing component using the ui-validator subagent.

## Usage

```bash
/ui-review src/components/vue/buttons/PrimaryButton.vue
/ui-review UserCard.vue --fix
/ui-review PrimaryButton.vue --polish
/ui-review Modal.vue --fix --polish
```

**Syntax**: `/ui-review [component-path] [--flags]`

## Flags

- `--fix` - Automatically fix detected issues (hardcoded colors, missing types, etc.)
- `--polish` - Apply professional polish enhancements (hover states, transitions, depth)

## Review Process

Analyze the component at: $ARGUMENTS

### 1. Code Analysis
- Read component file
- Parse structure and patterns
- Identify all props, events, slots
- Check TypeScript usage
- Review composition patterns

### 2. Quality Scoring (10 Criteria)
Score each aspect 0-10:

1. **TypeScript Compliance** - Type definitions, no `any`
2. **Design Token Usage** - CSS custom properties, no hardcoded values
3. **Accessibility** - WCAG compliance, ARIA, keyboard nav
4. **Code Structure** - Clean composition, separation of concerns
5. **Performance** - Optimizations, memoization, lazy loading
6. **Error Handling** - Comprehensive, graceful degradation
7. **Reusability** - Generic, flexible, composable
8. **Documentation** - JSDoc, prop descriptions, examples
9. **Test Coverage** - Unit tests, integration tests
10. **Visual Polish** - Consistent spacing, alignment, responsive

**Total: /100**

### 3. Compliance Checks (Enhanced Token Validation)
- ✅ Design system tokens (0 hardcoded values)
- ✅ Tailwind utilities only (no @apply, no inline styles)
- ✅ Type-only props (no runtime validation)
- ✅ Semantic HTML
- ✅ ARIA labels where needed
- ✅ Token compliance percentage calculated
- ✅ Hardcoded hex/rgb colors detected
- ✅ Inline style violations flagged

### 4. Issue Detection
Categorize issues by severity:

**🔴 Critical (Must Fix)**
- TypeScript errors
- Accessibility violations (WCAG A violations)
- Security vulnerabilities
- Broken functionality

**🟡 Warnings (Should Fix)**
- Code structure issues
- Missing error handling
- Performance concerns
- WCAG AA violations

**🔵 Suggestions (Nice to Have)**
- Code style improvements
- Enhanced documentation
- Additional features
- WCAG AAA enhancements

### 5. Auto-Fix Analysis (Applied if --fix flag)
Automatically fix these issues:
- Missing TypeScript types → Add interfaces
- Hardcoded colors (#3B82F6) → Convert to tokens (var(--color-primary-500))
- Inline styles (style="padding: 20px") → Convert to Tailwind (class="p-5")
- Runtime props → Convert to type-only defineProps<{}>
- Missing ARIA → Add aria-label attributes

### 6. Polish Enhancements (Applied if --polish flag)
Automatically apply professional touches:
- **Interactive States**: Add missing hover/focus/active states
- **Motion**: Add transitions with proper duration/easing
- **Depth**: Convert borders to shadows + color layering
- **Typography**: Fix font scale, weights, line heights
- **Spacing**: Standardize to spacing scale

## Output Format

```markdown
# 🔍 Component Review: [ComponentName]

**File**: `$ARGUMENTS`
**Date**: [Current Date]
**Reviewer**: ui-validator subagent

---

## 📊 Quality Score: XX/100

### Score Breakdown
| Criterion | Score | Status |
|-----------|-------|--------|
| TypeScript Compliance | X/10 | [emoji] |
| Design Token Usage | X/10 | [emoji] |
| Accessibility | X/10 | [emoji] |
| Code Structure | X/10 | [emoji] |
| Performance | X/10 | [emoji] |
| Error Handling | X/10 | [emoji] |
| Reusability | X/10 | [emoji] |
| Documentation | X/10 | [emoji] |
| Test Coverage | X/10 | [emoji] |
| Visual Polish | X/10 | [emoji] |
| **TOTAL** | **XX/100** | **[Grade]** |

**Grade Interpretation:**
- 95-100: ⭐ Excellent (Production Ready)
- 85-94: ✅ Very Good (Minor Improvements)
- 70-84: ⚠️ Good (Needs Refinement)
- <70: ❌ Needs Significant Work

---

## ✅ Strengths

- [List 3-5 positive aspects of the component]
- Well-structured composition API usage
- Comprehensive TypeScript typing
- [More strengths...]

---

## 🔴 Critical Issues (Must Fix)

### 1. [Issue Title]
**Line**: [Line number or range]
**Impact**: High
**Description**: [Detailed description of the issue]
**Fix**:
```typescript
// Before
[problematic code]

// After
[fixed code]
\```

[Continue for all critical issues]

---

## 🟡 Warnings (Should Fix)

### 1. [Issue Title]
**Line**: [Line number]
**Impact**: Medium
**Description**: [Description]
**Recommendation**: [How to fix]

[Continue for all warnings]

---

## 🔵 Suggestions (Nice to Have)

1. **[Suggestion Title]**
   - **Benefit**: [Why this would help]
   - **How**: [Implementation approach]

[Continue for all suggestions]

---

## 🤖 Auto-Fixable Issues

The following issues can be automatically corrected:

✅ **Fixed Automatically:**
1. Converted 3 hardcoded colors to design tokens
2. Added missing TypeScript interface for Props
3. Replaced inline styles with Tailwind classes
4. Added ARIA labels for icon buttons

💡 **Can Be Auto-Fixed** (run `/ui-fix` to apply):
1. Convert runtime prop validation to type-only
2. Add JSDoc comments for public methods
3. Optimize computed properties

---

## ♿ Accessibility Report

**WCAG Level**: [A | AA | AAA | Non-Compliant]

### Compliance Status
- ✅ Keyboard Navigation: Full support (Tab, Enter, Space, Arrows)
- ✅ Screen Reader: Compatible with ARIA labels
- ⚠️ Color Contrast: 3.8:1 (needs improvement to 4.5:1)
- ✅ Touch Targets: All ≥44x44px
- ✅ Focus Indicators: Visible and distinct

### Issues Found
1. [Accessibility issue with line number]
2. [Another issue]

### Recommendations
1. [How to fix accessibility issues]

---

## 🎨 Design System Compliance

**Token Usage**: [XX]%

### Compliant Areas
- ✅ All colors use design tokens
- ✅ Spacing uses Tailwind scale
- ✅ Typography uses system fonts

### Violations
- ❌ Line 45: Hardcoded `#3B82F6` → should be `var(--color-primary-500)`
- ❌ Line 67: Inline `style="padding: 20px"` → should be `p-5`

---

## ⚡ Performance Analysis

### Optimizations Present
- ✅ Computed properties for reactive classes
- ✅ v-memo for list rendering
- ✅ Proper key usage in v-for

### Opportunities
- 💡 Consider lazy loading for [heavy feature]
- 💡 Could memoize [expensive computation]

---

## 📚 Documentation Status

**Coverage**: [Percentage]

### Present
- ✅ JSDoc comments for component
- ✅ Prop type definitions

### Missing
- ❌ Usage examples
- ❌ Event documentation
- ❌ Slot documentation

---

## 🔄 Comparison to Standards

| Metric | This Component | Project Average | Target |
|--------|---------------|-----------------|--------|
| Quality Score | XX/100 | 89/100 | 95/100 |
| Token Compliance | XX% | 92% | 100% |
| A11y Level | AA | AA | AAA |
| Test Coverage | X% | 85% | 90% |

---

## 🎯 Action Items (Prioritized)

### High Priority (Do Now)
1. [ ] Fix critical accessibility issue on line X
2. [ ] Convert hardcoded colors to tokens
3. [ ] Add missing error handling

### Medium Priority (Do Soon)
1. [ ] Improve TypeScript types
2. [ ] Add JSDoc comments
3. [ ] Optimize performance

### Low Priority (Nice to Have)
1. [ ] Enhance documentation
2. [ ] Add advanced features
3. [ ] Increase test coverage

---

## 🚀 Next Steps

**If issues found:**
```bash
# Auto-fix detected issues
/ui-review ComponentName.vue --fix

# Apply polish enhancements
/ui-review ComponentName.vue --polish

# Do both
/ui-review ComponentName.vue --fix --polish
```

**After fixes:**
```bash
# Capture updated screenshot
/ui-screenshot ComponentName.vue --compare

# Update documentation
/ui-document ComponentName.vue

# Revalidate
/ui-review ComponentName.vue
```

**Estimated Time to Fix**: [X] hours
**Priority Level**: [High | Medium | Low]
\```

## Review Categories

The review focuses on these key areas:

### Code Quality
- TypeScript usage
- Code organization
- Naming conventions
- Error handling
- Best practices

### Design System
- Token compliance
- Tailwind usage
- No hardcoded values
- Consistent patterns

### Accessibility
- WCAG compliance
- Keyboard navigation
- Screen reader support
- Focus management
- Color contrast

### Performance
- Rendering optimization
- Memoization
- Lazy loading
- Bundle size

### Maintainability
- Code clarity
- Documentation
- Reusability
- Test coverage

## Time Estimate

- Component reading: 1-2 minutes
- Quality scoring: 2-3 minutes
- Issue detection: 2-3 minutes
- Report generation: 1-2 minutes
- **Total: 6-10 minutes**

## Integration

Use this command:
- **After**: Creating or modifying components
- **Before**: Committing code changes
- **During**: Code review process
- **For**: Quality assurance

Can trigger:
- `/ui-fix` - Apply auto-fixes
- `/ui-visual-regression` - Test visual changes
- `/ui-document` - Update documentation

This command provides objective, actionable feedback to improve component quality.
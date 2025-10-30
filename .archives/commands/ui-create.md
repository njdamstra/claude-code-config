---
description: Full component creation pipeline - plan, analyze, generate 3 variants, refine, validate, screenshot
argument-hint: [component description]
allowed-tools: read, write, bash, grep, str_replace, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Creation Pipeline

Complete workflow for creating production-ready Vue 3 components with planning, generation, refinement, and validation.

## Full Pipeline

Execute this complete workflow for: $ARGUMENTS

### Step 1: Planning (ui-analyzer)
1. Search for existing similar components
2. Analyze design requirements  
3. Create implementation plan
4. **WAIT FOR USER APPROVAL** before proceeding

### Step 2: Generation (ui-builder)
1. Generate 3 component variants:
   - **Variant 1**: Minimal & Elegant
   - **Variant 2**: Feature-Rich
   - **Variant 3**: Accessible & Optimized
2. Present all variants to user
3. **WAIT FOR USER TO CHOOSE** preferred variant

### Step 3: Refinement (ui-builder)
Execute 2 refinement rounds on chosen variant:

**Round 1 - Polish** (2-3 minutes):
- Improve TypeScript types
- Enhance code structure
- Polish class naming
- Add helpful comments
- Improve prop interfaces

**Round 2 - Performance & Accessibility** (2-3 minutes):
- Add v-memo for expensive lists
- Verify ARIA labels complete
- Test keyboard navigation
- Check color contrast
- Optimize computed properties
- Add performance optimizations

### Step 4: Validation (ui-validator)
1. Run quality scoring (10 criteria)
2. Check design system compliance
3. Validate accessibility (WCAG AAA)
4. Auto-fix common issues
5. Report any blocking issues

### Step 5: Screenshot (ui-validator)
1. Set up component preview page
2. Capture screenshot with Playwright
3. Save to `screenshots/` directory
4. Show screenshot to user

### Step 6: Documentation (ui-documenter) [OPTIONAL]
Generate component documentation if requested

## Workflow Output Format

```markdown
# 🎨 Component Creation: [ComponentName]

## Step 1: ✅ Planning Complete

[Show planning output from ui-analyzer]

**Approval Required**: Proceed with generation? (yes/no)

---

## Step 2: ✅ Generated 3 Variants

### Variant 1: Minimal & Elegant
[Show code]

### Variant 2: Feature-Rich  
[Show code]

### Variant 3: Accessible & Optimized
[Show code]

**Selection Required**: Which variant? (1, 2, or 3)

---

## Step 3: ✅ Refinement Complete

### Round 1 - Polish
**Changes made:**
- Improved TypeScript types for Props
- Enhanced computed class composition
- Added descriptive comments
- [List other improvements]

### Round 2 - Performance & A11y
**Changes made:**
- Added v-memo for list optimization
- Completed all ARIA labels
- Verified 4.5:1 contrast ratio
- Optimized computed properties
- [List other improvements]

**Final Code:**
```vue
[Show refined component]
\```

---

## Step 4: ✅ Validation Complete

**Quality Score: 95/100** ⭐

**Breakdown:**
- TypeScript: 10/10
- Design Tokens: 10/10
- Accessibility: 9/10
- Code Structure: 10/10
- Performance: 10/10
- Error Handling: 9/10
- Reusability: 10/10
- Documentation: 8/10
- Test Coverage: 9/10
- Visual Polish: 10/10

**Issues:**
- ⚠️ Minor: Missing JSDoc for helper function
- ✅ Auto-fixed: 3 hardcoded colors → design tokens

---

## Step 5: ✅ Screenshot Captured

![ComponentName Screenshot](screenshots/ComponentName.png)

**File**: `src/components/vue/{category}/ComponentName.vue`

---

## ✅ COMPLETE - Production Ready!

**Summary:**
- Created: ComponentName.vue
- Quality: 95/100
- Accessibility: WCAG AAA
- Performance: Optimized
- Status: Ready to ship 🚀

**Next Steps:**
- Import and use in your pages
- Run visual regression: `/ui-visual-regression`
- Generate docs: `/ui-document ComponentName`
\```

## Command Behavior

- **Automatic**: Runs all steps in sequence
- **Interactive**: Waits for approval at key points
- **Verbose**: Shows progress for each step
- **Complete**: Delivers production-ready code

## Example Usage

```bash
/ui-create Badge with status colors
/ui-create User profile card with avatar and actions
/ui-create Modal dialog with form validation
/ui-create Search input with autocomplete
```

## Success Criteria

Component is complete when:
- ✅ Quality score ≥ 95/100
- ✅ Zero blocking issues
- ✅ WCAG AAA compliant
- ✅ Screenshot captured
- ✅ All tokens from design system
- ✅ TypeScript strict mode passing

## Time Estimate

- Planning: 2-3 minutes
- Generation: 3-4 minutes
- Refinement: 4-6 minutes (2 rounds)
- Validation: 2-3 minutes
- Screenshot: 1-2 minutes
- **Total: 12-18 minutes per component**

This workflow ensures every component meets production quality standards before deployment.
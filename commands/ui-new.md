---
description: Complete component creation workflow - plan with wireframes, generate 3 variants, refine, validate, screenshot
argument-hint: [component description]
allowed-tools: read, write, bash, grep, str_replace, view
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 23, 2025
Enhanced with wireframing workflow and flexible planning
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Creation Pipeline

Complete workflow for creating production-ready Vue 3 components with optional planning, wireframing, generation, refinement, and validation.

## Usage

```bash
/ui-new Badge component with status colors
/ui-new User profile card --skip-plan
/ui-new Modal dialog --variants 5
/ui-new Search input --skip-plan --screenshot
```

**Syntax**: `/ui-new [component description] [--flags]`

## Flags

- `--skip-plan` - Skip planning/wireframing, jump straight to generation
- `--variants N` - Generate N variants (default: 3)
- `--skip-validation` - Skip quality validation
- `--screenshot` - Capture screenshot after generation

## Full Pipeline

Execute this complete workflow for: $ARGUMENTS

### Step 0: Planning (Default - Skip with --skip-plan)

**ui-analyzer** creates strategic plan with wireframes:

1. **Search for existing similar components**
2. **Analyze design requirements**
3. **Generate ASCII wireframes** (2-3 layout options)
4. **Create implementation plan**
5. **WAIT FOR USER APPROVAL** before proceeding

**Wireframe Example:**
```
OPTION 1: Badge with Icon
┌────────────────┐
│ [icon] Label   │
└────────────────┘

OPTION 2: Badge Stacked
┌──────┐
│ Icon │
│Label │
└──────┘
```

User selects preferred wireframe → Proceed with generation

### Step 1: Generation (ui-builder)

1. Generate N component variants (default: 3):
   - **Variant 1**: Minimal & Elegant
   - **Variant 2**: Feature-Rich
   - **Variant 3**: Accessible & Optimized
2. Present all variants to user
3. **WAIT FOR USER TO CHOOSE** preferred variant

### Step 2: Refinement (ui-builder)

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

### Step 3: Validation (ui-validator) [Optional - Skip with --skip-validation]

1. Run quality scoring (10 criteria)
2. Check design system compliance
3. Validate accessibility (WCAG AAA)
4. Auto-fix common issues
5. Report any blocking issues

### Step 4: Screenshot (ui-validator) [Optional - Use --screenshot flag]

1. Set up component preview page
2. Capture screenshot with Playwright
3. Save to `screenshots/` directory
4. Show screenshot to user

### Step 5: Documentation (ui-documenter) [OPTIONAL]

Generate component documentation if requested

## Workflow Output Format

```markdown
# 🎨 Component Creation: [ComponentName]

## Step 0: ✅ Planning Complete (unless --skip-plan)

### Wireframes Generated

**Option 1: Horizontal Layout**
```
┌─────────────────────────────────────┐
│ [Icon] Title           [Actions]    │
└─────────────────────────────────────┘
```

**Option 2: Vertical Layout**
```
┌──────────────┐
│    [Icon]    │
│    Title     │
│   [Action]   │
└──────────────┘
```

**Selected**: Option 1 (Horizontal)

---

## Step 1: ✅ Generated 3 Variants

### Variant 1: Minimal & Elegant
[Show code]

### Variant 2: Feature-Rich
[Show code]

### Variant 3: Accessible & Optimized
[Show code]

**Selection Required**: Which variant? (1, 2, or 3)

---

## Step 2: ✅ Refinement Complete

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
```

---

## Step 3: ✅ Validation Complete (if not --skip-validation)

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

## Step 4: ✅ Screenshot Captured (if --screenshot)

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
- Run visual regression: `/ui-screenshot --compare`
- Generate docs: `/ui-document ComponentName`
```

## Command Behavior

### Default (with Planning):
```bash
/ui-new Badge with status colors
```
→ Plan with wireframes → User approves → Generate 3 variants → Refine → Validate

### Skip Planning:
```bash
/ui-new Badge with status colors --skip-plan
```
→ Generate 3 variants → Refine → Validate (no planning phase)

### Custom Variants:
```bash
/ui-new Badge with status colors --variants 5
```
→ Plan → Generate 5 variants → Refine → Validate

### Fast Track:
```bash
/ui-new Badge --skip-plan --skip-validation --screenshot
```
→ Generate 3 variants → Refine → Screenshot (fastest path)

## Wireframing in Planning Phase

When planning is enabled (default), ui-analyzer generates ASCII wireframes showing:

### Layout Options
- Horizontal vs Vertical arrangements
- Icon placement options
- Content organization
- Interactive element positioning

### Responsive Transformations
- Desktop layout
- Mobile transformation
- Breakpoint considerations

### Component States
- Default state
- Hover/active states
- Loading states
- Error states

**Example Wireframe Output:**
```
Desktop (1280px+):
┌─────────────────────────────────────┐
│ Header                [Actions]     │
├────────┬────────────────────────────┤
│        │                            │
│ Side   │   Main Content Area        │
│ Nav    │   ┌──────────────────┐     │
│        │   │  Card            │     │
│ [opt]  │   │  - Title         │     │
│ [opt]  │   │  - Content       │     │
│ [opt]  │   └──────────────────┘     │
│        │                            │
└────────┴────────────────────────────┘

Mobile Transform (< 768px):
┌──────────────┐
│ Header       │
├──────────────┤
│ [≡ Menu]     │
├──────────────┤
│ Content      │
│ ┌──────────┐ │
│ │ Card     │ │
│ └──────────┘ │
└──────────────┘
```

User selects preferred layout → Implementation follows wireframe structure

## Success Criteria

Component is complete when:
- ✅ Quality score ≥ 95/100 (if validation enabled)
- ✅ Zero blocking issues
- ✅ WCAG AAA compliant
- ✅ Screenshot captured (if requested)
- ✅ All tokens from design system
- ✅ TypeScript strict mode passing

## Time Estimate

**With Planning (default):**
- Planning + Wireframes: 3-5 minutes
- Generation: 3-4 minutes
- Refinement: 4-6 minutes (2 rounds)
- Validation: 2-3 minutes
- Screenshot: 1-2 minutes
- **Total: 13-20 minutes**

**With --skip-plan:**
- Generation: 3-4 minutes
- Refinement: 4-6 minutes
- Validation: 2-3 minutes
- Screenshot: 1-2 minutes
- **Total: 10-15 minutes**

**Fast track (--skip-plan --skip-validation):**
- Generation: 3-4 minutes
- Refinement: 4-6 minutes
- **Total: 7-10 minutes**

## Example Usage

```bash
# Full workflow with planning
/ui-new Navigation menu with dropdown

# Quick generation (no planning)
/ui-new Simple button component --skip-plan

# Generate 5 variants to explore options
/ui-new Card layout --variants 5

# Fast track for simple components
/ui-new Loading spinner --skip-plan --skip-validation

# Complete with screenshot
/ui-new User avatar --screenshot
```

This workflow ensures every component meets production quality standards while offering flexibility for different use cases.

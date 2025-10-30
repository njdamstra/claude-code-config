---
description: Generate N variant options for a component with automatic refinement
argument-hint: [count] [component description]
allowed-tools: write, read, str_replace
---

---
**SOCIALAIZE-SPECIFIC VERSION**
Updated: October 22, 2025
This workflow uses Socialaize stack - see SOCIALAIZE_UI_SYSTEM_v3.md for tech details
Part 1 Status: ✅ Complete (Tailwind config enhanced)
---

# UI Component Variants Generator

Generate multiple high-quality variants of a component with automatic refinement to choose the best option.

## Usage

```bash
/ui-variants 3 User card with avatar and social links
/ui-variants 5 Button with loading state
/ui-variants 2 Modal dialog with form
```

**Syntax**: `/ui-variants [count] [component description]`

## Process

### Step 1: Generate Variants
Create $1 distinct variants based on: $ARGUMENTS (excluding first argument)

Each variant should have:
- **Different approach**: Visual style, structure, or features
- **Clear purpose**: Labeled with use case (minimal, feature-rich, accessible, etc.)
- **Complete code**: Fully functional, production-ready
- **Design system compliant**: Uses only design tokens

### Step 2: Refinement Loop (2 Rounds)
For EACH variant, execute 2 refinement rounds:

**Round 1 - Polish** (per variant):
- Improve TypeScript types
- Enhance code structure
- Polish naming and comments
- Refine prop interfaces

**Round 2 - Performance & A11y** (per variant):
- Add performance optimizations
- Complete accessibility features
- Verify WCAG compliance
- Optimize rendering

### Step 3: Present Options
Show all refined variants with:
- Clear labeling and use case
- Key features highlighted
- Trade-offs explained
- Recommendation provided

## Variant Strategy

When generating N variants, follow this distribution:

### For 3 Variants (Standard):
1. **Minimal & Elegant** - Simple, clean, essential features only
2. **Feature-Rich** - Advanced functionality, enhanced interactions
3. **Accessible & Optimized** - WCAG AAA, performance-focused

### For 5 Variants (Extended):
1. **Minimal** - Bare essentials
2. **Standard** - Balanced features
3. **Feature-Rich** - Advanced capabilities
4. **Accessible** - A11y-first approach
5. **Premium** - Polished, enterprise-grade

### For 2 Variants (Quick):
1. **Simple** - Basic functionality
2. **Advanced** - Enhanced features

## Output Format

```markdown
# 🎨 Component Variants: [ComponentName]

Generated **$1 variants** with 2 refinement rounds each

---

## ✨ Variant 1: [Name/Purpose]

**Best for:** [Use case description]

**Key Features:**
- [Feature 1]
- [Feature 2]
- [Feature 3]

**Trade-offs:**
- ✅ Advantage 1
- ⚠️ Limitation 1

**Code:**
```vue
[Full component code]
\```

**Refinement Changes:**
- Round 1: [List polish improvements]
- Round 2: [List performance/a11y improvements]

---

## 🎯 Variant 2: [Name/Purpose]

[Same structure as Variant 1]

---

## [Continue for all N variants]

---

## 💡 Recommendation

**Suggested Variant: [Number]** - [Name]

**Reasoning:** [Why this variant is recommended for the stated use case]

**Alternative:** If [condition], consider Variant [N] instead.

---

## 📊 Comparison Matrix

| Aspect | Variant 1 | Variant 2 | Variant 3 |
|--------|-----------|-----------|-----------|
| **Complexity** | Low | Medium | Medium |
| **Features** | Basic | Rich | Standard |
| **Accessibility** | AA | AA | AAA |
| **Performance** | Fast | Moderate | Optimized |
| **Use Case** | Prototypes | Apps | Enterprise |

---

## 🎯 Next Steps

1. **Review variants** and choose preferred option
2. **Test selected variant** in your application
3. **Run validation**: `/ui-review` for quality check
4. **Capture screenshot**: `/ui-screenshot` for visual docs
5. **Run regression test**: `/ui-visual-regression` before deployment
\```

## Variant Differentiation

Each variant must be meaningfully different in one or more of:

### Structure
- Component composition approach
- Prop interface design
- Slot configuration
- Event architecture

### Visual Design
- Layout approach (flex, grid)
- Spacing and density
- Visual hierarchy
- Interactive states

### Features
- Core vs. advanced functionality
- Optional capabilities
- Edge case handling
- Customization options

### Technical Approach
- TypeScript patterns
- Composition API usage
- Performance optimizations
- Accessibility implementation

## Quality Standards

Every variant must meet:
- ✅ Full TypeScript typing
- ✅ Design system compliance (100% tokens)
- ✅ Composition API best practices
- ✅ Minimum WCAG AA (variant 3 must be AAA)
- ✅ Semantic HTML
- ✅ Responsive design
- ✅ Production-ready code

## Refinement Process

### Round 1 - Polish (First Pass)
Focus on code quality:
- Type improvements
- Naming consistency
- Code organization
- Comment clarity
- Interface design

### Round 2 - Performance & A11y (Second Pass)
Focus on optimization:
- v-memo for lists
- Computed optimization
- ARIA completion
- Keyboard navigation
- Focus management
- Color contrast
- Touch targets

## Time Estimate

Per variant:
- Generation: 3 minutes
- Round 1 Refinement: 2 minutes
- Round 2 Refinement: 2 minutes
- **Total per variant: 7 minutes**

For 3 variants: ~21 minutes total

## Example Scenarios

### Scenario 1: Exploring Options
```bash
/ui-variants 5 Card component for blog posts
```
→ Generates 5 different approaches to choose from

### Scenario 2: Standard Workflow
```bash
/ui-variants 3 Input field with validation
```
→ Generates minimal, standard, and accessible variants

### Scenario 3: Quick Comparison
```bash
/ui-variants 2 Badge with icon
```
→ Quick simple vs. advanced comparison

## Integration

This command uses:
- **ui-builder** subagent for variant generation
- **ui-analyzer** for design compliance checking (implicit)

Can be followed by:
- `/ui-review` for quality validation
- `/ui-screenshot` for visual documentation
- `/ui-visual-regression` for testing

Choose this command when you want to explore multiple implementation approaches before committing to one.
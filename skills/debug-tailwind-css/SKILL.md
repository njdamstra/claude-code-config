---
name: debug-tailwind-css
description: |
  Comprehensive debugging toolkit for Tailwind CSS + Vue 3 layouts. Provides CLI tools and scripts for:
  - Box model visualization and calculation
  - Flexbox/Grid layout analysis
  - Z-index stacking context inspection
  - Overflow and horizontal scroll detection
  - Computed style extraction
  - Responsive breakpoint testing
  - Layout constraint validation
  - Gap and spacing analysis
  - Position context tracing
  - Component dimension comparison
  - CSS specificity calculation
  - Visual regression testing
  - Dark mode coverage validation
  - Tailwind class conflict detection
  - SSR safety checking
  - Accessibility (ARIA) validation

  Use when debugging sizing, padding, positioning, alignment, overflow, z-index conflicts,
  responsive layout issues, dark mode styling, class conflicts, SSR hydration, or investigating
  why styles aren't applying correctly.

  Triggers: "debug layout", "why is this positioned", "overflow issue", "sizing problem",
  "flexbox not working", "z-index conflict", "horizontal scroll", "spacing inconsistent",
  "dark mode not working", "conflicting classes", "SSR hydration error", "missing aria label"
---

# Debug Tailwind CSS Skill

A comprehensive debugging toolkit for Tailwind CSS and Vue 3 layouts, designed to eliminate the guesswork from CSS debugging.

## Installation

1. Install dependencies:
```bash
cd ~/.claude/skills/debug-tailwind-css
npm install
```

2. Ensure your development server is running (for browser-based tools):
```bash
# In your project directory
npm run dev
```

## Quick Start

### Port Configuration

**Option 1: CLI Arguments (Fastest - No Config File Needed)**
```bash
# Override port on any browser tool
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --port=6942
node ~/.claude/skills/debug-tailwind-css/tools/box-model-extractor.js "h1" --port=3000
node ~/.claude/skills/debug-tailwind-css/tools/position-tracer.js ".modal" --port=8080

# Or use full URL
node ~/.claude/skills/debug-tailwind-css/tools/detect-overflow.js --url=http://localhost:6942
```

**Option 2: Config File (Persistent)**
```bash
# Create .debug-tailwind-css.config.cjs in project root
# (Use .cjs for ESM projects with "type": "module")
cat > .debug-tailwind-css.config.cjs << 'EOF'
module.exports = {
  baseUrl: 'http://localhost:6942',
  outputDir: '.debug-output'
};
EOF
```

### Common Debugging Scenarios

#### "Why is my element sized this way?"
```bash
# Start dev server first, then:
npm run analyze:box-model -- "#my-element" --port=6942
```

#### "What's causing horizontal scroll?"
```bash
npm run detect:overflow --port=6942
```

#### "Why isn't my z-index working?"
```bash
npm run analyze:z-index  # Static analysis - no port needed
```

#### "Compare button sizing across components"
```bash
npm run compare:dimensions -- Button --port=6942
```

#### "Check flex/grid layout patterns"
```bash
npm run analyze:layouts  # Static analysis - no port needed
```

#### "Validate dark mode coverage"
```bash
npm run validate:dark-mode  # Static analysis
npm run screenshot:dark-mode -- --port=6942  # Visual comparison
```

#### "Find conflicting Tailwind classes"
```bash
npm run detect:conflicts
```

#### "Check for SSR safety issues"
```bash
npm run check:ssr
```

## Available Tools

### Layout Analysis

**box-model-extractor** - Extract complete box model with calculations
```bash
npm run analyze:box-model -- ".card"
# Output: JSON with width, height, padding, margin, border, position
```

**flex-grid-analyzer** - Find flex/grid patterns
```bash
npm run analyze:layouts
# Output: Text report of all flex/grid usage
```

**computed-styles** - Extract final computed styles
```bash
npm run extract:styles -- "#header"
# Output: JSON with all computed CSS properties
```

**dimension-compare** - Compare similar components
```bash
npm run compare:dimensions -- Card
# Output: JSON comparing all Card component dimensions
```

### Overflow & Sizing

**detect-overflow** - Find horizontal scroll culprits
```bash
npm run detect:overflow
# Output: Console table + red outlines on overflowing elements
```

**size-calculator** - Explain element sizing
```bash
npm run explain:size -- ".modal"
# Output: Detailed size breakdown with explanations
```

**layout-validator** - Check for common issues
```bash
npm run validate:layout
# Output: Report of potential layout problems
```

### Positioning & Stacking

**z-index-hierarchy** - Map stacking contexts
```bash
npm run analyze:z-index
# Output: Text file with z-index usage and contexts
```

**position-tracer** - Trace positioning contexts
```bash
npm run trace:position -- ".tooltip"
# Output: JSON showing positioning chain
```

### Spacing & Alignment

**spacing-analyzer** - Audit gap, padding, margin
```bash
npm run analyze:spacing
# Output: Text report of spacing patterns
```

**tailwind-class-audit** - Find most used classes
```bash
npm run audit:classes
# Output: Top 20 most used Tailwind classes
```

**duplicate-detector** - Find potential duplicates
```bash
npm run detect:duplicates
# Output: Components with similar class patterns
```

### Testing & Verification

**breakpoint-tester** - Screenshot at all breakpoints
```bash
npm run test:breakpoints -- http://localhost:4321/page
# Output: screenshots/breakpoint-*.png
```

**visual-regression** - Playwright visual testing
```bash
npm run test:visual
# Output: Playwright test results with diffs
```

**specificity-calc** - Calculate CSS specificity
```bash
npm run calc:specificity -- ".btn" ".btn-primary"
# Output: Specificity comparison
```

### Dark Mode Validation

**dark-mode-validator** - Validate dark: class coverage (static)
```bash
npm run validate:dark-mode
# Output: Missing dark: variants, hardcoded colors, dark mode coverage report
```
Checks:
- Missing `dark:` variants on color utilities
- Hardcoded hex/rgb colors
- CSS custom property usage
- Dark mode toggle implementation

**dark-mode-screenshot** - Visual comparison (browser-based)
```bash
npm run screenshot:dark-mode -- --port=6942
# Output: Side-by-side screenshots (light + dark), color analysis JSON
```
Features:
- Takes screenshots in both light and dark modes
- Analyzes color usage differences
- Detects if dark mode is actually working
- Saves screenshots and color analysis report

### Class Conflict Detection

**tailwind-class-conflict-detector** - Find conflicting Tailwind classes
```bash
npm run detect:conflicts
# Output: Report of conflicting utility classes
```
Detects:
- Multiple width classes (`w-full w-64`)
- Display conflicts (`hidden flex`, `block grid`)
- Position conflicts (`static absolute`)
- Text-align conflicts (`text-left text-center`)
- Multiple flex-direction values
- Justify/items conflicts
- Overflow conflicts
- Opacity conflicts

### SSR Safety Checking

**ssr-safety-checker** - Detect browser-only APIs
```bash
npm run check:ssr
# Output: Report of potential SSR hydration issues
```
Checks:
- `window`/`document`/`localStorage` usage
- DOM queries outside mounted hooks
- Direct browser API access in `<script setup>`
- Event listeners outside lifecycle hooks
- VueUse composables (validates SSR compatibility)
- Missing `useMounted()` or `onMounted()` wrappers

### Accessibility Validation

**layout-validator** - Now includes ARIA checks
```bash
npm run validate:layout
# Output: Layout issues + accessibility problems
```
New ARIA checks:
- Buttons without accessible names
- Interactive elements missing semantic roles
- Form inputs without labels
- Missing `aria-label` or `aria-labelledby`

## Advanced Usage

### Custom Analysis Scripts

All tools support custom selectors and options:

```bash
# Analyze specific viewport size
npm run analyze:box-model -- ".card" -- --viewport=375x667

# Export to different format
npm run analyze:layouts -- --format=json > layouts.json

# Include child elements
npm run detect:overflow -- --recursive

# Custom breakpoints
npm run test:breakpoints -- http://localhost:4321 -- --breakpoints="320,768,1024"
```

### Integration with Chrome DevTools

Use these tools alongside Chrome DevTools for maximum effectiveness:

1. Run a tool to identify issues
2. Open Chrome DevTools to inspect live
3. Use tool output as reference for fixes
4. Re-run tool to verify fixes

### Vue Component Specific

For Vue SFC analysis:

```bash
# Parse component structure
npm run parse:vue -- src/components/Card.vue

# Extract template classes
npm run extract:classes -- src/components/Button.vue

# Find component dependencies
npm run analyze:deps -- src/components/Modal.vue
```

## Tool Reference

### box-model-extractor.js
Extracts complete box model information using Puppeteer.

**Output:**
```json
{
  "selector": "#element",
  "width": 320,
  "height": 200,
  "padding": {
    "top": "16px",
    "right": "24px", 
    "bottom": "16px",
    "left": "24px"
  },
  "margin": { ... },
  "position": "relative",
  "display": "flex"
}
```

### detect-overflow.js
Identifies elements causing horizontal scroll by comparing element bounds with viewport width.

**Output:** Console table + visual red outlines

### flex-grid-analyzer.sh
Scans Vue files for flex/grid usage and reports patterns.

**Output:** Text report grouped by file

### layout-validator.sh
Checks for common layout anti-patterns:
- width:100% with padding (box-sizing issues)
- Flex containers without flex-wrap
- Fixed widths that break on mobile
- Absolute positioning without relative parent

### spacing-analyzer.sh
Audits spacing patterns across codebase:
- Gap class usage frequency
- Padding class distribution
- Margin class patterns

### z-index-hierarchy.sh
Maps z-index values and identifies stacking contexts:
- All z-index declarations
- Position values that create contexts
- Transform/opacity that create contexts

## Configuration

Create `.debug-tailwind-css.config.js` in your project root:

```javascript
module.exports = {
  // Base URL for your dev server
  baseUrl: 'http://localhost:4321',
  
  // Paths to scan
  scanPaths: ['src/**/*.vue', 'src/**/*.astro'],
  
  // Breakpoints for testing
  breakpoints: {
    sm: 640,
    md: 768,
    lg: 1024,
    xl: 1280,
    '2xl': 1536
  },
  
  // Puppeteer options
  puppeteer: {
    headless: true,
    viewport: {
      width: 1280,
      height: 720
    }
  },
  
  // Output directory
  outputDir: '.debug-output'
};
```

## Troubleshooting

### "Cannot connect to development server"
Ensure your dev server is running on the expected port:
```bash
npm run dev
```

### "Module not found"
Install dependencies:
```bash
npm install
```

### "Permission denied"
Make scripts executable:
```bash
chmod +x tools/*.sh
```

### "Playwright not installed"
Install Playwright:
```bash
npx playwright install
```

## Tips & Best Practices

1. **Start broad, narrow down**: Use validators and analyzers first, then focus on specific elements

2. **Visual confirmation**: Always verify tool findings visually in the browser

3. **Incremental fixes**: Fix one issue at a time and re-run tests

4. **Document patterns**: Use the audit tools to establish naming conventions

5. **Automate checks**: Add layout validation to your CI/CD pipeline

6. **Combine tools**: Use multiple tools together for comprehensive analysis

## Examples

### Debug Modal Positioning Issue
```bash
# 1. Trace positioning context
npm run trace:position -- ".modal"

# 2. Check z-index
npm run analyze:z-index

# 3. Verify box model
npm run analyze:box-model -- ".modal"
```

### Fix Horizontal Scroll on Mobile
```bash
# 1. Detect overflow
npm run detect:overflow

# 2. Validate layout constraints
npm run validate:layout

# 3. Test at mobile breakpoint
npm run test:breakpoints -- http://localhost:4321 -- --breakpoints="375"
```

### Standardize Button Spacing
```bash
# 1. Compare button dimensions
npm run compare:dimensions -- Button

# 2. Audit spacing patterns
npm run analyze:spacing

# 3. Find duplicates
npm run detect:duplicates
```

## Contributing

This skill is designed to be extended. Add new tools by:

1. Create script in `tools/`
2. Add npm script in `package.json`
3. Document in this file
4. Test with your project

## Credits

Built using:
- Puppeteer for browser automation
- Playwright for visual testing
- CSS specificity calculation libraries
- Vue SFC parsing utilities

## License

MIT

# Debug Tailwind CSS Skill - Package Contents

## Files Included

### Documentation
- **SKILL.md** - Main skill documentation (used by Claude Code)
- **README.md** - Installation and usage guide
- **CONTENTS.md** - This file

### Configuration
- **package.json** - npm dependencies and scripts
- **.gitignore** - Git ignore patterns
- **.debug-tailwind-css.config.example.js** - Example configuration

### Scripts
- **install.sh** - Automated installation script

### Tools Directory (tools/)

#### Layout Analysis (5 tools)
1. **box-model-extractor.js** - Complete box model analysis with calculations
2. **flex-grid-analyzer.sh** - Finds all flex/grid patterns in Vue files
3. **computed-styles.js** - Extracts final computed styles for any element
4. **dimension-compare.js** - Compares dimensions across similar components
5. **layout-validator.sh** - Checks for common layout constraint violations

#### Overflow & Sizing (2 tools)
6. **detect-overflow.js** - Finds elements causing horizontal scroll
7. **tailwind-class-audit.sh** - Lists most used Tailwind classes

#### Positioning & Stacking (2 tools)
8. **z-index-hierarchy.sh** - Maps z-index values and stacking contexts
9. **position-tracer.js** - Traces positioning context chain

#### Spacing & Patterns (3 tools)
10. **spacing-analyzer.sh** - Audits gap, padding, margin patterns
11. **duplicate-detector.sh** - Finds components with similar class patterns
12. **specificity-calculator.js** - Calculates CSS selector specificity

#### Testing (1 tool)
13. **breakpoint-tester.sh** - Screenshots at all Tailwind breakpoints

## Total: 13 Analysis Tools

## Quick Reference

### Installation
```bash
unzip debug-tailwind-css.zip
mv debug-tailwind-css ~/.claude/skills/
cd ~/.claude/skills/debug-tailwind-css
./install.sh
```

### Most Common Commands
```bash
# Detect overflow
npm run detect:overflow

# Analyze layouts
npm run analyze:layouts

# Compare components
npm run compare:dimensions -- Button

# Check z-index
npm run analyze:z-index

# Validate layout
npm run validate:layout
```

## Dependencies

### Production
- puppeteer: ^22.0.0 (browser automation)
- @playwright/test: ^1.44.0 (visual testing)
- @vue/compiler-sfc: ^3.4.0 (Vue parsing)
- vue-sfc-parser: ^0.2.0 (SFC analysis)
- css-specificity: ^0.2.0 (specificity calc)
- glob: ^10.3.0 (file matching)
- chalk: ^4.1.2 (terminal colors)
- yargs: ^17.7.0 (CLI args)

### Dev
- prettier: ^3.2.0 (code formatting)

## Output

All tools save results to `.debug-output/` directory:
- **JSON reports** for programmatic analysis
- **Text reports** for human reading  
- **Screenshots** for visual verification

## Size

Package: ~26KB (compressed)
Installed (with node_modules): ~150MB

## License

MIT

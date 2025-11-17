# Debug Tailwind CSS - Claude Code Skill

A comprehensive debugging toolkit for Tailwind CSS and Vue 3 layouts. Eliminates guesswork from CSS debugging with automated analysis tools.

## Installation

### 1. Copy to Skills Directory

```bash
# If you downloaded the zip
unzip debug-tailwind-css.zip
mv debug-tailwind-css ~/.claude/skills/

# Or clone directly
cd ~/.claude/skills/
# (if you have it in a repo)
```

### 2. Install Dependencies

```bash
cd ~/.claude/skills/debug-tailwind-css
npm install
```

### 3. Install Playwright (for visual testing)

```bash
npx playwright install
```

### 4. Make Scripts Executable

```bash
chmod +x tools/*.sh
```

## Quick Start

### Prerequisites

Your development server must be running for browser-based tools:

```bash
# In your project directory
npm run dev
```

### Basic Usage

```bash
# Navigate to your project
cd ~/my-project

# Run tools using npm scripts
npm run --prefix ~/.claude/skills/debug-tailwind-css analyze:box-model -- "#element"
```

Or add aliases to your shell profile for easier access:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias css-debug='cd ~/.claude/skills/debug-tailwind-css && npm run'

# Then use:
css-debug analyze:box-model -- "#element"
```

## Available Commands

### Layout Analysis
- `npm run analyze:box-model -- "<selector>"` - Complete box model analysis
- `npm run analyze:layouts` - Find all flex/grid patterns
- `npm run extract:styles -- "<selector>"` - Extract computed styles
- `npm run compare:dimensions -- ComponentName` - Compare component dimensions

### Overflow & Sizing
- `npm run detect:overflow` - Find horizontal scroll culprits
- `npm run validate:layout` - Check for common layout issues

### Positioning & Stacking
- `npm run analyze:z-index` - Map z-index hierarchy
- `npm run trace:position -- "<selector>"` - Trace positioning contexts

### Spacing & Patterns
- `npm run analyze:spacing` - Audit spacing patterns
- `npm run audit:classes` - Most used Tailwind classes

### Testing
- `npm run test:breakpoints -- <url>` - Screenshot all breakpoints
- `npm run test:visual` - Playwright visual regression

## Configuration

Create `.debug-tailwind-css.config.js` in your project root:

```javascript
module.exports = {
  baseUrl: 'http://localhost:4321',
  scanPaths: ['src/**/*.vue', 'src/**/*.astro'],
  breakpoints: {
    sm: 640,
    md: 768,
    lg: 1024,
    xl: 1280,
    '2xl': 1536
  },
  outputDir: '.debug-output'
};
```

## Usage with Claude Code

This skill is automatically available in Claude Code. Trigger it with:

- "debug this layout"
- "why is there horizontal scroll"
- "analyze the flex layout"
- "check z-index issues"
- "compare button dimensions"

Claude Code will automatically invoke the appropriate tools and analyze results.

## Troubleshooting

### "Cannot connect to localhost"
Ensure your dev server is running:
```bash
npm run dev
```

### "Permission denied" on scripts
Make scripts executable:
```bash
chmod +x tools/*.sh
```

### "Module not found"
Install dependencies:
```bash
npm install
```

## Output

All tools save results to `.debug-output/` in your project:
- JSON reports for programmatic analysis
- Text reports for human reading
- Screenshots for visual verification

## Examples

### Debug Horizontal Scroll
```bash
npm run detect:overflow
# Opens browser, highlights overflowing elements in red
# Saves screenshot and JSON report
```

### Compare All Buttons
```bash
npm run compare:dimensions -- Button
# Finds all *Button*.vue files
# Compares width, height, padding, margin
# Reports inconsistencies
```

### Analyze Layout
```bash
npm run analyze:box-model -- ".card"
npm run extract:styles -- ".card"
npm run validate:layout
# Complete layout analysis with specific recommendations
```

## Tips

1. **Run validators first** - Get overview of common issues
2. **Then drill down** - Use specific tools on problem areas
3. **Save reports** - Compare before/after when fixing
4. **Automate checks** - Add to CI/CD pipeline

## Contributing

Found a bug or want to add a tool? The skill is modular:

1. Add script to `tools/`
2. Add npm script to `package.json`
3. Document in `SKILL.md`

## License

MIT

## Credits

Uses: Puppeteer, Playwright, Vue SFC parsers, CSS specificity calculators

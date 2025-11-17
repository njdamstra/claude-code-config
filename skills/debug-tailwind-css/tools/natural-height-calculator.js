#!/usr/bin/env node

/**
 * Natural Height Calculator
 * Measures content's natural dimensions without height constraints
 * Perfect for calculating baseline dimensions for responsive scaling
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Load config
let config = {
  baseUrl: 'http://localhost:4321',
  outputDir: '.debug-output'
};

try {
  const configPaths = [
    path.join(process.cwd(), '.debug-tailwind-css.config.cjs'),
    path.join(process.cwd(), '.debug-tailwind-css.config.js')
  ];
  for (const configPath of configPaths) {
    if (fs.existsSync(configPath)) {
      config = { ...config, ...require(configPath) };
      break;
    }
  }
} catch (e) {
  // Use defaults
}

// CLI arguments
const urlArg = process.argv.find(arg => arg.startsWith('--url='));
const portArg = process.argv.find(arg => arg.startsWith('--port='));

if (urlArg) {
  config.baseUrl = urlArg.split('=')[1];
} else if (portArg) {
  const port = portArg.split('=')[1];
  config.baseUrl = `http://localhost:${port}`;
}

const selector = process.argv[2];

if (!selector || selector.startsWith('--')) {
  console.error('Usage: npm run calc:natural-height -- "<selector>" [--port=PORT]');
  console.error('Example: npm run calc:natural-height -- ".analytics-stage"');
  process.exit(1);
}

(async () => {
  console.log(`Calculating natural dimensions for: ${selector}`);
  console.log(`Target URL: ${config.baseUrl}\n`);

  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });

  const page = await browser.newPage();

  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });

    const naturalDimensions = await page.evaluate((sel) => {
      const el = document.querySelector(sel);

      if (!el) {
        return { error: `Element not found: ${sel}` };
      }

      const computed = getComputedStyle(el);
      const rect = el.getBoundingClientRect();

      // Get original constraints
      const originalMaxHeight = computed.maxHeight;
      const originalHeight = computed.height;
      const originalMinHeight = computed.minHeight;

      // Store element info
      const elementInfo = {
        tagName: el.tagName.toLowerCase(),
        id: el.id || null,
        classes: el.className ? Array.from(el.classList).slice(0, 5) : []
      };

      // Current state
      const currentState = {
        width: Math.round(rect.width),
        height: Math.round(rect.height),
        clientHeight: el.clientHeight,
        scrollHeight: el.scrollHeight,
        constraints: {
          minHeight: originalMinHeight,
          maxHeight: originalMaxHeight,
          height: originalHeight
        }
      };

      // Calculate padding and border
      const paddingV = parseFloat(computed.paddingTop) + parseFloat(computed.paddingBottom);
      const borderV = parseFloat(computed.borderTopWidth) + parseFloat(computed.borderBottomWidth);
      const paddingH = parseFloat(computed.paddingLeft) + parseFloat(computed.paddingRight);
      const borderH = parseFloat(computed.borderLeftWidth) + parseFloat(computed.borderRightWidth);

      // Temporarily remove height constraints to get natural height
      el.style.maxHeight = 'none';
      el.style.minHeight = '0';
      el.style.height = 'auto';

      // Force reflow
      el.offsetHeight;

      // Get natural dimensions
      const naturalRect = el.getBoundingClientRect();
      const naturalHeight = el.scrollHeight;

      const naturalState = {
        width: Math.round(naturalRect.width),
        height: Math.round(naturalRect.height),
        scrollHeight: naturalHeight,
        contentHeight: naturalHeight - paddingV - borderV
      };

      // Restore original styles
      el.style.maxHeight = originalMaxHeight;
      el.style.minHeight = originalMinHeight;
      el.style.height = originalHeight;

      // Analyze children
      const children = Array.from(el.children).map(child => {
        const childComputed = getComputedStyle(child);
        const childRect = child.getBoundingClientRect();
        const childMarginV = parseFloat(childComputed.marginTop) + parseFloat(childComputed.marginBottom);

        return {
          tagName: child.tagName.toLowerCase(),
          id: child.id || null,
          classes: child.className ? Array.from(child.classList).slice(0, 3) : [],
          height: Math.round(childRect.height),
          marginVertical: childMarginV,
          totalSpace: Math.round(childRect.height + childMarginV)
        };
      });

      // Calculate total child height
      const totalChildHeight = children.reduce((sum, child) => sum + child.totalSpace, 0);

      // Get parent info
      let parentInfo = null;
      if (el.parentElement) {
        const parent = el.parentElement;
        const parentComputed = getComputedStyle(parent);
        const parentRect = parent.getBoundingClientRect();

        const parentPaddingV = parseFloat(parentComputed.paddingTop) + parseFloat(parentComputed.paddingBottom);

        parentInfo = {
          tagName: parent.tagName.toLowerCase(),
          id: parent.id || null,
          height: Math.round(parentRect.height),
          clientHeight: parent.clientHeight,
          paddingVertical: parentPaddingV,
          availableHeight: parent.clientHeight - parentPaddingV
        };
      }

      return {
        element: elementInfo,
        current: currentState,
        natural: naturalState,
        padding: {
          horizontal: paddingH,
          vertical: paddingV
        },
        border: {
          horizontal: borderH,
          vertical: borderV
        },
        children: children,
        childrenSummary: {
          count: children.length,
          totalHeight: totalChildHeight,
          averageHeight: children.length > 0 ? Math.round(totalChildHeight / children.length) : 0
        },
        parent: parentInfo
      };
    }, selector);

    if (naturalDimensions.error) {
      console.error(`❌ ${naturalDimensions.error}`);
      process.exit(1);
    }

    // Pretty print
    console.log('📏 Natural Content Dimensions\n');
    console.log(`Element: ${naturalDimensions.element.tagName}${naturalDimensions.element.id ? '#' + naturalDimensions.element.id : ''}`);
    if (naturalDimensions.element.classes.length > 0) {
      console.log(`Classes: .${naturalDimensions.element.classes.join('.')}`);
    }

    console.log('\n📐 Current State (with constraints):');
    console.log(`  Height: ${naturalDimensions.current.height}px`);
    console.log(`  Client: ${naturalDimensions.current.clientHeight}px`);
    console.log(`  Scroll: ${naturalDimensions.current.scrollHeight}px`);
    if (naturalDimensions.current.scrollHeight > naturalDimensions.current.clientHeight) {
      console.log(`  ⚠️  Content is ${naturalDimensions.current.scrollHeight - naturalDimensions.current.clientHeight}px taller than container!`);
    }
    console.log(`\n  Constraints:`);
    console.log(`    min-height: ${naturalDimensions.current.constraints.minHeight}`);
    console.log(`    height: ${naturalDimensions.current.constraints.height}`);
    console.log(`    max-height: ${naturalDimensions.current.constraints.maxHeight}`);

    console.log('\n🌿 Natural State (constraints removed):');
    console.log(`  Width: ${naturalDimensions.natural.width}px`);
    console.log(`  Height: ${naturalDimensions.natural.height}px`);
    console.log(`  Content height (no padding/border): ${naturalDimensions.natural.contentHeight}px`);
    console.log(`  Scroll height: ${naturalDimensions.natural.scrollHeight}px`);

    console.log('\n📦 Space Breakdown:');
    console.log(`  Padding: ${Math.round(naturalDimensions.padding.vertical)}px vertical`);
    console.log(`  Border: ${Math.round(naturalDimensions.border.vertical)}px vertical`);
    console.log(`  Content: ${naturalDimensions.natural.contentHeight}px`);
    console.log(`  Total: ${naturalDimensions.natural.height}px`);

    if (naturalDimensions.children.length > 0) {
      console.log('\n👶 Child Elements:');
      naturalDimensions.children.forEach((child, idx) => {
        console.log(`  ${idx + 1}. ${child.tagName}${child.id ? '#' + child.id : ''}`);
        if (child.classes.length > 0) {
          console.log(`     Classes: .${child.classes.join('.')}`);
        }
        console.log(`     Height: ${child.height}px${child.marginVertical > 0 ? ` + ${Math.round(child.marginVertical)}px margin = ${child.totalSpace}px total` : ''}`);
      });

      console.log(`\n  Summary: ${naturalDimensions.childrenSummary.count} children, ${naturalDimensions.childrenSummary.totalHeight}px total height`);

      // Check if children sum matches natural height
      const diff = naturalDimensions.natural.contentHeight - naturalDimensions.childrenSummary.totalHeight;
      if (Math.abs(diff) > 2) {
        console.log(`  ⚠️  Gap between children (${naturalDimensions.childrenSummary.totalHeight}px) and content (${naturalDimensions.natural.contentHeight}px): ${Math.round(diff)}px`);
        console.log(`     This could be: gaps, flex/grid spacing, or nested elements`);
      }
    }

    if (naturalDimensions.parent) {
      console.log('\n👪 Parent Container:');
      console.log(`  Element: ${naturalDimensions.parent.tagName}${naturalDimensions.parent.id ? '#' + naturalDimensions.parent.id : ''}`);
      console.log(`  Height: ${naturalDimensions.parent.height}px`);
      console.log(`  Client: ${naturalDimensions.parent.clientHeight}px`);
      console.log(`  Padding: ${Math.round(naturalDimensions.parent.paddingVertical)}px vertical (consumes space)`);
      console.log(`  Available: ${Math.round(naturalDimensions.parent.availableHeight)}px`);

      const fitsInParent = naturalDimensions.natural.height <= naturalDimensions.parent.availableHeight;
      if (!fitsInParent) {
        const overflow = naturalDimensions.natural.height - naturalDimensions.parent.availableHeight;
        console.log(`\n  ❌ Content (${naturalDimensions.natural.height}px) exceeds available space (${Math.round(naturalDimensions.parent.availableHeight)}px)`);
        console.log(`     Overflow: ${Math.round(overflow)}px`);
      } else {
        console.log(`\n  ✅ Content fits within parent (${Math.round(naturalDimensions.parent.availableHeight - naturalDimensions.natural.height)}px buffer)`);
      }
    }

    // Recommendations
    console.log('\n💡 Recommendations:\n');

    if (naturalDimensions.parent) {
      console.log('For responsive scaling configuration:');
      console.log('```typescript');
      console.log('responsive: {');
      console.log('  enabled: true,');
      console.log(`  baselineWidth: ${naturalDimensions.natural.width},`);
      console.log(`  baselineHeight: ${naturalDimensions.natural.height}, // Natural content height`);
      console.log(`  measureTarget: 'self',`);
      console.log(`  scalingMode: 'both',`);
      console.log('  minScale: 0.5,');
      console.log('  maxScale: 1.2');
      console.log('}');
      console.log('```');

      if (naturalDimensions.parent.paddingVertical > 0) {
        const withPadding = naturalDimensions.natural.height + naturalDimensions.parent.paddingVertical;
        console.log(`\nIf padding is "baked into" baseline (single-container pattern):`);
        console.log(`  baselineHeight: ${Math.round(withPadding)} // ${naturalDimensions.natural.height}px content + ${Math.round(naturalDimensions.parent.paddingVertical)}px padding`);
      }
    }

    // Save to file
    const outputDir = path.join(process.cwd(), config.outputDir);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const outputFile = path.join(outputDir, 'natural-height-analysis.json');
    fs.writeFileSync(outputFile, JSON.stringify(naturalDimensions, null, 2));

    console.log(`\n✅ Full report saved to: ${outputFile}`);

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

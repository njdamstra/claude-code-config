#!/usr/bin/env node

/**
 * Parent-Child Hierarchy Analyzer
 * Analyzes entire component hierarchy: parents, children, siblings
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
} catch (e) {}

// CLI arguments override config file
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
  console.error('Usage: node parent-child-analyzer.js "<selector>" [--port=PORT]');
  console.error('Example: node parent-child-analyzer.js ".modal" --port=6942');
  console.error('');
  console.error('Analyzes complete hierarchy: grandparent → parent → element → children');
  process.exit(1);
}

(async () => {
  console.log(`🔍 Analyzing hierarchy for: ${selector}\n`);

  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });

  const page = await browser.newPage();

  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });

    const hierarchy = await page.evaluate((sel) => {
      const element = document.querySelector(sel);

      if (!element) {
        return { error: `Element not found: ${sel}` };
      }

      // Helper to extract element info
      const getElementInfo = (el) => {
        if (!el) return null;

        const computed = getComputedStyle(el);
        const rect = el.getBoundingClientRect();

        return {
          tagName: el.tagName.toLowerCase(),
          id: el.id || null,
          classes: el.className ? Array.from(el.classList).slice(0, 5) : [],
          dimensions: {
            width: Math.round(rect.width),
            height: Math.round(rect.height)
          },
          layout: {
            display: computed.display,
            position: computed.position,
            flexDirection: computed.flexDirection !== 'row' ? computed.flexDirection : null,
            gridTemplateColumns: computed.gridTemplateColumns !== 'none' ? computed.gridTemplateColumns : null
          },
          spacing: {
            padding: {
              top: parseInt(computed.paddingTop),
              right: parseInt(computed.paddingRight),
              bottom: parseInt(computed.paddingBottom),
              left: parseInt(computed.paddingLeft)
            },
            margin: {
              top: parseInt(computed.marginTop),
              right: parseInt(computed.marginRight),
              bottom: parseInt(computed.marginBottom),
              left: parseInt(computed.marginLeft)
            }
          },
          zIndex: computed.zIndex !== 'auto' ? computed.zIndex : 'auto',
          childCount: el.children.length
        };
      };

      // Build hierarchy
      const result = {
        target: getElementInfo(element),
        parent: getElementInfo(element.parentElement),
        grandparent: getElementInfo(element.parentElement?.parentElement),
        greatGrandparent: getElementInfo(element.parentElement?.parentElement?.parentElement),
        children: Array.from(element.children).map(child => getElementInfo(child)),
        siblings: element.parentElement ?
          Array.from(element.parentElement.children)
            .filter(child => child !== element)
            .map(sibling => getElementInfo(sibling)) :
          [],
        path: []
      };

      // Build path from body to element
      let current = element;
      while (current && current !== document.body) {
        const info = getElementInfo(current);
        result.path.unshift({
          tag: info.tagName,
          id: info.id,
          classes: info.classes.slice(0, 2),
          display: info.layout.display
        });
        current = current.parentElement;
      }

      return result;
    }, selector);

    if (hierarchy.error) {
      console.error(`❌ ${hierarchy.error}`);
      process.exit(1);
    }

    // Pretty print hierarchy
    console.log('🌳 Component Hierarchy Tree\n');

    // Show path from body
    console.log('📍 DOM Path (body → target):');
    hierarchy.path.forEach((node, i) => {
      const indent = '  '.repeat(i);
      const id = node.id ? `#${node.id}` : '';
      const classes = node.classes.length > 0 ? `.${node.classes.join('.')}` : '';
      console.log(`${indent}└─ ${node.tag}${id}${classes} [${node.display}]`);
    });

    console.log('\n👴 Great-Grandparent:');
    if (hierarchy.greatGrandparent) {
      printElement(hierarchy.greatGrandparent, '  ');
    } else {
      console.log('  (none)');
    }

    console.log('\n👵 Grandparent:');
    if (hierarchy.grandparent) {
      printElement(hierarchy.grandparent, '  ');
    } else {
      console.log('  (none)');
    }

    console.log('\n👪 Parent:');
    if (hierarchy.parent) {
      printElement(hierarchy.parent, '  ');
    } else {
      console.log('  (none - this is body or root)');
    }

    console.log('\n🎯 Target Element:');
    printElement(hierarchy.target, '  ');

    console.log('\n👶 Children (' + hierarchy.children.length + '):');
    if (hierarchy.children.length > 0) {
      hierarchy.children.forEach((child, i) => {
        console.log(`\n  Child ${i + 1}:`);
        printElement(child, '    ');
      });
    } else {
      console.log('  (no children)');
    }

    console.log('\n👫 Siblings (' + hierarchy.siblings.length + '):');
    if (hierarchy.siblings.length > 0) {
      hierarchy.siblings.slice(0, 5).forEach((sibling, i) => {
        console.log(`\n  Sibling ${i + 1}:`);
        printElement(sibling, '    ');
      });
      if (hierarchy.siblings.length > 5) {
        console.log(`\n  ... and ${hierarchy.siblings.length - 5} more siblings`);
      }
    } else {
      console.log('  (no siblings)');
    }

    // Relationship analysis
    console.log('\n🔍 Relationship Analysis:');
    analyzeRelationships(hierarchy);

    // Save JSON
    const outputDir = path.join(process.cwd(), config.outputDir);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const outputFile = path.join(outputDir, 'hierarchy-analysis.json');
    fs.writeFileSync(outputFile, JSON.stringify(hierarchy, null, 2));

    console.log(`\n✅ Full hierarchy saved to: ${outputFile}`);

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

function printElement(el, indent = '') {
  const id = el.id ? `#${el.id}` : '';
  const classes = el.classes.length > 0 ? `.${el.classes.join('.')}` : '';

  console.log(`${indent}Tag: ${el.tagName}${id}${classes}`);
  console.log(`${indent}Display: ${el.layout.display}`);
  console.log(`${indent}Position: ${el.layout.position}`);
  console.log(`${indent}Dimensions: ${el.dimensions.width}px × ${el.dimensions.height}px`);

  if (el.layout.flexDirection) {
    console.log(`${indent}Flex Direction: ${el.layout.flexDirection}`);
  }
  if (el.layout.gridTemplateColumns) {
    console.log(`${indent}Grid Columns: ${el.layout.gridTemplateColumns}`);
  }

  const hasSpacing =
    el.spacing.padding.top || el.spacing.padding.right ||
    el.spacing.padding.bottom || el.spacing.padding.left;

  if (hasSpacing) {
    console.log(`${indent}Padding: ${el.spacing.padding.top}px ${el.spacing.padding.right}px ${el.spacing.padding.bottom}px ${el.spacing.padding.left}px`);
  }

  if (el.zIndex !== 'auto') {
    console.log(`${indent}Z-Index: ${el.zIndex}`);
  }

  if (el.childCount > 0) {
    console.log(`${indent}Children: ${el.childCount}`);
  }
}

function analyzeRelationships(h) {
  const issues = [];

  // Check if parent is flex/grid and target has width issues
  if (h.parent) {
    const isFlexParent = h.parent.layout.display.includes('flex');
    const isGridParent = h.parent.layout.display.includes('grid');

    if (isFlexParent) {
      console.log('  ✓ Parent is flexbox container');
      if (h.parent.layout.flexDirection) {
        console.log(`    Direction: ${h.parent.layout.flexDirection}`);
      }
    }

    if (isGridParent) {
      console.log('  ✓ Parent is grid container');
      if (h.parent.layout.gridTemplateColumns) {
        console.log(`    Columns: ${h.parent.layout.gridTemplateColumns}`);
      }
    }

    // Check positioning contexts
    if (h.target.layout.position === 'absolute' && h.parent.layout.position === 'static') {
      console.log('  ⚠️  Target is absolutely positioned but parent is static');
      console.log('      (will position relative to next non-static ancestor)');
    }

    // Check z-index without positioning
    if (h.target.zIndex !== 'auto' && h.target.layout.position === 'static') {
      console.log('  ⚠️  Z-index set but position is static (z-index has no effect)');
    }
  }

  // Check for deeply nested structure
  if (h.path.length > 10) {
    console.log(`  ⚠️  Deep nesting (${h.path.length} levels) - may impact performance`);
  }

  // Check for many siblings
  if (h.siblings.length > 20) {
    console.log(`  ℹ️  Large sibling count (${h.siblings.length}) - consider virtualization`);
  }

  // Check for many children
  if (h.target.childCount > 50) {
    console.log(`  ℹ️  Large child count (${h.target.childCount}) - consider virtualization`);
  }
}

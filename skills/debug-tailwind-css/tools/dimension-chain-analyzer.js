#!/usr/bin/env node

/**
 * Dimension Chain Analyzer
 * Shows parent → child dimension hierarchy with available space calculations
 * Perfect for debugging overflow issues and understanding containment
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
const depthArg = process.argv.find(arg => arg.startsWith('--depth='));

if (urlArg) {
  config.baseUrl = urlArg.split('=')[1];
} else if (portArg) {
  const port = portArg.split('=')[1];
  config.baseUrl = `http://localhost:${port}`;
}

const selector = process.argv[2];
const maxDepth = depthArg ? parseInt(depthArg.split('=')[1]) : 3;

if (!selector || selector.startsWith('--')) {
  console.error('Usage: npm run analyze:chain -- "<selector>" [--depth=N] [--port=PORT]');
  console.error('Example: npm run analyze:chain -- ".analytics-stage"');
  console.error('Example: npm run analyze:chain -- ".analytics-stage" --depth=5');
  process.exit(1);
}

(async () => {
  console.log(`Analyzing dimension chain for: ${selector}`);
  console.log(`Max depth: ${maxDepth} levels up`);
  console.log(`Target URL: ${config.baseUrl}\n`);

  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });

  const page = await browser.newPage();

  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });

    const chainData = await page.evaluate((sel, depth) => {
      const target = document.querySelector(sel);

      if (!target) {
        return { error: `Element not found: ${sel}` };
      }

      const getElementInfo = (el) => {
        const computed = getComputedStyle(el);
        const rect = el.getBoundingClientRect();

        const paddingH = parseFloat(computed.paddingLeft) + parseFloat(computed.paddingRight);
        const paddingV = parseFloat(computed.paddingTop) + parseFloat(computed.paddingBottom);
        const borderH = parseFloat(computed.borderLeftWidth) + parseFloat(computed.borderRightWidth);
        const borderV = parseFloat(computed.borderTopWidth) + parseFloat(computed.borderBottomWidth);

        // Calculate available space for children
        const availableWidth = el.clientWidth - paddingH;
        const availableHeight = el.clientHeight - paddingV;

        return {
          tagName: el.tagName.toLowerCase(),
          id: el.id || null,
          classes: el.className ? Array.from(el.classList).slice(0, 5) : [],
          dimensions: {
            width: Math.round(rect.width),
            height: Math.round(rect.height),
            clientWidth: el.clientWidth,
            clientHeight: el.clientHeight,
            scrollWidth: el.scrollWidth,
            scrollHeight: el.scrollHeight
          },
          padding: {
            horizontal: paddingH,
            vertical: paddingV,
            top: parseFloat(computed.paddingTop),
            right: parseFloat(computed.paddingRight),
            bottom: parseFloat(computed.paddingBottom),
            left: parseFloat(computed.paddingLeft)
          },
          border: {
            horizontal: borderH,
            vertical: borderV
          },
          margin: {
            horizontal: parseFloat(computed.marginLeft) + parseFloat(computed.marginRight),
            vertical: parseFloat(computed.marginTop) + parseFloat(computed.marginBottom)
          },
          availableForChildren: {
            width: availableWidth,
            height: availableHeight
          },
          overflow: {
            horizontal: el.scrollWidth > el.clientWidth,
            vertical: el.scrollHeight > el.clientHeight,
            horizontalAmount: Math.max(0, el.scrollWidth - el.clientWidth),
            verticalAmount: Math.max(0, el.scrollHeight - el.clientHeight)
          },
          layout: {
            position: computed.position,
            display: computed.display,
            boxSizing: computed.boxSizing,
            overflow: computed.overflow,
            minWidth: computed.minWidth,
            maxWidth: computed.maxWidth,
            minHeight: computed.minHeight,
            maxHeight: computed.maxHeight
          },
          cssClasses: computed.cssText ? computed.cssText.substring(0, 100) : ''
        };
      };

      // Build chain from target up to ancestors
      const chain = [];
      let current = target;
      let level = 0;

      while (current && level <= depth) {
        const info = getElementInfo(current);
        info.level = level;
        info.isTarget = level === 0;

        // Check if this element overflows its parent
        if (current.parentElement) {
          const parent = current.parentElement;
          const parentAvailableWidth = parent.clientWidth - (parseFloat(getComputedStyle(parent).paddingLeft) + parseFloat(getComputedStyle(parent).paddingRight));
          const parentAvailableHeight = parent.clientHeight - (parseFloat(getComputedStyle(parent).paddingTop) + parseFloat(getComputedStyle(parent).paddingBottom));

          info.fitsInParent = {
            width: current.getBoundingClientRect().width <= parentAvailableWidth,
            height: current.getBoundingClientRect().height <= parentAvailableHeight,
            widthDiff: Math.round(current.getBoundingClientRect().width - parentAvailableWidth),
            heightDiff: Math.round(current.getBoundingClientRect().height - parentAvailableHeight)
          };
        }

        chain.push(info);
        current = current.parentElement;
        level++;
      }

      return { chain: chain.reverse() }; // Reverse so root is first
    }, selector, maxDepth);

    if (chainData.error) {
      console.error(`❌ ${chainData.error}`);
      process.exit(1);
    }

    // Pretty print the chain
    console.log('📐 Dimension Chain Analysis\n');

    chainData.chain.forEach((node, idx) => {
      const indent = '  '.repeat(node.level);
      const prefix = node.isTarget ? '🎯 ' : idx === 0 ? '🏠 ' : '├─ ';

      console.log(`${indent}${prefix}${node.tagName}${node.id ? '#' + node.id : ''}`);

      if (node.classes.length > 0) {
        console.log(`${indent}   Classes: .${node.classes.join('.')}`);
      }

      console.log(`${indent}   Container: ${node.dimensions.width}px × ${node.dimensions.height}px`);
      console.log(`${indent}   Client: ${node.dimensions.clientWidth}px × ${node.dimensions.clientHeight}px`);

      if (node.padding.horizontal > 0 || node.padding.vertical > 0) {
        console.log(`${indent}   Padding: ${Math.round(node.padding.horizontal)}px H, ${Math.round(node.padding.vertical)}px V (consumes space)`);
      }

      if (node.border.horizontal > 0 || node.border.vertical > 0) {
        console.log(`${indent}   Border: ${Math.round(node.border.horizontal)}px H, ${Math.round(node.border.vertical)}px V`);
      }

      console.log(`${indent}   Available for children: ${Math.round(node.availableForChildren.width)}px × ${Math.round(node.availableForChildren.height)}px`);

      if (node.layout.minWidth !== '0px' || node.layout.maxWidth !== 'none') {
        console.log(`${indent}   Width constraints: min=${node.layout.minWidth}, max=${node.layout.maxWidth}`);
      }

      if (node.layout.minHeight !== '0px' || node.layout.maxHeight !== 'none') {
        console.log(`${indent}   Height constraints: min=${node.layout.minHeight}, max=${node.layout.maxHeight}`);
      }

      console.log(`${indent}   Display: ${node.layout.display}, Position: ${node.layout.position}, Box-sizing: ${node.layout.boxSizing}`);

      // Overflow detection
      if (node.overflow.horizontal || node.overflow.vertical) {
        console.log(`${indent}   ❌ INTERNAL OVERFLOW DETECTED!`);
        if (node.overflow.horizontal) {
          console.log(`${indent}      Horizontal: ${node.overflow.horizontalAmount}px (scroll: ${node.dimensions.scrollWidth}px > client: ${node.dimensions.clientWidth}px)`);
        }
        if (node.overflow.vertical) {
          console.log(`${indent}      Vertical: ${node.overflow.verticalAmount}px (scroll: ${node.dimensions.scrollHeight}px > client: ${node.dimensions.clientHeight}px)`);
        }
      }

      // Parent fit check
      if (node.fitsInParent) {
        if (!node.fitsInParent.width || !node.fitsInParent.height) {
          console.log(`${indent}   ❌ OVERFLOWS PARENT CONTAINER!`);
          if (!node.fitsInParent.width) {
            console.log(`${indent}      Width: ${node.fitsInParent.widthDiff}px overflow`);
          }
          if (!node.fitsInParent.height) {
            console.log(`${indent}      Height: ${node.fitsInParent.heightDiff}px overflow`);
          }
        } else {
          console.log(`${indent}   ✅ Fits within parent`);
        }
      }

      console.log('');
    });

    // Constraint analysis
    const targetNode = chainData.chain.find(n => n.isTarget);
    const parentNode = chainData.chain[chainData.chain.findIndex(n => n.isTarget) - 1];

    if (targetNode) {
      console.log('🔒 Constraint Analysis:\n');

      // Analyze width constraints
      const widthConstraints = [];
      if (targetNode.layout.minWidth !== '0px') widthConstraints.push(`min-width: ${targetNode.layout.minWidth}`);
      if (targetNode.layout.maxWidth !== 'none') widthConstraints.push(`max-width: ${targetNode.layout.maxWidth}`);
      if (parentNode) widthConstraints.push(`parent available: ${Math.round(parentNode.availableForChildren.width)}px`);

      if (widthConstraints.length > 0) {
        console.log('Width Constraints:');
        widthConstraints.forEach(c => console.log(`  - ${c}`));

        // Determine which constraint "wins"
        const actualWidth = targetNode.dimensions.width;
        const minWidth = parseFloat(targetNode.layout.minWidth) || 0;
        const maxWidth = targetNode.layout.maxWidth !== 'none' ? parseFloat(targetNode.layout.maxWidth) : Infinity;
        const parentWidth = parentNode ? parentNode.availableForChildren.width : Infinity;

        console.log(`\n  Actual width: ${actualWidth}px`);

        if (actualWidth === minWidth) {
          console.log(`  ✓ Constrained by min-width (${minWidth}px)`);
        } else if (actualWidth === maxWidth) {
          console.log(`  ✓ Constrained by max-width (${maxWidth}px)`);
        } else if (parentNode && actualWidth >= parentWidth) {
          console.log(`  ✓ Constrained by parent width (${Math.round(parentWidth)}px)`);
        } else {
          console.log(`  ✓ Natural content width`);
        }
      }

      // Analyze height constraints
      const heightConstraints = [];
      if (targetNode.layout.minHeight !== '0px') heightConstraints.push(`min-height: ${targetNode.layout.minHeight}`);
      if (targetNode.layout.maxHeight !== 'none') heightConstraints.push(`max-height: ${targetNode.layout.maxHeight}`);
      if (parentNode) heightConstraints.push(`parent available: ${Math.round(parentNode.availableForChildren.height)}px`);

      if (heightConstraints.length > 0) {
        console.log('\n\nHeight Constraints:');
        heightConstraints.forEach(c => console.log(`  - ${c}`));

        // Determine which constraint "wins"
        const actualHeight = targetNode.dimensions.height;
        const minHeight = parseFloat(targetNode.layout.minHeight) || 0;
        const maxHeight = targetNode.layout.maxHeight !== 'none' ? parseFloat(targetNode.layout.maxHeight) : Infinity;
        const parentHeight = parentNode ? parentNode.availableForChildren.height : Infinity;

        console.log(`\n  Actual height: ${actualHeight}px`);

        if (actualHeight === minHeight) {
          console.log(`  ✓ Constrained by min-height (${minHeight}px)`);
        } else if (actualHeight === maxHeight) {
          console.log(`  ✓ Constrained by max-height (${maxHeight}px)`);
        } else if (parentNode && actualHeight >= parentHeight) {
          console.log(`  ✓ Constrained by parent height (${Math.round(parentHeight)}px)`);
        } else {
          console.log(`  ✓ Natural content height`);
        }
      }

      // Constraint precedence explanation
      console.log('\n\n📚 Constraint Precedence Rules:');
      console.log('  1. min-width/min-height (highest priority)');
      console.log('  2. max-width/max-height');
      console.log('  3. Parent container dimensions');
      console.log('  4. Natural content size (lowest priority)');
      console.log('');
    }

    // Summary and recommendations
    console.log('💡 Analysis Summary:\n');

    if (targetNode && parentNode) {
      console.log(`Target element: ${targetNode.tagName}${targetNode.id ? '#' + targetNode.id : ''}`);
      console.log(`  Dimensions: ${targetNode.dimensions.width}px × ${targetNode.dimensions.height}px`);
      console.log(`\nParent container: ${parentNode.tagName}${parentNode.id ? '#' + parentNode.id : ''}`);
      console.log(`  Available space: ${Math.round(parentNode.availableForChildren.width)}px × ${Math.round(parentNode.availableForChildren.height)}px`);

      if (targetNode.fitsInParent) {
        if (!targetNode.fitsInParent.width || !targetNode.fitsInParent.height) {
          console.log(`\n⚠️  Recommendations:`);

          if (!targetNode.fitsInParent.height) {
            console.log(`  - Target needs ${targetNode.dimensions.height}px height but parent only provides ${Math.round(parentNode.availableForChildren.height)}px`);
            console.log(`  - Consider: Increase parent height OR scale target content down`);

            if (parentNode.padding.vertical > 0) {
              console.log(`  - Parent padding (${Math.round(parentNode.padding.vertical)}px vertical) is consuming available space`);
            }

            // Calculate suggested baseline for responsive scaling
            const naturalHeight = targetNode.dimensions.scrollHeight;
            const paddingNeeded = parentNode.padding.vertical;
            const suggestedBaseline = naturalHeight + paddingNeeded;

            console.log(`\n  Suggested for responsive scaling:`);
            console.log(`    baselineHeight: ${suggestedBaseline} // Natural content (${naturalHeight}px) + padding (${Math.round(paddingNeeded)}px)`);
          }

          if (!targetNode.fitsInParent.width) {
            console.log(`  - Target needs ${targetNode.dimensions.width}px width but parent only provides ${Math.round(parentNode.availableForChildren.width)}px`);
            console.log(`  - Consider: Increase parent width OR scale target content down`);
          }
        } else {
          console.log(`\n✅ Target fits comfortably within parent container`);
        }
      }
    }

    // Save to file
    const outputDir = path.join(process.cwd(), config.outputDir);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const outputFile = path.join(outputDir, 'dimension-chain-analysis.json');
    fs.writeFileSync(outputFile, JSON.stringify(chainData, null, 2));

    console.log(`\n✅ Full report saved to: ${outputFile}`);

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

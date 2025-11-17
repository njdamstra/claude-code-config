#!/usr/bin/env node

/**
 * Box Model Extractor (Enhanced)
 * Extracts complete box model information with parent analysis and overflow detection
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
  console.error('Usage: npm run analyze:box-model -- "<selector>" [--url=URL] [--port=PORT]');
  console.error('Example: npm run analyze:box-model -- "#my-element"');
  console.error('Example: npm run analyze:box-model -- ".analytics-stage" --port=4321');
  process.exit(1);
}

(async () => {
  console.log(`Analyzing box model for: ${selector}`);
  console.log(`Target URL: ${config.baseUrl}\n`);

  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });

  const page = await browser.newPage();

  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });

    const boxModel = await page.evaluate((sel) => {
      const el = document.querySelector(sel);

      if (!el) {
        return { error: `Element not found: ${sel}` };
      }

      const computed = getComputedStyle(el);
      const rect = el.getBoundingClientRect();

      // Get parent information
      const parent = el.parentElement;
      let parentInfo = null;

      if (parent) {
        const parentComputed = getComputedStyle(parent);
        const parentRect = parent.getBoundingClientRect();

        parentInfo = {
          tagName: parent.tagName.toLowerCase(),
          id: parent.id || null,
          classes: parent.className ? Array.from(parent.classList) : [],
          dimensions: {
            width: parentRect.width,
            height: parentRect.height,
            clientWidth: parent.clientWidth,
            clientHeight: parent.clientHeight
          },
          padding: {
            top: parseFloat(parentComputed.paddingTop),
            right: parseFloat(parentComputed.paddingRight),
            bottom: parseFloat(parentComputed.paddingBottom),
            left: parseFloat(parentComputed.paddingLeft),
            totalHorizontal: parseFloat(parentComputed.paddingLeft) + parseFloat(parentComputed.paddingRight),
            totalVertical: parseFloat(parentComputed.paddingTop) + parseFloat(parentComputed.paddingBottom)
          },
          layout: {
            display: parentComputed.display,
            boxSizing: parentComputed.boxSizing,
            position: parentComputed.position
          }
        };
      }

      // Calculate available space (parent dimensions minus parent padding)
      let availableSpace = null;
      if (parentInfo) {
        availableSpace = {
          width: parentInfo.dimensions.clientWidth,
          height: parentInfo.dimensions.clientHeight,
          widthAfterPadding: parentInfo.dimensions.clientWidth - parentInfo.padding.totalHorizontal,
          heightAfterPadding: parentInfo.dimensions.clientHeight - parentInfo.padding.totalVertical
        };
      }

      // Calculate space consumed by element
      const paddingH = parseFloat(computed.paddingLeft) + parseFloat(computed.paddingRight);
      const paddingV = parseFloat(computed.paddingTop) + parseFloat(computed.paddingBottom);
      const borderH = parseFloat(computed.borderLeftWidth) + parseFloat(computed.borderRightWidth);
      const borderV = parseFloat(computed.borderTopWidth) + parseFloat(computed.borderBottomWidth);

      const spaceConsumed = {
        byPadding: {
          horizontal: paddingH,
          vertical: paddingV
        },
        byBorder: {
          horizontal: borderH,
          vertical: borderV
        },
        total: {
          horizontal: paddingH + borderH,
          vertical: paddingV + borderV
        },
        availableForContent: {
          width: el.clientWidth - paddingH,
          height: el.clientHeight - paddingV
        }
      };

      // Detect overflow
      const overflow = {
        horizontal: el.scrollWidth > el.clientWidth,
        vertical: el.scrollHeight > el.clientHeight,
        horizontalAmount: Math.max(0, el.scrollWidth - el.clientWidth),
        verticalAmount: Math.max(0, el.scrollHeight - el.clientHeight)
      };

      // Parent overflow check
      let parentOverflow = null;
      if (parentInfo && availableSpace) {
        parentOverflow = {
          horizontal: rect.width > availableSpace.width,
          vertical: rect.height > availableSpace.height,
          horizontalAmount: Math.max(0, rect.width - availableSpace.width),
          verticalAmount: Math.max(0, rect.height - availableSpace.height)
        };
      }

      return {
        selector: sel,
        element: {
          tagName: el.tagName.toLowerCase(),
          id: el.id || null,
          classes: el.className ? Array.from(el.classList) : []
        },
        dimensions: {
          width: rect.width,
          height: rect.height,
          clientWidth: el.clientWidth,
          clientHeight: el.clientHeight,
          offsetWidth: el.offsetWidth,
          offsetHeight: el.offsetHeight,
          scrollWidth: el.scrollWidth,
          scrollHeight: el.scrollHeight
        },
        padding: {
          top: computed.paddingTop,
          right: computed.paddingRight,
          bottom: computed.paddingBottom,
          left: computed.paddingLeft,
          totalHorizontal: paddingH,
          totalVertical: paddingV
        },
        margin: {
          top: computed.marginTop,
          right: computed.marginRight,
          bottom: computed.marginBottom,
          left: computed.marginLeft,
          totalHorizontal: parseFloat(computed.marginLeft) + parseFloat(computed.marginRight),
          totalVertical: parseFloat(computed.marginTop) + parseFloat(computed.marginBottom)
        },
        border: {
          top: computed.borderTopWidth,
          right: computed.borderRightWidth,
          bottom: computed.borderBottomWidth,
          left: computed.borderLeftWidth,
          totalHorizontal: borderH,
          totalVertical: borderV
        },
        layout: {
          position: computed.position,
          display: computed.display,
          boxSizing: computed.boxSizing,
          overflow: computed.overflow,
          overflowX: computed.overflowX,
          overflowY: computed.overflowY
        },
        coordinates: {
          top: computed.top,
          right: computed.right,
          bottom: computed.bottom,
          left: computed.left
        },
        boundingRect: {
          top: rect.top,
          right: rect.right,
          bottom: rect.bottom,
          left: rect.left,
          x: rect.x,
          y: rect.y
        },
        parent: parentInfo,
        availableSpace: availableSpace,
        spaceConsumed: spaceConsumed,
        overflow: overflow,
        parentOverflow: parentOverflow
      };
    }, selector);

    if (boxModel.error) {
      console.error(`❌ ${boxModel.error}`);
      process.exit(1);
    }

    // Pretty print
    console.log('📦 Box Model Analysis\n');
    console.log(`Element: ${boxModel.element.tagName}${boxModel.element.id ? '#' + boxModel.element.id : ''}`);
    if (boxModel.element.classes.length > 0) {
      console.log(`Classes: .${boxModel.element.classes.slice(0, 5).join('.')}`);
    }

    console.log('\n📐 Dimensions:');
    console.log(`  Width: ${Math.round(boxModel.dimensions.width)}px`);
    console.log(`  Height: ${Math.round(boxModel.dimensions.height)}px`);
    console.log(`  Client: ${boxModel.dimensions.clientWidth} x ${boxModel.dimensions.clientHeight}px`);
    console.log(`  Scroll: ${boxModel.dimensions.scrollWidth} x ${boxModel.dimensions.scrollHeight}px`);

    console.log('\n📦 Padding:');
    console.log(`  Top: ${boxModel.padding.top} | Right: ${boxModel.padding.right}`);
    console.log(`  Bottom: ${boxModel.padding.bottom} | Left: ${boxModel.padding.left}`);
    console.log(`  Total: ${Math.round(boxModel.padding.totalHorizontal)}px H, ${Math.round(boxModel.padding.totalVertical)}px V`);

    console.log('\n📦 Margin:');
    console.log(`  Top: ${boxModel.margin.top} | Right: ${boxModel.margin.right}`);
    console.log(`  Bottom: ${boxModel.margin.bottom} | Left: ${boxModel.margin.left}`);
    console.log(`  Total: ${Math.round(boxModel.margin.totalHorizontal)}px H, ${Math.round(boxModel.margin.totalVertical)}px V`);

    console.log('\n🔲 Border:');
    console.log(`  Total: ${Math.round(boxModel.border.totalHorizontal)}px H, ${Math.round(boxModel.border.totalVertical)}px V`);

    console.log('\n🎨 Layout:');
    console.log(`  Position: ${boxModel.layout.position}`);
    console.log(`  Display: ${boxModel.layout.display}`);
    console.log(`  Box Sizing: ${boxModel.layout.boxSizing}`);
    console.log(`  Overflow: ${boxModel.layout.overflow}`);

    // Space consumed
    console.log('\n💾 Space Consumed:');
    console.log(`  Padding: ${Math.round(boxModel.spaceConsumed.byPadding.horizontal)}px H, ${Math.round(boxModel.spaceConsumed.byPadding.vertical)}px V`);
    console.log(`  Border: ${Math.round(boxModel.spaceConsumed.byBorder.horizontal)}px H, ${Math.round(boxModel.spaceConsumed.byBorder.vertical)}px V`);
    console.log(`  Total: ${Math.round(boxModel.spaceConsumed.total.horizontal)}px H, ${Math.round(boxModel.spaceConsumed.total.vertical)}px V`);
    console.log(`  Available for content: ${Math.round(boxModel.spaceConsumed.availableForContent.width)}px W x ${Math.round(boxModel.spaceConsumed.availableForContent.height)}px H`);

    // Parent information
    if (boxModel.parent) {
      console.log('\n👪 Parent Container:');
      console.log(`  Element: ${boxModel.parent.tagName}${boxModel.parent.id ? '#' + boxModel.parent.id : ''}`);
      if (boxModel.parent.classes.length > 0) {
        console.log(`  Classes: .${boxModel.parent.classes.slice(0, 3).join('.')}`);
      }
      console.log(`  Dimensions: ${Math.round(boxModel.parent.dimensions.width)}px x ${Math.round(boxModel.parent.dimensions.height)}px`);
      console.log(`  Client: ${boxModel.parent.dimensions.clientWidth}px x ${boxModel.parent.dimensions.clientHeight}px`);
      console.log(`  Padding: ${Math.round(boxModel.parent.padding.totalHorizontal)}px H, ${Math.round(boxModel.parent.padding.totalVertical)}px V`);
      console.log(`  Display: ${boxModel.parent.layout.display}`);
    }

    // Available space
    if (boxModel.availableSpace) {
      console.log('\n📏 Available Space in Parent:');
      console.log(`  Total: ${Math.round(boxModel.availableSpace.width)}px x ${Math.round(boxModel.availableSpace.height)}px`);
      console.log(`  After parent padding: ${Math.round(boxModel.availableSpace.widthAfterPadding)}px x ${Math.round(boxModel.availableSpace.heightAfterPadding)}px`);
    }

    // Overflow detection
    console.log('\n🔍 Overflow Detection:');
    if (boxModel.overflow.horizontal || boxModel.overflow.vertical) {
      console.log(`  ❌ Element has internal overflow!`);
      if (boxModel.overflow.horizontal) {
        console.log(`     Horizontal: ${boxModel.overflow.horizontalAmount}px overflow`);
      }
      if (boxModel.overflow.vertical) {
        console.log(`     Vertical: ${boxModel.overflow.verticalAmount}px overflow`);
      }
    } else {
      console.log(`  ✅ No internal overflow`);
    }

    if (boxModel.parentOverflow) {
      if (boxModel.parentOverflow.horizontal || boxModel.parentOverflow.vertical) {
        console.log(`  ❌ Element overflows parent container!`);
        if (boxModel.parentOverflow.horizontal) {
          console.log(`     Horizontal: ${Math.round(boxModel.parentOverflow.horizontalAmount)}px overflow`);
        }
        if (boxModel.parentOverflow.vertical) {
          console.log(`     Vertical: ${Math.round(boxModel.parentOverflow.verticalAmount)}px overflow`);
        }
      } else {
        console.log(`  ✅ Fits within parent container`);
      }
    }

    // Save to file
    const outputDir = path.join(process.cwd(), config.outputDir);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const outputFile = path.join(outputDir, 'box-model-analysis.json');
    fs.writeFileSync(outputFile, JSON.stringify(boxModel, null, 2));

    console.log(`\n✅ Full report saved to: ${outputFile}`);

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

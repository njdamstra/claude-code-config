#!/usr/bin/env node

/**
 * Overflow Detector (Enhanced)
 * Finds elements causing horizontal AND vertical scroll/overflow
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
  console.error('Config load error:', e.message);
}

// CLI arguments
const urlArg = process.argv.find(arg => arg.startsWith('--url='));
const portArg = process.argv.find(arg => arg.startsWith('--port='));
const directionArg = process.argv.find(arg => arg.startsWith('--direction='));

if (urlArg) {
  config.baseUrl = urlArg.split('=')[1];
} else if (portArg) {
  const port = portArg.split('=')[1];
  config.baseUrl = `http://localhost:${port}`;
}

const direction = directionArg ? directionArg.split('=')[1] : 'both';

(async () => {
  console.log('🔍 Detecting overflow elements...');
  console.log(`Direction: ${direction}`);
  console.log(`Target URL: ${config.baseUrl}\n`);

  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });

  const page = await browser.newPage();

  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });

    const overflowing = await page.evaluate((detectionMode) => {
      const docWidth = document.documentElement.clientWidth;
      const docHeight = document.documentElement.clientHeight;
      const results = {
        horizontal: [],
        vertical: []
      };

      const walker = document.createTreeWalker(
        document.body,
        NodeFilter.SHOW_ELEMENT
      );

      while (walker.nextNode()) {
        const el = walker.currentNode;
        const rect = el.getBoundingClientRect();
        const computed = getComputedStyle(el);

        let identifier = el.tagName.toLowerCase();
        if (el.id) identifier += `#${el.id}`;
        if (el.className && typeof el.className === 'string') {
          const classes = el.className.split(' ').filter(c => c).slice(0, 3);
          if (classes.length > 0) {
            identifier += '.' + classes.join('.');
          }
        }

        if (detectionMode === 'horizontal' || detectionMode === 'both') {
          if (rect.right > docWidth || rect.left < 0) {
            el.style.setProperty('outline', '2px solid red', 'important');

            results.horizontal.push({
              element: identifier,
              width: Math.round(rect.width),
              left: Math.round(rect.left),
              right: Math.round(rect.right),
              viewportWidth: docWidth,
              overflowAmount: Math.max(
                0,
                Math.round(rect.right - docWidth),
                Math.round(-rect.left)
              ),
              computed: {
                position: computed.position,
                display: computed.display,
                width: computed.width,
                overflow: computed.overflow,
                overflowX: computed.overflowX
              }
            });
          }
        }

        if (detectionMode === 'vertical' || detectionMode === 'both') {
          const exceedsViewport = rect.bottom > docHeight || rect.top < 0;
          const hasInternalOverflow = el.scrollHeight > el.clientHeight;

          if (exceedsViewport || hasInternalOverflow) {
            if (detectionMode === 'vertical') {
              el.style.setProperty('outline', '2px solid purple', 'important');
            } else {
              const hasHorizontal = rect.right > docWidth || rect.left < 0;
              el.style.setProperty('outline', hasHorizontal ? '2px solid orange' : '2px solid purple', 'important');
            }

            results.vertical.push({
              element: identifier,
              height: Math.round(rect.height),
              top: Math.round(rect.top),
              bottom: Math.round(rect.bottom),
              viewportHeight: docHeight,
              clientHeight: el.clientHeight,
              scrollHeight: el.scrollHeight,
              overflowType: hasInternalOverflow ? 'internal' : 'viewport',
              overflowAmount: hasInternalOverflow
                ? el.scrollHeight - el.clientHeight
                : Math.max(0, Math.round(rect.bottom - docHeight), Math.round(-rect.top)),
              computed: {
                position: computed.position,
                display: computed.display,
                height: computed.height,
                overflow: computed.overflow,
                overflowY: computed.overflowY,
                maxHeight: computed.maxHeight
              }
            });
          }
        }
      }

      return {
        viewportWidth: docWidth,
        viewportHeight: docHeight,
        horizontal: results.horizontal,
        vertical: results.vertical
      };
    }, direction);

    let hasIssues = false;

    if (direction === 'horizontal' || direction === 'both') {
      if (overflowing.horizontal.length === 0) {
        console.log('✅ No horizontal overflow detected!');
      } else {
        hasIssues = true;
        console.log(`❌ Found ${overflowing.horizontal.length} horizontal overflowing elements:\n`);
        console.log(`Viewport width: ${overflowing.viewportWidth}px\n`);

        overflowing.horizontal.forEach((el, i) => {
          console.log(`${i + 1}. ${el.element}`);
          console.log(`   Width: ${el.width}px`);
          console.log(`   Position: left ${el.left}px, right ${el.right}px`);
          console.log(`   Overflow: ${el.overflowAmount}px`);
          console.log(`   CSS: ${el.computed.position} / ${el.computed.display} / ${el.computed.width}`);
          console.log('');
        });
      }
    }

    if (direction === 'vertical' || direction === 'both') {
      if (overflowing.vertical.length === 0) {
        console.log('✅ No vertical overflow detected!');
      } else {
        hasIssues = true;
        console.log(`\n❌ Found ${overflowing.vertical.length} vertical overflowing elements:\n`);
        console.log(`Viewport height: ${overflowing.viewportHeight}px\n`);

        overflowing.vertical.forEach((el, i) => {
          console.log(`${i + 1}. ${el.element}`);
          console.log(`   Height: ${el.height}px`);
          console.log(`   Position: top ${el.top}px, bottom ${el.bottom}px`);
          console.log(`   Overflow type: ${el.overflowType}`);
          if (el.overflowType === 'internal') {
            console.log(`   Client: ${el.clientHeight}px, Scroll: ${el.scrollHeight}px`);
          }
          console.log(`   Overflow: ${el.overflowAmount}px`);
          console.log(`   CSS: ${el.computed.position} / ${el.computed.display} / ${el.computed.height}`);
          console.log(`   Max-height: ${el.computed.maxHeight}`);
          console.log('');
        });
      }
    }

    if (hasIssues) {
      const outputDir = path.join(process.cwd(), config.outputDir);
      if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
      }

      const screenshotPath = path.join(outputDir, `overflow-debug-${direction}.png`);
      await page.screenshot({
        path: screenshotPath,
        fullPage: true
      });

      console.log(`📸 Screenshot saved with colored outlines: ${screenshotPath}`);
      if (direction === 'both') {
        console.log(`   Red: horizontal only`);
        console.log(`   Purple: vertical only`);
        console.log(`   Orange: both horizontal and vertical`);
      } else if (direction === 'horizontal') {
        console.log(`   Red: horizontal overflow`);
      } else {
        console.log(`   Purple: vertical overflow`);
      }

      const reportPath = path.join(outputDir, `overflow-report-${direction}.json`);
      fs.writeFileSync(reportPath, JSON.stringify(overflowing, null, 2));
      console.log(`📄 Full report saved: ${reportPath}`);
    }

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

#!/usr/bin/env node

/**
 * Overflow Detector
 * Finds elements causing horizontal scroll
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
  const configPath = path.join(process.cwd(), '.debug-tailwind-css.config.js');
  if (fs.existsSync(configPath)) {
    config = { ...config, ...require(configPath) };
  }
} catch (e) {}

(async () => {
  console.log('🔍 Detecting overflow elements...\n');
  
  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });
  
  const page = await browser.newPage();
  
  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });
    
    const overflowing = await page.evaluate(() => {
      const docWidth = document.documentElement.offsetWidth;
      const results = [];
      
      const walker = document.createTreeWalker(
        document.body,
        NodeFilter.SHOW_ELEMENT
      );
      
      while (walker.nextNode()) {
        const el = walker.currentNode;
        const rect = el.getBoundingClientRect();
        
        if (rect.right > docWidth || rect.left < 0) {
          // Highlight element
          el.style.setProperty('outline', '2px solid red', 'important');
          
          // Get element identifier
          let identifier = el.tagName.toLowerCase();
          if (el.id) identifier += `#${el.id}`;
          if (el.className && typeof el.className === 'string') {
            const classes = el.className.split(' ').filter(c => c).slice(0, 3);
            identifier += '.' + classes.join('.');
          }
          
          results.push({
            element: identifier,
            width: Math.round(rect.width),
            left: Math.round(rect.left),
            right: Math.round(rect.right),
            overflowAmount: Math.max(
              0,
              Math.round(rect.right - docWidth),
              Math.round(-rect.left)
            ),
            computed: {
              position: getComputedStyle(el).position,
              display: getComputedStyle(el).display,
              width: getComputedStyle(el).width
            }
          });
        }
      }
      
      return {
        viewportWidth: docWidth,
        overflowingElements: results
      };
    });
    
    if (overflowing.overflowingElements.length === 0) {
      console.log('✅ No horizontal overflow detected!');
    } else {
      console.log(`❌ Found ${overflowing.overflowingElements.length} overflowing elements:\n`);
      console.log(`Viewport width: ${overflowing.viewportWidth}px\n`);
      
      overflowing.overflowingElements.forEach((el, i) => {
        console.log(`${i + 1}. ${el.element}`);
        console.log(`   Width: ${el.width}px`);
        console.log(`   Position: left ${el.left}px, right ${el.right}px`);
        console.log(`   Overflow: ${el.overflowAmount}px`);
        console.log(`   CSS: ${el.computed.position} / ${el.computed.display} / ${el.computed.width}`);
        console.log('');
      });
      
      // Take screenshot with outlines
      const outputDir = path.join(process.cwd(), config.outputDir);
      if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
      }
      
      const screenshotPath = path.join(outputDir, 'overflow-debug.png');
      await page.screenshot({ 
        path: screenshotPath,
        fullPage: true 
      });
      
      console.log(`📸 Screenshot saved with red outlines: ${screenshotPath}`);
      
      // Save JSON report
      const reportPath = path.join(outputDir, 'overflow-report.json');
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

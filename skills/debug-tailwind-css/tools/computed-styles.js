#!/usr/bin/env node

/**
 * Computed Styles Extractor
 * Extracts final computed styles for any element
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

if (!selector) {
  console.error('Usage: npm run extract:styles -- "<selector>"');
  console.error('Example: npm run extract:styles -- ".card"');
  process.exit(1);
}

(async () => {
  console.log(`Extracting computed styles for: ${selector}\n`);
  
  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });
  
  const page = await browser.newPage();
  
  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });
    
    const styles = await page.evaluate((sel) => {
      const el = document.querySelector(sel);
      
      if (!el) {
        return { error: `Element not found: ${sel}` };
      }
      
      const computed = getComputedStyle(el);
      
      // Categories of properties to extract
      const categories = {
        layout: [
          'display', 'position', 'float', 'clear',
          'top', 'right', 'bottom', 'left',
          'width', 'height', 'min-width', 'min-height', 'max-width', 'max-height',
          'box-sizing', 'overflow', 'overflow-x', 'overflow-y'
        ],
        flexbox: [
          'flex-direction', 'flex-wrap', 'flex-flow',
          'justify-content', 'align-items', 'align-content',
          'flex-grow', 'flex-shrink', 'flex-basis', 'flex',
          'align-self', 'order', 'gap', 'row-gap', 'column-gap'
        ],
        grid: [
          'grid-template-columns', 'grid-template-rows', 'grid-template-areas',
          'grid-auto-columns', 'grid-auto-rows', 'grid-auto-flow',
          'grid-column', 'grid-row', 'grid-area',
          'justify-items', 'align-items', 'place-items'
        ],
        spacing: [
          'padding-top', 'padding-right', 'padding-bottom', 'padding-left',
          'margin-top', 'margin-right', 'margin-bottom', 'margin-left'
        ],
        border: [
          'border-width', 'border-style', 'border-color', 'border-radius'
        ],
        typography: [
          'font-family', 'font-size', 'font-weight', 'font-style',
          'line-height', 'letter-spacing', 'text-align', 'text-transform',
          'text-decoration', 'color'
        ],
        visual: [
          'background-color', 'background-image', 'background-size',
          'opacity', 'visibility', 'z-index',
          'box-shadow', 'transform', 'transition'
        ]
      };
      
      const result = {
        selector: sel,
        categories: {}
      };
      
      Object.entries(categories).forEach(([category, props]) => {
        result.categories[category] = {};
        props.forEach(prop => {
          const value = computed.getPropertyValue(prop);
          if (value && value !== 'none' && value !== 'normal') {
            result.categories[category][prop] = value;
          }
        });
      });
      
      return result;
    }, selector);
    
    if (styles.error) {
      console.error(`❌ ${styles.error}`);
      process.exit(1);
    }
    
    // Pretty print
    console.log('📊 Computed Styles\n');
    
    Object.entries(styles.categories).forEach(([category, props]) => {
      const propCount = Object.keys(props).length;
      if (propCount > 0) {
        console.log(`${category.toUpperCase()}:`);
        Object.entries(props).forEach(([prop, value]) => {
          console.log(`  ${prop}: ${value}`);
        });
        console.log('');
      }
    });
    
    // Save to file
    const outputDir = path.join(process.cwd(), config.outputDir);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }
    
    const outputFile = path.join(outputDir, 'computed-styles.json');
    fs.writeFileSync(outputFile, JSON.stringify(styles, null, 2));
    
    console.log(`✅ Full report saved to: ${outputFile}`);
    
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

#!/usr/bin/env node

/**
 * Position Tracer
 * Traces positioning context chain for an element
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
  console.error('Usage: npm run trace:position -- "<selector>"');
  console.error('Example: npm run trace:position -- ".tooltip"');
  process.exit(1);
}

(async () => {
  console.log(`🔍 Tracing positioning context for: ${selector}\n`);
  
  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });
  
  const page = await browser.newPage();
  
  try {
    await page.goto(config.baseUrl, { waitUntil: 'networkidle0' });
    
    const chain = await page.evaluate((sel) => {
      let el = document.querySelector(sel);
      
      if (!el) {
        return { error: `Element not found: ${sel}` };
      }
      
      const results = [];
      let depth = 0;
      
      const isStackingContext = (element, computed) => {
        const pos = computed.position;
        const zIndex = computed.zIndex;
        const opacity = computed.opacity;
        const transform = computed.transform;
        const filter = computed.filter;
        const isolation = computed.isolation;
        
        return (
          (pos !== 'static' && zIndex !== 'auto') ||
          opacity !== '1' ||
          transform !== 'none' ||
          filter !== 'none' ||
          isolation === 'isolate'
        );
      };
      
      while (el && el !== document.body && depth < 20) {
        const computed = getComputedStyle(el);
        const rect = el.getBoundingClientRect();
        
        let identifier = el.tagName.toLowerCase();
        if (el.id) identifier += `#${el.id}`;
        if (el.className && typeof el.className === 'string') {
          const classes = el.className.split(' ').filter(c => c).slice(0, 2);
          if (classes.length) identifier += '.' + classes.join('.');
        }
        
        const stackingContext = isStackingContext(el, computed);
        
        results.push({
          depth: depth,
          element: identifier,
          position: computed.position,
          zIndex: computed.zIndex,
          transform: computed.transform !== 'none' ? 'yes' : 'no',
          opacity: computed.opacity,
          isStackingContext: stackingContext,
          coordinates: {
            top: Math.round(rect.top),
            left: Math.round(rect.left),
            bottom: Math.round(rect.bottom),
            right: Math.round(rect.right)
          }
        });
        
        el = el.parentElement;
        depth++;
      }
      
      return { chain: results };
    }, selector);
    
    if (chain.error) {
      console.error(`❌ ${chain.error}`);
      process.exit(1);
    }
    
    // Pretty print
    console.log('📍 Position Context Chain\n');
    console.log('(from target up to body)\n');
    
    chain.chain.forEach((item, i) => {
      const indent = '  '.repeat(item.depth);
      const stackingMarker = item.isStackingContext ? '🏗️  ' : '   ';
      
      console.log(`${stackingMarker}${indent}${item.element}`);
      console.log(`${indent}   Position: ${item.position}`);
      console.log(`${indent}   Z-index: ${item.zIndex}`);
      console.log(`${indent}   Transform: ${item.transform}`);
      console.log(`${indent}   Opacity: ${item.opacity}`);
      console.log(`${indent}   Coords: (${item.coordinates.left}, ${item.coordinates.top})`);
      
      if (item.isStackingContext) {
        console.log(`${indent}   ⚠️  Creates stacking context`);
      }
      
      console.log('');
    });
    
    // Count stacking contexts
    const stackingContexts = chain.chain.filter(item => item.isStackingContext);
    console.log(`Found ${stackingContexts.length} stacking contexts in chain`);
    
    // Save to file
    const outputDir = path.join(process.cwd(), config.outputDir);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }
    
    const outputFile = path.join(outputDir, 'position-trace.json');
    fs.writeFileSync(outputFile, JSON.stringify(chain, null, 2));
    
    console.log(`\n✅ Full report saved to: ${outputFile}`);
    
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

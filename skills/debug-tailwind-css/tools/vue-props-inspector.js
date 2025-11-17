#!/usr/bin/env node
import puppeteer from 'puppeteer';

const args = process.argv.slice(2);
const portArg = args.find(arg => arg.startsWith('--port='));
const port = portArg ? portArg.split('=')[1] : '4321';
const targetUrl = `http://localhost:${port}`;

console.log(`🔍 Inspecting Vue component props...`);
console.log(`Target URL: ${targetUrl}\n`);

const browser = await puppeteer.launch({ headless: true });
const page = await browser.newPage();

try {
  await page.goto(targetUrl, { waitUntil: 'networkidle2', timeout: 10000 });
  await new Promise(resolve => setTimeout(resolve, 2000));
  
  // Check visibility ref values
  const visibilityCheck = await page.evaluate(() => {
    // Find theater divs
    const theater0Left = document.querySelector('[data-v-5f79079c]')?.querySelector('div[class*="grid"]')?.children[0];
    const theater0Right = document.querySelector('[data-v-5f79079c]')?.querySelector('div[class*="grid"]')?.children[1];
    
    // Check if elements are in viewport
    const isInViewport = (el) => {
      if (!el) return false;
      const rect = el.getBoundingClientRect();
      return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
      );
    };
    
    // Get position info
    const getPositionInfo = (el) => {
      if (!el) return null;
      const rect = el.getBoundingClientRect();
      return {
        top: Math.round(rect.top),
        bottom: Math.round(rect.bottom),
        inViewport: isInViewport(el),
        windowHeight: window.innerHeight,
        scrollY: window.scrollY
      };
    };
    
    return {
      theater0Left: getPositionInfo(theater0Left),
      theater0Right: getPositionInfo(theater0Right),
      hasIntersectionObserver: typeof IntersectionObserver !== 'undefined'
    };
  });
  
  console.log('📊 VISIBILITY TRACKING STATUS:\n');
  console.log(`  IntersectionObserver available: ${visibilityCheck.hasIntersectionObserver ? '✅' : '❌'}`);
  console.log(`  Window height: ${visibilityCheck.theater0Left?.windowHeight}px`);
  console.log(`  Current scroll: ${visibilityCheck.theater0Left?.scrollY}px\n`);
  
  if (visibilityCheck.theater0Left) {
    console.log('LEFT THEATER:');
    console.log(`  Top position: ${visibilityCheck.theater0Left.top}px`);
    console.log(`  Bottom position: ${visibilityCheck.theater0Left.bottom}px`);
    console.log(`  In viewport: ${visibilityCheck.theater0Left.inViewport ? '✅ YES' : '❌ NO'}`);
  } else {
    console.log('LEFT THEATER: ❌ NOT FOUND');
  }
  
  if (visibilityCheck.theater0Right) {
    console.log('\nRIGHT THEATER:');
    console.log(`  Top position: ${visibilityCheck.theater0Right.top}px`);
    console.log(`  Bottom position: ${visibilityCheck.theater0Right.bottom}px`);
    console.log(`  In viewport: ${visibilityCheck.theater0Right.inViewport ? '✅ YES' : '❌ NO'}`);
  } else {
    console.log('\nRIGHT THEATER: ❌ NOT FOUND');
  }
  
  // Scroll to the workflows section
  console.log('\n🔄 Scrolling to workflows section...\n');
  await page.evaluate(() => {
    const section = document.querySelector('#workflows');
    if (section) {
      section.scrollIntoView({ behavior: 'instant', block: 'center' });
    }
  });
  
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  // Check again after scroll
  const afterScroll = await page.evaluate(() => {
    const leftLayer = document.querySelector('#workflow-theater-layer-0-left');
    const rightLayer = document.querySelector('#workflow-theater-layer-0-right');
    
    return {
      leftLayerChildren: leftLayer ? leftLayer.children.length : 0,
      rightLayerChildren: rightLayer ? rightLayer.children.length : 0,
      leftLayerHTML: leftLayer ? leftLayer.innerHTML.substring(0, 200) : 'NOT FOUND',
      rightLayerHTML: rightLayer ? rightLayer.innerHTML.substring(0, 200) : 'NOT FOUND'
    };
  });
  
  console.log('📊 AFTER SCROLLING TO VIEW:\n');
  console.log(`  Left teleport layer: ${afterScroll.leftLayerChildren} children`);
  console.log(`  Right teleport layer: ${afterScroll.rightLayerChildren} children`);
  
  if (afterScroll.leftLayerChildren === 0) {
    console.log(`\n⚠️  LEFT LAYER STILL EMPTY: ${afterScroll.leftLayerHTML}`);
  } else {
    console.log(`\n✅ LEFT LAYER HAS CONTENT`);
  }
  
  if (afterScroll.rightLayerChildren === 0) {
    console.log(`⚠️  RIGHT LAYER STILL EMPTY: ${afterScroll.rightLayerHTML}`);
  } else {
    console.log(`✅ RIGHT LAYER HAS CONTENT`);
  }
  
  await browser.close();
  process.exit(0);
  
} catch (error) {
  console.error(`❌ Error: ${error.message}`);
  await browser.close();
  process.exit(1);
}

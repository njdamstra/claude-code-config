#!/usr/bin/env node
import puppeteer from 'puppeteer';

const args = process.argv.slice(2);
const selectorArg = args.find(arg => !arg.startsWith('--'));
const portArg = args.find(arg => arg.startsWith('--port='));
const urlArg = args.find(arg => arg.startsWith('--url='));

const selector = selectorArg || 'body';
const port = portArg ? portArg.split('=')[1] : '4321';
const targetUrl = urlArg ? urlArg.split('=')[1] : `http://localhost:${port}`;

console.log(`🔍 Checking visibility for: ${selector}`);
console.log(`Target URL: ${targetUrl}\n`);

const browser = await puppeteer.launch({ headless: true });
const page = await browser.newPage();

try {
  await page.goto(targetUrl, { waitUntil: 'networkidle2', timeout: 10000 });
  
  const exists = await page.evaluate((sel) => {
    return document.querySelector(sel) !== null;
  }, selector);
  
  if (!exists) {
    console.log(`❌ Element NOT FOUND in DOM: ${selector}\n`);
    
    console.log('🔎 Searching for similar elements...');
    const similar = await page.evaluate((sel) => {
      const parts = sel.split(/[.\s#\[]/);
      const classes = parts.filter(p => p && !p.match(/[=\]]/));
      const found = [];
      
      classes.forEach(cls => {
        const elements = document.querySelectorAll(`[class*="${cls}"]`);
        if (elements.length > 0) {
          found.push(`  Found ${elements.length} elements with class containing "${cls}"`);
        }
      });
      
      return found;
    }, selector);
    
    similar.forEach(s => console.log(s));
    await browser.close();
    process.exit(1);
  }
  
  console.log(`✅ Element EXISTS in DOM\n`);
  
  const visibility = await page.evaluate((sel) => {
    const el = document.querySelector(sel);
    if (!el) return null;
    
    const rect = el.getBoundingClientRect();
    const styles = window.getComputedStyle(el);
    
    return {
      inDOM: true,
      hasSize: rect.width > 0 && rect.height > 0,
      inViewport: rect.top < window.innerHeight && rect.bottom > 0 && 
                  rect.left < window.innerWidth && rect.right > 0,
      notHidden: styles.display !== 'none',
      notInvisible: styles.visibility !== 'hidden',
      hasOpacity: parseFloat(styles.opacity) > 0,
      zIndex: styles.zIndex,
      position: styles.position,
      width: rect.width,
      height: rect.height,
      top: rect.top,
      left: rect.left,
      display: styles.display,
      visibility: styles.visibility,
      opacity: styles.opacity,
      overflow: styles.overflow,
      hasChildren: el.children.length,
      hasTextContent: el.textContent.trim().length > 0,
      innerHTML: el.innerHTML.substring(0, 200)
    };
  }, selector);
  
  console.log('📊 VISIBILITY ANALYSIS:\n');
  
  const issues = [];
  const passes = [];
  
  if (!visibility.hasSize) {
    issues.push('❌ ZERO SIZE: Element has width or height of 0');
    console.log(`   Width: ${visibility.width}px, Height: ${visibility.height}px`);
  } else {
    passes.push(`✅ Has size: ${Math.round(visibility.width)}×${Math.round(visibility.height)}px`);
  }
  
  if (!visibility.inViewport) {
    issues.push('⚠️  OUT OF VIEWPORT: Element is outside visible area');
    console.log(`   Position: top ${Math.round(visibility.top)}px, left ${Math.round(visibility.left)}px`);
  } else {
    passes.push(`✅ In viewport`);
  }
  
  if (!visibility.notHidden) {
    issues.push('❌ DISPLAY NONE: Element has display:none');
  } else {
    passes.push(`✅ Display: ${visibility.display}`);
  }
  
  if (!visibility.notInvisible) {
    issues.push('❌ VISIBILITY HIDDEN: Element has visibility:hidden');
  } else {
    passes.push(`✅ Visibility: ${visibility.visibility}`);
  }
  
  if (!visibility.hasOpacity) {
    issues.push('❌ ZERO OPACITY: Element is transparent');
  } else {
    passes.push(`✅ Opacity: ${visibility.opacity}`);
  }
  
  if (visibility.hasChildren === 0 && !visibility.hasTextContent) {
    issues.push('⚠️  EMPTY CONTENT: No children or text content');
  } else {
    passes.push(`✅ Has content: ${visibility.hasChildren} children`);
  }
  
  console.log('PASSES:');
  passes.forEach(p => console.log(`  ${p}`));
  
  if (issues.length > 0) {
    console.log('\nISSUES FOUND:');
    issues.forEach(i => console.log(`  ${i}`));
  } else {
    console.log('\n✅ NO VISIBILITY ISSUES DETECTED');
  }
  
  console.log('\n📐 DIMENSIONS:');
  console.log(`  Size: ${Math.round(visibility.width)}×${Math.round(visibility.height)}px`);
  console.log(`  Position: (${Math.round(visibility.left)}, ${Math.round(visibility.top)})`);
  console.log(`  Z-index: ${visibility.zIndex}`);
  console.log(`  Position type: ${visibility.position}`);
  
  console.log('\n🎨 STYLES:');
  console.log(`  Display: ${visibility.display}`);
  console.log(`  Visibility: ${visibility.visibility}`);
  console.log(`  Opacity: ${visibility.opacity}`);
  console.log(`  Overflow: ${visibility.overflow}`);
  
  if (visibility.innerHTML.length > 0) {
    console.log('\n📄 CONTENT PREVIEW:');
    console.log(`  ${visibility.innerHTML.substring(0, 150)}...`);
  }
  
  await browser.close();
  process.exit(issues.length > 0 ? 1 : 0);
  
} catch (error) {
  console.error(`❌ Error: ${error.message}`);
  await browser.close();
  process.exit(1);
}

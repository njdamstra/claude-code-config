#!/usr/bin/env node
import puppeteer from 'puppeteer';

const args = process.argv.slice(2);
const portArg = args.find(arg => arg.startsWith('--port='));
const port = portArg ? portArg.split('=')[1] : '4321';
const targetUrl = `http://localhost:${port}`;

console.log(`🔍 Checking Vue rendering issues...`);
console.log(`Target URL: ${targetUrl}\n`);

const browser = await puppeteer.launch({ headless: true });
const page = await browser.newPage();

const vueErrors = [];
const vueWarnings = [];

page.on('console', msg => {
  const text = msg.text();
  const type = msg.type();
  
  if (text.includes('[Vue warn]') || text.includes('Vue')) {
    if (type === 'error') {
      vueErrors.push(text);
    } else if (type === 'warning') {
      vueWarnings.push(text);
    }
  }
});

try {
  await page.goto(targetUrl, { waitUntil: 'networkidle2', timeout: 10000 });
  await new Promise(resolve => setTimeout(resolve, 3000));
  
  // Check for Vue DevTools
  const hasVue = await page.evaluate(() => {
    return typeof window.__VUE__ !== 'undefined' || 
           typeof window.__vue_app__ !== 'undefined' ||
           document.querySelector('[data-v-]') !== null;
  });
  
  console.log(`Vue detected: ${hasVue ? '✅ Yes' : '❌ No'}\n`);
  
  // Check specific components
  const componentCheck = await page.evaluate(() => {
    const results = {
      workflowSection: !!document.querySelector('#workflows'),
      teleportLayerLeft: !!document.querySelector('#workflow-theater-layer-0-left'),
      teleportLayerRight: !!document.querySelector('#workflow-theater-layer-0-right'),
      manualChaosTheater: !!document.querySelector('.manual-chaos-theater-anchor'),
      manualChaosStage: !!document.querySelector('.manual-chaos-stage'),
      automatedWorkflowStage: !!document.querySelector('.automated-workflow-stage'),
      browserWindow: !!document.querySelector('.browser-window'),
      socialIcon: !!document.querySelector('.social-icon')
    };
    
    // Get teleport layer content
    const leftLayer = document.querySelector('#workflow-theater-layer-0-left');
    const rightLayer = document.querySelector('#workflow-theater-layer-0-right');
    
    return {
      ...results,
      leftLayerHTML: leftLayer ? leftLayer.innerHTML : 'NOT FOUND',
      rightLayerHTML: rightLayer ? rightLayer.innerHTML : 'NOT FOUND',
      leftLayerChildren: leftLayer ? leftLayer.children.length : 0,
      rightLayerChildren: rightLayer ? rightLayer.children.length : 0
    };
  });
  
  console.log('📊 COMPONENT DETECTION:\n');
  console.log(`  #workflows section: ${componentCheck.workflowSection ? '✅' : '❌'}`);
  console.log(`  Left teleport layer: ${componentCheck.teleportLayerLeft ? '✅' : '❌'} (${componentCheck.leftLayerChildren} children)`);
  console.log(`  Right teleport layer: ${componentCheck.teleportLayerRight ? '✅' : '❌'} (${componentCheck.rightLayerChildren} children)`);
  console.log(`  ManualChaosTheater anchor: ${componentCheck.manualChaosTheater ? '✅' : '❌'}`);
  console.log(`  ManualChaosStage: ${componentCheck.manualChaosStage ? '✅' : '❌'}`);
  console.log(`  AutomatedWorkflowStage: ${componentCheck.automatedWorkflowStage ? '✅' : '❌'}`);
  console.log(`  BrowserWindow: ${componentCheck.browserWindow ? '✅' : '❌'}`);
  console.log(`  SocialIcon: ${componentCheck.socialIcon ? '✅' : '❌'}`);
  
  if (componentCheck.leftLayerChildren === 0) {
    console.log('\n⚠️  LEFT TELEPORT LAYER IS EMPTY');
    console.log(`  HTML: ${componentCheck.leftLayerHTML.substring(0, 100)}`);
  }
  
  if (componentCheck.rightLayerChildren === 0) {
    console.log('\n⚠️  RIGHT TELEPORT LAYER IS EMPTY');
    console.log(`  HTML: ${componentCheck.rightLayerHTML.substring(0, 100)}`);
  }
  
  if (vueErrors.length > 0) {
    console.log('\n❌ VUE ERRORS:');
    vueErrors.forEach((err, i) => console.log(`  ${i + 1}. ${err}`));
  }
  
  if (vueWarnings.length > 0) {
    console.log('\n⚠️  VUE WARNINGS:');
    vueWarnings.slice(0, 5).forEach((warn, i) => console.log(`  ${i + 1}. ${warn}`));
  }
  
  await browser.close();
  process.exit(0);
  
} catch (error) {
  console.error(`❌ Error: ${error.message}`);
  await browser.close();
  process.exit(1);
}

#!/usr/bin/env node
import puppeteer from 'puppeteer';

const args = process.argv.slice(2);
const portArg = args.find(arg => arg.startsWith('--port='));
const port = portArg ? portArg.split('=')[1] : '4321';
const targetUrl = `http://localhost:${port}`;

console.log(`🔍 Checking console errors...`);
console.log(`Target URL: ${targetUrl}\n`);

const browser = await puppeteer.launch({ headless: true });
const page = await browser.newPage();

const errors = [];
const warnings = [];
const logs = [];

page.on('console', msg => {
  const text = msg.text();
  const type = msg.type();
  
  if (type === 'error') {
    errors.push(text);
  } else if (type === 'warning') {
    warnings.push(text);
  } else if (type === 'log') {
    logs.push(text);
  }
});

page.on('pageerror', error => {
  errors.push(`PageError: ${error.message}`);
});

try {
  await page.goto(targetUrl, { waitUntil: 'networkidle2', timeout: 10000 });
  
  await new Promise(resolve => setTimeout(resolve, 2000));
  
  console.log(`\n📊 CONSOLE REPORT:\n`);
  
  if (errors.length > 0) {
    console.log(`❌ ERRORS (${errors.length}):`);
    errors.forEach((err, i) => {
      console.log(`  ${i + 1}. ${err}`);
    });
  } else {
    console.log(`✅ No console errors`);
  }
  
  if (warnings.length > 0) {
    console.log(`\n⚠️  WARNINGS (${warnings.length}):`);
    warnings.slice(0, 10).forEach((warn, i) => {
      console.log(`  ${i + 1}. ${warn}`);
    });
  }
  
  if (logs.length > 0) {
    console.log(`\n📝 LOGS (${logs.length}):`);
    logs.slice(0, 5).forEach((log, i) => {
      console.log(`  ${i + 1}. ${log}`);
    });
  }
  
  await browser.close();
  process.exit(errors.length > 0 ? 1 : 0);
  
} catch (error) {
  console.error(`❌ Error: ${error.message}`);
  await browser.close();
  process.exit(1);
}

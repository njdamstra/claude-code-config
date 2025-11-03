#!/usr/bin/env node

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

/**
 * Universal Playwright executor
 * Usage:
 *   node run.js /path/to/script.js
 *   node run.js "inline code here"
 */

async function main() {
  const input = process.argv[2];

  if (!input) {
    console.error('❌ Usage: node run.js <script-path> OR node run.js "<inline-code>"');
    process.exit(1);
  }

  let code;

  // Check if input is a file path or inline code
  if (fs.existsSync(input)) {
    // Read from file
    code = fs.readFileSync(input, 'utf8');
    console.log(`📄 Executing: ${path.basename(input)}\n`);
  } else {
    // Treat as inline code
    code = input;
    console.log(`📝 Executing inline code\n`);
  }

  try {
    // Execute the code - it will require playwright itself
    const AsyncFunction = Object.getPrototypeOf(async function(){}).constructor;
    const fn = new AsyncFunction('require', code);
    await fn(require);
  } catch (error) {
    console.error('\n❌ Execution failed:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

main();

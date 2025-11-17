#!/usr/bin/env node

/**
 * Dark Mode Screenshot Tool
 * Takes side-by-side screenshots in light and dark modes for visual comparison
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

// CLI arguments
const urlArg = process.argv.find(arg => arg.startsWith('--url='));
const portArg = process.argv.find(arg => arg.startsWith('--port='));
const pathArg = process.argv.find(arg => arg.startsWith('--path='));

if (urlArg) {
  config.baseUrl = urlArg.split('=')[1];
} else if (portArg) {
  const port = portArg.split('=')[1];
  config.baseUrl = `http://localhost:${port}`;
}

// Optional path to append to base URL
const urlPath = pathArg ? pathArg.split('=')[1] : '';
const fullUrl = config.baseUrl + urlPath;

console.log('🌙 Dark Mode Screenshot Tool\n');
console.log(`Target URL: ${fullUrl}\n`);

(async () => {
  const browser = await puppeteer.launch({
    headless: 'new',
    ...(config.puppeteer || {})
  });

  const page = await browser.newPage();

  // Set viewport for consistent screenshots
  await page.setViewport({
    width: 1280,
    height: 900,
    deviceScaleFactor: 1
  });

  try {
    // Navigate to page
    console.log('📄 Loading page...');
    await page.goto(fullUrl, { waitUntil: 'networkidle0' });

    const outputDir = path.join(process.cwd(), config.outputDir);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    // Take light mode screenshot
    console.log('☀️  Capturing light mode...');
    await page.evaluate(() => {
      // Remove dark class if present
      document.documentElement.classList.remove('dark');
    });
    await page.waitForTimeout(500); // Let transitions settle

    const lightPath = path.join(outputDir, 'dark-mode-light.png');
    await page.screenshot({
      path: lightPath,
      fullPage: true
    });
    console.log(`   ✅ Saved: ${lightPath}`);

    // Take dark mode screenshot
    console.log('🌙 Capturing dark mode...');
    await page.evaluate(() => {
      // Add dark class
      document.documentElement.classList.add('dark');
    });
    await page.waitForTimeout(500); // Let transitions settle

    const darkPath = path.join(outputDir, 'dark-mode-dark.png');
    await page.screenshot({
      path: darkPath,
      fullPage: true
    });
    console.log(`   ✅ Saved: ${darkPath}`);

    // Analyze colors used in both modes
    console.log('\n🎨 Analyzing color usage...');

    const colorAnalysis = await page.evaluate(() => {
      const getColors = () => {
        const elements = document.querySelectorAll('*');
        const colors = {
          backgrounds: new Set(),
          texts: new Set(),
          borders: new Set()
        };

        elements.forEach(el => {
          const computed = getComputedStyle(el);

          if (computed.backgroundColor && computed.backgroundColor !== 'rgba(0, 0, 0, 0)') {
            colors.backgrounds.add(computed.backgroundColor);
          }
          if (computed.color) {
            colors.texts.add(computed.color);
          }
          if (computed.borderColor && computed.borderColor !== 'rgba(0, 0, 0, 0)') {
            colors.borders.add(computed.borderColor);
          }
        });

        return {
          backgrounds: Array.from(colors.backgrounds),
          texts: Array.from(colors.texts),
          borders: Array.from(colors.borders)
        };
      };

      // Get dark mode colors
      document.documentElement.classList.add('dark');
      const darkColors = getColors();

      // Get light mode colors
      document.documentElement.classList.remove('dark');
      const lightColors = getColors();

      return {
        light: lightColors,
        dark: darkColors,
        stats: {
          lightBgCount: lightColors.backgrounds.length,
          darkBgCount: darkColors.backgrounds.length,
          lightTextCount: lightColors.texts.length,
          darkTextCount: darkColors.texts.length
        }
      };
    });

    // Save analysis
    const analysisPath = path.join(outputDir, 'dark-mode-analysis.json');
    fs.writeFileSync(analysisPath, JSON.stringify(colorAnalysis, null, 2));
    console.log(`   ✅ Color analysis saved: ${analysisPath}`);

    // Print summary
    console.log('\n📊 Color Summary:');
    console.log(`   Light mode: ${colorAnalysis.stats.lightBgCount} backgrounds, ${colorAnalysis.stats.lightTextCount} text colors`);
    console.log(`   Dark mode: ${colorAnalysis.stats.darkBgCount} backgrounds, ${colorAnalysis.stats.darkTextCount} text colors`);

    // Check for potential issues
    console.log('\n🔍 Potential Issues:');

    if (colorAnalysis.stats.darkBgCount === colorAnalysis.stats.lightBgCount) {
      console.log('   ⚠️  Same number of backgrounds in both modes - dark mode may not be working');
    } else {
      console.log('   ✅ Different colors detected in dark mode');
    }

    // Check for common light mode colors in dark mode
    const lightBgSet = new Set(colorAnalysis.light.backgrounds);
    const darkBgSet = new Set(colorAnalysis.dark.backgrounds);

    const sharedBg = colorAnalysis.light.backgrounds.filter(c => darkBgSet.has(c));
    if (sharedBg.length > 0) {
      console.log(`   ℹ️  ${sharedBg.length} colors shared between modes (may be intentional)`);
    }

    console.log('\n✅ Screenshots complete!');
    console.log('\n📸 Compare visually:');
    console.log(`   Light: ${lightPath}`);
    console.log(`   Dark:  ${darkPath}`);

    console.log('\n💡 Tip: Open both screenshots side-by-side to verify dark mode styling');

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
})();

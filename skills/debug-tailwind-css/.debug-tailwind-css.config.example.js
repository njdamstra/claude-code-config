/**
 * Debug Tailwind CSS Configuration
 * Copy this to your project root as .debug-tailwind-css.config.js
 */

module.exports = {
  // Base URL for your development server
  baseUrl: 'http://localhost:4321',
  
  // Paths to scan for analysis
  scanPaths: [
    'src/**/*.vue',
    'src/**/*.astro',
    'src/**/*.jsx',
    'src/**/*.tsx'
  ],
  
  // Tailwind breakpoints for testing
  breakpoints: {
    sm: 640,
    md: 768,
    lg: 1024,
    xl: 1280,
    '2xl': 1536
  },
  
  // Puppeteer browser options
  puppeteer: {
    headless: 'new',
    viewport: {
      width: 1280,
      height: 720
    },
    // Uncomment for debugging
    // headless: false,
    // devtools: true
  },
  
  // Output directory for reports
  outputDir: '.debug-output',
  
  // Optional: Custom z-index ranges
  zIndexRanges: {
    content: [0, 10],
    dropdowns: [10, 20],
    modals: [20, 30],
    tooltips: [30, 40],
    notifications: [40, 50]
  }
};

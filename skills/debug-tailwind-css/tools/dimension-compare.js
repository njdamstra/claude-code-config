#!/usr/bin/env node

/**
 * Dimension Compare
 * Compares dimensions across similar components
 */

const fs = require('fs');
const path = require('path');
const { glob } = require('glob');

const componentName = process.argv[2];

if (!componentName) {
  console.error('Usage: npm run compare:dimensions -- <ComponentName>');
  console.error('Example: npm run compare:dimensions -- Button');
  process.exit(1);
}

console.log(`🔍 Comparing dimensions for: *${componentName}*\n`);

// Find matching files
const pattern = `src/**/*${componentName}*.vue`;
const files = glob.sync(pattern);

if (files.length === 0) {
  console.error(`❌ No files found matching: ${pattern}`);
  process.exit(1);
}

console.log(`Found ${files.length} files:\n`);

const results = files.map(file => {
  const content = fs.readFileSync(file, 'utf-8');
  
  // Extract class attributes
  const classMatches = content.match(/class="([^"]*)"/g) || [];
  const allClasses = classMatches.join(' ');
  
  // Extract specific dimension classes
  const width = (allClasses.match(/\bw-[^\s]*/g) || []).join(' ');
  const height = (allClasses.match(/\bh-[^\s]*/g) || []).join(' ');
  const padding = (allClasses.match(/\bp[xytbrl]?-[^\s]*/g) || []).join(' ');
  const margin = (allClasses.match(/\bm[xytbrl]?-[^\s]*/g) || []).join(' ');
  const text = (allClasses.match(/\btext-[^\s]*/g) || []).join(' ');
  const gap = (allClasses.match(/\bgap-[^\s]*/g) || []).join(' ');
  
  return {
    file: path.basename(file),
    path: file,
    width: width || '(none)',
    height: height || '(none)',
    padding: padding || '(none)',
    margin: margin || '(none)',
    text: text || '(none)',
    gap: gap || '(none)'
  };
});

// Display comparison
results.forEach((result, i) => {
  console.log(`${i + 1}. ${result.file}`);
  console.log(`   Path: ${result.path}`);
  console.log(`   Width: ${result.width}`);
  console.log(`   Height: ${result.height}`);
  console.log(`   Padding: ${result.padding}`);
  console.log(`   Margin: ${result.margin}`);
  console.log(`   Text: ${result.text}`);
  console.log(`   Gap: ${result.gap}`);
  console.log('');
});

// Find inconsistencies
const widths = results.map(r => r.width).filter(w => w !== '(none)');
const uniqueWidths = [...new Set(widths)];

const paddings = results.map(r => r.padding).filter(p => p !== '(none)');
const uniquePaddings = [...new Set(paddings)];

console.log('📊 Consistency Analysis:\n');
console.log(`Width variations: ${uniqueWidths.length}`);
if (uniqueWidths.length > 1) {
  console.log(`   ⚠️  Found ${uniqueWidths.length} different width patterns`);
  uniqueWidths.forEach(w => console.log(`      - ${w}`));
} else {
  console.log('   ✅ Consistent width usage');
}
console.log('');

console.log(`Padding variations: ${uniquePaddings.length}`);
if (uniquePaddings.length > 1) {
  console.log(`   ⚠️  Found ${uniquePaddings.length} different padding patterns`);
  uniquePaddings.forEach(p => console.log(`      - ${p}`));
} else {
  console.log('   ✅ Consistent padding usage');
}
console.log('');

// Save to file
const outputDir = path.join(process.cwd(), '.debug-output');
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

const outputFile = path.join(outputDir, `dimension-compare-${componentName}.json`);
fs.writeFileSync(outputFile, JSON.stringify(results, null, 2));

console.log(`✅ Full report saved to: ${outputFile}`);

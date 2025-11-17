#!/usr/bin/env node

/**
 * Specificity Calculator
 * Calculates and compares CSS selector specificity
 */

function calculateSpecificity(selector) {
  // Simple specificity calculation
  // Format: [a, b, c] where:
  // a = number of ID selectors
  // b = number of class selectors, attributes, pseudo-classes
  // c = number of type selectors and pseudo-elements

  const ids = (selector.match(/#[\w-]+/g) || []).length;
  const classes = (selector.match(/\.[\w-]+/g) || []).length;
  const attrs = (selector.match(/\[[\w-]+\]/g) || []).length;
  const pseudoClasses = (selector.match(/:(?!:)[\w-]+/g) || []).length;
  const elements = (selector.match(/^[\w-]+|[\s>+~][\w-]+/g) || []).length;
  const pseudoElements = (selector.match(/::[\w-]+/g) || []).length;

  return {
    selector,
    a: ids,
    b: classes + attrs + pseudoClasses,
    c: elements + pseudoElements,
    specificity: [ids, classes + attrs + pseudoClasses, elements + pseudoElements]
  };
}

const selectors = process.argv.slice(2);

if (selectors.length === 0) {
  console.error('Usage: npm run calc:specificity -- "<selector1>" "<selector2>" ...');
  console.error('Example: npm run calc:specificity -- ".btn" ".btn-primary" "#submit"');
  process.exit(1);
}

console.log('🎯 CSS Specificity Calculator\n');

try {
  const results = selectors.map(calculateSpecificity);

  // Sort by specificity (descending)
  results.sort((a, b) => {
    if (a.a !== b.a) return b.a - a.a;
    if (a.b !== b.b) return b.b - a.b;
    return b.c - a.c;
  });

  // Display results
  console.log('Specificity (descending order):\n');
  results.forEach((result, i) => {
    console.log(`${i + 1}. ${result.selector}`);
    console.log(`   Specificity: (${result.specificity.join(', ')})`);
    console.log(`   IDs: ${result.a}, Classes/Attrs: ${result.b}, Elements: ${result.c}`);
    console.log('');
  });

  // Winner
  if (results.length > 1) {
    console.log(`🏆 Most specific: ${results[0].selector}`);
    console.log(`   Specificity: (${results[0].specificity.join(', ')})\n`);
  }

  // Explain
  console.log('ℹ️  Specificity is calculated as (IDs, Classes/Attrs, Elements)');
  console.log('   IDs have highest priority');
  console.log('   Classes, attributes, and pseudo-classes are next');
  console.log('   Elements and pseudo-elements have lowest priority');

} catch (error) {
  console.error('Error:', error.message);
  process.exit(1);
}

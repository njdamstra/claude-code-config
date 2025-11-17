#!/bin/bash

##
# Flex and Grid Layout Analyzer
# Finds all flex/grid usage patterns in Vue files
##

echo "🔍 Analyzing Flex/Grid Layouts..."
echo ""

# Default scan path
SCAN_PATH="${1:-src}"

OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/flex-grid-analysis.txt"

# Clear output file
> "$OUTPUT_FILE"

echo "=== FLEX/GRID LAYOUT ANALYSIS ===" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find files with flex or grid
FLEX_FILES=$(grep -rl "display.*flex\|flex \|flex-" "$SCAN_PATH" --include="*.vue" --include="*.astro" 2>/dev/null)
GRID_FILES=$(grep -rl "display.*grid\|grid \|grid-" "$SCAN_PATH" --include="*.vue" --include="*.astro" 2>/dev/null)

# Count totals
FLEX_COUNT=$(echo "$FLEX_FILES" | grep -c "^" 2>/dev/null || echo "0")
GRID_COUNT=$(echo "$GRID_FILES" | grep -c "^" 2>/dev/null || echo "0")

echo "📊 Summary" >> "$OUTPUT_FILE"
echo "  Flex containers: $FLEX_COUNT files" >> "$OUTPUT_FILE"
echo "  Grid containers: $GRID_COUNT files" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Analyze Flex layouts
if [ ! -z "$FLEX_FILES" ]; then
  echo "=== FLEXBOX USAGE ===" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  
  for file in $FLEX_FILES; do
    echo "📄 $file" >> "$OUTPUT_FILE"
    
    # Extract flex-related classes
    grep -o "flex[^ \"']*\|justify-[^ \"']*\|items-[^ \"']*\|gap-[^ \"']*" "$file" | \
      sort | uniq >> "$OUTPUT_FILE"
    
    # Check for flex-wrap
    if ! grep -q "flex-wrap" "$file"; then
      echo "  ⚠️  No flex-wrap found (may cause overflow)" >> "$OUTPUT_FILE"
    fi
    
    echo "" >> "$OUTPUT_FILE"
  done
fi

# Analyze Grid layouts
if [ ! -z "$GRID_FILES" ]; then
  echo "=== GRID USAGE ===" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  
  for file in $GRID_FILES; do
    echo "📄 $file" >> "$OUTPUT_FILE"
    
    # Extract grid-related classes
    grep -o "grid[^ \"']*\|gap-[^ \"']*\|col-[^ \"']*\|row-[^ \"']*" "$file" | \
      sort | uniq >> "$OUTPUT_FILE"
    
    echo "" >> "$OUTPUT_FILE"
  done
fi

# Find potential issues
echo "=== POTENTIAL ISSUES ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Fixed widths in flex/grid
echo "🔍 Fixed widths in flex/grid containers:" >> "$OUTPUT_FILE"
for file in $FLEX_FILES $GRID_FILES; do
  if grep -q "w-\[.*px\]\|width:.*px" "$file" 2>/dev/null; then
    echo "  ⚠️  $file" >> "$OUTPUT_FILE"
  fi
done
echo "" >> "$OUTPUT_FILE"

# Missing gap
echo "🔍 Flex/Grid without gap property:" >> "$OUTPUT_FILE"
for file in $FLEX_FILES $GRID_FILES; do
  if ! grep -q "gap-\|gap:" "$file" 2>/dev/null; then
    echo "  ℹ️  $file (uses spacing instead?)" >> "$OUTPUT_FILE"
  fi
done

# Output to console
cat "$OUTPUT_FILE"

echo ""
echo "✅ Analysis complete. Full report saved to: $OUTPUT_FILE"

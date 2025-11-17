#!/bin/bash

##
# Component-Specific Debugger
# Deep analysis of a single component: layout, spacing, z-index, structure
##

COMPONENT_FILE="$1"

if [ -z "$COMPONENT_FILE" ]; then
  echo "Usage: bash component-debugger.sh <path/to/Component.vue>"
  echo "Example: bash component-debugger.sh src/components/vue/modals/BaseModal.vue"
  exit 1
fi

if [ ! -f "$COMPONENT_FILE" ]; then
  echo "❌ File not found: $COMPONENT_FILE"
  exit 1
fi

OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"

COMPONENT_NAME=$(basename "$COMPONENT_FILE" .vue)
OUTPUT_FILE="$OUTPUT_DIR/component-debug-$COMPONENT_NAME.txt"

echo "🔍 Deep Analysis: $COMPONENT_FILE"
echo ""

# Clear output file
cat > "$OUTPUT_FILE" << EOF
===========================================
COMPONENT DEBUG REPORT: $COMPONENT_NAME
===========================================
File: $COMPONENT_FILE
Generated: $(date)

EOF

# 1. FILE STRUCTURE
echo "📁 Analyzing component structure..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "=== COMPONENT STRUCTURE ===" >> "$OUTPUT_FILE"
LINES=$(wc -l < "$COMPONENT_FILE")
echo "Total lines: $LINES" >> "$OUTPUT_FILE"

# Count template vs script vs style
TEMPLATE_LINES=$(grep -c "<template>\|</template>" "$COMPONENT_FILE" 2>/dev/null || echo "0")
SCRIPT_LINES=$(grep -c "<script.*>\|</script>" "$COMPONENT_FILE" 2>/dev/null || echo "0")
STYLE_LINES=$(grep -c "<style.*>\|</style>" "$COMPONENT_FILE" 2>/dev/null || echo "0")

echo "Template blocks: $TEMPLATE_LINES" >> "$OUTPUT_FILE"
echo "Script blocks: $SCRIPT_LINES" >> "$OUTPUT_FILE"
echo "Style blocks: $STYLE_LINES" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 2. LAYOUT ANALYSIS
echo "📐 Analyzing layout patterns..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "=== LAYOUT PATTERNS ===" >> "$OUTPUT_FILE"

# Display type
if grep -q "display.*flex\|class=\"[^\"]*flex" "$COMPONENT_FILE"; then
  echo "✓ Uses Flexbox" >> "$OUTPUT_FILE"

  # Flex properties
  FLEX_CLASSES=$(grep -o "flex[^ \"']*\|justify-[^ \"']*\|items-[^ \"']*\|gap-[^ \"']*" "$COMPONENT_FILE" | sort | uniq -c | sort -rn)
  if [ ! -z "$FLEX_CLASSES" ]; then
    echo "" >> "$OUTPUT_FILE"
    echo "Flex classes used:" >> "$OUTPUT_FILE"
    echo "$FLEX_CLASSES" >> "$OUTPUT_FILE"
  fi

  # Check for flex-wrap
  if ! grep -q "flex-wrap" "$COMPONENT_FILE"; then
    echo "" >> "$OUTPUT_FILE"
    echo "⚠️  WARNING: No flex-wrap found (may cause overflow on small screens)" >> "$OUTPUT_FILE"
  fi
fi

if grep -q "display.*grid\|class=\"[^\"]*grid" "$COMPONENT_FILE"; then
  echo "✓ Uses Grid" >> "$OUTPUT_FILE"

  # Grid properties
  GRID_CLASSES=$(grep -o "grid[^ \"']*\|gap-[^ \"']*\|col-[^ \"']*\|row-[^ \"']*" "$COMPONENT_FILE" | sort | uniq -c | sort -rn)
  if [ ! -z "$GRID_CLASSES" ]; then
    echo "" >> "$OUTPUT_FILE"
    echo "Grid classes used:" >> "$OUTPUT_FILE"
    echo "$GRID_CLASSES" >> "$OUTPUT_FILE"
  fi
fi

echo "" >> "$OUTPUT_FILE"

# 3. SPACING ANALYSIS
echo "📏 Analyzing spacing..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "=== SPACING PATTERNS ===" >> "$OUTPUT_FILE"

# Gap
GAP_USAGE=$(grep -o "gap-[^ \"']*" "$COMPONENT_FILE" | sort | uniq -c | sort -rn)
if [ ! -z "$GAP_USAGE" ]; then
  echo "Gap:" >> "$OUTPUT_FILE"
  echo "$GAP_USAGE" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Padding
PADDING_USAGE=$(grep -o "p-[0-9]*\|px-[0-9]*\|py-[0-9]*\|pt-[0-9]*\|pb-[0-9]*\|pl-[0-9]*\|pr-[0-9]*" "$COMPONENT_FILE" | sort | uniq -c | sort -rn | head -10)
if [ ! -z "$PADDING_USAGE" ]; then
  echo "Padding (top 10):" >> "$OUTPUT_FILE"
  echo "$PADDING_USAGE" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Margin
MARGIN_USAGE=$(grep -o "m-[0-9]*\|mx-[0-9]*\|my-[0-9]*\|mt-[0-9]*\|mb-[0-9]*\|ml-[0-9]*\|mr-[0-9]*" "$COMPONENT_FILE" | sort | uniq -c | sort -rn | head -10)
if [ ! -z "$MARGIN_USAGE" ]; then
  echo "Margin (top 10):" >> "$OUTPUT_FILE"
  echo "$MARGIN_USAGE" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# 4. Z-INDEX & POSITIONING
echo "🏗️ Analyzing positioning..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "=== POSITIONING & STACKING ===" >> "$OUTPUT_FILE"

# Position values
POSITIONS=$(grep -o "absolute\|relative\|fixed\|sticky" "$COMPONENT_FILE" | sort | uniq -c)
if [ ! -z "$POSITIONS" ]; then
  echo "Position types:" >> "$OUTPUT_FILE"
  echo "$POSITIONS" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Z-index usage
Z_INDEX=$(grep -o "z-[0-9]*\|z-\[[0-9]*\]" "$COMPONENT_FILE" | sort | uniq -c | sort -rn)
if [ ! -z "$Z_INDEX" ]; then
  echo "Z-index values:" >> "$OUTPUT_FILE"
  echo "$Z_INDEX" >> "$OUTPUT_FILE"

  # Check for z-index conflicts (multiple different values)
  Z_COUNT=$(echo "$Z_INDEX" | wc -l)
  if [ "$Z_COUNT" -gt 3 ]; then
    echo "" >> "$OUTPUT_FILE"
    echo "⚠️  WARNING: Component uses $Z_COUNT different z-index values (potential stacking issues)" >> "$OUTPUT_FILE"
  fi
else
  echo "No z-index found" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# 5. COMPONENT DEPENDENCIES
echo "🔗 Analyzing component imports..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "=== COMPONENT DEPENDENCIES ===" >> "$OUTPUT_FILE"

# Extract imports from script section
IMPORTS=$(grep "import.*from\|import.*@" "$COMPONENT_FILE" | grep -v "^//")
if [ ! -z "$IMPORTS" ]; then
  echo "$IMPORTS" >> "$OUTPUT_FILE"
else
  echo "No component imports found" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# 6. POTENTIAL ISSUES
echo "🚨 Checking for common issues..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "=== POTENTIAL ISSUES ===" >> "$OUTPUT_FILE"

ISSUES_FOUND=0

# Check for fixed widths
if grep -q "w-\[.*px\]\|width:.*px" "$COMPONENT_FILE"; then
  echo "⚠️  Fixed pixel widths found (may break responsive layout)" >> "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check for !important
if grep -q "!important" "$COMPONENT_FILE"; then
  IMPORTANT_COUNT=$(grep -c "!important" "$COMPONENT_FILE")
  echo "⚠️  Uses !important ($IMPORTANT_COUNT times) - specificity issues?" >> "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check for inline styles
INLINE_STYLES=$(grep -c ":style=" "$COMPONENT_FILE" 2>/dev/null || echo "0")
if [ "$INLINE_STYLES" -gt 0 ]; then
  echo "ℹ️  Uses inline styles ($INLINE_STYLES times) - consider Tailwind classes" >> "$OUTPUT_FILE"
fi

# Check for scoped styles
if grep -q "<style scoped>" "$COMPONENT_FILE"; then
  echo "✓ Uses scoped styles" >> "$OUTPUT_FILE"
else
  if grep -q "<style" "$COMPONENT_FILE"; then
    echo "⚠️  Has <style> block without 'scoped' (may leak styles)" >> "$OUTPUT_FILE"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  fi
fi

if [ "$ISSUES_FOUND" -eq 0 ]; then
  echo "✅ No major issues detected" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# 7. SUMMARY
echo "=== SUMMARY ===" >> "$OUTPUT_FILE"
echo "Component: $COMPONENT_NAME" >> "$OUTPUT_FILE"
echo "Issues found: $ISSUES_FOUND" >> "$OUTPUT_FILE"
echo "Full report: $OUTPUT_FILE" >> "$OUTPUT_FILE"

# Output to console
cat "$OUTPUT_FILE"

echo ""
echo "✅ Component analysis complete!"
echo "📄 Full report saved to: $OUTPUT_FILE"

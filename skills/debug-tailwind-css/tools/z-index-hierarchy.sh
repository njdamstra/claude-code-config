#!/bin/bash

##
# Z-Index Hierarchy Analyzer
# Maps z-index values and stacking contexts
##

echo "🔍 Analyzing Z-Index and Stacking Contexts..."
echo ""

SCAN_PATH="${1:-src}"
OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/z-index-analysis.txt"

> "$OUTPUT_FILE"

echo "=== Z-INDEX & STACKING CONTEXT ANALYSIS ===" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find all z-index declarations
echo "📊 Z-INDEX VALUES" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

Z_INDEX_MATCHES=$(grep -rn "z-\[.*\]\|z-[0-9]\+\|z-index:" "$SCAN_PATH" --include="*.vue" --include="*.css")

if [ ! -z "$Z_INDEX_MATCHES" ]; then
  echo "$Z_INDEX_MATCHES" | sort -t: -k3 -rn >> "$OUTPUT_FILE"
  
  # Extract and sort unique values
  echo "" >> "$OUTPUT_FILE"
  echo "Unique z-index values (sorted):" >> "$OUTPUT_FILE"
  echo "$Z_INDEX_MATCHES" | \
    grep -o "z-[0-9]\+\|z-\[[0-9]\+\]\|z-index:[  ]*[0-9]\+" | \
    sed 's/z-\[\([0-9]*\)\]/\1/; s/z-//' | \
    sed 's/z-index:[  ]*//' | \
    sort -n | uniq >> "$OUTPUT_FILE"
else
  echo "No z-index declarations found" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find elements that create stacking contexts
echo "🏗️  STACKING CONTEXT CREATORS" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Position (absolute/relative/fixed + z-index):" >> "$OUTPUT_FILE"
grep -rn "position.*\(absolute\|relative\|fixed\)" "$SCAN_PATH" --include="*.vue" -A1 | \
  grep -B1 "z-index\|z-" | head -20 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Transform properties:" >> "$OUTPUT_FILE"
grep -rn "transform:" "$SCAN_PATH" --include="*.vue" --include="*.css" | head -15 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Opacity < 1:" >> "$OUTPUT_FILE"
grep -rn "opacity-[0-9]\|opacity:.*0\.[0-9]" "$SCAN_PATH" --include="*.vue" | head -15 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Will-change property:" >> "$OUTPUT_FILE"
grep -rn "will-change" "$SCAN_PATH" --include="*.vue" --include="*.css" | head -15 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Isolation property:" >> "$OUTPUT_FILE"
grep -rn "isolation:" "$SCAN_PATH" --include="*.vue" --include="*.css" | head -15 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Potential z-index conflicts
echo "=== POTENTIAL CONFLICTS ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find same z-index values in different files
echo "Files using same z-index values:" >> "$OUTPUT_FILE"
DUPLICATE_Z=$(echo "$Z_INDEX_MATCHES" | \
  grep -o "z-[0-9]\+\|z-\[[0-9]\+\]" | \
  sort | uniq -d)

if [ ! -z "$DUPLICATE_Z" ]; then
  for z in $DUPLICATE_Z; do
    echo "  $z used in:" >> "$OUTPUT_FILE"
    echo "$Z_INDEX_MATCHES" | grep "$z" | cut -d: -f1 | uniq >> "$OUTPUT_FILE"
  done
else
  echo "  ✅ No duplicate z-index values found" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# High z-index values (potential z-index war)
echo "⚠️  High z-index values (> 100):" >> "$OUTPUT_FILE"
echo "$Z_INDEX_MATCHES" | \
  grep -E "z-[1-9][0-9]{2,}\|z-\[[1-9][0-9]{2,}\]\|z-index:[  ]*[1-9][0-9]{2,}" | \
  head -10 >> "$OUTPUT_FILE"

# Recommendations
echo "" >> "$OUTPUT_FILE"
echo "=== RECOMMENDATIONS ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "1. Use z-index sparingly and with clear purpose" >> "$OUTPUT_FILE"
echo "2. Document z-index ranges for different UI layers:" >> "$OUTPUT_FILE"
echo "   - Base content: 0-10" >> "$OUTPUT_FILE"
echo "   - Dropdowns/popovers: 10-20" >> "$OUTPUT_FILE"
echo "   - Modals/dialogs: 20-30" >> "$OUTPUT_FILE"
echo "   - Tooltips: 30-40" >> "$OUTPUT_FILE"
echo "   - Notifications: 40-50" >> "$OUTPUT_FILE"
echo "3. Avoid z-index values > 100 unless absolutely necessary" >> "$OUTPUT_FILE"
echo "4. Create stacking contexts intentionally to isolate z-index" >> "$OUTPUT_FILE"

# Output to console
cat "$OUTPUT_FILE"

echo ""
echo "✅ Analysis complete. Full report saved to: $OUTPUT_FILE"

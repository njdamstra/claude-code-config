#!/bin/bash

##
# Spacing Analyzer
# Audits gap, padding, and margin usage patterns
##

echo "🔍 Analyzing Spacing Patterns..."
echo ""

SCAN_PATH="${1:-src}"
OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/spacing-analysis.txt"

> "$OUTPUT_FILE"

echo "=== SPACING USAGE ANALYSIS ===" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Gap usage (flex/grid)
echo "📏 GAP CLASSES (Flex/Grid spacing)" >> "$OUTPUT_FILE"
echo "Top 10 most used:" >> "$OUTPUT_FILE"
grep -roh "gap-[^ \"'<>]*" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn | head -10 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Padding usage
echo "📦 PADDING CLASSES" >> "$OUTPUT_FILE"

echo "  Uniform padding (p-):" >> "$OUTPUT_FILE"
grep -roh "\bp-[0-9]\+\b" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn | head -10 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "  Horizontal padding (px-):" >> "$OUTPUT_FILE"
grep -roh "\bpx-[0-9]\+\b" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn | head -10 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "  Vertical padding (py-):" >> "$OUTPUT_FILE"
grep -roh "\bpy-[0-9]\+\b" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn | head -10 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Margin usage
echo "📐 MARGIN CLASSES" >> "$OUTPUT_FILE"

echo "  Uniform margin (m-):" >> "$OUTPUT_FILE"
grep -roh "\bm-[0-9]\+\b" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn | head -10 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "  Horizontal margin (mx-):" >> "$OUTPUT_FILE"
grep -roh "\bmx-[0-9]\+\b\|mx-auto" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn | head -10 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "  Vertical margin (my-):" >> "$OUTPUT_FILE"
grep -roh "\bmy-[0-9]\+\b" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn | head -10 >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Space between classes
echo "🔀 SPACE-BETWEEN/AROUND USAGE" >> "$OUTPUT_FILE"
grep -roh "space-[xy]-[^ \"'<>]*" "$SCAN_PATH" --include="*.vue" | \
  sort | uniq -c | sort -rn >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Consistency check
echo "=== CONSISTENCY ANALYSIS ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Count unique spacing values
UNIQUE_PADDINGS=$(grep -roh "p[trblxy]\?-[0-9]\+" "$SCAN_PATH" --include="*.vue" | \
  sed 's/.*-//' | sort -u | wc -l)
UNIQUE_MARGINS=$(grep -roh "m[trblxy]\?-[0-9]\+" "$SCAN_PATH" --include="*.vue" | \
  sed 's/.*-//' | sort -u | wc -l)
UNIQUE_GAPS=$(grep -roh "gap-[0-9]\+" "$SCAN_PATH" --include="*.vue" | \
  sed 's/.*-//' | sort -u | wc -l)

echo "Unique spacing values:" >> "$OUTPUT_FILE"
echo "  Padding: $UNIQUE_PADDINGS different values" >> "$OUTPUT_FILE"
echo "  Margin: $UNIQUE_MARGINS different values" >> "$OUTPUT_FILE"
echo "  Gap: $UNIQUE_GAPS different values" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ "$UNIQUE_PADDINGS" -gt 10 ] || [ "$UNIQUE_MARGINS" -gt 10 ]; then
  echo "⚠️  High variation in spacing values detected" >> "$OUTPUT_FILE"
  echo "Consider standardizing to Tailwind's spacing scale" >> "$OUTPUT_FILE"
else
  echo "✅ Spacing values appear consistent with design system" >> "$OUTPUT_FILE"
fi

# Output to console
cat "$OUTPUT_FILE"

echo ""
echo "✅ Analysis complete. Full report saved to: $OUTPUT_FILE"

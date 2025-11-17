#!/bin/bash

##
# Duplicate Detector
# Finds components with similar class patterns
##

echo "🔍 Detecting Potential Duplicate Components..."
echo ""

SCAN_PATH="${1:-src/components}"
OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"

# Find all Vue components and extract their class patterns
find "$SCAN_PATH" -name "*.vue" -type f | while read file; do
  # Extract all classes
  classes=$(grep -o 'class="[^"]*"' "$file" | head -1 | tr ' ' '\n' | sort | tr '\n' ' ')
  echo "$file: $classes"
done | sort -t: -k2 > "$OUTPUT_DIR/component-classes.txt"

echo "Component class patterns saved to: $OUTPUT_DIR/component-classes.txt"
echo ""
echo "Finding similar patterns..."
echo ""

# Find files with >80% similar classes (simple heuristic)
awk -F: '{print $2}' "$OUTPUT_DIR/component-classes.txt" | \
  sort | uniq -d | while read pattern; do
    if [ ! -z "$pattern" ]; then
      echo "⚠️  Similar class pattern found in:"
      grep -F "$pattern" "$OUTPUT_DIR/component-classes.txt" | cut -d: -f1
      echo ""
    fi
  done

echo "✅ Analysis complete"

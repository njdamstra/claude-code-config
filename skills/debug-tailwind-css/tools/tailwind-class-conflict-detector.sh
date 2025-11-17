#!/bin/bash

##
# Tailwind Class Conflict Detector
# Finds conflicting Tailwind utility classes that override each other
##

SCAN_PATH="${1:-src}"

echo "🔍 Detecting Tailwind Class Conflicts..."
echo ""

OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/class-conflicts.txt"

> "$OUTPUT_FILE"

echo "=== TAILWIND CLASS CONFLICT REPORT ===" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "Scan path: $SCAN_PATH" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

TOTAL_CONFLICTS=0

# Function to check for conflicts in a file
check_file_conflicts() {
  local file="$1"
  local conflicts_found=0

  # Extract all class attributes
  grep -o 'class="[^"]*"' "$file" 2>/dev/null | while IFS= read -r class_attr; do
    local classes=$(echo "$class_attr" | sed 's/class="//;s/"//')
    local line_num=$(grep -n "$class_attr" "$file" | head -1 | cut -d: -f1)

    # Check width conflicts
    if echo "$classes" | grep -qE 'w-full.*w-[0-9]+|w-[0-9]+.*w-full'; then
      echo "  ⚠️  Line $line_num: Width conflict (w-full + w-*)" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    if echo "$classes" | grep -qE 'w-[0-9]+.*w-[0-9]+'; then
      # Check if different width values
      widths=$(echo "$classes" | grep -oE 'w-[0-9]+' | sort -u)
      if [ $(echo "$widths" | wc -l) -gt 1 ]; then
        echo "  ⚠️  Line $line_num: Multiple width classes" >> "$OUTPUT_FILE"
        echo "      Classes: $classes" >> "$OUTPUT_FILE"
        echo "      Widths: $(echo $widths | tr '\n' ' ')" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        conflicts_found=$((conflicts_found + 1))
      fi
    fi

    # Check height conflicts
    if echo "$classes" | grep -qE 'h-full.*h-[0-9]+|h-[0-9]+.*h-full'; then
      echo "  ⚠️  Line $line_num: Height conflict (h-full + h-*)" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check display conflicts
    if echo "$classes" | grep -qE 'hidden.*(flex|block|inline|grid)|((flex|block|inline|grid)).*hidden'; then
      echo "  ⚠️  Line $line_num: Display conflict (hidden + visible display)" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    if echo "$classes" | grep -qE 'block.*flex|flex.*block|block.*grid|grid.*block'; then
      echo "  ⚠️  Line $line_num: Display conflict (multiple display types)" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check position conflicts
    if echo "$classes" | grep -qE 'static.*absolute|absolute.*static|static.*relative|relative.*static|static.*fixed|fixed.*static'; then
      echo "  ⚠️  Line $line_num: Position conflict (multiple position values)" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check text-align conflicts
    if echo "$classes" | grep -qE 'text-left.*(text-center|text-right)|text-center.*(text-left|text-right)|text-right.*(text-left|text-center)'; then
      echo "  ⚠️  Line $line_num: Text-align conflict" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check flex-direction conflicts
    if echo "$classes" | grep -qE 'flex-row.*flex-col|flex-col.*flex-row'; then
      echo "  ⚠️  Line $line_num: Flex-direction conflict" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check justify-content conflicts
    if echo "$classes" | grep -oE 'justify-[a-z-]+' | sort | uniq -d | grep -q .; then
      echo "  ⚠️  Line $line_num: Multiple justify-content values" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check items-align conflicts
    if echo "$classes" | grep -oE 'items-[a-z-]+' | sort | uniq -d | grep -q .; then
      echo "  ⚠️  Line $line_num: Multiple items-align values" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check overflow conflicts
    if echo "$classes" | grep -qE 'overflow-hidden.*(overflow-auto|overflow-scroll)|overflow-auto.*(overflow-hidden|overflow-scroll)'; then
      echo "  ⚠️  Line $line_num: Overflow conflict" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

    # Check opacity conflicts (0 with visible)
    if echo "$classes" | grep -qE 'opacity-0.*opacity-[1-9]|opacity-[1-9].*opacity-0'; then
      echo "  ⚠️  Line $line_num: Opacity conflict" >> "$OUTPUT_FILE"
      echo "      Classes: $classes" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      conflicts_found=$((conflicts_found + 1))
    fi

  done

  return $conflicts_found
}

# Scan files
echo "📁 Scanning files in: $SCAN_PATH" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$SCAN_PATH" -type f \( -name "*.vue" -o -name "*.astro" -o -name "*.jsx" -o -name "*.tsx" \) 2>/dev/null | while IFS= read -r file; do
  FILE_CONFLICTS=$(check_file_conflicts "$file" | grep -c "⚠️" || echo "0")

  if [ "$FILE_CONFLICTS" -gt 0 ]; then
    echo "❌ $file" >> "$OUTPUT_FILE"
    check_file_conflicts "$file" >> "$OUTPUT_FILE"
    TOTAL_CONFLICTS=$((TOTAL_CONFLICTS + FILE_CONFLICTS))
  fi
done

# Count total conflicts
CONFLICT_COUNT=$(grep -c "⚠️" "$OUTPUT_FILE" 2>/dev/null || echo "0")

echo "" >> "$OUTPUT_FILE"
echo "=== SUMMARY ===" >> "$OUTPUT_FILE"
echo "Total conflicts found: $CONFLICT_COUNT" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ "$CONFLICT_COUNT" -eq 0 ]; then
  echo "✅ No class conflicts detected!" >> "$OUTPUT_FILE"
else
  echo "Review conflicts above. Common fixes:" >> "$OUTPUT_FILE"
  echo "  - Remove redundant classes" >> "$OUTPUT_FILE"
  echo "  - Use single width/height class" >> "$OUTPUT_FILE"
  echo "  - Don't mix display types (flex, block, grid)" >> "$OUTPUT_FILE"
  echo "  - Use conditional classes for responsive changes" >> "$OUTPUT_FILE"
fi

# Output to console
cat "$OUTPUT_FILE"

echo ""
if [ "$CONFLICT_COUNT" -eq 0 ]; then
  echo "✅ No conflicts detected!"
else
  echo "⚠️  Found $CONFLICT_COUNT conflicts"
  echo "📄 Full report saved to: $OUTPUT_FILE"
fi

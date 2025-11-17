#!/bin/bash

##
# Layout Validator
# Checks for common layout constraint violations
##

echo "🔍 Validating Layout Patterns..."
echo ""

SCAN_PATH="${1:-src}"
OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/layout-validation.txt"

> "$OUTPUT_FILE"

echo "=== LAYOUT VALIDATION REPORT ===" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

ISSUES_FOUND=0

# 1. Elements with width:100% AND padding (box-sizing issue)
echo "1️⃣  Checking for width:100% + padding (box-sizing issues)..." | tee -a "$OUTPUT_FILE"
MATCHES=$(grep -rn "w-full\|width.*100%" "$SCAN_PATH" --include="*.vue" -A3 | grep -E "p-\|padding" | head -10)
if [ ! -z "$MATCHES" ]; then
  echo "$MATCHES" >> "$OUTPUT_FILE"
  ISSUE_COUNT=$(echo "$MATCHES" | wc -l)
  echo "   ⚠️  Found $ISSUE_COUNT potential issues" | tee -a "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + ISSUE_COUNT))
else
  echo "   ✅ No issues found" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 2. Flex containers without flex-wrap
echo "2️⃣  Checking for flex containers without flex-wrap..." | tee -a "$OUTPUT_FILE"
FLEX_FILES=$(grep -rl "display.*flex\|flex " "$SCAN_PATH" --include="*.vue")
for file in $FLEX_FILES; do
  if ! grep -q "flex-wrap" "$file"; then
    echo "   ⚠️  $file" >> "$OUTPUT_FILE"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
  fi
done
if [ $ISSUES_FOUND -gt 0 ]; then
  echo "   ⚠️  Found flex containers without flex-wrap (may cause overflow)" | tee -a "$OUTPUT_FILE"
else
  echo "   ✅ All flex containers have flex-wrap" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 3. Fixed widths that might break on mobile
echo "3️⃣  Checking for large fixed widths..." | tee -a "$OUTPUT_FILE"
MATCHES=$(grep -rn "w-\[\(4[0-9][0-9]\|[5-9][0-9][0-9]\|[0-9]\{4,\}\)px\]\|width:.*\(4[0-9][0-9]\|[5-9][0-9][0-9]\|[0-9]\{4,\}\)px" "$SCAN_PATH" --include="*.vue" | head -10)
if [ ! -z "$MATCHES" ]; then
  echo "$MATCHES" >> "$OUTPUT_FILE"
  ISSUE_COUNT=$(echo "$MATCHES" | wc -l)
  echo "   ⚠️  Found $ISSUE_COUNT elements with large fixed widths (400px+)" | tee -a "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + ISSUE_COUNT))
else
  echo "   ✅ No large fixed widths found" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 4. Absolute positioning without relative parent
echo "4️⃣  Checking for absolute positioning without relative parent..." | tee -a "$OUTPUT_FILE"
ABS_FILES=$(grep -l "absolute" "$SCAN_PATH"/*.vue 2>/dev/null || echo "")
if [ ! -z "$ABS_FILES" ]; then
  for file in $ABS_FILES; do
    # Get 10 lines before absolute
    CONTEXT=$(grep -B 10 "absolute" "$file" | grep -c "relative")
    if [ "$CONTEXT" -eq 0 ]; then
      echo "   ⚠️  $file - absolute without relative parent" >> "$OUTPUT_FILE"
      ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
  done
fi
if grep -q "⚠️" "$OUTPUT_FILE"; then
  echo "   ⚠️  Found absolute positioning without relative parent" | tee -a "$OUTPUT_FILE"
else
  echo "   ✅ No positioning issues found" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 5. Missing box-sizing: border-box
echo "5️⃣  Checking for border-box usage..." | tee -a "$OUTPUT_FILE"
if grep -rq "box-sizing.*border-box\|\\*.*box-sizing" "$SCAN_PATH/../"*.css 2>/dev/null; then
  echo "   ✅ Global border-box found" | tee -a "$OUTPUT_FILE"
else
  echo "   ⚠️  No global border-box found (recommended)" | tee -a "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi
echo "" >> "$OUTPUT_FILE"

# 6. Images without max-width
echo "6️⃣  Checking for images without max-width..." | tee -a "$OUTPUT_FILE"
IMG_COUNT=$(grep -rc "<img" "$SCAN_PATH" --include="*.vue" | awk -F: '{s+=$2} END {print s}')
MAX_WIDTH_COUNT=$(grep -rc "max-w-\|max-width" "$SCAN_PATH" --include="*.vue" | awk -F: '{s+=$2} END {print s}')
if [ "$IMG_COUNT" -gt "$MAX_WIDTH_COUNT" ]; then
  echo "   ⚠️  Found $IMG_COUNT images but only $MAX_WIDTH_COUNT max-width declarations" | tee -a "$OUTPUT_FILE"
  echo "   Consider adding max-w-full to images" | tee -a "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
  echo "   ✅ Images appear to have size constraints" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 7. Buttons without accessible names
echo "7️⃣  Checking for buttons without accessible names..." | tee -a "$OUTPUT_FILE"
BUTTON_ISSUES=$(grep -rn "<button" "$SCAN_PATH" --include="*.vue" | while IFS=: read -r file line content; do
  # Check if button has aria-label, aria-labelledby, or text content
  FULL_LINE=$(sed -n "${line}p" "$file")
  if ! echo "$FULL_LINE" | grep -qE 'aria-label|aria-labelledby' && ! echo "$FULL_LINE" | grep -qE '>[^<]'; then
    echo "$file:$line"
  fi
done)

if [ ! -z "$BUTTON_ISSUES" ]; then
  echo "$BUTTON_ISSUES" | head -10 >> "$OUTPUT_FILE"
  ISSUE_COUNT=$(echo "$BUTTON_ISSUES" | wc -l)
  echo "   ⚠️  Found $ISSUE_COUNT buttons without accessible names" | tee -a "$OUTPUT_FILE"
  echo "   Add aria-label or text content" | tee -a "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + ISSUE_COUNT))
else
  echo "   ✅ All buttons have accessible names" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 8. Interactive elements without ARIA attributes
echo "8️⃣  Checking for interactive elements missing ARIA..." | tee -a "$OUTPUT_FILE"
ARIA_ISSUES=$(grep -rn "@click\|@keypress\|@keydown" "$SCAN_PATH" --include="*.vue" | while IFS=: read -r file line content; do
  # Check if element has role or aria attributes
  FULL_LINE=$(sed -n "${line}p" "$file")
  if ! echo "$FULL_LINE" | grep -qE 'role=|aria-|<button|<a '; then
    echo "$file:$line - Interactive element without semantic role"
  fi
done)

if [ ! -z "$ARIA_ISSUES" ]; then
  echo "$ARIA_ISSUES" | head -10 >> "$OUTPUT_FILE"
  ISSUE_COUNT=$(echo "$ARIA_ISSUES" | wc -l)
  echo "   ⚠️  Found $ISSUE_COUNT interactive elements without proper semantics" | tee -a "$OUTPUT_FILE"
  echo "   Use semantic HTML (button, a) or add role/aria attributes" | tee -a "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + ISSUE_COUNT))
else
  echo "   ✅ Interactive elements have proper semantics" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# 9. Form inputs without labels
echo "9️⃣  Checking for form inputs without labels..." | tee -a "$OUTPUT_FILE"
INPUT_ISSUES=$(grep -rn "<input\|<textarea\|<select" "$SCAN_PATH" --include="*.vue" | while IFS=: read -r file line content; do
  # Check if input has id that matches a label, or has aria-label
  FULL_LINE=$(sed -n "${line}p" "$file")
  if ! echo "$FULL_LINE" | grep -qE 'aria-label|aria-labelledby|id='; then
    echo "$file:$line"
  fi
done)

if [ ! -z "$INPUT_ISSUES" ]; then
  echo "$INPUT_ISSUES" | head -10 >> "$OUTPUT_FILE"
  ISSUE_COUNT=$(echo "$INPUT_ISSUES" | wc -l)
  echo "   ⚠️  Found $ISSUE_COUNT form inputs that may be missing labels" | tee -a "$OUTPUT_FILE"
  echo "   Add <label> with matching 'for' attribute or aria-label" | tee -a "$OUTPUT_FILE"
  ISSUES_FOUND=$((ISSUES_FOUND + ISSUE_COUNT))
else
  echo "   ✅ Form inputs have labels" | tee -a "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Summary
echo "=== SUMMARY ===" >> "$OUTPUT_FILE"
if [ $ISSUES_FOUND -eq 0 ]; then
  echo "✅ No major layout issues found!" | tee -a "$OUTPUT_FILE"
else
  echo "⚠️  Found $ISSUES_FOUND potential layout issues" | tee -a "$OUTPUT_FILE"
  echo "Review the report above for details." | tee -a "$OUTPUT_FILE"
fi

echo ""
echo "📄 Full report saved to: $OUTPUT_FILE"

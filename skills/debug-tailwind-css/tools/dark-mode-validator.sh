#!/bin/bash

##
# Dark Mode Validator
# Validates dark: class coverage for color-related utilities
# Project requirement: ALWAYS use dark: mode
##

SCAN_PATH="${1:-src}"

echo "🌙 Validating Dark Mode Coverage..."
echo ""

OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/dark-mode-validation.txt"

> "$OUTPUT_FILE"

echo "=== DARK MODE VALIDATION REPORT ===" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "Scan path: $SCAN_PATH" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Project requirement: ALL color utilities must have dark: variants" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

TOTAL_ISSUES=0

# Color-related utilities that need dark: variants
echo "🎨 Checking for missing dark: variants..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to check a specific color utility pattern
check_color_utility() {
  local pattern="$1"
  local name="$2"
  local file="$3"

  # Find lines with the pattern but without dark: prefix
  MATCHES=$(grep -nE "$pattern" "$file" | grep -vE "dark:$pattern")

  if [ ! -z "$MATCHES" ]; then
    echo "$MATCHES" | while IFS=: read -r line_num content; do
      # Extract just the classes for this match
      CLASSES=$(echo "$content" | grep -oE 'class="[^"]*"' | head -1)

      # Check if this element has ANY dark: variant for this color property
      if ! echo "$CLASSES" | grep -qE "dark:$pattern"; then
        # Extract the specific utility being used
        UTILITY=$(echo "$CLASSES" | grep -oE "$pattern[^ \"']*" | head -1)
        echo "  Line $line_num: $UTILITY (missing dark: variant)"
      fi
    done
  fi
}

# Scan files
find "$SCAN_PATH" -type f \( -name "*.vue" -o -name "*.astro" \) 2>/dev/null | while IFS= read -r file; do
  FILE_ISSUES=$(mktemp)

  # Check background colors
  check_color_utility "bg-gray-|bg-red-|bg-blue-|bg-green-|bg-yellow-|bg-purple-|bg-pink-|bg-indigo-|bg-teal-|bg-orange-|bg-white|bg-black|bg-primary-|bg-secondary-|bg-accent-" "Background colors" "$file" >> "$FILE_ISSUES"

  # Check text colors
  check_color_utility "text-gray-|text-red-|text-blue-|text-green-|text-yellow-|text-purple-|text-pink-|text-indigo-|text-teal-|text-orange-|text-white|text-black|text-primary-|text-secondary-|text-accent-" "Text colors" "$file" >> "$FILE_ISSUES"

  # Check border colors
  check_color_utility "border-gray-|border-red-|border-blue-|border-green-|border-yellow-|border-purple-|border-pink-|border-indigo-|border-teal-|border-orange-|border-white|border-black|border-primary-|border-secondary-|border-accent-" "Border colors" "$file" >> "$FILE_ISSUES"

  # Check ring colors
  check_color_utility "ring-gray-|ring-red-|ring-blue-|ring-green-|ring-yellow-|ring-purple-|ring-pink-|ring-indigo-|ring-teal-|ring-orange-|ring-white|ring-black|ring-primary-|ring-secondary-|ring-accent-" "Ring colors" "$file" >> "$FILE_ISSUES"

  # Check divide colors
  check_color_utility "divide-gray-|divide-red-|divide-blue-|divide-green-|divide-yellow-|divide-purple-|divide-pink-|divide-indigo-|divide-teal-|divide-orange-|divide-white|divide-black" "Divide colors" "$file" >> "$FILE_ISSUES"

  # If file has issues, report them
  if [ -s "$FILE_ISSUES" ]; then
    echo "❌ $file" >> "$OUTPUT_FILE"
    cat "$FILE_ISSUES" >> "$OUTPUT_FILE"
    ISSUE_COUNT=$(wc -l < "$FILE_ISSUES")
    TOTAL_ISSUES=$((TOTAL_ISSUES + ISSUE_COUNT))
    echo "" >> "$OUTPUT_FILE"
  fi

  rm -f "$FILE_ISSUES"
done

# Additional checks
echo "" >> "$OUTPUT_FILE"
echo "📋 Additional Dark Mode Checks..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Check for hardcoded hex/rgb colors
echo "1️⃣  Checking for hardcoded colors (hex/rgb)..." >> "$OUTPUT_FILE"
HARDCODED=$(grep -rn "color:.*#\|background:.*#\|border-color:.*#\|color:.*rgb\|background:.*rgb" "$SCAN_PATH" --include="*.vue" | grep -v "dark:")
if [ ! -z "$HARDCODED" ]; then
  echo "$HARDCODED" | head -10 >> "$OUTPUT_FILE"
  HARDCODED_COUNT=$(echo "$HARDCODED" | wc -l)
  echo "  ⚠️  Found $HARDCODED_COUNT instances of hardcoded colors" >> "$OUTPUT_FILE"
  echo "  💡 Use Tailwind color utilities with dark: variants instead" >> "$OUTPUT_FILE"
  TOTAL_ISSUES=$((TOTAL_ISSUES + HARDCODED_COUNT))
else
  echo "  ✅ No hardcoded colors found" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Check for CSS custom properties without dark mode handling
echo "2️⃣  Checking for CSS custom properties..." >> "$OUTPUT_FILE"
CSS_VARS=$(grep -rn "var(--" "$SCAN_PATH" --include="*.vue" | head -20)
if [ ! -z "$CSS_VARS" ]; then
  echo "$CSS_VARS" | head -10 >> "$OUTPUT_FILE"
  VAR_COUNT=$(echo "$CSS_VARS" | wc -l)
  echo "  ℹ️  Found $VAR_COUNT CSS custom property usages" >> "$OUTPUT_FILE"
  echo "  💡 Ensure CSS variables are defined in both light and dark themes" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Check for proper dark mode implementation
echo "3️⃣  Checking dark mode implementation..." >> "$OUTPUT_FILE"
DARK_USAGE=$(grep -rc "dark:" "$SCAN_PATH" --include="*.vue" --include="*.astro" | grep -v ":0$" | head -10)
if [ ! -z "$DARK_USAGE" ]; then
  DARK_COUNT=$(echo "$DARK_USAGE" | wc -l)
  echo "  ✅ Found dark: classes in $DARK_COUNT files" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "  Top files with dark: usage:" >> "$OUTPUT_FILE"
  echo "$DARK_USAGE" | sort -t: -k2 -rn | head -10 >> "$OUTPUT_FILE"
else
  echo "  ⚠️  No dark: classes found - dark mode not implemented!" >> "$OUTPUT_FILE"
  TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
fi
echo "" >> "$OUTPUT_FILE"

# Check if dark mode toggle exists
echo "4️⃣  Checking for dark mode toggle..." >> "$OUTPUT_FILE"
if grep -rq "dark.*classList\|toggleDark\|setDarkMode\|darkMode\|theme.*toggle" "$SCAN_PATH" --include="*.vue" --include="*.ts" --include="*.js"; then
  echo "  ✅ Dark mode toggle functionality found" >> "$OUTPUT_FILE"
else
  echo "  ℹ️  No dark mode toggle found" >> "$OUTPUT_FILE"
  echo "  💡 Consider adding user preference for light/dark mode" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Summary
echo "=== SUMMARY ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ $TOTAL_ISSUES -eq 0 ]; then
  echo "✅ Excellent dark mode coverage!" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "Your components follow the project requirement:" >> "$OUTPUT_FILE"
  echo "  - All color utilities have dark: variants" >> "$OUTPUT_FILE"
  echo "  - No hardcoded colors" >> "$OUTPUT_FILE"
  echo "  - Consistent dark mode implementation" >> "$OUTPUT_FILE"
else
  echo "⚠️  Found $TOTAL_ISSUES dark mode issues" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "How to fix:" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "1. Add dark: variants to all color utilities:" >> "$OUTPUT_FILE"
  echo "   ❌ bg-gray-100 text-gray-900" >> "$OUTPUT_FILE"
  echo "   ✅ bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-gray-100" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "2. Replace hardcoded colors with Tailwind utilities:" >> "$OUTPUT_FILE"
  echo "   ❌ style=\"background: #f3f4f6\"" >> "$OUTPUT_FILE"
  echo "   ✅ class=\"bg-gray-100 dark:bg-gray-800\"" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "3. For custom properties, define both themes:" >> "$OUTPUT_FILE"
  echo "   :root { --bg-color: #fff; }" >> "$OUTPUT_FILE"
  echo "   .dark { --bg-color: #1a1a1a; }" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "4. Common color pairings:" >> "$OUTPUT_FILE"
  echo "   Light bg → Dark bg:   bg-white dark:bg-gray-900" >> "$OUTPUT_FILE"
  echo "   Light text → Dark text: text-gray-900 dark:text-gray-100" >> "$OUTPUT_FILE"
  echo "   Light border → Dark border: border-gray-200 dark:border-gray-700" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "📚 Resources:" >> "$OUTPUT_FILE"
echo "  - Tailwind Dark Mode: https://tailwindcss.com/docs/dark-mode" >> "$OUTPUT_FILE"
echo "  - Project CLAUDE.md: Mandates 'ALWAYS dark: mode'" >> "$OUTPUT_FILE"

# Output to console
cat "$OUTPUT_FILE"

echo ""
if [ $TOTAL_ISSUES -eq 0 ]; then
  echo "✅ Excellent dark mode coverage!"
else
  echo "⚠️  Found $TOTAL_ISSUES dark mode issues"
  echo "📄 Full report saved to: $OUTPUT_FILE"
fi

#!/bin/bash

##
# SSR Safety Checker
# Detects browser-only APIs that may cause hydration issues in SSR
##

SCAN_PATH="${1:-src}"

echo "🔍 Checking SSR Safety..."
echo ""

OUTPUT_DIR=".debug-output"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/ssr-safety-report.txt"

> "$OUTPUT_FILE"

echo "=== SSR SAFETY REPORT ===" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "Scan path: $SCAN_PATH" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

TOTAL_ISSUES=0

# Browser-only APIs to check for
BROWSER_APIS="window\.|document\.|localStorage|sessionStorage|navigator\.|location\.|history\.|XMLHttpRequest|fetch\(|alert\(|confirm\(|prompt\("

echo "📝 Checking for unsafe browser API usage..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Check Vue files
find "$SCAN_PATH" -type f -name "*.vue" 2>/dev/null | while IFS= read -r file; do
  FILE_HAS_ISSUES=0

  # Extract <script> section (between <script and </script>)
  SCRIPT_CONTENT=$(sed -n '/<script/,/<\/script>/p' "$file")

  # Skip if no script section
  if [ -z "$SCRIPT_CONTENT" ]; then
    continue
  fi

  # Check for browser APIs
  BROWSER_API_MATCHES=$(echo "$SCRIPT_CONTENT" | grep -nE "$BROWSER_APIS")

  if [ ! -z "$BROWSER_API_MATCHES" ]; then
    # Check if file uses useMounted or onMounted
    HAS_USE_MOUNTED=$(grep -c "useMounted\|onMounted\|import.*useMounted\|from '@vueuse/core'" "$file")
    HAS_CLIENT_DIRECTIVE=$(grep -c "client:load\|client:visible\|client:idle\|client:media\|client:only" "$file")

    # Check if browser API usage is inside mounted hook
    UNSAFE_USAGE=$(echo "$BROWSER_API_MATCHES" | while IFS= read -r match; do
      LINE_NUM=$(echo "$match" | cut -d: -f1)
      CONTENT=$(echo "$match" | cut -d: -f2-)

      # Simple heuristic: if line contains onMounted or useMounted, it's probably safe
      if ! echo "$CONTENT" | grep -qE "onMounted|useMounted|if.*mounted|watch.*mounted"; then
        echo "$LINE_NUM: $CONTENT"
      fi
    done)

    if [ ! -z "$UNSAFE_USAGE" ]; then
      if [ $FILE_HAS_ISSUES -eq 0 ]; then
        echo "❌ $file" >> "$OUTPUT_FILE"
        FILE_HAS_ISSUES=1
      fi

      echo "  Browser API usage detected:" >> "$OUTPUT_FILE"
      echo "$UNSAFE_USAGE" | head -5 | while IFS= read -r line; do
        echo "    Line $line" >> "$OUTPUT_FILE"
      done

      if [ "$HAS_USE_MOUNTED" -eq 0 ]; then
        echo "  ⚠️  No useMounted/onMounted found - may cause SSR hydration errors" >> "$OUTPUT_FILE"
        TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
      else
        echo "  ℹ️  File has mounted hooks - verify browser APIs are inside them" >> "$OUTPUT_FILE"
      fi

      if [ "$HAS_CLIENT_DIRECTIVE" -eq 0 ]; then
        echo "  💡 Consider adding client: directive to parent component" >> "$OUTPUT_FILE"
      fi

      echo "" >> "$OUTPUT_FILE"
    fi
  fi
done

# Check for common SSR-unsafe patterns
echo "" >> "$OUTPUT_FILE"
echo "📋 Checking for SSR-unsafe patterns..." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Pattern 1: DOM queries in script setup
DOM_QUERY_FILES=$(grep -rn "querySelector\|getElementById\|getElementsBy" "$SCAN_PATH" --include="*.vue" | grep -v "onMounted\|useMounted")
if [ ! -z "$DOM_QUERY_FILES" ]; then
  echo "⚠️  DOM queries outside mounted hooks:" >> "$OUTPUT_FILE"
  echo "$DOM_QUERY_FILES" | head -10 >> "$OUTPUT_FILE"
  ISSUE_COUNT=$(echo "$DOM_QUERY_FILES" | wc -l)
  echo "  Found $ISSUE_COUNT instances" >> "$OUTPUT_FILE"
  echo "  💡 Wrap in onMounted() or useMounted()" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  TOTAL_ISSUES=$((TOTAL_ISSUES + ISSUE_COUNT))
fi

# Pattern 2: Direct window/document in <script setup>
DIRECT_WINDOW=$(grep -rn "<script setup" "$SCAN_PATH" --include="*.vue" -A 20 | grep -E "^\s*(window|document)\." | grep -v "//")
if [ ! -z "$DIRECT_WINDOW" ]; then
  echo "⚠️  Direct window/document access in script setup:" >> "$OUTPUT_FILE"
  echo "$DIRECT_WINDOW" | head -10 >> "$OUTPUT_FILE"
  echo "  💡 Use useMounted() from @vueuse/core" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
fi

# Pattern 3: Browser event listeners
EVENT_LISTENERS=$(grep -rn "addEventListener\|removeEventListener" "$SCAN_PATH" --include="*.vue" | grep -v "onMounted\|useMounted\|onUnmounted")
if [ ! -z "$EVENT_LISTENERS" ]; then
  echo "⚠️  Event listeners outside mounted hooks:" >> "$OUTPUT_FILE"
  echo "$EVENT_LISTENERS" | head -10 >> "$OUTPUT_FILE"
  ISSUE_COUNT=$(echo "$EVENT_LISTENERS" | wc -l)
  echo "  Found $ISSUE_COUNT instances" >> "$OUTPUT_FILE"
  echo "  💡 Add in onMounted, remove in onUnmounted" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  TOTAL_ISSUES=$((TOTAL_ISSUES + ISSUE_COUNT))
fi

# Pattern 4: VueUse composables that need mounted
VUEUSE_UNSAFE=$(grep -rn "useStorage\|useLocalStorage\|useSessionStorage\|useMediaQuery" "$SCAN_PATH" --include="*.vue")
if [ ! -z "$VUEUSE_UNSAFE" ]; then
  echo "ℹ️  VueUse composables detected (verify SSR safety):" >> "$OUTPUT_FILE"
  echo "$VUEUSE_UNSAFE" | head -10 >> "$OUTPUT_FILE"
  echo "  These composables handle SSR internally, but verify client: directive" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Check for components with client: directives (good!)
CLIENT_DIRECTIVES=$(grep -rc "client:" "$SCAN_PATH" --include="*.vue" --include="*.astro" | grep -v ":0$" | head -10)
if [ ! -z "$CLIENT_DIRECTIVES" ]; then
  echo "✅ Components using client: directives (SSR-safe):" >> "$OUTPUT_FILE"
  echo "$CLIENT_DIRECTIVES" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Summary
echo "=== SUMMARY ===" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ $TOTAL_ISSUES -eq 0 ]; then
  echo "✅ No SSR safety issues detected!" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "Your components appear SSR-safe:" >> "$OUTPUT_FILE"
  echo "  - Browser APIs are wrapped in mounted hooks" >> "$OUTPUT_FILE"
  echo "  - Or components use client: directives" >> "$OUTPUT_FILE"
else
  echo "⚠️  Found $TOTAL_ISSUES potential SSR issues" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "Common fixes:" >> "$OUTPUT_FILE"
  echo "  1. Wrap browser APIs in useMounted():" >> "$OUTPUT_FILE"
  echo "     const mounted = useMounted()" >> "$OUTPUT_FILE"
  echo "     if (mounted.value) { window.addEventListener(...) }" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "  2. Use onMounted() from Vue:" >> "$OUTPUT_FILE"
  echo "     onMounted(() => { document.querySelector(...) })" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "  3. Add client: directive to component:" >> "$OUTPUT_FILE"
  echo "     <Component client:load />" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "  4. Use SSR-safe VueUse composables:" >> "$OUTPUT_FILE"
  echo "     useMediaQuery, useStorage (handle SSR internally)" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "📚 Resources:" >> "$OUTPUT_FILE"
echo "  - Astro client directives: https://docs.astro.build/en/reference/directives-reference/#client-directives" >> "$OUTPUT_FILE"
echo "  - VueUse SSR: https://vueuse.org/guide/best-practice.html#ssr-compatibility" >> "$OUTPUT_FILE"

# Output to console
cat "$OUTPUT_FILE"

echo ""
if [ $TOTAL_ISSUES -eq 0 ]; then
  echo "✅ No SSR safety issues detected!"
else
  echo "⚠️  Found $TOTAL_ISSUES potential SSR issues"
  echo "📄 Full report saved to: $OUTPUT_FILE"
fi

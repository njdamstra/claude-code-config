#!/bin/bash

##
# Breakpoint Tester
# Screenshots page at all Tailwind breakpoints
##

URL="${1:-http://localhost:4321}"

if [ -z "$URL" ]; then
  echo "Usage: npm run test:breakpoints -- <url>"
  echo "Example: npm run test:breakpoints -- http://localhost:4321/page"
  exit 1
fi

echo "📸 Testing breakpoints for: $URL"
echo ""

OUTPUT_DIR=".debug-output/screenshots"
mkdir -p "$OUTPUT_DIR"

# Tailwind default breakpoints
declare -A BREAKPOINTS=(
  ["sm"]="640"
  ["md"]="768"
  ["lg"]="1024"
  ["xl"]="1280"
  ["2xl"]="1536"
)

# Check if npx playwright is available
if ! command -v npx &> /dev/null; then
  echo "❌ npx not found. Please install Node.js"
  exit 1
fi

for name in "${!BREAKPOINTS[@]}"; do
  width="${BREAKPOINTS[$name]}"
  output="$OUTPUT_DIR/breakpoint-${name}-${width}px.png"
  
  echo "  📱 ${name}: ${width}px"
  
  npx playwright screenshot \
    --viewport-size="${width},900" \
    --full-page \
    "$URL" \
    "$output" 2>/dev/null
done

echo ""
echo "✅ Screenshots saved to: $OUTPUT_DIR"
echo ""
echo "Files created:"
ls -lh "$OUTPUT_DIR"

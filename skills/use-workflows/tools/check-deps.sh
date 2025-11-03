#!/usr/bin/env bash

set -euo pipefail

EXIT_CODE=0

echo "Checking workflow engine dependencies..."
echo ""

# Check jq
if command -v jq &> /dev/null; then
  JQ_VERSION=$(jq --version | cut -d'-' -f2)
  echo "✓ jq $JQ_VERSION"
else
  echo "✗ jq not found (required)"
  echo "  Install: brew install jq"
  EXIT_CODE=1
fi

# Check yq
if command -v yq &> /dev/null; then
  YQ_VERSION=$(yq --version | awk '{print $NF}')
  echo "✓ yq $YQ_VERSION"
else
  echo "✗ yq not found (required)"
  echo "  Install: brew install yq"
  EXIT_CODE=1
fi

# Check Node.js
if command -v node &> /dev/null; then
  NODE_VERSION=$(node --version)
  echo "✓ node $NODE_VERSION"
else
  echo "✗ node not found (required)"
  echo "  Install: brew install node"
  EXIT_CODE=1
fi

# Check mustache (optional)
if command -v mustache &> /dev/null; then
  echo "✓ mustache (optional)"
else
  echo "⚠ mustache not found (optional, will use fallback)"
  echo "  Install: npm install -g mustache"
fi

echo ""

if [ $EXIT_CODE -eq 0 ]; then
  echo "======================================"
  echo "All required dependencies present ✓"
  echo "======================================"
else
  echo "======================================"
  echo "Missing required dependencies ✗"
  echo "======================================"
fi

exit $EXIT_CODE

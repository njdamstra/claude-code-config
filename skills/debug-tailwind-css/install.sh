#!/bin/bash

##
# Debug Tailwind CSS - Installation Script
##

echo "🚀 Installing Debug Tailwind CSS Skill..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
  echo "❌ Error: package.json not found"
  echo "Please run this script from the debug-tailwind-css directory"
  exit 1
fi

# Install npm dependencies
echo "📦 Installing npm dependencies..."
npm install

if [ $? -ne 0 ]; then
  echo "❌ npm install failed"
  exit 1
fi

# Install Playwright
echo "🎭 Installing Playwright browsers..."
npx playwright install chromium

if [ $? -ne 0 ]; then
  echo "⚠️  Playwright install failed (you can do this later)"
fi

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x tools/*.sh

# Create example config in current directory (not project)
if [ ! -f ".debug-tailwind-css.config.js" ]; then
  echo "📄 Creating example config..."
  cp .debug-tailwind-css.config.example.js .debug-tailwind-css.config.js
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Copy .debug-tailwind-css.config.js to your project root"
echo "2. Update the baseUrl in the config"
echo "3. Start your dev server"
echo "4. Run tools from your project: npm run --prefix ~/.claude/skills/debug-tailwind-css <command>"
echo ""
echo "Or add an alias to your shell profile:"
echo "  alias css-debug='npm run --prefix ~/.claude/skills/debug-tailwind-css'"
echo ""
echo "Quick test:"
echo "  npm run analyze:layouts"
echo ""

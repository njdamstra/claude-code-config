#!/bin/bash

##
# Tailwind Class Audit
# Finds most used Tailwind classes
##

echo "🔍 Auditing Tailwind Class Usage..."
echo ""

SCAN_PATH="${1:-src}"

# Extract all classes from class attributes and count them
echo "Top 30 most used Tailwind classes:"
echo ""

grep -roh 'class="[^"]*"' "$SCAN_PATH" --include="*.vue" --include="*.astro" | \
  sed 's/class="//g' | sed 's/"//g' | \
  tr ' ' '\n' | \
  grep -v '^$' | \
  sort | uniq -c | \
  sort -rn | \
  head -30 | \
  awk '{printf "%3d  %s\n", $1, $2}'

echo ""
echo "✅ Audit complete"

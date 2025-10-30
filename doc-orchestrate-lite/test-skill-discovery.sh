#!/bin/bash

# Test script for orchestrate-lite skill scanning
# This validates that skills can be discovered from both user and project locations

echo "🧪 Testing Orchestrate-Lite Skill Discovery"
echo "=========================================="
echo ""

# Function to extract and display skill info
extract_skill_info() {
  local skills_dir="$1"
  local location="$2"
  local count=0
  
  if [[ -d "$skills_dir" ]]; then
    echo "📁 Scanning: $skills_dir ($location)"
    echo ""
    
    for skill_file in "$skills_dir"/*/SKILL.md; do
      if [[ -f "$skill_file" ]]; then
        skill_name=$(basename $(dirname "$skill_file"))
        
        # Extract description from YAML frontmatter
        description=$(awk '/^---$/,/^---$/ {
          if ($0 ~ /^description:/) {
            sub(/^description: */, "")
            print
            exit
          }
        }' "$skill_file")
        
        # Fallback: try without frontmatter delimiters
        if [[ -z "$description" ]]; then
          description=$(grep "^description:" "$skill_file" | head -1 | sed 's/^description: *//')
        fi
        
        if [[ -n "$description" ]]; then
          echo "  ✅ $skill_name"
          echo "     → $description"
          echo ""
          ((count++))
        else
          echo "  ⚠️  $skill_name (no description found)"
          echo ""
        fi
      fi
    done
    
    if [[ $count -eq 0 ]]; then
      echo "  ℹ️  No skills found in this location"
      echo ""
    else
      echo "  📊 Found $count skill(s)"
      echo ""
    fi
  else
    echo "📁 Directory not found: $skills_dir ($location)"
    echo ""
  fi
}

# Scan user-level skills
extract_skill_info "$HOME/.claude/skills" "USER"

echo "=========================================="
echo ""

# Scan project-level skills
extract_skill_info "./.claude/skills" "PROJECT"

echo "=========================================="
echo ""
echo "✅ Skill discovery test complete!"
echo ""
echo "💡 To use orchestrate-lite:"
echo "   /orchestrate-lite <your task description>"
echo ""
echo "Example:"
echo "   /orchestrate-lite create a modal component"

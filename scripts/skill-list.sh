#!/bin/bash

# skill-list.sh - List all available Claude Code skills with descriptions
# Scans both user-level (~/.claude/skills/) and project-level (./.claude/skills/)

echo "=== AVAILABLE SKILLS ==="
echo ""

# Function to extract skill info from a skills directory
extract_skill_info() {
  local skills_dir="$1"
  local location="$2"

  if [[ -d "$skills_dir" ]]; then
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
          echo "[$location] $skill_name"
          echo "  → $description"
          echo ""
        fi
      fi
    done
  fi
}

# Scan user-level skills
extract_skill_info "$HOME/.claude/skills" "USER"

# Scan project-level skills
extract_skill_info "./.claude/skills" "PROJECT"

echo "=== END SKILLS ==="

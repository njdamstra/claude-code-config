#!/usr/bin/env bash
# Template Renderer Library
# Functions for Mustache-style variable substitution

set -euo pipefail

# Replace {{variable}} with values from JSON
# Args: content, data_json
# Output: Content with simple variables substituted
substitute_simple_vars() {
  local content=$1
  local data_json=$2

  # Extract all variable names from content (BSD compatible)
  local vars=$(echo "$content" | perl -nle 'print $1 while /\{\{([^#^\/{}]+)\}\}/g' | sort -u || true)

  local result="$content"

  # Substitute each variable
  while IFS= read -r var; do
    [[ -z "$var" ]] && continue

    # Skip {{.}} - it's handled by array iteration
    [[ "$var" == "." ]] && continue

    local value_json
    value_json=$(echo "$data_json" | jq -c ".${var} // empty")

    if [[ -n "$value_json" && "$value_json" != "null" ]]; then
      result=$(python3 -c '
import sys, json
var = sys.argv[1]
raw = sys.argv[2]
value = json.loads(raw)
if isinstance(value, (dict, list)):
    replacement = json.dumps(value, indent=2)
elif value is None:
    replacement = ""
else:
    replacement = str(value)
content = sys.stdin.read()
print(content.replace("{{"+var+"}}", replacement), end="")
' "$var" "$value_json" <<< "$result")
    fi
  done <<< "$vars"

  echo "$result"
}

# Process {{#var}}...{{/var}} and {{^var}}...{{/var}} blocks
# Args: content, data_json
# Output: Content with conditional blocks processed
substitute_conditionals() {
  local content=$1
  local data_json=$2

  # Process {{#var}}...{{/var}} blocks (positive conditionals)
  # Note: This is a simplified implementation that handles single-line conditionals
  # For multi-line, we'd need more complex parsing
  
  local result="$content"
  
  # Extract conditional variables (BSD compatible)
  local cond_vars=$(echo "$content" | perl -nle 'print $1 while /\{\{#([^}]+)\}\}/g' | sort -u || true)
  
  while IFS= read -r var; do
    [[ -z "$var" ]] && continue
    
    local value=$(echo "$data_json" | jq -r ".${var} // empty")
    
    # Check if truthy (not empty, not null, not false)
    if [[ -n "$value" && "$value" != "null" && "$value" != "false" ]]; then
      # Keep the content between tags, remove tags themselves
      result=$(echo "$result" | perl -0777 -pe "s/\{\{#${var}\}\}(.*?)\{\{\/${var}\}\}/\1/gs" || echo "$result")
    else
      # Remove the entire conditional block
      result=$(echo "$result" | perl -0777 -pe "s/\{\{#${var}\}\}.*?\{\{\/${var}\}\}//gs" || echo "$result")
    fi
  done <<< "$cond_vars"
  
  # Process {{^var}}...{{/var}} blocks (inverted conditionals) (BSD compatible)
  local inv_vars=$(echo "$content" | perl -nle 'print $1 while /\{\{\^([^}]+)\}\}/g' | sort -u || true)
  
  while IFS= read -r var; do
    [[ -z "$var" ]] && continue
    
    local value=$(echo "$data_json" | jq -r ".${var} // empty")
    
    # Check if falsy (empty, null, or false)
    if [[ -z "$value" || "$value" == "null" || "$value" == "false" ]]; then
      # Keep the content between tags, remove tags themselves
      result=$(echo "$result" | perl -0777 -pe "s/\{\{\^${var}\}\}(.*?)\{\{\/${var}\}\}/\1/gs" || echo "$result")
    else
      # Remove the entire conditional block
      result=$(echo "$result" | perl -0777 -pe "s/\{\{\^${var}\}\}.*?\{\{\/${var}\}\}//gs" || echo "$result")
    fi
  done <<< "$inv_vars"

  echo "$result"
}

# Process {{#array}}...{{/array}} with iteration (recursive for nested arrays)
# Args: content, data_json
# Output: Content with arrays expanded
substitute_arrays() {
  local content=$1
  local data_json=$2

  local result="$content"

  # Find all {{#arrayname}}...{{/arrayname}} blocks
  local array_names=$(echo "$content" | perl -nle 'print $1 while /\{\{#([a-zA-Z_][a-zA-Z0-9_]*)\}\}/g' | sort -u || true)

  while IFS= read -r array_name; do
    [[ -z "$array_name" ]] && continue

    # Check if this is an array in the JSON
    local is_array=$(echo "$data_json" | jq -r "(.${array_name} | type) == \"array\"" 2>/dev/null || echo "false")

    if [[ "$is_array" != "true" ]]; then
      # Not an array, skip (will be handled by conditionals)
      continue
    fi

    # Process ALL occurrences of this array block (not just the first)
    local occurrence=0
    while echo "$result" | grep -q "{{#${array_name}}}"; do
      occurrence=$((occurrence + 1))

      # Extract the block content for THIS occurrence
      local block=$(echo "$result" | perl -0777 -ne "print \$1 if /\{\{#${array_name}\}\}(.*?)\{\{\/${array_name}\}\}/s")

      if [[ -z "$block" ]]; then
        break
      fi

      # Get array length
      local array_length=$(echo "$data_json" | jq ".${array_name} | length")

      # Build expanded content for THIS block
      local expanded=""

      # Iterate through array
      for ((i=0; i<array_length; i++)); do
        local item_json=$(echo "$data_json" | jq ".${array_name}[$i]")
        local item_type=$(echo "$item_json" | jq -r 'type')
        local item_block="$block"

        # RECURSIVE FIX: Check if item_block contains nested arrays
        # If so, recursively process them BEFORE doing simple variable substitution
        if echo "$item_block" | grep -q '{{#[a-zA-Z_]'; then
          # Has nested arrays - recursively process with item context
          item_block=$(substitute_arrays "$item_block" "$item_json")
        fi

        if [[ "$item_type" == "object" ]]; then
          item_block=$(substitute_conditionals "$item_block" "$item_json")
          item_block=$(substitute_simple_vars "$item_block" "$item_json")
        else
          # Primitive (string, number, etc): substitute {{.}} with the value
          local item_json_str
          item_json_str=$(echo "$item_json" | jq -c '.')
          if [[ -n "$item_json_str" && "$item_json_str" != "null" ]]; then
            item_block=$(python3 -c '
import sys, json
prop = sys.argv[1]
raw = sys.argv[2]
value = json.loads(raw)
if isinstance(value, (dict, list)):
    replacement = json.dumps(value, indent=2)
elif value is None:
    replacement = ""
else:
    replacement = str(value)
content = sys.stdin.read()
print(content.replace("{{"+prop+"}}", replacement), end="")
' "." "$item_json_str" <<< "$item_block")
          fi
        fi

        expanded="${expanded}${item_block}"
      done

      # Replace ONLY THE FIRST occurrence of this block
      local temp_expanded=$(mktemp)
      echo -n "$expanded" > "$temp_expanded"

      # Replace only the first occurrence (not global)
      result=$(echo "$result" | perl -0777 -pe "
        BEGIN {
          open(my \$fh, '<', '$temp_expanded') or die;
          local \$/;
          \$expanded_content = <\$fh>;
          close(\$fh);
        }
        s/\\{\\{#${array_name}\\}\\}.*?\\{\\{\\/${array_name}\\}\\}/\$expanded_content/s;
      ")

      rm -f "$temp_expanded"
    done

  done <<< "$array_names"

  echo "$result"
}

# Main rendering function combining all substitutions
# Args: template_path, data_json
# Output: Rendered content
render_template() {
  local template_path=$1
  local data_json=$2

  # Validate JSON structure
  if ! echo "$data_json" | jq empty 2>/dev/null; then
    echo "Error: Invalid JSON data provided to template renderer" >&2
    return 1
  fi

  # Read template
  if [[ ! -f "$template_path" ]]; then
    echo "Error: Template not found: $template_path" >&2
    return 1
  fi

  local content=$(cat "$template_path")

  # Apply substitutions in order
  # Note: Arrays first (most specific), then conditionals, then simple vars
  content=$(substitute_arrays "$content" "$data_json")
  content=$(substitute_conditionals "$content" "$data_json")
  content=$(substitute_simple_vars "$content" "$data_json")

  echo "$content"
}

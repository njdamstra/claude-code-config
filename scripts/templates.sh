#!/usr/bin/env bash

# templates.sh - Template management system for Claude Code
# Provides discovery, listing, retrieval, and configuration help for templates

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

TEMPLATES_DIR="${HOME}/.claude/templates"
REGISTRY_FILE="${TEMPLATES_DIR}/template-registry.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ============================================================================
# Helper Functions
# ============================================================================

error() {
  echo -e "${RED}Error:${RESET} $1" >&2
  exit 1
}

success() {
  echo -e "${GREEN}✓${RESET} $1"
}

info() {
  echo -e "${CYAN}ℹ${RESET} $1"
}

warning() {
  echo -e "${YELLOW}⚠${RESET} $1"
}

heading() {
  echo -e "\n${BOLD}${BLUE}$1${RESET}"
}

# Check if registry exists
check_registry() {
  if [[ ! -f "$REGISTRY_FILE" ]]; then
    error "Template registry not found at: $REGISTRY_FILE"
  fi
}

# Validate jq is installed
check_jq() {
  if ! command -v jq &> /dev/null; then
    error "jq is required but not installed. Install with: brew install jq"
  fi
}

# ============================================================================
# Command Functions
# ============================================================================

# Show help message
cmd_help() {
  cat <<EOF
${BOLD}templates.sh${RESET} - Template management system for Claude Code

${BOLD}USAGE:${RESET}
  templates.sh <command> [arguments]

${BOLD}COMMANDS:${RESET}
  ${GREEN}help${RESET}                Show this help message
  ${GREEN}list${RESET} [category]     List all templates or templates in a category
  ${GREEN}retrieve${RESET} <id>       Retrieve and display a specific template
  ${GREEN}search${RESET} <query>      Search templates by name, description, or tags
  ${GREEN}categories${RESET}          List all available categories
  ${GREEN}info${RESET} <id>           Show detailed information about a template
  ${GREEN}config${RESET}              Show how to add/edit templates in the system

${BOLD}CATEGORIES:${RESET}
  documenting    Templates for documentation and knowledge capture
  planning       Templates for project planning and task breakdown
  components     Templates for reusable components and patterns

${BOLD}EXAMPLES:${RESET}
  ${CYAN}templates.sh list${RESET}
    List all available templates

  ${CYAN}templates.sh list planning${RESET}
    List only planning templates

  ${CYAN}templates.sh retrieve feature-plan${RESET}
    Display the feature-plan template

  ${CYAN}templates.sh search "bug"${RESET}
    Search for templates related to bugs

  ${CYAN}templates.sh info vue-component${RESET}
    Show details about the vue-component template

  ${CYAN}templates.sh config${RESET}
    Learn how to add new templates to the system

EOF
}

# List all templates or templates in a category
cmd_list() {
  check_registry
  check_jq

  local category="${1:-}"

  if [[ -z "$category" ]]; then
    # List all templates grouped by category
    heading "Available Templates"

    for cat in $(jq -r '.categories | keys[]' "$REGISTRY_FILE"); do
      local cat_desc=$(jq -r ".categories.${cat}.description" "$REGISTRY_FILE")
      echo -e "\n${BOLD}${YELLOW}${cat}${RESET} - ${cat_desc}"

      jq -r ".categories.${cat}.templates[] | \"  \(.id) - \(.name)\"" "$REGISTRY_FILE" | while read -r line; do
        echo -e "  ${GREEN}${line}${RESET}"
      done
    done

    echo ""
    local total=$(jq -r '.metadata.totalTemplates' "$REGISTRY_FILE")
    info "Total templates: ${total}"

  else
    # List templates in specific category
    if ! jq -e ".categories.${category}" "$REGISTRY_FILE" > /dev/null 2>&1; then
      error "Category '${category}' not found. Use 'categories' command to see available categories."
    fi

    heading "Templates in '${category}' category"

    jq -r ".categories.${category}.templates[] | \"\(.id)\t\(.name)\t\(.description)\"" "$REGISTRY_FILE" | \
    while IFS=$'\t' read -r id name desc; do
      echo -e "${GREEN}${id}${RESET}"
      echo -e "  ${name}"
      echo -e "  ${desc}"
      echo ""
    done
  fi
}

# Show available categories
cmd_categories() {
  check_registry
  check_jq

  heading "Available Categories"

  jq -r '.categories | to_entries[] | "\(.key)\t\(.value.description)"' "$REGISTRY_FILE" | \
  while IFS=$'\t' read -r cat desc; do
    echo -e "${YELLOW}${cat}${RESET}"
    echo -e "  ${desc}"
    echo ""
  done
}

# Retrieve and display a template
cmd_retrieve() {
  check_registry
  check_jq

  local template_id="${1:-}"

  if [[ -z "$template_id" ]]; then
    error "Template ID required. Usage: templates.sh retrieve <id>"
  fi

  # Find template in registry
  local template_file=$(jq -r --arg id "$template_id" \
    '.categories[].templates[] | select(.id == $id) | .file' "$REGISTRY_FILE")

  if [[ -z "$template_file" ]]; then
    error "Template '${template_id}' not found. Use 'list' command to see available templates."
  fi

  local full_path="${TEMPLATES_DIR}/${template_file}"

  if [[ ! -f "$full_path" ]]; then
    error "Template file not found at: ${full_path}"
  fi

  # Display template
  heading "Template: ${template_id}"
  echo ""
  cat "$full_path"
  echo ""
  success "Template retrieved from: ${template_file}"
}

# Search templates by query
cmd_search() {
  check_registry
  check_jq

  local query="${1:-}"

  if [[ -z "$query" ]]; then
    error "Search query required. Usage: templates.sh search <query>"
  fi

  heading "Search results for: '${query}'"

  local found=0
  local query_lower=$(echo "$query" | tr '[:upper:]' '[:lower:]')

  local results=$(jq -r --arg q "$query_lower" \
    '.categories[].templates[] |
     select(
       (.name | ascii_downcase | contains($q)) or
       (.description | ascii_downcase | contains($q)) or
       (.tags[] | ascii_downcase | contains($q))
     ) | "\(.id)\t\(.name)\t\(.description)"' "$REGISTRY_FILE")

  if [[ -n "$results" ]]; then
    while IFS=$'\t' read -r id name desc; do
      echo -e "\n${GREEN}${id}${RESET}"
      echo -e "  ${name}"
      echo -e "  ${desc}"
    done <<< "$results"
    found=1
  fi

  if [[ $found -eq 0 ]]; then
    warning "No templates found matching: '${query}'"
  fi
  echo ""
}

# Show detailed info about a template
cmd_info() {
  check_registry
  check_jq

  local template_id="${1:-}"

  if [[ -z "$template_id" ]]; then
    error "Template ID required. Usage: templates.sh info <id>"
  fi

  # Find template in registry
  local template_json=$(jq -r --arg id "$template_id" \
    '.categories[].templates[] | select(.id == $id)' "$REGISTRY_FILE")

  if [[ -z "$template_json" ]]; then
    error "Template '${template_id}' not found."
  fi

  heading "Template Information: ${template_id}"

  echo "$template_json" | jq -r '"
Name:        \(.name)
File:        \(.file)
Description: \(.description)
Tags:        \(.tags | join(", "))"'

  local full_path="${TEMPLATES_DIR}/$(echo "$template_json" | jq -r '.file')"

  if [[ -f "$full_path" ]]; then
    local line_count=$(wc -l < "$full_path" | tr -d ' ')
    echo "Lines:       ${line_count}"
    success "Template file exists"
  else
    warning "Template file not found at: ${full_path}"
  fi

  echo ""
}

# Show configuration help
cmd_config() {
  cat <<EOF
${BOLD}${BLUE}Template System Configuration Guide${RESET}

${BOLD}How to Add a New Template:${RESET}

${BOLD}1. Create the Template File${RESET}
   Place your template in the appropriate category folder:

   ${CYAN}~/.claude/templates/documenting/${RESET}  - Documentation templates
   ${CYAN}~/.claude/templates/planning/${RESET}     - Planning templates
   ${CYAN}~/.claude/templates/components/${RESET}   - Component templates

   Example:
   ${GREEN}vim ~/.claude/templates/planning/my-new-plan.md${RESET}

${BOLD}2. Register in template-registry.json${RESET}
   Edit ${CYAN}~/.claude/templates/template-registry.json${RESET}

   Add entry to appropriate category:

   ${YELLOW}{
     "id": "my-new-plan",
     "name": "My New Plan Template",
     "file": "planning/my-new-plan.md",
     "description": "Brief description of what this template does",
     "tags": ["planning", "workflow", "custom"]
   }${RESET}

${BOLD}3. Update Template Count${RESET}
   Increment ${CYAN}metadata.totalTemplates${RESET} in registry.json

${BOLD}4. Test the Template${RESET}
   ${GREEN}templates.sh list planning${RESET}          # Should show your template
   ${GREEN}templates.sh info my-new-plan${RESET}       # Show template details
   ${GREEN}templates.sh retrieve my-new-plan${RESET}   # Display template

${BOLD}Template ID Naming Convention:${RESET}
  • Use kebab-case (lowercase with dashes)
  • Be descriptive but concise
  • Examples: feature-plan, bug-report, vue-component

${BOLD}File Path Convention:${RESET}
  • Path relative to ~/.claude/templates/
  • Include category folder: planning/my-template.md
  • Use appropriate extension: .md, .vue, .ts, .json

${BOLD}Tags Best Practices:${RESET}
  • Include category as first tag
  • Add technology tags: vue, typescript, appwrite
  • Add type tags: documentation, component, workflow
  • Use lowercase, no spaces

${BOLD}Example Complete Entry:${RESET}

${YELLOW}"api-integration": {
  "name": "API Integration Plan",
  "file": "planning/api-integration.md",
  "description": "Template for planning external API integrations",
  "tags": ["planning", "api", "integration", "backend"]
}${RESET}

${BOLD}Creating New Categories:${RESET}

To add a new category, edit template-registry.json:

${YELLOW}"categories": {
  "my-category": {
    "description": "Description of this category",
    "templates": []
  }
}${RESET}

${BOLD}Validation:${RESET}
  • Ensure JSON is valid: ${GREEN}jq . template-registry.json${RESET}
  • Test template access: ${GREEN}templates.sh retrieve <id>${RESET}
  • Verify search works: ${GREEN}templates.sh search <keyword>${RESET}

${BOLD}Integration with Slash Commands:${RESET}

  Use ${CYAN}/templates${RESET} slash command in Claude Code:

  ${GREEN}/templates list${RESET}                # List all templates
  ${GREEN}/templates retrieve feature-plan${RESET}  # Get specific template
  ${GREEN}/templates search "component"${RESET}     # Search templates

For more help: ${CYAN}templates.sh help${RESET}

EOF
}

# ============================================================================
# Main Entry Point
# ============================================================================

main() {
  local command="${1:-help}"
  shift || true

  case "$command" in
    help)
      cmd_help
      ;;
    list)
      cmd_list "$@"
      ;;
    retrieve)
      cmd_retrieve "$@"
      ;;
    search)
      cmd_search "$@"
      ;;
    categories)
      cmd_categories
      ;;
    info)
      cmd_info "$@"
      ;;
    config)
      cmd_config
      ;;
    *)
      error "Unknown command: ${command}. Use 'help' for usage information."
      ;;
  esac
}

main "$@"

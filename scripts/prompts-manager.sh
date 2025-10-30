#!/bin/bash

# Prompts Manager Script
# Handles CRUD operations, merging, and variable substitution for Claude Code prompts

set -euo pipefail

# Paths
USER_PROMPTS="$HOME/.claude/prompts.json"
PROJECT_PROMPTS="./.claude/prompts.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize prompts file if it doesn't exist
init_prompts_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        mkdir -p "$(dirname "$file")"
        echo '{"prompts":[]}' > "$file"
    fi
}

# Load and merge prompts from both levels
load_prompts() {
    init_prompts_file "$USER_PROMPTS"

    local user_prompts=$(cat "$USER_PROMPTS")
    local project_prompts='{"prompts":[]}'

    if [ -f "$PROJECT_PROMPTS" ]; then
        project_prompts=$(cat "$PROJECT_PROMPTS")
    fi

    # Merge: project prompts override user prompts with same name
    # Use jq to merge arrays, keeping project version (last) for duplicates
    echo "$user_prompts" "$project_prompts" | jq -s '
        .[0].prompts + .[1].prompts |
        group_by(.name) |
        map(.[-1]) |
        {prompts: .}
    '
}

# Get single prompt by name
get_prompt() {
    local name="$1"
    load_prompts | jq -r --arg name "$name" '
        .prompts[] | select(.name == $name)
    '
}

# List all prompts with optional tag filter
list_prompts() {
    local tag_filter="${1:-}"
    local prompts=$(load_prompts)

    if [ -n "$tag_filter" ]; then
        prompts=$(echo "$prompts" | jq --arg tag "$tag_filter" '
            .prompts | map(select(.tags[]? == $tag))
        ')
    else
        prompts=$(echo "$prompts" | jq '.prompts')
    fi

    local count=$(echo "$prompts" | jq 'length')

    if [ "$count" -eq 0 ]; then
        echo -e "${YELLOW}No prompts found${NC}"
        return
    fi

    echo -e "${BLUE}Available Prompts ($count):${NC}\n"

    echo "$prompts" | jq -r '.[] |
        "🔹 \(.name)\n   \(.description)\n   Tags: \(.tags | join(", "))\n   Used: \(.usageCount) times" +
        (if .lastUsed then " | Last: \(.lastUsed)" else "" end) + "\n"
    '
}

# Search prompts by keyword
search_prompts() {
    local keyword="$1"
    local prompts=$(load_prompts)

    echo "$prompts" | jq -r --arg keyword "$keyword" '
        .prompts[] |
        select(
            (.name | contains($keyword)) or
            (.description | contains($keyword)) or
            (.prompt | contains($keyword)) or
            (.tags[]? | contains($keyword))
        ) |
        "🔍 \(.name)\n   \(.description)\n   Tags: \(.tags | join(", "))\n"
    '
}

# Store new prompt
store_prompt() {
    local name="$1"
    local description="$2"
    local prompt="$3"
    local tags="${4:-general}"
    local notes="${5:-}"
    local scope="${6:-user}" # user or project

    local file="$USER_PROMPTS"
    if [ "$scope" = "project" ]; then
        file="$PROJECT_PROMPTS"
        init_prompts_file "$file"
    fi

    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local tags_array=$(echo "$tags" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$";""))')

    # Extract variables from prompt
    local variables=$(echo "$prompt" | grep -o '{{[A-Z_]*}}' | sed 's/[{}]//g' | jq -R . | jq -s 'unique')

    # Check if prompt exists
    local existing=$(cat "$file" | jq --arg name "$name" '.prompts[] | select(.name == $name)')

    if [ -n "$existing" ]; then
        # Update existing
        cat "$file" | jq --arg name "$name" \
            --arg desc "$description" \
            --arg prompt "$prompt" \
            --argjson tags "$tags_array" \
            --arg notes "$notes" \
            --arg timestamp "$timestamp" \
            --argjson vars "$variables" '
            .prompts |= map(
                if .name == $name then
                    .description = $desc |
                    .prompt = $prompt |
                    .tags = $tags |
                    .notes = $notes |
                    .updatedAt = $timestamp |
                    .variables = $vars
                else . end
            )
        ' > "$file.tmp" && mv "$file.tmp" "$file"

        echo -e "${GREEN}✓ Updated prompt: $name${NC}"
    else
        # Create new
        cat "$file" | jq --arg name "$name" \
            --arg desc "$description" \
            --arg prompt "$prompt" \
            --argjson tags "$tags_array" \
            --arg notes "$notes" \
            --arg timestamp "$timestamp" \
            --argjson vars "$variables" '
            .prompts += [{
                name: $name,
                description: $desc,
                prompt: $prompt,
                tags: $tags,
                notes: $notes,
                usageCount: 0,
                lastUsed: null,
                variables: $vars,
                createdAt: $timestamp,
                updatedAt: $timestamp
            }]
        ' > "$file.tmp" && mv "$file.tmp" "$file"

        echo -e "${GREEN}✓ Created prompt: $name${NC}"
    fi
}

# Delete prompt
delete_prompt() {
    local name="$1"

    # Check which file contains the prompt
    local in_user=$(cat "$USER_PROMPTS" 2>/dev/null | jq --arg name "$name" '.prompts[] | select(.name == $name)' || echo "")
    local in_project=""
    if [ -f "$PROJECT_PROMPTS" ]; then
        in_project=$(cat "$PROJECT_PROMPTS" | jq --arg name "$name" '.prompts[] | select(.name == $name)' || echo "")
    fi

    if [ -z "$in_user" ] && [ -z "$in_project" ]; then
        echo -e "${RED}✗ Prompt not found: $name${NC}"
        return 1
    fi

    # Delete from appropriate file
    if [ -n "$in_project" ]; then
        cat "$PROJECT_PROMPTS" | jq --arg name "$name" '
            .prompts |= map(select(.name != $name))
        ' > "$PROJECT_PROMPTS.tmp" && mv "$PROJECT_PROMPTS.tmp" "$PROJECT_PROMPTS"
        echo -e "${GREEN}✓ Deleted prompt from project: $name${NC}"
    elif [ -n "$in_user" ]; then
        cat "$USER_PROMPTS" | jq --arg name "$name" '
            .prompts |= map(select(.name != $name))
        ' > "$USER_PROMPTS.tmp" && mv "$USER_PROMPTS.tmp" "$USER_PROMPTS"
        echo -e "${GREEN}✓ Deleted prompt from user library: $name${NC}"
    fi
}

# Update usage statistics
update_usage() {
    local name="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Determine which file contains the prompt
    local in_user=$(cat "$USER_PROMPTS" 2>/dev/null | jq --arg name "$name" '.prompts[] | select(.name == $name)' || echo "")
    local file="$USER_PROMPTS"

    if [ -f "$PROJECT_PROMPTS" ]; then
        local in_project=$(cat "$PROJECT_PROMPTS" | jq --arg name "$name" '.prompts[] | select(.name == $name)' || echo "")
        if [ -n "$in_project" ]; then
            file="$PROJECT_PROMPTS"
        fi
    fi

    cat "$file" | jq --arg name "$name" --arg timestamp "$timestamp" '
        .prompts |= map(
            if .name == $name then
                .usageCount += 1 |
                .lastUsed = $timestamp
            else . end
        )
    ' > "$file.tmp" && mv "$file.tmp" "$file"
}

# Get prompt with variable substitution
inject_prompt() {
    local name="$1"
    local user_message="${2:-}"

    # Handle case where only name is provided
    if [ $# -le 1 ]; then
        shift || true
    else
        shift 2 || true
    fi

    local extra_vars=("$@")

    local prompt_data=$(get_prompt "$name")

    if [ -z "$prompt_data" ]; then
        echo -e "${RED}✗ Prompt not found: $name${NC}" >&2
        return 1
    fi

    local prompt_text=$(echo "$prompt_data" | jq -r '.prompt')

    # Substitute {{USER_MESSAGE}}
    prompt_text="${prompt_text//\{\{USER_MESSAGE\}\}/$user_message}"

    # Substitute other variables from extra_vars (format: VAR=value)
    if [ ${#extra_vars[@]} -gt 0 ]; then
        for var_pair in "${extra_vars[@]}"; do
            if [[ "$var_pair" =~ ^([A-Z_]+)=(.*)$ ]]; then
                local var_name="${BASH_REMATCH[1]}"
                local var_value="${BASH_REMATCH[2]}"
                prompt_text="${prompt_text//\{\{$var_name\}\}/$var_value}"
            fi
        done
    fi

    # Update usage stats
    update_usage "$name"

    # Return the substituted prompt
    echo "$prompt_text"
}

# Preview prompt without execution
preview_prompt() {
    local name="$1"
    local user_message="${2:-[USER_MESSAGE]}"

    local prompt_data=$(get_prompt "$name")

    if [ -z "$prompt_data" ]; then
        echo -e "${RED}✗ Prompt not found: $name${NC}"
        return 1
    fi

    echo -e "${BLUE}Preview: $name${NC}"
    echo -e "${BLUE}$(printf '=%.0s' {1..60})${NC}\n"

    local prompt_text=$(echo "$prompt_data" | jq -r '.prompt')
    prompt_text="${prompt_text//\{\{USER_MESSAGE\}\}/$user_message}"

    echo "$prompt_text"

    echo -e "\n${BLUE}$(printf '=%.0s' {1..60})${NC}"
    echo -e "${YELLOW}Variables:${NC} $(echo "$prompt_data" | jq -r '.variables | join(", ")')"
    echo -e "${YELLOW}Tags:${NC} $(echo "$prompt_data" | jq -r '.tags | join(", ")')"
}

# Show usage statistics
show_stats() {
    local prompts=$(load_prompts)

    echo -e "${BLUE}Prompt Usage Statistics:${NC}\n"

    echo "$prompts" | jq -r '.prompts | sort_by(.usageCount) | reverse | .[] |
        "📊 \(.name) - \(.usageCount) uses" +
        (if .lastUsed then " | Last: \(.lastUsed)" else " | Never used" end)
    '
}

# Export prompts
export_prompts() {
    local output_file="${1:-prompts-export.json}"
    local prompts=$(load_prompts)

    echo "$prompts" > "$output_file"
    echo -e "${GREEN}✓ Exported prompts to: $output_file${NC}"
}

# Import prompts
import_prompts() {
    local input_file="$1"
    local scope="${2:-user}"

    if [ ! -f "$input_file" ]; then
        echo -e "${RED}✗ File not found: $input_file${NC}"
        return 1
    fi

    local file="$USER_PROMPTS"
    if [ "$scope" = "project" ]; then
        file="$PROJECT_PROMPTS"
        init_prompts_file "$file"
    fi

    local imported=$(cat "$input_file")
    local current=$(cat "$file")

    # Merge imported prompts with current, keeping newer versions
    echo "$current" "$imported" | jq -s '
        .[0].prompts + .[1].prompts |
        group_by(.name) |
        map(max_by(.updatedAt)) |
        {prompts: .}
    ' > "$file.tmp" && mv "$file.tmp" "$file"

    local count=$(echo "$imported" | jq '.prompts | length')
    echo -e "${GREEN}✓ Imported $count prompts${NC}"
}

# Main command router
main() {
    local command="${1:-list}"
    shift || true

    case "$command" in
        list)
            local tag_filter="${1:-}"
            list_prompts "$tag_filter"
            ;;
        search)
            if [ $# -eq 0 ]; then
                echo -e "${RED}Usage: search <keyword>${NC}"
                exit 1
            fi
            search_prompts "$1"
            ;;
        filter)
            if [ "$1" = "--tag" ] && [ -n "${2:-}" ]; then
                list_prompts "$2"
            else
                echo -e "${RED}Usage: filter --tag <tag>${NC}"
                exit 1
            fi
            ;;
        store)
            if [ $# -lt 2 ]; then
                echo -e "${RED}Usage: store <name> <description> [--tags tag1,tag2] [--notes \"...\"] [--scope user|project]${NC}"
                exit 1
            fi
            local name="$1"
            local description="$2"
            shift 2

            # Parse optional flags
            local tags="general"
            local notes=""
            local scope="user"
            local prompt=""

            while [ $# -gt 0 ]; do
                case "$1" in
                    --tags)
                        tags="$2"
                        shift 2
                        ;;
                    --notes)
                        notes="$2"
                        shift 2
                        ;;
                    --scope)
                        scope="$2"
                        shift 2
                        ;;
                    --prompt)
                        prompt="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done

            # If no prompt provided, enter interactive mode
            if [ -z "$prompt" ]; then
                echo -e "${YELLOW}Enter prompt text (end with Ctrl+D):${NC}"
                prompt=$(cat)
            fi

            store_prompt "$name" "$description" "$prompt" "$tags" "$notes" "$scope"
            ;;
        delete)
            if [ $# -eq 0 ]; then
                echo -e "${RED}Usage: delete <name>${NC}"
                exit 1
            fi
            delete_prompt "$1"
            ;;
        inject)
            if [ $# -eq 0 ]; then
                echo -e "${RED}Usage: inject <name> [user-message] [VAR=value ...]${NC}"
                exit 1
            fi
            inject_prompt "$@"
            ;;
        preview)
            if [ $# -eq 0 ]; then
                echo -e "${RED}Usage: preview <name> [user-message]${NC}"
                exit 1
            fi
            preview_prompt "$1" "${2:-}"
            ;;
        stats)
            show_stats
            ;;
        export)
            export_prompts "${1:-prompts-export.json}"
            ;;
        import)
            if [ $# -eq 0 ]; then
                echo -e "${RED}Usage: import <filename> [user|project]${NC}"
                exit 1
            fi
            import_prompts "$1" "${2:-user}"
            ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            echo -e "Available commands: list, search, filter, store, delete, inject, preview, stats, export, import"
            exit 1
            ;;
    esac
}

main "$@"

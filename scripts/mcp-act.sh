#!/usr/bin/env bash

# MCP Act - MCP Server Management with Presets
# Version: 2.0 (Improved with validation and security)
# Usage: mcp-act <action> [server-name|preset-name] [scope]

set -e

CONFIG_FILE="$HOME/.claude/mcp-servers-config.json"
CLAUDE_CONFIG="$HOME/.claude.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; exit 1; }
tip() { echo -e "${CYAN}💡${NC} $1"; }

# Check if jq is available
if ! command -v jq &> /dev/null; then
    error "jq is required but not installed. Install with: brew install jq (macOS) or apt-get install jq (Linux)"
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    error "Configuration file not found: $CONFIG_FILE"
fi

# Parse arguments
ACTION="${1:-list}"
TARGET="${2:-}"
SCOPE="${3:-project}"

# Resolve alias to actual server name
resolve_alias() {
    local input="$1"

    # First check if it's already a valid server name
    if jq -e ".servers[\"$input\"]" "$CONFIG_FILE" &>/dev/null; then
        echo "$input"
        return 0
    fi

    # Check if it's an alias
    local resolved=$(jq -r ".servers | to_entries[] | select(.value.aliases[]? == \"$input\") | .key" "$CONFIG_FILE" 2>/dev/null | head -n1)

    if [ -n "$resolved" ]; then
        echo "$resolved"
        return 0
    fi

    # Not found as server or alias
    echo "$input"
    return 1
}

# Get server list from preset or single server
get_servers() {
    local target="$1"

    if [[ "$target" == preset:* ]]; then
        # It's a preset
        local preset_name="${target#preset:}"
        local servers=$(jq -r ".presets[\"$preset_name\"].servers[]" "$CONFIG_FILE" 2>/dev/null)

        if [ -z "$servers" ]; then
            error "Preset '$preset_name' not found"
        fi

        echo "$servers"
    else
        # It's a single server - try to resolve alias first
        local resolved=$(resolve_alias "$target")

        if jq -e ".servers[\"$resolved\"]" "$CONFIG_FILE" &>/dev/null; then
            if [ "$resolved" != "$target" ]; then
                info "Resolved alias '$target' to '$resolved'" >&2
            fi
            echo "$resolved"
        else
            error "Server '$target' not found in configuration (checked aliases too)"
        fi
    fi
}

# Get server config
get_server_config() {
    local server_name="$1"
    jq -r ".servers[\"$server_name\"]" "$CONFIG_FILE"
}

# Validate environment variables for a server
validate_env_vars() {
    local server_name="$1"
    local config=$(get_server_config "$server_name")

    local missing_vars=()

    # 1. Check env object for ${VAR} references
    local env_keys=$(echo "$config" | jq -r '.env | keys[]?' 2>/dev/null)

    for var in $env_keys; do
        local var_value=$(echo "$config" | jq -r ".env[\"$var\"]")

        # Check if it's a template variable (${VAR_NAME})
        if [[ "$var_value" =~ ^\$\{([A-Z_]+)\}$ ]]; then
            local env_name="${BASH_REMATCH[1]}"

            if [ -z "${!env_name}" ]; then
                missing_vars+=("$env_name")
            fi
        fi
    done

    # 2. Check args array for ${VAR} references (e.g., Tavily pattern)
    local args_string=$(echo "$config" | jq -r '.args | join(" ")' 2>/dev/null)

    if [ -n "$args_string" ]; then
        # Extract all ${VAR_NAME} patterns from args
        while [[ "$args_string" =~ \$\{([A-Z_][A-Z0-9_]*)\} ]]; do
            local env_name="${BASH_REMATCH[1]}"

            # Check if variable is set
            if [ -z "${!env_name}" ]; then
                # Avoid duplicates
                if [[ ! " ${missing_vars[@]} " =~ " ${env_name} " ]]; then
                    missing_vars+=("$env_name")
                fi
            fi

            # Remove matched pattern to continue searching
            args_string="${args_string/${BASH_REMATCH[0]}/}"
        done
    fi

    # 3. If no env vars found in either location, return success
    if [ -z "$env_keys" ] && [ -z "$args_string" ]; then
        return 0
    fi

    # 4. Report missing vars if any
    if [ ${#missing_vars[@]} -gt 0 ]; then
        warning "Server '$server_name' requires environment variables:"
        for missing_var in "${missing_vars[@]}"; do
            echo -e "  ${RED}✗${NC} $missing_var (not set)"
        done

        local notes=$(echo "$config" | jq -r '.notes // "No additional notes"')
        tip "$notes"

        echo ""
        echo -e "${MAGENTA}=== How to Fix ===${NC}"
        echo ""
        echo -e "${CYAN}Method 1: Persistent (Recommended)${NC}"
        echo "  1. Add to shell profile:"
        echo "     echo 'export ${missing_vars[0]}=\"your-key-here\"' >> ~/.zshrc"
        echo ""
        echo "  2. FULLY RESTART Claude Code (Cmd+Q, then reopen)"
        echo "     Note: Just restarting the terminal is NOT enough!"
        echo ""
        echo -e "${CYAN}Method 2: Quick Testing${NC}"
        echo "  Use inline export for immediate testing:"
        echo "     export ${missing_vars[0]}=\"your-key\" && ~/.claude/scripts/mcp-act.sh add $server_name"
        echo ""
        tip "Claude Code does NOT automatically source ~/.zshrc. Full app restart required for persistent env vars."
        return 1
    fi

    success "Environment variables validated for '$server_name'"
    return 0
}

# Action: list
action_list() {
    info "Listing all configured MCP servers..."
    echo ""
    echo -e "${MAGENTA}=== Presets ===${NC}"
    jq -r '.presets | to_entries[] | "\(.key): \(.value.description) [\(.value.servers | join(", "))]"' "$CONFIG_FILE"
    echo ""
    echo -e "${MAGENTA}=== Individual Servers ===${NC}"
    jq -r '.servers | to_entries[] | "\(.key): \(.value.description)" + (if .value.aliases then " [aliases: \(.value.aliases | join(", "))]" else "" end)' "$CONFIG_FILE"
    echo ""

    # Show active MCP servers grouped by scope
    info "Active MCP servers:"
    echo ""

    # Check user-level servers
    if [ -f "$CLAUDE_CONFIG" ]; then
        local user_servers=$(jq -r '.mcpServers | keys[]?' "$CLAUDE_CONFIG" 2>/dev/null)
        if [ -n "$user_servers" ]; then
            echo -e "${CYAN}User-level (global):${NC}"
            while IFS= read -r server; do
                local cmd=$(jq -r ".mcpServers[\"$server\"].command" "$CLAUDE_CONFIG")
                local args=$(jq -r ".mcpServers[\"$server\"].args | join(\" \")" "$CLAUDE_CONFIG")
                echo "  • $server: $cmd $args"
            done <<< "$user_servers"
            echo ""
        fi
    fi

    # Check project-level servers (current working directory)
    # Try both ./.mcp.json (root), ./.claude/.mcp.json (claude dir), and ~/.claude/.mcp.json (home)
    local project_config=""
    if [ -f "./.mcp.json" ]; then
        project_config="./.mcp.json"
    elif [ -f "./.claude/.mcp.json" ]; then
        project_config="./.claude/.mcp.json"
    elif [ -f "$HOME/.claude/.mcp.json" ]; then
        project_config="$HOME/.claude/.mcp.json"
    fi

    if [ -n "$project_config" ]; then
        local project_servers=$(jq -r '.mcpServers | keys[]?' "$project_config" 2>/dev/null)
        if [ -n "$project_servers" ]; then
            echo -e "${CYAN}Project-level (local):${NC}"
            while IFS= read -r server; do
                local cmd=$(jq -r ".mcpServers[\"$server\"].command" "$project_config")
                local args=$(jq -r ".mcpServers[\"$server\"].args | join(\" \")" "$project_config")
                echo "  • $server: $cmd $args"
            done <<< "$project_servers"
            echo ""
        fi
    fi

    # Show connection status
    claude mcp list 2>/dev/null | grep -E "✓ Connected|✗ " || warning "Could not check server connection status"
}

# Action: info
action_info() {
    local target="$1"

    if [[ "$target" == preset:* ]]; then
        local preset_name="${target#preset:}"
        info "Preset: $preset_name"
        echo ""
        jq ".presets[\"$preset_name\"]" "$CONFIG_FILE" || error "Preset not found"
    else
        # Resolve alias if necessary
        local resolved=$(resolve_alias "$target")
        if [ "$resolved" != "$target" ]; then
            info "Resolved alias '$target' to '$resolved'"
            echo ""
        fi
        info "Server: $resolved"
        echo ""
        jq ".servers[\"$resolved\"]" "$CONFIG_FILE" || error "Server not found"
    fi
}

# Action: add
action_add() {
    local target="$1"
    local scope="$2"

    info "Adding servers (scope: $scope)..."
    echo ""

    local servers=$(get_servers "$target" 2>/dev/null)

    if [ -z "$servers" ]; then
        error "No servers found for: $target"
    fi

    local failed_servers=()
    local added_servers=()

    # Determine target config file based on scope
    local target_config=""
    if [ "$scope" = "user" ]; then
        target_config="$CLAUDE_CONFIG"
    else
        # Project scope - check for existing project config or use home claude dir
        if [ -f "./.mcp.json" ]; then
            target_config="./.mcp.json"
        elif [ -f "./.claude/.mcp.json" ]; then
            target_config="./.claude/.mcp.json"
        elif [ -f "$HOME/.claude/.mcp.json" ]; then
            target_config="$HOME/.claude/.mcp.json"
        else
            # Create in home claude dir if no project config exists
            target_config="$HOME/.claude/.mcp.json"
            # Initialize with empty mcpServers object if file doesn't exist
            if [ ! -f "$target_config" ]; then
                echo '{"mcpServers":{}}' > "$target_config"
            fi
        fi
    fi

    # Ensure the config file has mcpServers object
    if [ ! -f "$target_config" ]; then
        echo '{"mcpServers":{}}' > "$target_config"
    fi

    for server in $servers; do
        info "Processing: $server"

        # Check if server already exists
        if jq -e ".mcpServers[\"$server\"]" "$target_config" &>/dev/null; then
            warning "Server '$server' already exists in config, skipping"
            failed_servers+=("$server (already exists)")
            echo ""
            continue
        fi

        # Validate environment variables first
        if ! validate_env_vars "$server"; then
            failed_servers+=("$server (missing env vars)")
            echo ""
            continue
        fi

        local config=$(get_server_config "$server")
        local command=$(echo "$config" | jq -r '.command')
        local args=$(echo "$config" | jq -r '.args')
        local env=$(echo "$config" | jq -r '.env')

        # Substitute environment variables in args
        local substituted_args=$(echo "$args" | jq -r 'map(
            gsub("\\$\\{(?<var>[A-Z_]+)\\}"; env["\(.var)"] // "${\(.var)}")
        )')

        # Build the server entry
        local server_entry=$(jq -n \
            --arg cmd "$command" \
            --argjson args "$substituted_args" \
            --argjson env "$env" \
            '{
                type: "stdio",
                command: $cmd,
                args: $args,
                env: $env
            }')

        # Add server to config
        local tmp_file=$(mktemp)
        jq ".mcpServers[\"$server\"] = $server_entry" "$target_config" > "$tmp_file"

        if [ $? -eq 0 ]; then
            mv "$tmp_file" "$target_config"
            success "Added to config: $server"
            added_servers+=("$server")
        else
            rm -f "$tmp_file"
            warning "Failed to add: $server"
            failed_servers+=("$server (jq error)")
        fi
        echo ""
    done

    # Summary
    echo -e "${MAGENTA}=== Summary ===${NC}"
    if [ ${#added_servers[@]} -gt 0 ]; then
        success "Successfully added ${#added_servers[@]} server(s) to $target_config:"
        for server in "${added_servers[@]}"; do
            echo "  ✓ $server"
        done
    fi

    if [ ${#failed_servers[@]} -gt 0 ]; then
        warning "Failed to add ${#failed_servers[@]} server(s):"
        for server in "${failed_servers[@]}"; do
            echo "  ✗ $server"
        done
    fi

    echo ""
    tip "Restart Claude Code to apply changes. Verify with: claude mcp list"
}

# Action: remove
action_remove() {
    local target="$1"

    info "Removing servers..."
    echo ""

    local servers=$(get_servers "$target" 2>/dev/null)

    if [ -z "$servers" ]; then
        error "No servers found for: $target"
    fi

    local removed_servers=()
    local failed_servers=()

    for server in $servers; do
        info "Removing: $server"

        local removed_from_any=false

        # Try to remove from user-level config
        if [ -f "$CLAUDE_CONFIG" ]; then
            if jq -e ".mcpServers[\"$server\"]" "$CLAUDE_CONFIG" &>/dev/null; then
                # Server exists in user config - remove it
                local tmp_file=$(mktemp)
                jq "del(.mcpServers[\"$server\"])" "$CLAUDE_CONFIG" > "$tmp_file"
                mv "$tmp_file" "$CLAUDE_CONFIG"
                success "Removed from user-level config: $server"
                removed_from_any=true
            fi
        fi

        # Try to remove from project-level config
        local project_config=""
        if [ -f "./.mcp.json" ]; then
            project_config="./.mcp.json"
        elif [ -f "./.claude/.mcp.json" ]; then
            project_config="./.claude/.mcp.json"
        elif [ -f "$HOME/.claude/.mcp.json" ]; then
            project_config="$HOME/.claude/.mcp.json"
        fi

        if [ -n "$project_config" ]; then
            if jq -e ".mcpServers[\"$server\"]" "$project_config" &>/dev/null; then
                # Server exists in project config - remove it
                local tmp_file=$(mktemp)
                jq "del(.mcpServers[\"$server\"])" "$project_config" > "$tmp_file"
                mv "$tmp_file" "$project_config"
                success "Removed from project-level config: $server"
                removed_from_any=true
            fi
        fi

        if [ "$removed_from_any" = true ]; then
            removed_servers+=("$server")
        else
            warning "Server not found in any config: $server"
            failed_servers+=("$server")
        fi
        echo ""
    done

    # Summary
    echo -e "${MAGENTA}=== Summary ===${NC}"
    if [ ${#removed_servers[@]} -gt 0 ]; then
        success "Successfully removed ${#removed_servers[@]} server(s):"
        for server in "${removed_servers[@]}"; do
            echo "  ✓ $server"
        done
    fi

    if [ ${#failed_servers[@]} -gt 0 ]; then
        warning "Failed to remove ${#failed_servers[@]} server(s):"
        for server in "${failed_servers[@]}"; do
            echo "  ✗ $server (not found in configs)"
        done
    fi

    echo ""
    tip "Restart Claude Code to apply changes. Verify with: claude mcp list"
}

# Action: audit (NEW - security check)
action_audit() {
    info "Auditing ~/.claude.json for security issues..."
    echo ""

    if [ ! -f "$CLAUDE_CONFIG" ]; then
        warning "Claude config not found: $CLAUDE_CONFIG"
        return 1
    fi

    # Check for hardcoded secrets (long alphanumeric strings that aren't ${VAR})
    local potential_secrets=$(jq -r '.mcpServers | to_entries[] | select(.value.env | to_entries[]? | .value | type == "string" and (test("^[A-Za-z0-9_-]{20,}$") and (test("^\\$\\{") | not))) | "\(.key): \(.value.env | to_entries[] | select(.value | type == "string" and (test("^[A-Za-z0-9_-]{20,}$") and (test("^\\$\\{") | not))) | .key)"' "$CLAUDE_CONFIG" 2>/dev/null)

    if [ -n "$potential_secrets" ]; then
        warning "Potential hardcoded secrets detected:"
        echo "$potential_secrets"
        echo ""
        tip "Replace hardcoded values with environment variable references: \${VAR_NAME}"
        echo ""
        info "Example fix:"
        echo '  "env": { "API_KEY": "${API_KEY}" }  ← Good'
        echo '  "env": { "API_KEY": "abc123..." }   ← Bad (hardcoded)'
        return 1
    else
        success "No hardcoded secrets detected!"
    fi

    # Check for missing env vars in current shell
    echo ""
    info "Checking environment variables..."
    local all_env_vars=$(jq -r '.mcpServers | to_entries[] | .value.env | to_entries[]? | .value | select(test("^\\$\\{")) | gsub("\\$\\{|\\}"; "")' "$CLAUDE_CONFIG" 2>/dev/null | sort -u)

    if [ -n "$all_env_vars" ]; then
        local missing_env=()
        while IFS= read -r env_var; do
            if [ -z "${!env_var}" ]; then
                missing_env+=("$env_var")
            fi
        done <<< "$all_env_vars"

        if [ ${#missing_env[@]} -gt 0 ]; then
            warning "Environment variables not set in current shell:"
            for var in "${missing_env[@]}"; do
                echo "  ✗ $var"
            done
            echo ""
            tip "Set in ~/.zshrc or ~/.bashrc for persistence"
        else
            success "All required environment variables are set!"
        fi
    fi
}

# Action: validate (NEW - validate config file)
action_validate() {
    info "Validating configuration file..."
    echo ""

    # Check JSON syntax
    if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
        error "Invalid JSON in $CONFIG_FILE"
    fi
    success "JSON syntax valid"

    # Check required fields in presets
    local preset_count=$(jq '.presets | length' "$CONFIG_FILE")
    success "Found $preset_count preset(s)"

    # Check required fields in servers
    local server_count=$(jq '.servers | length' "$CONFIG_FILE")
    success "Found $server_count server(s)"

    # Validate each server has required fields
    local servers=$(jq -r '.servers | keys[]' "$CONFIG_FILE")
    for server in $servers; do
        local has_command=$(jq -e ".servers[\"$server\"].command" "$CONFIG_FILE" &>/dev/null && echo "yes" || echo "no")
        if [ "$has_command" = "no" ]; then
            warning "Server '$server' missing 'command' field"
        fi
    done

    echo ""
    success "Configuration file is valid!"
}

# Action: config (NEW - edit MCP registry)
action_config() {
    info "MCP Server Registry Configuration"
    echo ""
    echo -e "${CYAN}Location:${NC} $CONFIG_FILE"
    echo ""
    echo -e "${MAGENTA}=== Instructions for Claude Code ===${NC}"
    echo ""
    echo "Please help me edit or add MCP servers to the registry at:"
    echo "  $CONFIG_FILE"
    echo ""
    echo "The registry contains:"
    echo "  • presets: Bundles of related servers"
    echo "  • servers: Individual MCP server configurations"
    echo "  • environments: Environment variable documentation"
    echo ""
    echo "Each server entry should have:"
    echo "  - name: Server identifier"
    echo "  - description: What the server does"
    echo "  - command: Executable to run (e.g., 'npx', 'python3')"
    echo "  - args: Array of arguments"
    echo "  - env: Environment variables (use \${VAR} references)"
    echo "  - aliases: Array of shortcut names (optional)"
    echo "  - notes: Additional information (optional)"
    echo ""
    echo "Example server entry:"
    cat << 'EOF'
  "my-server": {
    "name": "my-server",
    "description": "Brief description of what this server does",
    "command": "npx",
    "args": ["-y", "my-mcp-package"],
    "env": {
      "API_KEY": "${MY_API_KEY}"
    },
    "aliases": ["short", "alias"],
    "notes": "Get API key from https://example.com"
  }
EOF
    echo ""
    echo -e "${MAGENTA}=== Environment Variable Setup ===${NC}"
    echo ""
    echo "IMPORTANT: Claude Code does NOT automatically source ~/.zshrc or ~/.bashrc"
    echo ""
    echo -e "${CYAN}Step 1: Add to Shell Profile${NC}"
    echo "  echo 'export MY_API_KEY=\"your-api-key-here\"' >> ~/.zshrc"
    echo ""
    echo -e "${CYAN}Step 2: FULLY RESTART Claude Code${NC}"
    echo "  - Quit completely (Cmd+Q)"
    echo "  - Reopen Claude Code"
    echo "  - Note: Just restarting the terminal session is NOT enough!"
    echo ""
    echo -e "${CYAN}Quick Testing (Without Restart)${NC}"
    echo "  export MY_API_KEY=\"your-key\" && /mcps add my-server user"
    echo ""
    tip "After editing, run '/mcps validate' to check the configuration"
}

# Main execution
case "$ACTION" in
    list)
        action_list
        ;;
    info)
        [ -z "$TARGET" ] && error "Usage: mcp-act info <server-name|preset-name>"
        action_info "$TARGET"
        ;;
    add)
        [ -z "$TARGET" ] && error "Usage: mcp-act add <server-name|preset-name> [project|user]"
        action_add "$TARGET" "$SCOPE"
        ;;
    remove)
        [ -z "$TARGET" ] && error "Usage: mcp-act remove <server-name|preset-name>"
        action_remove "$TARGET"
        ;;
    audit)
        action_audit
        ;;
    validate)
        action_validate
        ;;
    config)
        action_config
        ;;
    help|--help|-h)
        echo "MCP Act - MCP Server Management with Presets"
        echo ""
        echo "Usage: mcp-act <action> [arguments]"
        echo ""
        echo "Actions:"
        echo "  list                            List all configured servers and presets"
        echo "  info <name>                     Show details about a server or preset"
        echo "  add <name> [project|user]       Add server(s) to configuration"
        echo "  remove <name>                   Remove server(s) from configuration"
        echo "  config                          Edit MCP registry (opens guidance for Claude Code)"
        echo "  audit                           Check for security issues"
        echo "  validate                        Validate configuration file"
        echo "  help                            Show this help message"
        echo ""
        echo "Examples:"
        echo "  mcp-act list"
        echo "  mcp-act add preset:webdev"
        echo "  mcp-act add gemini-cli user"
        echo "  mcp-act add gemini user          # Use alias (gemini → gemini-cli)"
        echo "  mcp-act info chrome              # Use alias (chrome → chrome-devtools)"
        echo "  mcp-act info preset:ui"
        echo "  mcp-act config                   # Edit MCP registry with Claude Code"
        echo "  mcp-act audit"
        echo "  mcp-act validate"
        echo ""
        echo "Note: You can use server aliases as shortcuts. Run 'mcp-act list' to see available aliases."
        ;;
    *)
        error "Unknown action: $ACTION\nRun 'mcp-act help' for usage"
        ;;
esac

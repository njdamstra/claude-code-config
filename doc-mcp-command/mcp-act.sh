#!/usr/bin/env bash

# MCP Act - MCP Server Management with Presets
# Usage: mcp-act.sh <action> [server-name|preset-name] [scope]

set -e

CONFIG_FILE="$HOME/.mcp-servers-config.json"
CLAUDE_CONFIG="$HOME/.claude.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; exit 1; }

# Check if jq is available
if ! command -v jq &> /dev/null; then
    error "jq is required but not installed. Install with: brew install jq"
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    error "Configuration file not found: $CONFIG_FILE"
fi

# Parse arguments
ACTION="${1:-list}"
TARGET="${2:-}"
SCOPE="${3:-project}"

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
        # It's a single server
        if jq -e ".servers[\"$target\"]" "$CONFIG_FILE" &>/dev/null; then
            echo "$target"
        else
            error "Server '$target' not found in configuration"
        fi
    fi
}

# Get server config
get_server_config() {
    local server_name="$1"
    jq -r ".servers[\"$server_name\"]" "$CONFIG_FILE"
}

# Build claude mcp add command
build_add_command() {
    local server_name="$1"
    local scope_flag="$2"
    
    local config=$(get_server_config "$server_name")
    local command=$(echo "$config" | jq -r '.command')
    local args=$(echo "$config" | jq -r '.args | join(" ")')
    local env=$(echo "$config" | jq -r '.env | to_entries[] | "-e \(.key)=\(.value)"' | tr '\n' ' ')
    
    echo "claude mcp add $server_name $scope_flag $command $args $env"
}

# Action: list
action_list() {
    info "Listing all configured MCP servers..."
    echo ""
    echo "=== Presets ==="
    jq -r '.presets | to_entries[] | "\(.key): \(.value.description) [\(.value.servers | join(", "))]"' "$CONFIG_FILE"
    echo ""
    echo "=== Individual Servers ==="
    jq -r '.servers | to_entries[] | "\(.key): \(.value.description)"' "$CONFIG_FILE"
    echo ""
    info "Active MCP servers:"
    claude mcp list || warning "Could not list active servers"
}

# Action: info
action_info() {
    local target="$1"
    
    if [[ "$target" == preset:* ]]; then
        local preset_name="${target#preset:}"
        info "Preset: $preset_name"
        jq ".presets[\"$preset_name\"]" "$CONFIG_FILE" || error "Preset not found"
    else
        info "Server: $target"
        jq ".servers[\"$target\"]" "$CONFIG_FILE" || error "Server not found"
    fi
}

# Action: add
action_add() {
    local target="$1"
    local scope="$2"
    
    local scope_flag=""
    if [ "$scope" = "user" ]; then
        scope_flag="-s user"
    fi
    
    info "Adding servers (scope: $scope)..."
    
    local servers=$(get_servers "$target")
    
    for server in $servers; do
        info "Adding: $server"
        
        local config=$(get_server_config "$server")
        local command=$(echo "$config" | jq -r '.command')
        local args=$(echo "$config" | jq -r '.args[]')
        local notes=$(echo "$config" | jq -r '.notes')
        
        # Build the full command
        local add_cmd="claude mcp add $server $scope_flag $command"
        for arg in $args; do
            add_cmd="$add_cmd $arg"
        done
        
        # Add environment variables if present
        local env_vars=$(echo "$config" | jq -r '.env | to_entries[]? | "-e \(.key)=\(.value)"')
        if [ -n "$env_vars" ]; then
            while IFS= read -r env_var; do
                # Check for unset environment variables (starting with ${)
                if [[ "$env_var" == *'${'* ]]; then
                    warning "Environment variable needed: $env_var"
                    warning "Notes: $notes"
                fi
                add_cmd="$add_cmd $env_var"
            done <<< "$env_vars"
        fi
        
        info "Executing: $add_cmd"
        eval "$add_cmd" && success "Added: $server" || warning "Failed to add: $server (may need manual edit)"
    done
    
    success "Completed! Run '/mcp' to verify servers are connected"
}

# Action: remove  
action_remove() {
    local target="$1"
    
    info "Removing servers..."
    
    local servers=$(get_servers "$target")
    
    for server in $servers; do
        info "Removing: $server"
        claude mcp remove "$server" && success "Removed: $server" || warning "Failed to remove: $server (known bug - try manual edit of ~/.claude.json)"
    done
}

# Action: enable/disable (edit config file)
action_toggle() {
    local target="$1"
    local enable="$2"  # true or false
    
    if [ ! -f "$CLAUDE_CONFIG" ]; then
        error "Claude config not found: $CLAUDE_CONFIG"
    fi
    
    warning "Enable/disable requires manual editing of $CLAUDE_CONFIG"
    warning "This feature will comment/uncomment servers in your config"
    info "Servers to toggle: $(get_servers "$target" | tr '\n' ' ')"
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
    enable|disable)
        [ -z "$TARGET" ] && error "Usage: mcp-act $ACTION <server-name|preset-name>"
        action_toggle "$TARGET" "$ACTION"
        ;;
    *)
        error "Unknown action: $ACTION\nValid actions: list, info, add, remove, enable, disable"
        ;;
esac

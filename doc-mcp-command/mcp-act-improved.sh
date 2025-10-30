#!/usr/bin/env bash

# MCP Act - MCP Server Management with Presets
# Version: 2.0 (Improved with validation and security)
# Usage: mcp-act <action> [server-name|preset-name] [scope]

set -e

CONFIG_FILE="$HOME/.mcp-servers-config.json"
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

# Validate environment variables for a server
validate_env_vars() {
    local server_name="$1"
    local config=$(get_server_config "$server_name")

    # Extract env vars from config
    local env_keys=$(echo "$config" | jq -r '.env | keys[]?' 2>/dev/null)

    if [ -z "$env_keys" ]; then
        # No env vars required
        return 0
    fi

    local missing_vars=()

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

    if [ ${#missing_vars[@]} -gt 0 ]; then
        warning "Server '$server_name' requires environment variables:"
        for missing_var in "${missing_vars[@]}"; do
            echo -e "  ${RED}✗${NC} $missing_var (not set)"
        done

        local notes=$(echo "$config" | jq -r '.notes // "No additional notes"')
        tip "$notes"

        echo ""
        info "Set with: export ${missing_vars[0]}='your-value-here'"
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
    jq -r '.servers | to_entries[] | "\(.key): \(.value.description)"' "$CONFIG_FILE"
    echo ""
    info "Active MCP servers:"
    claude mcp list 2>/dev/null || warning "Could not list active servers (is Claude Code running?)"
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
        info "Server: $target"
        echo ""
        jq ".servers[\"$target\"]" "$CONFIG_FILE" || error "Server not found"
    fi
}

# Action: add
action_add() {
    local target="$1"
    local scope="$2"

    local scope_flag=""
    if [ "$scope" = "user" ]; then
        scope_flag="--scope user"
    else
        scope_flag="--scope project"
    fi

    info "Adding servers (scope: $scope)..."
    echo ""

    local servers=$(get_servers "$target")
    local failed_servers=()
    local added_servers=()

    for server in $servers; do
        info "Processing: $server"

        # Validate environment variables first
        if ! validate_env_vars "$server"; then
            failed_servers+=("$server (missing env vars)")
            echo ""
            continue
        fi

        local config=$(get_server_config "$server")
        local command=$(echo "$config" | jq -r '.command')
        local args=$(echo "$config" | jq -r '.args[]')

        # Build the full command
        local add_cmd="claude mcp add $scope_flag $server $command"
        for arg in $args; do
            add_cmd="$add_cmd $arg"
        done

        # Add environment variables if present
        local env_vars=$(echo "$config" | jq -r '.env | to_entries[]? | "-e \(.key)=\(.value)"')
        if [ -n "$env_vars" ]; then
            while IFS= read -r env_var; do
                add_cmd="$add_cmd $env_var"
            done <<< "$env_vars"
        fi

        info "Executing: $add_cmd"
        if eval "$add_cmd" 2>/dev/null; then
            success "Added: $server"
            added_servers+=("$server")
        else
            warning "Failed to add: $server (try manual edit of ~/.claude.json)"
            failed_servers+=("$server (command failed)")
        fi
        echo ""
    done

    # Summary
    echo -e "${MAGENTA}=== Summary ===${NC}"
    if [ ${#added_servers[@]} -gt 0 ]; then
        success "Successfully added ${#added_servers[@]} server(s):"
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
    tip "Run 'claude mcp list' or '/mcp' to verify servers are connected"
}

# Action: remove
action_remove() {
    local target="$1"

    info "Removing servers..."
    echo ""

    local servers=$(get_servers "$target")

    for server in $servers; do
        info "Removing: $server"
        if claude mcp remove "$server" 2>/dev/null; then
            success "Removed: $server"
        else
            warning "Failed to remove: $server"
            tip "Known bug with 'claude mcp remove' - try manual edit of ~/.claude.json"
        fi
    done

    echo ""
    tip "Verify with: claude mcp list"
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
        echo "  audit                           Check for security issues"
        echo "  validate                        Validate configuration file"
        echo "  help                            Show this help message"
        echo ""
        echo "Examples:"
        echo "  mcp-act list"
        echo "  mcp-act add preset:webdev"
        echo "  mcp-act add gemini-cli user"
        echo "  mcp-act info preset:ui"
        echo "  mcp-act audit"
        ;;
    *)
        error "Unknown action: $ACTION\nRun 'mcp-act help' for usage"
        ;;
esac

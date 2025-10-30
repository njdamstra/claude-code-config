#!/bin/bash

# Claude Code Tools Discovery Script
# Efficiently lists all available tools in the environment
# Usage: list-tools.sh [category]
#   Categories: system, mcps, skills, agents, commands, hooks, plugins, styles, all

CATEGORY="${1:-all}"

# Color codes (optional, remove if causing issues)
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Header
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              CLAUDE CODE TOOLS DIRECTORY                       ║"
echo "║              Current Environment Capabilities                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Counters
SKILL_COUNT=0
AGENT_COUNT=0
CMD_COUNT=0
HOOK_COUNT=0
STYLE_COUNT=3  # Built-in styles
MCP_COUNT=0

# Function: List System Commands
list_system() {
    echo "📋 BUILT-IN SYSTEM COMMANDS"
    echo "────────────────────────────────────────────────────────────────"
    echo "Core Claude Code slash commands:"
    echo ""
    echo "Session Management:"
    echo "  /help         - Show all available slash commands"
    echo "  /clear        - Clear conversation history"
    echo "  /context      - View current context usage"
    echo "  /compact      - Compact conversation history"
    echo "  /checkpoint   - Create conversation checkpoint"
    echo "  /resume       - Resume previous session"
    echo ""
    echo "Project & Configuration:"
    echo "  /init         - Initialize new project context"
    echo "  /model        - Switch between Claude models"
    echo "  /permissions  - View/modify tool permissions"
    echo "  /hooks        - Configure lifecycle hooks interactively"
    echo ""
    echo "Tool Management:"
    echo "  /agents       - Manage subagents"
    echo "  /skills       - Manage agent skills"
    echo "  /plugin       - Manage plugins"
    echo "  /mcp          - Manage MCP servers"
    echo ""
    echo "Run /help for complete list and details"
    echo ""
}

# Function: List MCP Servers
list_mcps() {
    echo "🔌 MCP SERVERS"
    echo "────────────────────────────────────────────────────────────────"

    local found=0

    # Check user settings
    if [ -f ~/.claude/settings.json ]; then
        local mcp_data=$(grep -A 50 "mcpServers" ~/.claude/settings.json 2>/dev/null)
        if [ -n "$mcp_data" ]; then
            local servers=$(echo "$mcp_data" | grep -E '"[a-zA-Z0-9_-]+":\s*{' | sed 's/.*"\([^"]*\)".*/\1/')
            if [ -n "$servers" ]; then
                found=1
                echo "Found MCP server(s):"
                echo ""
                while IFS= read -r server; do
                    [ -z "$server" ] && continue
                    MCP_COUNT=$((MCP_COUNT + 1))
                    echo "✓ $server (user)"
                    echo "  Status: Configured"
                    echo ""
                done <<< "$servers"
            fi
        fi
    fi

    if [ $found -eq 0 ]; then
        echo "No MCP servers currently configured"
        echo ""
    fi

    echo "💡 Add MCP servers: claude mcp add <name> [args]"
    echo "📖 Browse servers: https://github.com/modelcontextprotocol/servers"
    echo ""
}

# Function: List Agent Skills
list_skills() {
    echo "🎯 AGENT SKILLS"
    echo "────────────────────────────────────────────────────────────────"

    # User skills
    if [ -d ~/.claude/skills ]; then
        for skill_dir in ~/.claude/skills/*/; do
            [ ! -d "$skill_dir" ] && continue

            local skill_name=$(basename "$skill_dir")
            SKILL_COUNT=$((SKILL_COUNT + 1))

            echo "📦 $skill_name (user)"

            if [ -f "$skill_dir/SKILL.md" ]; then
                local desc=$(grep "^description:" "$skill_dir/SKILL.md" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-70)
                [ -n "$desc" ] && echo "   $desc..."
            fi
            echo ""
        done
    fi

    # Project skills
    if [ -d .claude/skills ]; then
        for skill_dir in .claude/skills/*/; do
            [ ! -d "$skill_dir" ] && continue

            local skill_name=$(basename "$skill_dir")
            SKILL_COUNT=$((SKILL_COUNT + 1))

            echo "📦 $skill_name (project)"

            if [ -f "$skill_dir/SKILL.md" ]; then
                local desc=$(grep "^description:" "$skill_dir/SKILL.md" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-70)
                [ -n "$desc" ] && echo "   $desc..."
            fi
            echo ""
        done
    fi

    echo "Total: $SKILL_COUNT skills"
    echo ""
    echo "💡 Create skill: mkdir -p ~/.claude/skills/myskill && touch ~/.claude/skills/myskill/SKILL.md"
    echo "📖 Skill docs: https://docs.claude.com/en/docs/claude-code/skills"
    echo ""
}

# Function: List Subagents
list_agents() {
    echo "🤖 SUBAGENTS"
    echo "────────────────────────────────────────────────────────────────"

    # User agents
    if [ -d ~/.claude/agents ]; then
        for agent_file in ~/.claude/agents/*.md; do
            [ ! -f "$agent_file" ] && continue

            local agent_name=$(basename "$agent_file" .md)
            AGENT_COUNT=$((AGENT_COUNT + 1))

            echo "👤 $agent_name (user)"

            local desc=$(grep "^description:" "$agent_file" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-70)
            [ -n "$desc" ] && echo "   $desc..."
            echo ""
        done
    fi

    # Project agents
    if [ -d .claude/agents ]; then
        for agent_file in .claude/agents/*.md; do
            [ ! -f "$agent_file" ] && continue

            local agent_name=$(basename "$agent_file" .md)
            AGENT_COUNT=$((AGENT_COUNT + 1))

            echo "👤 $agent_name (project)"

            local desc=$(grep "^description:" "$agent_file" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-70)
            [ -n "$desc" ] && echo "   $desc..."
            echo ""
        done
    fi

    echo "Total: $AGENT_COUNT subagents"
    echo ""
    echo "💡 Create agent: Create .md file in .claude/agents/ or ~/.claude/agents/"
    echo "📖 Agent docs: https://docs.claude.com/en/docs/claude-code/agents"
    echo ""
}

# Function: List Custom Slash Commands
list_commands() {
    echo "⚡ CUSTOM SLASH COMMANDS"
    echo "────────────────────────────────────────────────────────────────"

    # User commands
    if [ -d ~/.claude/commands ]; then
        for cmd_file in ~/.claude/commands/*.md; do
            [ ! -f "$cmd_file" ] && continue

            local cmd_name=$(basename "$cmd_file" .md)
            CMD_COUNT=$((CMD_COUNT + 1))

            echo "/$cmd_name (user)"

            local desc=$(grep "^description:" "$cmd_file" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-65)
            [ -n "$desc" ] && echo "  $desc..."

            local args=$(grep "^argument-hint:" "$cmd_file" 2>/dev/null | head -1 | sed 's/^argument-hint: *//')
            [ -n "$args" ] && echo "  Arguments: $args"
            echo ""
        done
    fi

    # Project commands
    if [ -d .claude/commands ]; then
        for cmd_file in .claude/commands/*.md; do
            [ ! -f "$cmd_file" ] && continue

            local cmd_name=$(basename "$cmd_file" .md)
            CMD_COUNT=$((CMD_COUNT + 1))

            echo "/$cmd_name (project)"

            local desc=$(grep "^description:" "$cmd_file" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-65)
            [ -n "$desc" ] && echo "  $desc..."

            local args=$(grep "^argument-hint:" "$cmd_file" 2>/dev/null | head -1 | sed 's/^argument-hint: *//')
            [ -n "$args" ] && echo "  Arguments: $args"
            echo ""
        done
    fi

    echo "Total: $CMD_COUNT commands"
    echo ""
    echo "💡 Create command: echo '# My Command' > ~/.claude/commands/mycommand.md"
    echo "📖 Command docs: https://docs.claude.com/en/docs/claude-code/slash-commands"
    echo ""
}

# Function: List Hooks
list_hooks() {
    echo "🪝 LIFECYCLE HOOKS"
    echo "────────────────────────────────────────────────────────────────"

    local found=0

    # Check user settings
    if [ -f ~/.claude/settings.json ]; then
        local hooks_data=$(grep -A 100 '"hooks"' ~/.claude/settings.json 2>/dev/null)
        if [ -n "$hooks_data" ]; then
            local pre_count=$(echo "$hooks_data" | grep -c "PreToolUse" || echo "0")
            local post_count=$(echo "$hooks_data" | grep -c "PostToolUse" || echo "0")

            if [ "$pre_count" -gt 0 ] || [ "$post_count" -gt 0 ]; then
                found=1
                echo "Hook Types Configured:"
                [ "$pre_count" -gt 0 ] && echo "  PreToolUse:  $pre_count hook(s)" && HOOK_COUNT=$((HOOK_COUNT + pre_count))
                [ "$post_count" -gt 0 ] && echo "  PostToolUse: $post_count hook(s)" && HOOK_COUNT=$((HOOK_COUNT + post_count))
                echo ""
            fi
        fi
    fi

    if [ $found -eq 0 ]; then
        echo "No lifecycle hooks currently configured"
        echo ""
    fi

    echo "Total: $HOOK_COUNT hooks"
    echo ""
    echo "💡 Configure hooks: Edit settings.json or use interactive setup"
    echo "📖 Hook docs: https://docs.claude.com/en/docs/claude-code/hooks"
    echo ""
}

# Function: List Output Styles
list_styles() {
    echo "🎨 OUTPUT STYLES"
    echo "────────────────────────────────────────────────────────────────"

    echo "Built-in Styles:"
    echo "  - efficient       (Fast, direct coding assistant)"
    echo "  - explanatory     (Teaching mode with insights)"
    echo "  - concise         (Minimal, to-the-point responses)"
    echo ""

    # User styles
    if [ -d ~/.claude/output-styles ]; then
        local has_custom=0
        for style_file in ~/.claude/output-styles/*.md; do
            [ ! -f "$style_file" ] && continue

            if [ $has_custom -eq 0 ]; then
                echo "Custom User Styles:"
                has_custom=1
            fi

            local style_name=$(basename "$style_file" .md)
            STYLE_COUNT=$((STYLE_COUNT + 1))

            echo "  📝 $style_name (user)"

            local desc=$(grep "^description:" "$style_file" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-65)
            [ -n "$desc" ] && echo "     $desc..."
        done
        [ $has_custom -eq 1 ] && echo ""
    fi

    # Project styles
    if [ -d .claude/output-styles ]; then
        local has_custom=0
        for style_file in .claude/output-styles/*.md; do
            [ ! -f "$style_file" ] && continue

            if [ $has_custom -eq 0 ]; then
                echo "Custom Project Styles:"
                has_custom=1
            fi

            local style_name=$(basename "$style_file" .md)
            STYLE_COUNT=$((STYLE_COUNT + 1))

            echo "  📝 $style_name (project)"

            local desc=$(grep "^description:" "$style_file" 2>/dev/null | head -1 | sed 's/^description: *//' | cut -c1-65)
            [ -n "$desc" ] && echo "     $desc..."
        done
        [ $has_custom -eq 1 ] && echo ""
    fi

    echo "Total: $STYLE_COUNT styles"
    echo ""
    echo "💡 Create style: Create .md file in .claude/output-styles/"
    echo ""
}

# Function: Display Summary
show_summary() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                         SUMMARY                                 ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""

    local total=$((15 + MCP_COUNT + SKILL_COUNT + AGENT_COUNT + CMD_COUNT + HOOK_COUNT + STYLE_COUNT))

    echo "Total Capabilities: $total items"
    echo "├─ Built-in Commands: 15+"
    echo "├─ MCP Servers: $MCP_COUNT"
    echo "├─ Agent Skills: $SKILL_COUNT"
    echo "├─ Subagents: $AGENT_COUNT"
    echo "├─ Slash Commands: $CMD_COUNT"
    echo "├─ Hooks: $HOOK_COUNT"
    echo "├─ Plugins: 0"
    echo "└─ Output Styles: $STYLE_COUNT"
    echo ""
    echo "📖 Full Documentation: https://docs.claude.com/en/docs/claude-code/"
    echo "💬 Community: https://github.com/hesreallyhim/awesome-claude-code"
    echo ""
}

# Main execution logic
case "$CATEGORY" in
    system)
        list_system
        ;;
    mcps)
        list_mcps
        ;;
    skills)
        list_skills
        ;;
    agents)
        list_agents
        ;;
    commands)
        list_commands
        ;;
    hooks)
        list_hooks
        ;;
    styles)
        list_styles
        ;;
    plugins)
        echo "🔌 INSTALLED PLUGINS"
        echo "────────────────────────────────────────────────────────────────"
        echo "No plugins currently installed"
        echo ""
        echo "💡 Install plugin: /plugin install <name>"
        echo "📖 Plugin docs: https://docs.claude.com/en/docs/claude-code/plugins"
        echo ""
        ;;
    all|*)
        list_system
        list_mcps
        list_skills
        list_agents
        list_commands
        list_hooks
        list_styles
        show_summary
        ;;
esac

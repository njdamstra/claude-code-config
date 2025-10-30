#!/bin/bash

# Claude Code /tools Command Installer
# Installs the /tools slash command for discovering all available tools

set -e

echo "🔧 Claude Code /tools Command Installer"
echo "========================================"
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if tools.md exists
if [ ! -f "$SCRIPT_DIR/tools.md" ]; then
    echo "❌ Error: tools.md not found in current directory"
    exit 1
fi

# Ask user for installation scope
echo -e "${BLUE}Where would you like to install the /tools command?${NC}"
echo ""
echo "1. Personal (user-level) - Available in all projects"
echo "   Location: ~/.claude/commands/"
echo ""
echo "2. Project (current directory) - Available only in this project"
echo "   Location: ./.claude/commands/"
echo ""
echo "3. Both"
echo ""
read -p "Enter your choice (1, 2, or 3): " choice

install_user=false
install_project=false

case $choice in
    1)
        install_user=true
        ;;
    2)
        install_project=true
        ;;
    3)
        install_user=true
        install_project=true
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

# Install to user directory
if [ "$install_user" = true ]; then
    echo ""
    echo -e "${YELLOW}Installing to user directory...${NC}"
    
    # Create directory if it doesn't exist
    mkdir -p ~/.claude/commands
    
    # Copy the file
    cp "$SCRIPT_DIR/tools.md" ~/.claude/commands/tools.md
    
    echo -e "${GREEN}✓ Installed to ~/.claude/commands/tools.md${NC}"
fi

# Install to project directory
if [ "$install_project" = true ]; then
    echo ""
    echo -e "${YELLOW}Installing to project directory...${NC}"
    
    # Create directory if it doesn't exist
    mkdir -p .claude/commands
    
    # Copy the file
    cp "$SCRIPT_DIR/tools.md" .claude/commands/tools.md
    
    echo -e "${GREEN}✓ Installed to ./.claude/commands/tools.md${NC}"
    
    # Ask about git
    if [ -d .git ]; then
        echo ""
        read -p "Would you like to commit this to git? (y/n): " commit_choice
        if [ "$commit_choice" = "y" ] || [ "$commit_choice" = "Y" ]; then
            git add .claude/commands/tools.md
            git commit -m "Add /tools discovery command for Claude Code"
            echo -e "${GREEN}✓ Committed to git${NC}"
        fi
    fi
fi

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo "  /tools              List all available tools"
echo "  /tools mcps         List MCP servers"
echo "  /tools skills       List Agent Skills"
echo "  /tools agents       List Subagents"
echo "  /tools commands     List Slash Commands"
echo "  /tools hooks        List Hooks"
echo "  /tools plugins      List Plugins"
echo "  /tools styles       List Output Styles"
echo "  /tools system       List System Commands"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Start or restart Claude Code"
echo "2. Type /tools to see all your available tools"
echo "3. Use /help to verify the command is loaded"
echo ""
echo "📚 For more information, see README.md"

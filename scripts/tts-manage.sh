#!/bin/bash
# TTS Management Script
# Manages text-to-speech configuration for Claude Code hooks

set -euo pipefail

# Configuration paths
SETTINGS_JSON="$HOME/.claude/settings.json"
STOP_HOOK="$HOME/.claude/hooks/stop.py"
NOTIFICATION_HOOK="$HOME/.claude/hooks/notification.py"
SUBAGENT_HOOK="$HOME/.claude/hooks/subagent_stop.py"
SHELL_RC="$HOME/.zshrc"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

check_dependencies() {
    if ! command -v jq &>/dev/null; then
        echo -e "${RED}❌ Error: jq is required${NC}"
        echo "Install with: brew install jq"
        exit 1
    fi
}

get_current_provider() {
    # Check environment variables to determine active provider
    if [ -n "${ELEVENLABS_API_KEY:-}" ]; then
        echo "ElevenLabs"
    elif [ -n "${OPENAI_API_KEY:-}" ]; then
        echo "OpenAI"
    else
        echo "pyttsx3 (offline)"
    fi
}

get_provider_details() {
    local provider=$(get_current_provider)

    case "$provider" in
        "OpenAI")
            echo "  Model: gpt-4o-mini-tts"
            echo "  Voice: nova"
            echo "  Tone: Cheerful, positive yet professional"
            ;;
        "ElevenLabs")
            echo "  Model: eleven_turbo_v2_5"
            echo "  Voice: Custom (configured)"
            echo "  Quality: Premium"
            ;;
        "pyttsx3 (offline)")
            echo "  Engine: System TTS"
            echo "  Rate: 180 words/min"
            echo "  Volume: 80%"
            ;;
    esac
}

check_hook_enabled() {
    local hook_name="$1"
    local command=$(jq -r ".hooks.${hook_name}[0].hooks[0].command" "$SETTINGS_JSON" 2>/dev/null || echo "")

    if echo "$command" | grep -q -- "--notify"; then
        echo "ENABLED"
    else
        echo "DISABLED"
    fi
}

get_stop_mode() {
    # Check which function is active in stop.py
    if grep -q "^[[:space:]]*announce_completion_with_transcript" "$STOP_HOOK"; then
        echo "transcript"
    else
        echo "static"
    fi
}

# ============================================================================
# Status Command
# ============================================================================

show_status() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║  TTS CONFIGURATION STATUS             ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""

    local provider=$(get_current_provider)
    echo -e "${BLUE}PROVIDER:${NC} $provider"
    get_provider_details
    echo ""

    echo -e "${BLUE}HOOKS:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local stop_status=$(check_hook_enabled "Stop")
    local stop_mode=$(get_stop_mode)
    if [ "$stop_status" = "ENABLED" ]; then
        echo -e "${GREEN}✅${NC} Stop           ${GREEN}ENABLED${NC}  ($stop_mode mode)"
    else
        echo -e "${RED}❌${NC} Stop           ${RED}DISABLED${NC}"
    fi

    local notif_status=$(check_hook_enabled "Notification")
    if [ "$notif_status" = "ENABLED" ]; then
        echo -e "${GREEN}✅${NC} Notification   ${GREEN}ENABLED${NC}  (static message)"
    else
        echo -e "${RED}❌${NC} Notification   ${RED}DISABLED${NC}"
    fi

    local subagent_status=$(check_hook_enabled "SubagentStop")
    if [ "$subagent_status" = "ENABLED" ]; then
        echo -e "${GREEN}✅${NC} SubagentStop   ${GREEN}ENABLED${NC}  (static message)"
    else
        echo -e "${RED}❌${NC} SubagentStop   ${RED}DISABLED${NC}"
    fi

    echo ""
    echo -e "${BLUE}ENVIRONMENT VARIABLES:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ -n "${OPENAI_API_KEY:-}" ]; then
        echo -e "${GREEN}✅${NC} OPENAI_API_KEY      Set"
    else
        echo -e "${RED}❌${NC} OPENAI_API_KEY      Not set"
    fi

    if [ -n "${ELEVENLABS_API_KEY:-}" ]; then
        echo -e "${GREEN}✅${NC} ELEVENLABS_API_KEY  Set"
    else
        echo -e "${RED}❌${NC} ELEVENLABS_API_KEY  Not set"
    fi

    if [ -n "${ENGINEER_NAME:-}" ]; then
        echo -e "${GREEN}✅${NC} ENGINEER_NAME       ${ENGINEER_NAME}"
    else
        echo -e "${YELLOW}⚠️${NC}  ENGINEER_NAME       Not set"
    fi

    echo ""
}

# ============================================================================
# Enable/Disable Commands
# ============================================================================

enable_hook_tts() {
    local hook_name="$1"
    local display_name="$2"

    # Backup settings.json
    cp "$SETTINGS_JSON" "$SETTINGS_JSON.backup"

    # Get current command
    local current_command=$(jq -r ".hooks.${hook_name}[0].hooks[0].command" "$SETTINGS_JSON")

    # Check if already has --notify
    if echo "$current_command" | grep -q -- "--notify"; then
        echo -e "${YELLOW}⚠️  ${display_name} TTS already enabled${NC}"
        return 0
    fi

    # Add --notify flag
    local new_command="${current_command} --notify"
    jq ".hooks.${hook_name}[0].hooks[0].command = \"${new_command}\"" "$SETTINGS_JSON" > "$SETTINGS_JSON.tmp"
    mv "$SETTINGS_JSON.tmp" "$SETTINGS_JSON"

    echo -e "${GREEN}✅${NC} ${display_name} TTS enabled"
}

disable_hook_tts() {
    local hook_name="$1"
    local display_name="$2"

    # Backup settings.json
    cp "$SETTINGS_JSON" "$SETTINGS_JSON.backup"

    # Get current command
    local current_command=$(jq -r ".hooks.${hook_name}[0].hooks[0].command" "$SETTINGS_JSON")

    # Check if doesn't have --notify
    if ! echo "$current_command" | grep -q -- "--notify"; then
        echo -e "${YELLOW}⚠️  ${display_name} TTS already disabled${NC}"
        return 0
    fi

    # Remove --notify flag
    local new_command=$(echo "$current_command" | sed 's/ --notify//')
    jq ".hooks.${hook_name}[0].hooks[0].command = \"${new_command}\"" "$SETTINGS_JSON" > "$SETTINGS_JSON.tmp"
    mv "$SETTINGS_JSON.tmp" "$SETTINGS_JSON"

    echo -e "${GREEN}✅${NC} ${display_name} TTS disabled"
}

enable_all() {
    echo ""
    echo "🔊 Enabling TTS for all hooks..."
    echo ""

    enable_hook_tts "Stop" "Stop"
    enable_hook_tts "Notification" "Notification"
    enable_hook_tts "SubagentStop" "SubagentStop"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}✅ TTS enabled for all hooks!${NC}"
    echo ""
    local provider=$(get_current_provider)
    echo "Active provider: $provider"
    echo "Run '/tts status' to see full configuration"
    echo ""
}

disable_all() {
    echo ""
    echo "🔇 Disabling TTS for all hooks..."
    echo ""

    disable_hook_tts "Stop" "Stop"
    disable_hook_tts "Notification" "Notification"
    disable_hook_tts "SubagentStop" "SubagentStop"

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}✅ TTS disabled for all hooks${NC}"
    echo ""
    echo "Hooks will still run but won't announce audio"
    echo "To re-enable: /tts enable"
    echo ""
}

# ============================================================================
# Mode Toggle (Transcript vs Static)
# ============================================================================

set_mode_transcript() {
    local current_mode=$(get_stop_mode)

    if [ "$current_mode" = "transcript" ]; then
        echo -e "${YELLOW}⚠️  Stop hook already in TRANSCRIPT mode${NC}"
        return 0
    fi

    echo ""
    echo "🔄 Switching Stop hook to transcript mode..."
    echo ""

    # Use Edit tool pattern: comment one line, uncomment another
    # Find the lines and swap comments
    sed -i.bak \
        -e 's/^\([[:space:]]*\)announce_completion_with_transcript/\1announce_completion_with_transcript/' \
        -e 's/^\([[:space:]]*\)# announce_completion()/\1announce_completion()/' \
        -e 's/^\([[:space:]]*\)announce_completion()/\1# announce_completion()/' \
        "$STOP_HOOK"

    # Now uncomment the transcript line
    sed -i '' \
        -e 's/^\([[:space:]]*\)# announce_completion_with_transcript/\1announce_completion_with_transcript/' \
        "$STOP_HOOK"

    echo -e "${GREEN}✅ Mode changed to TRANSCRIPT${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "What this means:"
    echo "• Stop hook will now read the full transcript"
    echo "• LLM will summarize your response to 2-3 sentences"
    echo "• TTS will speak the summary instead of 'Work complete!'"
    echo ""
    echo "Example: 'I analyzed the TTS configuration system,"
    echo "mapped all settings, and created a comprehensive"
    echo "research report with implementation recommendations.'"
    echo ""
    echo "To revert: /tts mode static"
    echo ""
}

set_mode_static() {
    local current_mode=$(get_stop_mode)

    if [ "$current_mode" = "static" ]; then
        echo -e "${YELLOW}⚠️  Stop hook already in STATIC mode${NC}"
        return 0
    fi

    echo ""
    echo "🔄 Switching Stop hook to static mode..."
    echo ""

    # Comment transcript line, uncomment static line
    sed -i.bak \
        -e 's/^\([[:space:]]*\)announce_completion_with_transcript/\1# announce_completion_with_transcript/' \
        -e 's/^\([[:space:]]*\)# announce_completion()/\1announce_completion()/' \
        "$STOP_HOOK"

    echo -e "${GREEN}✅ Mode changed to STATIC${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "What this means:"
    echo "• Stop hook will use static completion messages"
    echo "• TTS will say 'Work complete!' or similar"
    echo "• Faster (no transcript reading or summarization)"
    echo ""
    echo "To enable transcript mode: /tts mode transcript"
    echo ""
}

# ============================================================================
# Provider Info
# ============================================================================

show_provider_info() {
    local provider=$(get_current_provider)

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${BLUE}ACTIVE PROVIDER:${NC} $provider"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    get_provider_details
    echo ""

    echo -e "${BLUE}PROVIDER PRIORITY:${NC}"
    echo "1. ElevenLabs (if ELEVENLABS_API_KEY set)"
    echo "2. OpenAI (if OPENAI_API_KEY set)"
    echo "3. pyttsx3 (offline fallback)"
    echo ""

    echo -e "${BLUE}TO CHANGE PROVIDER:${NC}"
    if [ "$provider" = "pyttsx3 (offline)" ]; then
        echo "Set an API key in ~/.zshrc:"
        echo "  export OPENAI_API_KEY='your_key_here'"
        echo "  export ELEVENLABS_API_KEY='your_key_here'"
        echo "Then: source ~/.zshrc"
    elif [ "$provider" = "OpenAI" ]; then
        echo "To use ElevenLabs (higher priority):"
        echo "  export ELEVENLABS_API_KEY='your_key_here' in ~/.zshrc"
        echo "  Then: source ~/.zshrc"
        echo ""
        echo "To use pyttsx3 (offline):"
        echo "  Unset OPENAI_API_KEY (not recommended)"
    else
        echo "Current provider is highest priority"
        echo "To downgrade, remove ELEVENLABS_API_KEY from ~/.zshrc"
    fi
    echo ""
}

# ============================================================================
# Test TTS
# ============================================================================

test_tts() {
    local message="${1:-Testing TTS output}"
    local provider=$(get_current_provider)

    echo ""
    echo "🔊 Testing TTS with message: \"$message\""
    echo "Provider: $provider"
    echo ""

    # Determine which TTS script to use
    local tts_script=""
    if [ -n "${ELEVENLABS_API_KEY:-}" ]; then
        tts_script="$HOME/.claude/hooks/utils/tts/elevenlabs_tts.py"
    elif [ -n "${OPENAI_API_KEY:-}" ]; then
        tts_script="$HOME/.claude/hooks/utils/tts/openai_tts.py"
    else
        tts_script="$HOME/.claude/hooks/utils/tts/pyttsx3_tts.py"
    fi

    if [ ! -f "$tts_script" ]; then
        echo -e "${RED}❌ Error: TTS script not found: $tts_script${NC}"
        exit 1
    fi

    # Run TTS
    if uv run "$tts_script" "$message"; then
        echo -e "${GREEN}✅ TTS test complete${NC}"
    else
        echo -e "${RED}❌ TTS test failed${NC}"
        echo "Check that dependencies are installed and API keys are valid"
    fi
    echo ""
}

# ============================================================================
# Help
# ============================================================================

show_help() {
    cat << 'EOF'
TTS Management - Control text-to-speech configuration

USAGE:
  /tts <command> [options]

COMMANDS:
  status                    Show current TTS configuration

  enable                    Enable TTS for all hooks
  disable                   Disable TTS for all hooks

  hook stop on|off          Enable/disable Stop hook TTS
  hook notification on|off  Enable/disable Notification hook TTS
  hook subagent on|off      Enable/disable SubagentStop hook TTS

  mode transcript           Use transcript summaries (Stop hook)
  mode static               Use static messages (Stop hook)

  provider                  Show current TTS provider info

  test "message"            Test TTS with custom message

  help                      Show this help message

EXAMPLES:
  /tts status               # View current configuration
  /tts enable               # Enable all TTS hooks
  /tts hook stop off        # Disable only Stop hook TTS
  /tts mode transcript      # Switch to transcript summaries
  /tts test "Hello world"   # Test TTS output

CURRENT STATUS:
EOF
    show_status
}

# ============================================================================
# Main Command Handler
# ============================================================================

main() {
    check_dependencies

    case "${1:-}" in
        status|"")
            show_status
            ;;
        enable)
            enable_all
            ;;
        disable)
            disable_all
            ;;
        hook)
            case "${2:-}" in
                stop)
                    case "${3:-}" in
                        on|enable) enable_hook_tts "Stop" "Stop" ;;
                        off|disable) disable_hook_tts "Stop" "Stop" ;;
                        *) echo "Usage: /tts hook stop on|off"; exit 1 ;;
                    esac
                    ;;
                notification)
                    case "${3:-}" in
                        on|enable) enable_hook_tts "Notification" "Notification" ;;
                        off|disable) disable_hook_tts "Notification" "Notification" ;;
                        *) echo "Usage: /tts hook notification on|off"; exit 1 ;;
                    esac
                    ;;
                subagent)
                    case "${3:-}" in
                        on|enable) enable_hook_tts "SubagentStop" "SubagentStop" ;;
                        off|disable) disable_hook_tts "SubagentStop" "SubagentStop" ;;
                        *) echo "Usage: /tts hook subagent on|off"; exit 1 ;;
                    esac
                    ;;
                *)
                    echo "Usage: /tts hook <stop|notification|subagent> <on|off>"
                    exit 1
                    ;;
            esac
            ;;
        mode)
            case "${2:-}" in
                transcript) set_mode_transcript ;;
                static) set_mode_static ;;
                *) echo "Usage: /tts mode <transcript|static>"; exit 1 ;;
            esac
            ;;
        provider)
            show_provider_info
            ;;
        test)
            test_tts "${2:-Testing TTS output}"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}Error: Unknown command '${1}'${NC}"
            echo "Run '/tts help' for usage information"
            exit 1
            ;;
    esac
}

main "$@"

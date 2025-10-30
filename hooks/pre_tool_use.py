#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# ///

import json
import sys
import re
from pathlib import Path

def is_dangerous_rm_command(command):
    """
    Comprehensive detection of dangerous rm commands.
    Matches various forms of rm -rf and similar destructive patterns.
    """
    # Normalize command by removing extra spaces and converting to lowercase
    normalized = ' '.join(command.lower().split())
    
    # Pattern 1: Standard rm -rf variations
    patterns = [
        r'\brm\s+.*-[a-z]*r[a-z]*f',  # rm -rf, rm -fr, rm -Rf, etc.
        r'\brm\s+.*-[a-z]*f[a-z]*r',  # rm -fr variations
        r'\brm\s+--recursive\s+--force',  # rm --recursive --force
        r'\brm\s+--force\s+--recursive',  # rm --force --recursive
        r'\brm\s+-r\s+.*-f',  # rm -r ... -f
        r'\brm\s+-f\s+.*-r',  # rm -f ... -r
    ]
    
    # Check for dangerous patterns
    for pattern in patterns:
        if re.search(pattern, normalized):
            return True
    
    # Pattern 2: Check for rm with recursive flag targeting dangerous paths
    dangerous_paths = [
        r'/',           # Root directory
        r'/\*',         # Root with wildcard
        r'~',           # Home directory
        r'~/',          # Home directory path
        r'\$HOME',      # Home environment variable
        r'\.\.',        # Parent directory references
        r'\*',          # Wildcards in general rm -rf context
        r'\.',          # Current directory
        r'\.\s*$',      # Current directory at end of command
    ]
    
    if re.search(r'\brm\s+.*-[a-z]*r', normalized):  # If rm has recursive flag
        for path in dangerous_paths:
            if re.search(path, normalized):
                return True
    
    return False

def is_env_file_access(tool_name, tool_input):
    """
    Check if any tool is trying to access .env files containing sensitive data.
    """
    if tool_name in ['Read', 'Edit', 'MultiEdit', 'Write', 'Bash']:
        # Check file paths for file-based tools
        if tool_name in ['Read', 'Edit', 'MultiEdit', 'Write']:
            file_path = tool_input.get('file_path', '')
            if '.env' in file_path and not file_path.endswith('.env.sample'):
                return True

        # Check bash commands for .env file access
        elif tool_name == 'Bash':
            command = tool_input.get('command', '')
            # Pattern to detect .env file access (but allow .env.sample)
            env_patterns = [
                r'\b\.env\b(?!\.sample)',  # .env but not .env.sample
                r'cat\s+.*\.env\b(?!\.sample)',  # cat .env
                r'echo\s+.*>\s*\.env\b(?!\.sample)',  # echo > .env
                r'touch\s+.*\.env\b(?!\.sample)',  # touch .env
                r'cp\s+.*\.env\b(?!\.sample)',  # cp .env
                r'mv\s+.*\.env\b(?!\.sample)',  # mv .env
            ]

            for pattern in env_patterns:
                if re.search(pattern, command):
                    return True

    return False

def is_subagent():
    """Check if running in subagent context by looking for flag file."""
    return Path('.claude_in_subtask.flag').exists()

def suggest_file_size_optimization(tool_name, tool_input):
    """
    Suggest file size optimization strategies (non-blocking).
    Returns suggestion message or None.
    Main agent: 500 line suggestion → Explore subagent
    Subagent: 10,000 line suggestion → Gemini MCP
    """
    if tool_name != 'Read':
        return None

    file_path = tool_input.get('file_path', '')
    if not file_path or not Path(file_path).exists():
        return None

    try:
        # Count lines in file
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            line_count = sum(1 for _ in f)

        # Suggest optimizations based on context
        if is_subagent():
            # Subagent: 10,000 line suggestion
            if line_count > 10000:
                return f"""💡 LARGE FILE DETECTED: {line_count} lines (reading anyway)

SUGGESTION: Consider using Gemini CLI MCP for better performance:
  • Gemini has a 1M-token context window
  • Use: gemini -p "@{file_path} analyze this file"
  • Or: gemini -p "@{file_path} find the definition of function_name"

See: ~/.claude/documentation/ for Gemini MCP usage examples"""
        else:
            # Main agent: 500 line suggestion
            if line_count > 500:
                return f"""💡 LARGE FILE DETECTED: {line_count} lines (reading anyway)

SUGGESTION: Consider using the Explore subagent for token efficiency:
  • Delegate analysis to specialized agent
  • Use: Task tool with subagent_type="Explore"
  • Keeps your context clean and focused

Example: "Use the Explore agent to analyze {file_path}" """

        return None

    except Exception:
        # Don't suggest on errors
        return None

def validate_git_command(command):
    """
    Validate git commands requiring explicit user approval.
    ALL git add/commit/push/checkout operations require user confirmation.
    Returns (should_block, message).
    """
    if not command or 'git' not in command.lower():
        return False, None

    normalized = ' '.join(command.lower().split())

    # Define git operations that require approval
    git_operations = {
        'git add': {
            'patterns': [
                r'\bgit\s+add\s+-[a-z]*A[a-z]*',  # git add -A
                r'\bgit\s+add\s+--all\b',  # git add --all
                r'\bgit\s+add\s+\.\s*$',  # git add .
                r'\bgit\s+add\s+\*',  # git add *
                r'\bgit\s+add\s+',  # ANY git add
            ],
            'prompt': 'Stage files with git add?',
            'details': 'This will stage files for commit.'
        },
        'git commit': {
            'patterns': [r'\bgit\s+commit\b'],
            'prompt': 'Create a git commit?',
            'details': 'This will commit staged changes to the repository.'
        },
        'git push': {
            'patterns': [r'\bgit\s+push\b'],
            'prompt': 'Push changes to remote repository?',
            'details': 'This will push local commits to the remote repository.'
        },
        'git checkout': {
            'patterns': [
                r'\bgit\s+checkout\s+-[a-z]*f[a-z]*',  # git checkout -f
                r'\bgit\s+checkout\s+--force\b',  # git checkout --force
                r'\bgit\s+checkout\s+\.\s*$',  # git checkout .
                r'\bgit\s+checkout\s+\w+',  # git checkout branch
            ],
            'prompt': 'Switch branch or restore files with git checkout?',
            'details': 'This may overwrite uncommitted changes.'
        }
    }

    # Check each git operation
    for operation, config in git_operations.items():
        for pattern in config['patterns']:
            if re.search(pattern, normalized):
                # Format message for user approval
                message = f"""⚠️ Git operation requires approval

Command: {command}
Action: {config['prompt']}
Warning: {config['details']}

This command requires explicit user approval to proceed."""
                return True, message

    return False, None

def suggest_trash_pattern(command):
    """
    Suggest TRASH/ pattern enforcement for rm commands.
    Returns suggestion message or None.
    """
    if not command or 'rm' not in command.lower():
        return None

    # Already blocked by is_dangerous_rm_command, so this is for messaging
    normalized = ' '.join(command.lower().split())
    if re.search(r'\brm\s+', normalized):
        return """
💡 REMINDER: Instead of rm, use the TRASH/ pattern:
   1. mkdir -p TRASH
   2. mv unwanted_file.txt TRASH/
   3. echo "unwanted_file.txt - moved to TRASH/ - reason" >> TRASH-FILES.md

This allows recovery if needed."""

    return None

def suggest_mcp_tools(tool_name, tool_input):
    """
    Suggest MCP tools as alternatives to WebSearch/WebFetch.
    Returns suggestion message or None (non-blocking).
    """
    # Detect WebSearch usage
    if tool_name == 'WebSearch':
        query = tool_input.get('query', '')
        return f"""
💡 SUGGESTION: Consider using Tavily MCP for web search:
   • More reliable than WebSearch
   • Advanced filtering (domain, time range, news vs general)
   • Image results included

   Use: tavily_search tool with query: "{query}"
"""

    # Detect WebFetch for documentation
    if tool_name == 'WebFetch':
        url = tool_input.get('url', '')
        if any(domain in url.lower() for domain in ['docs.', '/docs/', 'documentation', 'api.', 'reference']):
            return """
💡 SUGGESTION: For documentation, use Context7 MCP:
   1. resolve-library-id to find library (e.g., "vue" → "/vuejs/docs")
   2. get-library-docs to fetch structured documentation

   Benefits: Code examples, token-efficient, up-to-date versions
"""

    # Detect curl/wget in Bash commands
    if tool_name == 'Bash':
        command = tool_input.get('command', '')
        if any(cmd in command.lower() for cmd in ['curl', 'wget', 'http']):
            return """
💡 SUGGESTION: For web content extraction, use Tavily MCP:
   • tavily_extract: Extract content from URLs (cleaner than curl)
   • tavily_map: Discover site structure
   • tavily_crawl: Multi-page content extraction
"""

    return None

def suggest_ripgrep(command):
    """
    Suggest ripgrep (rg) or fd as faster alternatives.
    Returns suggestion message or None (non-blocking).
    """
    if not command:
        return None

    normalized = ' '.join(command.lower().split())

    # Detect grep usage
    if re.search(r'\bgrep\b', normalized):
        return """
💡 PERFORMANCE TIP: Use 'rg' (ripgrep) instead of grep:
   • 10-100x faster on large codebases
   • Respects .gitignore automatically
   • Better regex syntax
   • Colored output by default
"""

    # Detect find usage
    if re.search(r'\bfind\s+', normalized):
        return """
💡 PERFORMANCE TIP: Use 'fd' instead of find:
   • 5-10x faster on large directories
   • Simpler syntax (no -name required)
   • Respects .gitignore automatically

   Example: find . -name "*.js" → fd "\\.js$"
"""

    return None

def main():
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)

        tool_name = input_data.get('tool_name', '')
        tool_input = input_data.get('tool_input', {})

        # === BLOCKING VALIDATIONS (exit 2 blocks execution) ===

        # 1. Git command validation with speed bump approval
        if tool_name == 'Bash':
            command = tool_input.get('command', '')

            should_block, message = validate_git_command(command)
            if should_block:
                print(message, file=sys.stderr)
                sys.exit(2)

            # 2. Block dangerous rm -rf commands
            if is_dangerous_rm_command(command):
                print("BLOCKED: Dangerous rm command detected and prevented", file=sys.stderr)
                trash_suggestion = suggest_trash_pattern(command)
                if trash_suggestion:
                    print(trash_suggestion, file=sys.stderr)
                sys.exit(2)

        # === NON-BLOCKING SUGGESTIONS (print to stdout, don't block) ===

        # 3. Suggest file size optimizations for large files
        file_size_suggestion = suggest_file_size_optimization(tool_name, tool_input)
        if file_size_suggestion:
            print(file_size_suggestion, file=sys.stdout)

        # 4. Suggest MCP tools for WebSearch/WebFetch
        mcp_suggestion = suggest_mcp_tools(tool_name, tool_input)
        if mcp_suggestion:
            print(mcp_suggestion, file=sys.stdout)

        # 5. Suggest ripgrep/fd for better performance
        if tool_name == 'Bash':
            command = tool_input.get('command', '')
            perf_suggestion = suggest_ripgrep(command)
            if perf_suggestion:
                print(perf_suggestion, file=sys.stdout)

        # === LOGGING ===

        # Ensure log directory exists
        log_dir = Path.cwd() / 'logs'
        log_dir.mkdir(parents=True, exist_ok=True)
        log_path = log_dir / 'pre_tool_use.json'

        # Read existing log data or initialize empty list
        if log_path.exists():
            with open(log_path, 'r') as f:
                try:
                    log_data = json.load(f)
                except (json.JSONDecodeError, ValueError):
                    log_data = []
        else:
            log_data = []

        # Append new data
        log_data.append(input_data)

        # Write back to file with formatting
        with open(log_path, 'w') as f:
            json.dump(log_data, f, indent=2)

        sys.exit(0)

    except json.JSONDecodeError:
        # Gracefully handle JSON decode errors
        sys.exit(0)
    except Exception:
        # Handle any other errors gracefully
        sys.exit(0)

if __name__ == '__main__':
    main()
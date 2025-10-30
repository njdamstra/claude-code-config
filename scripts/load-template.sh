#!/usr/bin/env bash
#
# Template Loader Utility
# Usage: load-template.sh <template-path> <variable1=value1> <variable2=value2> ...
#
# Example:
#   load-template.sh frontend/code-scout-new FEATURE_NAME="auth" FEATURE_DESCRIPTION="OAuth login"
#

set -euo pipefail

# Template base directory
TEMPLATE_DIR="${HOME}/.claude/templates"

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <template-path> [VAR=value...]" >&2
    echo "Example: $0 frontend/code-scout-new FEATURE_NAME=auth" >&2
    exit 1
fi

TEMPLATE_PATH="$1"
shift

# Resolve template file
if [[ "$TEMPLATE_PATH" == *.md ]]; then
    TEMPLATE_FILE="${TEMPLATE_DIR}/${TEMPLATE_PATH}"
else
    TEMPLATE_FILE="${TEMPLATE_DIR}/${TEMPLATE_PATH}.md"
fi

# Check template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template not found: $TEMPLATE_FILE" >&2
    echo "Available templates:" >&2
    find "$TEMPLATE_DIR" -name "*.md" -type f | sed "s|^${TEMPLATE_DIR}/||" >&2
    exit 1
fi

# Read template content
CONTENT=$(<"$TEMPLATE_FILE")

# Process variable substitutions
for arg in "$@"; do
    if [[ "$arg" == *=* ]]; then
        VAR_NAME="${arg%%=*}"
        VAR_VALUE="${arg#*=}"

        # Replace {{VAR_NAME}} with value
        CONTENT="${CONTENT//\{\{${VAR_NAME}\}\}/${VAR_VALUE}}"
    fi
done

# Output processed template
echo "$CONTENT"

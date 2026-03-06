#!/bin/bash

# Shell formatter hook for iflow cli (Plugin Mode)
# Formats shell scripts with shfmt after edits and outputs JSON format

# Source utilities
source "$(dirname "$0")/utils.sh"

# Helper function to output JSON and exit
output_json() {
    echo "$1"
    exit 0
}

# Read input from stdin
INPUT=$(cat)

# Parse input and extract fields
if ! parse_hook_input "$INPUT"; then
    output_json '{}'
fi

# Check if file is a shell script
if [[ ! "$FILE_PATH" =~ \.(sh|bash|zsh|ksh|fish)$ ]]; then
    output_json '{}'
fi

# Check if project has local shfmt hook override
if has_project_hook_override "$PROJECT_DIR"; then
    output_json '{}'
fi

# Check if shfmt is available
if ! has_shfmt; then
    output_json '{}'
fi

# Run shfmt on the file (always succeed regardless of outcome)
shfmt -w "$FILE_PATH" >/dev/null 2>&1

# Always return empty JSON with success status
output_json '{}'
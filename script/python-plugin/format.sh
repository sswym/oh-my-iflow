#!/bin/bash

# Python formatter hook for iflow cli (Plugin Mode)
# Formats Python files with Black after edits and outputs JSON format

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

# Check if file is a Python file
if [[ ! "$FILE_PATH" =~ \.py$ ]]; then
    output_json '{}'
fi

# Check if project has local black hook override
if has_project_hook_override "$PROJECT_DIR"; then
    output_json '{}'
fi

# Check if black is configured or available
if ! has_black_config "$PROJECT_DIR"; then
    output_json '{}'
fi

# Run black on the file (always succeed regardless of outcome)
cd "$PROJECT_DIR" && black "$FILE_PATH" >/dev/null 2>&1

# Always return empty JSON with success status
output_json '{}'
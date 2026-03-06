#!/bin/bash

# Rust formatter hook for iflow cli (Plugin Mode)
# Formats Rust files with rustfmt after edits and outputs JSON format

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

# Check if file is a Rust file
if [[ ! "$FILE_PATH" =~ \.rs$ ]]; then
    output_json '{}'
fi

# Check if project has local rustfmt hook override
if has_project_hook_override "$PROJECT_DIR"; then
    output_json '{}'
fi

# Check if rustfmt is available
if ! has_rustfmt; then
    output_json '{}'
fi

# Run rustfmt on the file (always succeed regardless of outcome)
rustfmt "$FILE_PATH" >/dev/null 2>&1

# Always return empty JSON with success status
output_json '{}'
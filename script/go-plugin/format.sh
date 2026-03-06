#!/bin/bash

# Go formatter hook for iflow Code (Plugin Mode)
# Formats Go files with gofmt after edits and outputs JSON format

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

# Check if file is a Go file
if [[ ! "$FILE_PATH" =~ \.go$ ]]; then
    output_json '{}'
fi

# Check if project has local gofmt hook override
if has_project_hook_override "$PROJECT_DIR"; then
    output_json '{}'
fi

# Check if gofmt is available
if ! has_gofmt; then
    output_json '{}'
fi

# Run gofmt on the file (always succeed regardless of outcome)
gofmt -w "$FILE_PATH" >/dev/null 2>&1

# Always return empty JSON with success status
output_json '{}'
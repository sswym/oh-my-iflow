#!/bin/bash

# Utility functions for Python plugin hooks

# Parse JSON input from stdin and extract fields
parse_hook_input() {
    local input="$1"

    # Extract project_dir and file_path
    PROJECT_DIR=$(echo "$input" | jq -r ".cwd // empty" 2>/dev/null)
    FILE_PATH=$(echo "$input" | jq -r ".tool_input.file_path // empty" 2>/dev/null)

    # Validate we have required fields
    if [[ -z "$PROJECT_DIR" || -z "$FILE_PATH" ]]; then
        return 1
    fi

    return 0
}

# Check if project has local hook override for black
has_project_hook_override() {
    local project_dir="$1"

    local project_settings="$project_dir/.iflow/settings.json"

    # Check if project has .iflow/settings.json
    if [[ ! -f "$project_settings" ]]; then
        return 1
    fi

    # Check if settings has PostToolUse hooks with black
    if jq -e ".hooks.PostToolUse[]?.hooks[]?.command | select(test(\"black\"; \"i\"))" "$project_settings" >/dev/null 2>&1; then
        return 0
    fi

    return 1
}

# Check if black is configured or available
has_black_config() {
    local project_dir="$1"

    # Check for pyproject.toml with [tool.black] section
    if [[ -f "$project_dir/pyproject.toml" ]]; then
        if grep -q "^\[tool\.black\]" "$project_dir/pyproject.toml" 2>/dev/null; then
            return 0
        fi
    fi

    # Check for setup.cfg with [black] section
    if [[ -f "$project_dir/setup.cfg" ]]; then
        if grep -q "^\[black\]" "$project_dir/setup.cfg" 2>/dev/null; then
            return 0
        fi
    fi

    # Check for .black configuration file
    if [[ -f "$project_dir/.black" ]]; then
        return 0
    fi

    # Check if black is installed globally
    if command -v black >/dev/null 2>&1; then
        return 0
    fi

    return 0
}
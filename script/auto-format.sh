#!/bin/bash

# Universal auto-formatter for iflow CLI
# Automatically detects file type and runs the appropriate formatter

# Helper function to output JSON and exit
output_json() {
	echo "$1"
	exit 0
}

# Read input from stdin
INPUT=$(cat)

# Parse input and extract fields
PROJECT_DIR=$(echo "$INPUT" | jq -r ".cwd // empty" 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r ".tool_input.file_path // empty" 2>/dev/null)

# Validate we have required fields
if [[ -z "$PROJECT_DIR" || -z "$FILE_PATH" ]]; then
	output_json '{}'
fi

# Get the file extension
FILE_EXT="${FILE_PATH##*.}"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine which formatter to use based on file extension
FORMATTER_SCRIPT=""

case "$FILE_EXT" in
go)
	FORMATTER_SCRIPT="$SCRIPT_DIR/go-plugin/format.sh"
	;;
py)
	FORMATTER_SCRIPT="$SCRIPT_DIR/python-plugin/format.sh"
	;;
rs)
	FORMATTER_SCRIPT="$SCRIPT_DIR/rust-plugin/format.sh"
	;;
sh | bash | zsh | ksh | fish)
	FORMATTER_SCRIPT="$SCRIPT_DIR/shell-plugin/format.sh"
	;;
js | jsx | ts | tsx | json | css | scss | less | html | md | yaml | yml)
	FORMATTER_SCRIPT="$SCRIPT_DIR/prettier/prettier-format.sh"
	;;
*)
	# Unknown file type, do nothing
	output_json '{}'
	;;
esac

# Check if the formatter script exists and is executable
if [[ ! -f "$FORMATTER_SCRIPT" ]]; then
	output_json '{}'
fi

# Check if the formatter script is executable, if not, make it executable
if [[ ! -x "$FORMATTER_SCRIPT" ]]; then
	chmod +x "$FORMATTER_SCRIPT" 2>/dev/null
fi

# Run the formatter script and pass the input
echo "$INPUT" | bash "$FORMATTER_SCRIPT"

# The formatter script will output the JSON and exit

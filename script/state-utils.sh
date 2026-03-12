#!/bin/bash
# omi State Management Utilities
# Unified state management for oh-my-iflow

set -e

# Default state directory
STATE_DIR="${OMI_STATE_DIR:-.omi/state}"
MEMORY_DIR="${OMI_MEMORY_DIR:-.omi/memory}"
RULES_DIR="${OMI_RULES_DIR:-.omi/rules}"
HOOKS_DIR="${OMI_HOOKS_DIR:-.omi/hooks}"
CONFIG_FILE="${STATE_DIR}/config.json"

# Default configuration
DEFAULT_CONFIG='{
  "loopLimits": {
    "default": 5,
    "speed": 3,
    "deep": 10,
    "autopilot": 5,
    "ralph": -1
  },
  "stateDir": ".omi/state",
  "memoryDir": ".omi/memory",
  "rulesDir": ".omi/rules",
  "hooksDir": ".omi/hooks"
}'

# Initialize state directories
omi_init() {
	mkdir -p "$STATE_DIR" "$MEMORY_DIR" "$RULES_DIR" "$HOOKS_DIR"

	if [[ ! -f "$CONFIG_FILE" ]]; then
		echo "$DEFAULT_CONFIG" >"$CONFIG_FILE"
		echo "Created default config at $CONFIG_FILE"
	fi
}

# Get state file path
omi_state_file() {
	local name="$1"
	echo "${STATE_DIR}/${name}"
}

# Read state value
omi_read_state() {
	local file="$1"
	local path="${STATE_DIR}/${file}"

	if [[ -f "$path" ]]; then
		cat "$path"
	else
		echo ""
	fi
}

# Write state value
omi_write_state() {
	local file="$1"
	local content="$2"
	local path="${STATE_DIR}/${file}"

	mkdir -p "$(dirname "$path")"
	echo "$content" >"$path"
}

# Get config value (JSON path using jq)
omi_get_config() {
	local path="$1"

	if command -v jq &>/dev/null && [[ -f "$CONFIG_FILE" ]]; then
		jq -r "$path // empty" "$CONFIG_FILE" 2>/dev/null || echo ""
	else
		echo ""
	fi
}

# Get loop limit for mode
omi_get_loop_limit() {
	local mode="${1:-default}"
	local limit

	if command -v jq &>/dev/null && [[ -f "$CONFIG_FILE" ]]; then
		limit=$(jq -r ".loopLimits.${mode} // .loopLimits.default // 5" "$CONFIG_FILE" 2>/dev/null)
	fi

	echo "${limit:-5}"
}

# Update state with timestamp
omi_update_state() {
	local file="$1"
	local content="$2"
	local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

	if [[ "$file" == *.json ]]; then
		if command -v jq &>/dev/null; then
			content=$(echo "$content" | jq --arg ts "$timestamp" '. + {updated_at: $ts}' 2>/dev/null || echo "$content")
		fi
	fi

	omi_write_state "$file" "$content"
}

# Check if state exists
omi_state_exists() {
	local file="$1"
	local path="${STATE_DIR}/${file}"
	[[ -f "$path" ]]
}

# List all state files
omi_list_state() {
	find "$STATE_DIR" -type f -name "*.json" -o -name "*.md" 2>/dev/null | sort
}

# Clean state (remove all or specific)
omi_clean_state() {
	local pattern="${1:-*}"
	find "$STATE_DIR" -name "$pattern" -type f -delete 2>/dev/null
	echo "Cleaned state files matching: $pattern"
}

# Show state summary
omi_status() {
	echo "=== omi State Status ==="
	echo ""
	echo "State Directory: $STATE_DIR"
	echo "Config File: $CONFIG_FILE"
	echo ""

	if [[ -f "$CONFIG_FILE" ]]; then
		echo "Configuration:"
		cat "$CONFIG_FILE"
		echo ""
	fi

	echo "State Files:"
	omi_list_state | while read -r file; do
		local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "?")
		echo "  $(basename "$file") ($size bytes)"
	done
}

# Main entry point
case "${1:-help}" in
init)
	omi_init
	;;
file)
	omi_state_file "${2:-}"
	;;
read)
	omi_read_state "${2:-}"
	;;
write)
	omi_write_state "${2:-}" "${3:-}"
	;;
config)
	omi_get_config "${2:-.}"
	;;
loop-limit)
	omi_get_loop_limit "${2:-default}"
	;;
update)
	omi_update_state "${2:-}" "${3:-}"
	;;
exists)
	omi_state_exists "${2:-}" && echo "yes" || echo "no"
	;;
list)
	omi_list_state
	;;
clean)
	omi_clean_state "${2:-*}"
	;;
status)
	omi_status
	;;
help | *)
	echo "omi State Management Utilities"
	echo ""
	echo "Usage: $0 <command> [args]"
	echo ""
	echo "Commands:"
	echo "  init              Initialize state directories and config"
	echo "  file <name>       Get state file path"
	echo "  read <file>       Read state file content"
	echo "  write <file> <content>  Write state file"
	echo "  config <path>     Get config value (jq path)"
	echo "  loop-limit <mode> Get loop limit for mode"
	echo "  update <file> <content>  Update state with timestamp"
	echo "  exists <file>     Check if state file exists"
	echo "  list              List all state files"
	echo "  clean [pattern]   Clean state files"
	echo "  status            Show state summary"
	;;
esac

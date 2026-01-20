#!/bin/bash

# ==============================================================================
# Script Name: find_cmd.sh
# Description: Checks if a specific command exists in the system's PATH.
# Usage: ./find_cmd.sh <command_name>
# ==============================================================================

# Input validation
if [ -z "$1" ]; then
    echo "❌ Error: No command name provided."
    echo "Usage: $0 <command_name>"
    exit 1
fi

CMD_NAME=$1

# Use 'command -v' to locate the command
# It is more portable and reliable than 'which' in shell scripts
CMD_PATH=$(command -v "$CMD_NAME")

if [ -n "$CMD_PATH" ]; then
    echo "✅ Success: Command '$CMD_NAME' found."
    echo "Location: $CMD_PATH"
else
    echo "❓ Not Found: Command '$CMD_NAME' is not in your PATH."
    exit 1
fi

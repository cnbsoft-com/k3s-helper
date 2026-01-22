#!/bin/sh

# ==============================================================================
# Script Name: cmd_exam.sh
# Description: Checks if a specific command exists and lists Ubuntu images.
# ==============================================================================

# Input validation
if [ -z "$1" ]; then
    echo "❌ Error: No command name provided."
    echo "Usage: $0 <command_name>"
    exit 1
fi

CMD_NAME=$1

# Use 'command -v' to locate the command
CMD_PATH=$(command -v "$CMD_NAME")

if [ -n "$CMD_PATH" ]; then
    echo "✅ Success: Command '$CMD_NAME' found."
    echo "Location: $CMD_PATH"
else
    echo "❓ Not Found: Command '$CMD_NAME' is not in your PATH."
    exit 1
fi

CMD="multipass"
echo ""
echo "--- Ubuntu Images ---"
$CMD find | grep "Ubuntu" | while read -r line; do
    echo "Found: $line"
done

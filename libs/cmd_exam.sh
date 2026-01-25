#!/bin/bash

# ==============================================================================
# Script Name: cmd_exam.bash
# Description: Checks if a specific command exists and lists Ubuntu images.
# ==============================================================================
cmd_test() {
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
}

select_recusive_test() {

  built_in_specs=()
  built_in_specs+=("2cpus, 2G memory, 10G disk|--cpus 2 --memory 2G --disk 10G")
  built_in_specs+=("4cpus, 4G memory, 20G disk|--cpus 4 --memory 4G --disk 20G")
  built_in_specs+=("8cpus, 8G memory, 40G disk|--cpus 8 --memory 8G --disk 40G")

  # select에 표시할 label만 추출
  display_labels=()
  for spec in "${built_in_specs[@]}"; do
    IFS='|' read -r label _ <<< "$spec"
    display_labels+=("$label")
  done

  PS3="
👉 Select a spec (or 'q' to quit): "

  select choice in "${display_labels[@]}"; do
    if [[ "$REPLY" == "q" || "$REPLY" == "Q" ]]; then
      echo "👋 Exiting..."
      exit 0
    elif [ -n "$choice" ]; then
      # REPLY는 1부터 시작하므로 인덱스는 REPLY-1
      idx=$((REPLY - 1))
      IFS='|' read -r label value <<< "${built_in_specs[$idx]}"
      echo "Label is ${label}"
      echo "Value is ${value}"
      break
    else
      echo "⚠️ Invalid selection. Please enter a number from the list above."
    fi
  done
}

select_recusive_test

#cmd_test "$@"


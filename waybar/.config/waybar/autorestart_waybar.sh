#!/bin/bash

# This script monitors changes to files in
# ~/.config/waybar/ and restarts Waybar automatically.

# --- Prerequisites ---
# Ensure you have 'inotify-tools' installed.
# On Arch Linux: sudo pacman -S inotify-tools

# --- Configuration ---
# Set the directory where your Waybar config files are located.
WAYBAR_CONFIG_DIR="$HOME/.config/waybar/"

# --- Script ---

function restart_waybar() {
  echo "--- $(date): Change detected! Restarting Waybar... ---"
  killall waybar
  waybar &
  echo "--- Waybar restarted. ---"
}

echo "Monitoring directory: $WAYBAR_CONFIG_DIR"
echo "Press Ctrl+C to stop the script."

# Initial Waybar start (optional, remove if Waybar is already running via another service)
# This ensures Waybar is running when the script starts.
# restart_waybar

# Loop indefinitely, monitoring for file modifications
# -m: Monitor indefinitely
# -e modify: Only trigger on 'modify' events (when files are saved)
inotifywait -m -r -e modify $WAYBAR_CONFIG_DIR |
  while read -r date time dir file; do
    # When a change is detected, restart Waybar
    restart_waybar
  done

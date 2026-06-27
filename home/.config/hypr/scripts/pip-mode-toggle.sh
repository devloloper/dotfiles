#!/usr/bin/env bash

# Find the Odyssey G9 monitor name dynamically (usually DP-1 or DP-2)
MONITOR_NAME=$(hyprctl monitors -j | jq -r '.[] | select(.description | contains("Odyssey G9")) | .name' | head -n 1)

if [ -z "$MONITOR_NAME" ] || [ "$MONITOR_NAME" = "null" ]; then
    MONITOR_NAME="DP-1"
fi

# Get info for this specific monitor
WIDTH=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR_NAME\") | .width")

if [ -n "$WIDTH" ] && [ "$WIDTH" -eq 7680 ]; then
    # Start Waybar service in Native mode
    systemctl --user start waybar.service
    notify-send "Hyprland" "Native Mode Active (8K 32:9) - Waybar Started"
else
    # Stop Waybar service in PIP mode to reclaim vertical space
    systemctl --user stop waybar.service
    notify-send "Hyprland" "PiP Mode Active - Waybar Stopped"
fi

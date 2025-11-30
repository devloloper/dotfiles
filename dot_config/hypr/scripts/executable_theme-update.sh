#!/bin/bash

# 1. Generate Colors & Update Wallpaper (if image provided)
if [ -n "$1" ]; then
    WALLPAPER="$1"

    # Generate colors with pywal
    if ! wal -i "$WALLPAPER"; then
        echo "Error: wal failed to generate colors."
        exit 1
    fi

    # Update Hyprpaper
    if pgrep hyprpaper >/dev/null; then
         echo "Updating Hyprpaper..."
         # Unload the wallpaper first to force a reload from disk
         hyprctl hyprpaper unload "$WALLPAPER"
         
         # Preload the new wallpaper
         hyprctl hyprpaper preload "$WALLPAPER"
         
         # Get all connected monitor names
         MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
         
         # Set the wallpaper for each monitor
         for monitor in $MONITORS; do
             hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
         done
    else
         echo "Warning: hyprpaper not running. Wallpaper not updated."
    fi
else
    if ! wal -R; then
        echo "Error: wal failed to reload colors."
        exit 1
    fi
fi

# 2. Update Pywalfox (Firefox)
pywalfox update

# 3. Reload Waybar to pick up new colors
pkill -SIGUSR2 waybar

# 4. Reload Hyprland (updates borders)
hyprctl reload

#!/usr/bin/env bash

# Match the G9 57" specifically
MONITOR_NAME="DP-2"

# Get info for this specific monitor
WIDTH=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR_NAME\") | .width")

# Debug log (optional, you can see this in your notification)
# notify-send "Debug" "Current Width: $WIDTH"

if [ "$WIDTH" -eq 7680 ]; then
    # Switch to PiP Mode (1440p 16:9)
    # Using @auto to ensure the handshake succeeds
    hyprctl eval "hl.monitor({ output = \"$MONITOR_NAME\", mode = \"2560x1440@auto\", position = \"0x0\", scale = \"1\", bitdepth = 10 })"
    notify-send "Hyprland" "PiP Mode Enabled (1440p 16:9)"
else
    # Switch back to Native 8K
    hyprctl eval "hl.monitor({ output = \"$MONITOR_NAME\", mode = \"7680x2160@auto\", position = \"0x0\", scale = \"1\", bitdepth = 10 })"
    notify-send "Hyprland" "Native Mode Enabled (8K 32:9)"
fi

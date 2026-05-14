#!/bin/bash

# Toggle Hyprland group titles visibility by zeroing font size
# This keeps the group bar height consistent (defined in hyprland.lua)

# Get current font size
CURRENT_FONT=$(hyprctl getoption group.groupbar.font_size -j | jq -r '.int')

if [ "$CURRENT_FONT" -gt 0 ]; then
    # Hide titles by setting font to 0, but keep the bar height
    hyprctl eval 'hl.config({ group = { groupbar = { font_size = 0 } } })'
    # Optional: you could also set render_titles to false here if 0 font isn't enough,
    # but usually font 0 + fixed height 24 works best.
else
    # Restore titles
    hyprctl eval 'hl.config({ group = { groupbar = { font_size = 13 } } })'
fi

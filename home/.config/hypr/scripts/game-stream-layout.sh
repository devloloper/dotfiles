#!/usr/bin/env bash
set -euo pipefail

hyprctl eval 'hl.config({ master = { orientation = "left", mfact = 0.70 } })' >/dev/null

workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')
game_address=$(hyprctl activewindow -j | jq -r '.address')

if [ "$game_address" != "null" ] && [ -n "$game_address" ]; then
    hyprctl dispatch "hl.dsp.window.swap({ target = 'master' })" >/dev/null 2>&1 || true
fi

mpv_address=$(
    hyprctl clients -j |
        jq -r --argjson workspace "$workspace_id" '
            [.[] | select(.workspace.id == $workspace and .class == "mpv" and .floating == false)]
            | sort_by(.focusHistoryID)
            | .[0].address // empty
        '
)

if [ -n "$mpv_address" ] && [ "$mpv_address" != "$game_address" ]; then
    hyprctl dispatch "hl.dsp.focus({ window = 'address:$mpv_address' })" >/dev/null
    hyprctl dispatch "hl.dsp.window.swap({ target = 'master' })" >/dev/null 2>&1 || true
    hyprctl dispatch "hl.dsp.focus({ window = 'address:$game_address' })" >/dev/null
fi

notify-send "Hyprland" "Game + stream layout: 70/30"

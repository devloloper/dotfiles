if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx HSA_OVERRIDE_GFX_VERSION 10.3.0
set -gx VISUAL code --wait
set -gx EDITOR nano

string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -Ua SSH_KEYS_TO_AUTOLOAD ~/.ssh/id_ed25519
end

set -gx HSA_OVERRIDE_GFX_VERSION 10.3.0
set -gx VISUAL code --wait
set -gx EDITOR nano
set -gx GITHUB_USERNAME devloloper

string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)

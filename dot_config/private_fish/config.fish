if status is-interactive
    # Commands to run in interactive sessions can go here
    if uwsm check may-start
        exec uwsm start hyprland
    end
end

# Add ssh key to keyring
set -U SSH_KEYS_TO_AUTOLOAD ~/.ssh/id_ed25519

set -gx MOZ_ENABLE_WAYLAND 1
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx VISUAL code --wait
set -gx EDITOR nano
set -gx GITHUB_USERNAME devloloper

string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)

pyenv init - | source

starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Add ssh key to keyring
set -U SSH_KEYS_TO_AUTOLOAD ~/.ssh/id_ed25519

set -gx MOZ_ENABLE_WAYLAND 1
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx HSA_OVERRIDE_GFX_VERSION 10.3.0
set -gx VISUAL code --wait
set -gx EDITOR nano
set -gx GITHUB_USERNAME devloloper

string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)
fish_add_path -aP /opt/rocm/bin

#!/bin/bash
set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

sudo install -Dm644 \
    "$DOTFILES_DIR/system/etc/tmpfiles.d/rapl.conf" \
    /etc/tmpfiles.d/rapl.conf

sudo systemd-tmpfiles --create /etc/tmpfiles.d/rapl.conf

echo "Installed system dotfiles."

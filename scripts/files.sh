#!/bin/sh
set -eu

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        message="deepBlack files unavailable: $1 is not installed"

        if command -v notify-send >/dev/null 2>&1; then
            notify-send -u critical "deepBlack" "$message" || true
        fi

        printf '%s\n' "$message" >&2
        exit 127
    fi
}

require_command foot
require_command yazi

exec foot \
    --app-id deepblack-files \
    --title "deepBlack Files" \
    yazi "${1:-$HOME}"

#!/bin/sh
set -eu

SCREENSHOT_DIR="$HOME/Pictures/deepBlack/screenshots"

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        message="deepBlack screenshot unavailable: $1 is not installed"

        if command -v notify-send >/dev/null 2>&1; then
            notify-send -u critical "deepBlack" "$message" || true
        fi

        printf '%s\n' "$message" >&2
        exit 127
    fi
}

require_command grim
require_command slurp

mkdir -p "$SCREENSHOT_DIR"

if ! geometry="$(slurp)"; then
    exit 0
fi

if [ -z "$geometry" ]; then
    exit 0
fi

output="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S_area.png')"

grim -g "$geometry" "$output"

if command -v notify-send >/dev/null 2>&1; then
    notify-send \
        "deepBlack // screenshot" \
        "Saved to $output" \
        || true
fi

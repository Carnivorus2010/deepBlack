#!/bin/sh
set -u

WALLPAPER="${DEEPBLACK_WALLPAPER:-$HOME/.local/share/deepblack/wallpaper}"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/deepblack"
LOG_FILE="$LOG_DIR/swaybg.log"

mkdir -p "$LOG_DIR"

if command -v swaybg >/dev/null 2>&1 && [ -r "$WALLPAPER" ]; then
    pkill -x swaybg 2>/dev/null || true

    swaybg \
        -i "$WALLPAPER" \
        -m fill \
        >"$LOG_FILE" 2>&1 &
else
    printf 'deepBlack: wallpaper unavailable: %s\n' \
        "$WALLPAPER" >"$LOG_FILE"
fi

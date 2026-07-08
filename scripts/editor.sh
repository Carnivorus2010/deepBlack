#!/usr/bin/env bash
set -euo pipefail

APP_ID="deepblack-editor"
TITLE="deepBlack :: editor"

if ! command -v nvim >/dev/null 2>&1; then
    msg="deepBlack editor unavailable: nvim is not installed"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u critical "deepBlack" "$msg"
    fi
    printf '%s\n' "$msg" >&2
    exit 127
fi

if command -v foot >/dev/null 2>&1; then
    exec foot --app-id "$APP_ID" --title "$TITLE" nvim "$@"
fi

exec nvim "$@"

#!/bin/sh
set -eu

if ! command -v thunar >/dev/null 2>&1; then
    printf 'deepBlack: Thunar is not installed\n' >&2
    exit 127
fi

exec thunar "${1:-$HOME}"

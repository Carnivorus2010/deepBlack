#!/bin/sh
set -u

WALLPAPER="${DEEPBLACK_WALLPAPER:-$HOME/Pictures/Wallpapers/wallpaper.png}"

if command -v swaybg >/dev/null 2>&1 && [ -f "$WALLPAPER" ]; then
    swaybg -i "$WALLPAPER" &
fi

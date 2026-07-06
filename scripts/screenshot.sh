#!/bin/sh

SCREENSHOT_DIR="$HOME/Pictures/deepBlack/screenshots"

mkdir -p "$SCREENSHOT_DIR"

grim -g "$(slurp)" "$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S_area.png')"

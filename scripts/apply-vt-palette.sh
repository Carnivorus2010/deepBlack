#!/bin/sh
set -u

PALETTE="${1:-/usr/local/share/deepblack/vtrgb}"

if ! command -v setvtrgb >/dev/null 2>&1; then
    exit 0
fi

if [ ! -r "$PALETTE" ]; then
    exit 0
fi

setvtrgb "$PALETTE" >/dev/null 2>&1 || exit 0

exit 0

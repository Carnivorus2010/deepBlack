#!/bin/sh
set -eu

export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=deepBlack
export XDG_SESSION_DESKTOP=deepBlack

export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland

AUTOSTART="/usr/local/bin/deepblack-autostart"
STATUS="/usr/local/bin/deepblack-status"

if [ -x "$AUTOSTART" ]; then
    set -- dwl -s "$AUTOSTART"
else
    set -- dwl
fi

if [ -x "$STATUS" ]; then
    if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
        "$STATUS" | dbus-run-session -- "$@"
    else
        "$STATUS" | "$@"
    fi
else
    if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
        exec dbus-run-session -- "$@"
    else
        exec "$@"
    fi
fi

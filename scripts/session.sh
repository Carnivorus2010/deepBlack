#!/bin/sh
set -eu

export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=deepBlack
export XDG_SESSION_DESKTOP=deepBlack

export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland

if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    exec dbus-run-session dwl
else
    exec dwl
fi

#!/bin/sh

# deepBlack notification daemon launcher
# Runs the source-tokenized Mako build from the deepBlack repository.

MAKO_BIN="$HOME/Projects/deepBlack/source/mako/build/mako"
LOG_DIR="$HOME/.local/state/deepBlack"
LOG_FILE="$LOG_DIR/mako.log"

mkdir -p "$LOG_DIR"

{
    echo "---- deepBlack mako launch $(date) ----"
    echo "MAKO_BIN=$MAKO_BIN"
    echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-unset}"
    echo "XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-unset}"
    echo "DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-unset}"
} >> "$LOG_FILE"

if [ ! -x "$MAKO_BIN" ]; then
    echo "ERROR: deepBlack mako binary not found or not executable: $MAKO_BIN" >> "$LOG_FILE"
    exit 1
fi

# If systemd did not inherit WAYLAND_DISPLAY, infer it from the runtime socket.
if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
    for socket in "$XDG_RUNTIME_DIR"/wayland-*; do
        if [ -S "$socket" ]; then
            export WAYLAND_DISPLAY="${socket##*/}"
            echo "Resolved WAYLAND_DISPLAY=$WAYLAND_DISPLAY" >> "$LOG_FILE"
            break
        fi
    done
fi

if [ -z "$WAYLAND_DISPLAY" ]; then
    echo "ERROR: WAYLAND_DISPLAY is unset and no Wayland socket was found." >> "$LOG_FILE"
    exit 1
fi

# Avoid duplicate notification daemons.
pkill -x mako 2>/dev/null || true

echo "Starting source-built deepBlack mako..." >> "$LOG_FILE"

exec "$MAKO_BIN" >> "$LOG_FILE" 2>&1

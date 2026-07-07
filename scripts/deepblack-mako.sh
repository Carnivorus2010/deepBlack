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

# Wait briefly for the Wayland socket during login/session startup.
# This prevents systemd from marking the service failed if it starts
# slightly before dwl creates the Wayland display socket.
attempts=0
while [ -z "$WAYLAND_DISPLAY" ] && [ "$attempts" -lt 50 ]; do
    if [ -n "$XDG_RUNTIME_DIR" ]; then
        for socket in "$XDG_RUNTIME_DIR"/wayland-*; do
            if [ -S "$socket" ]; then
                export WAYLAND_DISPLAY="${socket##*/}"
                echo "Resolved WAYLAND_DISPLAY=$WAYLAND_DISPLAY" >> "$LOG_FILE"
                break
            fi
        done
    fi

    [ -n "$WAYLAND_DISPLAY" ] && break

    attempts=$((attempts + 1))
    sleep 0.1
done

if [ -z "$WAYLAND_DISPLAY" ]; then
    echo "ERROR: WAYLAND_DISPLAY is unset and no Wayland socket was found after waiting." >> "$LOG_FILE"
    exit 1
fi

# Avoid duplicate notification daemons.
pkill -x mako 2>/dev/null || true

echo "Starting source-built deepBlack mako..." >> "$LOG_FILE"

exec "$MAKO_BIN" >> "$LOG_FILE" 2>&1

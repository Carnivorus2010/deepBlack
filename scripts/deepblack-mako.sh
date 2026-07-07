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

# Avoid duplicate notification daemons.
pkill -x mako 2>/dev/null || true

echo "Starting source-built deepBlack mako..." >> "$LOG_FILE"

exec "$MAKO_BIN" >> "$LOG_FILE" 2>&1

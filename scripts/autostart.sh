#!/bin/sh
set -u

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/deepblack"
DEFAULT_WALLPAPER="$DATA_DIR/wallpaper"
WALLPAPER="${DEEPBLACK_WALLPAPER:-$DEFAULT_WALLPAPER}"
COLOR_FILE="$DATA_DIR/background-color"
MODE_FILE="$DATA_DIR/wallpaper-mode"

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/deepblack"
LOG_FILE="$LOG_DIR/swaybg.log"

mkdir -p "$LOG_DIR"

# Bind session services to the current Wayland environment.
if command -v systemctl >/dev/null 2>&1; then
    systemctl --user import-environment \
        WAYLAND_DISPLAY \
        XDG_RUNTIME_DIR \
        DBUS_SESSION_BUS_ADDRESS

    systemctl --user restart deepblack-mako.service
fi

COLOR="000000"
MODE="fill"

if [ -r "$COLOR_FILE" ]; then
    IFS= read -r COLOR < "$COLOR_FILE"
fi

if [ -r "$MODE_FILE" ]; then
    IFS= read -r MODE < "$MODE_FILE"
fi

case "$COLOR" in
    [[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]])
        ;;
    *)
        COLOR="000000"
        ;;
esac

case "$MODE" in
    stretch|fill|fit|center|tile)
        ;;
    *)
        MODE="fill"
        ;;
esac

if command -v swaybg >/dev/null 2>&1; then
    pkill -x swaybg 2>/dev/null || true

    if [ -r "$WALLPAPER" ]; then
        swaybg \
            -i "$WALLPAPER" \
            -m "$MODE" \
            -c "$COLOR" \
            >"$LOG_FILE" 2>&1 &
    else
        printf \
            'deepBlack: using solid background #%s\n' \
            "$COLOR" \
            >"$LOG_FILE"

        swaybg \
            -c "$COLOR" \
            >>"$LOG_FILE" 2>&1 &
    fi
else
    printf \
        'deepBlack: swaybg is not installed\n' \
        >"$LOG_FILE"
fi

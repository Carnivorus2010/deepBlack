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

# Bind managed user services to the current graphical session.
INIT_BACKEND_LIB="$HOME/.local/libexec/deepblack/init-backend.sh"

if [ -r "$INIT_BACKEND_LIB" ]; then
    # Source the installed backend-neutral service helpers.
    # shellcheck disable=SC1090
    . "$INIT_BACKEND_LIB"

        if INIT_BACKEND="$(deepblack_detect_user_backend)"; then
        if deepblack_import_session_environment "$INIT_BACKEND"; then
            deepblack_start_or_restart_user_service \
                deepblack-mako \
                "$INIT_BACKEND" || {
                    printf \
                        'deepBlack: failed to start Mako through %s\n' \
                        "$INIT_BACKEND" \
                        >&2
                }
        else
            printf \
                'deepBlack: failed to import the session environment through %s\n' \
                "$INIT_BACKEND" \
                >&2
        fi
    else
        printf \
            'deepBlack: no supported user-service backend is active\n' \
            >&2
    fi
else
    printf \
        'deepBlack: init backend library is not installed: %s\n' \
        "$INIT_BACKEND_LIB" \
        >&2
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

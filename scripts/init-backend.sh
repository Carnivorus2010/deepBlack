#!/bin/sh

# deepBlack user-service backend abstraction.
#
# This file is intended to be sourced by other deepBlack scripts.
# It provides one interface for systemd and dinit user services.

deepblack_detect_user_backend() {
    case "${DEEPBLACK_INIT_BACKEND:-auto}" in
        systemd|dinit)
            printf '%s\n' "$DEEPBLACK_INIT_BACKEND"
            return 0
            ;;
        auto)
            ;;
        *)
            printf \
                'deepBlack: unsupported init backend: %s\n' \
                "$DEEPBLACK_INIT_BACKEND" \
                >&2
            return 2
            ;;
    esac

    if command -v systemctl >/dev/null 2>&1 \
        && systemctl --user show-environment >/dev/null 2>&1
    then
        printf '%s\n' systemd
        return 0
    fi

    if command -v dinitctl >/dev/null 2>&1 \
        && dinitctl --user list >/dev/null 2>&1
    then
        printf '%s\n' dinit
        return 0
    fi

    printf '%s\n' none
    return 1
}

deepblack_import_session_environment() {
    _db_backend="${1:-$(deepblack_detect_user_backend)}"

    case "$_db_backend" in
        systemd)
            systemctl --user import-environment \
                WAYLAND_DISPLAY \
                XDG_RUNTIME_DIR \
                DBUS_SESSION_BUS_ADDRESS
            ;;

        dinit)
            if [ -n "${WAYLAND_DISPLAY:-}" ]; then
                dinitctl --user setenv \
                    "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
            else
                dinitctl --user unsetenv WAYLAND_DISPLAY
            fi

            if [ -n "${XDG_RUNTIME_DIR:-}" ]; then
                dinitctl --user setenv \
                    "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
            else
                dinitctl --user unsetenv XDG_RUNTIME_DIR
            fi

            if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
                dinitctl --user setenv \
                    "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS"
            else
                dinitctl --user unsetenv DBUS_SESSION_BUS_ADDRESS
            fi
            ;;

        *)
            printf \
                'deepBlack: no supported user-service backend is active\n' \
                >&2
            return 1
            ;;
    esac
}

deepblack_start_or_restart_user_service() {
    _db_service="${1%.service}"
    _db_backend="${2:-$(deepblack_detect_user_backend)}"

    case "$_db_backend" in
        systemd)
            systemctl --user restart "${_db_service}.service"
            ;;

        dinit)
            if dinitctl --user --quiet \
                is-started "$_db_service" >/dev/null 2>&1
            then
                dinitctl --user restart "$_db_service"
            else
                dinitctl --user start "$_db_service"
            fi
            ;;

        *)
            printf \
                'deepBlack: cannot control %s without a supported backend\n' \
                "$_db_service" \
                >&2
            return 1
            ;;
    esac
}

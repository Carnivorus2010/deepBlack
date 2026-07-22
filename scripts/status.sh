#!/bin/sh
set -eu

if command -v slstatus >/dev/null 2>&1; then
    exec slstatus -s
fi

battery_dir=""

for candidate in /sys/class/power_supply/BAT*; do
    if [ -d "$candidate" ]; then
        battery_dir="$candidate"
        break
    fi
done

while :; do
    if [ -n "$battery_dir" ] \
        && [ -r "$battery_dir/capacity" ] \
        && [ -r "$battery_dir/status" ]; then

        battery_capacity=$(cat "$battery_dir/capacity")
        battery_status=$(cat "$battery_dir/status")

        case "$battery_status" in
            Charging)
                battery_icon=" 󰂄"
                ;;
            Full)
                battery_icon=" 󰁹"
                ;;
            *)
                battery_icon=" 󰁿"
                ;;
        esac

        printf '%s %s%% | %s\n' \
            "$battery_icon" \
            "$battery_capacity" \
            "$(date '+%a %Y-%m-%d %H:%M')"
    else
        date '+%a %Y-%m-%d %H:%M'
    fi

    sleep 30
done

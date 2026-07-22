#!/bin/sh
set -eu

if command -v slstatus >/dev/null 2>&1; then
    exec slstatus -s
fi

cd /sys/class/power_supply/BAT0

while :; do
	if [ -r capacity ]; then
		battery_capacity=$(cat capacity)
		battery_status=$(cat status)

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

#!/bin/sh
set -eu

if command -v slstatus >/dev/null 2>&1; then
    exec slstatus -s
fi

while :; do
    date '+%a %Y-%m-%d %H:%M'
    sleep 30
done

#!/bin/sh
set -eu

TOKENS="${1:-generated/dwl/design_tokens.h}"
OUT="${2:-generated/greetd/vtrgb}"

if [ ! -f "$TOKENS" ]; then
    echo "error: token header not found: $TOKENS" >&2
    exit 1
fi

token_raw() {
    awk -v name="$1" '$1 == "#define" && $2 == name { print $3; exit }' "$TOKENS"
}

token_hex() {
    name="$1"
    depth=0

    while :; do
        raw="$(token_raw "$name")"

        if [ -z "$raw" ]; then
            echo "error: token not found: $name" >&2
            exit 1
        fi

        case "$raw" in
            0x*)
                printf '%s\n' "$raw"
                return 0
                ;;
            *)
                name="$raw"
                ;;
        esac

        depth=$((depth + 1))
        if [ "$depth" -gt 8 ]; then
            echo "error: token alias loop while resolving $1" >&2
            exit 1
        fi
    done
}

hex_to_rgb() {
    hex="${1#0x}"

    rr="$(printf '%s' "$hex" | cut -c1-2)"
    gg="$(printf '%s' "$hex" | cut -c3-4)"
    bb="$(printf '%s' "$hex" | cut -c5-6)"

    r="$(printf '%d' "0x$rr")"
    g="$(printf '%d' "0x$gg")"
    b="$(printf '%d' "0x$bb")"

    printf '%s,%s,%s\n' "$r" "$g" "$b"
}

append_csv() {
    current="$1"
    value="$2"

    if [ -n "$current" ]; then
        printf '%s,%s' "$current" "$value"
    else
        printf '%s' "$value"
    fi
}

mkdir -p "$(dirname "$OUT")"

# ANSI slots:
# 0 black, 1 red, 2 green, 3 yellow, 4 blue, 5 magenta, 6 cyan, 7 white
# 8 bright black, 9 bright red, 10 bright green, 11 bright yellow,
# 12 bright blue, 13 bright magenta, 14 bright cyan, 15 bright white
SLOTS="
SURFACE_00
STATE_CRITICAL
ACCENT_PRIMARY
STATE_WARNING
ACCENT_SECONDARY
ACCENT_DIAGNOSTIC
TEXT_SECONDARY
TEXT_PRIMARY
TEXT_MUTED
STATE_CRITICAL
ACCENT_DIAGNOSTIC
STATE_WARNING
ACCENT_SECONDARY
ACCENT_DIAGNOSTIC
TEXT_SECONDARY
TEXT_PRIMARY
"

reds=""
greens=""
blues=""

for token in $SLOTS; do
    rgb="$(hex_to_rgb "$(token_hex "$token")")"

    old_ifs="$IFS"
    IFS=,
    set -- $rgb
    IFS="$old_ifs"

    reds="$(append_csv "$reds" "$1")"
    greens="$(append_csv "$greens" "$2")"
    blues="$(append_csv "$blues" "$3")"
done

{
    printf '%s\n' "$reds"
    printf '%s\n' "$greens"
    printf '%s\n' "$blues"
} > "$OUT"

printf 'generated %s\n' "$OUT"

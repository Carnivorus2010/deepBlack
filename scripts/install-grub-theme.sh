#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

THEME_NAME="${1:-silverbullet-nord}"
SOURCE_DIR="$ROOT/config/grub/themes/$THEME_NAME"
DEST_DIR="/boot/grub/themes/$THEME_NAME"

GRUB_DEFAULT="/etc/default/grub"
GRUB_CONFIG="/boot/grub/grub.cfg"
GRUB_GFXMODE="${DEEPBLACK_GRUB_GFXMODE:-1280x800,auto}"

die() {
    printf 'error: %s\n' "$1" >&2
    exit 1
}

if [[ ! "$THEME_NAME" =~ ^[a-z0-9][a-z0-9._-]*$ ]]; then
    die "invalid GRUB theme name: $THEME_NAME"
fi

if [[ ! -f "$SOURCE_DIR/theme.txt" ]]; then
    die "theme file not found: $SOURCE_DIR/theme.txt"
fi

if ! command -v grub-mkconfig >/dev/null 2>&1; then
    die "grub-mkconfig is not installed"
fi

FONT_SOURCE=""

for candidate in \
    /usr/share/grub/themes/starfield/dejavu_16.pf2 \
    /boot/grub/themes/starfield/dejavu_16.pf2
do
    if [[ -f "$candidate" ]]; then
        FONT_SOURCE="$candidate"
        break
    fi
done

if [[ -z "$FONT_SOURCE" ]]; then
    die "DejaVu Sans GRUB font could not be found"
fi

set_grub_setting() {
    local key="$1"
    local value="$2"

    if sudo grep -qE "^[[:space:]]*#?[[:space:]]*${key}=" "$GRUB_DEFAULT"; then
        sudo sed -i -E \
            "s|^[[:space:]]*#?[[:space:]]*${key}=.*|${key}=${value}|" \
            "$GRUB_DEFAULT"
    else
        printf '\n%s=%s\n' "$key" "$value" |
            sudo tee -a "$GRUB_DEFAULT" >/dev/null
    fi
}

if [[ ! -e "$GRUB_DEFAULT.deepblack-backup" ]]; then
    sudo cp -a "$GRUB_DEFAULT" "$GRUB_DEFAULT.deepblack-backup"
    printf 'created backup: %s\n' "$GRUB_DEFAULT.deepblack-backup"
fi

sudo rm -rf -- "$DEST_DIR"

sudo install -Dm644 \
    "$SOURCE_DIR/theme.txt" \
    "$DEST_DIR/theme.txt"

sudo install -Dm644 \
    "$FONT_SOURCE" \
    "$DEST_DIR/dejavu_16.pf2"

set_grub_setting "GRUB_GFXMODE" "$GRUB_GFXMODE"
set_grub_setting "GRUB_THEME" "\"$DEST_DIR/theme.txt\""

sudo grub-mkconfig -o "$GRUB_CONFIG"

printf '\nInstalled GRUB theme: %s\n' "$THEME_NAME"
printf 'Theme path: %s/theme.txt\n' "$DEST_DIR"
printf 'Graphics mode: %s\n' "$GRUB_GFXMODE"

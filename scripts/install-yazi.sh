#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CONFIG_SRC="$ROOT_DIR/config/yazi"
GENERATED_SRC="$ROOT_DIR/generated/yazi"
DEST="$HOME/.config/yazi"

"$ROOT_DIR/scripts/generate-yazi-theme.sh"

install -d "$DEST"
install -m 0644 "$CONFIG_SRC/yazi.toml" "$DEST/yazi.toml"
install -m 0644 "$GENERATED_SRC/theme.toml" "$DEST/theme.toml"

if [ -f "$CONFIG_SRC/keymap.toml" ]; then
	install -m 0644 "$CONFIG_SRC/keymap.toml" "$DEST/keymap.toml"
fi

printf 'deepBlack: installed Yazi config to %s\n' "$DEST"

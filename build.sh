#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DWL_DIR="$ROOT/source/dwl"
GENERATED_DIR="$ROOT/generated"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

step() {
  printf '\n[deepBlack] %s\n' "$1"
}

step "Generating shared dwl and Foot assets"
"$ROOT/tools/generate_themes.py"

step "Syncing design tokens into dwl"
install -Dm644 \
  "$GENERATED_DIR/dwl/design_tokens.h" \
  "$DWL_DIR/design_tokens.h"

step "Installing Foot configuration"
install -Dm644 \
  "$GENERATED_DIR/foot/foot.ini" \
  "$CONFIG_HOME/foot/foot.ini"

step "Installing Neovim configuration"
"$ROOT/scripts/install-nvim.sh"

step "Installing Yazi configuration"
"$ROOT/scripts/install-yazi.sh"

step "Generating greetd VT palette"
"$ROOT/scripts/generate-vt-palette.sh" \
  "$GENERATED_DIR/dwl/design_tokens.h" \
  "$GENERATED_DIR/greetd/vtrgb"

step "Installing greetd VT palette"
sudo install -Dm644 \
  "$GENERATED_DIR/greetd/vtrgb" \
  "/usr/local/share/deepblack/vtrgb"

step "Building dwl"
cd "$DWL_DIR"
rm -f config.h
make clean
make

step "Installing dwl"
sudo make install

step "Build completed successfully"

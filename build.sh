#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DWL_DIR="$ROOT/source/dwl"
TOKEN_HEADER="$ROOT/generated/dwl/design_tokens.h"
FOOT_CONFIG_DIR="$HOME/.config/foot"

step() {
  printf "\n[deepBlack] %s\n" "$1"
}

step "Generating design token header"
"$ROOT/tools/generate_themes.py"

step "Syncing design token header into dwl"
cp "$TOKEN_HEADER" "$DWL_DIR/design_tokens.h"

step "Syncing foot theme"
mkdir -p "$FOOT_CONFIG_DIR"
cp "$ROOT/generated/foot/foot.ini" "$FOOT_CONFIG_DIR/foot.ini"

step "Building and installing dwl"
cd "$DWL_DIR"
rm -f config.h
sudo make clean install

step "Build completed successfully"

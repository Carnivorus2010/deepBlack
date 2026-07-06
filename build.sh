#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DWL_DIR="$ROOT/source/dwl"
TOKEN_HEADER="$ROOT/generated/dwl/design_tokens.h"

step() {
  printf "\n[deepBlack] %s\n" "$1"
}

step "Generating design token header"
"$ROOT/tools/generate_themes.py"

step "Syncing design token header into dwl"
cp "$TOKEN_HEADER" "$DWL_DIR/design_tokens.h"

step "Building and installing dwl"
cd "$DWL_DIR"
rm -f config.h
sudo make clean install

step "Build completed successfully"

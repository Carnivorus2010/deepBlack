#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

"$REPO_DIR/tools/generate-nvim-tokens.py"

mkdir -p "$NVIM_DIR"

cp -a "$REPO_DIR/config/nvim/." "$NVIM_DIR/"
cp -a "$REPO_DIR/generated/nvim/." "$NVIM_DIR/"

printf 'installed deepBlack Neovim config to %s\n' "$NVIM_DIR"

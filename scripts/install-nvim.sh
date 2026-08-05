#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

MIN_NVIM_VERSION="0.12.0"
MIN_TREE_SITTER_VERSION="0.26.1"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

version_at_least() {
  current="$1"
  required="$2"

  first="$(
    printf '%s\n%s\n' "$required" "$current" |
      sort -V |
      head -n 1
  )"

  [ "$first" = "$required" ]
}

require_command() {
  command_name="$1"
  package_name="$2"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'error: required command not found: %s\n' "$command_name" >&2
    printf 'install it with:\n\n' >&2
    printf '  sudo pacman -S --needed %s\n\n' "$package_name" >&2
    exit 1
  fi
}

printf '[deepBlack] Checking Neovim dependencies\n'

require_command nvim neovim
require_command git git
require_command curl curl
require_command tar tar
require_command cc base-devel
require_command tree-sitter tree-sitter-cli
require_command sort coreutils

nvim_version="$(
  nvim --version |
    sed -n '1s/^NVIM v//p'
)"

[ -n "$nvim_version" ] ||
  die "could not determine the installed Neovim version"

if ! version_at_least "$nvim_version" "$MIN_NVIM_VERSION"; then
  die "Neovim $MIN_NVIM_VERSION or newer is required; found $nvim_version"
fi

tree_sitter_version="$(
  tree-sitter --version |
    awk 'NR == 1 { print $2 }'
)"

[ -n "$tree_sitter_version" ] ||
  die "could not determine the installed tree-sitter CLI version"

if ! version_at_least \
  "$tree_sitter_version" \
  "$MIN_TREE_SITTER_VERSION"
then
  die "tree-sitter CLI $MIN_TREE_SITTER_VERSION or newer is required; found $tree_sitter_version"
fi

printf '[deepBlack] Generating Neovim tokens\n'
"$REPO_DIR/tools/generate-nvim-tokens.py"

printf '[deepBlack] Installing Neovim configuration\n'
mkdir -p "$NVIM_DIR"

cp -a "$REPO_DIR/config/nvim/." "$NVIM_DIR/"
cp -a "$REPO_DIR/generated/nvim/." "$NVIM_DIR/"

printf '[deepBlack] Restoring locked Neovim plugins\n'
nvim --headless \
  "+Lazy! restore" \
  "+qa"

printf '[deepBlack] Installing Python Tree-sitter parser\n'
nvim --headless \
  -c "lua require('nvim-treesitter').install({ 'python' }):wait(300000)" \
  -c "qa"

printf '[deepBlack] Verifying Python Tree-sitter parser\n'
nvim --headless \
  -c "lua assert(vim.treesitter.language.add('python'), 'Python Tree-sitter parser could not be loaded')" \
  -c "qa"

printf 'installed deepBlack Neovim config to %s\n' "$NVIM_DIR"

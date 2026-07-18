#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DWL_DIR="$ROOT/source/dwl"
GENERATED_DIR="$ROOT/generated"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
MACHINE="${DEEPBLACK_MACHINE:-generic}"

step() {
  printf '\n[deepBlack] %s\n' "$1"
}

usage() {
  cat <<USAGE
Usage: ./build.sh [--machine PROFILE]

Available machine profiles:
$(find "$ROOT/profiles/machines" -maxdepth 1 -type f -name '*.json' \
  -printf '  %f\n' | sed 's/\.json$//')

Examples:
  ./build.sh
  ./build.sh --machine silverbullet
USAGE
}

while (($# > 0)); do
  case "$1" in
    --machine)
      if (($# < 2)); then
        printf 'error: --machine requires a profile name\n' >&2
        exit 2
      fi

      MACHINE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'error: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

PROFILE_FILE="$ROOT/profiles/machines/$MACHINE.json"

if [[ ! -f "$PROFILE_FILE" ]]; then
  printf 'error: machine profile not found: %s\n' "$MACHINE" >&2
  usage >&2
  exit 2
fi

step "Generating machine profile: $MACHINE"
"$ROOT/tools/generate-machine-profile.py" --machine "$MACHINE"

FOOT_FONT_SIZE="$(<"$GENERATED_DIR/machine/foot-font-size")"

step "Generating shared dwl and Foot assets"
DEEPBLACK_FOOT_FONT_SIZE="$FOOT_FONT_SIZE" \
  "$ROOT/tools/generate_themes.py"

step "Syncing generated headers into dwl"
install -Dm644 \
  "$GENERATED_DIR/dwl/design_tokens.h" \
  "$DWL_DIR/design_tokens.h"

install -Dm644 \
  "$GENERATED_DIR/dwl/machine_profile.h" \
  "$DWL_DIR/machine_profile.h"

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

step "Building dwl for machine profile: $MACHINE"
cd "$DWL_DIR"
rm -f config.h
make clean
make

step "Installing dwl"
sudo make install

step "Build completed successfully for machine profile: $MACHINE"

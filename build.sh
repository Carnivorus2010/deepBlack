#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DWL_DIR="$ROOT/source/dwl"
MAKO_DIR="$ROOT/source/mako"
MAKO_BUILD_DIR="$MAKO_DIR/build"
GENERATED_DIR="$ROOT/generated"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_LIBEXEC="$HOME/.local/libexec/deepblack"
USER_SYSTEMD_DIR="$CONFIG_HOME/systemd/user"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DEEPBLACK_DATA_DIR="$DATA_HOME/deepblack"

MACHINE="${DEEPBLACK_MACHINE:-generic}"
FLAVOR="${DEEPBLACK_FLAVOR:-deepblack}"

step() {
  printf '\n[deepBlack] %s\n' "$1"
}

usage() {
  cat <<USAGE
Usage: ./build.sh [--machine PROFILE] [--flavor PROFILE]

Available machine profiles:
$(find "$ROOT/profiles/machines" -maxdepth 1 -type f -name '*.json' \
  -printf '  %f\n' | sed 's/\.json$//')

Available flavor profiles:
$(find "$ROOT/profiles/flavors" -maxdepth 1 -type f -name '*.json' \
  -printf '  %f\n' | sed 's/\.json$//')

Examples:
  ./build.sh
  ./build.sh --machine silverbullet
  ./build.sh --machine silverbullet --flavor nord
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
    --flavor)
      if (($# < 2)); then
        printf 'error: --flavor requires a profile name\n' >&2
        exit 2
      fi

      FLAVOR="$2"
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
FLAVOR_FILE="$ROOT/profiles/flavors/$FLAVOR.json"

if [[ ! -f "$PROFILE_FILE" ]]; then
  printf 'error: machine profile not found: %s\n' "$MACHINE" >&2
  usage >&2
  exit 2
fi

if [[ ! -f "$FLAVOR_FILE" ]]; then
  printf 'error: flavor profile not found: %s\n' "$FLAVOR" >&2
  usage >&2
  exit 2
fi

step "Generating machine profile: $MACHINE"
"$ROOT/tools/generate-machine-profile.py" --machine "$MACHINE"

FOOT_FONT_SIZE="$(<"$GENERATED_DIR/machine/foot-font-size")"

step "Generating shared assets for flavor: $FLAVOR"
DEEPBLACK_FOOT_FONT_SIZE="$FOOT_FONT_SIZE" \
  "$ROOT/tools/generate_themes.py" --flavor "$FLAVOR"

step "Generating GRUB theme source"
python "$ROOT/tools/generate-grub-theme.py" \
  --machine "$MACHINE" \
  --flavor "$FLAVOR"

step "Installing wmenu launcher"
install -Dm755 \
    "$GENERATED_DIR/wmenu/deepblack-wmenu" \
    "$HOME/.local/bin/deepblack-wmenu"

step "Syncing generated Mako tokens"
install -Dm644 \
  "$GENERATED_DIR/mako/deepblack_tokens.h" \
  "$MAKO_DIR/include/deepblack_tokens.h"

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

step "Installing GTK 3 configuration"
install -Dm644 \
  "$GENERATED_DIR/gtk-3.0/settings.ini" \
  "$CONFIG_HOME/gtk-3.0/settings.ini"

install -Dm644 \
  "$GENERATED_DIR/gtk-3.0/gtk.css" \
  "$CONFIG_HOME/gtk-3.0/gtk.css"

step "Installing wallpaper assets"
install -Dm644 \
  "$GENERATED_DIR/wallpaper/background-color" \
  "$DEEPBLACK_DATA_DIR/background-color"

install -Dm644 \
  "$GENERATED_DIR/wallpaper/mode" \
  "$DEEPBLACK_DATA_DIR/wallpaper-mode"

# Never retain an image belonging to a previously selected flavor.
rm -f "$DEEPBLACK_DATA_DIR/wallpaper"

if [[ -f "$GENERATED_DIR/wallpaper/wallpaper" ]]; then
  install -Dm644 \
    "$GENERATED_DIR/wallpaper/wallpaper" \
    "$DEEPBLACK_DATA_DIR/wallpaper"
fi

step "Installing Neovim configuration"
"$ROOT/scripts/install-nvim.sh"

step "Installing Yazi configuration"
"$ROOT/scripts/install-yazi.sh"

step "Installing application launchers"
install -Dm755 \
  "$ROOT/scripts/editor.sh" \
  "$LOCAL_BIN/deepblack-editor"

install -Dm755 \
  "$ROOT/scripts/screenshot.sh" \
  "$LOCAL_BIN/deepblack-screenshot"

install -Dm755 \
  "$ROOT/scripts/files.sh" \
  "$HOME/.local/bin/deepblack-files"

install -Dm755 \
  "$ROOT/scripts/files-gui.sh" \
  "$HOME/.local/bin/deepblack-files-gui"

step "Building Mako for flavor: $FLAVOR"
if [[ ! -f "$MAKO_BUILD_DIR/build.ninja" ]]; then
  meson setup "$MAKO_BUILD_DIR" "$MAKO_DIR"
fi

meson compile -C "$MAKO_BUILD_DIR"

step "Installing Mako runtime"
install -Dm755 \
  "$MAKO_BUILD_DIR/mako" \
  "$LOCAL_LIBEXEC/mako"

install -Dm755 \
  "$MAKO_BUILD_DIR/makoctl" \
  "$LOCAL_BIN/deepblack-makoctl"

install -Dm755 \
  "$ROOT/scripts/deepblack-mako.sh" \
  "$LOCAL_BIN/deepblack-mako"

step "Installing Mako user service"
install -Dm644 \
  "$ROOT/config/systemd/user/deepblack-mako.service" \
  "$USER_SYSTEMD_DIR/deepblack-mako.service"

systemctl --user daemon-reload
systemctl --user enable deepblack-mako.service

step "Generating greetd VT palette"
"$ROOT/scripts/generate-vt-palette.sh" \
  "$GENERATED_DIR/dwl/design_tokens.h" \
  "$GENERATED_DIR/greetd/vtrgb"

step "Installing greetd VT palette"
sudo install -Dm644 \
  "$GENERATED_DIR/greetd/vtrgb" \
  "/usr/local/share/deepblack/vtrgb"

step "Installing session layer"
sudo install -Dm755 \
  "$ROOT/scripts/session.sh" \
  "/usr/local/bin/deepblack-session"

sudo install -Dm755 \
  "$ROOT/scripts/autostart.sh" \
  "/usr/local/bin/deepblack-autostart"

sudo install -Dm755 \
  "$ROOT/scripts/status.sh" \
  "/usr/local/bin/deepblack-status"

sudo install -Dm644 \
  "$ROOT/config/wayland-sessions/deepblack.desktop" \
  "/usr/share/wayland-sessions/deepblack.desktop"

step "Installing greetd integration"
sudo install -Dm755 \
  "$ROOT/scripts/apply-vt-palette.sh" \
  "/usr/local/bin/deepblack-apply-vt-palette"

sudo install -Dm755 \
  "$GENERATED_DIR/greetd/deepblack-greeter" \
  "/usr/local/bin/deepblack-greeter"

sudo install -Dm644 \
  "$ROOT/config/greetd/config.toml" \
  "/etc/greetd/config.toml"

sudo install -Dm644 \
  "$ROOT/config/systemd/greetd.service.d/deepblack-vt-palette.conf" \
  "/etc/systemd/system/greetd.service.d/deepblack-vt-palette.conf"

sudo systemctl daemon-reload

step "Building dwl for machine: $MACHINE, flavor: $FLAVOR"
cd "$DWL_DIR"
rm -f config.h
make clean
make

step "Installing dwl"
sudo make install

if [[ -n "${WAYLAND_DISPLAY:-}" ]] \
    && systemctl --user cat deepblack-mako.service >/dev/null 2>&1; then
  step "Restarting Mako notification service"
  systemctl --user restart deepblack-mako.service
else
  step "Skipping Mako restart outside an active Wayland session"
fi

step "Build completed successfully for machine: $MACHINE, flavor: $FLAVOR"

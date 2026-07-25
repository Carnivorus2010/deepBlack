#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

GENERATOR="$ROOT/tools/generate-grub-theme.py"
GENERATED_DIR="$ROOT/generated/grub"

GRUB_DEFAULT="/etc/default/grub"
GRUB_CONFIG="/boot/grub/grub.cfg"
GRUB_THEME_ROOT="/boot/grub/themes"
BACKUP_ROOT="/var/backups/deepblack/grub"

MACHINE="generic"
FLAVOR="deepblack"
DRY_RUN=false
ASSUME_YES=false

usage() {
    cat <<'EOF'
Usage:
  ./scripts/install-grub-theme.sh [options]

Options:
  --machine NAME   Machine profile to compose
  --flavor NAME    Flavor profile to compose
  --dry-run        Generate and validate without modifying the system
  --yes            Skip the interactive confirmation
  -h, --help       Show this help text

Examples:
  ./scripts/install-grub-theme.sh \
    --machine generic \
    --flavor arc \
    --dry-run

  ./scripts/install-grub-theme.sh \
    --machine silverbullet \
    --flavor nord
EOF
}

die() {
    printf 'deepBlack GRUB: %s\n' "$1" >&2
    exit 1
}

require_value() {
    local option="$1"
    local value="${2:-}"

    if [[ -z "$value" || "$value" == --* ]]; then
        die "$option requires a value"
    fi
}

while (($# > 0)); do
    case "$1" in
        --machine)
            require_value "$1" "${2:-}"
            MACHINE="$2"
            shift 2
            ;;
        --flavor)
            require_value "$1" "${2:-}"
            FLAVOR="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --yes)
            ASSUME_YES=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "unknown option: $1"
            ;;
    esac
done

SAFE_ID_PATTERN='^[a-z0-9][a-z0-9._-]*$'
GFXMODE_PATTERN='^(auto|[0-9]+x[0-9]+(,[0-9]+x[0-9]+)*(,auto)?)$'

[[ "$MACHINE" =~ $SAFE_ID_PATTERN ]] \
    || die "invalid machine identifier: $MACHINE"

[[ "$FLAVOR" =~ $SAFE_ID_PATTERN ]] \
    || die "invalid flavor identifier: $FLAVOR"

[[ -x "$GENERATOR" ]] \
    || die "GRUB generator is missing or not executable: $GENERATOR"

command -v python >/dev/null 2>&1 \
    || die "python is not installed"

command -v grub-mkconfig >/dev/null 2>&1 \
    || die "grub-mkconfig is not installed"

[[ -f "$GRUB_DEFAULT" ]] \
    || die "GRUB defaults file does not exist: $GRUB_DEFAULT"

printf '[deepBlack] Generating GRUB composition: %s, %s\n' \
    "$MACHINE" \
    "$FLAVOR"

python "$GENERATOR" \
    --machine "$MACHINE" \
    --flavor "$FLAVOR"

THEME_SOURCE="$GENERATED_DIR/theme.txt"
THEME_NAME_FILE="$GENERATED_DIR/theme-name"
GFXMODE_FILE="$GENERATED_DIR/gfxmode"

[[ -s "$THEME_SOURCE" ]] \
    || die "generated theme is missing: $THEME_SOURCE"

[[ -s "$THEME_NAME_FILE" ]] \
    || die "generated theme identity is missing: $THEME_NAME_FILE"

[[ -s "$GFXMODE_FILE" ]] \
    || die "generated graphics mode is missing: $GFXMODE_FILE"

IFS= read -r THEME_NAME < "$THEME_NAME_FILE"
IFS= read -r GENERATED_GFXMODE < "$GFXMODE_FILE"

[[ "$THEME_NAME" =~ $SAFE_ID_PATTERN ]] \
    || die "generated theme name is unsafe: $THEME_NAME"

GRUB_GFXMODE="${DEEPBLACK_GRUB_GFXMODE:-$GENERATED_GFXMODE}"

[[ "$GRUB_GFXMODE" =~ $GFXMODE_PATTERN ]] \
    || die "invalid GRUB graphics mode: $GRUB_GFXMODE"

DEST_DIR="$GRUB_THEME_ROOT/$THEME_NAME"
DEST_THEME="$DEST_DIR/theme.txt"

grep -q '^desktop-color: "#[0-9a-fA-F]\{6\}"$' \
    "$THEME_SOURCE" \
    || die "generated theme has no valid desktop color"

grep -q '^+ boot_menu {$' \
    "$THEME_SOURCE" \
    || die "generated theme has no boot menu"

grep -q '^+ progress_bar {$' \
    "$THEME_SOURCE" \
    || die "generated theme has no timeout progress bar"

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

[[ -n "$FONT_SOURCE" ]] \
    || die "DejaVu Sans GRUB font could not be found"

printf '\nGRUB installation plan\n'
printf '  Machine:       %s\n' "$MACHINE"
printf '  Flavor:        %s\n' "$FLAVOR"
printf '  Theme name:    %s\n' "$THEME_NAME"
printf '  Theme source:  %s\n' "$THEME_SOURCE"
printf '  Destination:   %s\n' "$DEST_DIR"
printf '  Graphics mode: %s\n' "$GRUB_GFXMODE"
printf '  GRUB defaults: %s\n' "$GRUB_DEFAULT"
printf '  GRUB config:   %s\n' "$GRUB_CONFIG"
printf '  Font source:   %s\n' "$FONT_SOURCE"

if "$DRY_RUN"; then
    printf '\n[deepBlack] Dry run passed; no system files were changed.\n'
    exit 0
fi

if ! "$ASSUME_YES"; then
    printf '\nThis will modify the active GRUB configuration.\n'
    read -r -p "Type INSTALL to continue: " confirmation

    [[ "$confirmation" == "INSTALL" ]] \
        || die "installation cancelled"
fi

sudo -v

TIMESTAMP="$(date +'%Y%m%d-%H%M%S')"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

WORK_DIR="$(mktemp -d)"
DEFAULT_CANDIDATE="$WORK_DIR/grub.default"
CONFIG_CANDIDATE="$WORK_DIR/grub.cfg"

ROLLBACK_REQUIRED=false
THEME_EXISTED=false
CONFIG_EXISTED=false

cleanup() {
    rm -rf -- "$WORK_DIR"
}

transaction_fail() {
    printf 'deepBlack GRUB: %s\n' "$1" >&2
    return 1
}

rollback() {
    local status="${1:-1}"
    local rollback_failed=false

    # Prevent failures during recovery from recursively invoking rollback.
    trap - ERR INT TERM
    set +e

	if [[ -e "$DEFAULT_CANDIDATE" ]]; then
		sudo install \
			-o root \
			-g root \
			-m600 \
			"$DEFAULT_CANDIDATE" \
			"$BACKUP_DIR/failed-grub.default" \
			|| rollback_failed=true
	fi

	if [[ -e "$CONFIG_CANDIDATE" ]]; then
		sudo install \
			-o root \
			-g root \
			-m600 \
			"$CONFIG_CANDIDATE" \
			"$BACKUP_DIR/failed-grub.cfg" \
			|| rollback_failed=true
	fi

    if "$ROLLBACK_REQUIRED"; then
        printf \
            '\n[deepBlack] Installation failed; restoring GRUB state.\n' \
            >&2

        sudo cp -a \
            "$BACKUP_DIR/grub.default" \
            "$GRUB_DEFAULT" \
            || rollback_failed=true

        if "$CONFIG_EXISTED"; then
            sudo cp -a \
                "$BACKUP_DIR/grub.cfg" \
                "$GRUB_CONFIG" \
                || rollback_failed=true
        else
            sudo rm -f -- "$GRUB_CONFIG" \
                || rollback_failed=true
        fi

        sudo rm -rf -- "$DEST_DIR" \
            || rollback_failed=true

        if "$THEME_EXISTED"; then
            sudo cp -a \
                "$BACKUP_DIR/theme" \
                "$DEST_DIR" \
                || rollback_failed=true
        fi

        if [[ "$rollback_failed" == true ]]; then
            printf \
                '[deepBlack] Rollback encountered errors; inspect backup: %s\n' \
                "$BACKUP_DIR" \
                >&2
        else
            printf \
                '[deepBlack] Rollback completed from %s\n' \
                "$BACKUP_DIR" \
                >&2
        fi
    fi

    exit "$status"
}

trap 'rollback "$?"' ERR
trap 'rollback 130' INT
trap 'rollback 143' TERM
trap cleanup EXIT

printf '\n[deepBlack] Creating backup: %s\n' "$BACKUP_DIR"

sudo install -d -m755 "$BACKUP_DIR"

sudo cp -a \
    "$GRUB_DEFAULT" \
    "$BACKUP_DIR/grub.default"

if sudo test -e "$GRUB_CONFIG"; then
    CONFIG_EXISTED=true

    sudo cp -a \
        "$GRUB_CONFIG" \
        "$BACKUP_DIR/grub.cfg"
fi

if sudo test -d "$DEST_DIR"; then
    THEME_EXISTED=true

    sudo cp -a \
        "$DEST_DIR" \
        "$BACKUP_DIR/theme"
fi

ROLLBACK_REQUIRED=true

cp "$GRUB_DEFAULT" "$DEFAULT_CANDIDATE"

python - \
    "$DEFAULT_CANDIDATE" \
    "$GRUB_GFXMODE" \
    "$DEST_THEME" <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path


path = Path(sys.argv[1])
gfxmode = sys.argv[2]
theme_path = sys.argv[3]

settings = {
    "GRUB_GFXMODE": gfxmode,
    "GRUB_THEME": f'"{theme_path}"',
}

lines = path.read_text(encoding="utf-8").splitlines()
remaining = dict(settings)
result: list[str] = []

pattern = re.compile(
    r"^[ \t]*#?[ \t]*"
    r"(GRUB_GFXMODE|GRUB_THEME)="
)

for line in lines:
    match = pattern.match(line)

    if match:
        key = match.group(1)

        if key in remaining:
            result.append(f"{key}={remaining.pop(key)}")
            continue

    result.append(line)

if remaining:
    if result and result[-1]:
        result.append("")

    for key, value in remaining.items():
        result.append(f"{key}={value}")

path.write_text(
    "\n".join(result) + "\n",
    encoding="utf-8",
)
PY

printf '[deepBlack] Installing generated theme\n'

sudo rm -rf -- "$DEST_DIR"

sudo install -Dm644 \
    "$THEME_SOURCE" \
    "$DEST_THEME"

sudo install -Dm644 \
    "$FONT_SOURCE" \
    "$DEST_DIR/dejavu_16.pf2"

printf '[deepBlack] Installing candidate GRUB defaults\n'

sudo install \
    -o root \
    -g root \
    -m644 \
    "$DEFAULT_CANDIDATE" \
    "$GRUB_DEFAULT"

printf '[deepBlack] Generating candidate grub.cfg\n'

# Let the invoking shell create and own the candidate file.
# grub-mkconfig writes the generated configuration to stdout
# when no --output path is supplied.
: > "$CONFIG_CANDIDATE"

sudo grub-mkconfig > "$CONFIG_CANDIDATE"

if [[ ! -s "$CONFIG_CANDIDATE" ]]; then
    transaction_fail \
        "grub-mkconfig produced an empty configuration"
fi

CANDIDATE_SIZE="$(
    stat -c '%s' "$CONFIG_CANDIDATE"
)"

printf \
    '[deepBlack] Candidate grub.cfg size: %s bytes\n' \
    "$CANDIDATE_SIZE"

if ! grep -q \
    "set theme=.*${THEME_NAME}/theme.txt" \
    "$CONFIG_CANDIDATE"
then
    transaction_fail \
        "candidate grub.cfg does not reference the generated theme"
fi

if command -v grub-script-check >/dev/null 2>&1; then
    printf '[deepBlack] Validating candidate grub.cfg\n'

    sudo grub-script-check \
        "$CONFIG_CANDIDATE"
else
    printf \
        '[deepBlack] grub-script-check unavailable; skipping syntax check\n'
fi

sudo install \
    -o root \
    -g root \
    -m600 \
    "$CONFIG_CANDIDATE" \
    "$GRUB_CONFIG"

ROLLBACK_REQUIRED=false

trap - ERR INT TERM

printf '\n[deepBlack] GRUB theme installed successfully.\n'
printf '  Theme:      %s\n' "$THEME_NAME"
printf '  Theme path: %s\n' "$DEST_THEME"
printf '  GFX mode:   %s\n' "$GRUB_GFXMODE"
printf '  Backup:     %s\n' "$BACKUP_DIR"
printf '\nReboot is required to verify the visual result.\n'

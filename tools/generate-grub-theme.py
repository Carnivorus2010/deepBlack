#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]

MACHINE_DIR = ROOT / "profiles" / "machines"
FLAVOR_DIR = ROOT / "profiles" / "flavors"

OUT_DIR = ROOT / "generated" / "grub"
OUT_THEME = OUT_DIR / "theme.txt"
OUT_NAME = OUT_DIR / "theme-name"
OUT_GFXMODE = OUT_DIR / "gfxmode"

SLUG_PATTERN = re.compile(r"^[a-z0-9][a-z0-9._-]*$")
RGBA_PATTERN = re.compile(r"^0x([0-9a-fA-F]{8})$")
GFXMODE_PATTERN = re.compile(
    r"^(?:auto|[0-9]+x[0-9]+"
    r"(?:,[0-9]+x[0-9]+)*(?:,auto)?)$"
)


def load_object(path: Path) -> dict[str, Any]:
    if not path.is_file():
        raise FileNotFoundError(f"profile does not exist: {path}")

    data = json.loads(path.read_text(encoding="utf-8"))

    if not isinstance(data, dict):
        raise ValueError(f"profile must contain a JSON object: {path}")

    return data


def require_slug(value: Any, label: str) -> str:
    if not isinstance(value, str) or not SLUG_PATTERN.fullmatch(value):
        raise ValueError(f"{label} must be a safe lowercase identifier")

    return value


def require_text(value: Any, label: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{label} must be a non-empty string")

    value = value.strip()

    if any(character in value for character in '"\r\n'):
        raise ValueError(f"{label} contains unsupported characters")

    return value


def resolve_color(
    tokens: dict[str, Any],
    name: str,
    stack: tuple[str, ...] = (),
) -> str:
    if name in stack:
        chain = " -> ".join((*stack, name))
        raise ValueError(f"circular token reference: {chain}")

    if name not in tokens:
        raise ValueError(f"required token is missing: {name}")

    value = tokens[name]

    if not isinstance(value, str):
        raise ValueError(f"token {name} must contain a string")

    match = RGBA_PATTERN.fullmatch(value)

    if match:
        return f"#{match.group(1)[:6].lower()}"

    return resolve_color(tokens, value, (*stack, name))


def generate_theme(machine_name: str, flavor_name: str) -> None:
    machine_path = MACHINE_DIR / f"{machine_name}.json"
    flavor_path = FLAVOR_DIR / f"{flavor_name}.json"

    machine = load_object(machine_path)
    flavor = load_object(flavor_path)

    machine_id = require_slug(machine.get("id"), "machine id")
    flavor_id = require_slug(flavor.get("id"), "flavor id")

    if machine_id != machine_name:
        raise ValueError(
            f"machine profile id {machine_id!r} does not match "
            f"filename {machine_name!r}"
        )

    if flavor_id != flavor_name:
        raise ValueError(
            f"flavor profile id {flavor_id!r} does not match "
            f"filename {flavor_name!r}"
        )

    machine_label = require_text(
        machine.get("grub_label", machine.get("greeter_greeting")),
        "GRUB machine label",
    )

    gfxmode = require_text(
        machine.get("grub_gfxmode", "auto"),
        "GRUB graphics mode",
    )

    if not GFXMODE_PATTERN.fullmatch(gfxmode):
        raise ValueError(
            "grub_gfxmode must be 'auto' or a comma-separated "
            "resolution list such as '1280x800,auto'"
        )

    tokens = flavor.get("tokens")

    if not isinstance(tokens, dict):
        raise ValueError("flavor tokens must be an object")

    surface_00 = resolve_color(tokens, "SURFACE_00")
    surface_01 = resolve_color(tokens, "SURFACE_01")
    text_primary = resolve_color(tokens, "TEXT_PRIMARY")
    text_secondary = resolve_color(tokens, "TEXT_SECONDARY")
    accent_primary = resolve_color(tokens, "ACCENT_PRIMARY")
    border_inactive = resolve_color(tokens, "BORDER_INACTIVE")

    theme_name = f"deepblack-{machine_id}-{flavor_id}"
    title = f"{machine_label.upper()} // {flavor_id.upper()}"

    theme = f"""\
# Auto-generated deepBlack GRUB theme
# Machine: {machine_id}
# Flavor: {flavor_id}
# Do not edit by hand.

desktop-color: "{surface_00}"
message-font: "DejaVu Sans Regular 16"
message-color: "{text_secondary}"
message-bg-color: "{surface_00}"
terminal-font: "DejaVu Sans Regular 16"
terminal-border: "0"

+ label {{
    top = 8%
    left = 10%
    width = 80%
    height = 40
    text = "{title}"
    align = "left"
    font = "DejaVu Sans Regular 16"
    color = "{accent_primary}"
}}

+ boot_menu {{
    left = 10%
    width = 80%
    top = 25%
    height = 45%
    item_font = "DejaVu Sans Regular 16"
    item_color = "{text_primary}"
    selected_item_font = "DejaVu Sans Regular 16"
    selected_item_color = "{accent_primary}"
    icon_height = 0
    icon_width = 0
    item_height = 42
    item_padding = 6
    item_icon_space = 0
    item_spacing = 2
    scrollbar = false
}}

+ progress_bar {{
    id = "__timeout__"
    left = 15%
    top = 80%
    height = 28
    width = 70%
    font = "DejaVu Sans Regular 16"
    text_color = "{text_primary}"
    fg_color = "{accent_primary}"
    bg_color = "{surface_01}"
    border_color = "{border_inactive}"
    text = "@TIMEOUT_NOTIFICATION_LONG@"
}}
"""

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    OUT_THEME.write_text(theme, encoding="utf-8")
    OUT_NAME.write_text(f"{theme_name}\n", encoding="utf-8")
    OUT_GFXMODE.write_text(f"{gfxmode}\n", encoding="utf-8")

    print(f"[deepBlack] generated {OUT_THEME}")
    print(f"[deepBlack] generated {OUT_NAME}")
    print(f"[deepBlack] generated {OUT_GFXMODE}")
    print(
        f"[deepBlack] selected GRUB composition: "
        f"{machine_id}, {flavor_id}"
    )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate a machine- and flavor-aware GRUB theme"
    )

    parser.add_argument(
        "--machine",
        default="generic",
        help="machine profile identifier",
    )

    parser.add_argument(
        "--flavor",
        default="deepblack",
        help="flavor profile identifier",
    )

    args = parser.parse_args()

    try:
        generate_theme(args.machine, args.flavor)
    except (
        FileNotFoundError,
        ValueError,
        json.JSONDecodeError,
    ) as error:
        parser.error(str(error))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

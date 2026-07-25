#!/usr/bin/env python3
"""Generate deepBlack theme assets from a selected flavor profile."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
FLAVORS_DIR = ROOT / "profiles" / "flavors"

OUT_DWL = ROOT / "generated" / "dwl" / "design_tokens.h"
OUT_MAKO = ROOT / "generated" / "mako" / "deepblack_tokens.h"
OUT_FOOT = ROOT / "generated" / "foot" / "foot.ini"
OUT_WMENU = ROOT / "generated" / "wmenu" / "deepblack-wmenu"
OUT_GTK_SETTINGS = ROOT / "generated" / "gtk-3.0" / "settings.ini"
OUT_GTK_CSS = ROOT / "generated" / "gtk-3.0" / "gtk.css"
OUT_WALLPAPER_COLOR = (
    ROOT / "generated" / "wallpaper" / "background-color"
)
OUT_WALLPAPER_MODE = (
    ROOT / "generated" / "wallpaper" / "mode"
)
OUT_WALLPAPER_IMAGE = (
    ROOT / "generated" / "wallpaper" / "wallpaper"
)

REQUIRED_TOKENS = {
    "SURFACE_00",
    "SURFACE_01",
    "SURFACE_02",
    "SURFACE_03",
    "SURFACE_04",
    "TEXT_PRIMARY",
    "TEXT_SECONDARY",
    "TEXT_MUTED",
    "ACCENT_PRIMARY",
    "ACCENT_SECONDARY",
    "ACCENT_DIAGNOSTIC",
    "STATE_SUCCESS",
    "STATE_WARNING",
    "STATE_CRITICAL",
    "BORDER_INACTIVE",
    "BORDER_ACTIVE",
    "BORDER_CRITICAL",
    "SYNTAX_COMMENT",
    "SYNTAX_KEYWORD",
    "SYNTAX_FUNCTION",
    "SYNTAX_STRING",
    "SYNTAX_NUMBER",
    "SYNTAX_TYPE",
    "SYNTAX_CONSTANT",
    "SYNTAX_OPERATOR",
    "SYNTAX_SPECIAL",
    "SYNTAX_VARIABLE",
    "SYNTAX_PROPERTY",
    "SYNTAX_PARAMETER",
    "SYNTAX_PREPROC",
}

GROUPS = {
    "SURFACE": "Surface Tokens",
    "TEXT": "Text Tokens",
    "ACCENT": "Accent Tokens",
    "STATE": "State Tokens",
    "BORDER": "Border Tokens",
    "SYNTAX": "Syntax Tokens",
}

MAKO_TOKENS = [
    "ACCENT_PRIMARY",
    "ACCENT_SECONDARY",
    "ACCENT_DIAGNOSTIC",
    "SURFACE_00",
    "SURFACE_01",
    "SURFACE_02",
    "SURFACE_03",
    "SURFACE_04",
    "TEXT_PRIMARY",
    "TEXT_SECONDARY",
    "TEXT_MUTED",
    "STATE_SUCCESS",
    "STATE_WARNING",
    "STATE_CRITICAL",
    "BORDER_ACTIVE",
    "BORDER_INACTIVE",
    "BORDER_CRITICAL",
]

def group_for(name: str) -> str:
    return name.split("_", 1)[0]


def load_flavor(
    flavor: str,
) -> tuple[
    Path,
    dict[str, str],
    dict[str, Any],
    dict[str, str],
    dict[str, str | None],
]:
    path = FLAVORS_DIR / f"{flavor}.json"

    if not path.is_file():
        available = ", ".join(
            sorted(profile.stem for profile in FLAVORS_DIR.glob("*.json"))
        )
        raise FileNotFoundError(
            f"unknown flavor profile: {flavor}\n"
            f"available flavors: {available or 'none'}"
        )

    profile: dict[str, Any] = json.loads(path.read_text(encoding="utf-8"))

    if profile.get("id") != flavor:
        raise ValueError(
            f"profile id {profile.get('id')!r} does not match filename {flavor!r}"
        )

    tokens = profile.get("tokens")

    if not isinstance(tokens, dict):
        raise ValueError("flavor profile must contain a tokens object")

    missing = REQUIRED_TOKENS.difference(tokens)

    if missing:
        raise ValueError(
            "flavor profile is missing required tokens: "
            + ", ".join(sorted(missing))
        )

    for name, value in tokens.items():
        if not isinstance(name, str) or not isinstance(value, str):
            raise ValueError("token names and values must be strings")

    foot = profile.get("foot", {})
    if not isinstance(foot, dict):
        raise ValueError("flavor foot settings must be an object")

    alpha = foot.get("alpha", 1.0)
    alpha_mode = foot.get("alpha_mode", "default")

    if isinstance(alpha, bool) or not isinstance(alpha, (int, float)):
        raise ValueError("foot alpha must be a number")

    if not 0.0 <= float(alpha) <= 1.0:
        raise ValueError("foot alpha must be between 0.0 and 1.0")

    if alpha_mode not in {"default", "matching", "all"}:
        raise ValueError(
            "foot alpha_mode must be default, matching, or all"
        )

    foot_settings = {
        "alpha": float(alpha),
        "alpha_mode": alpha_mode,
    }

    gtk = profile.get("gtk", {})

    if not isinstance(gtk, dict):
        raise ValueError("flavor gtk settings must be an object")

    gtk_settings = {
        "theme": gtk.get("theme", "Adwaita"),
        "icon_theme": gtk.get("icon_theme", "Adwaita"),
        "font": gtk.get("font", "Sans 10"),
    }

    for name, value in gtk_settings.items():
        if not isinstance(value, str) or not value.strip():
            raise ValueError(
                f"gtk {name} must be a non-empty string"
            )

    wallpaper = profile.get("wallpaper", {})

    if not isinstance(wallpaper, dict):
        raise ValueError("flavor wallpaper settings must be an object")

    wallpaper_asset = wallpaper.get("asset")
    wallpaper_mode = wallpaper.get("mode", "fill")

    if wallpaper_asset is not None:
        if (
            not isinstance(wallpaper_asset, str)
            or not wallpaper_asset.strip()
        ):
            raise ValueError(
                "wallpaper asset must be a non-empty string"
            )

        wallpaper_asset = wallpaper_asset.strip()

        if Path(wallpaper_asset).name != wallpaper_asset:
            raise ValueError(
                "wallpaper asset must be a filename, not a path"
            )

    allowed_modes = {
        "stretch",
        "fill",
        "fit",
        "center",
        "tile",
    }

    if wallpaper_mode not in allowed_modes:
        allowed = ", ".join(sorted(allowed_modes))
        raise ValueError(
            f"wallpaper mode must be one of: {allowed}"
        )

    wallpaper_settings = {
        "asset": wallpaper_asset,
        "mode": wallpaper_mode,
    }

    return (
        path,
        tokens,
        foot_settings,
        gtk_settings,
        wallpaper_settings,
    )

def resolve_token(tokens: dict[str, str], value: str) -> str:
    """Resolve aliases such as BORDER_ACTIVE -> ACCENT_PRIMARY -> hex."""

    seen: set[str] = set()

    while value in tokens:
        if value in seen:
            raise ValueError(f"circular token reference detected: {value}")

        seen.add(value)
        value = tokens[value]

    return value


def c_to_hex(tokens: dict[str, str], name: str) -> str:
    """Convert 0xRRGGBBAA into Foot's RRGGBB format."""

    value = resolve_token(tokens, tokens[name])

    if not value.startswith("0x") or len(value) != 10:
        raise ValueError(
            f"{name} does not resolve to a 0xRRGGBBAA value: {value}"
        )

    return value[2:8]


def generate_dwl(
    tokens: dict[str, str],
    source: Path,
    flavor: str,
) -> None:
    source_name = source.relative_to(ROOT)

    lines = [
        "/*",
        " * ============================================================",
        " * deepBlack Design Tokens",
        " *",
        " * AUTO-GENERATED FILE",
        f" * Flavor: {flavor}",
        f" * Source: {source_name}",
        " *",
        " * DO NOT EDIT THIS FILE DIRECTLY.",
        " * ============================================================",
        " */",
        "",
        "#ifndef DESIGN_TOKENS_H",
        "#define DESIGN_TOKENS_H",
        "",
    ]

    current_group = None

    for name, value in tokens.items():
        group = group_for(name)

        if group != current_group:
            if current_group is not None:
                lines.append("")

            lines.append(
                f"/* {GROUPS.get(group, group.title() + ' Tokens')} */"
            )
            current_group = group

        lines.append(f"#define {name:<20} {value}")

    lines += [
        "",
        "#endif /* DESIGN_TOKENS_H */",
        "",
    ]

    OUT_DWL.parent.mkdir(parents=True, exist_ok=True)
    OUT_DWL.write_text("\n".join(lines), encoding="utf-8")

    print(f"[deepBlack] generated {OUT_DWL}")


def generate_mako(
    tokens: dict[str, str],
    source: Path,
    flavor: str,
) -> None:
    source_name = source.relative_to(ROOT)

    lines = [
        "/*",
        " * ============================================================",
        " * deepBlack Mako Tokens",
        " *",
        " * AUTO-GENERATED FILE",
        f" * Flavor: {flavor}",
        f" * Source: {source_name}",
        " *",
        " * DO NOT EDIT THIS FILE DIRECTLY.",
        " * ============================================================",
        " */",
        "",
        "#ifndef DEEPBLACK_TOKENS_H",
        "#define DEEPBLACK_TOKENS_H",
        "",
    ]

    current_group = None

    for name in MAKO_TOKENS:
        group = group_for(name)

        if group != current_group:
            if current_group is not None:
                lines.append("")

            lines.append(
                f"/* {GROUPS.get(group, group.title() + ' Tokens')} */"
            )
            current_group = group

        value = tokens[name]

        if value in tokens:
            mako_value = f"DB_{value}"
        else:
            resolved = resolve_token(tokens, value)

            if not resolved.startswith("0x") or len(resolved) != 10:
                raise ValueError(
                    f"{name} does not resolve to a 0xRRGGBBAA value: "
                    f"{resolved}"
                )

            mako_value = resolved.upper()

        macro = f"DB_{name}"
        lines.append(f"#define {macro:<28} {mako_value}")

    lines += [
        "",
        "#define DB_STATE_DISABLED            DB_TEXT_MUTED",
        "",
        "#endif /* DEEPBLACK_TOKENS_H */",
        "",
    ]

    OUT_MAKO.parent.mkdir(parents=True, exist_ok=True)
    OUT_MAKO.write_text("\n".join(lines), encoding="utf-8")

    print(f"[deepBlack] generated {OUT_MAKO}")


def generate_foot(
    tokens: dict[str, str],
    source: Path,
    flavor: str,
    foot_font_size: int,
    foot_settings: dict[str, Any],
) -> None:
    source_name = source.relative_to(ROOT)

    lines = [
        f"# Auto-generated from {source_name}",
        f"# Flavor: {flavor}",
        "# Do not edit by hand.",
        "",
        "[main]",
        f"font=JetBrainsMono Nerd Font Mono:size={foot_font_size}",
        "pad=8x8",
        "",
        "[colors-dark]",
        f"alpha={foot_settings['alpha']:.2f}",
        f"alpha-mode={foot_settings['alpha_mode']}",
        f"foreground={c_to_hex(tokens, 'TEXT_PRIMARY')}",
        f"background={c_to_hex(tokens, 'SURFACE_00')}",
        "",
        f"regular0={c_to_hex(tokens, 'SURFACE_00')}",
        f"regular1={c_to_hex(tokens, 'STATE_CRITICAL')}",
        f"regular2={c_to_hex(tokens, 'ACCENT_PRIMARY')}",
        f"regular3={c_to_hex(tokens, 'STATE_WARNING')}",
        f"regular4={c_to_hex(tokens, 'ACCENT_SECONDARY')}",
        f"regular5={c_to_hex(tokens, 'TEXT_SECONDARY')}",
        f"regular6={c_to_hex(tokens, 'ACCENT_DIAGNOSTIC')}",
        f"regular7={c_to_hex(tokens, 'TEXT_PRIMARY')}",
        "",
        f"bright0={c_to_hex(tokens, 'TEXT_MUTED')}",
        f"bright1={c_to_hex(tokens, 'STATE_CRITICAL')}",
        f"bright2={c_to_hex(tokens, 'ACCENT_PRIMARY')}",
        f"bright3={c_to_hex(tokens, 'STATE_WARNING')}",
        f"bright4={c_to_hex(tokens, 'ACCENT_SECONDARY')}",
        f"bright5={c_to_hex(tokens, 'TEXT_SECONDARY')}",
        f"bright6={c_to_hex(tokens, 'ACCENT_DIAGNOSTIC')}",
        f"bright7={c_to_hex(tokens, 'TEXT_PRIMARY')}",
        "",
        f"selection-foreground={c_to_hex(tokens, 'SURFACE_00')}",
        f"selection-background={c_to_hex(tokens, 'ACCENT_PRIMARY')}",
        f"cursor={c_to_hex(tokens, 'SURFACE_00')} "
        f"{c_to_hex(tokens, 'TEXT_SECONDARY')}",
        "",
    ]

    OUT_FOOT.parent.mkdir(parents=True, exist_ok=True)
    OUT_FOOT.write_text("\n".join(lines), encoding="utf-8")

    print(f"[deepBlack] generated {OUT_FOOT}")



def generate_wmenu(
    tokens: dict[str, str],
    source: Path,
    flavor: str,
) -> None:
    source_name = source.relative_to(ROOT)

    lines = [
        "#!/usr/bin/env sh",
        f"# Auto-generated from {source_name}",
        f"# Flavor: {flavor}",
        "# Do not edit by hand.",
        "",
        "exec wmenu-run \\",
        '  -f "JetBrainsMono Nerd Font 12" \\',
        f'  -n "{c_to_hex(tokens, "TEXT_PRIMARY")}" \\',
        f'  -N "{c_to_hex(tokens, "SURFACE_00")}" \\',
        f'  -m "{c_to_hex(tokens, "ACCENT_PRIMARY")}" \\',
        f'  -M "{c_to_hex(tokens, "SURFACE_01")}" \\',
        f'  -s "{c_to_hex(tokens, "SURFACE_00")}" \\',
        f'  -S "{c_to_hex(tokens, "ACCENT_PRIMARY")}" \\',
        '  "$@"',
        "",
    ]

    OUT_WMENU.parent.mkdir(parents=True, exist_ok=True)
    OUT_WMENU.write_text("\n".join(lines), encoding="utf-8")
    OUT_WMENU.chmod(0o755)

    print(f"[deepBlack] generated {OUT_WMENU}")


def generate_gtk(
    tokens: dict[str, str],
    source: Path,
    flavor: str,
    gtk_settings: dict[str, str],
) -> None:
    source_name = source.relative_to(ROOT)

    settings_lines = [
        f"# Auto-generated from {source_name}",
        f"# Flavor: {flavor}",
        "# Do not edit by hand.",
        "",
        "[Settings]",
        f"gtk-theme-name={gtk_settings['theme']}",
        f"gtk-icon-theme-name={gtk_settings['icon_theme']}",
        f"gtk-font-name={gtk_settings['font']}",
        "gtk-application-prefer-dark-theme=1",
        "",
    ]

    css_lines = [
        f"/* Auto-generated from {source_name} */",
        f"/* Flavor: {flavor} */",
        "/* Do not edit by hand. */",
        "",
        f"@define-color db_surface_00 #{c_to_hex(tokens, 'SURFACE_00')};",
        f"@define-color db_surface_01 #{c_to_hex(tokens, 'SURFACE_01')};",
        f"@define-color db_surface_02 #{c_to_hex(tokens, 'SURFACE_02')};",
        "",
        f"@define-color db_text_primary #{c_to_hex(tokens, 'TEXT_PRIMARY')};",
        f"@define-color db_text_secondary #{c_to_hex(tokens, 'TEXT_SECONDARY')};",
        f"@define-color db_text_muted #{c_to_hex(tokens, 'TEXT_MUTED')};",
        "",
        f"@define-color db_accent_primary #{c_to_hex(tokens, 'ACCENT_PRIMARY')};",
        f"@define-color db_border_inactive #{c_to_hex(tokens, 'BORDER_INACTIVE')};",
        "",
        "/* Primary application surfaces */",
        "window,",
        "dialog,",
        ".background {",
        "    background-color: @db_surface_00;",
        "    color: @db_text_primary;",
        "}",
        "",
        "/* Main file views */",
        ".view,",
        "iconview,",
        "treeview,",
        "treeview.view {",
        "    background-color: @db_surface_00;",
        "    color: @db_text_primary;",
        "}",
        "",
        "/* Persistent interface regions */",
        "menubar,",
        "toolbar,",
        "statusbar,",
        ".sidebar,",
        "placessidebar {",
        "    background-color: @db_surface_01;",
        "    color: @db_text_secondary;",
        "    border-color: @db_border_inactive;",
        "}",
        "",
        "/* Compact toolbar and path controls */",
        "toolbar {",
        "    padding: 1px;",
        "}",
        "",
        "toolbar button,",
        ".path-bar button {",
        "    min-width: 24px;",
        "    min-height: 24px;",
        "    padding: 2px 5px;",
        "    background-color: @db_surface_01;",
        "    color: @db_text_primary;",
        "    border-color: @db_border_inactive;",
        "}",
        "",
        "entry {",
        "    min-height: 24px;",
        "    padding: 2px 6px;",
        "    background-color: @db_surface_02;",
        "    color: @db_text_primary;",
        "    border-color: @db_border_inactive;",
        "}",
        "",
        "/* Sidebar density */",
        "placessidebar row,",
        ".sidebar row {",
        "    min-height: 26px;",
        "    padding: 1px 5px;",
        "    color: @db_text_secondary;",
        "}",
        "",
        "/* Main-view selection */",
        ".view:selected,",
        "iconview:selected,",
        "treeview:selected,",
        "treeview.view:selected {",
        "    background-color: @db_accent_primary;",
        "    color: @db_surface_00;",
        "}",
        "",
        "/* Active sidebar location */",
        "placessidebar row:selected,",
        ".sidebar row:selected {",
        "    background-color: @db_surface_02;",
        "    color: @db_accent_primary;",
        "    border-left: 3px solid @db_accent_primary;",
        "}",
        "",
        "/* Passive and disabled information */",
        "label:disabled,",
        "button:disabled,",
        "row:disabled {",
        "    color: @db_text_muted;",
        "}",
        "",
        "separator {",
        "    background-color: @db_border_inactive;",
        "    color: @db_border_inactive;",
        "}",
        "",
        "statusbar {",
        "    padding: 1px 4px;",
        "    color: @db_text_muted;",
        "}",
        "",
    ]

    OUT_GTK_SETTINGS.parent.mkdir(parents=True, exist_ok=True)

    OUT_GTK_SETTINGS.write_text(
        "\n".join(settings_lines),
        encoding="utf-8",
    )

    OUT_GTK_CSS.write_text(
        "\n".join(css_lines),
        encoding="utf-8",
    )

    print(f"[deepBlack] generated {OUT_GTK_SETTINGS}")
    print(f"[deepBlack] generated {OUT_GTK_CSS}")


def generate_wallpaper(
    tokens: dict[str, str],
    source: Path,
    flavor: str,
    wallpaper_settings: dict[str, str | None],
) -> None:
    output_dir = OUT_WALLPAPER_COLOR.parent
    output_dir.mkdir(parents=True, exist_ok=True)

    background_color = c_to_hex(tokens, "SURFACE_00")
    wallpaper_mode = wallpaper_settings["mode"]

    if not isinstance(wallpaper_mode, str):
        raise ValueError("wallpaper mode must be a string")

    OUT_WALLPAPER_COLOR.write_text(
        f"{background_color}\n",
        encoding="utf-8",
    )

    OUT_WALLPAPER_MODE.write_text(
        f"{wallpaper_mode}\n",
        encoding="utf-8",
    )

    # Prevent an image from a previous flavor generation surviving
    # when the newly selected flavor intentionally uses solid color.
    OUT_WALLPAPER_IMAGE.unlink(missing_ok=True)

    wallpaper_asset = wallpaper_settings["asset"]

    if wallpaper_asset is not None:
        if not isinstance(wallpaper_asset, str):
            raise ValueError("wallpaper asset must be a string")

        asset_path = (
            ROOT
            / "assets"
            / "wallpapers"
            / wallpaper_asset
        )

        if not asset_path.is_file():
            raise FileNotFoundError(
                f"wallpaper asset does not exist: {asset_path}"
            )

        OUT_WALLPAPER_IMAGE.write_bytes(
            asset_path.read_bytes()
        )

        print(
            f"[deepBlack] generated "
            f"{OUT_WALLPAPER_IMAGE}"
        )
    else:
        print(
            f"[deepBlack] flavor {flavor} uses "
            f"solid background #{background_color}"
        )

    print(f"[deepBlack] generated {OUT_WALLPAPER_COLOR}")
    print(f"[deepBlack] generated {OUT_WALLPAPER_MODE}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--flavor",
        default="deepblack",
        help="flavor profile name from profiles/flavors",
    )
    args = parser.parse_args()

    try:
        (
            source,
            tokens,
            foot_settings,
            gtk_settings,
            wallpaper_settings,
        ) = load_flavor(args.flavor)


        foot_font_size = int(
            os.environ.get("DEEPBLACK_FOOT_FONT_SIZE", "12")
        )

        if not 6 <= foot_font_size <= 32:
            raise ValueError(
                "DEEPBLACK_FOOT_FONT_SIZE must be between 6 and 32"
            )

        generate_dwl(tokens, source, args.flavor)
        generate_mako(tokens, source, args.flavor)
        generate_foot(
            tokens,
            source,
            args.flavor,
            foot_font_size,
            foot_settings,
        )
        generate_wmenu(tokens, source, args.flavor)
        generate_gtk(
            tokens,
            source,
            args.flavor,
            gtk_settings,
        )
        generate_wallpaper(
            tokens,
            source,
            args.flavor,
            wallpaper_settings,
        )
    except (
        FileNotFoundError,
        ValueError,
        json.JSONDecodeError,
    ) as error:
        parser.error(str(error))

    print(f"[deepBlack] selected flavor profile: {args.flavor}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

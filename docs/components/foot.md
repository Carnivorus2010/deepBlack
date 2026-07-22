# deepBlack Foot Component

Foot is the terminal surface of the deepBlack operating environment.

It provides the base material for terminal sessions, Neovim, Yazi, and other command-line workflows launched through the compositor.

## Design Role

Foot acts as a primary work surface.

- HIERARCHY_01 — primary work
- MATERIAL_BASE — terminal background
- TEXT_PRIMARY — active terminal content
- TEXT_SECONDARY — supporting information
- TEXT_MUTED — low-priority structure
- ACCENT_PRIMARY — cursor and active emphasis

The terminal should remain visually quiet so command output and editor content retain priority.

## Source Inputs

Foot configuration is generated rather than maintained as a standalone tracked theme file.

Machine-specific input comes from:

    profiles/machines/<machine>.json

Flavor-specific input comes from:

    profiles/flavors/<flavor>.json

The machine profile controls values such as the terminal font size.

The flavor profile controls semantic colors, cursor colors, and opacity behavior.

## Generation Flow

```text
profiles/machines/<machine>.json
profiles/flavors/<flavor>.json
  -> tools/generate-machine-profile.py
  -> tools/generate_themes.py
  -> generated/foot/foot.ini
  -> ~/.config/foot/foot.ini
```

The generated file should not be edited by hand.

## Runtime Role

Foot is used for:

- the primary terminal
- Neovim through `scripts/editor.sh`
- Yazi through `scripts/files.sh`
- other terminal-native project workflows

The compositor launches the primary terminal with:

    MOD + Return

Neovim launches with:

    MOD + h

Yazi launches with:

    MOD + e

The actual modifier is supplied by the selected machine profile.

## Build Examples

Generic deepBlack:

    ./build.sh

SilverBullet Nord:

    ./build.sh --machine silverbullet --flavor nord

The build generates and installs:

    generated/foot/foot.ini
        -> ~/.config/foot/foot.ini

## Current SilverBullet Behavior

The SilverBullet profile supplies a larger Foot font appropriate for the Retina display and 1.75 compositor scale.

The Nord flavor supplies the terminal color system and current opacity behavior.

Machine-specific font sizing remains separate from flavor-specific visual tokens.

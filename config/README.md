# deepBlack Config

Configuration sources for user-facing deepBlack components.

These files are source configuration, not generated output.

### greetd

`config/greetd/config.toml` is the tracked source template for the deepBlack greetd
login/session configuration.

It is intended to be installed to:

    /etc/greetd/config.toml

This file should launch the installed deepBlack session command rather than a user-local
repository path.

### Wayland Sessions

`config/wayland-sessions/deepblack.desktop` defines the deepBlack Wayland session entry.

It is intended to be installed to:

    /usr/share/wayland-sessions/deepblack.desktop

### systemd

`config/systemd/greetd.service.d/deepblack-vt-palette.conf` is the tracked source template
for the greetd systemd drop-in.

It is intended to be installed to:

    /etc/systemd/system/greetd.service.d/deepblack-vt-palette.conf

The drop-in applies the deepBlack virtual terminal palette before greetd starts.

## Neovim

Neovim is the primary text editor component for deepBlack.

Source configuration:

    config/nvim/

Installed by:

    scripts/install-nvim.sh

Launch keybind:

    MOD + h / ALT+h

Design role:

- Hierarchy: HIERARCHY_01 / Primary Work
- Material: MATERIAL_BASE through Foot
- Typography: TYPE_DIAGNOSTIC / TYPE_BODY depending on content
- Motion: MOTION_INSTANT for text input
- Color: generated from generated/dwl/design_tokens.h

ACCENT_PRIMARY is reserved for cursor emphasis, current line number, selections,
and active syntax states. It should not become decoration.

## Yazi

Yazi is the primary file manager component for deepBlack.

Source configuration:

    config/yazi/

Installed by:

    scripts/install-yazi.sh

Launch keybind:

    MOD + e / ALT+e

Design role:

- Hierarchy: HIERARCHY_01 / Primary Work
- Material: MATERIAL_BASE through Foot
- Typography: TYPE_DIAGNOSTIC / TYPE_BODY depending on content
- Motion: MOTION_INSTANT for navigation and selection
- Color: generated from generated/dwl/design_tokens.h

The generated Yazi theme is written to:

    generated/yazi/theme.toml

Generated theme output should not be edited by hand.

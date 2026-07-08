# deepBlack Config

Configuration sources for user-facing deepBlack components.

These files are source configuration, not generated output.

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

ACCENT_PRIMARY is reserved for cursor emphasis, current line number, selections, and active syntax states. It should not become decoration.

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

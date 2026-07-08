# scripts

Part of the deepBlack operating environment project.

Scripts provide stable launch and install surfaces between dwl keybinds, generated tokens, and user configuration directories.

## Launchers

### session.sh

Starts the deepBlack Wayland session.

This is the canonical session entry point used by the login/session layer.

For greetd usage, it is intended to be installed as:

    /usr/local/bin/deepblack-session

### editor.sh

Launches Neovim inside Foot as the deepBlack editor surface.

Used by:

    MOD + h / ALT+h

### files.sh

Launches Yazi inside Foot as the deepBlack file manager surface.

Used by:

    MOD + e / ALT+e

### screenshot.sh

Runs the grim/slurp screenshot workflow.

Used by:

    MOD + s / ALT+s

### deepblack-mako.sh

Launches the source-built deepBlack Mako notification daemon.

## Installers

### install-nvim.sh

Regenerates Neovim token configuration and installs Neovim config into:

    ~/.config/nvim/

### install-yazi.sh

Regenerates the Yazi theme and installs Yazi config into:

    ~/.config/yazi/

## Generators

### generate-yazi-theme.sh

Reads:

    generated/dwl/design_tokens.h

Writes:

    generated/yazi/theme.toml

The generated file should not be edited by hand.

# scripts

Part of the deepBlack operating environment project.

Scripts provide stable launch and install surfaces between dwl keybinds, generated tokens, and user configuration directories.

## Launchers

### session.sh

Starts the deepBlack Wayland session.

This is the canonical session entry point used by the login/session layer.

For greetd usage, it is intended to be installed as:

    /usr/local/bin/deepblack-session

### autostart.sh

Starts session background services for the deepBlack dwl session.

Current responsibilities:

    swaybg wallpaper startup

For greetd usage, it is intended to be installed as:

    /usr/local/bin/deepblack-autostart

### status.sh

Provides status text to the deepBlack dwl bar.

It uses `slstatus -s` when available and falls back to a simple date/time loop.

For greetd usage, it is intended to be installed as:

    /usr/local/bin/deepblack-status

### apply-vt-palette.sh

Applies the generated deepBlack virtual terminal color palette using `setvtrgb`.

For greetd usage, it is intended to be installed as:

    /usr/local/bin/deepblack-apply-vt-palette

This helper is safe-failing. If `setvtrgb` or the palette file is unavailable, it exits
without blocking login.

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

### generate-vt-palette.sh

Reads:

    generated/dwl/design_tokens.h

Writes:

    generated/greetd/vtrgb

The generated palette maps deepBlack semantic color tokens onto the Linux virtual
terminal ANSI color slots used by tuigreet.

The generated file should not be edited by hand.

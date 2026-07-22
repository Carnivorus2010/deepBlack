# scripts

Part of the deepBlack operating environment project.

Scripts provide stable launch, generation, and installation surfaces between machine profiles, flavor tokens, dwl, greetd, and user configuration directories.

## Session Layer

### session.sh

Starts the deepBlack Wayland session.

It prepares the Wayland environment and launches dwl through the installed status and autostart helpers.

Installed as:

    /usr/local/bin/deepblack-session

### autostart.sh

Starts background services for the deepBlack dwl session.

Current responsibilities include wallpaper startup through `swaybg`.

Installed as:

    /usr/local/bin/deepblack-autostart

### status.sh

Provides status text to the dwl bar.

When `slstatus` is installed, it executes:

    slstatus -s

Otherwise the built-in fallback reports:

- battery percentage and charge state from the first available `/sys/class/power_supply/BAT*` device
- current date and time
- date and time only when the expected battery interface is unavailable

Installed as:

    /usr/local/bin/deepblack-status

### apply-vt-palette.sh

Applies the generated virtual-terminal palette using `setvtrgb`.

The default managed palette path is:

    /usr/local/share/deepblack/vtrgb

Installed as:

    /usr/local/bin/deepblack-apply-vt-palette

The helper is safe-failing. Missing palette support must not prevent greetd from starting.

## Application Launchers

### editor.sh

Launches Neovim inside Foot as the deepBlack editor surface.

Used by:

    MOD + h

### files.sh

Launches Yazi inside Foot as the deepBlack file manager surface.

Used by:

    MOD + e

### screenshot.sh

Runs the grim/slurp screenshot workflow.

Used by:

    MOD + s

### deepblack-mako.sh

Launches the source-built deepBlack Mako notification daemon.

## Installers

### install-nvim.sh

Regenerates Neovim token configuration and installs the source configuration into:

    ~/.config/nvim/

### install-yazi.sh

Regenerates the Yazi theme and installs the source configuration into:

    ~/.config/yazi/

### install-grub-theme.sh

Installs a tracked GRUB theme explicitly.

Default theme:

    config/grub/themes/silverbullet-nord/

Default installation:

    ./scripts/install-grub-theme.sh

The installer:

- validates the theme name and source
- creates `/etc/default/grub.deepblack-backup` when absent
- installs the theme beneath `/boot/grub/themes/`
- installs the required GRUB font
- sets `GRUB_THEME`
- sets `GRUB_GFXMODE`
- regenerates `/boot/grub/grub.cfg`

The default graphics mode is:

    1280x800,auto

Override it with:

    DEEPBLACK_GRUB_GFXMODE=1920x1080,auto ./scripts/install-grub-theme.sh

GRUB changes are intentionally separate from the normal build.

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

The generator maps semantic flavor roles onto the Linux virtual-terminal ANSI slots used by tuigreet.

The generated file should not be edited by hand.

## Build Integration

The root build performs session and greetd installation automatically:

    ./build.sh --machine silverbullet --flavor nord

The compatibility entry point forwards all arguments:

    ./sync.sh --machine silverbullet --flavor nord

Generated output and transient dwl headers can be removed with:

    ./clean.sh

The build installs session files and reloads systemd configuration, but it does not restart greetd, enable greetd, modify GRUB, or reboot.

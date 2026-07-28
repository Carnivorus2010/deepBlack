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

Current responsibilities include:

- importing Wayland and D-Bus session variables into the selected user-service manager
- starting or restarting the managed Mako service
- wallpaper startup through `swaybg`

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

### init-backend.sh

Provides backend-neutral user-service operations for systemd and dinit.

Responsibilities include:

- detecting the active or explicitly selected backend
- locating the backend-specific user-service directory
- importing graphical session environment variables
- enabling, starting, and restarting managed user services

Installed as:

    ~/.local/libexec/deepblack/init-backend.sh

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

Launches the installed source-built deepBlack Mako notification daemon
independently of the selected service manager.

## Installers

### install-nvim.sh

Regenerates Neovim token configuration and installs the source configuration into:

    ~/.config/nvim/

### install-yazi.sh

Regenerates the Yazi theme and installs the source configuration into:

    ~/.config/yazi/

### install-grub-theme.sh

Generates, validates, and installs a GRUB theme composed from a selected
machine profile and flavor profile.

Usage:

    ./scripts/install-grub-theme.sh [options]

Options:

    --machine NAME   Machine profile to compose
    --flavor NAME    Flavor profile to compose
    --dry-run        Generate and validate without modifying the system
    --yes            Skip the interactive confirmation
    -h, --help       Show usage information

The selected profiles are read from:

    profiles/machines/<machine>.json
    profiles/flavors/<flavor>.json

Generated GRUB assets are written beneath:

    generated/grub/

Before installing a theme, perform a dry run:

    ./scripts/install-grub-theme.sh \
      --machine silverbullet \
      --flavor nord \
      --dry-run

Install the SilverBullet Nord theme:

    ./scripts/install-grub-theme.sh \
      --machine silverbullet \
      --flavor nord

Install the generic ARC theme:

    ./scripts/install-grub-theme.sh \
      --machine generic \
      --flavor arc

Unless `--yes` is supplied, the installer displays its installation plan and
requires the user to type `INSTALL` before modifying the system.

The installer:

- generates the machine- and flavor-aware GRUB composition
- validates the generated theme and graphics mode
- creates a timestamped backup beneath `/var/backups/deepblack/grub/`
- installs the theme beneath `/boot/grub/themes/`
- installs the required GRUB font
- updates `GRUB_THEME` in `/etc/default/grub`
- updates `GRUB_GFXMODE` in `/etc/default/grub`
- generates and validates a candidate `grub.cfg`
- installs the validated configuration as `/boot/grub/grub.cfg`
- restores the previous GRUB state automatically if installation fails

The graphics mode normally comes from the selected machine profile. It can be
overridden for one installation with:

    DEEPBLACK_GRUB_GFXMODE=1920x1080,auto \
      ./scripts/install-grub-theme.sh \
        --machine silverbullet \
        --flavor nord

GRUB installation is intentionally separate from the normal deepBlack build.
A reboot is required to verify the visual result.

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

The root build performs session, user-service, and greetd integration
automatically.

Arch with systemd:

    ./build.sh \
      --machine generic \
      --flavor carbon \
      --init-backend systemd

SilverBullet with dinit:

    ./build.sh \
      --machine silverbullet \
      --flavor nord \
      --init-backend dinit

The compatibility entry point forwards all arguments:

    ./sync.sh \
      --machine silverbullet \
      --flavor nord \
      --init-backend dinit

Generated output and transient dwl headers can be removed with:

    ./clean.sh

The build installs and enables the selected Mako user service and installs the
matching VT-palette integration. It does not restart greetd, enable greetd,
modify GRUB, or reboot.

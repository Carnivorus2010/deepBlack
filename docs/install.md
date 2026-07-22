# Installation Notes

This document records the current deepBlack install and dependency model.

It is not a fully automated installer yet.

The goal is to make a fresh clone understandable and recoverable.


## Repository Layout

Important source directories:

    source/dwl/
    source/mako/
    config/nvim/
    config/yazi/
    config/greetd/
    config/grub/
    config/wayland-sessions/
    config/systemd/
    profiles/machines/
    profiles/flavors/
    scripts/
    tools/

Generated output is written beneath:

    generated/

Source configuration and profiles are tracked.

Generated output and transient dwl headers can be recreated and should not be edited by hand.

## Core Package Groups

### Base Build Tools

Required for building source components.

    base-devel
    git
    meson
    ninja
    pkgconf


### Wayland / Compositor Stack

Required for the dwl compositor layer on Arch Linux:

    wayland
    wayland-protocols
    wlroots0.20
    libinput
    libxkbcommon
    fcft
    tllist

The project targets the Arch `wlroots0.20` compatibility package rather than the unversioned `wlroots` package.

Optional XWayland support:

    xorg-xwayland

### Runtime Components

Required for the current deepBlack workflow.

    foot
    wmenu
    grim
    slurp
    neovim
    wl-clipboard
    yazi
    chromium
    bitwarden-desktop

### Login Packages

Required for the greetd-based login/session flow.

    greetd
    greetd-tuigreet

### Mako Source Build Support

Required for the vendored Mako notification daemon.

    meson
    ninja
    scdoc
    cairo
    pango
    gdk-pixbuf2
    dbus

Mako source lives at:

    source/mako/

deepBlack launch wrapper:

    scripts/deepblack-mako.sh

Project-specific Mako notes:

    source/mako/DEEPBLACK_UPSTREAM.md

## Optional Packages

### GUI File Manager Fallback

Yazi is the primary deepBlack file manager.

Thunar may be installed as an optional GUI fallback:

    thunar

This is not the primary file manager path.


### Status Provider

The deepBlack session status helper uses `slstatus -s` when available.

Without `slstatus`, the built-in fallback reports:

- battery percentage and state from the first available `/sys/class/power_supply/BAT*` device
- current date and time
- date and time only on systems without the expected battery interface


## Component Install Flow

### Machine and Flavor Profiles

Machine profiles describe hardware-specific behavior:

    profiles/machines/generic.json
    profiles/machines/silverbullet.json

Current machine-profile responsibilities include:

- monitor names and scaling
- master-area defaults
- natural scrolling
- compositor modifier key
- Foot font size
- greeter identity

Flavor profiles describe the visual implementation:

    profiles/flavors/deepblack.json
    profiles/flavors/nord.json

Current flavor-profile responsibilities include:

- semantic color tokens
- syntax colors
- border and state colors
- Foot opacity behavior
- generated VT palette behavior

Machine and flavor are selected independently.

Default generic deepBlack build:

    ./build.sh

SilverBullet Nord build:

    ./build.sh --machine silverbullet --flavor nord

The compatibility entry point forwards all arguments to `build.sh`:

    ./sync.sh --machine silverbullet --flavor nord

Environment variables may also provide defaults:

    DEEPBLACK_MACHINE=silverbullet
    DEEPBLACK_FLAVOR=nord

Explicit command-line arguments take precedence.

### Build Responsibilities

The normal build performs the following work:

1. Generate the selected machine profile.
2. Generate the selected flavor assets.
3. Synchronize transient headers into `source/dwl/`.
4. Install Foot configuration.
5. Generate and install Neovim configuration.
6. Generate and install Yazi configuration.
7. Generate and install the greetd VT palette.
8. Install the session and greetd integration files.
9. Build and install dwl.

The build runs `systemctl daemon-reload` after installing the greetd drop-in.

It intentionally does not:

- restart greetd
- enable greetd
- modify GRUB
- reboot the machine

Those actions remain explicit.

### dwl

Primary source configuration:

    source/dwl/config.def.h

Generated build inputs:

    generated/dwl/design_tokens.h
    generated/dwl/machine_profile.h

Transient compile copies:

    source/dwl/design_tokens.h
    source/dwl/machine_profile.h

The transient copies are ignored by Git and are recreated by the build.

Generated compositor configuration:

    source/dwl/config.h

None of these generated files should be treated as source configuration.

Remove generated assets and transient headers with:

    ./clean.sh

Recreate them through the selected build:

    ./sync.sh --machine silverbullet --flavor nord

### Login / Session Startup

Source session files:

    scripts/session.sh
    scripts/autostart.sh
    scripts/status.sh
    scripts/apply-vt-palette.sh
    scripts/generate-vt-palette.sh
    config/greetd/config.toml
    config/wayland-sessions/deepblack.desktop
    config/systemd/greetd.service.d/deepblack-vt-palette.conf

The machine generator writes:

    generated/greetd/deepblack-greeter

The flavor pipeline writes:

    generated/greetd/vtrgb

Expected installed paths:

    /usr/local/bin/deepblack-session
    /usr/local/bin/deepblack-autostart
    /usr/local/bin/deepblack-status
    /usr/local/bin/deepblack-greeter
    /usr/local/bin/deepblack-apply-vt-palette
    /usr/local/share/deepblack/vtrgb
    /etc/greetd/config.toml
    /usr/share/wayland-sessions/deepblack.desktop
    /etc/systemd/system/greetd.service.d/deepblack-vt-palette.conf

The intended session flow is:

    greetd.service
        -> deepblack-apply-vt-palette
        -> greetd
        -> deepblack-greeter
        -> deepblack-session
        -> deepblack-status | dwl -s deepblack-autostart

The active greeter uses `/usr/local/share/deepblack/vtrgb` through the systemd pre-start helper.

Machine-local `/etc/vtrgb` handling is not part of the managed session path.

Before enabling or restarting greetd, confirm these files exist and are executable:

    /usr/local/bin/deepblack-session
    /usr/local/bin/deepblack-greeter
    /usr/local/bin/deepblack-apply-vt-palette

Keep a fallback TTY available while testing login changes.

### GRUB Theme

The tested SilverBullet Nord GRUB source is tracked at:

    config/grub/themes/silverbullet-nord/theme.txt

Install it explicitly with:

    ./scripts/install-grub-theme.sh

The installer:

- validates the requested theme
- creates `/etc/default/grub.deepblack-backup` if absent
- installs the theme under `/boot/grub/themes/`
- installs the required GRUB font
- sets `GRUB_THEME`
- sets `GRUB_GFXMODE`
- regenerates `/boot/grub/grub.cfg`

The default graphics mode is:

    1280x800,auto

Override it for another display with:

    DEEPBLACK_GRUB_GFXMODE=1920x1080,auto ./scripts/install-grub-theme.sh

GRUB installation remains separate from `build.sh` because bootloader changes should be deliberate.

### Neovim

Source configuration:

    config/nvim/

Install script:

    scripts/install-nvim.sh

Token flow:

    generated/dwl/design_tokens.h
        -> tools/generate-nvim-tokens.py
        -> generated/nvim/
        -> ~/.config/nvim/

Launch keybind:

    MOD + h

### Yazi

Source configuration:

    config/yazi/

Install script:

    scripts/install-yazi.sh

Token flow:

    generated/dwl/design_tokens.h
        -> scripts/generate-yazi-theme.sh
        -> generated/yazi/theme.toml
        -> ~/.config/yazi/

Launch keybind:

    MOD + e

### Screenshots

Screenshot workflow:

    scripts/screenshot.sh

Runtime tools:

    grim
    slurp

Launch keybind:

    MOD + s

## Fresh Clone Checklist

After cloning the repository:

1. Install the required Arch packages.
2. Select the intended machine and flavor profiles.
3. Run the complete build.

Generic deepBlack:

    ./build.sh

SilverBullet Nord:

    ./build.sh --machine silverbullet --flavor nord

4. Verify the installed session files before enabling or restarting greetd.
5. Test login and logout behavior with a fallback TTY available.
6. Install a GRUB theme separately when required:

       ./scripts/install-grub-theme.sh

7. Build and configure the vendored Mako daemon when needed.
8. Verify the primary launch keybinds for the selected machine profile.

Common actions:

    MOD + Return  terminal
    MOD + d       launcher
    MOD + h       Neovim
    MOD + e       Yazi
    MOD + s       screenshot

The actual modifier is supplied by the machine profile.

For example:

    generic       -> ALT
    silverbullet  -> LOGO / Command

## Generated Files

Generated files should not be edited by hand.

Important generated paths:

    generated/dwl/design_tokens.h
    generated/dwl/machine_profile.h
    generated/foot/foot.ini
    generated/greetd/deepblack-greeter
    generated/greetd/vtrgb
    generated/machine/foot-font-size
    generated/nvim/
    generated/wmenu/
    generated/yazi/theme.toml

Transient dwl compile inputs:

    source/dwl/design_tokens.h
    source/dwl/machine_profile.h
    source/dwl/config.h

`generated/` and the transient headers are excluded from version control.

Clean them with:

    ./clean.sh

Regenerate them with an explicit profile selection:

    ./sync.sh --machine silverbullet --flavor nord

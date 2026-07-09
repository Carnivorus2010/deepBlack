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
    config/wayland-sessions/
    config/systemd/
    scripts/
    generated/

Source configuration is tracked.

Generated output can be recreated.

## Core Package Groups

### Base Build Tools

Required for building source components.

    base-devel
    git
    meson
    ninja
    pkgconf

### Wayland / Compositor Stack

Required for the dwl compositor layer.

    wayland
    wayland-protocols
    wlroots
    libinput
    libxkbcommon

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

If `slstatus` is not available, it falls back to a simple date/time loop.

## Component Install Flow

### dwl

Primary source configuration:

    source/dwl/config.def.h

After changing dwl configuration, rebuild and reinstall dwl using the project’s normal dwl build workflow.

Generated build output:

    source/dwl/config.h

The generated config.h file should not be treated as the source of truth.

### Login / Session Startup

Source session launcher:

    scripts/session.sh

Source session helpers:

    scripts/autostart.sh
    scripts/status.sh

Source virtual terminal palette helpers:

    scripts/generate-vt-palette.sh
    scripts/apply-vt-palette.sh

Source greetd configuration:

    config/greetd/config.toml

Source Wayland session entry:

    config/wayland-sessions/deepblack.desktop

Source systemd drop-in:

    config/systemd/greetd.service.d/deepblack-vt-palette.conf

Expected system install paths:

    /usr/local/bin/deepblack-session
    /usr/local/bin/deepblack-autostart
    /usr/local/bin/deepblack-status
    /usr/local/bin/deepblack-apply-vt-palette
    /usr/local/share/deepblack/vtrgb
    /etc/greetd/config.toml
    /usr/share/wayland-sessions/deepblack.desktop
    /etc/systemd/system/greetd.service.d/deepblack-vt-palette.conf

Manual install commands:

    scripts/generate-vt-palette.sh
    sudo install -Dm755 scripts/session.sh /usr/local/bin/deepblack-session
    sudo install -Dm755 scripts/autostart.sh /usr/local/bin/deepblack-autostart
    sudo install -Dm755 scripts/status.sh /usr/local/bin/deepblack-status
    sudo install -Dm755 scripts/apply-vt-palette.sh /usr/local/bin/deepblack-apply-vt-palette
    sudo install -Dm644 generated/greetd/vtrgb /usr/local/share/deepblack/vtrgb
    sudo install -Dm644 config/greetd/config.toml /etc/greetd/config.toml
    sudo install -Dm644 config/wayland-sessions/deepblack.desktop /usr/share/wayland-sessions/deepblack.desktop
    sudo install -Dm644 config/systemd/greetd.service.d/deepblack-vt-palette.conf /etc/systemd/system/greetd.service.d/deepblack-vt-palette.conf
    sudo systemctl daemon-reload

The intended session flow is:

    greetd
        -> tuigreet
        -> deepblack-session
        -> deepblack-status | dwl -s deepblack-autostart

Virtual terminal palette flow:

    generated/dwl/design_tokens.h
        -> scripts/generate-vt-palette.sh
        -> generated/greetd/vtrgb
        -> /usr/local/share/deepblack/vtrgb
        -> setvtrgb
        -> tuigreet ANSI theme roles

Session helper responsibilities:

    deepblack-session            prepares the Wayland session and launches dwl
    deepblack-autostart          starts session background services such as wallpaper
    deepblack-status             writes status text to dwl through stdin
    deepblack-apply-vt-palette   applies the generated VT palette before greetd starts

Do not enable greetd.service until the session has been installed and tested manually.

Before enabling greetd.service, confirm that:

    /usr/local/bin/deepblack-session
    /usr/local/bin/deepblack-autostart
    /usr/local/bin/deepblack-status
    /usr/local/bin/deepblack-apply-vt-palette

exist, are executable, and work from a temporary greetd start test.

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

    MOD + h / ALT+h

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

    MOD + e / ALT+e

### Screenshots

Screenshot workflow:

    scripts/screenshot.sh

Runtime tools:

    grim
    slurp

Launch keybind:

    MOD + s / ALT+s

## Fresh Clone Checklist

After cloning the repository:

1. Install required system packages.
2. Build and install dwl.
3. Build vendored Mako if needed.
4. Install and verify the login/session layer:

       scripts/session.sh
       scripts/autostart.sh
       scripts/status.sh
       scripts/generate-vt-palette.sh
       scripts/apply-vt-palette.sh
       config/greetd/config.toml
       config/wayland-sessions/deepblack.desktop
       config/systemd/greetd.service.d/deepblack-vt-palette.conf

5. Run Neovim install script:

       scripts/install-nvim.sh

6. Run Yazi install script:

       scripts/install-yazi.sh

7. Verify launch keybinds:

       ALT + Return  terminal
       ALT + d       launcher
       ALT + h       Neovim
       ALT + e       Yazi
       ALT + s       screenshot

## Generated Files

Generated files should not be edited by hand.

Important generated paths:

    generated/dwl/design_tokens.h
    generated/nvim/
    generated/yazi/theme.toml
    generated/greetd/vtrgb
    source/dwl/config.h

When generated output looks out of date, rerun the relevant generator or install script.

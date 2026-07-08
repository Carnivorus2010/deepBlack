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

## Component Install Flow

### dwl

Primary source configuration:

    source/dwl/config.def.h

After changing dwl configuration, rebuild and reinstall dwl using the project’s normal dwl build workflow.

Generated build output:

    source/dwl/config.h

The generated config.h file should not be treated as the source of truth.

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
4. Run Neovim install script:

       scripts/install-nvim.sh

5. Run Yazi install script:

       scripts/install-yazi.sh

6. Verify launch keybinds:

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
    source/dwl/config.h

When generated output looks out of date, rerun the relevant generator or install script.

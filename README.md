# deepBlack

A cohesive operating environment for advanced systems engineering.

This is not a Linux rice.
This is a source-driven desktop environment project.

deepBlack is built around dwl, Foot, source-tokenized configuration, and a restrained visual language designed for focused technical work.

## Current Release

Current tagged checkpoint:

    v0.1.5

v0.1.5 adds tokenized Yazi file manager integration.

## Core Components

| Component | Role |
| :--- | :--- |
| dwl | Wayland compositor and keybind router |
| Foot | terminal surface |
| Neovim | primary text editor |
| Yazi | primary file manager |
| Mako | notification daemon |
| wmenu | application launcher |
| grim/slurp | screenshot workflow |

## Primary Keybinds

The deepBlack modifier is ALT.

| Keybind | Action |
| :--- | :--- |
| ALT + Return | Terminal |
| ALT + d | Launcher |
| ALT + h | Neovim |
| ALT + e | Yazi |
| ALT + s | Screenshot |
| ALT + b | Browser |
| ALT + n | Password manager |

## Documentation

Project documentation lives in:

    docs/

Component documentation:

    docs/components/neovim.md
    docs/components/yazi.md

Design system documentation:

    design/

Source components:

    source/

Configuration sources:

    config/

Project scripts:

    scripts/

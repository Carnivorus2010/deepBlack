# deepBlack

A cohesive operating environment for advanced systems engineering.

This is not a Linux rice.

It is a source-driven operating environment built around dwl, Foot, machine profiles, semantic flavor tokens, and a restrained visual language designed for focused technical work.

## Current Release

Current tagged checkpoint:

    v0.1.6

Current development milestone:

    v0.1.7 portability audit

v0.1.7 is validating deepBlack as a reproducible environment across different hardware rather than as a single-machine configuration.

## Profile Model

Machine profiles describe hardware behavior:

    profiles/machines/

Flavor profiles describe visual implementation:

    profiles/flavors/

Machine and flavor are selected independently.

Generic deepBlack build:

    ./build.sh

SilverBullet Nord build:

    ./build.sh --machine silverbullet --flavor nord

Examples of current profile behavior:

| Machine | Modifier | Display behavior | Greeting |
| :--- | :--- | :--- | :--- |
| generic | ALT | Portable defaults | deepBlack |
| silverbullet | LOGO / Command | eDP-1 at 1.75 scale | SilverBullet |

Current flavors:

| Flavor | Purpose |
| :--- | :--- |
| deepblack | Original emerald engineering environment |
| nord | Polar engineering environment used on SilverBullet |

## Core Components

| Component | Role |
| :--- | :--- |
| dwl | Wayland compositor and keybind router |
| greetd / tuigreet | Login and session entry |
| Foot | Terminal surface |
| Neovim | Primary text editor |
| Yazi | Primary file manager |
| Mako | Notification daemon |
| wmenu | Application launcher |
| grim / slurp | Screenshot workflow |
| GRUB theme | Optional machine-specific boot identity |

## Primary Actions

The actual modifier is supplied by the selected machine profile.

| Keybind | Action |
| :--- | :--- |
| MOD + Return | Terminal |
| MOD + d | Launcher |
| MOD + h | Neovim |
| MOD + e | Yazi |
| MOD + s | Screenshot |
| MOD + b | Browser |
| MOD + n | Password manager |

## Build Lifecycle

Build and install the selected environment:

    ./build.sh --machine silverbullet --flavor nord

The compatibility entry point forwards all arguments:

    ./sync.sh --machine silverbullet --flavor nord

Remove generated output and transient dwl headers:

    ./clean.sh

Generated files are not source configuration and should not be edited by hand.

GRUB installation remains explicit:

    ./scripts/install-grub-theme.sh

## Documentation

Project documentation:

    docs/

Install and dependency notes:

    docs/install.md

Component documentation:

    docs/components/session.md
    docs/components/dwl.md
    docs/components/foot.md
    docs/components/mako.md
    docs/components/neovim.md
    docs/components/yazi.md

Design system documentation:

    design/

Source components:

    source/

Configuration sources:

    config/

Machine and flavor profiles:

    profiles/

Project scripts and installers:

    scripts/

# deepBlack

A cohesive operating environment for advanced systems engineering.

This is not a Linux rice.

It is a source-driven operating environment built around dwl, Foot, machine profiles,
semantic flavor tokens, and a restrained visual language designed for focused technical work.

## Current Release

Current release:

    v0.1.8

v0.1.8 adds the ARC and Carbon desktop flavors and completes a broader runtime-hardening pass.
The build now generates GTK, wallpaper, Mako, and GRUB assets from independently
selected machine and flavor profiles. Runtime launchers and the source-built Mako daemon
are installed outside the repository, while bootloader installation remains an explicit
transactional operation.

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

ARC build:

    ./build.sh --machine generic --flavor arc

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
| arc | Restrained blue-black environment with cyan interaction energy |
| carbon | Graphite precision environment with matte charcoal surfaces and metallic interaction light |

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
| MOD + Shift + e | Thunar |
| MOD + Ctrl + e | Toggle fullscreen |
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

    ./scripts/install-grub-theme.sh \
      --machine generic \
      --flavor arc \
      --dry-run

    ./scripts/install-grub-theme.sh \
      --machine generic \
      --flavor arc

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

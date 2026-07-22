# deepBlack dwl Component

dwl is the compositor and window-management layer of the deepBlack operating environment.

It owns persistent infrastructure such as window focus, monitor layout, workspace tags, input behavior, compositor keybinds, and the status bar.

## Design Role

dwl occupies the persistent-infrastructure layer.

- HIERARCHY_04 — persistent infrastructure
- MATERIAL_PANEL — compositor-owned bar and interface elements
- BORDER_ACTIVE — focused window
- BORDER_INACTIVE — inactive window structure
- BORDER_CRITICAL — urgent window
- ACCENT_PRIMARY — selected and active state
- STATE_CRITICAL — exceptional attention state

The compositor should remain structurally present without competing with applications.

## Source Configuration

Primary tracked source:

    source/dwl/config.def.h

Detailed source documentation:

    source/dwl/README.md

Machine settings come from:

    profiles/machines/<machine>.json

Flavor tokens come from:

    profiles/flavors/<flavor>.json

## Generated Build Inputs

The build generates:

    generated/dwl/machine_profile.h
    generated/dwl/design_tokens.h

It copies them temporarily into:

    source/dwl/machine_profile.h
    source/dwl/design_tokens.h

Those transient copies are ignored by Git and must not be edited by hand.

dwl also creates:

    source/dwl/config.h

from the tracked `config.def.h` during compilation.

## Machine Responsibilities

Machine profiles currently control:

- compositor modifier
- monitor rules
- monitor scaling
- master-area ratio
- master-client count
- natural scrolling
- Foot font size
- greeter identity

Current modifier examples:

| Machine profile | Modifier |
| :--- | :--- |
| generic | ALT |
| silverbullet | LOGO / Command |

Documentation refers to the selected modifier as `MOD`.

## Core Actions

| Keybind | Action |
| :--- | :--- |
| MOD + Return | Launch Foot |
| MOD + d | Launch wmenu |
| MOD + h | Launch Neovim |
| MOD + e | Launch Yazi |
| MOD + s | Take a screenshot |
| MOD + b | Launch Chromium |
| MOD + n | Launch Bitwarden |
| MOD + Shift + b | Toggle the status bar |
| MOD + Shift + q | Exit the compositor |

The full binding list is maintained in:

    source/dwl/README.md

## Session Integration

The installed session launches dwl through:

```text
deepblack-session
  -> deepblack-status | dwl -s deepblack-autostart
```

Source helpers:

    scripts/session.sh
    scripts/status.sh
    scripts/autostart.sh

## Build Commands

Generic deepBlack build:

    ./build.sh

SilverBullet Nord build:

    ./build.sh --machine silverbullet --flavor nord

Compatibility entry point:

    ./sync.sh --machine silverbullet --flavor nord

Remove generated files and transient headers:

    ./clean.sh

## wlroots Compatibility

The current compositor build targets:

    wlroots0.20

The Arch build dependencies include:

    wlroots0.20
    fcft
    tllist
    wayland
    wayland-protocols
    libinput
    libxkbcommon

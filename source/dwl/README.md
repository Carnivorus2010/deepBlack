# deepBlack dwl Source

This directory contains the deepBlack build of dwl.

dwl is the compositor layer of the operating environment. It manages windows, keybind routing, monitor layout, input behavior, workspace tags, and compositor-owned interface elements.

The login/session layer reaches dwl through:

    /usr/local/bin/deepblack-session

Source launcher:

    scripts/session.sh

## Source Configuration

The primary tracked compositor configuration is:

    source/dwl/config.def.h

Machine-specific settings are generated from:

    profiles/machines/<machine>.json

Flavor-specific design tokens are generated from:

    profiles/flavors/<flavor>.json

Generated build inputs:

    generated/dwl/machine_profile.h
    generated/dwl/design_tokens.h

Transient compile copies:

    source/dwl/machine_profile.h
    source/dwl/design_tokens.h

The transient headers are ignored by Git and recreated by the build.

Generated compositor configuration:

    source/dwl/config.h

Generated files must not be treated as source configuration.

## Build Examples

Generic deepBlack:

    ./build.sh

SilverBullet with Nord:

    ./build.sh --machine silverbullet --flavor nord

Equivalent compatibility entry point:

    ./sync.sh --machine silverbullet --flavor nord

Remove generated output and transient headers:

    ./clean.sh

## Design Role

The compositor is persistent infrastructure.

It should provide structure without dominating the workspace.

- HIERARCHY_04 — persistent infrastructure
- MATERIAL_PANEL — bar and compositor-owned UI
- BORDER_ACTIVE — focused window state
- BORDER_INACTIVE — inactive window structure
- ACCENT_PRIMARY — active workspace, focused border, selected state
- STATE_CRITICAL — urgent window state

## Modifier Behavior

The compositor modifier is supplied by the selected machine profile.

Current mappings:

| Machine profile | Modifier |
| :--- | :--- |
| generic | ALT |
| silverbullet | LOGO / Command |

Documentation refers to the selected modifier as `MOD`.

## Current Core Bindings

| Keybind | Action |
| :--- | :--- |
| MOD + Return | Launch Foot terminal |
| MOD + d | Launch wmenu |
| MOD + b | Launch Chromium |
| MOD + n | Launch Bitwarden |
| MOD + h | Launch Neovim through `scripts/editor.sh` |
| MOD + e | Launch Yazi through `scripts/files.sh` |
| MOD + s | Run `scripts/screenshot.sh` |
| MOD + Shift + b | Toggle dwl bar |
| MOD + j / MOD + k | Focus next / previous client |
| MOD + i / MOD + p | Increase / decrease master count |
| MOD + Shift + h / MOD + Shift + l | Adjust master-area size |
| MOD + Shift + Return | Zoom focused client |
| MOD + q | Kill focused client |
| MOD + t | Tile layout |
| MOD + f | Floating layout |
| MOD + m | Monocle layout |
| MOD + Space | Cycle layout |
| MOD + Shift + Space | Toggle floating |
| MOD + Shift + e | Toggle fullscreen |
| MOD + Tab | Toggle previous tag view |
| MOD + 1-9 | View tag |
| MOD + Shift + 1-9 | Move focused client to tag |
| MOD + Ctrl + 1-9 | Toggle visible tag |
| MOD + Ctrl + Shift + 1-9 | Toggle focused client on tag |
| MOD + Shift + q | Quit compositor session |

## Input Behavior

Caps Lock and Escape are swapped at the XKB level:

    caps:swapescape

Natural scrolling, monitor scaling, and modifier selection are supplied by the machine profile.

## Runtime Components

The compositor launches project-controlled scripts where practical.

| Component | Launch path |
| :--- | :--- |
| Editor | `scripts/editor.sh` |
| File manager | `scripts/files.sh` |
| Screenshot | `scripts/screenshot.sh` |
| Menu | generated wmenu wrapper |
| Terminal | Foot |
| Browser | Chromium |
| Password manager | Bitwarden |

Keeping behavior behind project scripts allows components to evolve without repeatedly changing compositor source.

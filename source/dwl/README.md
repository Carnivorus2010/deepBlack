# deepBlack dwl Source

This directory contains the deepBlack build of dwl.

dwl is the compositor layer of the operating environment. It is responsible for window management, keybind routing, monitor layout, input behavior, workspace tags, and launching core user-facing components.

The login/session layer reaches dwl through the canonical deepBlack session launcher:

    scripts/session.sh

When installed for greetd, that launcher is expected at:

    /usr/local/bin/deepblack-session

This build is source-configured through:

    source/dwl/config.def.h

Generated design tokens are included through:

    generated/dwl/design_tokens.h

## Design Role

The compositor is persistent infrastructure.

It should provide structure without dominating the workspace.

- HIERARCHY_04 — persistent infrastructure
- MATERIAL_PANEL — bar and compositor-owned UI
- BORDER_ACTIVE — focused window state
- BORDER_INACTIVE — inactive window structure
- ACCENT_PRIMARY — active workspace, focused border, selected state
- STATE_CRITICAL — urgent window state

## Current Core Bindings

The deepBlack modifier is ALT.

| Keybind | Action |
| :--- | :--- |
| ALT + Return | Launch Foot terminal |
| ALT + d | Launch wmenu |
| ALT + b | Launch Chromium |
| ALT + n | Launch Bitwarden |
| ALT + h | Launch Neovim through scripts/editor.sh |
| ALT + e | Launch Yazi through scripts/files.sh |
| ALT + s | Run screenshot workflow through scripts/screenshot.sh |
| ALT + Shift + b | Toggle dwl bar |
| ALT + j / ALT + k | Focus next / previous client |
| ALT + i / ALT + p | Increase / decrease master count |
| ALT + Shift + h / ALT + Shift + l | Adjust master area size |
| ALT + Shift + Return | Zoom focused client |
| ALT + q | Kill focused client |
| ALT + t | Tile layout |
| ALT + f | Floating layout |
| ALT + m | Monocle layout |
| ALT + Space | Cycle layout |
| ALT + Shift + Space | Toggle floating |
| ALT + Shift + e | Toggle fullscreen |
| ALT + Tab | Toggle previous tag view |
| ALT + 1-9 | View tag |
| ALT + Shift + 1-9 | Move focused client to tag |
| ALT + Ctrl + 1-9 | Toggle visible tag |
| ALT + Ctrl + Shift + 1-9 | Toggle focused client on tag |
| ALT + Shift + q | Quit compositor session |

## Input Behavior

Caps Lock and Escape are swapped at the XKB level.

This supports the Neovim-centered workflow while keeping the behavior compositor-native.

Current XKB option:

    caps:swapescape

## Runtime Components

The compositor launches project-controlled scripts where possible.

This keeps dwl stable while allowing component behavior to evolve without repeatedly editing compositor source.

| Component | Launch Path |
| :--- | :--- |
| Editor | scripts/editor.sh |
| File manager | scripts/files.sh |
| Screenshot | scripts/screenshot.sh |
| Menu | wmenu-run |
| Terminal | foot |
| Browser | chromium |
| Password manager | bitwarden-desktop |

## Build Notes

After changing config.def.h, rebuild and reinstall dwl from this directory using the project’s normal build workflow.

The generated config.h file is build output derived from config.def.h and should not be treated as the source of truth.

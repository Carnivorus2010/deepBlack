# deepBlack Config

Configuration sources for user-facing deepBlack components.

These files are tracked source configuration rather than generated output.

## greetd

`config/greetd/config.toml` is the tracked source configuration for greetd.

Installed path:

    /etc/greetd/config.toml

The active configuration launches:

    /usr/local/bin/deepblack-greeter

The greeter wrapper itself is generated from the selected machine profile:

    profiles/machines/<machine>.json
        -> tools/generate-machine-profile.py
        -> generated/greetd/deepblack-greeter
        -> /usr/local/bin/deepblack-greeter

The greetd configuration must not embed a repository-local path or a machine-specific local wrapper.

## GRUB

Tracked GRUB theme source:

    config/grub/themes/silverbullet-nord/theme.txt

Install it explicitly with:

    scripts/install-grub-theme.sh

The source theme is installed beneath:

    /boot/grub/themes/silverbullet-nord/

GRUB installation remains separate from the normal build because bootloader modification should be deliberate.

## Wayland Sessions

`config/wayland-sessions/deepblack.desktop` defines the deepBlack Wayland session entry.

Installed path:

    /usr/share/wayland-sessions/deepblack.desktop

The session entry launches:

    /usr/local/bin/deepblack-session

## systemd

`config/systemd/greetd.service.d/deepblack-vt-palette.conf` is the tracked greetd service drop-in.

Installed path:

    /etc/systemd/system/greetd.service.d/deepblack-vt-palette.conf

The drop-in runs:

    /usr/local/bin/deepblack-apply-vt-palette

before greetd starts.

The applied palette is read from:

    /usr/local/share/deepblack/vtrgb

## Neovim

Neovim is the primary text editor component.

Source configuration:

    config/nvim/

Installed by:

    scripts/install-nvim.sh

Launch keybind:

    MOD + h

Design role:

- Hierarchy: HIERARCHY_01 / Primary Work
- Material: MATERIAL_BASE through Foot
- Typography: TYPE_DIAGNOSTIC / TYPE_BODY depending on content
- Motion: MOTION_INSTANT for text input
- Color: generated from `generated/dwl/design_tokens.h`

`ACCENT_PRIMARY` is reserved for cursor emphasis, selections, current-line information, and active syntax states.

## Yazi

Yazi is the primary file manager component.

Source configuration:

    config/yazi/

Installed by:

    scripts/install-yazi.sh

Launch keybind:

    MOD + e

Design role:

- Hierarchy: HIERARCHY_01 / Primary Work
- Material: MATERIAL_BASE through Foot
- Typography: TYPE_DIAGNOSTIC / TYPE_BODY depending on content
- Motion: MOTION_INSTANT for navigation and selection
- Color: generated from `generated/dwl/design_tokens.h`

Generated Yazi theme:

    generated/yazi/theme.toml

Generated theme output should not be edited by hand.

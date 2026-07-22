# deepBlack Session Layer

The deepBlack session layer defines the path from system authentication into the dwl compositor.

Its purpose is to provide a reliable, auditable, and visually consistent login flow without introducing a separate desktop-display-manager aesthetic.

## Components

deepBlack uses:

- `greetd` as the login and session manager
- `tuigreet` as the console-native greeter
- `scripts/session.sh` as the canonical Wayland session launcher
- `scripts/autostart.sh` for session background services
- `scripts/status.sh` for dwl bar status input
- `scripts/apply-vt-palette.sh` for the generated virtual-terminal palette

## Session Flow

```text
greetd.service
  -> deepblack-apply-vt-palette
  -> greetd
    -> deepblack-greeter
      -> deepblack-session
        -> deepblack-status | dwl -s deepblack-autostart
```

The systemd pre-start helper applies the selected flavor palette before tuigreet begins.

## Machine-Generated Greeter

The installed greeter wrapper is generated from the selected machine profile:

```text
profiles/machines/<machine>.json
  -> tools/generate-machine-profile.py
  -> generated/greetd/deepblack-greeter
  -> /usr/local/bin/deepblack-greeter
```

Machine profiles define the greeter identity through `greeter_greeting`.

Examples:

```text
generic       -> deepBlack
silverbullet  -> SilverBullet
```

The generated greeter launches `/usr/local/bin/deepblack-session`.

It also exposes the installed Wayland and X11 session directories for recovery or alternate-session selection.

## Flavor-Generated VT Palette

The tuigreet color roles are backed by the selected flavor tokens:

```text
profiles/flavors/<flavor>.json
  -> generated/dwl/design_tokens.h
  -> scripts/generate-vt-palette.sh
  -> generated/greetd/vtrgb
  -> /usr/local/share/deepblack/vtrgb
  -> deepblack-apply-vt-palette
```

The Linux virtual-terminal ANSI slots represent semantic roles such as surface, critical, success, warning, primary accent, secondary accent, and text.

The active greeter does not depend on `/etc/vtrgb` or a machine-local palette script.

## Source Files

```text
scripts/session.sh
scripts/autostart.sh
scripts/status.sh
scripts/apply-vt-palette.sh
scripts/generate-vt-palette.sh
config/greetd/config.toml
config/wayland-sessions/deepblack.desktop
config/systemd/greetd.service.d/deepblack-vt-palette.conf
profiles/machines/
profiles/flavors/
tools/generate-machine-profile.py
```

## Installed Files

The normal build installs:

```text
/usr/local/bin/deepblack-session
/usr/local/bin/deepblack-autostart
/usr/local/bin/deepblack-status
/usr/local/bin/deepblack-greeter
/usr/local/bin/deepblack-apply-vt-palette
/usr/local/share/deepblack/vtrgb
/etc/greetd/config.toml
/usr/share/wayland-sessions/deepblack.desktop
/etc/systemd/system/greetd.service.d/deepblack-vt-palette.conf
```

The active greetd configuration launches `/usr/local/bin/deepblack-greeter`.

## Build Examples

Generic deepBlack environment:

```bash
./build.sh
```

SilverBullet with the Nord flavor:

```bash
./build.sh --machine silverbullet --flavor nord
```

The same arguments may be forwarded through:

```bash
./sync.sh --machine silverbullet --flavor nord
```

The build installs the session layer but does not restart greetd automatically.

## Status Provider

When `slstatus` is installed, `deepblack-status` uses `slstatus -s`.

Otherwise it provides a built-in fallback containing battery state when available and the current date and time.

## Safety

Keep a fallback TTY available while changing greetd or the session launcher.

Before enabling or restarting greetd, confirm these files exist and are executable:

```text
/usr/local/bin/deepblack-session
/usr/local/bin/deepblack-greeter
/usr/local/bin/deepblack-apply-vt-palette
```

The build runs `systemctl daemon-reload` but intentionally does not restart the display manager.

## Tested State

The generic deepBlack session path was verified during v0.1.6.

The SilverBullet portability audit additionally verified:

```text
boot -> Nord GRUB theme
greetd pre-start -> managed Nord VT palette
tuigreet -> generated SilverBullet greeter
login -> deepblack-session
deepblack-status | dwl -s deepblack-autostart
logout -> tuigreet
```

The previous machine-local SilverBullet greeter was retired after the generated repository-managed path passed relog and reboot testing.

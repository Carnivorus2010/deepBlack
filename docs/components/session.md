# deepBlack Session Layer

The deepBlack session layer defines how the operating environment starts from login into the dwl compositor.

This layer is intentionally minimal. Its purpose is to provide a clear, reliable path from system authentication to the deepBlack Wayland session without introducing unnecessary visual complexity.

## Current Direction

deepBlack uses greetd as the login/session manager and tuigreet as the initial greeter.

This choice keeps the login flow:

* console-native
* minimal
* scriptable
* easy to audit
* visually restrained
* aligned with the rest of the operating environment

The login screen should feel like the first screen of deepBlack, not like an external desktop display manager.

## Session Flow

The intended launch chain is:

```text
greetd
  -> tuigreet
    -> deepblack-session
      -> dwl
```

The repo tracks the session entry point as:

```text
scripts/session.sh
```

During system installation, this script should be installed to:

```text
/usr/local/bin/deepblack-session
```

The greetd configuration should launch that installed session command rather than referencing a user-local repository path.

## Session Startup Helpers

The session launcher starts dwl with project-controlled helper scripts.

Tracked helper scripts:

```text
scripts/autostart.sh
scripts/status.sh

## Tracked Configuration

Source templates live under:

```text
config/greetd/config.toml
config/wayland-sessions/deepblack.desktop
```

The active system paths are expected to be:

```text
/etc/greetd/config.toml
/usr/share/wayland-sessions/deepblack.desktop
/usr/local/bin/deepblack-session
```

The files under `config/` are source-controlled templates. They are not active until installed into their system locations.

## Design Intent

The session layer is infrastructure.

It should support the operating environment without becoming visually dominant. Visual polish should remain secondary until the login path is stable and reliable.

The greeter should remain calm, matte, restrained, and terminal-native where possible. Accent usage should be uncommon and meaningful.

## Safety Notes

Do not enable `greetd.service` until the session command exists at the path referenced by `/etc/greetd/config.toml`.

Before enabling greetd, confirm that:

```text
/usr/local/bin/deepblack-session
```

exists, is executable, and successfully launches the deepBlack dwl session.

Keep a fallback TTY available while testing the login/session layer.

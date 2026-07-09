# deepBlack Session Layer

The deepBlack session layer defines how the operating environment starts from login into the dwl compositor.

This layer is intentionally minimal. Its purpose is to provide a clear, reliable path from system authentication to the deepBlack Wayland session without introducing unnecessary visual complexity.

## Current Direction

deepBlack uses greetd as the login/session manager and tuigreet as the initial greeter.

This choice keeps the login flow:

- console-native
- minimal
- scriptable
- easy to audit
- visually restrained
- aligned with the rest of the operating environment

The login screen should feel like the first screen of deepBlack, not like an external desktop display manager.

## Session Flow

The intended launch chain is:

```text
greetd
  -> tuigreet
    -> deepblack-session
      -> deepblack-status | dwl -s deepblack-autostart

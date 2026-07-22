# deepBlack Mako Component

Mako is the notification daemon used by the deepBlack operating environment.

The project vendors Mako source so notification appearance and urgency behavior can be integrated directly rather than relying only on an external theme file.

## Design Role

Notifications are temporary informational surfaces.

- HIERARCHY_03 — transient information
- MATERIAL_FLOATING — notification surface
- TEXT_PRIMARY — notification title and important content
- TEXT_SECONDARY — supporting content
- ACCENT_PRIMARY — ordinary active emphasis
- STATE_WARNING — warning urgency
- STATE_CRITICAL — critical urgency

Notifications should communicate state clearly without becoming decorative or visually dominant.

## Vendored Source

Mako source lives at:

    source/mako/

Project-specific upstream and maintenance notes:

    source/mako/DEEPBLACK_UPSTREAM.md

The vendored source contains deepBlack-specific default styling and urgency behavior.

## Launcher

The project launcher is:

    scripts/deepblack-mako.sh

The installed notification service uses this launcher rather than the distribution-provided Mako binary path directly.

Runtime service name:

    deepblack-mako.service

Inspect it with:

    systemctl --user status deepblack-mako.service

The launcher waits for the required Wayland and session-bus environment before starting the notification daemon.

## Build Dependencies

The vendored source build requires the packages documented in:

    docs/install.md

Core build support includes:

    meson
    ninja
    scdoc
    cairo
    pango
    gdk-pixbuf2
    dbus

## Runtime Verification

Confirm the service is active:

    systemctl --user status deepblack-mako.service

Confirm the source-built daemon is running:

    pgrep -a mako

A successful session should provide:

- ordinary notifications with restrained emphasis
- warning notifications with warning-state treatment
- critical notifications with critical-state treatment
- startup that waits safely for the Wayland and D-Bus session environment

## Source Policy

Changes to deepBlack notification defaults should be made in the vendored source or project launcher rather than patched manually into an installed system package.

The distribution Mako package is not the authoritative deepBlack notification implementation.

# Roadmap

## Completed v0.1.x Milestones

### v0.1.1 - v0.1.3

Core compositor, terminal, screenshot, and notification groundwork.

- Tokenized dwl visual integration.
- Foot terminal integration.
- Grim/slurp screenshot workflow.
- Source-built Mako notification integration.
- wlroots 0.20 migration.
- Hardened Mako startup through the user service layer.

### v0.1.4

Tokenized Neovim workflow integration.

- Neovim launched through `scripts/editor.sh`.
- Tokenized Neovim configuration.
- Telescope, nvim-tree, bufferline, clipboard, and cursor refinements.
- Caps Lock and Escape swapped at the compositor XKB level.

### v0.1.5

Tokenized Yazi file manager integration.

- Yazi launched through `scripts/files.sh`.
- Tokenized Yazi theme generation.
- Yazi source configuration under `config/yazi/`.
- Yazi install flow through `scripts/install-yazi.sh`.
- Installation and dependency documentation added.

### v0.1.6 Login / Session Layer

Implemented and reboot-tested the greetd-based session entry point.

- greetd as the login and session manager.
- tuigreet as the console-native greeter.
- `scripts/session.sh` as the canonical Wayland session launcher.
- `scripts/autostart.sh` as the session background-service helper.
- `scripts/status.sh` as the dwl status provider.
- Generated virtual-terminal palette support.
- Managed Wayland session entry.
- greetd systemd pre-start palette integration.
- Login, logout, wallpaper, status, and reboot paths verified.

### v0.1.7 Portability Audit

Validated deepBlack as a profile-driven environment on a second physical machine.

Target system:

    Early 2015 13-inch MacBook Pro Retina
    Machine profile: silverbullet
    Flavor profile: nord

Implemented:

- Independent machine and flavor profile selection.
- `--machine` and `--flavor` build arguments.
- Generic and SilverBullet machine profiles.
- deepBlack and Nord flavor profiles.
- Machine-generated dwl monitor, input, modifier, and font settings.
- Machine-generated tuigreet wrapper and greeting identity.
- Flavor-generated Foot, Neovim, Yazi, wmenu, dwl, and VT palette assets.
- Managed greetd and session installation through `build.sh`.
- Repository-managed VT palette at `/usr/local/share/deepblack/vtrgb`.
- Battery status fallback for laptop deployments.
- SilverBullet Nord GRUB theme.
- Explicit GRUB theme installer with backup and configuration regeneration.
- Clean and synchronization workflows that preserve profile arguments.
- Generated dwl headers removed from version control.
- Correct Arch dependencies documented: `wlroots0.20`, `fcft`, and `tllist`.

Verified:

- Clean generation from an empty `generated/` directory.
- SilverBullet/Nord dwl compilation and installation.
- Command-key compositor modifier.
- eDP-1 scaling at 1.75.
- Natural trackpad scrolling.
- Nord Foot, Neovim, Yazi, wmenu, and tuigreet appearance.
- Managed VT palette without `/etc/vtrgb`.
- Generated greeter without the retired local SilverBullet wrapper.
- Battery percentage and glyph display in the dwl bar.
- Wallpaper autostart.
- Login, logout, relog, and reboot behavior.
- Repository-installed GRUB theme and larger 1280x800 boot interface.

Release checkpoint:

- Documentation audit completed.
- Final repository validation passed.
- Feature branch fast-forwarded into `main`.
- This milestone represents the final v0.1.7 release state.

Documentation audit:

- Updated installation and dependency guidance.
- Documented machine and flavor profile composition.
- Documented generated and transient file policy.
- Documented managed greetd, VT palette, and GRUB workflows.
- Added the missing dwl component document.

## Next v0.1.x Work

### Additional Machine Profiles

Create explicit profiles for:

- the primary desktop workstation
- the Framework Laptop 13

Machine profiles should contain only hardware behavior and machine identity.

### Additional Flavor Profiles

Planned Framework flavor:

    oxocarbon

Flavor profiles should remain independent from hardware profiles.

### Profile Onboarding

Improve documentation and validation for adding a new machine or flavor.

Potential additions:

- profile schema documentation
- profile validation tests
- hardware discovery notes
- battery-device discovery validation tests
- monitor-profile examples

### Installer Hardening

Continue moving from documented build automation toward a recoverable installer.

Priority areas:

- dependency checks
- dry-run support
- clearer privilege boundaries
- explicit backup and rollback behavior
- machine onboarding without local one-off files

## v0.2.0 Direction

Move from core functionality and portability into refinement.

Focus areas:

- broader semantic token coverage
- stronger boot-to-shutdown identity
- more complete machine/flavor composition
- installer hardening
- visual consistency across every user-facing component
- removal of remaining machine-local assumptions

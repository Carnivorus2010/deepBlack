# Changelog

Design and implementation decisions should be logged here.

## v0.1.8

### ARC Flavor and Carbon Flavors

- Added the ARC flavor profile with a restrained blue-black palette and cyan interaction accent.
- Added the Carbon flavor profile with matte charcoal surfaces and metallic interaction light.
- Added the tracked ARC wallpaper at `assets/wallpapers/arc.png`.
- Added GTK 3 generation and installation for flavor-aware graphical applications.
- Added Thunar as the explicit graphical file-manager fallback.
- Added `MOD + Shift + e` for Thunar.
- Moved fullscreen to `MOD + Ctrl + e`.

### Generated Component Pipeline

- Extended `tools/generate_themes.py` to generate:
  - dwl design tokens
  - Mako tokens
  - Foot configuration
  - wmenu launcher
  - GTK 3 settings and CSS
  - wallpaper image, mode, and solid-color fallback
- Added flavor-aware wallpaper installation under `~/.local/share/deepblack/`.
- Added stale-wallpaper protection when switching to a flavor without an image.
- Added `tools/generate-grub-theme.py` for machine- and flavor-aware GRUB composition.
- Added generated GRUB theme identity and graphics-mode metadata.

### Runtime Hardening

- Installed stable application launchers beneath `~/.local/bin`.
- Removed dwl runtime dependencies on the repository location.
- Hardened the Yazi, Thunar, editor, and screenshot launchers.
- Added dependency reporting and clean screenshot-cancellation handling.
- Installed the source-built Mako daemon beneath `~/.local/libexec/deepblack/`.
- Added the tracked `deepblack-mako.service` systemd user unit.
- Changed Mako tokens from a tracked source header to generated transient output.

### GRUB

- Replaced the static SilverBullet-only GRUB theme source with generated machine-and-flavor compositions.
- Added explicit `--machine`, `--flavor`, `--dry-run`, and `--yes` installer options.
- Added timestamped GRUB backups under `/var/backups/deepblack/grub/`.
- Added candidate `grub.cfg` generation, theme-reference validation, syntax validation, and automatic rollback.
- Verified the generated ARC GRUB theme through a successful reboot.

### Verification

- Verified a complete `generic + arc` build.
- Verified Foot, dwl, wmenu, Neovim, Yazi, Thunar, GTK 3, Mako, greetd, wallpaper, and GRUB integration.
- Verified all hardened application keybinds after relogging.
- Verified ARC wallpaper installation and stale-image protection.

## v0.1.7

Portability audit and first cross-hardware deepBlack deployment.

### Added

- Added machine-profile selection through `--machine`.
- Added flavor-profile selection through `--flavor`.
- Added `profiles/machines/generic.json`.
- Added `profiles/machines/silverbullet.json`.
- Added the Nord flavor profile.
- Added machine-generated dwl monitor, modifier, scrolling, and font settings.
- Added machine-generated `/usr/local/bin/deepblack-greeter`.
- Added machine-specific greeter greetings.
- Added automatic session-layer installation to `build.sh`.
- Added automatic greetd integration installation to `build.sh`.
- Added battery status and state glyphs to the fallback dwl status provider.
- Added `config/grub/themes/silverbullet-nord/theme.txt`.
- Added `scripts/install-grub-theme.sh`.
- Added explicit GRUB backup, font installation, graphics-mode configuration, and `grub.cfg` regeneration.

### Changed

- Changed `sync.sh` into an argument-forwarding compatibility entry point for `build.sh`.
- Changed `clean.sh` to remove generated output and both transient dwl headers.
- Changed the VT palette mapping to use semantic ANSI roles across flavors.
- Changed greetd to launch the generated `deepblack-greeter`.
- Changed the active palette source to `/usr/local/share/deepblack/vtrgb`.
- Changed the build to install the session launcher, autostart helper, status helper, Wayland session entry, generated greeter, palette helper, greetd configuration, and systemd drop-in.
- Changed documentation to use `MOD` when the modifier is machine-dependent.
- Hardened fallback battery discovery to support any `BAT*` power-supply device and systems without batteries.
- Corrected Arch compositor dependencies to `wlroots0.20`, `fcft`, and `tllist`.

### Removed

- Removed the tracked `source/dwl/design_tokens.h`.
- Removed generated flavor state from version control.
- Removed the active dependency on `/etc/vtrgb`.
- Removed the active dependency on the local `silverbullet-greeter`.
- Retired the old machine-local SilverBullet login path after managed-session verification.

### Tested

- Verified `./clean.sh` removes all generated assets and transient dwl headers.
- Verified `./sync.sh --machine silverbullet --flavor nord` recreates all required output.
- Verified the generated Nord VT palette matches the approved local palette.
- Verified dwl builds successfully against `wlroots0.20`.
- Verified the SilverBullet eDP-1 scale, Command-key modifier, natural scrolling, and Foot font size.
- Verified Nord Foot, Neovim, Yazi, wmenu, tuigreet, and VT appearance.
- Verified battery percentage and glyph output in the dwl bar.
- Verified the repository-managed greetd and generated greeter path.
- Verified login, logout, relog, and reboot behavior.
- Verified the SilverBullet Nord GRUB theme after installation and reboot.
- Verified the installed GRUB theme matches the repository source.

## v0.1.6

### Added

- Added `scripts/session.sh` as the canonical deepBlack session launcher.
- Added `scripts/autostart.sh` for session background startup.
- Added `scripts/status.sh` for dwl bar status input.
- Added `scripts/generate-vt-palette.sh`.
- Added `scripts/apply-vt-palette.sh`.
- Added `config/greetd/config.toml`.
- Added `config/wayland-sessions/deepblack.desktop`.
- Added the greetd systemd palette drop-in.
- Added initial session-layer documentation.

### Changed

- Refined the tuigreet command for a restrained login screen.
- Mapped tuigreet ANSI roles through the generated virtual-terminal palette.

### Tested

- Verified temporary greetd startup from a control TTY.
- Verified tuigreet login launches the deepBlack dwl session.
- Verified wallpaper autostart, dwl status input, and primary keybinds.
- Verified exiting dwl returns to tuigreet.
- Verified reboot into greetd/tuigreet on VT1.
- Verified the full login and logout path after reboot.

## v0.1.5

Tokenized Yazi file manager integration.

- Added `scripts/files.sh`.
- Updated `MOD + e` to launch Yazi through the project script.
- Added `config/yazi/yazi.toml`.
- Added `scripts/generate-yazi-theme.sh`.
- Added `scripts/install-yazi.sh`.
- Generated the Yazi theme from semantic design tokens.
- Established Yazi as the primary file manager.
- Preserved Thunar as an optional GUI fallback.

## v0.1.4

Tokenized Neovim workflow integration.

- Added tokenized Neovim configuration.
- Added the Neovim launcher workflow through Foot.
- Added Telescope fuzzy file search.
- Added live grep, buffer search, recent files, nvim-tree, bufferline, clipboard support, and yank feedback.
- Refined Neovim cursor behavior by mode.
- Refined Foot cursor token behavior.
- Swapped Caps Lock and Escape at the dwl XKB level.

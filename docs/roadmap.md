# Roadmap

## Completed v0.1.x Milestones

### v0.1.1 - v0.1.3

Core compositor, terminal, screenshot, and notification groundwork.

- Tokenized dwl visual integration.
- Foot terminal integration.
- Grim/slurp screenshot workflow.
- Source-built Mako notification integration.
- wlroots 0.20 migration.

### v0.1.4

Tokenized Neovim workflow integration.

- Neovim launched through scripts/editor.sh.
- Tokenized Neovim configuration.
- Telescope, nvim-tree, bufferline, clipboard, and cursor behavior refinements.
- Caps Lock and Escape swapped at the compositor XKB level.

### v0.1.5

Tokenized Yazi file manager integration.

- Yazi launched through scripts/files.sh.
- Tokenized Yazi theme generation.
- Yazi source configuration under config/yazi/.
- Yazi install flow through scripts/install-yazi.sh.

### Post-v0.1.5 Documentation Pass

Project documentation was refreshed after the v0.1.5 code/config checkpoint.

- Added Yazi component documentation.
- Updated Neovim documentation for the current MOD + h / ALT+h launch path.
- Updated dwl keybind documentation.
- Added install and dependency notes.
- Removed outdated references to older file manager and editor launch paths.

### Pre-v0.1.6 Login / Session Layer

Implemented, reboot-tested, and token-polished the greetd-based login/session entry point.

- greetd as the login/session manager.
- tuigreet as the initial console-native greeter.
- scripts/session.sh as the canonical deepBlack session launcher.
- scripts/autostart.sh as the deepBlack session background startup helper.
- scripts/status.sh as the dwl bar status provider.
- scripts/generate-vt-palette.sh as the virtual terminal palette generator.
- scripts/apply-vt-palette.sh as the safe VT palette application helper.
- config/greetd/config.toml as the tracked greetd source template.
- config/wayland-sessions/deepblack.desktop as the tracked Wayland session entry.
- config/systemd/greetd.service.d/deepblack-vt-palette.conf as the tracked greetd systemd drop-in template.
- Manual install path documented before enabling greetd.service.
- Reboot into greetd/tuigreet on VT1 verified.
- Login into the full deepBlack dwl session verified.
- Logout-to-greeter behavior verified.
- tuigreet ANSI theme roles mapped through the generated deepBlack VT palette.

Release intent:

- This work is tracked as the v0.1.6-pre.1 foundation plus polish work toward the final v0.1.6 checkpoint.
- Final v0.1.6 should represent the completed login/session layer.

## Next v0.1.x Work

### v0.1.6 Release Finalization

- Run final reboot verification after the VT palette layer.
- Audit session/login documentation.
- Merge the greetd token polish branch into main.
- Tag the final v0.1.6 release.

### GUI Fallbacks

Yazi is the primary file manager.

Thunar may remain an optional GUI fallback for workflows that need a traditional graphical file manager.

## v0.2.0 Direction

Move from core functionality into refinement.

Focus areas:

- broader token coverage
- boot-to-shutdown identity
- stronger documentation
- installer hardening
- consistency across all user-facing components

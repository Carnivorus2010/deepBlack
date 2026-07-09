# Changelog

Design and implementation decisions should be logged here.

## v0.1.6

### Added

- Began greetd-based login/session layer integration.
- Added `scripts/session.sh` as the canonical deepBlack session launcher.
- Added `scripts/autostart.sh` for deepBlack session background startup.
- Added `scripts/status.sh` for dwl bar status input.
- Added `scripts/generate-vt-palette.sh` for virtual terminal palette generation.
- Added `scripts/apply-vt-palette.sh` for applying the generated VT palette before greetd starts.
- Added `config/greetd/config.toml` as the tracked greetd source template.
- Added `config/wayland-sessions/deepblack.desktop` as the tracked Wayland session entry.
- Added `config/systemd/greetd.service.d/deepblack-vt-palette.conf` as the tracked greetd systemd drop-in template.
- Added initial session layer documentation.

### Changed

- Refined the tuigreet command for a calmer, more restrained login screen.
- Removed session selection memory so the deepBlack session launcher remains the authoritative login path.
- Mapped tuigreet ANSI theme roles through the generated deepBlack virtual terminal palette.

### Tested

- Verified temporary greetd startup from a control TTY.
- Verified tuigreet login launches the deepBlack dwl session.
- Verified wallpaper autostart, dwl bar status input, and primary keybinds inside the greetd-launched session.
- Verified exiting dwl returns to tuigreet.
- Verified reboot into greetd/tuigreet on VT1.
- Verified login from greetd launches the full deepBlack dwl session.
- Verified wallpaper autostart, dwl status input, primary keybinds, and logout-to-greeter behavior after reboot.
- Verified tuigreet uses the generated deepBlack virtual terminal palette after restarting greetd.

## v0.1.5

Tokenized Yazi file manager integration.

- Added `scripts/files.sh` as the file manager launcher.
- Updated the dwl file manager keybind flow so `MOD + e` / `ALT+e` launches Yazi through the project script.
- Added `config/yazi/yazi.toml` as source Yazi configuration.
- Added `scripts/generate-yazi-theme.sh`.
- Added `scripts/install-yazi.sh`.
- Generated the Yazi theme from `generated/dwl/design_tokens.h`.
- Established Yazi as the primary deepBlack file manager.
- Preserved Thunar as an optional GUI fallback candidate.

## v0.1.4

Tokenized Neovim workflow integration.

- Added tokenized Neovim configuration.
- Added Neovim launcher workflow through Foot.
- Added Telescope fuzzy file search.
- Added live grep, buffer search, recent files, nvim-tree, bufferline, clipboard support, and yank feedback.
- Refined Neovim cursor behavior by mode.
- Refined Foot cursor token behavior.
- Swapped Caps Lock and Escape at the dwl XKB level.

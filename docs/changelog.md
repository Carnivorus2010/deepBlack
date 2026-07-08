# Changelog

Design and implementation decisions should be logged here.

## Unreleased

### Added

- Began greetd-based login/session layer integration.
- Added `scripts/session.sh` as the canonical deepBlack session launcher.
- Added `config/greetd/config.toml` as the tracked greetd source template.
- Added `config/wayland-sessions/deepblack.desktop` as the tracked Wayland session entry.
- Added initial session layer documentation.

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

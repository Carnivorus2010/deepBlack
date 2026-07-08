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

## Next v0.1.x Work

### Login / Session Layer

Evaluate and integrate a login/session entry point.

Candidate direction:

- greetd
- tuigreet or another minimal greeter
- deepBlack-aligned session startup

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

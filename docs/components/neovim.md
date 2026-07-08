# Neovim Component

## Purpose

Neovim provides the core text editing surface for deepBlack.

It is not treated as a themed external application. It is a first-class work surface aligned to the token system and launched through the compositor.

## Component Role

- HIERARCHY_01 — primary work
- MATERIAL_BASE — runs inside Foot as a solid terminal surface
- TYPE_DIAGNOSTIC — code, logs, shell scripts, configuration
- ACCENT_PRIMARY — cursor, selection, current line number, active syntax
- STATE_WARNING — warning diagnostics only
- STATE_CRITICAL — errors only

## Launch Path

MOD + h / ALT+h launches the editor workflow.

Launch flow:

    source/dwl/config.def.h
        -> scripts/editor.sh
        -> foot --app-id deepblack-editor
        -> nvim

The launcher opens Foot with app id deepblack-editor, title deepBlack :: editor, and starts nvim.

The launcher lives at:

    scripts/editor.sh

## Configuration Layout

Source configuration lives at:

    config/nvim/

Generated token output is written to:

    generated/nvim/

Installed user configuration is written to:

    ~/.config/nvim/

## Token Flow

Neovim token generation follows this path:

    generated/dwl/design_tokens.h
        -> scripts/install-nvim.sh
        -> generated/nvim/
        -> ~/.config/nvim/lua/deepblack/tokens.lua
        -> require("deepblack.tokens")

The generated Lua token file should not be edited by hand.

## Workflow Features

The deepBlack Neovim configuration includes:

- Telescope fuzzy file search
- Telescope live grep
- buffer search
- recent files
- nvim-tree directory sidebar
- bufferline tab-like buffer navigation
- wl-clipboard yank and paste support
- TextYankPost yank highlight feedback
- tokenized cursor behavior by mode

## Cursor Behavior

Neovim cursor behavior is intentionally stronger than the base Foot terminal cursor.

- Normal mode: visible block
- Insert mode: vertical beam
- Replace mode: warning-style underline

## Maintenance

Regenerate and install the Neovim configuration with:

    scripts/install-nvim.sh

Then relaunch with:

    MOD + h / ALT+h

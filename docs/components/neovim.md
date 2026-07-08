# Neovim Component

## Purpose

Neovim provides the core text editing surface for deepBlack.

It is not treated as a themed external application. It is a first-class work
surface aligned to the token system and launched through the compositor.

## Component Role

- `HIERARCHY_01` — primary work
- `TYPE_DIAGNOSTIC` — code, logs, shell scripts, configuration
- `ACCENT_PRIMARY` — cursor, selection, current line number, active syntax
- `STATE_WARNING` — warning diagnostics only
- `STATE_CRITICAL` — errors only

## Launch Path

`MOD + v` launches:

```sh
scripts/editor.sh
```

The launcher opens Foot with app id `deepblack-editor`, title
`deepBlack :: editor`, and starts `nvim`.

## Token Flow

```text
header/design_tokens.h
        ↓
tools/generate-nvim-tokens.py
        ↓
config/nvim/lua/deepblack/tokens.lua
        ↓
config/nvim/lua/deepblack/theme.lua
```

The generated Lua file should not be edited by hand.

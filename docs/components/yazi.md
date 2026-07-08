# Yazi Component

## Purpose

Yazi provides the primary file management surface for deepBlack.

It replaces the earlier GUI-first file manager workflow with a terminal-native, keyboard-driven file manager that fits the existing Foot, dwl, and tokenized configuration model.

Yazi is treated as a first-class work surface, not an external themed application.

## Launch Path

MOD + e / ALT+e launches the file manager workflow.

Launch flow:

    source/dwl/config.def.h
        -> scripts/files.sh
        -> foot --app-id deepblack-files
        -> yazi

The launcher lives at:

    scripts/files.sh

## Configuration Layout

Source configuration lives at:

    config/yazi/yazi.toml

Generated theme output is written to:

    generated/yazi/theme.toml

Installed user configuration is written to:

    ~/.config/yazi/yazi.toml
    ~/.config/yazi/theme.toml

## Token Flow

Yazi theme generation follows this path:

    generated/dwl/design_tokens.h
        -> scripts/generate-yazi-theme.sh
        -> generated/yazi/theme.toml
        -> scripts/install-yazi.sh
        -> ~/.config/yazi/theme.toml

The generated theme file should not be edited by hand.

## Theme Behavior

Yazi uses semantic file-manager roles mapped onto the shared deepBlack token system.

The theme generator defines roles for directories, normal files, documentation, source code, configuration files, shell scripts, media files, archives, executable files, hidden files, broken/orphaned targets, pane borders, status indicators, and mode indicators.

ACCENT_PRIMARY remains reserved for active interaction.

It should not become the default color for every file entry.

## Maintenance

Regenerate and install the Yazi configuration with:

    scripts/install-yazi.sh

Clear Yazi cache after theme changes with:

    yazi --clear-cache

Then relaunch with:

    MOD + e / ALT+e

## GUI Fallback

Thunar may be used as an optional GUI fallback for workflows that require a traditional graphical file manager.

Yazi remains the primary deepBlack file manager.

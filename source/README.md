# source

Part of the deepBlack operating environment project.

This directory contains source-managed components that deepBlack builds, vendors, or configures
directly.

## Directories

### dwl

The compositor layer.

The deepBlack session layer launches into the installed dwl compositor through the canonical
session launcher documented in `docs/components/session.md`.

Responsible for window management, keybind routing, monitor behavior, input behavior,
and launching core workflows.

Primary source configuration:

    source/dwl/config.def.h

### mako

Vendored notification daemon source.

deepBlack uses source-level Mako integration so notification behavior can align with the operating
environment instead of relying only on external theme files.

Project-specific notes:

    source/mako/DEEPBLACK_UPSTREAM.md

## Source Philosophy

deepBlack prefers source-level integration where practical.

The goal is to build a coherent operating environment rather than stack unrelated themes
over unrelated applications.

# docs

Part of the deepBlack operating environment project.

Documentation records component behavior, design decisions, installation requirements, portability work, roadmap items, and implementation history.

## Components

- [Session layer](components/session.md)
- [dwl](components/dwl.md)
- [Foot](components/foot.md)
- [Mako](components/mako.md)
- [Neovim](components/neovim.md)
- [Yazi](components/yazi.md)

## Project Documents

- [Installation notes](install.md)
- [Changelog](changelog.md)
- [Roadmap](roadmap.md)

## Profile Model

Hardware behavior is defined beneath:

    profiles/machines/

Visual implementation is defined beneath:

    profiles/flavors/

Machine and flavor profiles are selected independently during the build.

Example:

    ./build.sh --machine silverbullet --flavor nord

Generated output is reproducible and should not be edited by hand.

# tools

Part of the deepBlack operating environment project.

Tools transform tracked machine and flavor profiles into generated component assets.

Generated output is written beneath `generated/` and should not be edited by hand.

## generate-machine-profile.py

Reads a selected machine profile from:

    profiles/machines/<machine>.json

Generates:

    generated/dwl/machine_profile.h
    generated/machine/foot-font-size
    generated/greetd/deepblack-greeter

Machine-profile responsibilities currently include:

- monitor rules and scaling
- compositor modifier
- natural scrolling
- Foot font size
- greeter greeting identity

Example:

    ./tools/generate-machine-profile.py --machine silverbullet

## generate_themes.py

Reads a selected flavor profile from:

    profiles/flavors/<flavor>.json

Generates:

    generated/dwl/design_tokens.h
    generated/foot/foot.ini
    generated/wmenu/deepblack-wmenu

The selected machine’s Foot font size is passed through the `DEEPBLACK_FOOT_FONT_SIZE` environment variable by `build.sh`.

Example:

    DEEPBLACK_FOOT_FONT_SIZE=15 ./tools/generate_themes.py --flavor nord

## generate-nvim-tokens.py

Reads:

    generated/dwl/design_tokens.h

Generates the Lua token module used by the Neovim configuration beneath:

    generated/nvim/

This tool is invoked by:

    scripts/install-nvim.sh

## Normal Usage

The generators are normally orchestrated by the root build rather than run individually.

Generic deepBlack:

    ./build.sh

SilverBullet Nord:

    ./build.sh --machine silverbullet --flavor nord

Clean generated output:

    ./clean.sh

Rebuild through the compatibility entry point:

    ./sync.sh --machine silverbullet --flavor nord

## Generated-File Policy

Tracked source:

    profiles/machines/
    profiles/flavors/
    tools/
    scripts/
    source/dwl/config.def.h

Generated output:

    generated/

Transient dwl compile inputs:

    source/dwl/design_tokens.h
    source/dwl/machine_profile.h
    source/dwl/config.h

Generated and transient files must never become machine-specific repository state.

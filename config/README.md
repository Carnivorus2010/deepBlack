# deepBlack Neovim

Neovim is the primary text editor component for deepBlack.

Design role:

- Hierarchy: HIERARCHY_01 / Primary Work
- Material: MATERIAL_BASE through Foot
- Typography: TYPE_DIAGNOSTIC / TYPE_BODY depending on content
- Motion: MOTION_INSTANT for text input
- Color: generated from `header/design_tokens.h`

The theme is intentionally quiet. `ACCENT_PRIMARY` is reserved for the cursor,
current line number, selections, and active syntax states. It should not become
decoration.

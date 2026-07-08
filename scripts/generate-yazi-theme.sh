#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TOKENS_FILE="$ROOT_DIR/generated/dwl/design_tokens.h"
OUT_DIR="$ROOT_DIR/generated/yazi"
OUT_FILE="$OUT_DIR/theme.toml"

if [ ! -f "$TOKENS_FILE" ]; then
	printf 'deepBlack: missing token file: %s\n' "$TOKENS_FILE" >&2
	exit 1
fi

mkdir -p "$OUT_DIR"

python - "$TOKENS_FILE" "$OUT_FILE" <<'PY'
import re
import sys
from pathlib import Path

tokens_file = Path(sys.argv[1])
out_file = Path(sys.argv[2])

tokens = {}

pattern = re.compile(
    r"^\s*#define\s+([A-Z0-9_]+)\s+(0x[0-9a-fA-F]{6,8}|#[0-9a-fA-F]{6,8})\b"
)

for line in tokens_file.read_text().splitlines():
    line = line.split("/*", 1)[0].split("//", 1)[0]
    match = pattern.match(line)
    if not match:
        continue

    name, raw = match.groups()
    value = raw[2:] if raw.lower().startswith("0x") else raw[1:]
    tokens[name] = f"#{value[:6].lower()}"

def token(name, *fallbacks):
    if name in tokens:
        return tokens[name]

    for fallback in fallbacks:
        if fallback in tokens:
            return tokens[fallback]

    raise SystemExit(
        f"deepBlack: missing required token: {name} "
        f"(fallbacks tried: {', '.join(fallbacks) or 'none'})"
    )

surface_00 = token("SURFACE_00")
surface_01 = token("SURFACE_01", "SURFACE_00")
surface_02 = token("SURFACE_02", "SURFACE_01", "SURFACE_00")
surface_03 = token("SURFACE_03", "SURFACE_02", "SURFACE_01", "SURFACE_00")
surface_04 = token("SURFACE_04", "SURFACE_03", "SURFACE_02", "SURFACE_01", "SURFACE_00")

text_primary = token("TEXT_PRIMARY")
text_secondary = token("TEXT_SECONDARY", "TEXT_PRIMARY")
text_muted = token("TEXT_MUTED", "TEXT_SECONDARY", "TEXT_PRIMARY")

accent = token("ACCENT_PRIMARY")
accent_secondary = token("ACCENT_SECONDARY", "TEXT_SECONDARY", "ACCENT_PRIMARY")
warning = token("STATE_WARNING", "ACCENT_SECONDARY", "ACCENT_PRIMARY")
critical = token("STATE_CRITICAL", "STATE_WARNING", "ACCENT_PRIMARY")

border_inactive = token("BORDER_INACTIVE", "TEXT_MUTED", "TEXT_SECONDARY", "SURFACE_02", "SURFACE_01")
border_active = token("BORDER_ACTIVE", "ACCENT_PRIMARY")

# Yazi semantic roles mapped onto existing deepBlack tokens.
yazi_surface = token("YAZI_SURFACE", "SURFACE_01", "SURFACE_00")
dir_fg = token("YAZI_DIR", "TEXT_PRIMARY")
file_fg = token("YAZI_FILE", "TEXT_SECONDARY", "TEXT_PRIMARY")
doc_fg = token("YAZI_DOC", "TEXT_PRIMARY")
code_fg = token("YAZI_CODE", "TEXT_PRIMARY")
config_fg = token("YAZI_CONFIG", "ACCENT_SECONDARY", "TEXT_SECONDARY", "TEXT_PRIMARY")
script_fg = token("YAZI_SCRIPT", "ACCENT_SECONDARY", "TEXT_SECONDARY", "TEXT_PRIMARY")
media_fg = token("YAZI_MEDIA", "ACCENT_SECONDARY", "TEXT_SECONDARY", "TEXT_PRIMARY")
archive_fg = token("YAZI_ARCHIVE", "STATE_WARNING", "ACCENT_SECONDARY", "TEXT_SECONDARY")
exec_fg = token("YAZI_EXEC", "ACCENT_PRIMARY")
hidden_fg = token("YAZI_HIDDEN", "TEXT_MUTED", "TEXT_SECONDARY")

def style(fg=None, bg=None, bold=False, dim=False, italic=False, underline=False, reversed=False):
    parts = []
    if fg:
        parts.append(f'fg = "{fg}"')
    if bg:
        parts.append(f'bg = "{bg}"')
    if bold:
        parts.append("bold = true")
    if dim:
        parts.append("dim = true")
    if italic:
        parts.append("italic = true")
    if underline:
        parts.append("underline = true")
    if reversed:
        parts.append("reversed = true")
    return "{ " + ", ".join(parts) + " }"

content = f'''# deepBlack generated Yazi theme
# Source: generated/dwl/design_tokens.h
# Do not edit directly. Run scripts/generate-yazi-theme.sh.

[app]
overall = {style(bg=yazi_surface)}

[mgr]
cwd = {style(fg=text_primary, bold=True)}
find_keyword = {style(fg=surface_00, bg=accent, bold=True)}
find_position = {style(fg=text_muted)}
symlink_target = {style(fg=text_muted, italic=True)}

marker_copied = {style(fg=accent, bold=True)}
marker_cut = {style(fg=warning, bold=True)}
marker_marked = {style(fg=accent_secondary, bold=True)}
marker_selected = {style(fg=accent, bg=surface_02, bold=True)}

count_copied = {style(fg=accent, bold=True)}
count_cut = {style(fg=warning, bold=True)}
count_selected = {style(fg=accent_secondary, bold=True)}

border_symbol = "│"
border_style = {style(fg=border_inactive)}

[indicator]
parent = {style(fg=border_inactive)}
current = {style(fg=accent)}
preview = {style(fg=border_inactive)}
padding = {{ open = "▐", close = "▌" }}

[tabs]
active = {style(fg=accent, bg=surface_01, bold=True)}
inactive = {style(fg=text_muted, bg=yazi_surface)}
sep_inner = {{ open = "", close = "" }}
sep_outer = {{ open = "", close = "" }}

[mode]
normal_main = {style(fg=accent, bg=surface_01, bold=True)}
normal_alt = {style(fg=text_muted, bg=yazi_surface)}
select_main = {style(fg=accent_secondary, bg=surface_01, bold=True)}
select_alt = {style(fg=text_muted, bg=yazi_surface)}
unset_main = {style(fg=warning, bg=surface_01, bold=True)}
unset_alt = {style(fg=text_muted, bg=yazi_surface)}

[status]
overall = {style(fg=text_secondary, bg=yazi_surface)}
sep_left = {{ open = "", close = "" }}
sep_right = {{ open = "", close = "" }}

perm_type = {style(fg=text_muted)}
perm_read = {style(fg=text_muted)}
perm_write = {style(fg=text_muted)}
perm_exec = {style(fg=text_muted)}
perm_sep = {style(fg=surface_02)}

progress_label = {style(fg=text_primary, bold=True)}
progress_normal = {style(fg=accent, bg=surface_02)}
progress_error = {style(fg=critical, bg=surface_02)}

[which]
cols = 3
mask = {style(bg=surface_01)}
cand = {style(fg=accent, bold=True)}
rest = {style(fg=text_secondary)}
desc = {style(fg=text_primary)}
separator = " → "
separator_style = {style(fg=text_muted)}

[confirm]
border = {style(fg=warning)}
title = {style(fg=warning, bold=True)}
body = {style(fg=text_primary)}
list = {style(fg=text_secondary)}
btn_yes = {style(fg=accent, bg=surface_02, bold=True)}
btn_no = {style(fg=text_secondary, bg=surface_01)}
btn_labels = [" confirm ", " cancel "]

[input]
border = {style(fg=accent)}
title = {style(fg=accent, bold=True)}
value = {style(fg=text_primary)}
selected = {style(fg=accent, bg=surface_02)}

[cmp]
border = {style(fg=border_inactive)}
active = {style(fg=accent, bg=surface_02, bold=True)}
inactive = {style(fg=text_secondary)}
icon_file = "∷"
icon_folder = "▣"
icon_command = "λ"

[tasks]
border = {style(fg=border_inactive)}
title = {style(fg=accent, bold=True)}
hovered = {style(fg=accent, bg=surface_02)}

[help]
on = {style(fg=accent, bold=True)}
run = {style(fg=text_primary)}
desc = {style(fg=text_secondary)}
hovered = {style(fg=accent, bg=surface_02)}
footer = {style(fg=text_muted)}
icon_info = "i"
icon_warn = "!"
icon_error = "×"

[notify]
title_info = {style(fg=accent, bold=True)}
title_warn = {style(fg=warning, bold=True)}
title_error = {style(fg=critical, bold=True)}

[pick]
border = {style(fg=border_inactive)}
active = {style(fg=accent, bg=surface_02, bold=True)}
inactive = {style(fg=text_secondary)}

[filetype]
rules = [
	{{ url = "*", is = "orphan", fg = "{critical}" }},
	{{ url = "*/", fg = "{dir_fg}", bold = true }},
	{{ url = ".*", fg = "{hidden_fg}" }},
	{{ url = "*.md", fg = "{doc_fg}", bold = true }},
	{{ url = "README*", fg = "{doc_fg}", bold = true }},
	{{ url = "TODO*", fg = "{doc_fg}" }},
	{{ url = "LICENSE*", fg = "{doc_fg}" }},
	{{ url = "VERSION", fg = "{doc_fg}" }},
	{{ url = "Makefile", fg = "{config_fg}" }},
	{{ url = "*.toml", fg = "{config_fg}" }},
	{{ url = "*.conf", fg = "{config_fg}" }},
	{{ url = "*.mk", fg = "{config_fg}" }},
	{{ url = "*.h", fg = "{code_fg}" }},
	{{ url = "*.c", fg = "{code_fg}" }},
	{{ url = "*.lua", fg = "{code_fg}" }},
	{{ url = "*.sh", fg = "{script_fg}" }},
	{{ url = "*.py", fg = "{script_fg}" }},
	{{ url = "*.png", fg = "{media_fg}" }},
	{{ url = "*.jpg", fg = "{media_fg}" }},
	{{ url = "*.jpeg", fg = "{media_fg}" }},
	{{ url = "*.webp", fg = "{media_fg}" }},
	{{ url = "*.svg", fg = "{media_fg}" }},
	{{ mime = "{{audio,video}}/*", fg = "{media_fg}" }},
	{{ mime = "application/{{zip,gzip,x-tar,x-bzip,x-bzip2,x-7z-compressed,x-rar}}", fg = "{archive_fg}" }},
	{{ url = "*", is = "exec", fg = "{exec_fg}" }},
	{{ url = "*", fg = "{file_fg}" }},
]

[icon]
prepend_dirs = [
	{{ name = ".git", text = "", fg = "{hidden_fg}" }},
	{{ name = "config", text = "", fg = "{config_fg}" }},
	{{ name = "configs", text = "", fg = "{config_fg}" }},
	{{ name = "scripts", text = "󰯂", fg = "{script_fg}" }},
	{{ name = "source", text = "󰘧", fg = "{code_fg}" }},
	{{ name = "docs", text = "󰈙", fg = "{doc_fg}" }},
	{{ name = "generated", text = "󰚰", fg = "{text_muted}" }},
]

prepend_files = [
	{{ name = "README.md", text = "󰈙", fg = "{doc_fg}" }},
	{{ name = "TODO.md", text = "󰔟", fg = "{doc_fg}" }},
	{{ name = "LICENSE", text = "󰿃", fg = "{doc_fg}" }},
	{{ name = "Makefile", text = "󰛕", fg = "{config_fg}" }},
]

prepend_exts = [
	{{ name = "sh", text = "󱆃", fg = "{script_fg}" }},
	{{ name = "py", text = "󰌠", fg = "{script_fg}" }},
	{{ name = "toml", text = "󱁿", fg = "{config_fg}" }},
	{{ name = "conf", text = "", fg = "{config_fg}" }},
	{{ name = "c", text = "", fg = "{code_fg}" }},
	{{ name = "h", text = "", fg = "{code_fg}" }},
	{{ name = "lua", text = "", fg = "{code_fg}" }},
	{{ name = "md", text = "󰍔", fg = "{doc_fg}" }},
	{{ name = "png", text = "󰋩", fg = "{media_fg}" }},
	{{ name = "jpg", text = "󰋩", fg = "{media_fg}" }},
	{{ name = "jpeg", text = "󰋩", fg = "{media_fg}" }},
	{{ name = "webp", text = "󰋩", fg = "{media_fg}" }},
]

prepend_conds = [
	{{ if = "orphan", text = "×", fg = "{critical}" }},
	{{ if = "exec", text = "λ", fg = "{exec_fg}" }},
	{{ if = "hidden", text = "·", fg = "{hidden_fg}" }},
	{{ if = "dir", text = "▣", fg = "{dir_fg}" }},
	{{ if = "!dir", text = "∷", fg = "{file_fg}" }},
]
'''

out_file.write_text(content)
print(f"deepBlack: generated {out_file}")
PY

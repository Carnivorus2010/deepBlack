local M = {}

local fallback = {
  SURFACE_00 = "#000000",
  SURFACE_01 = "#050805",
  SURFACE_02 = "#0b120d",
  SURFACE_03 = "#101a12",
  SURFACE_04 = "#17231a",
  TEXT_PRIMARY = "#d8f7df",
  TEXT_SECONDARY = "#8fa897",
  TEXT_MUTED = "#4d6654",
  ACCENT_PRIMARY = "#39ff14",
  ACCENT_DIAGNOSTIC = "#66ff99",
  BORDER_INACTIVE = "#1a2a1d",
  BORDER_ACTIVE = "#39ff14",
  STATE_SUCCESS = "#39ff14",
  STATE_WARNING = "#d6b85a",
  STATE_CRITICAL = "#ff3b3b",
}

local function tokens()
  local ok, generated = pcall(require, "deepblack.tokens")
  if not ok or type(generated) ~= "table" then
    return fallback
  end

  return setmetatable(generated, { __index = fallback })
end

local function hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

function M.apply()
  local t = tokens()
  vim.cmd("highlight clear")
  vim.g.colors_name = "deepblack"

  hl("Normal", { fg = t.TEXT_PRIMARY, bg = t.SURFACE_00 })
  hl("NormalNC", { fg = t.TEXT_SECONDARY, bg = t.SURFACE_00 })
  hl("NormalFloat", { fg = t.TEXT_PRIMARY, bg = t.SURFACE_03 })
  hl("FloatBorder", { fg = t.BORDER_ACTIVE, bg = t.SURFACE_03 })

  -- Cursor language
  -- ACCENT_PRIMARY communicates current focus / active insertion point.
  hl("Cursor", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY })
  hl("lCursor", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY })
  hl("CursorIM", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY })

  hl("CursorInsert", { fg = t.ACCENT_PRIMARY, bg = t.ACCENT_PRIMARY })
  hl("CursorReplace", { fg = t.SURFACE_00, bg = t.STATE_WARNING })

  hl("TermCursor", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY })
  hl("TermCursorNC", { fg = t.TEXT_MUTED, bg = t.SURFACE_02 })

  hl("CursorLine", { bg = t.SURFACE_01 })
  hl("CursorLineNr", { fg = t.ACCENT_PRIMARY, bg = t.SURFACE_01, bold = true })
  hl("LineNr", { fg = t.TEXT_MUTED, bg = t.SURFACE_00 })
  hl("SignColumn", { fg = t.TEXT_MUTED, bg = t.SURFACE_00 })
  hl("ColorColumn", { bg = t.SURFACE_01 })

  hl("Visual", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY })
  hl("Search", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY })
  hl("IncSearch", { fg = t.SURFACE_00, bg = t.ACCENT_DIAGNOSTIC })

  hl("StatusLine", { fg = t.TEXT_PRIMARY, bg = t.SURFACE_01 })
  hl("StatusLineNC", { fg = t.TEXT_MUTED, bg = t.SURFACE_00 })
  hl("WinSeparator", { fg = t.BORDER_INACTIVE, bg = t.SURFACE_00 })

  hl("Pmenu", { fg = t.TEXT_PRIMARY, bg = t.SURFACE_03 })
  hl("PmenuSel", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY })
  hl("PmenuSbar", { bg = t.SURFACE_02 })
  hl("PmenuThumb", { bg = t.TEXT_MUTED })

  hl("Comment", { fg = t.TEXT_MUTED, italic = true })
  hl("Constant", { fg = t.TEXT_PRIMARY })
  hl("String", { fg = t.TEXT_SECONDARY })
  hl("Identifier", { fg = t.TEXT_PRIMARY })
  hl("Function", { fg = t.ACCENT_DIAGNOSTIC })
  hl("Statement", { fg = t.ACCENT_PRIMARY })
  hl("Keyword", { fg = t.ACCENT_PRIMARY })
  hl("Type", { fg = t.TEXT_SECONDARY })
  hl("PreProc", { fg = t.TEXT_SECONDARY })
  hl("Special", { fg = t.ACCENT_DIAGNOSTIC })

  hl("DiagnosticError", { fg = t.STATE_CRITICAL })
  hl("DiagnosticWarn", { fg = t.STATE_WARNING })
  hl("DiagnosticInfo", { fg = t.ACCENT_DIAGNOSTIC })
  hl("DiagnosticHint", { fg = t.TEXT_MUTED })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = t.STATE_CRITICAL })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = t.STATE_WARNING })

  hl("DiffAdd", { fg = t.STATE_SUCCESS, bg = t.SURFACE_01 })
  hl("DiffChange", { fg = t.STATE_WARNING, bg = t.SURFACE_01 })
  hl("DiffDelete", { fg = t.STATE_CRITICAL, bg = t.SURFACE_01 })

  hl("Directory", { fg = t.ACCENT_PRIMARY })
  hl("Title", { fg = t.ACCENT_PRIMARY, bold = true })
  hl("NonText", { fg = t.TEXT_MUTED })
  hl("EndOfBuffer", { fg = t.SURFACE_00 })

  -- Yank feedback
  hl("YankHighlight", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY, bold = true })

  -- Telescope
  hl("TelescopeNormal", { fg = t.TEXT_PRIMARY, bg = t.SURFACE_03 })
  hl("TelescopeBorder", { fg = t.BORDER_ACTIVE, bg = t.SURFACE_03 })
  hl("TelescopePromptNormal", { fg = t.TEXT_PRIMARY, bg = t.SURFACE_02 })
  hl("TelescopePromptBorder", { fg = t.BORDER_ACTIVE, bg = t.SURFACE_02 })
  hl("TelescopePromptPrefix", { fg = t.ACCENT_PRIMARY, bg = t.SURFACE_02 })
  hl("TelescopeSelection", { fg = t.SURFACE_00, bg = t.ACCENT_PRIMARY, bold = true })
  hl("TelescopeMatching", { fg = t.ACCENT_DIAGNOSTIC, bold = true })

  -- NvimTree
  hl("NvimTreeNormal", { fg = t.TEXT_PRIMARY, bg = t.SURFACE_01 })
  hl("NvimTreeNormalNC", { fg = t.TEXT_SECONDARY, bg = t.SURFACE_01 })
  hl("NvimTreeCursorLine", { bg = t.SURFACE_03 })
  hl("NvimTreeFolderName", { fg = t.ACCENT_DIAGNOSTIC })
  hl("NvimTreeOpenedFolderName", { fg = t.ACCENT_PRIMARY, bold = true })
  hl("NvimTreeRootFolder", { fg = t.ACCENT_PRIMARY, bold = true })
  hl("NvimTreeIndentMarker", { fg = t.TEXT_MUTED })
  hl("NvimTreeGitDirty", { fg = t.STATE_WARNING })
  hl("NvimTreeGitNew", { fg = t.STATE_SUCCESS })
  hl("NvimTreeGitDeleted", { fg = t.STATE_CRITICAL })

  -- Bufferline / tab-like buffer bar
  hl("BufferLineFill", { bg = t.SURFACE_00 })
  hl("BufferLineBackground", { fg = t.TEXT_MUTED, bg = t.SURFACE_00 })
  hl("BufferLineBufferVisible", { fg = t.TEXT_SECONDARY, bg = t.SURFACE_00 })
  hl("BufferLineBufferSelected", { fg = t.ACCENT_PRIMARY, bg = t.SURFACE_01, bold = true })
  hl("BufferLineSeparator", { fg = t.BORDER_INACTIVE, bg = t.SURFACE_00 })
  hl("BufferLineSeparatorSelected", { fg = t.BORDER_ACTIVE, bg = t.SURFACE_01 })
  hl("BufferLineIndicatorSelected", { fg = t.ACCENT_PRIMARY, bg = t.SURFACE_01 })
end

return M

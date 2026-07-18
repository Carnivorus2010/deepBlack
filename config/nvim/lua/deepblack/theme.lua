local M = {}

local fallback = {
  SURFACE_00 = "#000000",
  SURFACE_01 = "#050805",
  SURFACE_02 = "#080c08",
  SURFACE_03 = "#101a12",
  SURFACE_04 = "#17231a",

  TEXT_PRIMARY = "#d8ffe0",
  TEXT_SECONDARY = "#7fa88a",
  TEXT_MUTED = "#4d6654",

  ACCENT_PRIMARY = "#39ff14",
  ACCENT_SECONDARY = "#1f7f35",
  ACCENT_DIAGNOSTIC = "#7cff9b",

  BORDER_INACTIVE = "#113311",
  BORDER_ACTIVE = "#39ff14",
  BORDER_CRITICAL = "#ff0033",

  STATE_SUCCESS = "#39ff14",
  STATE_WARNING = "#ffb000",
  STATE_CRITICAL = "#ff0033",

  SYNTAX_COMMENT = "#4d6654",
  SYNTAX_KEYWORD = "#c792ea",
  SYNTAX_FUNCTION = "#7cff9b",
  SYNTAX_STRING = "#8fd6a0",
  SYNTAX_NUMBER = "#d6b85a",
  SYNTAX_TYPE = "#66c7d1",
  SYNTAX_CONSTANT = "#ff9e64",
  SYNTAX_OPERATOR = "#9fb8a6",
  SYNTAX_SPECIAL = "#ffd166",
  SYNTAX_VARIABLE = "#d8ffe0",
  SYNTAX_PROPERTY = "#5fbf8f",
  SYNTAX_PARAMETER = "#b6d9bf",
  SYNTAX_PREPROC = "#b48ead",
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

  -- Syntax language
  hl("Comment", { fg = t.SYNTAX_COMMENT, italic = true })

  hl("Constant", { fg = t.SYNTAX_CONSTANT })
  hl("String", { fg = t.SYNTAX_STRING })
  hl("Character", { fg = t.SYNTAX_STRING })
  hl("Number", { fg = t.SYNTAX_NUMBER })
  hl("Boolean", { fg = t.SYNTAX_CONSTANT, bold = true })
  hl("Float", { fg = t.SYNTAX_NUMBER })

  hl("Identifier", { fg = t.SYNTAX_VARIABLE })
  hl("Function", { fg = t.SYNTAX_FUNCTION })

  hl("Statement", { fg = t.SYNTAX_KEYWORD })
  hl("Conditional", { fg = t.SYNTAX_KEYWORD })
  hl("Repeat", { fg = t.SYNTAX_KEYWORD })
  hl("Label", { fg = t.SYNTAX_KEYWORD })
  hl("Keyword", { fg = t.SYNTAX_KEYWORD })
  hl("Exception", { fg = t.SYNTAX_KEYWORD })
  hl("Operator", { fg = t.SYNTAX_OPERATOR })

  hl("Type", { fg = t.SYNTAX_TYPE })
  hl("StorageClass", { fg = t.SYNTAX_TYPE })
  hl("Structure", { fg = t.SYNTAX_TYPE })
  hl("Typedef", { fg = t.SYNTAX_TYPE })

  hl("PreProc", { fg = t.SYNTAX_PREPROC })
  hl("Include", { fg = t.SYNTAX_PREPROC })
  hl("Define", { fg = t.SYNTAX_PREPROC })
  hl("Macro", { fg = t.SYNTAX_PREPROC })
  hl("PreCondit", { fg = t.SYNTAX_PREPROC })

  hl("Special", { fg = t.SYNTAX_SPECIAL })
  hl("SpecialChar", { fg = t.SYNTAX_SPECIAL })
  hl("Tag", { fg = t.SYNTAX_SPECIAL })
  hl("Delimiter", { fg = t.SYNTAX_OPERATOR })
  hl("SpecialComment", { fg = t.SYNTAX_COMMENT })
  hl("Debug", { fg = t.STATE_WARNING })

  hl("Property", { fg = t.SYNTAX_PROPERTY })
  hl("Parameter", { fg = t.SYNTAX_PARAMETER })

  -- Treesitter capture language. These are harmless until a parser is active.
  hl("@comment", { link = "Comment" })
  hl("@comment.documentation", { link = "Comment" })

  hl("@string", { link = "String" })
  hl("@string.documentation", { link = "String" })
  hl("@string.regexp", { link = "Special" })
  hl("@character", { link = "Character" })

  hl("@number", { link = "Number" })
  hl("@number.float", { link = "Float" })
  hl("@boolean", { link = "Boolean" })

  hl("@constant", { link = "Constant" })
  hl("@constant.builtin", { link = "Constant" })
  hl("@constant.macro", { link = "Constant" })

  hl("@variable", { link = "Identifier" })
  hl("@variable.builtin", { link = "Special" })
  hl("@variable.member", { link = "Property" })
  hl("@property", { link = "Property" })
  hl("@field", { link = "Property" })
  hl("@variable.parameter", { link = "Parameter" })
  hl("@parameter", { link = "Parameter" })

  hl("@function", { link = "Function" })
  hl("@function.call", { link = "Function" })
  hl("@function.builtin", { link = "Function" })
  hl("@function.macro", { link = "Macro" })
  hl("@function.method", { link = "Function" })
  hl("@function.method.call", { link = "Function" })
  hl("@method", { link = "Function" })
  hl("@method.call", { link = "Function" })
  hl("@constructor", { link = "Type" })

  hl("@keyword", { link = "Keyword" })
  hl("@keyword.function", { link = "Keyword" })
  hl("@keyword.operator", { link = "Keyword" })
  hl("@keyword.return", { link = "Keyword" })
  hl("@keyword.conditional", { link = "Conditional" })
  hl("@keyword.repeat", { link = "Repeat" })
  hl("@keyword.exception", { link = "Exception" })
  hl("@operator", { link = "Operator" })

  hl("@type", { link = "Type" })
  hl("@type.builtin", { link = "Type" })
  hl("@type.definition", { link = "Typedef" })
  hl("@module", { link = "Type" })
  hl("@namespace", { link = "Type" })

  hl("@attribute", { link = "PreProc" })
  hl("@attribute.builtin", { link = "PreProc" })

  hl("@punctuation.delimiter", { link = "Delimiter" })
  hl("@punctuation.bracket", { link = "Delimiter" })
  hl("@punctuation.special", { link = "Special" })

  hl("@tag", { link = "Tag" })
  hl("@tag.attribute", { link = "Property" })
  hl("@tag.delimiter", { link = "Delimiter" })

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

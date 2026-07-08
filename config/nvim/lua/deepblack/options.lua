-- Cursor behavior
-- Uses highlight groups defined in deepblack/theme.lua.
vim.opt.guicursor = table.concat({
	"n-v-c:block-Cursor",
	"i-ci-ve:ver25-CursorInsert",
	"r-cr:hor20-CursorReplace",
	"o:hor50-Cursor",
	"a:blinkon0",
}, ",")

-- Cursor behavior
vim.opt.guicursor = table.concat({
	"n-v-c:block-Cursor",
	"i-ci-ve:ver25-CursorInsert",
	"r-cr:hor20-CursorReplace",
	"o:hor50-Cursor",
	"a:blinkon0",
}, ",")

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "100"

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.cmdheight = 1

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.statusline = " deepBlack :: %f %m%r %= %y  %l:%c "

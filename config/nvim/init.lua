vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("deepblack.options")
require("deepblack.keymaps")
require("deepblack.plugins").setup()
require("deepblack.theme").apply()
require("deepblack.autocmds")
require("deepblack.lsp")

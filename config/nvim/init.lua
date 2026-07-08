vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("deepblack.options")
require("deepblack.keymaps")
require("deepblack.theme").apply()
pcall(require, "deepblack.lsp")

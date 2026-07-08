local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>w", ":write<CR>", opts)
map("n", "<leader>q", ":quit<CR>", opts)
map("n", "<leader>Q", ":quitall<CR>", opts)
map("n", "<leader>h", ":nohlsearch<CR>", opts)

map("n", "<leader>v", ":vsplit<CR>", opts)
map("n", "<leader>s", ":split<CR>", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map({ "n", "v" }, "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+Y', opts)
map({ "n", "v" }, "<leader>p", '"+p', opts)

map("n", "<Esc>", ":nohlsearch<CR>", opts)

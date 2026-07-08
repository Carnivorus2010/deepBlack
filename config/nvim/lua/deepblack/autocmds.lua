local group = vim.api.nvim_create_augroup("deepblack.autocmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight yanked text",
  callback = function()
    local on_yank = vim.hl and vim.hl.on_yank or vim.highlight.on_yank

    on_yank({
      higroup = "YankHighlight",
      timeout = 350,
      on_visual = true,
    })
  end,
})

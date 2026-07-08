-- Native LSP wiring. This intentionally avoids plugin dependency for v0.1.x.
-- Servers are enabled only when their executables exist on the system.

if not (vim.lsp and vim.lsp.config and vim.lsp.enable) then
  return
end

local servers = {
  lua_ls = "lua-language-server",
  bashls = "bash-language-server",
  clangd = "clangd",
  pyright = "pyright-langserver",
}

for server, executable in pairs(servers) do
  if vim.fn.executable(executable) == 1 then
    vim.lsp.config(server, {})
    vim.lsp.enable(server)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, noremap = true, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

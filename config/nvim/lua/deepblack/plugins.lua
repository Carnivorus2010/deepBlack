local M = {}

function M.setup()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = "Telescope",
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search text" },
        { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
        { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
        { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      },
      config = function()
        require("telescope").setup({
          defaults = {
            prompt_prefix = "SEARCH > ",
            selection_caret = "ACTIVE > ",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
              },
            },
            color_devicons = false,
          },
        })
      end,
    },

    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
        { "<leader>E", "<cmd>NvimTreeFocus<CR>", desc = "Focus file tree" },
      },
      config = function()
        require("nvim-tree").setup({
          disable_netrw = true,
          hijack_netrw = true,
          view = {
            width = 32,
            side = "left",
          },
          renderer = {
            group_empty = true,
            highlight_git = true,
            indent_markers = {
              enable = true,
            },
            icons = {
              show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = false,
              },
            },
          },
          filters = {
            dotfiles = false,
          },
          actions = {
            open_file = {
              quit_on_open = false,
              resize_window = true,
            },
          },
        })
      end,
    },

    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      keys = {
        { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
        { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
        { "<leader>bd", "<cmd>bdelete<CR>", desc = "Close buffer" },
      },
      config = function()
        require("bufferline").setup({
          options = {
            mode = "buffers",
            diagnostics = "nvim_lsp",
            separator_style = "thin",
            show_buffer_close_icons = false,
            show_close_icon = false,
            always_show_bufferline = true,
            offsets = {
              {
                filetype = "NvimTree",
                text = "PROJECT",
                text_align = "left",
                separator = true,
              },
            },
          },
        })
      end,
    },
  })
end

return M

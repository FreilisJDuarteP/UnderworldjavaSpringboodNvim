return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",

    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_close_icon = false,
          show_buffer_close_icons = false,
        },
      })

      vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>")
      vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>")
    end,
  },
}

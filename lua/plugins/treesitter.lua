return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,

    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end

      ts.setup({
        ensure_installed = {
          "lua",
          "java",
          "bash",
          "json",
          "markdown",
          "markdown_inline",
        },

        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}

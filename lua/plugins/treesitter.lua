return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local ts = require("nvim-treesitter")

      -- 1. Configuración básica (setup)
      ts.setup({
        -- Opcional: solo si quieres mover donde se instalan
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- 2. Instalación de parsers (el reemplazo de ensure_installed)
      -- Esto es un "no-op" si ya están instalados, así que es seguro tenerlo aquí
      ts.install({ "lua", "java", "markdown", "markdown_inline", "bash" })
    end,
  },
}

return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvim-treesitter/nvim-treesitter",
    },

    config = function()
      -- =========================
      -- Setup básico
      -- =========================
      local autopairs = require("nvim-autopairs")

      autopairs.setup({
        check_ts = true, -- usa treesitter para contexto inteligente
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false, -- evita bugs del parser java
        },
      })

      -- =========================
      -- Integración con CMP
      -- =========================
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}

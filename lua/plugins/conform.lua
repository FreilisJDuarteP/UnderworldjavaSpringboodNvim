return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      java = { "google-java-format" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
    },
  },
}

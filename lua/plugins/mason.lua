return {

	-------------------------------------------------

	-- MASON

	-------------------------------------------------

	{

		"williamboman/mason.nvim",

		build = ":MasonUpdate",

		config = function()
			require("mason").setup()
		end,

	},

	-------------------------------------------------

	-- MASON LSPCONFIG

	-------------------------------------------------

	{

		"williamboman/mason-lspconfig.nvim",

		dependencies = { "mason.nvim" },

		config = function()
			require("mason-lspconfig").setup({

				ensure_installed = {

					"lua_ls", -- SOLO LUA AQUÍ

				},

			})
		end,

	},


	-------------------------------------------------

	-- LSP (Neovim 0.11+ API)

	-------------------------------------------------

	{

		"neovim/nvim-lspconfig",

		dependencies = {

			"mason-lspconfig.nvim",

			"hrsh7th/cmp-nvim-lsp",

		},


		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()


			-- LUA

			vim.lsp.config("lua_ls", {

				capabilities = capabilities,

				settings = {

					Lua = {

						diagnostics = { globals = { "vim" } },

					},

				},

			})


			vim.lsp.enable("lua_ls")
		end,

	},

}

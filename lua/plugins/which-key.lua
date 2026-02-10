return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",

		opts = {
			preset = "modern",

			win = {
				border = "rounded",
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
			},

			layout = {
				height = { min = 4, max = 25 },
				width = { min = 20, max = 50 },
				spacing = 3,
				align = "left",
			},

			icons = {
				breadcrumb = "»",
				separator = "➜",
				group = "+",
			},

			show_help = true,
			show_keys = true,
		},

		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)

			-- 📂 SOLO GRUPOS (no comandos)
			wk.add({
				{ "<leader>f", group = "Find" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>t", group = "Toggle" },

				-- Java
				{ "<leader>j", group = "Java (JDTLS)" },
				{ "<leader>r", group = "Run / Execute" },
			})
		end,
	},
}

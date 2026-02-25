return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false, -- 🔥 asegura que cargue primero

		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
					lualine = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },

		config = function()
			require("lualine").setup({
				options = {
					theme = "auto", -- 🔥 importante
					globalstatus = true,
					section_separators = "",
					component_separators = "",
				},
			})
		end,
	},

	{ "echasnovski/mini.icons", version = false },
}

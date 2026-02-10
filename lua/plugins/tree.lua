return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",

	config = function()
		require("nvim-tree").setup({
			view = {
				width = 30,
				relativenumber = true, -- Te ayuda a moverte con saltos numéricos dentro del árbol
			},
			renderer = {
				highlight_opened_files = "all", -- Resalta los archivos que tienes en buffers
			},
			sync_root_with_cwd = true, -- Mantiene el árbol sincronizado con tu carpeta de trabajo
		})
	end
}

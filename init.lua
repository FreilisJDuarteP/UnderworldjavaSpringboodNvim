require("config.options")
require("config.keybinds")
require("config.lazy")

--treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "java" },
	callback = function()
		vim.treesitter.start()
	end,
})
--- cierra

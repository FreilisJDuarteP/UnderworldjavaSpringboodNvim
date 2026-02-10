return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- ===== LOGO UNDERWORLD =====
		dashboard.section.header.val = {
			" ██╗   ██╗███╗   ██╗██████╗ ███████╗██████╗ ██╗    ██╗ ██████╗ ██████╗ ██╗     ██████╗ ",
			" ██║   ██║████╗  ██║██╔══██╗██╔════╝██╔══██╗██║    ██║██╔═══██╗██╔══██╗██║     ██╔══██╗",
			" ██║   ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝██║ █╗ ██║██║   ██║██████╔╝██║     ██║  ██║",
			" ██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗██║███╗██║██║   ██║██╔══██╗██║     ██║  ██║",
			" ╚██████╔╝██║ ╚████║██████╔╝███████╗██║  ██║╚███╔███╔╝╚██████╔╝██║  ██║███████╗██████╔╝",
			"  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ",
		}

		-- ===== BOTONES =====
		dashboard.section.buttons.val = {
			dashboard.button("e", "  Explorer", "<leader>e"),
			dashboard.button("f", "󰱼  Find File", "<leader>ff"),
			dashboard.button("g", "󰱼  Live Grep", "<leader>fg"),
			dashboard.button("r", "󰄉  Recent Files", "<cmd>Telescope oldfiles<cr>"),
			dashboard.button("c", "  Config", "<cmd>edit $MYVIMRC<cr>"),
			dashboard.button("t", "  Terminal", "<leader>tt"),
			dashboard.button("q", "󰅚  Quit", "<cmd>qa<cr>"),
		}

		-- ===== FOOTER =====
		dashboard.section.footer.val =
		"⚡ UNDERWORLD — Java · Spring · Debug · Control absoluto"

		dashboard.config.opts.noautocmd = true
		alpha.setup(dashboard.config)
	end,
}

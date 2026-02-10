return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },

		config = function()
			local jdtls = require("jdtls")
			local wk = require("which-key")
			local home = os.getenv("HOME")
			local bufnr = vim.api.nvim_get_current_buf()

			-- 📁 Workspace por proyecto
			local workspace_dir = home
			    .. "/.local/share/nvim/jdtls-workspace/"
			    .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

			-- 📍 Root del proyecto
			local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
			local root_dir = require("jdtls.setup").find_root(root_markers)

			if not root_dir then
				return
			end

			-- 🧠 Lombok (desde Mason)
			local mason_data = vim.fn.stdpath("data")
			local lombok_path = mason_data .. "/mason/packages/jdtls/lombok.jar"

			-- 📦 Java Debug + Test bundles
			local bundles = {}
			local mason_packages = mason_data .. "/mason/packages"

			vim.list_extend(
				bundles,
				vim.split(
					vim.fn.glob(
						mason_packages
						.. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
					),
					"\n"
				)
			)

			vim.list_extend(
				bundles,
				vim.split(
					vim.fn.glob(
						mason_packages .. "/java-test/extension/server/*.jar"
					),
					"\n"
				)
			)

			-- ⚙️ Configuración final de jdtls
			local config = {
				cmd = {
					"jdtls",
					"--jvm-arg=-javaagent:" .. lombok_path,
				},

				root_dir = root_dir,
				workspace_folder = workspace_dir,

				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "JavaSE-21",
									path = vim.fn.expand(
									"~/.sdkman/candidates/java/current"),
								},
							},
						},
					},
				},

				init_options = {
					bundles = bundles,
				},
			}

			-- 🚀 Arranque / attach
			jdtls.start_or_attach(config)

			-- 🐞 Debug Java
			jdtls.setup_dap({ hotcodereplace = "auto" })
			jdtls.setup.add_commands()

			-- ⌨️ Keybinds Java (OFICIALES y CORRECTOS)
			wk.add({
				-- Grupo
				{ "<leader>j",  name = "Java",               buffer = bufnr },

				-- Imports / Build
				{ "<leader>jo", jdtls.organize_imports,      desc = "Organize Imports",         buffer = bufnr },
				{ "<leader>jb", "<cmd>JdtCompile<cr>",       desc = "Compile Project",          buffer = bufnr },
				{ "<leader>ju", "<cmd>JdtUpdateConfig<cr>",  desc = "Update Project Config",    buffer = bufnr },
				{ "<leader>jr", "<cmd>JdtRestart<cr>",       desc = "Restart JDTLS",            buffer = bufnr },

				-- Runtime
				{ "<leader>js", "<cmd>JdtSetRuntime<cr>",    desc = "Select Java Runtime",      buffer = bufnr },

				-- Generate
				{ "<leader>jg", jdtls.generate,              desc = "Generate Code",            buffer = bufnr },
				{ "<leader>jc", jdtls.generate_constructors, desc = "Generate Constructors",    buffer = bufnr },
				{ "<leader>ja", jdtls.generate_accessors,    desc = "Generate Getters/Setters", buffer = bufnr },

				-- Extract
				{ "<leader>jm", jdtls.extract_method,        desc = "Extract Method",           buffer = bufnr },
				{ "<leader>jv", jdtls.extract_variable,      desc = "Extract Variable",         buffer = bufnr },
				{ "<leader>jk", jdtls.extract_constant,      desc = "Extract Constant",         buffer = bufnr },

				-- Tests
				{ "<leader>jt", jdtls.test_class,            desc = "Test Class",               buffer = bufnr },
				{ "<leader>jn", jdtls.test_nearest_method,   desc = "Test Nearest Method",      buffer = bufnr },
			})
		end,
	},
}

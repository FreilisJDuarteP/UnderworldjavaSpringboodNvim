return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },

		config = function()
			local jdtls = require("jdtls")
			local wk = require("which-key")
			local home = os.getenv("HOME")
			local bufnr = vim.api.nvim_get_current_buf()

			--------------------------------------------------
			-- 📁 Workspace por proyecto
			--------------------------------------------------
			local workspace_dir = home
				.. "/.local/share/nvim/jdtls-workspace/"
				.. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

			--------------------------------------------------
			-- 📍 Root detection
			--------------------------------------------------
			local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
			local root_dir = require("jdtls.setup").find_root(root_markers)
			if not root_dir then
				return
			end

			--------------------------------------------------
			-- 🧠 Lombok
			--------------------------------------------------
			local mason_data = vim.fn.stdpath("data")
			local lombok_path = mason_data .. "/mason/packages/jdtls/lombok.jar"

			--------------------------------------------------
			-- 🐞 Debug + Test bundles
			--------------------------------------------------
			local bundles = {}
			local mason_packages = mason_data .. "/mason/packages"

			vim.list_extend(
				bundles,
				vim.split(
					vim.fn.glob(
						mason_packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
					),
					"\n"
				)
			)

			vim.list_extend(
				bundles,
				vim.split(vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar"), "\n")
			)

			--------------------------------------------------
			-- ⚡ Extended capabilities
			--------------------------------------------------
			local extended = jdtls.extendedClientCapabilities
			extended.resolveAdditionalTextEditsSupport = true
			extended.progressReportProvider = true
			extended.classFileContentsSupport = true

			--------------------------------------------------
			-- 🚀 Config JDTLS PRO (FIXED)
			--------------------------------------------------
			local config = {
				cmd = {
					vim.fn.stdpath("data") .. "/mason/bin/jdtls", -- FIX 1
					"-Xms256m",
					"-Xmx1g",
					"-XX:+UseG1GC", -- FIX 2
					"-XX:+UseStringDeduplication",
					"-XX:+TieredCompilation",
					"-XX:TieredStopAtLevel=1",
					"--jvm-arg=-javaagent:" .. lombok_path,
				},

				root_dir = root_dir,

				settings = {
					java = {
						signatureHelp = { enabled = true },
						contentProvider = { preferred = "fernflower" },

						completion = {
							favoriteStaticMembers = {
								"org.junit.jupiter.api.Assertions.*",
								"org.mockito.Mockito.*",
								"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
								"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
							},
							importOrder = { "java", "javax", "jakarta", "org", "com" },
						},

						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},

						configuration = {
							runtimes = {
								{
									name = "JavaSE-21",
									path = vim.fn.expand("~/.sdkman/candidates/java/current"),
								},
							},
						},

						maven = { downloadSources = true },
						referencesCodeLens = { enabled = true },
						implementationsCodeLens = { enabled = true },

						inlayHints = {
							parameterNames = { enabled = "all" },
						},

						format = { enabled = true },
					},
				},

				init_options = {
					bundles = bundles,
					extendedClientCapabilities = extended,
				},

				flags = {
					allow_incremental_sync = true,
				},
			}

			--------------------------------------------------
			-- 🚀 Start / Attach
			--------------------------------------------------
			jdtls.start_or_attach(config)

			--------------------------------------------------
			-- 🐞 Debug + Test
			--------------------------------------------------
			jdtls.setup_dap({ hotcodereplace = "auto" })
			jdtls.setup.add_commands()
			require("jdtls.dap").setup_dap_main_class_configs()

			--------------------------------------------------
			-- 🔎 CodeLens auto refresh
			--------------------------------------------------
			vim.lsp.codelens.refresh()
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = bufnr,
				callback = vim.lsp.codelens.refresh,
			})

			--------------------------------------------------
			-- 🧹 Auto organize imports on save
			--------------------------------------------------
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.java",
				callback = function()
					pcall(vim.lsp.buf.code_action, {
						context = { only = { "source.organizeImports" } },
						apply = true,
					})
				end,
			})

			--------------------------------------------------
			-- 🧹 Workspace clean command
			--------------------------------------------------
			vim.api.nvim_create_user_command("JavaClean", function()
				vim.fn.delete(workspace_dir, "rf")
				print("JDTLS workspace cleaned. Restart Neovim.")
			end, {})

			--------------------------------------------------
			-- 🌈 Semantic tokens (FIX 4)
			--------------------------------------------------
			vim.api.nvim_create_autocmd("LspAttach", {
				buffer = bufnr,
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.name == "jdtls" and client.server_capabilities.semanticTokensProvider then
						vim.lsp.semantic_tokens.start(args.buf, client.id)
					end
				end,
			})

			--------------------------------------------------
			-- ▶️ Smart Runner SAFE (FIX 5)
			--------------------------------------------------
			local function run_cmd(cmd)
				if vim.fn.exists(":TermExec") == 2 then
					vim.cmd("TermExec cmd='" .. cmd .. "'")
				else
					print("toggleterm no instalado")
				end
			end

			local function is_maven()
				return vim.fn.filereadable("pom.xml") == 1
			end

			local function is_gradle()
				return vim.fn.filereadable("build.gradle") == 1
			end

			local function run_java()
				if is_maven() then
					run_cmd("mvn -q exec:java")
					return
				end

				if is_gradle() then
					run_cmd("./gradlew run")
					return
				end

				local mains = jdtls.dap.get_main_class_configs()
				if mains and not vim.tbl_isempty(mains) then
					run_cmd("java " .. mains[1].mainClass)
				else
					print("No main() encontrado")
				end
			end

			--------------------------------------------------
			-- ⌨️ Keybinds PRO (FIX 6)
			--------------------------------------------------
			wk.add({
				{ "<leader>j", group = "Java", buffer = bufnr },

				{ "<leader>jo", jdtls.organize_imports, desc = "Organize Imports", buffer = bufnr },
				{ "<leader>jr", run_java, desc = "Run Smart", buffer = bufnr },
				{ "<leader>jc", "<cmd>JavaClean<cr>", desc = "Clean Workspace", buffer = bufnr },

				{ "<leader>jt", jdtls.test_class, desc = "Test Class", buffer = bufnr },
				{ "<leader>jn", jdtls.test_nearest_method, desc = "Test Nearest Method", buffer = bufnr },

				{ "<leader>jg", jdtls.generate, desc = "Generate Code", buffer = bufnr },
				{ "<leader>ja", jdtls.generate_accessors, desc = "Generate Getters/Setters", buffer = bufnr },
				{ "<leader>jm", jdtls.extract_method, desc = "Extract Method", buffer = bufnr },
				{ "<leader>jv", jdtls.extract_variable, desc = "Extract Variable", buffer = bufnr },
			})
		end,
	},
}

-- =========================================================
-- LEADER KEY
-- =========================================================
vim.g.mapleader = " "

-- =========================================================
-- EXPLORADOR DE ARCHIVOS (Nvim-Tree)
-- =========================================================
vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
end, { desc = "Explorer: Toggle & Focus Current File" })

-- =========================================================
-- GUARDAR + FORMAT (IDE STYLE)
-- =========================================================

local function save_and_format()
  -- Quita readonly si está activo
  if vim.bo.readonly then
    vim.bo.readonly = false
  end

  -- Format si hay LSP
  pcall(function()
    vim.lsp.buf.format({ async = false })
  end)

  -- Guardar forzado y silencioso (evita E13)
  vim.cmd("silent! w!")
end

vim.keymap.set("n", "<C-s>", save_and_format, { desc = "File: Save + Format" })
vim.keymap.set("i", "<C-s>", function()
  save_and_format()
end, { desc = "File: Save + Format" })
vim.keymap.set("v", "<C-s>", function()
  save_and_format()
end, { desc = "File: Save + Format" })
-- =========================================================
-- CERRAR BUFFER
-- =========================================================
vim.keymap.set("n", "<leader>x", "<cmd>bp|bd #<cr>", { desc = "Buffer: Close Current" })

-- =========================================================
-- LSP (GENÉRICO)
-- =========================================================
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: References" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Implementation" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Docs" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: Rename" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })

-- =========================================================
-- DEBUGGING (DAP)
-- =========================================================
vim.keymap.set("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Debug: Start / Continue" })

vim.keymap.set("n", "<leader>dn", function()
	require("dap").step_over()
end, { desc = "Debug: Step Over" })

vim.keymap.set("n", "<leader>di", function()
	require("dap").step_into()
end, { desc = "Debug: Step Into" })

vim.keymap.set("n", "<leader>do", function()
	require("dap").step_out()
end, { desc = "Debug: Step Out" })

vim.keymap.set("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })

vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })

vim.keymap.set("n", "<leader>de", function()
	require("dapui").eval()
end, { desc = "Debug: Eval Expression" })

-- =========================================================
-- JAVA DEBUG (JDTLS)
-- =========================================================
vim.keymap.set("n", "<leader>dt", function()
	require("jdtls").test_class()
end, { desc = "Java: Debug Test Class" })

vim.keymap.set("n", "<leader>dm", function()
	require("jdtls").test_nearest_method()
end, { desc = "Java: Debug Nearest Test" })

-- =========================================================
-- JAVA (JDTLS - NO RUN AQUÍ)
-- =========================================================
vim.keymap.set("n", "<leader>jo", function()
	require("jdtls").organize_imports()
end, { desc = "Java: Organize Imports" })

-- =========================================================
-- RUN / EXECUTE (TERMINAL REAL)
-- =========================================================

-- ▶ Maven (pom.xml)
vim.keymap.set("n", "<leader>rm", function()
	require("toggleterm").exec("mvn -q exec:java")
end, { desc = "Run: Maven Project" })

-- ▶ Gradle (build.gradle)
vim.keymap.set("n", "<leader>rg", function()
	require("toggleterm").exec("./gradlew run")
end, { desc = "Run: Gradle Project" })

-- ▶ Java plano (archivo .java suelto)
vim.keymap.set("n", "<leader>rp", function()
	local file = vim.fn.expand("%:t")
	local class = vim.fn.expand("%:t:r")
	require("toggleterm").exec("javac " .. file .. " && java " .. class)
end, { desc = "Run: Java File" })

-- =========================================================
-- TERMINAL (toggleterm.nvim)
-- =========================================================
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Terminal: Toggle" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal: Exit Insert Mode" })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
--java Project
local java = require("config.java-runner")

vim.keymap.set("n", "<leader>jt", java.test, { desc = "Java Test" })
vim.keymap.set("n", "<leader>js", java.spring, { desc = "Spring Boot Run" })

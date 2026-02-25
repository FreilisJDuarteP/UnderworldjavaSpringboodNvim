return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },

  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      shade_terminals = true,
      direction = "horizontal",
      start_in_insert = true,
      close_on_exit = false,
    })

    ------------------------------------------------------------------
    -- RUN JAVA MAIN (detectado por JDTLS real)
    ------------------------------------------------------------------
    local function run_java_main()
      local ok, jdtls = pcall(require, "jdtls")
      if not ok then
        print("JDTLS no activo")
        return
      end

      local mains = jdtls.dap.get_main_class_configs()
      if not mains or vim.tbl_isempty(mains) then
        print("No se encontró main()")
        return
      end

      local main = mains[1]

      require("toggleterm").exec("java " .. main.mainClass)
    end

  end,
}

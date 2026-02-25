local M = {}

local function is_maven()
  return vim.fn.filereadable("pom.xml") == 1
end

local function is_gradle()
  return vim.fn.filereadable("build.gradle") == 1
end

local function run_main()
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
  vim.cmd("TermExec cmd='java " .. main.mainClass .. "'")
end

function M.run()
  if is_maven() then
    vim.cmd("TermExec cmd='mvn -q exec:java'")
    return
  end

  if is_gradle() then
    vim.cmd("TermExec cmd='./gradlew run'")
    return
  end

  run_main()
end

function M.test()
  if is_maven() then
    vim.cmd("TermExec cmd='mvn test'")
    return
  end

  if is_gradle() then
    vim.cmd("TermExec cmd='./gradlew test'")
    return
  end

  print("No se detectó sistema de tests")
end

function M.spring()
  if is_maven() then
    vim.cmd("TermExec cmd='mvn spring-boot:run'")
    return
  end

  if is_gradle() then
    vim.cmd("TermExec cmd='./gradlew bootRun'")
    return
  end
end

return M

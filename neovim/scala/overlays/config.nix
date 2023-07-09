final: prev: {
  luaConfig = ''
  vim.opt_global.shortmess:remove("F")

  local metals_config = require("metals").bare_config()

  metals_config.init_options.statusBarProvider = "on"

  metals_config.settings = {
    javaHome = "${final.jdk}",
    enableSemanticHighlighting = false,
    metalsBinaryPath = "${final.metals}/bin/metals",
  }

  metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
  end

  require("dap").configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "RunOrTest",
      metals = {
        runType = "runOrTestFile",
      }
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }

  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require('metals').initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
  '';
}

vim.opt_global.shortmess:remove("F")

function metals_setup(javaHome, metalsBinPath)
  metals_config = require("metals").bare_config()
  metals_config.init_options.statusBarProvider = "on"
  metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()
  metals_config.settings = {
    javaHome = javaHome,
    enableSemanticHighlighting = false,
    metalsBinaryPath = metalsBinPath,
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
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
      },
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

  nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java", "sc" },
    callback = function()
      require('metals').initialize_or_attach(metals_config)
      which_key.register({
        m = {
          name = "metals",
          d = { "<cmd>MetalsRunDoctor<cr>", "run doctor" },
          i = { "<cmd>MetalsInfo<cr>", "info" },
          l = { "<cmd>MetalsToggleLogs<cr>", "logs" },
          c = { require("telescope").extensions.metals.commands, "all commands" },
        }
        }, { prefix = "<leader>" }
      )
    end,
    group = nvim_metals_group,
  })

end

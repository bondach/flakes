vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    which_key.register({
      f = {
        s = {
          name = 'symbols (lsp)',
          d = { require('telescope.builtin').lsp_document_symbols, 'document (lsp)' },
          w = { require('telescope.builtin').lsp_dynamic_workspace_symbols, 'workspace (lsp)' },
        },
      },
      h = { vim.lsp.buf.hover, 'hover (lsp)' },
      d = { require('telescope.builtin').lsp_definitions, 'go to definition (lsp)' },
      i = { require('telescope.builtin').lsp_implementations, 'implementations (lsp)' },
      a = { vim.lsp.buf.code_action, 'code action (lsp)' },
      r = { require('telescope.builtin').lsp_references, 'references (lsp)' },
      R = { vim.lsp.buf.rename, 'rename (lsp)' },
      s = { vim.lsp.buf.signature_help, 'signature help (lsp)' },
      t = { vim.lsp.buf.type_definition, 'type definition (lsp)'},
      l = { vim.lsp.codelens.run, "codeLens run (lsp)" },
      D = { require('dap').repl.toggle, "repl toggle (DAP)" }, -- TODO разобраться с дапом
    }, { prefix = "<leader>" })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave"}, {
  callback = function(args)
    vim.lsp.codelens.refresh()
  end,
})

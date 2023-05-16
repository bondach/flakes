local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp"                },
    { name = "vsnip"                   },
    { name = "nvim_lsp_signature_help" },
  }, { { name = 'buffer' } }),
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then cmp.select_next_item()
      else fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else fallback()
      end
    end,
    ["<C-j>"] = cmp.mapping.scroll_docs(1),
    ["<C-k>"] = cmp.mapping.scroll_docs(-1),
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      before = function(entry, vim_item)
        return vim_item
      end,
    }),
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})

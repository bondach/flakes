vim.o.timeout    = true
vim.o.timeoutlen = 500

local which_key = require('which-key')
which_key.setup({})
which_key.register(
  {
    T = { '<cmd>NeoTreeFocusToggle<cr>', 'file tree' },
    f = {
      name = "find",
      f = { '<cmd>Telescope find_files<cr>', 'files'  },
      S = { '<cmd>Telescope live_grep<cr>',  'string' },
    },
  },
  {
    prefix = "<leader>"
  }
)

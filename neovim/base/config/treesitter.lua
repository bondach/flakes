require('nvim-treesitter.configs').setup {
  auto_install = false,
  highlight = {
    enable = true,
  },
}


local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })

-- TODO: сейчас будут все .conf файлы этим парсером проверятся, надо сделать так, 
-- чтобы только влияло на джавовые/скаловые проекты
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = hocon_group,
  pattern = '*.conf',
  command = 'set ft=hocon'
})

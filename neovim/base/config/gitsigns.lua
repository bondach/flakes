-- TODO: сделать так, чтобы gitsigns врубался, если произошла смена рабочей директории на ту, в которой есть git репозиторий
function gitsigns_setup()
  local git_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
  if git_dir ~= '' then 
    require('gitsigns').setup()
    which_key.register({
      g = {
        name = 'git',
        b = { '<cmd>Gitsigns blame_line<cr>',   'blame line'   },
        n = { '<cmd>Gitsigns next_hunk<cr>',    'next hunk'    },
        p = { '<cmd>Gitsigns prev_hunk<cr>',    'prev hunk'    },
        v = { '<cmd>Gitsigns preview_hunk<cr>', 'preview hunk' },
        r = { '<cmd>Gitsigns reset_hunk<cr>',   'reset hunk' },
        t = { 
          name = 'toggle',
          s = { '<cmd>Gitsigns toggle_signs<cr>',     'signs'     },
          w = { '<cmd>Gitsigns toggle_word_diff<cr>', 'word diff' },
          d = { '<cmd>Gitsigns toggle_deleted<cr>',   'deleted'   },
        },
      },
    }, { prefix = "<leader>" })
  end
end

gitsigns_setup()

require('kanagawa').setup({
  commentStyle = { italic = false },
  keywordStyle = { italic = false },
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
})

require('kanagawa').load('wave')

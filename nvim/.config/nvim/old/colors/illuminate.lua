local highlight_color = "#44475A"

require("illuminate").configure({
  delay = 1000,
  filetypes_denylist = {
    "NvimTree",
    "HarpoonTerm",
  },
})

vim.cmd("hi def IlluminatedWordWrite gui=bold guibg=" .. highlight_color)
vim.cmd("hi def IlluminatedWordText gui=bold guibg=" .. highlight_color)
vim.cmd("hi def IlluminatedWordRead gui=bold guibg=" .. highlight_color)

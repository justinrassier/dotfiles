local ts = require "nvim-treesitter.configs"

ts.setup {
  context_commentstring = {enable = true},
  ensure_installed = "all",
}

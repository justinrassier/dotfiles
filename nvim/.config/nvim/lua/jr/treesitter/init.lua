local ts = require "nvim-treesitter.configs"

ts.setup {
  context_commentstring = {enable = true},
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = { "html" },
    use_languagetree = true
  },
  indent = {enable = false},
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"}
  }
}

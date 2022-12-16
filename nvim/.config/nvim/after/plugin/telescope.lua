local vim = vim
local telescope = require("telescope")
local builtIn = require("telescope.builtin")
local actions = require("telescope.actions")
local gh = telescope.load_extension("gh")

telescope.load_extension("fzy_native")
telescope.load_extension("node_modules")
telescope.load_extension("live_grep_args")

local M = {}

telescope.setup({
  defaults = {
    -- layout_config = {
    --   vertical = {width = .75}
    -- },
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    mappings = {
      i = {
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<Tab>"] = actions.toggle_selection,
      },
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})

function M.find_files()
  local cmn_opts = {} --generateOpts({})
  cmn_opts.find_command = { "rg", "--hidden", "--files", "-L", "--glob", "!.git" }
  builtIn.find_files(cmn_opts)
end

vim.keymap.set("n", "<c-p>", function() M.find_files() end, { noremap = true })






return M

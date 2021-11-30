local vim = vim
local telescope = require("telescope")
local builtIn = require("telescope.builtin")
local actions = require("telescope.actions")
local gh = telescope.load_extension("gh")


telescope.load_extension("fzy_native")
telescope.load_extension("node_modules")



local M = {}


telescope.setup {
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    mappings = {
      i = {
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<Tab>"] = actions.toggle_selection
      }
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true
    }
  }
}

-- local function generateOpts(opts)
--   local common_opts = {
--     layout_strategy = "center",
--     sorting_strategy = "ascending",
--     results_title = false,
--     preview_title = "Preview",
--     previewer = false,
--     layout_config = {
--       width = 80,
--       height = 15,
--     },
--     borderchars = {
--       {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
--       prompt = {"─", "│", " ", "│", "╭", "╮", "│", "│"},
--       results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
--       preview = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"}
--     }
--   }
--   return vim.tbl_extend("force", opts, common_opts)
-- end
-- 
function M.find_files()
  local cmn_opts = {} --generateOpts({})
  cmn_opts.find_command = {"rg","--hidden", "--files", "-L", "--glob", "!.git"}
  builtIn.find_files(cmn_opts)
end

function M.github_issues()
  gh.issues()
end


return M

-- vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme catppuccin")
vim.cmd("colorscheme kanagawa")

-- get if system setting is dark mode and set colorscheme accordingly
local dark_mode = vim.fn.system("defaults read -g AppleInterfaceStyle")
dark_mode = string.gsub(dark_mode, "^%s*(.-)%s*$", "%1")
dark_mode = dark_mode == "Dark" and true or false
vim.cmd("set background=" .. (dark_mode and "dark" or "light"))

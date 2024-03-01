-- Options
local parsers = require("nvim-treesitter.parsers")
local Type = { GLOBAL_OPTION = "o", WINDOW_OPTION = "wo", BUFFER_OPTION = "bo" }
local add_options = function(option_type, options)
	if type(options) ~= "table" then
		error('options should be a type of "table"')
		return
	end
	local vim_option = vim[option_type]
	for key, value in pairs(options) do
		vim_option[key] = value
	end
end
local Option = {}
Option.g = function(options)
	add_options(Type.GLOBAL_OPTION, options)
end
Option.w = function(options)
	add_options(Type.WINDOW_OPTION, options)
end
Option.b = function(options)
	add_options(Type.BUFFER_OPTION, options)
end

--vim.g.loaded = 1
--vim.g.loaded_netrwPlugin = 1

Option.g({
	completeopt = "menu,menuone,noselect",
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	-- incremental search
	incsearch = true,
	-- disable higlighting after searching
	hlsearch = false,
	-- keep buffers open in the background
	hidden = true,
	wrap = false,
	-- history stuff
	swapfile = false,
	backup = false,
	undodir = vim.fn.expand("$HOME/.vim/undos"),
	undofile = true,
	-- start scrolling 8 lines from the bottom
	scrolloff = 8,
	signcolumn = "yes",
	number = true,
	rnu = true,
	splitbelow = true,
	splitright = true,
	termguicolors = true,
	syntax = true,
	foldmethod = "expr",
	foldcolumn = "0",
	foldlevelstart = 99,
	foldexpr = "nvim_treesitter#foldexpr()",
	spell = true,
})

vim.g.mapleader = " "
vim.g.highlightedyank_highlight_duration = 100

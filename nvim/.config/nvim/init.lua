require("jr.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	"neovim/nvim-lspconfig",
	"nvim-lua/plenary.nvim",
	"tpope/vim-sleuth",

	"github/copilot.vim",
	"mbbill/undotree",
	"NTBBloodbath/color-converter.nvim",
	{ dir = "~/git/jesting.nvim" },
	-- { "justinrassier/nvim-treesitter-angular", version = "fixes" },
	{ import = "plugins" },
})

require("jr.custom.commands")
require("jr.autocmds")
require("jr.mappings")
vim.cmd("JRStartCheckingPRs")
-- vim.cmd("JRTimeTrackingStart")

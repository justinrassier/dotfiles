require("jr.options")
require("jr.autocmds")
require("jr.mappings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	"tpope/vim-sleuth",
	"github/copilot.vim",
	{ dir = "~/dev/jesting.nvim" },
	{ import = "plugins" },
})

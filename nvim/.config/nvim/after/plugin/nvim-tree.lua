local nvim_tree = require("nvim-tree")

local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not directory then
		return
	end

	-- change to the directory
	vim.cmd.cd(data.file)

	-- open the tree
	require("nvim-tree.api").tree.open()
end

nvim_tree.setup({
	-- open_on_setup = true,
	view = {
		width = 40,
	},
	renderer = {
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
			},
		},
	},
})

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
vim.keymap.set("n", "<c-n>", "<cmd>:NvimTreeToggle<cr>")
vim.keymap.set("n", "<c-f>", "<cmd>:NvimTreeFindFile<cr>")
vim.keymap.set("n", "<leader>ts", "<cmd>:JRShrinkTreeWidth<cr>")

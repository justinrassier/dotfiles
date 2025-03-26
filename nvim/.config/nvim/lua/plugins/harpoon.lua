return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	event = "VeryLazy", -- Sets the loading event to 'VeryLazy'
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<leader>mf", function()
			harpoon:list():add()
		end, {
			desc = "[M]ark a [F]ile in Harpoon",
		})
		vim.keymap.set("n", "<leader>mu", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, {
			desc = "Open [M]arks in Harpoon [U]I",
		})

		vim.keymap.set("n", "<leader>m1", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<leader>m2", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<leader>m3", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<leader>m4", function()
			harpoon:list():select(4)
		end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end)
	end,
}

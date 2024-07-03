return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	config = function()
		local commands = require("jr.custom.commands")
		local function pr_count()
			if commands.pr_count == nil then
				return ""
			end
			return " " .. commands.pr_count
		end
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]parenthen
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				-- -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
				-- fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				-- hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				-- todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				-- note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				-- `foo`
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})

		require("mini.files").setup()

		vim.keymap.set("n", "<leader>mn", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>")
	end,
}

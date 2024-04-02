return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for install instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires special font.
		--  If you already have a Nerd Font, or terminal set up with fallback fonts
		--  you can enable this
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of help_tags options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			-- pickers = {}
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		local simple_theme = require("telescope.themes").get_dropdown({
			winblend = 10,
			border = true,
			previewer = true,
			shorten_path = false,
			layout_config = {
				width = 0.8,
			},
		})
		local function do_with_simple_theme(builtin)
			return function()
				builtin(simple_theme)
			end
		end
		-- Enable telescope extensions, if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", do_with_simple_theme(builtin.help_tags), { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", do_with_simple_theme(builtin.keymaps), { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<c-p>", do_with_simple_theme(builtin.find_files), { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sf", do_with_simple_theme(builtin.find_files), { desc = "[S]earch [F]iles" })
		vim.keymap.set(
			"n",
			"<leader>ss",
			do_with_simple_theme(builtin.builtin),
			{ desc = "[S]earch [S]elect Telescope" }
		)
		vim.keymap.set(
			"n",
			"<leader>sw",
			do_with_simple_theme(builtin.grep_string),
			{ desc = "[S]earch current [W]ord" }
		)
		vim.keymap.set("n", "<leader>sg", do_with_simple_theme(builtin.live_grep), { desc = "[S]earch by [G]rep" })
		vim.keymap.set(
			"n",
			"<leader>sd",
			do_with_simple_theme(builtin.diagnostics),
			{ desc = "[S]earch [D]iagnostics" }
		)
		vim.keymap.set("n", "<leader>sr", do_with_simple_theme(builtin.resume), { desc = "[S]earch [R]esume" })
		vim.keymap.set(
			"n",
			"<leader>s.",
			do_with_simple_theme(builtin.oldfiles),
			{ desc = '[S]earch Recent Files ("." for repeat)' }
		)
		vim.keymap.set(
			"n",
			"<leader><leader>",
			do_with_simple_theme(builtin.buffers),
			{ desc = "[ ] Find existing buffers" }
		)

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		vim.keymap.set("n", "<leader>sj", function()
			require("jr.telescope.jira_picker").jira_tickets(require("telescope.themes").get_dropdown({
				layout_config = { width = 0.8 },
			}))
		end, { desc = "[S]earch [J]ira tickets" })
		vim.keymap.set("n", "<leader>spr", function()
			require("jr.telescope.pr_picker").list_prs_for_review(require("telescope.themes").get_dropdown({
				layout_config = { width = 0.8 },
			}))
		end, { desc = "[S]earch [PR] for review" })

		vim.keymap.set({ "n", "v" }, "<Leader>fr", function()
			local opts = vim.deepcopy(simple_theme)
			require("telescope.builtin").grep_string(opts)
		end)
	end,
}

return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		local ts = require("nvim-treesitter")

		ts.install({ "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" })

		---@param buf integer
		---@param language string
		local function try_attach(buf, language)
			if not vim.treesitter.language.add(language) then return end
			vim.treesitter.start(buf, language)

			-- Opt-in: treesitter-based folds (see :help folds)
			-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			-- vim.wo.foldmethod = 'expr'

			if vim.treesitter.query.get(language, "indents") ~= nil then
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end

		local available = ts.get_available()

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match
				local language = vim.treesitter.language.get_lang(filetype)
				if not language then return end

				local installed = ts.get_installed("parsers")
				if vim.tbl_contains(installed, language) then
					try_attach(buf, language)
				elseif vim.tbl_contains(available, language) then
					ts.install(language):await(function() try_attach(buf, language) end)
				else
					try_attach(buf, language)
				end
			end,
		})
	end,
	-- Additional modules worth exploring:
	--   - nvim-treesitter/nvim-treesitter-context  (show current scope in statusline)
	--   - nvim-treesitter/nvim-treesitter-textobjects  (text objects based on syntax tree)
}

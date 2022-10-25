local vim = vim
local formatter = require("formatter")
local prettierConfig = function()
	return {
		exe = "prettier",
		args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--plugin-search-dir", "." },
		stdin = true,
	}
end

local formatterConfig = {
	svelte = {
		function()
			return {
				exe = "prettier",
				args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--plugin-search-dir", "." },
				stdin = true,
			}
		end,
	},
	vue = {
		function()
			return {
				exe = "prettier",
				args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--parser", "vue" },
				stdin = true,
			}
		end,
	},
	rust = {
		-- Rustfmt
		function()
			return {
				exe = "rustfmt",
				args = { "--emit=stdout" },
				stdin = true,
			}
		end,
	},
	go = {
		function()
			return {
				exe = "gofmt",
				stdin = true,
			}
		end,
	},
	html = {
		function()
			-- Tailwind opinionated formatter
			return {
				exe = "prettier",
				args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--plugin-search-dir", "." },
				stdin = true,
			}
		end,
		-- and standard prettier formatter
		prettierConfig,
	},
	ejs = {
		function()
			-- Tailwind opinionated formatter
			return {
				exe = "prettier",
				args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--plugin-search-dir", "." },
				stdin = true,
			}
		end,
		-- and standard prettier formatter
		prettierConfig,
	},
	lua = {
		function()
			return {
				exe = "~/dev/stylua",
				args = { "-" },
				stdin = true,
			}
		end,
	},
}
local commonFT = {
	"css",
	"scss",
	"java",
	"javascript",
	"typescript",
	"typescriptreact",
	"markdown",
	"markdown.mdx",
	"json",
}
for _, ft in ipairs(commonFT) do
	formatterConfig[ft] = {
		prettierConfig,
	}
end
-- Setup functions
formatter.setup({
	logging = false,
	filetype = formatterConfig,
})

-- format on save (maybe move to new file with other auto commands)
vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.lua,*.go,*.ejs,*.ts,*.html,*.js,*.json,*.svelte,*.rs FormatWrite
augroup END
]],
	true
)

local null_ls = require("null-ls")
local git_stuff = require("jr.custom.git")
local gh = require("jr.custom.gh")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.stylelint,
		--
		-- null_ls.builtins.diagnostics.cspell,
		-- null_ls.builtins.diagnostics.eslint,
		-- null_ls.builtins.diagnostics.stylelint,
		--
		-- null_ls.builtins.code_actions.eslint,
		-- null_ls.builtins.code_actions.gitsigns,

		null_ls.builtins.code_actions.cspell.with({
			filetypes = { "markdown", "tex", "text" },
		}),
		null_ls.builtins.diagnostics.cspell.with({
			filetypes = { "markdown", "tex", "text" },
		}),
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})

local blame_actions = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = {},
	generator = {
		fn = function(params)
			-- get the current line number
			local line = vim.api.nvim_win_get_cursor(0)[1]
			-- run git blame
			local output = vim.fn.system("git blame -L " .. line .. "," .. line .. " " .. vim.fn.expand("%:p"))

			local commit = output:match("([0-9a-f]+) ")

			if string.match(commit, "00000") ~= nil then
				vim.notify("No commit found", vim.log.levels.WARN)
				return
			end

			-- get the commit message
			local commit_message = vim.fn.system("git log -1 --pretty=%B " .. commit)

			-- get the CAVO ticket number
			local ticket = commit_message:match("CAVO%-[0-9]+")
			-- local pr_number = commit_message:match("(#%d+)")
			local pr = gh.get_pr_number_for_commit(commit)[1]
			local pr_number = nil
			if pr ~= nil then
				pr_number = pr.number
			end

			-- build options and their actions
			local options = {}
			local option_number = 1
			if ticket ~= nil then
				table.insert(options, {
					title = "Open Jira (" .. ticket .. ")",
					action = function()
						vim.fn.system("open https://adventhp.atlassian.net/browse/" .. ticket)
					end,
				})
				option_number = option_number + 1
			end

			if pr_number ~= nil then
				table.insert(options, {
					title = "Open PR #" .. pr_number .. " (" .. pr.title .. ")",
					action = function()
						vim.fn.system("gh pr view --web " .. string.gsub(pr_number, "#", ""))
					end,
				})
				option_number = option_number + 1
			end

			if commit ~= nil then
				table.insert(options, {
					title = "Copy commit hash (" .. commit .. ")",
					action = function()
						vim.fn.setreg("+", commit)
					end,
				})
				option_number = option_number + 1
			end

			return options
		end,
	},
}

local diff_view_actions = {
	method = null_ls.methods.CODE_ACTION,
	filetypes = {},
	generator = {
		fn = function(params)
			local actions = {
				{
					title = "View File History (DiffView)",
					action = function()
						vim.cmd("DiffviewFileHistory %")
					end,
				},
			}
			return actions
		end,
	},
}

null_ls.register(blame_actions)
null_ls.register(diff_view_actions)

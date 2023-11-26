-- autocommand to set spelling on for markdown files

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true }),
	callback = function()
		vim.cmd("setlocal wrap")

		-- map j/k to gj/gk to handle wrapped lines
		vim.api.nvim_buf_set_keymap(0, "n", "j", "gj", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, "n", "k", "gk", { noremap = true, silent = true })

		-- set line length to 80
		print("setting textwidth")
		vim.cmd("setlocal textwidth=80")

		-- turn line into a task
		vim.keymap.set("n", "<leader>mc", function()
			local line = vim.api.nvim_get_current_line()
			if string.match(line, "%[ %]") then
				-- replace [ ] with [x]
				vim.cmd("silent! s/\\[ \\]/[x]/g")
			elseif string.match(line, "%[x%]") then
				-- replace [x] with [ ]
				vim.cmd("silent! s/\\[x\\]/[ ]/g")
			else
				-- add [ ] to the beginning of the line
				vim.cmd("silent! s/^/- [ ] /g")
			end
		end, { noremap = true, silent = true, buffer = 0 })
	end,
})

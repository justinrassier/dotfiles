local M = {}

function M.get_selected_text()
	local text = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
	local full_text = table.concat(text, "\n")
	return full_text
end

return M

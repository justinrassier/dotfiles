local M = {}

function M.shrink_width()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local max_line_length = 0
	for i, line in ipairs(lines) do
		if #line > max_line_length and i ~= 1 then
			max_line_length = #line
		end
	end

	vim.fn.execute("NvimTreeResize " .. max_line_length)
end

return M

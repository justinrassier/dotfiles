local vim = vim
local uv = vim.loop
local M = {}

function M.mapBuf(buf, mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, options)
end

function M.get_node_modules(root_dir)
	-- util.find_node_modules_ancestor()
	local root_node = root_dir .. "/node_modules"
	local stats = uv.fs_stat(root_node)
	if stats == nil then
		return nil
	else
		return root_node
	end
end

function M.table_length(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

return M

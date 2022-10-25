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

function M.autocmd(event, triggers, operations)
	local cmd = string.format("autocmd %s %s %s", event, triggers, operations)
	vim.cmd(cmd)
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

function M.dumpTable(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
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

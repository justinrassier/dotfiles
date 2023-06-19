local ts_utils = require("nvim-treesitter.ts_utils")

local attribute_query = [[
  (element 
    (start_tag 
      (attribute
       (
          (attribute_name) @attr_name)
          (#eq? @attr_name "class")
          (quoted_attribute_value (attribute_value) @attr_value)
        )
      ) 
    ) 
  ]]

local self_closing_attribute_query = [[
  (element 
    (self_closing_tag
      (attribute
       (
          (attribute_name) @attr_name)
          (#eq? @attr_name "class")
          (quoted_attribute_value (attribute_value) @attr_value)
        )
      ) 
    ) 
  ]]

local self_closing_element_query = [[
  (element 
    (self_closing_tag
      (tag_name) @tag_name)
    ) 
  ]]

local element_query = [[
  (element 
    (start_tag 
      (tag_name) @tag_name)
    ) 
  ]]

local M = {}
function M.add_or_insert_class_attribute()
	local node = ts_utils.get_node_at_cursor()

	if not node then
		return
	end

	-- go up the tree until you get to the nearest element
	while node:type() ~= "element" do
		node = node:parent()
	end

	local query = vim.treesitter.query.parse("html", attribute_query)
	local current_row = unpack(vim.api.nvim_win_get_cursor(0))
	local has_class_attr = false

	-- in the case the element is not self-closing and already has a class attribute
	for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
		has_class_attr = true
		local capture_name = query.captures[id] -- name of the capture in the query
		local start_row, _, _, end_col = n:range()
		-- set cursor at the end of attr_value
		if capture_name == "attr_value" then
			-- set the cursor to the end of the class attribute string value (before the closing quote)
			vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col })
			-- go into insert mode and add a space to be ready to start adding new classes
			vim.api.nvim_feedkeys("i ", "n", false)
		end
	end

	-- in the case the element is self-closing and already has a class attribute
	query = vim.treesitter.query.parse("html", self_closing_attribute_query)
	for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
		has_class_attr = true
		local capture_name = query.captures[id] -- name of the capture in the query
		local start_row, _, _, end_col = n:range()
		-- set cursor at the end of attr_value
		if capture_name == "attr_value" then
			-- set the cursor to the end of the class attribute string value (before the closing quote)
			vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col })
			-- go into insert mode and add a space to be ready to start adding new classes
			vim.api.nvim_feedkeys("i ", "n", false)
		end
	end

	-- if the element doesn't have a class attribute, then add one
	if not has_class_attr then
		query = vim.treesitter.query.parse("html", element_query)
		for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
			local start_row, _, _, end_col = n:range()
			vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col - 1 })

			-- go into insert mode and add a a class attribute
			vim.api.nvim_feedkeys('a class="" ', "n", false)

			-- move cursor back to the middle of the quotes
			local left_key = vim.api.nvim_replace_termcodes("<Left><left>", true, true, true)
			vim.api.nvim_feedkeys(left_key, "n", false)
		end

		query = vim.treesitter.query.parse("html", self_closing_element_query)
		for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
			local start_row, _, _, end_col = n:range()
			vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col - 1 })

			-- go into insert mode and add a a class attribute
			vim.api.nvim_feedkeys('a class="" ', "n", false)

			-- move cursor back to the middle of the quotes
			local left_key = vim.api.nvim_replace_termcodes("<Left><left>", true, true, true)
			vim.api.nvim_feedkeys(left_key, "n", false)
		end
	end
end

function M.remove_class_attribute() end

return M

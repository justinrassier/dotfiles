-- HTML queries for 'class' attribute
local html_attribute_query = [[
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

local html_self_closing_attribute_query = [[
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

local html_self_closing_element_query = [[
  (element
    (self_closing_tag
      (tag_name) @tag_name)
    )
  ]]

local html_element_query = [[
  (element
    (start_tag
      (tag_name) @tag_name)
    )
  ]]

-- JSX queries for 'className' attribute
local jsx_attribute_query = [[
  (jsx_element
    (jsx_opening_element
      (jsx_attribute
        (property_identifier) @attr_name
        (#eq? @attr_name "className")
        (string (string_fragment) @attr_value)
      )
    )
  )
]]

local jsx_self_closing_attribute_query = [[
  (jsx_self_closing_element
    (jsx_attribute
      (property_identifier) @attr_name
      (#eq? @attr_name "className")
      (string (string_fragment) @attr_value)
    )
  )
]]

local jsx_element_query = [[
  (jsx_element
    (jsx_opening_element
      (identifier) @tag_name
    )
  )
]]

local jsx_self_closing_element_query = [[
  (jsx_self_closing_element
    (identifier) @tag_name
  )
]]

local M = {}

local function get_file_type()
    local filetype = vim.bo.filetype
    if filetype == "javascriptreact" or filetype == "typescriptreact" or filetype == "tsx" or filetype == "jsx" then
        return "jsx"
    else
        return "html"
    end
end

local function get_queries_for_filetype(file_type)
    if file_type == "jsx" then
        return {
            parser = "tsx",
            attribute_query = jsx_attribute_query,
            self_closing_attribute_query = jsx_self_closing_attribute_query,
            element_query = jsx_element_query,
            self_closing_element_query = jsx_self_closing_element_query,
            attribute_name = "className"
        }
    else
        return {
            parser = "html",
            attribute_query = html_attribute_query,
            self_closing_attribute_query = html_self_closing_attribute_query,
            element_query = html_element_query,
            self_closing_element_query = html_self_closing_element_query,
            attribute_name = "class"
        }
    end
end

function M.add_or_insert_class_attribute()
    local node = vim.treesitter.get_node()

    if not node then
        return
    end

    local file_type = get_file_type()
    local queries = get_queries_for_filetype(file_type)

    -- go up the tree until you get to the nearest element
    local target_node_type = file_type == "jsx" and "jsx_element" or "element"
    while node and node:type() ~= target_node_type and node:type() ~= "jsx_self_closing_element" do
        node = node:parent()
    end

    if not node then
        return
    end

    local current_row = unpack(vim.api.nvim_win_get_cursor(0))
    local has_class_attr = false

    -- Check for existing attribute in regular elements
    local query = vim.treesitter.query.parse(queries.parser, queries.attribute_query)
    for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
        has_class_attr = true
        local capture_name = query.captures[id]
        local start_row, _, _, end_col = n:range()
        if capture_name == "attr_value" then
            vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col })
            vim.api.nvim_feedkeys("i ", "n", false)
        end
    end

    -- Check for existing attribute in self-closing elements
    if not has_class_attr then
        query = vim.treesitter.query.parse(queries.parser, queries.self_closing_attribute_query)
        for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
            has_class_attr = true
            local capture_name = query.captures[id]
            local start_row, _, _, end_col = n:range()
            if capture_name == "attr_value" then
                vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col })
                vim.api.nvim_feedkeys("i ", "n", false)
            end
        end
    end

    -- If no existing attribute, add one
    if not has_class_attr then
        -- Try regular elements first
        query = vim.treesitter.query.parse(queries.parser, queries.element_query)
        local found_element = false
        for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
            found_element = true
            local start_row, _, _, end_col = n:range()
            vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col - 1 })

            local insert_text = string.format(' %s="" ', queries.attribute_name)
            vim.api.nvim_feedkeys('a' .. insert_text, "n", false)

            local left_key = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
            vim.api.nvim_feedkeys(left_key, "n", false)
        end

        -- If not found, try self-closing elements
        if not found_element then
            query = vim.treesitter.query.parse(queries.parser, queries.self_closing_element_query)
            for id, n, _ in query:iter_captures(node, 0, current_row - 1, current_row) do
                local start_row, _, _, end_col = n:range()
                vim.api.nvim_win_set_cursor(0, { start_row + 1, end_col - 1 })

                local insert_text = string.format(' %s="" ', queries.attribute_name)
                vim.api.nvim_feedkeys('a' .. insert_text, "n", false)

                local left_key = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
                vim.api.nvim_feedkeys(left_key, "n", false)
            end
        end
    end
end

function M.remove_class_attribute() end

return M

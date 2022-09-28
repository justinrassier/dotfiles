local M = {}
local scan = require'plenary.scandir'
local path = require'plenary.path'
local Job = require'plenary.job'
local nvim_tree_api = require("nvim-tree.api")
local find_nearest_angular_module = require'jr.custom.utils'.find_nearest_angular_module
local get_project_name_from_module_file = require'jr.custom.utils'.get_project_name_from_module_file
local find_nearest_ngrx_part = require'jr.custom.utils'.find_nearest_ngrx_part
local get_project_name_from_path = require'jr.custom.utils'.get_project_name_from_path
local get_relative_path_from_project_name = require'jr.custom.utils'.get_relative_path_from_project_name


function M.jump_to_angular_component_part(extension)
  -- get file name for the current buffer
  local current_buffer = vim.api.nvim_buf_get_name(0)
  
  -- get the parts of the component path
  local component_path, component_name, component_extension = string.match(current_buffer, "(.-)([^\\/]-%.?([^%.\\/]*))$")


  -- niave replacement of extension with desired destination extension
  local destination_file = string.gsub(component_name, "%." .. component_extension, "%." .. extension)

  -- assemble full path to the new file to navigate to
  local full_destination = component_path .. destination_file

  local exists = vim.fn.filereadable(full_destination)

  -- don't open a buffer if the file doesn't exist since you may end up creating a file without knowing it
  if exists == 0 then
    print ("File does not exist!", full_destination)
    return
  end

  -- load new file into buffer
  local uri = vim.uri_from_fname(full_destination)
  local new_buff = vim.uri_to_bufnr(uri)
  -- -- load new buffer into current window
  vim.api.nvim_win_set_buf(0, new_buff)
  -- force buffer to be loaded
  vim.fn.execute("edit")
  
end



function M.jump_to_ngrx_parts(ngrx_part)

  -- get file name for the current buffer
  local current_buffer = vim.api.nvim_buf_get_name(0)

  local project_name = get_project_name_from_path(current_buffer)

  if project_name == nil then
    print("Could not find project name")
    return
  end


  -- if project_name has data-acces in it
  local is_data_access = string.find(project_name, "data%-access")
  if is_data_access  then
    -- if in data-access layer, then jump to nearest ngrx particular
    local found_ngrx_part = find_nearest_ngrx_part(current_buffer, ngrx_part)

    -- make path to new file absolute
    local full_destination = path:new(found_ngrx_part):absolute()
    local uri = vim.uri_from_fname(full_destination)
    local new_buff = vim.uri_to_bufnr(uri)
    vim.api.nvim_win_set_buf(0, new_buff)
    -- -- force buffer to be loaded
    vim.fn.execute("edit")
  else
    -- replace 'feature' with 'data-access'
    local data_access_project_name = string.gsub(project_name, "feature", "data%-access")
    data_access_project_name = "shared-" .. data_access_project_name

    -- get relative path from project
    local absolute_path_to_project = path:new(get_relative_path_from_project_name(data_access_project_name)):absolute();
    local ngrx_part_plural = ngrx_part .. "s";
    local scan_result = scan.scan_dir(path:new(absolute_path_to_project):normalize() , {  search_pattern = '.'..ngrx_part..'.ts' });
    local scan_result_plural = scan.scan_dir(path:new(absolute_path_to_project):normalize() , {  search_pattern = '.'..ngrx_part_plural..'.ts' });

    local found_ngrx_part = nil
    if #scan_result > 0 then
      found_ngrx_part = scan_result[1]
    elseif #scan_result_plural > 0 then
      found_ngrx_part = scan_result_plural[1]
    end

    if found_ngrx_part ~= nil then
      local full_destination = path:new(found_ngrx_part):absolute()
      local uri = vim.uri_from_fname(full_destination)
      local new_buff = vim.uri_to_bufnr(uri)
      vim.api.nvim_win_set_buf(0, new_buff)
      -- -- force buffer to be loaded
      vim.fn.execute("edit")
    else
      print("Could not find ngrx part")
    end

  end

end


function M.jump_to_nearest_module()
  local current_buffer = vim.api.nvim_buf_get_name(0)
  local module_relative_path = find_nearest_angular_module(current_buffer)

  if module_relative_path ~= nil then
    local module_absolute_path = path:new(module_relative_path):absolute()
    -- load up the destination in the current buffer
    local uri = vim.uri_from_fname(module_absolute_path)
    local new_buff = vim.uri_to_bufnr(uri)
    vim.api.nvim_win_set_buf(0, new_buff)
    -- force buffer to be loaded
    vim.fn.execute("edit")
  end

end








function M.new_scratch_buffer()
  vim.api.nvim_command("enew")
  vim.api.nvim_command("setlocal buftype=nofile")
  vim.api.nvim_command("setlocal bufhidden=hide")
  vim.api.nvim_command("setlocal filetype=json")
  -- go to insert mode
  vim.api.nvim_command("normal i")
end







return M


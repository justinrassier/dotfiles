local M = {}


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

  -- load new buffer into current window
  vim.api.nvim_win_set_buf(0, new_buff)
end

return M

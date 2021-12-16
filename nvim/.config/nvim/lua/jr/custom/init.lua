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
  -- -- load new buffer into current window
  vim.api.nvim_win_set_buf(0, new_buff)
  -- force buffer to be loaded
  vim.fn.execute("edit")
  
end



function M.jump_to_ngrx_parts(ngrx_part)

  -- get file name for the current buffer
  local current_buffer = vim.api.nvim_buf_get_name(0)
  
  -- get current "feature" if in a feature lib already
  local feature_match = string.match(current_buffer, ".-/libs/(.-)/")

  -- get the "feature" if your your current drectory is "shared"
  local shared_feature_match = string.match(current_buffer, ".-/shared/(.-)/")

  -- get the libs directory root
  local libs_dir_root = string.match(current_buffer, "(.-/libs)")


  -- if the featured pulled was "shared" because we were in a shared dir, then use the shared_feature_match
  local feature = feature_match
  if feature_match == "shared" then
    feature = shared_feature_match
  end

  -- assemble the full destination 
  local full_destination = libs_dir_root .. "/shared/" .. feature ..  "/data-access/src/lib/store/" .. feature .. "." .. ngrx_part ..".ts"

  local exists = vim.fn.filereadable(full_destination)

  if exists == 0 then
    print ("File does not exist!", full_destination)
    return
  end


  -- load up the destination in the current buffer
  local uri = vim.uri_from_fname(full_destination)
  local new_buff = vim.uri_to_bufnr(uri)
  vim.api.nvim_win_set_buf(0, new_buff)
  -- force buffer to be loaded
  vim.fn.execute("edit")

end

function M.playAround()

  vim.ui.input({prompt="INPUT", completion="dir"}, function(i)
    print ( i)
  end)


end


return M


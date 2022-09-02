local M = {}
local scan = require'plenary.scandir'
local path = require'plenary.path'


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


  -- stupid hack due to Cavo naming convention change
  if feature == "notes" then
   full_destination = libs_dir_root .. "/shared/" .. "notes" ..  "/data-access/src/lib/store/" .. "note" .. "." .. ngrx_part ..".ts"
  end

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


function M.jump_to_nearest_module()
  local current_buffer = vim.api.nvim_buf_get_name(0)
  local current_dir = path:new(current_buffer)
  local scan_result
  local count = 1
-- keep going up directories until you find a `.module.ts` (or stop at 10 as then something went wrong)
  repeat
      current_dir = current_dir:parent()
      scan_result = scan.scan_dir(current_dir:normalize() , {  search_pattern = '.module.ts' });
      count = count + 1
  until (table_length(scan_result) > 0 or count >= 10)

  local module_relative_path = scan_result[1]

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


function table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end






function M.playAround()

  vim.ui.input({prompt="INPUT", completion="dir"}, function(i)
    print ( i)
  end)


end


return M


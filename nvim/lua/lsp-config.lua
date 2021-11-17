local lspconfig = require "lspconfig"
local vim = vim
local uv = vim.loop


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

function mapBuf(buf, mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, options)
end
function autocmd(event, triggers, operations)
  local cmd = string.format("autocmd %s %s %s", event, triggers, operations)
 vim.cmd(cmd)
end

local function get_node_modules(root_dir)
  -- util.find_node_modules_ancestor()
  local root_node = root_dir .. "/node_modules"
  local stats = uv.fs_stat(root_node)
  if stats == nil then
    return nil
  else
    return root_node
  end
end
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end


local default_node_modules = get_node_modules(vim.fn.getcwd())



local ngls_cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  default_node_modules,
  "--ngProbeLocations",
  default_node_modules,
  "--experimental-ivy"
}

lspconfig.angularls.setup {
  cmd = ngls_cmd,
  capabilities = capabilities,
  -- on_attach = on_attach,
  on_new_config = function(new_config)
    new_config.cmd = ngls_cmd
  end
}




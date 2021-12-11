local vim = vim
local formatter = require("formatter")
local prettierConfig = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
    stdin = true
  }
end



local formatterConfig = {
  vue = {
    function()
      return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote", "--parser", "vue"},
        stdin = true
      }
    end
  },
}
local commonFT = {
  "css",
  "scss",
  "html",
  "java",
  "javascript",
  "typescript",
  "typescriptreact",
  "markdown",
  "markdown.mdx",
  "json"
}
for _, ft in ipairs(commonFT) do
  formatterConfig[ft] = {
    prettierConfig
  }
end
-- Setup functions
formatter.setup(
  {
    logging = false,
    filetype = formatterConfig
  }
)


-- format on save (maybe move to new file with other auto commands)
vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.ts,*,html,*.js FormatWrite
augroup END
]], true)



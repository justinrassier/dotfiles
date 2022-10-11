-- autocommand to set spelling on for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = vim.api.nvim_create_augroup("MarkdownSettings", {clear = true}),
  callback = function()
    vim.cmd("setlocal wrap")

    -- map j/k to gj/gk to handle wrapped lines
    vim.api.nvim_buf_set_keymap(0, "n", "j", "gj", {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(0, "n", "k", "gk", {noremap = true, silent = true})
  end
})


-- vim.api.nvim_create_autocmd("BufEnter", {
--   once = true,
--   group = vim.api.nvim_create_augroup("SetDarkMode", {clear = true}),
--   callback = function()
--     -- check os if dark mode
--     local dark_mode = vim.fn.system("defaults read -g AppleInterfaceStyle")
--     dark_mode = string.gsub(dark_mode, "^%s*(.-)%s*$", "%1")
--     if dark_mode == "Dark" then
--       -- vim.cmd("set background=dark")
--     else
--       -- vim.cmd("set background=light")
--     end
--   end
-- })

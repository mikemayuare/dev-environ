-- This creates an isolated group for your setting
local quarto_indent_group = vim.api.nvim_create_augroup("QuartoIndent", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "quarto", -- Only trigger when opening a quarto file
  group = quarto_indent_group,
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

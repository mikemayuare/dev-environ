-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- require("oil").setup({ default_file_explorer = true, view_options = { show_hidden = true } })
vim.opt.formatoptions:remove({ "c", "r", "o" })
require("vim._core.ui2").enable({})

-- Delete trailing spaces on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

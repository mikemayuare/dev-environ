-- Load custom VS Code snippets after lazy.nvim finishes setup
vim.schedule(function()
  pcall(function()
    require("luasnip.loaders.from_vscode").load({
      paths = vim.fn.stdpath("config") .. "/snippets",
    })
  end)
end)

return {}

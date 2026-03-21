-- ~/.config/nvim/lua/plugins/theme.lua
return {
  { "catppuccin/nvim" },
  {
    "gbprod/nord.nvim",
    config = function()
      require("nord").setup({
        transparent = true,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}

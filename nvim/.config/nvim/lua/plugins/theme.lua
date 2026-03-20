-- ~/.config/nvim/lua/plugins/theme.lua
if false then
  return {}
end
return {
  { "catppuccin/nvim" },
  { "st-eez/osaka-jade.nvim" },
  { "ellisonleao/gruvbox.nvim" },
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

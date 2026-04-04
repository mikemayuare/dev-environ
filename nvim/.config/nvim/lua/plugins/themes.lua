return {
  { "ribru17/bamboo.nvim", lazy = true, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = true, priority = 1000 },
  { "bjarneo/hackerman.nvim", lazy = true, priority = 1000 },
  { "catppuccin/nvim", lazy = true, priority = 1000 },
  { "sainnhe/everforest", lazy = true, priority = 1000 },
  { "kepano/flexoki-neovim", lazy = true, priority = 1000 },
  { "ellisonleao/gruvbox.nvim", lazy = true, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = true, priority = 1000 },
  { "tahayvr/matteblack.nvim", lazy = true, priority = 1000 },
  { "rose-pine/neovim", lazy = true, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = true, priority = 1000 },
  { "st-eez/osaka-jade.nvim", lazy = true, priority = 1000 },
  {
    "gbprod/nord.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("nord").setup({
        transparent = true,
      })
    end,
  },
}

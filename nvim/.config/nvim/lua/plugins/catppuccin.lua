return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavor = "mocha",
      integrations = {
        -- enable bufferline integration if your version supports it
        bufferline = true,
        cmp = true,
        treesitter = true,
        gitsigns = true,
      },
    },
  },
}

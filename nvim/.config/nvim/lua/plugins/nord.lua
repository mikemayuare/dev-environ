return {
  -- Nord colorscheme
  {
    "shaunsingh/nord.nvim",
    lazy = false, -- load immediately (so the colorscheme is ready)
    priority = 1000, -- ensure it's setup early
    config = function()
      -- Nord options (must be set before colorscheme)
      vim.g.nord_disable_background = true
      vim.g.nord_cursorline = true
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_enable_sidebar_background = true

      -- Apply the colorscheme
      -- vim.cmd("colorscheme nord")
    end,
  },

  -- Bufferline with Nord highlights
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local highlights = require("nord").bufferline.highlights({
        italic = true,
        bold = true,
        fill = "#181c24",
      })

      require("bufferline").setup({
        options = {
          separator_style = "slant",
        },
        highlights = highlights,
      })
    end,
  },
}

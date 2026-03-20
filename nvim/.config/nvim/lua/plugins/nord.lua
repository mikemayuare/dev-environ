return {
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({
        transparent = true, -- Built-in transparency support!
        on_highlights = function(highlights, colors)
          -- Fix the "invisible" ignored files in Neo-tree/Snacks
          local light_gray = "#919eb5"
          highlights.NeoTreeGitIgnored = { fg = light_gray }
          highlights.NvimTreeGitIgnored = { fg = light_gray }
          highlights.Comment = { fg = light_gray }

          -- Fix Snacks Picker dimmed items
          highlights.SnacksPickerDimmed = { fg = light_gray }
        end,
      })
      vim.cmd.colorscheme("nord")
    end,
  },
}

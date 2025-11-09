return {
  "GCBallesteros/jupytext.nvim",
  config = function()
    require("jupytext").setup({
      -- Use percent format (# %% markers) - compatible with NotebookNavigator
      style = "percent",

      -- Automatically determine extension (.py for Python, .R for R, etc.)
      output_extension = "auto",

      -- Let Neovim automatically detect the filetype
      force_ft = nil,

      -- Custom formatting per language (optional)
      -- Uncomment if you want to force Python notebooks to specific formats
      custom_language_formatting = {
        -- python = {
        --   extension = "py",
        --   style = "percent",
        -- },
      },
    })
  end,

  -- IMPORTANT: Don't lazy load this plugin!
  -- It needs to be available when you open .ipynb files
  lazy = false,
}

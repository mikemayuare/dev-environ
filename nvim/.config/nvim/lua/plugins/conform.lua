return {
  { -- Formatter plugin
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        -- The "injected" formatter tells conform to use treesitter to find
        -- code blocks (like Python) and run their native formatters on them.
        quarto = { "injected" },
        markdown = { "injected" },
      },
    },
  },
}

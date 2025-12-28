return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        markdown = {}, -- Empty array = no linters
        -- other filetypes...
      }

      -- Optional: auto-run linting on events
      -- vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      --   callback = function()
      --     require("lint").try_lint()
      --   end,
      -- })
    end,
  },
}

return {
  -- Linting with sqlfluff
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sql = { "sqlfluff" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqlfluff_fix" },
      },
      formatters = {
        sqlfluff_fix = {
          command = "sqlfluff",
          args = { "fix", "--dialect=bigquery", "-" },
          stdin = true,
        },
      },
    },
  },
}

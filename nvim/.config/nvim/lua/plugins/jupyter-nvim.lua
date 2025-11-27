return {
  {
    "PeterJohannsenCMT/nvim-jupyter",
    enabled = false,
    ft = "python",
    config = function()
      require("jupyter").setup({
        -- Optional configuration (see Configuration section)
        python_cmd = ".venv/bin/python",
      })
    end,
  },
}

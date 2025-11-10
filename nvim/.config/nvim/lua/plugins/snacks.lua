return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      hidden = true,
      filter = function(entry)
        return entry.name ~= ".DS_Store"
      end,
    },
    gh = {},
    picker = {
      -- Enable hidden files globally for picker
      hidden = true,
      sources = {
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
        },
        gh_pr = {},
        files = {
          hidden = true,
        },
      },
    },
    styles = {
      picker = {
        wo = {
          cursorline = true,
        },
      },
    },
    keys = {
      {
        "<leader>gi",
        function()
          Snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>gI",
        function()
          Snacks.picker.gh_issue({ state = "all" })
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>gp",
        function()
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>gP",
        function()
          Snacks.picker.gh_pr({ state = "all" })
        end,
        desc = "GitHub Pull Requests (all)",
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    -- Set highlights after Snacks is loaded
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#88C0D0" })
    vim.api.nvim_set_hl(0, "Directory", { fg = "#88C0D0", bold = true })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#616E88" })
  end,
}

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
    dashboard = {
      sections = {
        -- Wide version (180 columns or more)
        {
          enabled = function()
            return (vim.o.columns >= 180)
          end,
          {
            section = "header",
            indent = 64,
          },
          {
            pane = 1,
            {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
              { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
              { icon = "󱁤 ", key = "m", desc = "Mason", action = ":Mason" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
              padding = 5,
            },
            {
              section = "startup",
              indent = 64,
            },
          },
          {
            pane = 2,
            {
              padding = 8,
            },
            {
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              indent = 3,
              padding = 1,
            },
            {
              icon = " ",
              title = "Projects",
              section = "projects",
              indent = 3,
            },
          },
        },

        -- Slim version (less than 180 columns)
        {
          enabled = function()
            return (vim.o.columns < 180)
          end,
          {
            { section = "header" },
            {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
              { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
              { icon = "󱁤 ", key = "m", desc = "Mason", action = ":Mason" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
              padding = 1,
            },
            {
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              indent = 3,
              padding = 1,
            },
            {
              icon = " ",
              title = "Projects",
              section = "projects",
              indent = 3,
              padding = 3,
            },
            {
              section = "startup",
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    -- Set highlights after Snacks is loaded
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#88C0D0" })
    vim.api.nvim_set_hl(0, "Directory", { fg = "#88C0D0", bold = true })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#616E88" })
    vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#D8DEE9", bold = false })
    vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#A3BE8C", bold = false })
  end,
}

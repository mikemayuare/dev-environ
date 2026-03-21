return {
  "folke/snacks.nvim",
  opts = {
    --     dashboard = {
    --       preset = {
    --         header = [[
    -- ███████╗██╗         ██╗  ██╗███████╗██╗   ██╗██╗███╗   ███╗
    -- ██╔════╝██║         ██║ ██╔╝██╔════╝██║   ██║██║████╗ ████║
    -- █████╗  ██║         █████╔╝ █████╗  ██║   ██║██║██╔████╔██║
    -- ██╔══╝  ██║         ██╔═██╗ ██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
    -- ███████╗███████╗    ██║  ██╗███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
    -- ╚══════╝╚══════╝    ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
    --
    --         ]],
    --       },
    --     },
    explorer = {
      enabled = false,
    },
    gh = {},
    picker = {
      layout = "custom",
      layouts = {
        custom = {
          preview = "main",
          layout = {
            box = "vertical",
            backdrop = false,
            width = 0,
            height = 0.4,
            position = "bottom",
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            {
              box = "horizontal",
              { win = "list", border = "rounded" },
              { win = "preview", title = "{preview}", width = 0.6, border = "left" },
            },
            { win = "input", height = 1, border = "bottom" },
          },
        },
      },
      -- Enable hidden files globally for picker
      hidden = true,
      sources = {
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
          hidden = true,
          exclude = { ".git", ".venv", ".DS_Store", ".ruff_cache" },
        },
        gh_pr = {},
        files = {
          hidden = true,
          exclude = { ".git", ".venv", ".DS_Store", ".ruff_cache" },
        },
        grep = {
          hidden = true,
          exclude = { ".git", ".venv", ".DS_Store", ".ruff_cache" },
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
}

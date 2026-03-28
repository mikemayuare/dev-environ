return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[

          ███╗   ███╗██╗██╗  ██╗███████╗██╗   ██╗██╗███╗   ███╗          Z
          ████╗ ████║██║██║ ██╔╝██╔════╝██║   ██║██║████╗ ████║      Z    
          ██╔████╔██║██║█████╔╝ █████╗  ██║   ██║██║██╔████╔██║   z       
          ██║╚██╔╝██║██║██╔═██╗ ██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
          ██║ ╚═╝ ██║██║██║  ██╗███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║           
          ╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝           
]],
      },
    },
    -- Snacks Explorer
    explorer = {
      hidden = false,
      filter = function(entry)
        local excluded = { ".DS_Store", ".venv", ".git", ".ruff_cache" }
        for _, name in ipairs(excluded) do
          if entry.name == name then
            return false
          end
        end
        return true
      end,
    },
    -- Snacks GitHub
    gh = {},
    -- Snacks Picker
    picker = {
      layout = "custom",
      layouts = {
        custom = {
          preview = "main",
          layout = {
            box = "vertical",
            backdrop = true,
            width = 0,
            height = 0.4,
            position = "bottom",
            border = "none",
            title = " {title} {live} {flags}",
            title_pos = "left",
            {
              box = "horizontal",
              { win = "list", border = "rounded" },
              { win = "preview", title = "{preview}", border = "rounded" },
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
    select = {
      enable = true,
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
  -- config = function(_, opts)
  --   require("snacks").setup(opts)
  --   -- Set highlights after Snacks is loaded
  --   vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#88C0D0" })
  --   vim.api.nvim_set_hl(0, "Directory", { fg = "#88C0D0", bold = true })
  --   vim.api.nvim_set_hl(0, "Comment", { fg = "#616E88" })
  --   vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#D8DEE9", bold = false })
  -- end,
}

return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      hidden = true,
      filter = function(entry)
        return entry.name ~= ".DS_Store"
      end,
    },
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
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    -- Set highlights after Snacks is loaded
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#88C0D0" })
    vim.api.nvim_set_hl(0, "Directory", { fg = "#88C0D0", bold = true })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#616E88" })
  end,
}

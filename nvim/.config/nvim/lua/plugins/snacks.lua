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
      sources = {
        explorer = {
          -- Notice the nested layout.layout for position
          layout = {
            layout = {
              position = "right",
            },
          },
        },
        files = {
          hidden = true, -- set to true to include hidden files
        },
      },
    },
  },
}

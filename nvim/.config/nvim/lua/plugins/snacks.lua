return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      hidden = true,
      position = "right", -- or "left" (default), "top", "bottom", "float"
      filter = function(entry)
        return entry.name ~= ".DS_Store"
      end,
    },
    picker = {
      hidden = true,
    },
  },
}

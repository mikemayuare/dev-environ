return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "data_science",
        path = "~/Obsidian/data_science/",
      },
    },
    note_id_func = function(title)
      if title ~= nil then
        return title:gsub(" ", "-"):gsub("[^%w%-]", ""):lower()
      else
        return tostring(os.time())
      end
    end,
    templates = {
      folder = "templates", -- MUST be relative to vault root
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    ui = {
      enable = false,
    },
  },
}

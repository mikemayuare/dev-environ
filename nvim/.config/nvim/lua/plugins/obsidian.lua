return {
  "obsidian-nvim/obsidian.nvim",
  lazy = false,
  version = "*", -- recommended, use latest release instead of latest commit
  ---@module  'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    -- This replaces the "random numbers" with the title you type
    note_id_func = function(title)
      if title ~= nil then
        -- Transform title into a valid file name (lowercase, no spaces)
        return title:gsub(" ", "-"):gsub("[^%w%-]", ""):lower()
      else
        -- Fallback to a timestamp if no title is provided
        return tostring(os.time())
      end
    end,
    workspaces = {
      {
        name = "data_science",
        path = "~/Obsidian/data_science/",
      },
    },
    templates = {
      folder = "templates", -- The folder name inside your vault
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- Optional: define variables you use in your templates
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
      },
    },
    ui = {
      enable = false,
    },
  },
}

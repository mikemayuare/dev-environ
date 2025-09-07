return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false, -- optional: also show git-ignored files
        hide_by_name = {
          -- you can still hide specific files/folders if needed
          -- ".git",
          -- "node_modules",
        },
        never_show = {
          -- files that should always be hidden
          ".DS_Store",
          "thumbs.db",
        },
      },
    },
  },
}

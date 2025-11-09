-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("oil").setup({ default_file_explorer = true, view_options = { show_hidden = true } })

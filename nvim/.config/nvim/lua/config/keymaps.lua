-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>O", "<cmd>Obsidian<cr>")
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>")
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian new_from_template<cr>")
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>")
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>")
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian follow_link<cr>")

-- 1. Force delete LazyVim's stubborn window navigation
pcall(vim.keymap.del, "n", "<C-h>")
pcall(vim.keymap.del, "n", "<C-j>")
pcall(vim.keymap.del, "n", "<C-k>")
pcall(vim.keymap.del, "n", "<C-l>")

-- 2. Setup herdr-nvim-nav immediately after, locking in the keys
require("herdr-nvim-nav").setup({
  with_tmux = false,

  -- Hardcoded paths to bypass macOS environment stripping
  herdr_bin = vim.fn.expand("~/.local/bin/herdr"),
  socket_path = vim.fn.expand("~/.config/herdr/herdr.sock"),
  cache_dir = vim.fn.expand("~/.cache"),

  keymaps = {
    left = { "<C-h>" },
    down = { "<C-j>" },
    up = { "<C-k>" },
    right = { "<C-l>" },
  },
})

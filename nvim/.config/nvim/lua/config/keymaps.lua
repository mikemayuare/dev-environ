-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Remap arrow keys to act as h, j, k, l in normal mode
vim.keymap.set("n", "<Up>", "k", { desc = "Move cursor up" })
vim.keymap.set("n", "<Down>", "j", { desc = "Move cursor down" })
vim.keymap.set("n", "<Left>", "h", { desc = "Move cursor left" })
vim.keymap.set("n", "<Right>", "l", { desc = "Move cursor right" })

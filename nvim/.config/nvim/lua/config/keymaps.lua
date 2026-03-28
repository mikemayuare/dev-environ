-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Remap arrow keys to act as h, j, k, l in normal mode
-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>O", "<cmd>Obsidian<cr>")
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>")
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian new_from_template<cr>")
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>")
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Remap arrow keys to act as h, j, k, l in normal mode
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>O", "<CMD>Obsidian<CR>", { desc = "Open Obsidian menu" })
vim.keymap.set("n", "<leader>ot", "<CMD>Obsidian new_from_template<CR>", { desc = "Open new note from template" })
vim.keymap.set("n", "<leader>on", "<CMD>Obsidian new<CR>", { desc = "Open a new note" })
vim.keymap.set("n", "<leader>of", "<CMD>Obsidian follow_link<CR>", { desc = "Follow link" })
vim.keymap.set("n", "<leader>oo", "<CMD>Obsidian open<CR>", { desc = "Open Obsidian app" })

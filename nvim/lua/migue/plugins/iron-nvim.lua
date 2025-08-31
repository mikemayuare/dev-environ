return {
	"Vigemus/iron.nvim",
	main = "iron.core",
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		local common = require("iron.fts.common")

		iron.setup({
			config = {
				-- Whether a repl should be discarded or not
				scratch_repl = true,

				-- REPL definitions for your languages
				repl_definition = {
					sh = {
						command = { "fish" },
					},
					python = {
						command = function(meta)
							-- Try $VIRTUAL_ENV first
							local venv = os.getenv("VIRTUAL_ENV")
							if venv then
								-- Use ipython from the virtual environment
								return { venv .. "/bin/ipython", "--no-autoindent" }
							end

							-- Try `.venv/bin/ipython` in project root
							local cwd = vim.fn.getcwd()
							local venv_ipython = cwd .. "/.venv/bin/ipython"
							if vim.fn.executable(venv_ipython) == 1 then
								return { venv_ipython, "--no-autoindent" }
							end

							-- Fallback to global ipython
							return { "ipython", "--no-autoindent" }
						end,
						format = require("iron.fts.common").bracketed_paste_python,
						block_dividers = { "# %%", "#%%" },
					},
				},

				-- How the repl window will be displayed
				-- This uses a split (not float!)
				-- Example: vertical split of 50 columns on the right
				repl_open_cmd = view.split.vertical.botright(80),
			},

			keymaps = {
				toggle_repl = "<space>jn", -- toggle repl
				restart_repl = "<space>rk", -- restart repl
				send_motion = "<space>sc",
				visual_send = "<space>sc",
				send_file = "<space>sf",
				send_line = "<space>sl",
				send_paragraph = "<space>sp",
				send_until_cursor = "<space>su",
				send_mark = "<space>sm",
				send_code_block = "<space>sb",
				send_code_block_and_move = "<space>sn",
				mark_motion = "<space>mc",
				mark_visual = "<space>mc",
				remove_mark = "<space>md",
				cr = "<space>s<cr>",
				interrupt = "<space>s<space>",
				exit = "<space>sq",
				clear = "<space>cl",
			},

			highlight = {
				italic = true,
			},

			ignore_blank_lines = true,
		})

		-- Extra keymaps (as per docs)
		vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
	end,
}

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- tab and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- aplit windows
opt.splitright = true
opt.splitbelow = true

-- considers dash "-" as a part of the word
opt.iskeyword:append("-")

-- auto-detect project venv
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local cwd = vim.fn.getcwd()
		local venv_python = cwd .. ".venv/bin/python"
		if vim.fn.executable(venv_python) == 1 then
			vim.g.python3_host_prog = venv_python
		end
	end,
})

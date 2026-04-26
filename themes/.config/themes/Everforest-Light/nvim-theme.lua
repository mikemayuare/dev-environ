return {
	{
		"neanias/everforest-nvim",
		config = function()
			require("everforest").setup({
				background = "hard",
			})
			vim.o.background = "light"
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "everforest",
		},
	},
}

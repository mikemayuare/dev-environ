return {
	{
		"neanias/everforest-nvim",
		config = function()
			require("everforest").setup({
				background = "hard",
				transparent_background_level = 2,
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

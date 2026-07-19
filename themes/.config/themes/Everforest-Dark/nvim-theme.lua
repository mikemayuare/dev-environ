return {
	{
		"neanias/everforest-nvim",
		config = function()
			require("everforest").setup({
				background = "medium",
				transparent_background_level = 2,
			})
			vim.o.background = "dark"
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "everforest",
		},
	},
}

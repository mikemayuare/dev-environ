return {
	{
		"neanias/everforest-nvim",
		config = function()
			require("everforest").setup({
				background = "medium",
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

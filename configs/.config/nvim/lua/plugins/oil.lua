-- https://parilia.dev/a/neovim/oil/
-- File manager.
return {
	'stevearc/oil.nvim',
	opts = {
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = {
		{ "echasnovski/mini.icons", opts = {} },
		-- { "nvim-tree/nvim-web-devicons" },
	},
}

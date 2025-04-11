-- https://parilia.dev/a/neovim/oil/
-- File manager.
return {
	'stevearc/oil.nvim',
	enabled = false,
	opts = {
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = {
		'echasnovski/mini.icons',
		-- 'nvim-tree/nvim-web-devicons',
	},
}

-- https://github.com/nvim-telescope/telescope.nvim
-- Extensible generic search tool.
return {
	'nvim-telescope/telescope.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {
		defaults = {
			layout_config = {
				width = 0.95,
				height = 0.95,
			},
		},
	},
}

-- https://github.com/nvim-telescope/telescope.nvim
-- Extensible generic search tool.
return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-telescope/telescope-file-browser.nvim',
		'nvim-lua/plenary.nvim',
	},
	opts = {
		defaults = {
			layout_config = {
				width = 0.95,
				height = 0.95,
			},
		},
		pickers = {
			find_files = {
				-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
				find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
			},
		},
		extensions = {
			file_browser = {
				hijack_netrw = true,
				hidden = {
					file_browser = true,
					folder_browser = true,
				},
			},
		},
	},
}

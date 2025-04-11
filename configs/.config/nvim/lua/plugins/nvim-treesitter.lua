-- https://github.com/nvim-treesitter/nvim-treesitter
-- Fast parser of code. Needed for codecompanion.
return {
	'nvim-treesitter/nvim-treesitter',
	opts = {
		ensure_installed = { 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'yaml' },
		sync_install = true,
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	},
	build = ':TSUpdate',
}

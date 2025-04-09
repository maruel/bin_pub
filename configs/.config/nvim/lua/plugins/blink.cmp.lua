-- https://github.com/Saghen/blink.cmp
return {
	'saghen/blink.cmp',
	enabled = false,
	-- use a release tag to download pre-built binaries
	version = '1.*',
	opts = {
		keymap = {
			preset = 'default',
		},
		completion = {
			documentation = {
				auto_show = false,
			},
		},
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
			per_filetype = {
				codecompanion = { "codecompanion" },
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	dependencies = { 'rafamadriz/friendly-snippets' },
}

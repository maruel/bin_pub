-- https://github.com/ray-x/go.nvim#lazynvim
-- Lots of go specific functionality.
return {
	'ray-x/go.nvim',
	config = true,
	opts = {
		lsp_cfg = false,
		lsp_document_formatting = false,
		lsp_keymaps = false,
		lsp_codelens = false,
		lsp_inlay_hints = {
			enable = false,
		},
	},
	dependencies = {
		'ray-x/guihua.lua',
		'neovim/nvim-lspconfig',
		'nvim-treesitter/nvim-treesitter',
	},
	event = { 'CmdlineEnter' },
	ft = { 'go' },
	-- Install go tools as needed.
	build = function()
		require("go.install").update_all_sync()
	end,
}

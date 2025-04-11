-- https://github.com/ray-x/go.nvim#lazynvim
-- Lots of go specific functionality.
return {
	'ray-x/go.nvim',
	dependencies = {
		'ray-x/guihua.lua',
		'neovim/nvim-lspconfig',
		'nvim-treesitter/nvim-treesitter',
	},
	config = true,
	opts = {},
	event = { 'CmdlineEnter' },
	ft = { 'go' },
	-- Install go tools as needed.
	build = function()
		require("go.install").update_all_sync()
	end,
}

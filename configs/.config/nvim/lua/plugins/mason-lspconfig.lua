-- https://github.com/williamboman/mason-lspconfig.nvim
return {
	'williamboman/mason-lspconfig.nvim',
	opts = {
		-- Auto-install favorite language servers.
		ensure_installed = { 'gopls', 'lua_ls', 'marksman', 'pyright' },
		automatic_installation = true,
		handlers = {
			function(server_name)
				require('lspconfig')[server_name].setup({})
			end,
		},
	},
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
	},
}

-- https://github.com/williamboman/mason.nvim
-- Package manager, used for LSP servers via mason-lspconfig.
return {
	'williamboman/mason.nvim',
	config = true,
	opts = {
		ensure_installed = { 'black' },
	},
}

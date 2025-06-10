-- https://github.com/mason-org/mason.nvim
-- Package manager, used for LSP servers via mason-lspconfig.
return {
	'mason-org/mason.nvim',
	config = true,
	opts = {
		ensure_installed = { 'black' },
	},
}

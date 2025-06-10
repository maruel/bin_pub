-- https://github.com/mason-org/mason-lspconfig.nvim
return {
	'mason-org/mason-lspconfig.nvim',
	opts = {
		-- Auto-install favorite language servers.
		-- https://github.com/mason-org/mason-lspconfig.nvim#available-lsp-servers
		ensure_installed = {
			'bashls', -- Bash
			-- 'bzl',       -- Bazel and Starlark
			'cmake', -- CMake
			'cssls', -- CSS
			'gopls', -- Go
			'html', -- HTML
			'lua_ls', -- Lua
			-- 'marksman',  -- Markdown
			'pyright', -- Python
			'remark_ls', -- Markdown
			-- 'sourcekit', -- Swift, Objective-C
			'typos_lsp', -- Spelling
			'yamlls', -- YAML
		},
	},
	dependencies = {
		'neovim/nvim-lspconfig',
		'mason-org/mason.nvim',
	},
}

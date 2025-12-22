-- https://github.com/mason-org/mason-lspconfig.nvim
return {
	'mason-org/mason-lspconfig.nvim',
	opts = {
		-- Auto-install favorite language servers.
		-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
		ensure_installed = {
			'bashls', -- Bash
			-- 'bzl',       -- Bazel and Starlark
			'cmake', -- CMake
			'cssls', -- CSS
			'gopls', -- Go
			'kotlin_language_server',
			'html', -- HTML
			-- 'superhtml', -- HTML
			-- 'biome', -- HTML
			'lua_ls', -- Lua
			-- 'marksman',  -- Markdown
			-- 'pyright', -- Python
			'remark_ls', -- Markdown
			'ruff',   -- Python
			-- 'sourcekit', -- Swift, Objective-C
			'ts_ls',  -- TypeScript
			'typos_lsp', -- Spelling
			'yamlls', -- YAML
		},
	},
	dependencies = {
		'neovim/nvim-lspconfig',
		'mason-org/mason.nvim',
	},
}

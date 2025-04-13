-- https://github.com/williamboman/mason-lspconfig.nvim
return {
	'williamboman/mason-lspconfig.nvim',
	config = function()
		local mason_lspconfig = require('mason-lspconfig')
		mason_lspconfig.setup({
			-- Auto-install favorite language servers.
			-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
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
			automatic_installation = true,
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup({})
				end,
			},
		})
		-- Things will change soon: https://github.com/neovim/nvim-lspconfig/issues/3494
		-- TODO: Revisit after 2025-06.
		-- vim.lsp.set_log_level("debug")
		local lspconfig = require('lspconfig')
		mason_lspconfig.setup_handlers({
			-- Make sure by default all automatically installed LSP servers are set up.
			function(server_name)
				lspconfig[server_name].setup({})
			end,
			['gopls'] = function()
				lspconfig.gopls.setup({
					on_attach = function(client, bufnr)
						if vim.bo[bufnr].filetype == 'gomod' then
							-- As of 2025-03, it's unusable.
							client.stop()
						end
					end,
					settings = {
						gopls = {
							analyses = { unusedparams = true, },
							staticcheck = true,
							gofumpt = true,
						},
					},
				})
			end,
			['lua_ls'] = function()
				lspconfig.lua_ls.setup({
					settings = {
						Lua = {
							runtime = { version = 'LuaJIT', },
							workspace = { library = vim.api.nvim_get_runtime_file('', true), },
							diagnostics = { globals = { 'vim', }, },
							telemetry = { enable = false, },
						},
					},
				})
			end,
		})
	end,
	dependencies = {
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
	},
}

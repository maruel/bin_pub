-- https://codecompanion.olimorris.dev/
return {
	'olimorris/codecompanion.nvim',
	opts = {
		strategies = {
			chat = {
				adapter = 'copilot',
				-- adapter = 'ollama',
				-- adapter = 'anthropic',
				tools = {
					['mcp'] = {
						-- Calling it in a function prevent mcphub from being loaded before it's needed since
						-- it's slow.
						callback = function() return require('mcphub.extensions.codecompanion') end,
						description = 'Call tools and resources from the MCP Servers',
					},
				},
				start_in_insert_mode = true,
			},
			inline = {
				adapter = 'copilot',
				-- adapter = 'ollama',
				-- adapter = 'anthropic',
			},
		}
	},
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-treesitter/nvim-treesitter',
	},
	build = ':TSInstall yaml',
}

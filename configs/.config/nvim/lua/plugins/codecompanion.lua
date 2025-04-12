-- https://codecompanion.olimorris.dev/
return {
	'olimorris/codecompanion.nvim',
	opts = {
		strategies = {
			chat = {
				-- Options: 'anthropic', 'cerebras', 'copilot', 'groq', 'ollama'
				adapter = 'cerebras',
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
			-- TODO: figure out to make it work without copilot plugin.
			inline = {
				adapter = 'cerebras',
			},
		},
		adapters = {
			cerebras = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "https://api.cerebras.ai",
						api_key = vim.env.CEREBRAS_API_KEY,
					},
					schema = {
						model = {
							default = function(self)
								-- https://cloud.cerebras.ai/
								return "llama-4-scout-17b-16e-instruct"
							end,
						},
					},
				})
			end,
			groq = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "https://api.groq.com/openai",
						api_key = vim.env.GROQ_API_KEY,
					},
					schema = {
						model = {
							default = function(self)
								-- See https://console.groq.com/settings/models
								return "qwen-2.5-coder-32b"
								-- return "qwen-qwq-32b"
							end,
						},
					},
				})
			end,
		},
	},
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-treesitter/nvim-treesitter',
	},
	build = ':TSInstall yaml',
}

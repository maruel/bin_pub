-- https://codecompanion.olimorris.dev/
return {
	"olimorris/codecompanion.nvim",
	opts = {
		strategies = {
			chat = {
				adapter = "anthropic",
				tools = {
					["mcp"] = {
						-- calling it in a function would prevent mcphub from being loaded before it's needed
						callback = function() return require("mcphub.extensions.codecompanion") end,
						description = "Call tools and resources from the MCP Servers",
					},
				},
			},
			inline = {
				adapter = "anthropic",
			},
		}
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
}

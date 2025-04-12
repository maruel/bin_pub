-- https://github.com/ravitemer/mcphub.nvim
-- https://github.com/ravitemer/mcphub.nvim/wiki/Installation
-- https://github.com/ravitemer/mcphub.nvim/wiki/CodeCompanion
-- MCP concentrator.
return {
	'ravitemer/mcphub.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	cmd = 'MCPHub',
	-- build = 'npm install -g mcp-hub@latest',
	build = 'bundled_build.lua',
	opts = {
		use_bundled_binary = true,
		auto_approve = false,
		extensions = {
			codecompanion = {
				show_result_in_chat = true, -- Show tool results in chat
				make_vars = true, -- Create chat variables from resources
				make_slash_commands = true, -- make /slash_commands from MCP server prompts
			},
		},
	},
}

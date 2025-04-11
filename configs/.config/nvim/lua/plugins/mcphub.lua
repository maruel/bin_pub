-- https://github.com/ravitemer/mcphub.nvim
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
	},
}

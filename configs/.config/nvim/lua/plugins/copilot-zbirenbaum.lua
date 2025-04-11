-- Defaults for https://github.com/zbirenbaum/copilot.lua are conservative. I
-- can't get the same feeling yet as with github's official version.
return {
	'zbirenbaum/copilot.lua',
	enabled = false,
	lazy = true,
	opts = {
		auto_refresh = true,
		suggestions = {
			-- require('copilot.suggestion').toggle_auto_trigger()
			auto_trigger = true
		},
		-- copilot_model
	},
}

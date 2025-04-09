-- Defaults for https://github.com/github/copilot.vim are simpler.
-- In particular, https://github.com/yetone/avante.nvim/issues/1048#issuecomment-2585235716
--
-- Defaults for https://github.com/zbirenbaum/copilot.lua are conservative. I
-- can't get the same feeling yet as with github's official version.
return {
	-- "github/copilot.vim"
	"zbirenbaum/copilot.lua",
	lazy = true,
	opts = {
		auto_refresh = true,
		suggestions = {
			-- require("copilot.suggestion").toggle_auto_trigger()
			auto_trigger = true
		},
		-- copilot_model
	},
}

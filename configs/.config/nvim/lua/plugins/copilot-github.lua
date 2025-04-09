-- https://github.com/github/copilot.vim
-- It's less aggressive than
-- In particular, https://github.com/yetone/avante.nvim/issues/1048#issuecomment-2585235716
return {
	"github/copilot.vim",
	enabled = false,
	lazy = true,
	init = function()
		vim.g.copilot_no_tab_map = true
	end,
}

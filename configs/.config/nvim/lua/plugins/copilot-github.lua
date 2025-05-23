-- https://github.com/github/copilot.vim
-- It's less aggressive than
-- In particular, https://github.com/yetone/avante.nvim/issues/1048#issuecomment-2585235716
-- :Copilot setup
return {
	'github/copilot.vim',
	-- Disable when out of quota.
	enabled = false,
	init = function()
		vim.g.copilot_no_tab_map = true
		vim.keymap.set('i', '<C-J>', "copilot#Accept('\\<CR>')", { expr = true, replace_keycodes = false })
	end,
}

-- https://github.com/Exafunction/windsurf.vim
-- :Codeium Auth
return {
	'Exafunction/windsurf.vim',
	-- enabled = false,
	event = 'BufEnter',
	init = function()
		vim.g.codeium_disable_bindings = 1
		vim.keymap.set('i', '<C-J>', "codeium#Accept()", { expr = true, replace_keycodes = false })
	end,
}

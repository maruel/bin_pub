-- https://github.com/kiddos/gemini.nvim
return {
	'kiddos/gemini.nvim',
	enabled = false,
	event = 'BufEnter',
	opts = {
		chat_config = {
			enabled = false,
		},
		hints = {
			insert_result_key = '<C-J>',
		},
		completion = {
			insert_result_key = '<C-J>',
		},
		instruction = {
			enabled = false,
		},
		task = {
			enabled = false,
		},
	},
}

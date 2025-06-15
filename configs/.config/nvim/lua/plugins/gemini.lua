-- https://github.com/kiddos/gemini.nvim
return {
	'kiddos/gemini.nvim',
	enabled = false,
	event = 'BufEnter',
	opts = {
		model_config = {
			-- completion_delay = 100,
			model_id = "gemini-2.5-flash-preview-05-20",
		},
		chat_config = {
			enabled = false,
		},
		hints = {
			insert_result_key = '<C-J>',
		},
		completion = {
			completion_delay = 100,
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

-- https://github.com/yetone/avante.nvim#installation
return {
	'yetone/avante.nvim',
	-- TODO: decide later.
	enabled = false,
	lazy = true,
	event = 'VeryLazy',
	version = false,
	init = function()
		-- See https://github.com/yetone/avante.nvim
		vim.opt.laststatus = 3
	end,
	opts = {
		suggestion = {
			debounce = 600,
			throttle = 600,
		},
		-- https://github.com/yetone/avante.nvim/blob/main/cursor-planning-mode.md
		-- cursor_applying_provider = 'groq',
		behaviour = {
			enable_cursor_planning_mode = true,
		},
		-- Will try others.
		provider = 'ollama',
		ollama = {
			model = 'qwen2.5-coder:14b',
			endpoint = 'http://127.0.0.1:11434',
		},
		vendors = {
			groq = {
				__inherited_from = 'openai',
				api_key_name = 'GROQ_API_KEY',
				endpoint = 'https://api.groq.com/openai/v1/',
				model = 'llama-3.3-70b-versatile',
				-- remember to increase this value, otherwise it will stop generating halfway
				max_completion_tokens = 32768,
			},
		},
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = 'make',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'stevearc/dressing.nvim',
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		--- The below dependencies are optional,
		'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
		-- 'zbirenbaum/copilot.lua', -- for providers='copilot'
		{
			-- support for image pasting
			'HakonHarnes/img-clip.nvim',
			event = 'VeryLazy',
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { 'markdown', 'Avante' },
			},
			ft = { 'markdown', 'Avante' },
		},
	},
}

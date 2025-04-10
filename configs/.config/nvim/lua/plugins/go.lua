-- https://github.com/ray-x/go.nvim#lazynvim
-- Lots of go specific functionality.
return {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = true,
	opts = {},
	event = { "CmdlineEnter" },
	-- it's annoying when processing 'gomod'
	ft = { "go" },
	build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}

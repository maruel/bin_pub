-- Ref: https://neovim.io/doc/user/lua-guide.html
-- TODO: Take a look at https://dotfyle.com/neovim/plugins/top
--
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.mouse = ''
-- Need some testing...
vim.o.termguicolors = true
vim.o.background = "dark"
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.cmd("highlight Normal guifg=#FFFFFF ctermfg=231")
	end,
})
vim.cmd("colorscheme default")

-- Load all plugins.
require("config.lazy")
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {},
	automatic_installation = true,
})
-- require('avante').setup()
-- When we get an error on save like:
--   [LSP] Format request failed, no matching language servers.
--   method textDocument/codeAction is not supported by any of the servers registered for the current buffer
-- We need to check https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md and configure the language server.
local lspconfig = require('lspconfig')
lspconfig.gopls.setup({})
-- lspconfig.grammarly.setup({})
-- sudo apt-get install ninja-build
-- git clone https://github.com/LuaLS/lua-language-server && cd lua-language-server && ./make.sh
-- Add to PATH.
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT', },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), },
		},
	},
})
lspconfig.marksman.setup({})
-- npm i -g pyright
lspconfig.pyright.setup({})
lspconfig.sourcekit.setup({
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
})
local gitsigns = require('gitsigns')
local telescope = require('telescope')
telescope.setup({
	defaults = {
		layout_config = {
			width = 0.95,
			height = 0.95,
		},
	},
})
local telescope_builtin = require('telescope.builtin')
-- https://parilia.dev/a/neovim/oil/
require('oil').setup({
	view_options = {
		show_hidden = true,
	},
})


-- Key bindings.
-- F-keys
vim.keymap.set({ 'n', 'v' }, '<F3>', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<F3>', '<Esc>:NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<F4>', gitsigns.blame, { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<F5>', ':GoCoverage<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<F5>', '<Esc>:GoCoverage<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<F9>', ':bp<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<F9>', '<Esc>:bp<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<F10>', ':bn<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<F10>', '<Esc>:bn<CR>', { noremap = true, silent = true })
-- Others
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>e', ':Oil --float<CR>')

vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- Auto format on save.
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		vim.lsp.buf.format()
		vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
		vim.lsp.buf.code_action { context = { only = { 'source.fixAll' } }, apply = true }
	end,
})


-- Go specific.
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require('go.format').goimports()
	end,
	group = format_sync_grp,
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.go" },
	callback = function(ev)
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
	end
})


-- Save cursor position
vim.api.nvim_create_augroup("RestoreCursorPosition", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "RestoreCursorPosition",
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end
})

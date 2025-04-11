-- Ref: https://neovim.io/doc/user/lua-guide.html
-- TODO: Take a look at https://dotfyle.com/neovim/plugins/top
--
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
--
-- https://neovim.io/doc/user/lua.html#vim.g
vim.g.mapleader = ' '
vim.g.maplocalleader = "\\"

-- https://neovim.io/doc/user/lua.html#vim.opt
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.mouse = ''
-- Make 'gw' wrap at 110 columns.
vim.opt.textwidth = 110
--  Use a subtle highlight at 80 columns.
-- PROBLEM: breaks copying with the termina.
-- PROBLEM: ColorColumn is ignored.
-- vim.opt.colorcolumn = '80'

-- https://neovim.io/doc/user/lua.html#vim.o
vim.o.foldenable = true
vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 99

-- Need some testing...
-- vim.o.termguicolors = true
-- vim.api.nvim_create_autocmd('ColorScheme', {
-- 	pattern = '*',
-- 	callback = function()
-- 		vim.cmd('highlight Normal guifg=#FFFFFF ctermfg=231')
-- 	end,
-- })

vim.cmd('colorscheme default')
-- vim.opt.background = 'dark'
vim.cmd('highlight Normal ctermbg=black')
vim.cmd('highlight SpecialKey ctermfg=Red')
-- Syntax highlighting for the primary groups. These only take effect when
-- 'syntax on' is used.
-- (see :help group-name):
vim.cmd('highlight Comment    ctermfg=LightBlue')
vim.cmd('highlight Constant   ctermfg=White')
vim.cmd('highlight String     ctermfg=DarkGreen')
vim.cmd('highlight Identifier ctermfg=White')
-- Keep statements highlighted: highlight Statement  ctermfg=White
vim.cmd('highlight PreProc    ctermfg=White')
vim.cmd('highlight Type       ctermfg=White')
vim.cmd('highlight Special    ctermfg=DarkGreen')
-- Highlight changes outside of groups. They take effect even when 'syntax off'
-- is used.
vim.cmd('highlight Search     ctermfg=Black ctermbg=DarkYellow')
vim.cmd('highlight IncSearch  ctermfg=Black ctermbg=DarkYellow')
vim.cmd('highlight treeDir    ctermfg=Cyan')
vim.cmd('highlight netrwDir   ctermfg=Cyan')
-- vim.cmd('highlight ColorColumn ctermbg=Yellow')


-- Load all plugins.
-- Documentation: https://lazy.folke.io/spec
require('config.lazy')
-- When we get an error on save like:
--   [LSP] Format request failed, no matching language servers.
--   method textDocument/codeAction is not supported by any of the servers registered for the current buffer
-- We need to check https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md and configure the language server.
local lspconfig = require('lspconfig')
lspconfig.gopls.setup({
	on_attach = function(client, bufnr)
		if vim.bo[bufnr].filetype == 'gomod' then
			-- As of 2025-03, it's unusable.
			client.stop()
		end
	end,
	settings = {
		gopls = {
			analyses = { unusedparams = true, },
			staticcheck = true,
			gofumpt = true,
		},
	},
})
-- lspconfig.grammarly.setup({})
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT', },
			workspace = { library = vim.api.nvim_get_runtime_file('', true), },
		},
	},
})
lspconfig.marksman.setup({})
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


-- Function to check if there are any LSP clients that can format
local function has_formatter(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr or 0 })) do
		if client.server_capabilities.documentFormattingProvider then
			return true
		end
	end
	return false
end


-- Key bindings.
-- https://neovim.io/doc/user/lua.html#_lua-module:-vim.keymap
-- https://neovim.io/doc/user/intro.html#keycodes
-- F-keys
vim.keymap.set({ 'i', 'n', 'v' }, '<F4>', '<Cmd>Gitsigns blame<CR>')
vim.keymap.set({ 'i', 'n', 'v' }, '<F5>', '<Cmd>GoCoverage<CR>') -- TODO: move to Go specific.
vim.keymap.set({ 'i', 'n', 'v' }, '<F7>', '<Cmd>set paste!<CR>')
vim.keymap.set({ 'i', 'n', 'v' }, '<F8>', '<Cmd>set wrap!<CR>')
vim.keymap.set({ 'i', 'n', 'v' }, '<F9>', '<Cmd>bp<CR>')
vim.keymap.set({ 'i', 'n', 'v' }, '<F10>', '<Cmd>bn<CR>')
vim.keymap.set({ 'i', 'n', 'v' }, '<C-h>', '<Cmd>bp<CR>')
vim.keymap.set({ 'i', 'n', 'v' }, '<C-l>', '<Cmd>bn<CR>')
-- Files
vim.keymap.set({ 'n', 'v' }, '<leader>ff', '<Cmd>Telescope find_files<CR>', { desc = 'Telescope find files' })
vim.keymap.set({ 'n', 'v' }, '<leader>fg', '<Cmd>Telescope live_grep<CR>', { desc = 'Telescope live grep' })
vim.keymap.set({ 'n', 'v' }, '<leader>fb', '<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>')
-- AI
vim.keymap.set('i', '<C-J>', "copilot#Accept('\\<CR>')", {
	expr = true,
	replace_keycodes = false
})
-- ga = accept change
-- gr = reject change
vim.keymap.set({ 'n', 'v' }, '<leader>s', '<Cmd>CodeCompanionActions<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>a', '<Cmd>CodeCompanionChat Toggle<CR>')
vim.keymap.set('v', 'ga', '<Cmd>CodeCompanionChat Add<CR>')
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
-- Enable features that only work if there is a language server active in the file.
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		-- Auto format on save.
		vim.api.nvim_create_autocmd('BufWritePre', {
			callback = function()
				if has_formatter(0) then
					-- TODO: Generalize.
					if vim.bo.filetype == 'go' then
						require('go.format').goimports()
					else
						vim.lsp.buf.format({ async = false })
					end
					-- if vim.lsp.buf.code_action then
					-- 	vim.lsp.buf.code_action { context = { diagnostics = {}, only = { 'source.organizeImports' } }, apply = true, triggerKind = 2 }
					-- 	vim.lsp.buf.code_action { context = { diagnostics = {}, only = { 'source.fixAll' } }, apply = true, triggerKind = 2 }
					-- end
				end
			end,
		})
	end,
})


-- Go specific.
-- TODO: move to ftplugin/go.lua
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
	pattern = { '*.go' },
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
	end
})


-- Save cursor position
vim.api.nvim_create_augroup('RestoreCursorPosition', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
	group = 'RestoreCursorPosition',
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line('$') then
			vim.cmd('normal! g`"')
		end
	end
})


-- Disable the annoying left shift. But it makes copying annoying.
-- :set scl=no
-- :set scl=yes
-- :set scl=auto
vim.opt.signcolumn = 'yes'
vim.api.nvim_create_autocmd('InsertEnter', {
	callback = function()
		if vim.o.paste then
			vim.opt.signcolumn = 'no'
		end
	end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
	callback = function()
		if vim.o.paste then
			vim.opt.signcolumn = 'yes'
		end
	end,
})

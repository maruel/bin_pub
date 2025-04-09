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
vim.o.foldenable = true
vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 99
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
-- Documentation: https://lazy.folke.io/spec
require("config.lazy")
-- When we get an error on save like:
--   [LSP] Format request failed, no matching language servers.
--   method textDocument/codeAction is not supported by any of the servers registered for the current buffer
-- We need to check https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md and configure the language server.
local lspconfig = require('lspconfig')
lspconfig.gopls.setup({
	on_attach = function(client, bufnr)
		if vim.bo[bufnr].filetype == "gomod" then
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
			workspace = { library = vim.api.nvim_get_runtime_file("", true), },
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


-- TODO:
-- Decide between telescope, nvim-tree and oil. I don't need all 3.


local gitsigns = require('gitsigns')
local telescope_builtin = require('telescope.builtin')


-- Key bindings.
-- https://neovim.io/doc/user/lua.html#_lua-module:-vim.keymap
-- https://neovim.io/doc/user/intro.html#keycodes
-- F-keys
vim.keymap.set({ 'n', 'v' }, '<F3>', '<Cmd>NvimTreeFindFileToggle<CR>')
vim.keymap.set('i', '<F3>', '<Cmd>NvimTreeFindFileToggle<CR>')
vim.keymap.set({ 'n', 'v', 'i' }, '<F4>', gitsigns.blame)
vim.keymap.set({ 'n', 'v' }, '<F5>', '<Cmd>GoCoverage<CR>')
vim.keymap.set('i', '<F5>', '<Cmd>GoCoverage<CR>')
vim.keymap.set({ 'n', 'v' }, '<F9>', '<Cmd>bp<CR>')
vim.keymap.set('i', '<F9>', '<Cmd>bp<CR>')
vim.keymap.set({ 'n', 'v' }, '<F10>', '<Cmd>bn<CR>')
vim.keymap.set('i', '<F10>', '<Cmd>bn<CR>')
-- Others
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>e', '<Cmd>Oil --float<CR>')
-- if copilot:
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false
})
--
-- ga = accept change
-- gr = reject change
vim.keymap.set({ "n", "v" }, "<leader>s", "<Cmd>CodeCompanionActions<CR>")
vim.keymap.set({ "n", "v" }, "<leader>a", "<Cmd>CodeCompanionChat Toggle<CR>")
vim.keymap.set("v", "ga", "<Cmd>CodeCompanionChat Add<CR>")
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])


-- Go specific.
-- local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.go",
-- 	callback = function()
-- 		require('go.format').goimports()
-- 	end,
-- 	group = format_sync_grp,
-- })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.go" },
	callback = function()
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


-- Function to check if there are any LSP clients that can format
local function has_formatter(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr or 0 })) do
		if client.server_capabilities.documentFormattingProvider then
			return true
		end
	end
	return false
end


-- This is where you enable features that only work
-- if there is a language server active in the file.
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf, noremap = true, silent = true }
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		-- vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		-- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		-- vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		-- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		-- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
		-- vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		-- vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
		-- vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		-- Auto format on save.
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				if has_formatter(0) then
					vim.lsp.buf.format({ async = false })
					-- if vim.lsp.buf.code_action then
					-- 	vim.lsp.buf.code_action { context = { diagnostics = {}, only = { 'source.organizeImports' } }, apply = true, triggerKind = 2 }
					-- 	vim.lsp.buf.code_action { context = { diagnostics = {}, only = { 'source.fixAll' } }, apply = true, triggerKind = 2 }
					-- end
				end
			end,
		})
	end,
})


-- Disable the annoying left shift. But it makes copying annoying.
-- :set scl=no
-- :set scl=yes
-- :set scl=auto
vim.opt.signcolumn = 'yes'
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		if vim.o.paste then
			vim.opt.signcolumn = "no"
		end
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		if vim.o.paste then
			vim.opt.signcolumn = "yes"
		end
	end,
})

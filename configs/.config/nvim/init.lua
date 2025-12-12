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
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.mouse = ''
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
-- Make 'gw' wrap at 110 columns.
vim.opt.textwidth = 110
--  Use a subtle highlight at 80 columns.
-- PROBLEM: breaks copying with the termina.
-- PROBLEM: ColorColumn is ignored.
-- vim.opt.colorcolumn = '80'
-- vim.opt.undofile = true -- Testing if it makes autoread fail
vim.opt.undolevels = 1000
vim.opt.foldenable = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.autoread = true
-- modeline is cool
vim.opt.modeline = true
vim.opt.modelineexpr = true

-- Debugging function when diagnosing why the hell things are not working.
-- To debug live, run commands like:
--   :lua print(string.format("%s", vim.inspect(vim.lsp.get_client_by_id(1).server_capabilities)))
-- vs
--   :lua print(string.format("%s", vim.inspect(vim.lsp.get_client_by_id(1).capabilities)))
local function goddam(fmt, ...)
	-- Use `:messages` to see the logs.
	if false then
		print(string.format(fmt, ...))
	end
	if false then
		local filepath = vim.fn.stdpath('log') .. '/goddam.log'
		local f = io.open(filepath, 'a')
		if f then
			f:write(string.format(fmt, ...) .. "\n") -- Write the formatted string and a newline
			f:close()
		else
			print("Error opening file: " .. filepath)
		end
	end
end


-- Load all plugins.
-- Documentation: https://lazy.folke.io/spec
require('config.lazy')
-- TODO: Make this automatic.
require("plugins.custom.spinner"):init()
-- Colors in lua/maruelcolor.lua
require('maruelcolor').colorscheme()


-- LSP
vim.lsp.config('gopls', {
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
vim.lsp.config('html', {
	filetypes = { "html", "gohtml" },
	settings = {
		html = {
			format = {
				templating = true,
				wrapLineLength = 120,
				wrapAttributes = 'auto',
				unformatted = '',
				contentUnformatted = '',
				indentInnerHtml = true,
				preserveNewLines = true,
				maxPreserveNewLines = 2,
			},
			hover = {
				documentation = true,
				references = true,
			},
		},
	},
})
vim.lsp.config('cssls', {
	filetypes = { "css", "scss", "less" },
	settings = {
		css = {
			format = {
				enable = true,
				wrapLineLength = 120,
				indentSize = 2,
			},
		},
		scss = {
			format = {
				enable = true,
				wrapLineLength = 120,
				indentSize = 2,
			},
		},
		less = {
			format = {
				enable = true,
				wrapLineLength = 120,
				indentSize = 2,
			},
		},
	},
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT', },
			workspace = { library = vim.api.nvim_get_runtime_file('', true), },
			diagnostics = { globals = { 'vim', }, },
			telemetry = { enable = false, },
		},
	},
})

vim.lsp.config('ts_ls', {
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	settings = {
		typescript = {
			format = {
				enable = true,
				indentSize = 2,
				tabSize = 2,
				convertTabsToSpaces = true,
				semicolons = 'ignore',
				insertSpaceBeforeAndAfterBinaryOperators = true,
				insertSpaceAfterKeywordsInControlFlowStatements = true,
				insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
				insertSpaceBeforeFunctionParenthesis = false,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
				insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
				insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
				insertSpaceAfterTypeAssertion = false,
				placeOpenBraceOnNewLineForFunctions = false,
				placeOpenBraceOnNewLineForControlBlocks = false,
			},
		},
		javascript = {
			format = {
				enable = true,
				indentSize = 2,
				tabSize = 2,
				convertTabsToSpaces = true,
				semicolons = 'ignore',
				insertSpaceBeforeAndAfterBinaryOperators = true,
				insertSpaceAfterKeywordsInControlFlowStatements = true,
				insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
				insertSpaceBeforeFunctionParenthesis = false,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
				insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
				insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
				insertSpaceAfterTypeAssertion = false,
				placeOpenBraceOnNewLineForFunctions = false,
				placeOpenBraceOnNewLineForControlBlocks = false,
			},
		},
	},
})


-- Delete the current file.
local function confirm_and_delete_buffer()
	if vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2) == 1 then
		os.remove(vim.fn.expand "%")
		vim.api.nvim_buf_delete(0, { force = true })
	end
end

-- Disable the annoying left shift. But it makes copying annoying.
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
			vim.opt.signcolumn = 'auto'
		end
	end,
})
-- Disable sign column in diff mode.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "diff" },
	callback = function()
		vim.opt_local.signcolumn = "no"
	end,
})
local function toggle_signcolumn()
	if vim.opt.signcolumn:get() == 'no' then
		vim.opt.signcolumn = 'yes'
	else
		vim.opt.signcolumn = 'no'
	end
end


-- Key bindings.
-- Difficult to use:
-- - Shift, Ctrl or Alt F-keys
-- - Ctrl-numbers
-- https://neovim.io/doc/user/lua.html#_lua-module:-vim.keymap
-- https://neovim.io/doc/user/intro.html#keycodes
-- F-keys
vim.keymap.set({ 'i', 'n', 'v' }, '<F3>', toggle_signcolumn)
vim.keymap.set({ 'i', 'n', 'v' }, '<F4>', '<Cmd>Gitsigns blame<CR>')
--vim.keymap.set({ 'i', 'n', 'v' }, '<C-4>', '<Cmd>Gitsigns toggle_current_line_blame<CR>')
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
vim.keymap.set('n', '<leader>df', confirm_and_delete_buffer)
-- ga = accept change
-- gr = reject change
vim.keymap.set({ 'n', 'v' }, '<leader>s', '<Cmd>CodeCompanionActions<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>a', '<Cmd>CodeCompanionChat Toggle<CR>')
vim.keymap.set('v', 'ga', '<Cmd>CodeCompanionChat Add<CR>')
vim.keymap.set({ 'i', 'n', 'v' }, '<C-f>', '<Cmd>Namu symbols<CR>', { desc = 'Jump to LSP symbol' })
vim.keymap.set({ 'n', 'v' }, 'U', '<Cmd>redo<CR>')
-- Quickfix; https://neovim.io/doc/user/quickfix.html
vim.keymap.set({ 'n' }, '<leader>n', '<Cmd>cnext<CR>')
vim.keymap.set({ 'n' }, '<leader>p', '<Cmd>cprevious<CR>')


-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])


-- Auto format on save.
vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup("maruel.lsp.bufwritepre.fixing", { clear = true }),
	callback = function(args)
		-- This is not super efficient to query on each save but LSPs can be loaded late, and many LSPs can
		--  be attached to a single buffer and their functionality can be loaded dynamically. We want only one
		--  formatting BufWritePre so it's better to just lazy query every time.
		goddam("BufWritePre: %s", vim.inspect(args))
		local foundOrganize = false
		local foundFormat = false
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			-- Check for: 'source.OrganizeImports' inside 'textDocument/codeAction'
			if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction)
				and client.capabilities
				and client.capabilities.textDocument
				and client.capabilities.textDocument.codeAction
				and client.capabilities.textDocument.codeAction.codeActionLiteralSupport
				and client.capabilities.textDocument.codeAction.codeActionLiteralSupport.codeActionKind
				and client.capabilities.textDocument.codeAction.codeActionLiteralSupport.codeActionKind.valueSet
				and vim.tbl_contains(
					client.capabilities.textDocument.codeAction.codeActionLiteralSupport.codeActionKind.valueSet,
					vim.lsp.protocol.CodeActionKind.SourceOrganizeImports) then
				goddam("BufWritePre: %s: sourceOrganize", client.name)
				foundOrganize = true
			end
			-- 'textDocument/formatting'
			if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
				goddam("BufWritePre: %s: format", client.name)
				foundFormat = true
			end
		end
		-- While slower, I realized it's better to format first then organize. The reason is that many LSP lie
		-- that they can organize but do nothing. So better to be sure that the code is formatted.
		if foundFormat then
			vim.lsp.buf.format({ bufnr = args.buf })
		end
		if foundOrganize then
			vim.lsp.buf.code_action(
				{
					bufnr = args.buf,
					context = {
						diagnostics = {},
						only = { vim.lsp.protocol.CodeActionKind.SourceOrganizeImports },
						triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
					},
					apply = true,
				})
		end
	end,
})


vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('maruel.lsp.attach', { clear = true }),
	callback = function(args)
		-- Alternative to `<C-]>`
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
	end,
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

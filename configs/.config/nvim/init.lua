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


-- Load all plugins.
require("config.lazy")
require('avante').setup()
local lspconfig = require('lspconfig')
lspconfig.gopls.setup({})
lspconfig.sourcekit.setup({
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
})


-- References to plugins to setup key bindings.
local gitsigns = require('gitsigns')

-- Key bindings.
-- F-keys
vim.keymap.set({'n', 'v'}, '<F3>', ':NvimTreeFindFileToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('i', '<F3>', '<Esc>:NvimTreeFindFileToggle<CR>', {noremap = true, silent = true})
vim.keymap.set({'n', 'v', 'i'}, '<F4>', gitsigns.blame, {noremap = true, silent = true})
vim.keymap.set({'n', 'v'}, '<F5>', ':GoCoverage<CR>', {noremap = true, silent = true})
vim.keymap.set('i', '<F5>', '<Esc>:GoCoverage<CR>', {noremap = true, silent = true})
vim.keymap.set({'n', 'v'}, '<F9>', ':bp<CR>', {noremap = true, silent = true})
vim.keymap.set('i', '<F9>', '<Esc>:bp<CR>', {noremap = true, silent = true})
vim.keymap.set({'n', 'v'}, '<F10>', ':bn<CR>', {noremap = true, silent = true})
vim.keymap.set('i', '<F10>', '<Esc>:bn<CR>', {noremap = true, silent = true})
-- Others
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {noremap = true, silent = true})


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

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.go"},
  callback = function(ev)
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
  end
})

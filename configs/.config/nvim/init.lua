-- Ref: https://neovim.io/doc/user/lua-guide.html
-- TODO: Take a look at https://dotfyle.com/neovim/plugins/top
--
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- Load all plugins.
require("config.lazy")
require('avante').setup()
require('lspconfig').gopls.setup({})


-- References to plugins to setup key bindings.
local gitsigns = require('gitsigns')

-- Key bindings.
vim.api.nvim_set_keymap('n', '<F3>', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<F4>', gitsigns.blame, {})
vim.api.nvim_set_keymap('n', '<F5>', ':GoCoverage<CR>', { noremap = true, silent = true })
-- gd = GoToDef


-- Auto format on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    vim.lsp.buf.format()
    vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
    vim.lsp.buf.code_action { context = { only = { 'source.fixAll' } }, apply = true }
  end,
})


local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimports()
  end,
  group = format_sync_grp,
})

-- Ref: https://neovim.io/doc/user/lua-guide.html
--
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load all plugins.
require("config.lazy")


local gitsigns = require('gitsigns')
local goformat = require('go.format')

-- TODO: Take a look at https://dotfyle.com/neovim/plugins/top


-- https://github.com/ray-x/go.nvim#run-gofmt--goimports-on-save
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = goformat.goimports,
  group = format_sync_grp,
})


-- Key bindings.
vim.keymap.set('n', '<F4>', gitsigns.blame, {})
vim.api.nvim_set_keymap('n', '<F5>', ':GoCoverage<CR>', { noremap = true, silent = true })
-- gd = GoToDef


-- TODO:
--  - :GoCoverage leaves a cover.cov file lying around.
--  - Autoformat on save doesn't work.
--
--

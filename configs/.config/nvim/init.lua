-- MARUEL: Warning: Still learning.
require("config.lazy")


-- TODO: Take a look at https://dotfyle.com/neovim/plugins/top

-- https://github.com/ray-x/go.nvim#run-gofmt--goimports-on-save
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimports()
  end,
  group = format_sync_grp,
})

-- TODO:
--  - :GoCoverage leaves a cover.cov file lying around.
--  - Key binding for :GoCoverage
--  - Autoformat on save doesn't work.
--  - GoToDef working and key binding.

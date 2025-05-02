-- My colors
local M = {}

function M.colorscheme()
	-- vim.cmd [[syntax on]]
	vim.opt.termguicolors = true

	local hl = vim.api.nvim_set_hl
	hl(0, "Normal", { bg = "#000000", fg = "#ffffff" })
	-- vim.cmd('highlight Normal ctermbg=black')
	-- vim.cmd('highlight SpecialKey ctermfg=Red')
	-- -- Syntax highlighting for the primary groups. These only take effect when
	-- -- 'syntax on' is used.
	-- -- (see :help group-name):
	-- vim.cmd('highlight Comment    ctermfg=LightBlue')
	-- vim.cmd('highlight Constant   ctermfg=White')
	-- vim.cmd('highlight String     ctermfg=DarkGreen')
	-- vim.cmd('highlight Identifier ctermfg=White')
	-- -- Keep statements highlighted: highlight Statement  ctermfg=White
	-- vim.cmd('highlight PreProc    ctermfg=White')
	-- vim.cmd('highlight Type       ctermfg=White')
	-- vim.cmd('highlight Special    ctermfg=DarkGreen')
	-- -- Highlight changes outside of groups. They take effect even when 'syntax off'
	-- -- is used.
	-- vim.cmd('highlight Search     ctermfg=Black ctermbg=DarkYellow')
	-- vim.cmd('highlight IncSearch  ctermfg=Black ctermbg=DarkYellow')
	-- vim.cmd('highlight treeDir    ctermfg=Cyan')
	-- vim.cmd('highlight netrwDir   ctermfg=Cyan')
	-- -- vim.cmd('highlight ColorColumn ctermbg=Yellow')
end

return M

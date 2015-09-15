" Sources:
" http://stackoverflow.com/questions/2019281/load-different-colorscheme-when-using-vimdiff
" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim?file=Xterm-color-table.png
" Add: No highlight. The reason is to reduce the noise, as the other side (which
" is deleted by definition) is red to signal that it's new lines.
" Delete: Red on Red (to hide the dash) The reason is that it makes it possible
" to make new lines to be not highlighted at all, to make the new code more
" readable.
" Change: No highlight, only the subtext is highlighted.
" DiffText: Blue to hightlight the differences. I'd prefer green but green is
" used for strings, which makes it green on green.
highlight DiffAdd    NONE
highlight DiffDelete ctermfg=52 ctermbg=52
highlight DiffChange NONE
highlight DiffText   ctermbg=17
